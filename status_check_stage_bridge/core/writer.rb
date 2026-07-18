require 'fileutils'
require 'time'

module StatusCheckGG
  module StageBridge
    module Core
      module Writer
        def self.pretty_json(root)
          JSON.pretty_generate(root) + "\n"
        end

        def self.write(path, root, encoding_name, options)
          overwrite = options[:overwrite] == true
          exists = File.exist?(path)
          raise IOError, "Refusing to overwrite existing file: #{path}" if exists && !overwrite

          backup_path = nil
          if exists
            stamp = Time.now.strftime('%Y%m%d-%H%M%S')
            backup_path = "#{path}.backup-#{stamp}"
            FileUtils.cp(path, backup_path)
          end

          temp_path = "#{path}.stage-bridge-tmp-#{Process.pid}"
          bytes = EncodingHelper.encode(pretty_json(root), encoding_name)
          File.open(temp_path, 'wb') { |file| file.write(bytes) }

          begin
            File.delete(path) if File.exist?(path)
            File.rename(temp_path, path)
          rescue Exception
            FileUtils.cp(backup_path, path) if backup_path && !File.exist?(path)
            raise
          ensure
            File.delete(temp_path) if File.exist?(temp_path)
          end

          { :path => path, :backup_path => backup_path, :bytes => bytes }
        end
      end
    end
  end
end
