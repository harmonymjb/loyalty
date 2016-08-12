class AddDefaultValueToStore < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :default_value, :integer, :default => 1
  end
end
