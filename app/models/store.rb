class Store < ApplicationRecord
  belongs_to :user
  has_many :accounts, dependent: :destroy
  has_many :rewards, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :default_value, presence: true, numericality: {greater_than_or_equal_to: 0}
end
