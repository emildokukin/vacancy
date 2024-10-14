class AddGeekIdAndJobIdToApply < ActiveRecord::Migration[7.2]
  def change
    add_column :applies, :geek_id, :integer
    add_column :applies, :job_id, :integer
  end
end
