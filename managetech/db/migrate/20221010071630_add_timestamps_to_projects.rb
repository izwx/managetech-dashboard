class AddTimestampsToProjects < ActiveRecord::Migration[7.0]
  def change
    add_timestamps :projects, default: Time.zone.now
  end
end
