class Apply < ApplicationRecord
  belongs_to :job, foreign_key: :job_id
  belongs_to :geek, foreign_key: :geek_id


end