class DeveloperToolMapSerializer < ActiveModel::Serializer
  attributes :id, :developer_id, :tool_id, :tool_name, :token_guide, :target_guide, :payload_guide, :account_name_guide, :account_name
end
