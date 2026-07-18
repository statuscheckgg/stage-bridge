require 'json'
require 'fileutils'

root = File.expand_path('..', File.dirname(__FILE__))
support = File.join(root, 'status_check_stage_bridge')
$LOAD_PATH.unshift(support)

require File.join(support, 'constants')
require File.join(support, 'core', 'encoding_helper')
require File.join(support, 'core', 'transform')
require File.join(support, 'core', 'catalog')
require File.join(support, 'core', 'stage_document')
require File.join(support, 'core', 'validator')
require File.join(support, 'core', 'writer')

module StageBridgeCoreTests
  def self.assert(condition, message)
    raise RuntimeError, message unless condition
  end

  def self.assert_close(expected, actual, tolerance, message)
    difference = (expected.to_f - actual.to_f).abs
    raise RuntimeError, "#{message}: expected #{expected}, got #{actual}" if difference > tolerance
  end

  def self.run(root)
    fixture = File.join(root, 'test', 'fixtures', 'synthetic-stage.STG')
    document = StatusCheckGG::StageBridge::Core::StageDocument.load(fixture)
    assert(document.props.length == 4, 'Expected four fixture props')
    assert(document.root['customTopLevelField']['mustSurvive'] == true, 'Unknown top-level data was lost')

    diagnostics = StatusCheckGG::StageBridge::Core::Validator.validate_root(document.root)
    assert(!StatusCheckGG::StageBridge::Core::Validator.blocking?(diagnostics), 'Fixture should validate')

    prop = document.props.first
    mapped = StatusCheckGG::StageBridge::Core::Transform.source_to_local(prop, document.anchor)
    round_trip = StatusCheckGG::StageBridge::Core::Transform.local_to_source(
      { 'x' => mapped['x'], 'y' => mapped['y'], 'z' => mapped['z'] },
      mapped['yaw'], mapped['scale'], document.anchor
    )
    source = StatusCheckGG::StageBridge::Core::Transform.source_translation(prop)
    assert_close(source['x'], round_trip['Translation']['X'], 0.01, 'X round trip')
    assert_close(source['y'], round_trip['Translation']['Y'], 0.01, 'Y round trip')
    assert_close(source['z'], round_trip['Translation']['Z'], 0.01, 'Z round trip')
    assert_close(
      StatusCheckGG::StageBridge::Core::Transform.source_yaw_radians(prop),
      StatusCheckGG::StageBridge::Core::Transform.source_yaw_radians({ 'propTransform' => round_trip }),
      0.000001,
      'Yaw round trip'
    )

    quarter_turn = JSON.parse(JSON.generate(prop))
    quarter_turn['propTransform']['Rotation'] = {
      'X' => 0.0,
      'Y' => 0.0,
      'Z' => Math.sin(Math::PI / 4.0),
      'W' => Math.cos(Math::PI / 4.0)
    }
    quarter_turn_mapped = StatusCheckGG::StageBridge::Core::Transform.source_to_local(quarter_turn, document.anchor)
    assert_close(-Math::PI / 2.0, quarter_turn_mapped['yaw'], 0.000001, 'Reflected Y must negate visual yaw')

    adjustable = StatusCheckGG::StageBridge::Core::Catalog.by_key('faultline_adjustable')
    assert(!adjustable.nil?, 'Adjustable fault line is missing from the catalog')
    assert_close(3.937007874, adjustable[:dimensions][0], 0.000001, 'Adjustable fault-line base length')
    assert(
      StatusCheckGG::StageBridge::Core::Catalog.for_prop_name('faultline-adjustable')[:key] == 'faultline_adjustable',
      'Adjustable fault line must not reuse the fixed 8-foot definition'
    )

    utf16 = StatusCheckGG::StageBridge::Core::EncodingHelper.encode(document.source_json, 'utf16le')
    decoded, encoding_name = StatusCheckGG::StageBridge::Core::EncodingHelper.decode(utf16)
    assert(encoding_name == 'utf16le', 'UTF-16LE encoding was not detected')
    assert(JSON.parse(decoded)['stageName'] == document.stage_name, 'UTF-16LE content changed')

    invalid = document.deep_copy_root
    invalid['propList'][1]['uniqueID'] = 1
    invalid_diagnostics = StatusCheckGG::StageBridge::Core::Validator.validate_root(invalid)
    assert(StatusCheckGG::StageBridge::Core::Validator.blocking?(invalid_diagnostics), 'Duplicate ID should block')

    activation_valid = document.deep_copy_root
    activation_valid['propList'][0]['activateIDs'] = [2]
    activation_diagnostics = StatusCheckGG::StageBridge::Core::Validator.validate_root(activation_valid)
    assert(!StatusCheckGG::StageBridge::Core::Validator.blocking?(activation_diagnostics), 'Valid activation ID should pass')

    activation_invalid = document.deep_copy_root
    activation_invalid['propList'][0]['activateIDs'] = [999999]
    activation_invalid_diagnostics = StatusCheckGG::StageBridge::Core::Validator.validate_root(activation_invalid)
    assert(
      activation_invalid_diagnostics.any? { |item| item['code'] == 'dangling_activation_id' },
      'Dangling activation ID should block'
    )

    counts = StatusCheckGG::StageBridge::Core::Catalog.scoring_counts(document.props)
    assert(counts['paper'] == 1, 'Paper count mismatch')
    assert(counts['steel'] == 1, 'Steel count mismatch')
    assert(counts['no_shoot'] == 0, 'No-shoot count mismatch')

    test_dir = 'C:/Vibes/Temp/practisim-sketchup-bridge/core-tests'
    FileUtils.mkdir_p(test_dir)
    output_path = File.join(test_dir, 'writer-test.STG')
    File.delete(output_path) if File.exist?(output_path)
    Dir.glob("#{output_path}.backup-*").each { |path| File.delete(path) }
    first_root = document.deep_copy_root
    first_root['stageName'] = 'Writer First Pass'
    first_result = StatusCheckGG::StageBridge::Core::Writer.write(
      output_path, first_root, StatusCheckGG::StageBridge::Core::EncodingHelper::UTF8, :overwrite => false
    )
    assert(File.exist?(first_result[:path]), 'Safe writer did not create output')

    refused = false
    begin
      StatusCheckGG::StageBridge::Core::Writer.write(
        output_path, first_root, StatusCheckGG::StageBridge::Core::EncodingHelper::UTF8, :overwrite => false
      )
    rescue IOError
      refused = true
    end
    assert(refused, 'Safe writer should refuse an implicit overwrite')

    second_root = document.deep_copy_root
    second_root['stageName'] = 'Writer Second Pass'
    second_result = StatusCheckGG::StageBridge::Core::Writer.write(
      output_path, second_root, StatusCheckGG::StageBridge::Core::EncodingHelper::UTF8, :overwrite => true
    )
    assert(!second_result[:backup_path].nil?, 'Explicit overwrite should create a backup')
    assert(File.exist?(second_result[:backup_path]), 'Overwrite backup is missing')
    current_document = StatusCheckGG::StageBridge::Core::StageDocument.load(output_path)
    backup_document = StatusCheckGG::StageBridge::Core::StageDocument.load(second_result[:backup_path])
    assert(current_document.stage_name == 'Writer Second Pass', 'Overwrite output content mismatch')
    assert(backup_document.stage_name == 'Writer First Pass', 'Backup content mismatch')
    File.delete(output_path) if File.exist?(output_path)
    File.delete(second_result[:backup_path]) if File.exist?(second_result[:backup_path])

    { 'status' => 'passed', 'tests' => 24 }
  end
end

if __FILE__ == $PROGRAM_NAME
  puts JSON.generate(StageBridgeCoreTests.run(root))
end
