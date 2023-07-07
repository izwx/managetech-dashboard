class DeveloperToolMap < ApplicationRecord
  belongs_to :tool_master, foreign_key: :tool_id, optional: true
  belongs_to :developer

  accepts_nested_attributes_for :developer

  def tool_name
    self.tool_master.tool_name
  end

  def token_guide
    self.tool_master.token_guide
  end

  def target_guide
    self.tool_master.target_guide
  end

  def payload_guide
    self.tool_master.payload_guide
  end

  def account_name_guide
    self.tool_master.account_name_guide
  end
end
