class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :tag_id

      t.timestamps
    end
  end
end
