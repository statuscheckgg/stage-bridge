module StatusCheckGG
  module StageBridge
    module Core
      module Catalog
        ENTRIES = [
          {
            :key => 'faultline_adjustable', :display => 'Fault Line - Adjustable', :prop_name => 'faultline-adjustable',
            :aliases => ['faultline-adjustable'], :builder => :adjustable_faultline, :custom_color => true,
            :dimensions => [Transform::ADJUSTABLE_MESH_INCHES, Transform::ADJUSTABLE_MESH_INCHES, Transform::ADJUSTABLE_MESH_INCHES],
            :color => [235, 196, 35], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'faultline_2m', :display => 'Fault Line - 2 m', :prop_name => 'faultline-2m',
            :aliases => ['faultline-2m'], :builder => :box, :dimensions => [78.7401574803, 3.5, 1.5],
            :color => [235, 196, 35], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'faultline_4ft', :display => 'Fault Line - 4 ft', :prop_name => 'faultline-4ft',
            :aliases => ['faultline-4ft'], :builder => :box, :dimensions => [48.0, 3.5, 1.5],
            :color => [235, 196, 35], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'faultline_6ft', :display => 'Fault Line - 6 ft', :prop_name => 'faultline-6ft',
            :aliases => ['faultline-6ft'], :builder => :box, :dimensions => [72.0, 3.5, 1.5],
            :color => [235, 196, 35], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'faultline_8ft', :display => 'Fault Line - 8 ft', :prop_name => 'faultline-8ft',
            :aliases => ['faultline-8ft'], :builder => :box, :dimensions => [96.0, 3.5, 1.5],
            :color => [235, 196, 35], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'faultline_10ft', :display => 'Fault Line - 10 ft', :prop_name => 'faultline-10ft',
            :aliases => ['faultline-10ft'], :builder => :box, :dimensions => [120.0, 3.5, 1.5],
            :color => [235, 196, 35], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'wall_4ft', :display => 'Wall - 4 x 6 ft', :prop_name => 'wall-targetsusa-4ft-frame',
            :aliases => ['wall-targetsusa-4ft-frame', 'wall-targetsusa-4ft', 'wall-short-brown', 'wall-short-color'],
            :builder => :wall, :dimensions => [48.0, 2.0, 72.0], :color => [218, 126, 48],
            :asset => 'wall_base.skp', :asset_scale => [0.9230769231, 1.0, 0.75],
            :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'wall_8ft', :display => 'Wall - 8 x 6 ft', :prop_name => 'wall-targetsusa-8ft-frame',
            :aliases => ['wall-targetsusa-8ft-frame', 'wall-targetsusa-8ft', 'wall-med-brown', 'wall-med-color'],
            :builder => :wall, :dimensions => [96.0, 2.0, 72.0], :color => [218, 126, 48],
            :asset => 'wall_base.skp', :asset_scale => [1.8461538462, 1.0, 0.75],
            :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'wall_metric_1x2', :display => 'Wall - 1 x 2 m', :prop_name => 'wall-metric-1x2',
            :aliases => ['wall-metric-1x2'], :builder => :wall, :dimensions => [39.3700787402, 2.0, 78.7401574803],
            :color => [218, 126, 48], :asset => 'wall_base.skp',
            :asset_scale => [0.757117, 1.0, 0.82021], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'wall_metric_2x2', :display => 'Wall - 2 x 2 m', :prop_name => 'wall-metric-2x2',
            :aliases => ['wall-metric-2x2'], :builder => :wall, :dimensions => [78.7401574803, 2.0, 78.7401574803],
            :color => [218, 126, 48], :asset => 'wall_base.skp',
            :asset_scale => [1.514234, 1.0, 0.82021], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'wall_metric_3x2', :display => 'Wall - 3 x 2 m', :prop_name => 'wall-metric-3x2',
            :aliases => ['wall-metric-3x2'], :builder => :wall, :dimensions => [118.11023622, 2.0, 78.7401574803],
            :color => [218, 126, 48], :asset => 'wall_base.skp',
            :asset_scale => [2.27135, 1.0, 0.82021], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'uspsa_target', :display => 'USPSA Paper Target', :prop_name => 'uspsa-full-target',
            :aliases => ['uspsa-full-target', 'uspsa-target'],
            :builder => :target, :dimensions => [18.125, 1.0, 30.0], :color => [181, 133, 87],
            :asset => 'uspsa_target_high.skp',
            :paper => 1, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'uspsa_target_short', :display => 'USPSA Paper Target - Short', :prop_name => 'uspsa-full-target-short',
            :aliases => ['uspsa-full-target-short'], :builder => :target, :dimensions => [18.125, 1.0, 30.0],
            :color => [181, 133, 87], :asset => 'uspsa_target_short.skp',
            :paper => 1, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'uspsa_target_short_tilted', :display => 'USPSA Paper Target - Short Tilted',
            :prop_name => 'uspsa-full-short-tilted', :aliases => ['uspsa-full-short-tilted'],
            :builder => :target, :dimensions => [18.125, 1.0, 30.0], :color => [181, 133, 87],
            :asset => 'uspsa_target_short_tilted.skp', :paper => 1, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'uspsa_no_shoot', :display => 'USPSA No-Shoot', :prop_name => 'uspsa-noshoot',
            :aliases => ['uspsa-noshoot', 'uspsa-noshoot-onstand'], :builder => :target,
            :dimensions => [18.125, 1.0, 30.0], :color => [245, 245, 240],
            :asset => 'uspsa_no_shoot_high.skp',
            :paper => 0, :steel => 0, :no_shoot => 1
          },
          {
            :key => 'uspsa_swinger', :display => 'USPSA Paper Swinger', :prop_name => 'uspsa-swinger',
            :aliases => ['uspsa-swinger', 'uspsa-swinger-right'], :builder => :swinger,
            :dimensions => [18.125, 18.0, 30.0], :color => [181, 133, 87],
            :paper => 1, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'uspsa_popper', :display => 'USPSA Popper', :prop_name => 'uspsa-popper',
            :aliases => ['uspsa-popper', 'uspsa-full-popper', 'ipsc-popper', 'ipsc-full-popper'],
            :builder => :popper, :dimensions => [12.0, 1.0, 42.0], :color => [170, 175, 180],
            :paper => 0, :steel => 1, :no_shoot => 0
          },
          {
            :key => 'uspsa_mini_popper', :display => 'USPSA Mini Popper', :prop_name => 'uspsa-mini-popper',
            :aliases => ['uspsa-mini-popper', 'uspsa-popper-mini', 'ipsc-mini-popper', 'ipsc-popper-mini'],
            :builder => :popper, :dimensions => [8.0, 1.0, 28.0], :color => [65, 115, 190],
            :paper => 0, :steel => 1, :no_shoot => 0
          },
          {
            :key => 'barrel', :display => 'Plastic Barrel', :prop_name => 'barrel-plastic',
            :aliases => ['barrel-plastic'], :builder => :cylinder, :dimensions => [23.5, 23.5, 36.0],
            :asset => 'barrel.skp',
            :color => [35, 95, 180], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'barrel_stack', :display => 'Plastic Barrel Stack', :prop_name => 'barrel-plastic-stack',
            :aliases => ['barrel-plastic-stack'], :builder => :cylinder, :dimensions => [23.5, 23.5, 72.0],
            :asset => 'barrel_stack.skp',
            :color => [35, 95, 180], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'start_position', :display => 'Start Position', :prop_name => 'start-position',
            :aliases => ['start-position'], :builder => :box, :dimensions => [24.0, 24.0, 0.25],
            :asset => 'start_position.skp', :asset_scale => [0.6666666667, 0.6666666667, 0.25],
            :color => [30, 210, 220], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'double_x_start', :display => 'Start Position - Double X', :prop_name => 'ssi-double-x-start-box',
            :aliases => ['ssi-double-x-start-box'], :builder => :double_x_start,
            :dimensions => [28.0, 12.0, 0.25], :color => [220, 35, 45],
            :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'folding_table', :display => 'Folding Table', :prop_name => 'folding-table',
            :aliases => ['folding-table'], :builder => :table, :dimensions => [84.0, 36.0, 36.0],
            :color => [145, 150, 155], :paper => 0, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'two_stack_hc', :display => 'Two-Stack Paper / Hard Cover', :prop_name => 'uspsa-two-stack-hc',
            :aliases => ['uspsa-two-stack-hc'], :builder => :stacked_target, :dimensions => [18.125, 1.0, 60.0],
            :color => [181, 133, 87], :paper => 2, :steel => 0, :no_shoot => 0
          },
          {
            :key => 'two_stack_no_shoot', :display => 'Two-Stack Paper / No-Shoot', :prop_name => 'uspsa-two-stack-noshoot',
            :aliases => ['uspsa-two-stack-noshoot', 'uspsa-two-noshoot-vert'], :builder => :stacked_target,
            :dimensions => [18.125, 1.0, 60.0], :color => [225, 220, 205],
            :paper => 2, :steel => 0, :no_shoot => 1
          }
        ]

        def self.entries
          ENTRIES
        end

        def self.by_key(key)
          ENTRIES.find { |entry| entry[:key] == key }
        end

        def self.by_display(display)
          ENTRIES.find { |entry| entry[:display] == display }
        end

        def self.for_prop_name(prop_name)
          normalized = prop_name.to_s.downcase
          ENTRIES.find do |entry|
            entry[:aliases].any? { |candidate| candidate.downcase == normalized }
          end
        end

        def self.scoring_counts(props)
          totals = { 'paper' => 0, 'steel' => 0, 'no_shoot' => 0 }
          props.each do |prop|
            entry = for_prop_name(prop['propName'])
            next if entry.nil?
            totals['paper'] += entry[:paper]
            totals['steel'] += entry[:steel]
            totals['no_shoot'] += entry[:no_shoot]
          end
          totals
        end

        def self.new_prop(entry, unique_id)
          {
            'propName' => entry[:prop_name],
            'uniqueID' => unique_id,
            'activateIDs' => [],
            'groupID' => [],
            'customText' => '',
            'width' => 1,
            'height' => 1,
            'depth' => 1,
            'propTransform' => {
              'Rotation' => { 'X' => 0.0, 'Y' => 0.0, 'Z' => 0.0, 'W' => 1.0 },
              'Translation' => { 'X' => 0.0, 'Y' => 0.0, 'Z' => 0.0 },
              'Scale3D' => { 'X' => 1.0, 'Y' => 1.0, 'Z' => 1.0 }
            }
          }
        end
      end
    end
  end
end
