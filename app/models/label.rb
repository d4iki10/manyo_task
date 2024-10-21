class Label < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  has_many :labelings, dependent: :destroy
  has_many :tasks, through: :labelings
end
