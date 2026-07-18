require 'sketchup.rb'
require 'extensions.rb'
require File.join(File.dirname(__FILE__), 'status_check_stage_bridge', 'constants')

module StatusCheckGG
  module StageBridge
    EXTENSION = SketchupExtension.new(
      'Stage Bridge',
      'status_check_stage_bridge/main'
    )
    EXTENSION.creator = 'Status Check'
    EXTENSION.description = 'Round-trip existing Practisim STG stages through SketchUp Make 2017.'
    EXTENSION.version = VERSION
    EXTENSION.copyright = '2026 Status Check'

    Sketchup.register_extension(EXTENSION, true)
  end
end
