class Account < ApplicationRecord
  belongs_to :user
  belongs_to :store
  has_many :points_transactions, dependent: :destroy
  validates :value, numericality: {greater_than_or_equal_to: 0}
end
