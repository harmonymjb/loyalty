class CreatePointsTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :points_transactions do |t|
      t.integer :value
      t.boolean :approved, :default => false

      t.timestamps
    end
  end
end
