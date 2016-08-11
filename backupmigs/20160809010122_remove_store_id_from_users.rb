class RemoveStoreIdFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :store_id
  end
end
