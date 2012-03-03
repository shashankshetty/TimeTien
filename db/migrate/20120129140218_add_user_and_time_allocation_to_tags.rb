class AddUserAndTimeAllocationToTags < ActiveRecord::Migration
  def change
    add_column :tags, :user_id, :integer

    add_column :tags, :time_allocated, :integer

    add_column :tags, :frequency, :string

  end
end
