class RemoveDefaultTimestamps < ActiveRecord::Migration[7.0]
  def change
    change_column_default :companies, :created_at, nil
    change_column_default :companies, :updated_at, nil
    change_column_default :projects, :created_at, nil
    change_column_default :projects, :updated_at, nil
    change_column_default :developers, :created_at, nil
    change_column_default :developers, :updated_at, nil
    change_column_default :teams, :created_at, nil
    change_column_default :teams, :updated_at, nil
    change_column_default :sprints, :created_at, nil
    change_column_default :sprints, :updated_at, nil
  end
end
