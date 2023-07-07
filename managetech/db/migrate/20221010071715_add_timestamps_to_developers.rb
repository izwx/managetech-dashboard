class AddTimestampsToDevelopers < ActiveRecord::Migration[7.0]
  def change
    add_timestamps :developers, default: Time.zone.now
  end
end
