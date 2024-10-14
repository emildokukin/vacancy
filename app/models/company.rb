class Company < ApplicationRecord
  has_many :jobs
  accepts_nested_attributes_for :jobs, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :jobs

  validates :name, :location, presence: true, on: [:create, :update]
  validates :name, :location, length: { maximum: 50 }

  def delete_company
    self.update(deleted: true)
  end
end