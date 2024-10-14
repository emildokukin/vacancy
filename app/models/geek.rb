class Geek < ApplicationRecord
  has_many :applies
  has_many :jobs, through: :applies
end