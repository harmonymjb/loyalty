class PointsTransaction < ApplicationRecord
  belongs_to :account
  validates :value, numericality: {only_integer: true}
end
