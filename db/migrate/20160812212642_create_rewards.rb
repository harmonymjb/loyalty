class CreateRewards < ActiveRecord::Migration[5.0]
  def change
    create_table :rewards do |t|
      t.string :name
      t.text :description
      t.integer :value
      t.references :store, foreign_key: true

      t.timestamps
    end
  end
end
