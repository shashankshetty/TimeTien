class AddNameAndUserUniquenessIndexToTags < ActiveRecord::Migration
  def self.up
    add_index :tags, [:name, :user_id], :unique => true
  end

  def self.down
    remove_index :users, [:name, :user_id]
  end
end
