class AddTimeOutColumnToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :time_out, :integer
  end
end
