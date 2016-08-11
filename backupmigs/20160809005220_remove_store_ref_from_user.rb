class RemoveStoreRefFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :users, name: "fk_rails_c6f326481e"
  end
end
