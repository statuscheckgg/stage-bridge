module StatusCheckGG
  module StageBridge
    module SketchupIntegration
      module Geometry
        def self.definition_for(model, entry, prop_name)
          key = entry ? entry[:key] : "unknown_#{sanitize(prop_name)}"
          definition_name = "StageBridge::v#{BRIDGE_SCHEMA_VERSION}::#{key}"
          existing = model.definitions[definition_name]
          return existing unless existing.nil?

          definition = model.definitions.add(definition_name)
          if entry.nil?
            material = material_for(model, 'Stage Bridge Unknown', [220, 40, 190], 0.75)
            add_box(definition.entities, 24.0, 24.0, 36.0, material, 0.0, 0.0, 0.0)
            return definition
          end

          return definition if build_from_asset(definition, model, entry)

          material = material_for(model, "Stage Bridge #{entry[:key]}", entry[:color], 1.0)
          dimensions = entry[:dimensions]
          case entry[:builder]
          when :adjustable_faultline
            build_adjustable_faultline(definition.entities, dimensions)
          when :wall
            build_wall(definition.entities, dimensions, model)
          when :target
            build_target(definition.entities, dimensions, material)
          when :popper
            build_popper(definition.entities, dimensions, material)
          when :cylinder
            build_cylinder(definition.entities, dimensions, material)
          when :table
            build_table(definition.entities, dimensions, material, model)
          when :stacked_target
            build_stacked_target(definition.entities, dimensions, material)
          when :swinger
            build_swinger(definition.entities, dimensions, material, model)
          when :double_x_start
            build_double_x_start(definition.entities, dimensions, material)
          else
            add_box(definition.entities, dimensions[0], dimensions[1], dimensions[2], material, 0.0, 0.0, 0.0)
          end
          definition
        end

        def self.build_adjustable_faultline(entities, dimensions)
          width = dimensions[0]
          # Practisim's adjustable fault-line translation is the starting end
          # of its 0.1-meter base mesh, not the center of the scaled line.
          # Leave faces unpainted so each instance can display customColor.
          add_box(entities, width, dimensions[1], dimensions[2], nil, width / 2.0, 0.0, 0.0)
        end

        def self.build_from_asset(wrapper, model, entry)
          asset_name = entry[:asset]
          return false if asset_name.nil? || asset_name.to_s.empty?
          asset_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'components', asset_name.to_s))
          return false unless File.file?(asset_path)

          source = model.definitions.load(asset_path)
          return false if source.nil?
          box = source.bounds
          center_x = (box.min.x.to_f + box.max.x.to_f) / 2.0
          center_y = (box.min.y.to_f + box.max.y.to_f) / 2.0
          normalize = Geom::Transformation.translation([-center_x, -center_y, -box.min.z.to_f])
          values = entry[:asset_scale] || [1.0, 1.0, 1.0]
          scaling = Geom::Transformation.scaling(values[0].to_f, values[1].to_f, values[2].to_f)
          wrapper.entities.add_instance(source, scaling * normalize)
          true
        rescue Exception => error
          puts "Stage Bridge asset load failed for #{asset_path}: #{error.class}: #{error.message}"
          false
        end

        def self.build_stage_reference(root_entities, root_hash, model)
          stage_shape = root_hash['stageShape']
          return nil unless stage_shape.is_a?(Hash)
          width_m = numeric(stage_shape['width'])
          depth_m = numeric(stage_shape['height'])
          return nil if width_m <= 0.0 || depth_m <= 0.0

          group = root_entities.add_group
          group.name = 'Stage Bridge Bay Reference'
          group.set_attribute(ENTITY_DICTIONARY, ROLE_KEY, ROLE_STAGE_REFERENCE)
          width = width_m * Core::Transform::INCHES_PER_METER
          depth = depth_m * Core::Transform::INCHES_PER_METER
          material = material_for(model, 'Stage Bridge Reference Floor', [92, 98, 104], 0.35)
          add_box(group.entities, width, depth, 0.1, material, 0.0, 0.0, -0.11)
          group.locked = true
          group
        end

        def self.build_wall(entities, dimensions, model)
          width = dimensions[0]
          depth = dimensions[1]
          height = dimensions[2]
          wood = material_for(model, 'Stage Bridge Wall Frame', [126, 79, 42], 1.0)
          mesh = material_for(model, 'Stage Bridge Wall Mesh', [225, 112, 35], 0.45)
          post = 1.5
          rail = 1.5
          add_box(entities, post, depth, height, wood, -(width / 2.0) + (post / 2.0), 0.0, 0.0)
          add_box(entities, post, depth, height, wood, (width / 2.0) - (post / 2.0), 0.0, 0.0)
          add_box(entities, width, depth, rail, wood, 0.0, 0.0, 0.0)
          add_box(entities, width, depth, rail, wood, 0.0, 0.0, height - rail)
          add_box(entities, width - (post * 2.0), 0.2, height - (rail * 2.0), mesh, 0.0, 0.0, rail)
        end

        def self.build_target(entities, dimensions, material)
          build_target_at(entities, dimensions, material, 30.0)
        end

        def self.build_target_at(entities, dimensions, material, base_height)
          stick_material = material
          add_box(entities, 1.5, 1.5, base_height, stick_material, -4.0, 0.0, 0.0)
          add_box(entities, 1.5, 1.5, base_height, stick_material, 4.0, 0.0, 0.0)
          target_dimensions = [dimensions[0], dimensions[1], dimensions[2]]
          width = target_dimensions[0]
          depth = target_dimensions[1]
          height = target_dimensions[2]
          shoulder = width * 0.72
          points = [
            [-width / 2.0, -depth / 2.0, base_height],
            [width / 2.0, -depth / 2.0, base_height],
            [width / 2.0, -depth / 2.0, base_height + (height * 0.65)],
            [shoulder / 2.0, -depth / 2.0, base_height + height],
            [-shoulder / 2.0, -depth / 2.0, base_height + height],
            [-width / 2.0, -depth / 2.0, base_height + (height * 0.65)]
          ]
          face = entities.add_face(points)
          return if face.nil?
          face.material = material
          face.back_material = material
          face.pushpull(depth)
          apply_material(entities, material)
        end

        def self.build_popper(entities, dimensions, material)
          width = dimensions[0]
          depth = dimensions[1]
          height = dimensions[2]
          head_radius = width / 2.0
          stem_width = [width * 0.35, 3.0].max
          add_box(entities, width, depth, 2.0, material, 0.0, 0.0, 0.0)
          add_box(entities, stem_width, depth, height - (head_radius * 2.0), material, 0.0, 0.0, 2.0)
          edges = entities.add_circle([0.0, -depth / 2.0, height - head_radius], Y_AXIS, head_radius, 20)
          face = entities.add_face(edges)
          unless face.nil?
            face.pushpull(depth)
            apply_material(entities, material)
          end
        end

        def self.build_cylinder(entities, dimensions, material)
          diameter = dimensions[0]
          height = dimensions[2]
          edges = entities.add_circle([0.0, 0.0, 0.0], Z_AXIS, diameter / 2.0, 24)
          face = entities.add_face(edges)
          return if face.nil?
          face.pushpull(height)
          apply_material(entities, material)
        end

        def self.build_table(entities, dimensions, material, model)
          width = dimensions[0]
          depth = dimensions[1]
          height = dimensions[2]
          leg_material = material_for(model, 'Stage Bridge Table Legs', [80, 84, 88], 1.0)
          add_box(entities, width, depth, 2.0, material, 0.0, 0.0, height - 2.0)
          [-1.0, 1.0].each do |x_sign|
            [-1.0, 1.0].each do |y_sign|
              add_box(
                entities, 1.5, 1.5, height - 2.0, leg_material,
                x_sign * ((width / 2.0) - 4.0), y_sign * ((depth / 2.0) - 4.0), 0.0
              )
            end
          end
        end

        def self.build_stacked_target(entities, dimensions, material)
          single_height = dimensions[2] / 2.0
          build_target_at(entities, [dimensions[0], dimensions[1], single_height], material, 24.0)
          build_target_at(entities, [dimensions[0], dimensions[1], single_height], material, 24.0 + (single_height * 0.75))
        end

        def self.build_swinger(entities, dimensions, material, model)
          frame = material_for(model, 'Stage Bridge Swinger Frame', [72, 76, 80], 1.0)
          add_box(entities, 30.0, 18.0, 1.5, frame, 0.0, 0.0, 0.0)
          add_box(entities, 1.5, 1.5, 34.0, frame, 0.0, 0.0, 1.5)
          add_box(entities, 24.0, 1.5, 1.5, frame, 0.0, 0.0, 34.0)
          build_target_at(entities, [dimensions[0], 1.0, dimensions[2]], material, 35.5)
        end

        def self.build_double_x_start(entities, _dimensions, material)
          [-7.0, 7.0].each do |center_x|
            [-Math::PI / 4.0, Math::PI / 4.0].each do |angle|
              bar = entities.add_group
              add_box(bar.entities, 11.0, 1.5, 0.25, material, 0.0, 0.0, 0.0)
              translation = Geom::Transformation.translation([center_x, 0.0, 0.0])
              rotation = Geom::Transformation.rotation(ORIGIN, Z_AXIS, angle)
              bar.transform!(translation * rotation)
            end
          end
        end

        def self.add_box(entities, width, depth, height, material, center_x, center_y, base_z)
          x0 = center_x - (width / 2.0)
          x1 = center_x + (width / 2.0)
          y0 = center_y - (depth / 2.0)
          y1 = center_y + (depth / 2.0)
          points = [[x0, y0, base_z], [x1, y0, base_z], [x1, y1, base_z], [x0, y1, base_z]]
          face = entities.add_face(points)
          return if face.nil?
          face.reverse! if face.normal.z < 0.0
          face.pushpull(height)
          apply_material(entities, material)
        end

        def self.apply_material(entities, material)
          entities.grep(Sketchup::Face).each do |face|
            face.material = material
            face.back_material = material
          end
        end

        def self.material_for(model, name, color, alpha)
          material = model.materials[name]
          material = model.materials.add(name) if material.nil?
          material.color = Sketchup::Color.new(color[0], color[1], color[2])
          material.alpha = alpha
          material
        end

        def self.numeric(value)
          Float(value)
        rescue ArgumentError, TypeError
          0.0
        end

        def self.sanitize(value)
          value.to_s.downcase.gsub(/[^a-z0-9]+/, '_')
        end
      end
    end
  end
end
