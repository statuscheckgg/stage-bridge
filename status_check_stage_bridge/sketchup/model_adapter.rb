require 'json'
require 'digest/sha2'

module StatusCheckGG
  module StageBridge
    module SketchupIntegration
      module ModelAdapter
        TEMPLATE_PERSON_NAMES = ['sang', 'sophie', 'susan', 'steve', 'chris', 'bonnie']

        def self.import_file(path, model)
          document = Core::StageDocument.load(path)
          diagnostics = Core::Validator.validate_root(document.root)
          if Core::Validator.blocking?(diagnostics)
            UI.messagebox(format_diagnostics('Stage import failed', diagnostics))
            return false
          end

          existing = stage_root(model)
          unless existing.nil?
            answer = UI.messagebox('This model already contains a Stage Bridge stage. Replace only that tagged stage?', MB_YESNO)
            return false unless answer == IDYES
          end

          model.start_operation('Import Practisim Stage', true)
          begin
            existing.erase! unless existing.nil? || existing.deleted?
            remove_template_people(model)
            root = model.entities.add_group
            root.name = "Stage Bridge - #{document.stage_name}"
            root.set_attribute(ENTITY_DICTIONARY, ROLE_KEY, ROLE_STAGE_ROOT)
            root.set_attribute(ENTITY_DICTIONARY, 'bridge_schema_version', BRIDGE_SCHEMA_VERSION)
            root.locked = false

            write_document_attributes(model, document)
            root.set_attribute(ENTITY_DICTIONARY, 'stage_name', document.stage_name)
            Geometry.build_stage_reference(root.entities, document.root, model)

            document.props.each_with_index do |prop, index|
              add_prop_instance(model, root, prop, index, document.anchor, false)
            end

            model.commit_operation
            model.active_view.zoom(root)
            PathPreferences.remember_path(path)
            true
          rescue Exception
            model.abort_operation
            raise
          end
        end

        def self.remove_template_people(model)
          model.entities.to_a.each do |entity|
            next unless entity.is_a?(Sketchup::ComponentInstance)
            values = [entity.name, entity.definition.name, entity.definition.description]
            normalized = values.map { |value| value.to_s.strip.downcase }
            next unless normalized.any? { |value| TEMPLATE_PERSON_NAMES.include?(value) }
            entity.erase!
          end
        end

        def self.add_catalog_prop(model, entry)
          root = stage_root(model)
          if root.nil?
            UI.messagebox('Import an existing Practisim STG stage before adding props.')
            return false
          end

          unique_id = next_unique_id(root)
          if unique_id.nil?
            UI.messagebox('New props require an existing stage with numeric uniqueID values.')
            return false
          end

          source_root = source_root_for(model)
          anchor = anchor_for(model)
          raw_prop = Core::Catalog.new_prop(entry, unique_id)
          raw_prop['propTransform']['Translation']['X'] = anchor['x']
          raw_prop['propTransform']['Translation']['Y'] = anchor['y']

          model.start_operation('Add Practisim Prop', true)
          begin
            instance = add_prop_instance(model, root, raw_prop, -1, anchor, true)
            model.commit_operation
            model.selection.clear
            model.selection.add(instance)
            true
          rescue Exception
            model.abort_operation
            raise
          end
        end

        def self.edit_metadata(model)
          root = stage_root(model)
          if root.nil?
            UI.messagebox('No Stage Bridge stage is loaded.')
            return false
          end
          source_root = source_root_for(model)
          prompts = ['Stage name', 'Author', 'Course type', 'Scoring type', 'Hits per paper', 'Rounds', 'Possible points']
          defaults = [
            source_root['stageName'].to_s,
            source_root['stageAuthor'].to_s,
            source_root['courseType'].to_s,
            source_root['scoringType'].to_s,
            integer_value(source_root['numPerPaper'], 2),
            integer_value(source_root['numRounds'], 0),
            integer_value(source_root['numPoints'], 0)
          ]
          values = UI.inputbox(prompts, defaults, 'Stage Bridge Metadata')
          return false if values == false

          model.start_operation('Update Stage Metadata', true)
          begin
            source_root['stageName'] = values[0].to_s
            source_root['stageAuthor'] = values[1].to_s
            source_root['courseType'] = values[2].to_s
            source_root['scoringType'] = values[3].to_s
            source_root['numPerPaper'] = integer_value(values[4], 2)
            source_root['numRounds'] = integer_value(values[5], 0)
            source_root['numPoints'] = integer_value(values[6], 0)
            text = Core::Writer.pretty_json(source_root)
            model.set_attribute(MODEL_DICTIONARY, 'source_json', text)
            model.set_attribute(MODEL_DICTIONARY, 'source_hash', Digest::SHA256.hexdigest(text))
            root.name = "Stage Bridge - #{source_root['stageName']}"
            root.set_attribute(ENTITY_DICTIONARY, 'stage_name', source_root['stageName'].to_s)
            model.commit_operation
            true
          rescue Exception
            model.abort_operation
            raise
          end
        end

        def self.validate_model(model)
          root_hash, diagnostics, _instances = build_export_root(model, false)
          diagnostics.concat(Core::Validator.validate_root(root_hash)) unless root_hash.nil?
          title = Core::Validator.blocking?(diagnostics) ? 'Stage validation failed' : 'Stage validation passed'
          UI.messagebox(format_diagnostics(title, diagnostics))
          !Core::Validator.blocking?(diagnostics)
        end

        def self.export_model(model)
          root = stage_root(model)
          if root.nil?
            UI.messagebox('No Stage Bridge stage is loaded.')
            return false
          end

          model.start_operation('Prepare Practisim Export', true)
          begin
            assign_duplicate_ids(root)
            export_root, diagnostics, instances = build_export_root(model, true)
            diagnostics.concat(Core::Validator.validate_root(export_root)) unless export_root.nil?
            if Core::Validator.blocking?(diagnostics)
              model.abort_operation
              UI.messagebox(format_diagnostics('Stage export blocked', diagnostics))
              return false
            end

            source_root = source_root_for(model)
            unless apply_scoring_review(source_root, export_root)
              model.abort_operation
              return false
            end

            model.commit_operation
          rescue Exception
            model.abort_operation
            raise
          end

          source_path = model.get_attribute(MODEL_DICTIONARY, 'source_path', '')
          source_folder = File.directory?(File.dirname(source_path.to_s)) ? File.dirname(source_path.to_s) : nil
          folder = PathPreferences.last_stage_folder(source_folder)
          base_name = File.basename(source_path.to_s, File.extname(source_path.to_s))
          base_name = 'stage' if base_name.empty?
          output_path = UI.savepanel('Export Practisim Stage', folder, "#{base_name}-SketchUp.STG")
          return false if output_path.nil?
          output_path += '.STG' if File.extname(output_path).empty?

          overwrite = File.exist?(output_path)
          if overwrite
            answer = UI.messagebox("The selected file exists. Create a timestamped backup and overwrite it?\n\n#{output_path}", MB_YESNO)
            return false unless answer == IDYES
          end

          encoding_name = model.get_attribute(MODEL_DICTIONARY, 'source_encoding', Core::EncodingHelper::UTF8)
          result = Core::Writer.write(output_path, export_root, encoding_name, :overwrite => overwrite)
          rebase_after_export(model, export_root, instances, result, encoding_name)
          PathPreferences.remember_path(output_path)

          message = "Exported #{export_root['propList'].length} props to:\n#{output_path}"
          message += "\n\nBackup:\n#{result[:backup_path]}" unless result[:backup_path].nil?
          warnings = diagnostics.select { |diagnostic| diagnostic['severity'] == 'warning' }
          message += "\n\nWarnings: #{warnings.length}" unless warnings.empty?
          UI.messagebox(message)
          true
        end

        def self.build_export_root(model, update_id_attributes)
          diagnostics = []
          root = stage_root(model)
          if root.nil?
            diagnostics << Core::Validator.error('missing_stage_root', 'No tagged Stage Bridge root group exists.')
            return [nil, diagnostics, []]
          end

          source_root = source_root_for(model)
          export_root = JSON.parse(JSON.generate(source_root))
          anchor = anchor_for(model)
          profile = model.get_attribute(MODEL_DICTIONARY, 'transform_profile', '').to_s
          if profile != TRANSFORM_PROFILE
            diagnostics << Core::Validator.error(
              'outdated_transform_profile',
              'This model was imported with an older visual transform profile. Re-import the original STG with the current Stage Bridge before exporting.'
            )
          end
          instances = prop_instances(root)
          exported = []

          untagged = root.entities.to_a.count do |entity|
            entity.get_attribute(ENTITY_DICTIONARY, ROLE_KEY, nil).nil?
          end
          if untagged > 0
            diagnostics << Core::Validator.warning('untagged_geometry_ignored', "#{untagged} untagged root entities will not be exported.")
          end

          identities = {}
          instances.each do |instance|
            identity = [
              instance.get_attribute(ENTITY_DICTIONARY, 'source_index', -1).to_i,
              instance.get_attribute(ENTITY_DICTIONARY, 'unique_id_json', 'null').to_s
            ]
            if identities.key?(identity) && identity[0] >= 0
              severity = update_id_attributes ? 'warning' : 'warning'
              diagnostics << {
                'severity' => severity,
                'code' => 'duplicate_instance_identity',
                'message' => 'A copied component shares its source identity; export will assign a new numeric uniqueID.'
              }
            else
              identities[identity] = true
            end

            prop, prop_diagnostics = prop_from_instance(instance, anchor)
            diagnostics.concat(prop_diagnostics)
            next if prop.nil?
            exported << {
              :instance => instance,
              :prop => prop,
              :source_index => instance.get_attribute(ENTITY_DICTIONARY, 'source_index', -1).to_i,
              :sort_id => entity_sort_id(instance)
            }
          end

          exported.sort_by! do |item|
            index = item[:source_index]
            index >= 0 ? [0, index, item[:sort_id]] : [1, item[:sort_id], item[:sort_id]]
          end
          export_root['propList'] = exported.map { |item| item[:prop] }
          [export_root, diagnostics, exported]
        end

        def self.prop_from_instance(instance, anchor)
          diagnostics = []
          transform_data, transform_diagnostics = extract_transform(instance, anchor)
          diagnostics.concat(transform_diagnostics)
          return [nil, diagnostics] if Core::Validator.blocking?(diagnostics)

          raw_json = instance.get_attribute(ENTITY_DICTIONARY, 'original_prop_json', '{}').to_s
          begin
            prop = JSON.parse(raw_json)
          rescue JSON::ParserError
            prop = {}
            diagnostics << Core::Validator.warning('missing_original_prop', "Component #{instance.name} lost its original prop JSON; a minimal prop will be emitted.")
          end

          prop_name = instance.get_attribute(ENTITY_DICTIONARY, 'prop_name', prop['propName'].to_s).to_s
          unique_id_json = instance.get_attribute(ENTITY_DICTIONARY, 'unique_id_json', encode_unique_id(prop['uniqueID'])).to_s
          begin
            unique_id = decode_unique_id(unique_id_json)
          rescue JSON::ParserError
            unique_id = unique_id_json
          end
          prop['propName'] = prop_name
          prop['uniqueID'] = unique_id
          merge_transform_data(prop, transform_data)
          [prop, diagnostics]
        end

        def self.merge_transform_data(prop, transform_data)
          target = prop['propTransform']
          target = {} unless target.is_a?(Hash)
          transform_data.each do |section_name, values|
            section_key = target.keys.find { |key| key.to_s.downcase == section_name.downcase }
            section_key ||= section_name
            section = target[section_key]
            section = {} unless section.is_a?(Hash)
            values.each do |axis_name, value|
              axis_key = section.keys.find { |key| key.to_s.downcase == axis_name.downcase }
              axis_key ||= axis_name
              section[axis_key] = value
            end
            target[section_key] = section
          end
          prop['propTransform'] = target
        end

        def self.extract_transform(instance, anchor)
          diagnostics = []
          transform = instance.transformation
          x_axis = transform.xaxis
          y_axis = transform.yaxis
          z_axis = transform.zaxis
          x_length = x_axis.length
          y_length = y_axis.length
          z_length = z_axis.length
          name = instance.name.to_s.empty? ? 'unnamed prop' : instance.name.to_s

          if x_length <= 0.000001 || y_length <= 0.000001 || z_length <= 0.000001
            diagnostics << Core::Validator.error('non_invertible_transform', "#{name} has a zero scale axis.")
            return [nil, diagnostics]
          end

          xy = x_axis.dot(y_axis).abs / (x_length * y_length)
          xz = x_axis.dot(z_axis).abs / (x_length * z_length)
          yz = y_axis.dot(z_axis).abs / (y_length * z_length)
          if [xy, xz, yz].max > 0.0001
            diagnostics << Core::Validator.error('sheared_transform', "#{name} has a sheared transform that Practisim cannot reproduce safely.")
          end

          determinant = x_axis.cross(y_axis).dot(z_axis)
          diagnostics << Core::Validator.error('mirrored_transform', "#{name} is mirrored.") if determinant <= 0.0

          vertical = z_axis.z / z_length
          if vertical.abs < 0.9999 || x_axis.z.abs > 0.0001 || y_axis.z.abs > 0.0001
            diagnostics << Core::Validator.error('non_planar_rotation', "#{name} is pitched or rolled; v1 supports vertical yaw only.")
          end
          return [nil, diagnostics] if Core::Validator.blocking?(diagnostics)

          origin = transform.origin
          display_z_offset = instance.get_attribute(ENTITY_DICTIONARY, 'display_z_offset', 0.0).to_f
          yaw = Math.atan2(x_axis.y, x_axis.x)
          source = Core::Transform.local_to_source(
            { 'x' => origin.x.to_f, 'y' => origin.y.to_f, 'z' => origin.z.to_f - display_z_offset },
            yaw,
            { 'x' => x_length, 'y' => y_length, 'z' => z_length },
            anchor
          )
          [source, diagnostics]
        end

        def self.assign_duplicate_ids(root)
          instances = prop_instances(root).sort_by { |instance| entity_sort_id(instance) }
          next_id = next_unique_id(root)
          return if next_id.nil?
          seen = {}
          instances.each do |instance|
            source_index = instance.get_attribute(ENTITY_DICTIONARY, 'source_index', -1).to_i
            id_json = instance.get_attribute(ENTITY_DICTIONARY, 'unique_id_json', 'null').to_s
            identity = [source_index, id_json]
            if source_index >= 0 && seen.key?(identity)
              instance.set_attribute(ENTITY_DICTIONARY, 'source_index', -1)
              instance.set_attribute(ENTITY_DICTIONARY, 'unique_id_json', encode_unique_id(next_id))
              instance.set_attribute(ENTITY_DICTIONARY, 'is_new', true)
              raw = JSON.parse(instance.get_attribute(ENTITY_DICTIONARY, 'original_prop_json', '{}').to_s)
              raw['uniqueID'] = next_id
              instance.set_attribute(ENTITY_DICTIONARY, 'original_prop_json', JSON.generate(raw))
              next_id += 1
            else
              seen[identity] = true
            end
          end
        end

        def self.apply_scoring_review(source_root, export_root)
          original_signature = scorable_signature(source_root['propList'])
          export_signature = scorable_signature(export_root['propList'])
          return true if original_signature == export_signature

          counts = Core::Catalog.scoring_counts(export_root['propList'])
          hits_per_paper = integer_value(export_root['numPerPaper'], 2)
          rounds = (counts['paper'] * hits_per_paper) + counts['steel']
          points = rounds * 5
          prompts = ['Paper targets', 'Steel targets', 'No-shoots', 'Rounds', 'Possible points']
          defaults = [counts['paper'], counts['steel'], counts['no_shoot'], rounds, points]
          values = UI.inputbox(prompts, defaults, 'Review Scoring After Prop Changes')
          return false if values == false

          export_root['numPaper'] = integer_value(values[0], counts['paper'])
          export_root['numSteel'] = integer_value(values[1], counts['steel'])
          export_root['numNoshoots'] = integer_value(values[2], counts['no_shoot'])
          export_root['numRounds'] = integer_value(values[3], rounds)
          export_root['numPoints'] = integer_value(values[4], points)
          true
        end

        def self.scorable_signature(props)
          return [] unless props.is_a?(Array)
          props.map do |prop|
            next nil unless prop.is_a?(Hash)
            entry = Core::Catalog.for_prop_name(prop['propName'])
            next nil if entry.nil? || (entry[:paper] + entry[:steel] + entry[:no_shoot]) == 0
            "#{prop['uniqueID']}:#{entry[:key]}"
          end.compact.sort
        end

        def self.rebase_after_export(model, export_root, instances, result, encoding_name)
          model.start_operation('Rebase Stage Bridge Source', true)
          begin
            text = Core::Writer.pretty_json(export_root)
            model.set_attribute(MODEL_DICTIONARY, 'source_json', text)
            model.set_attribute(MODEL_DICTIONARY, 'source_hash', Digest::SHA256.hexdigest(result[:bytes]))
            model.set_attribute(MODEL_DICTIONARY, 'source_path', result[:path])
            model.set_attribute(MODEL_DICTIONARY, 'source_encoding', encoding_name)
            by_id = {}
            export_root['propList'].each_with_index { |prop, index| by_id[prop['uniqueID'].to_s] = [prop, index] }
            instances.each do |item|
              instance = item[:instance]
              unique_id = item[:prop]['uniqueID'].to_s
              pair = by_id[unique_id]
              next if pair.nil?
              instance.set_attribute(ENTITY_DICTIONARY, 'source_index', pair[1])
              instance.set_attribute(ENTITY_DICTIONARY, 'original_prop_json', JSON.generate(pair[0]))
              instance.set_attribute(ENTITY_DICTIONARY, 'is_new', false)
            end
            model.commit_operation
          rescue Exception
            model.abort_operation
            raise
          end
        end

        def self.add_prop_instance(model, root, prop, source_index, anchor, is_new)
          prop_name = prop['propName'].to_s
          entry = Core::Catalog.for_prop_name(prop_name)
          definition = Geometry.definition_for(model, entry, prop_name)
          mapped = Core::Transform.source_to_local(prop, anchor)
          scale = mapped['scale']
          display_z_offset = display_ground_offset(definition, mapped)
          translation = Geom::Transformation.translation([mapped['x'], mapped['y'], mapped['z'] + display_z_offset])
          rotation = Geom::Transformation.rotation(ORIGIN, Z_AXIS, mapped['yaw'])
          scaling = Geom::Transformation.scaling(scale['x'], scale['y'], scale['z'])
          instance = root.entities.add_instance(definition, translation * rotation * scaling)
          instance.name = prop_name
          instance.set_attribute(ENTITY_DICTIONARY, ROLE_KEY, ROLE_PROP)
          instance.set_attribute(ENTITY_DICTIONARY, 'prop_name', prop_name)
          instance.set_attribute(ENTITY_DICTIONARY, 'catalog_key', entry ? entry[:key] : 'unknown')
          instance.set_attribute(ENTITY_DICTIONARY, 'source_index', source_index)
          instance.set_attribute(ENTITY_DICTIONARY, 'unique_id_json', encode_unique_id(prop['uniqueID']))
          instance.set_attribute(ENTITY_DICTIONARY, 'original_prop_json', JSON.generate(prop))
          instance.set_attribute(ENTITY_DICTIONARY, 'is_new', is_new)
          instance.set_attribute(ENTITY_DICTIONARY, 'display_z_offset', display_z_offset)
          apply_custom_appearance(model, instance, prop, entry)
          instance
        end

        def self.apply_custom_appearance(model, instance, prop, entry)
          return if entry.nil? || !entry[:custom_color]
          color = prop['customColor']
          return unless color.is_a?(Hash)
          red = color_component(color, 'R')
          green = color_component(color, 'G')
          blue = color_component(color, 'B')
          alpha = Core::Transform.number_value_with_default(color, 1.0, 'A', 'a')
          alpha = [[alpha, 0.0].max, 1.0].min
          name = "Stage Bridge Custom #{red}-#{green}-#{blue}-#{(alpha * 255.0).round}"
          instance.material = Geometry.material_for(model, name, [red, green, blue], alpha)
        end

        def self.color_component(color, key)
          value = Core::Transform.number_value_with_default(color, 0.0, key, key.downcase)
          ([[value, 0.0].max, 1.0].min * 255.0).round
        end

        def self.display_ground_offset(definition, mapped)
          scale_z = mapped['scale']['z'].to_f
          visual_min_z = mapped['z'].to_f + (definition.bounds.min.z.to_f * scale_z)
          visual_min_z < 0.0 ? -visual_min_z : 0.0
        end

        def self.write_document_attributes(model, document)
          model.set_attribute(MODEL_DICTIONARY, 'bridge_schema_version', BRIDGE_SCHEMA_VERSION)
          model.set_attribute(MODEL_DICTIONARY, 'bridge_version', VERSION)
          model.set_attribute(MODEL_DICTIONARY, 'transform_profile', TRANSFORM_PROFILE)
          model.set_attribute(MODEL_DICTIONARY, 'source_json', document.source_json)
          model.set_attribute(MODEL_DICTIONARY, 'source_hash', document.source_hash)
          model.set_attribute(MODEL_DICTIONARY, 'source_path', document.source_path)
          model.set_attribute(MODEL_DICTIONARY, 'source_encoding', document.encoding_name)
          model.set_attribute(MODEL_DICTIONARY, 'anchor_json', JSON.generate(document.anchor))
        end

        def self.source_root_for(model)
          text = model.get_attribute(MODEL_DICTIONARY, 'source_json', '{}').to_s
          JSON.parse(text)
        rescue JSON::ParserError
          {}
        end

        def self.anchor_for(model)
          text = model.get_attribute(MODEL_DICTIONARY, 'anchor_json', '{"x":0,"y":0,"z":0}').to_s
          JSON.parse(text)
        rescue JSON::ParserError
          { 'x' => 0.0, 'y' => 0.0, 'z' => 0.0 }
        end

        def self.stage_root(model)
          model.entities.grep(Sketchup::Group).find do |group|
            group.get_attribute(ENTITY_DICTIONARY, ROLE_KEY, nil) == ROLE_STAGE_ROOT
          end
        end

        def self.prop_instances(root)
          root.entities.grep(Sketchup::ComponentInstance).select do |instance|
            instance.get_attribute(ENTITY_DICTIONARY, ROLE_KEY, nil) == ROLE_PROP
          end
        end

        def self.next_unique_id(root)
          ids = prop_instances(root).map do |instance|
            begin
              value = decode_unique_id(instance.get_attribute(ENTITY_DICTIONARY, 'unique_id_json', 'null').to_s)
              value.is_a?(Numeric) ? value.to_i : nil
            rescue JSON::ParserError
              nil
            end
          end.compact
          return 1 if ids.empty?
          ids.max + 1
        end

        # SketchUp 2017's bundled JSON 1.x generator rejects scalar roots.
        # Wrapping the value preserves its JSON type while remaining compatible
        # with older models that stored a scalar JSON value directly.
        def self.encode_unique_id(value)
          JSON.generate({ 'value' => value })
        end

        def self.decode_unique_id(text)
          value = JSON.parse(text)
          if value.is_a?(Hash) && value.key?('value')
            value['value']
          else
            value
          end
        end

        def self.entity_sort_id(entity)
          entity.respond_to?(:persistent_id) ? entity.persistent_id : entity.entityID
        end

        def self.integer_value(value, fallback)
          Integer(value)
        rescue ArgumentError, TypeError
          fallback
        end

        def self.format_diagnostics(title, diagnostics)
          return "#{title}.\n\nNo warnings or errors." if diagnostics.empty?
          lines = diagnostics.map do |diagnostic|
            "[#{diagnostic['severity'].to_s.upcase}] #{diagnostic['code']}: #{diagnostic['message']}"
          end
          "#{title}.\n\n#{lines.join("\n")}"
        end
      end
    end
  end
end
