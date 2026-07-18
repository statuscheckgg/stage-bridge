require 'json'
require 'digest/sha2'

module StatusCheckGG
  module StageBridge
    module Core
      class StageDocument
        attr_reader :root, :source_json, :encoding_name, :source_hash, :source_path, :anchor

        def self.load(path)
          bytes = File.binread(path)
          text, encoding_name = EncodingHelper.decode(bytes)
          root = JSON.parse(text)
          raise ArgumentError, 'The STG root must be a JSON object.' unless root.is_a?(Hash)
          new(root, text, encoding_name, Digest::SHA256.hexdigest(bytes), path)
        end

        def self.from_json(text, encoding_name, source_path)
          root = JSON.parse(text)
          raise ArgumentError, 'The STG root must be a JSON object.' unless root.is_a?(Hash)
          bytes = EncodingHelper.encode(text, encoding_name)
          new(root, text, encoding_name, Digest::SHA256.hexdigest(bytes), source_path)
        end

        def initialize(root, source_json, encoding_name, source_hash, source_path)
          @root = root
          @source_json = source_json
          @encoding_name = encoding_name
          @source_hash = source_hash
          @source_path = source_path
          @anchor = Transform.anchor_for_props(props)
        end

        def props
          value = @root['propList']
          value.is_a?(Array) ? value : []
        end

        def deep_copy_root
          JSON.parse(JSON.generate(@root))
        end

        def stage_name
          value = @root['stageName']
          value.nil? || value.to_s.empty? ? File.basename(@source_path.to_s) : value.to_s
        end
      end
    end
  end
end
