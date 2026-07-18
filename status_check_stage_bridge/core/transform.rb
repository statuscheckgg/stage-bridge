module StatusCheckGG
  module StageBridge
    module Core
      module Transform
        METERS_PER_SOURCE_UNIT = 0.01005
        INCHES_PER_METER = 39.37007874015748
        INCHES_PER_SOURCE_UNIT = METERS_PER_SOURCE_UNIT * INCHES_PER_METER
        ADJUSTABLE_MESH_METERS = 0.1
        ADJUSTABLE_MESH_INCHES = ADJUSTABLE_MESH_METERS * INCHES_PER_METER

        def self.anchor_for_props(props)
          points = props.map do |prop|
            source_translation(prop)
          end

          return { 'x' => 0.0, 'y' => 0.0, 'z' => 0.0 } if points.empty?

          xs = points.map { |point| point['x'] }
          ys = points.map { |point| point['y'] }
          {
            'x' => (xs.min + xs.max) / 2.0,
            'y' => (ys.min + ys.max) / 2.0,
            'z' => 0.0
          }
        end

        def self.source_translation(prop)
          transform = hash_value(prop, 'propTransform') || {}
          translation = hash_value(transform, 'Translation') || {}
          {
            'x' => number_value(translation, 'X', 'x'),
            'y' => number_value(translation, 'Y', 'y'),
            'z' => number_value(translation, 'Z', 'z')
          }
        end

        def self.source_scale(prop)
          transform = hash_value(prop, 'propTransform') || {}
          scale = hash_value(transform, 'Scale3D') || {}
          {
            'x' => number_value_with_default(scale, 1.0, 'X', 'x'),
            'y' => number_value_with_default(scale, 1.0, 'Y', 'y'),
            'z' => number_value_with_default(scale, 1.0, 'Z', 'z')
          }
        end

        def self.source_yaw_radians(prop)
          transform = hash_value(prop, 'propTransform') || {}
          rotation = hash_value(transform, 'Rotation') || {}
          x = number_value(rotation, 'X', 'x')
          y = number_value(rotation, 'Y', 'y')
          z = number_value(rotation, 'Z', 'z')
          w = number_value_with_default(rotation, 1.0, 'W', 'w')
          Math.atan2(2.0 * ((w * z) + (x * y)), 1.0 - (2.0 * ((y * y) + (z * z))))
        end

        def self.source_to_local(prop, anchor)
          translation = source_translation(prop)
          {
            'x' => (translation['x'] - anchor['x']) * INCHES_PER_SOURCE_UNIT,
            'y' => -(translation['y'] - anchor['y']) * INCHES_PER_SOURCE_UNIT,
            'z' => (translation['z'] - anchor['z']) * INCHES_PER_SOURCE_UNIT,
            # Reflecting source Y changes the handedness of the ground plane.
            # A positive source yaw therefore appears as a negative SketchUp yaw.
            'yaw' => -source_yaw_radians(prop),
            'scale' => source_scale(prop)
          }
        end

        def self.local_to_source(origin, yaw_radians, scale, anchor)
          # Reverse the handedness correction applied by source_to_local.
          half_yaw = -yaw_radians / 2.0
          {
            'Rotation' => {
              'X' => 0.0,
              'Y' => 0.0,
              'Z' => Math.sin(half_yaw),
              'W' => Math.cos(half_yaw)
            },
            'Translation' => {
              'X' => anchor['x'] + (origin['x'] / INCHES_PER_SOURCE_UNIT),
              'Y' => anchor['y'] - (origin['y'] / INCHES_PER_SOURCE_UNIT),
              'Z' => anchor['z'] + (origin['z'] / INCHES_PER_SOURCE_UNIT)
            },
            'Scale3D' => {
              'X' => scale['x'],
              'Y' => scale['y'],
              'Z' => scale['z']
            }
          }
        end

        def self.hash_value(hash, key)
          return nil unless hash.is_a?(Hash)
          return hash[key] if hash.key?(key)
          found = hash.keys.find { |candidate| candidate.to_s.downcase == key.downcase }
          found ? hash[found] : nil
        end

        def self.number_value(hash, *keys)
          number_value_with_default(hash, 0.0, *keys)
        end

        def self.number_value_with_default(hash, default_value, *keys)
          keys.each do |key|
            value = hash_value(hash, key)
            next if value.nil?
            begin
              return Float(value)
            rescue ArgumentError, TypeError
              next
            end
          end
          default_value
        end
      end
    end
  end
end
