class Account < ApplicationRecord
  belongs_to :user
  belongs_to :store
  has_many :points_transactions, dependent: :destroy
end
