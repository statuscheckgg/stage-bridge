require 'sketchup.rb'
require 'json'

base = File.dirname(__FILE__)
Sketchup.require File.join(base, 'constants')
Sketchup.require File.join(base, 'core', 'encoding_helper')
Sketchup.require File.join(base, 'core', 'transform')
Sketchup.require File.join(base, 'core', 'catalog')
Sketchup.require File.join(base, 'core', 'stage_document')
Sketchup.require File.join(base, 'core', 'validator')
Sketchup.require File.join(base, 'core', 'writer')
Sketchup.require File.join(base, 'sketchup', 'geometry')
Sketchup.require File.join(base, 'sketchup', 'path_preferences')
Sketchup.require File.join(base, 'sketchup', 'model_adapter')
Sketchup.require File.join(base, 'sketchup', 'importer')
Sketchup.require File.join(base, 'sketchup', 'commands')

module StatusCheckGG
  module StageBridge
    SketchupIntegration::Commands.register
  end
end
