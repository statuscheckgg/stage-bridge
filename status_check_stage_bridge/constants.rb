module StatusCheckGG
  module StageBridge
    VERSION = '0.1.0-beta.7'
    BRIDGE_SCHEMA_VERSION = 5

    VALIDATE_COMMAND_ENABLED = false
    EXPORT_COMMAND_ENABLED = false
    PREVIEW_DISABLED_REASON = 'This command is disabled in the public import-and-edit preview while prop mapping and Practisim reopen testing are completed.'

    MODEL_DICTIONARY = 'status_check_stage_bridge_model'
    ENTITY_DICTIONARY = 'status_check_stage_bridge_entity'

    ROLE_KEY = 'role'
    ROLE_STAGE_ROOT = 'stage_root'
    ROLE_STAGE_REFERENCE = 'stage_reference'
    ROLE_PROP = 'prop'

    TRANSFORM_PROFILE = 'practisim-0.01005m-source-flip-y-negate-yaw-ground-offset-adjustable-endpoint-v3'
  end
end
