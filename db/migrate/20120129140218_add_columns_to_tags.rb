class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :tags, :user_id, :integer

    add_column :tags, :time_allocated, :integer

    add_column :tags, :pay_rate, :decimal, :precision => 6, :scale => 2

    add_column :tags, :pay_currency, :string

    add_column :tags, :frequency, :string
  end
end
