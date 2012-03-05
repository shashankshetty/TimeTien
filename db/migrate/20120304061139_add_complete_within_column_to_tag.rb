class AddCompleteWithinColumnToTag < ActiveRecord::Migration
  def change
    add_column :tags, :complete_within, :boolean
  end
end
