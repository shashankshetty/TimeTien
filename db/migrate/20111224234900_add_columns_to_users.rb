class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string

    add_column :users, :display_name, :string

    add_column :users, :has_random_password, :boolean, :default => false
  end
end
