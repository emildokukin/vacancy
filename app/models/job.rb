class Job < ApplicationRecord
  has_many :applies
  belongs_to :company, foreign_key: :company_id
  # accepts_nested_attributes_for :company, :reject_if => :all_blank

  validates :name, :place, :company_id, presence: true#, on: [:create, :update]
  validates :company_id, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :name, :place, length: { maximum: 50 }

end