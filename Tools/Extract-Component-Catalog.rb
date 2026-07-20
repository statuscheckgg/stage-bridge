require 'fileutils'

module StatusCheckGG
  module StageBridgeCatalogExtractor
    OUTPUT_DIRECTORY = File.expand_path('../status_check_stage_bridge/components', File.dirname(__FILE__))

    # These names are the stable top-level definitions in the user-supplied,
    # publicly distributable Big Prop File.skp stage-building collection.
    ASSETS = {
      'wall_base.skp' => 'Clear wall',
      'wall_plain_4ft.skp' => 'Group#286',
      'wall_plain_8ft.skp' => 'Group#336',
      'uspsa_target_high.skp' => 'Uspsa target and stand high#1',
      'uspsa_target_short.skp' => 'USPSA target and stand#10',
      'uspsa_target_short_tilted.skp' => 'USPSA target and stand#8',
      'uspsa_no_shoot_high.skp' => 'USPSA No shoot High',
      'uspsa_popper.skp' => 'Group#180',
      'uspsa_swinger.skp' => 'Group#167',
      'uspsa_two_stack_noshoot.skp' => 'Group#275',
      'barrel.skp' => 'ske245',
      'barrel_stack.skp' => 'Stacked_Barrels',
      'start_position.skp' => 'USPSA Shooting Box- 3X3'
    }

    def self.run
      model = Sketchup.active_model
      FileUtils.mkdir_p(OUTPUT_DIRECTORY)
      failures = []
      written = []

      ASSETS.each do |filename, definition_name|
        definition = model.definitions[definition_name]
        if definition.nil?
          failures << "#{filename}: definition #{definition_name.inspect} was not found"
          next
        end

        path = File.join(OUTPUT_DIRECTORY, filename)
        if definition.save_as(path)
          written << path
        else
          failures << "#{filename}: SketchUp could not save definition #{definition_name.inspect}"
        end
      end

      puts "Stage Bridge component catalog: wrote #{written.length} assets to #{OUTPUT_DIRECTORY}"
      failures.each { |failure| puts "WARNING: #{failure}" }
      failures.empty?
    end
  end
end

StatusCheckGG::StageBridgeCatalogExtractor.run
