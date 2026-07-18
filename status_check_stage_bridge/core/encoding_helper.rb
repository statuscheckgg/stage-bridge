module StatusCheckGG
  module StageBridge
    module Core
      module EncodingHelper
        UTF8 = 'utf8'
        UTF16LE = 'utf16le'

        def self.decode(bytes)
          raw = bytes.dup
          raw.force_encoding(Encoding::BINARY)

          if raw.bytesize >= 2 && raw.getbyte(0) == 0xFF && raw.getbyte(1) == 0xFE
            text = raw.byteslice(2, raw.bytesize - 2)
            text.force_encoding(Encoding::UTF_16LE)
            return [text.encode(Encoding::UTF_8), UTF16LE]
          end

          sample_length = [raw.bytesize, 512].min
          sample = raw.byteslice(0, sample_length)
          null_count = sample.bytes.count { |value| value == 0 }
          if sample_length > 0 && null_count > (sample_length / 4)
            raw.force_encoding(Encoding::UTF_16LE)
            return [raw.encode(Encoding::UTF_8), UTF16LE]
          end

          raw.force_encoding(Encoding::UTF_8)
          [raw.encode(Encoding::UTF_8, :invalid => :replace, :undef => :replace), UTF8]
        end

        def self.encode(text, encoding_name)
          if encoding_name == UTF16LE
            payload = text.encode(Encoding::UTF_16LE)
            bom = [0xFF, 0xFE].pack('C*')
            bom.force_encoding(Encoding::BINARY)
            encoded = payload.dup
            encoded.force_encoding(Encoding::BINARY)
            return bom + encoded
          end

          encoded = text.encode(Encoding::UTF_8)
          encoded.force_encoding(Encoding::BINARY)
          encoded
        end
      end
    end
  end
end
