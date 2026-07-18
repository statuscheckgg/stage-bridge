require 'json'
require 'fileutils'

repo_root = File.expand_path('..', File.dirname(__FILE__))
result_dir = 'C:/Vibes/Temp/practisim-sketchup-bridge'
result_path = File.join(result_dir, 'smoke-result.json')
boot_path = File.join(result_dir, 'smoke-boot.txt')
model_path = File.join(result_dir, 'smoke-model.skp')
reference_model_path = File.join(result_dir, 'smoke-reference-model.skp')
FileUtils.mkdir_p(result_dir)
File.open(boot_path, 'wb') { |file| file.write("loaded #{Time.now}\n") }

def write_smoke_result(path, payload)
  File.open(path, 'wb') { |file| file.write(JSON.pretty_generate(payload)) }
end

def angular_difference_degrees(a, b)
  difference = (a - b).abs % (Math::PI * 2.0)
  difference = (Math::PI * 2.0) - difference if difference > Math::PI
  difference * 180.0 / Math::PI
end

def validate_stage_round_trip(path)
  model = Sketchup.active_model
  existing_root = StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.stage_root(model)
  unless existing_root.nil? || existing_root.deleted?
    existing_root.locked = false
    existing_root.erase!
  end
  imported = StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.import_file(path, model)
  raise "SketchUp import returned false for #{path}" unless imported

  export_root, diagnostics, _instances = StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.build_export_root(model, false)
  if StatusCheckGG::StageBridge::Core::Validator.blocking?(diagnostics)
    raise "Export model diagnostics blocked for #{path}: #{diagnostics.inspect}"
  end

  document = StatusCheckGG::StageBridge::Core::StageDocument.load(path)
  original_root = document.root
  original_props = original_root['propList'] || []
  exported_props = export_root['propList'] || []
  unless original_props.length == exported_props.length
    raise "Prop count changed for #{path}: #{original_props.length} to #{exported_props.length}"
  end

  original_without_props = JSON.parse(JSON.generate(original_root))
  exported_without_props = JSON.parse(JSON.generate(export_root))
  original_without_props.delete('propList')
  exported_without_props.delete('propList')
  raise "Top-level non-prop data changed for #{path}" unless original_without_props == exported_without_props

  max_position_difference = 0.0
  max_yaw_difference = 0.0
  original_props.each_with_index do |original_prop, index|
    exported_prop = exported_props[index]
    original_without_transform = JSON.parse(JSON.generate(original_prop))
    exported_without_transform = JSON.parse(JSON.generate(exported_prop))
    original_without_transform.delete('propTransform')
    exported_without_transform.delete('propTransform')
    unless original_without_transform == exported_without_transform
      raise "Non-transform prop data changed at index #{index} in #{path}"
    end

    old_translation = StatusCheckGG::StageBridge::Core::Transform.source_translation(original_prop)
    new_translation = StatusCheckGG::StageBridge::Core::Transform.source_translation(exported_prop)
    ['x', 'y', 'z'].each do |axis|
      difference = (old_translation[axis] - new_translation[axis]).abs
      max_position_difference = difference if difference > max_position_difference
      raise "#{axis} round-trip difference #{difference} at index #{index} in #{path}" if difference > 0.01
    end

    old_yaw = StatusCheckGG::StageBridge::Core::Transform.source_yaw_radians(original_prop)
    new_yaw = StatusCheckGG::StageBridge::Core::Transform.source_yaw_radians(exported_prop)
    yaw_difference = angular_difference_degrees(old_yaw, new_yaw)
    max_yaw_difference = yaw_difference if yaw_difference > max_yaw_difference
    raise "Yaw round-trip difference #{yaw_difference} at index #{index} in #{path}" if yaw_difference > 0.05
  end

  {
    'path' => path,
    'prop_count' => exported_props.length,
    'diagnostic_count' => diagnostics.length,
    'max_position_difference' => max_position_difference,
    'max_yaw_difference_degrees' => max_yaw_difference
  }
end

UI.start_timer(1.0, false) do
  begin
    load File.join(repo_root, 'test', 'core_test_runner.rb')
    core_result = StageBridgeCoreTests.run(repo_root)
    load File.join(repo_root, 'status_check_stage_bridge.rb')
    load File.join(repo_root, 'status_check_stage_bridge', 'main.rb')
    unless StatusCheckGG::StageBridge::EXTENSION.version == StatusCheckGG::StageBridge::VERSION
      raise "Extension metadata version #{StatusCheckGG::StageBridge::EXTENSION.version} did not match #{StatusCheckGG::StageBridge::VERSION}"
    end

    fixture = File.join(repo_root, 'test', 'fixtures', 'synthetic-stage.STG')
    model = Sketchup.active_model
    imported = StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.import_file(fixture, model)
    raise 'SketchUp import returned false' unless imported

    export_root, diagnostics, _instances = StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.build_export_root(model, false)
    blocking = StatusCheckGG::StageBridge::Core::Validator.blocking?(diagnostics)
    raise "Export model diagnostics blocked: #{diagnostics.inspect}" if blocking
    raise 'Expected four exported props' unless export_root['propList'].length == 4
    raise 'Unknown top-level field was lost' unless export_root['customTopLevelField']['mustSurvive'] == true

    original = JSON.parse(File.read(fixture))
    original_by_id = {}
    original['propList'].each { |prop| original_by_id[prop['uniqueID'].to_s] = prop }
    export_root['propList'].each do |prop|
      original_prop = original_by_id[prop['uniqueID'].to_s]
      raise "Missing original prop #{prop['uniqueID']}" if original_prop.nil?
      old_translation = original_prop['propTransform']['Translation']
      new_translation = prop['propTransform']['Translation']
      ['X', 'Y', 'Z'].each do |axis|
        difference = (old_translation[axis].to_f - new_translation[axis].to_f).abs
        raise "#{axis} round-trip difference #{difference}" if difference > 0.01
      end
    end

    root_group = StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.stage_root(model)
    original_instances = StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.prop_instances(root_group)
    edited_instance = original_instances[0]
    edited_instance.transformation =
      Geom::Transformation.translation([12.0, -6.0, 3.0]) *
      Geom::Transformation.rotation(ORIGIN, Z_AXIS, 0.25) *
      Geom::Transformation.scaling(1.1, 0.9, 1.2)

    duplicate_source = original_instances[1]
    duplicate = root_group.entities.add_instance(duplicate_source.definition, duplicate_source.transformation)
    ['role', 'prop_name', 'catalog_key', 'source_index', 'unique_id_json', 'original_prop_json', 'is_new', 'display_z_offset'].each do |key|
      duplicate.set_attribute(
        StatusCheckGG::StageBridge::ENTITY_DICTIONARY,
        key,
        duplicate_source.get_attribute(StatusCheckGG::StageBridge::ENTITY_DICTIONARY, key, nil)
      )
    end
    StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.add_catalog_prop(
      model,
      StatusCheckGG::StageBridge::Core::Catalog.by_key('wall_4ft')
    )
    original_instances[3].erase!

    StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.assign_duplicate_ids(root_group)
    edited_root, edited_diagnostics, _edited_instances =
      StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.build_export_root(model, true)
    if StatusCheckGG::StageBridge::Core::Validator.blocking?(edited_diagnostics)
      raise "Tagged edit diagnostics blocked: #{edited_diagnostics.inspect}"
    end
    raise 'Move/rotate/scale/add/duplicate/delete edit count mismatch' unless edited_root['propList'].length == 5
    edited_ids = edited_root['propList'].map { |prop| prop['uniqueID'] }
    raise 'Edited stage contains duplicate IDs' unless edited_ids.uniq.length == edited_ids.length
    raise 'Original prop order changed' unless edited_ids[0, 3] == [1, 2, 3]
    raise 'New IDs were not appended above the original maximum' unless edited_ids[3, 2].all? { |value| value.to_i > 4 }

    valid_transformation = edited_instance.transformation
    edited_instance.transformation = Geom::Transformation.scaling(-1.0, 1.0, 1.0)
    _invalid_root, invalid_transform_diagnostics, _invalid_instances =
      StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.build_export_root(model, false)
    unless invalid_transform_diagnostics.any? { |diagnostic| diagnostic['code'] == 'mirrored_transform' }
      raise 'Mirrored transform was not rejected'
    end
    edited_instance.transformation = valid_transformation

    adjustable_entry = StatusCheckGG::StageBridge::Core::Catalog.by_key('faultline_adjustable')
    adjustable_prop = StatusCheckGG::StageBridge::Core::Catalog.new_prop(adjustable_entry, 900001)
    adjustable_prop['propTransform']['Scale3D'] = { 'X' => 24.384, 'Y' => 0.5, 'Z' => 1.0 }
    adjustable_instance = StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.add_prop_instance(
      model, root_group, adjustable_prop, -1, StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.anchor_for(model), true
    )
    adjustable_length = adjustable_instance.bounds.width.to_f
    unless (adjustable_length - 96.0).abs < 0.05
      raise "Adjustable 8-foot fault line rendered at #{adjustable_length} inches"
    end
    adjustable_instance.erase!

    grounded_prop = StatusCheckGG::StageBridge::Core::Catalog.new_prop(
      StatusCheckGG::StageBridge::Core::Catalog.by_key('wall_4ft'), 900002
    )
    grounded_prop['propTransform']['Translation']['Z'] = -4.19
    grounded_instance = StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.add_prop_instance(
      model, root_group, grounded_prop, -1, StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.anchor_for(model), true
    )
    if grounded_instance.bounds.min.z.to_f < -0.0001
      raise "Grounded prop still rendered below ground at #{grounded_instance.bounds.min.z.to_f} inches"
    end
    grounded_transform, grounded_diagnostics =
      StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.extract_transform(
        grounded_instance, StatusCheckGG::StageBridge::SketchupIntegration::ModelAdapter.anchor_for(model)
      )
    unless grounded_diagnostics.empty?
      raise "Grounded prop transform produced diagnostics: #{grounded_diagnostics.inspect}"
    end
    unless (grounded_transform['Translation']['Z'].to_f + 4.19).abs < 0.01
      raise "Ground display offset changed exported source Z to #{grounded_transform['Translation']['Z']}"
    end
    grounded_instance.erase!

    asset_expectations = [
      ['wall_4ft', [48.0, 4.2435434459, 72.0]],
      ['wall_8ft', [96.0, 4.2435434459, 72.0]],
      ['uspsa_target', [20.0, 18.0, 66.5264628608]],
      ['uspsa_target_short', [20.0, 18.0, 43.6932602888]],
      ['barrel', [22.9685039370, 22.9685039370, 37.7086614173]],
      ['barrel_stack', [22.9685039370, 22.9685039370, 75.4586614173]],
      ['start_position', [24.0, 24.0, 0.25]]
    ]
    asset_expectations.each do |catalog_key, expected_dimensions|
      entry = StatusCheckGG::StageBridge::Core::Catalog.by_key(catalog_key)
      definition = StatusCheckGG::StageBridge::SketchupIntegration::Geometry.definition_for(model, entry, entry[:prop_name])
      nested_assets = definition.entities.grep(Sketchup::ComponentInstance)
      raise "#{catalog_key} did not load its packaged component asset" if nested_assets.empty?
      bounds = definition.bounds
      actual_dimensions = [
        bounds.max.x.to_f - bounds.min.x.to_f,
        bounds.max.y.to_f - bounds.min.y.to_f,
        bounds.max.z.to_f - bounds.min.z.to_f
      ]
      expected_dimensions.each_with_index do |expected, dimension_index|
        difference = (actual_dimensions[dimension_index] - expected).abs
        if difference > 0.05
          raise "#{catalog_key} dimension #{dimension_index} was #{actual_dimensions[dimension_index]}, expected #{expected}"
        end
      end
      center_x = (bounds.min.x.to_f + bounds.max.x.to_f) / 2.0
      center_y = (bounds.min.y.to_f + bounds.max.y.to_f) / 2.0
      raise "#{catalog_key} asset X origin was not centered: #{center_x}" if center_x.abs > 0.001
      raise "#{catalog_key} asset Y origin was not centered: #{center_y}" if center_y.abs > 0.001
      raise "#{catalog_key} asset base was not grounded: #{bounds.min.z.to_f}" if bounds.min.z.to_f.abs > 0.001
    end

    model.save(model_path)
    reference_stages = ENV['STAGE_BRIDGE_REFERENCE_STAGES'].to_s.split(File::PATH_SEPARATOR)
    reference_stages = reference_stages.reject { |path| path.to_s.empty? }
    reference_results = reference_stages.map { |path| validate_stage_round_trip(path) }
    Sketchup.active_model.save(reference_model_path)
    write_smoke_result(result_path, {
      'status' => 'passed',
      'sketchup_version' => Sketchup.version,
      'ruby_version' => RUBY_VERSION,
      'core' => core_result,
      'prop_count' => export_root['propList'].length,
      'edited_prop_count' => edited_root['propList'].length,
      'diagnostics' => diagnostics,
      'model_path' => model_path,
      'reference_model_path' => reference_model_path,
      'reference_stages' => reference_results
    })
  rescue Exception => error
    write_smoke_result(result_path, {
      'status' => 'failed',
      'error_class' => error.class.to_s,
      'error' => error.message,
      'backtrace' => error.backtrace
    })
  ensure
    Sketchup.quit
  end
end
