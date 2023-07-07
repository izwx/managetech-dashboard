class ToolMasterSerializer < ActiveModel::Serializer
  attributes :id, :tool_name, :token_guide, :target_guide, :payload_guide, :account_name_guide
end
