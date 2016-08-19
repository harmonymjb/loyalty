class Reward < ApplicationRecord
  belongs_to :store
  validates :name, :value, presence: true
  validates :value, numericality: {greater_than_or_equal_to: 0}
end
