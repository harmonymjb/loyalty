class AddStoreRefToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :store, foreign_key: true
  end
end
