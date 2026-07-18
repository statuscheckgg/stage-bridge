module StatusCheckGG
  module StageBridge
    module SketchupIntegration
      module Commands
        def self.register
          return if @registered
          @registered = true

          Sketchup.register_importer(PractisimImporter.new)
          submenu = UI.menu('Extensions').add_submenu('Stage Bridge')

          import_command = command('Import Practisim Stage') { import_stage }
          add_command = command('Add Practisim Prop') { add_prop }
          metadata_command = command('Stage Metadata') { ModelAdapter.edit_metadata(Sketchup.active_model) }
          validate_command = command('Validate Stage') { ModelAdapter.validate_model(Sketchup.active_model) }
          export_command = command('Export Practisim Stage') { ModelAdapter.export_model(Sketchup.active_model) }

          [import_command, add_command, metadata_command, validate_command, export_command].each do |item|
            submenu.add_item(item)
          end

          toolbar = UI::Toolbar.new('Stage Bridge')
          [import_command, add_command, validate_command, export_command].each { |item| toolbar.add_item(item) }
          toolbar.restore
        end

        def self.command(name, &block)
          item = UI::Command.new(name, &block)
          item.menu_text = name
          item.tooltip = name
          item.status_bar_text = "Stage Bridge: #{name}"
          icon_path = File.join(File.dirname(__FILE__), '..', 'icons', 'stage_bridge.svg')
          item.small_icon = icon_path
          item.large_icon = icon_path
          item
        end

        def self.import_stage
          path = UI.openpanel('Import Practisim Stage', nil, 'Practisim Stage|*.STG||')
          return if path.nil?
          ModelAdapter.import_file(path, Sketchup.active_model)
        rescue Exception => error
          UI.messagebox("Stage Bridge import failed:\n#{error.class}: #{error.message}")
        end

        def self.add_prop
          entries = Core::Catalog.entries
          displays = entries.map { |entry| entry[:display] }
          values = UI.inputbox(['Prop'], [displays.first], [displays.join('|')], 'Add Practisim Prop')
          return if values == false
          entry = Core::Catalog.by_display(values[0].to_s)
          return if entry.nil?
          ModelAdapter.add_catalog_prop(Sketchup.active_model, entry)
        rescue Exception => error
          UI.messagebox("Stage Bridge could not add the prop:\n#{error.class}: #{error.message}")
        end
      end
    end
  end
end
