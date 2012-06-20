class AddAdditionalTimeSpentColumnToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :additional_time_spent, :integer
    add_column :tasks, :task_type, :string, :default => 'wt'
  end
end
