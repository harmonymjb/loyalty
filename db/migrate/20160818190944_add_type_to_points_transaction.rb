class AddTypeToPointsTransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :points_transactions, :trans_type, :string, :default => "credit"
  end
end
