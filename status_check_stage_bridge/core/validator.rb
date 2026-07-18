module StatusCheckGG
  module StageBridge
    module Core
      module Validator
        def self.validate_root(root)
          diagnostics = []
          unless root.is_a?(Hash)
            diagnostics << error('invalid_root', 'The STG root must be a JSON object.')
            return diagnostics
          end

          if root['stageName'].nil? || root['stageName'].to_s.strip.empty?
            diagnostics << error('missing_stage_name', "Required field 'stageName' is missing or empty.")
          end

          props = root['propList']
          unless props.is_a?(Array)
            diagnostics << error('missing_prop_list', "Required field 'propList' must be an array.")
            return diagnostics
          end

          ids = {}
          props.each_with_index do |prop, index|
            unless prop.is_a?(Hash)
              diagnostics << error('invalid_prop', "Prop #{index} is not an object.")
              next
            end
            prop_name = prop['propName'].to_s
            diagnostics << warning('missing_prop_name', "Prop #{index} has no propName.") if prop_name.empty?
            unique_id = prop['uniqueID']
            if unique_id.nil?
              diagnostics << error('missing_unique_id', "Prop #{index} has no uniqueID.")
            elsif ids.key?(unique_id.to_s)
              diagnostics << error('duplicate_unique_id', "Props #{ids[unique_id.to_s]} and #{index} share uniqueID #{unique_id}.")
            else
              ids[unique_id.to_s] = index
            end
          end

          props.each_with_index do |prop, index|
            next unless prop.is_a?(Hash)
            activate_ids = prop['activateIDs']
            next unless activate_ids.is_a?(Array)
            activate_ids.each do |target_id|
              unless ids.key?(target_id.to_s)
                diagnostics << error('dangling_activation_id', "Prop #{index} activates missing uniqueID #{target_id}.")
              end
            end
          end

          diagnostics
        end

        def self.blocking?(diagnostics)
          diagnostics.any? { |diagnostic| diagnostic['severity'] == 'error' }
        end

        def self.error(code, message)
          { 'severity' => 'error', 'code' => code, 'message' => message }
        end

        def self.warning(code, message)
          { 'severity' => 'warning', 'code' => code, 'message' => message }
        end
      end
    end
  end
end
