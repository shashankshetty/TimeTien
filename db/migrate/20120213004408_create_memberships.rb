class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :project_id
      t.integer :user_id
      t.boolean :is_admin, :default => false
      t.boolean :accepted, :default => false

      t.timestamps
    end
  end
end
