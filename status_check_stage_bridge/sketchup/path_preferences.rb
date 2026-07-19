module StatusCheckGG
  module StageBridge
    module SketchupIntegration
      module PathPreferences
        SECTION = 'StatusCheckGG_StageBridge'
        LAST_STAGE_FOLDER_KEY = 'last_stage_folder'

        def self.last_stage_folder(fallback_folder = nil)
          stored = Sketchup.read_default(SECTION, LAST_STAGE_FOLDER_KEY, '').to_s
          [stored, fallback_folder, Dir.home].each do |candidate|
            next if candidate.nil? || candidate.to_s.empty?
            expanded = File.expand_path(candidate.to_s)
            return expanded if File.directory?(expanded)
          end
          nil
        rescue Exception
          fallback_folder if !fallback_folder.nil? && File.directory?(fallback_folder.to_s)
        end

        def self.remember_path(path)
          return false if path.nil? || path.to_s.empty?
          expanded = File.expand_path(path.to_s)
          folder = File.directory?(expanded) ? expanded : File.dirname(expanded)
          return false unless File.directory?(folder)
          Sketchup.write_default(SECTION, LAST_STAGE_FOLDER_KEY, folder)
          true
        rescue Exception
          false
        end
      end
    end
  end
end
