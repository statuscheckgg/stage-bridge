module StatusCheckGG
  module StageBridge
    module SketchupIntegration
      class PractisimImporter < Sketchup::Importer
        def description
          'Practisim Stage (*.STG)'
        end

        def file_extension
          'STG'
        end

        def id
          'statuscheckgg.stage_bridge.practisim_stg'
        end

        def supports_options?
          false
        end

        def load_file(file_path, _status)
          success = ModelAdapter.import_file(file_path, Sketchup.active_model)
          success ? Sketchup::Importer::ImportSuccess : Sketchup::Importer::ImportCanceled
        rescue Errno::ENOENT
          Sketchup::Importer::ImportFileNotFound
        rescue Exception => error
          UI.messagebox("Stage Bridge import failed:\n#{error.class}: #{error.message}")
          Sketchup::Importer::ImportFail
        end
      end
    end
  end
end
