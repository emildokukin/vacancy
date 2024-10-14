class Job < ApplicationRecord
  has_many :applies
  has_many :geeks, through: :applies
  belongs_to :company, foreign_key: :company_id

  validates :name, :place, :company_id, presence: true
  validates :company_id, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :name, :place, length: { maximum: 50 }

end