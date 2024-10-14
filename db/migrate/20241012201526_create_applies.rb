class CreateApplies < ActiveRecord::Migration[7.2]
  def change
    create_table :applies do |t|
      t.boolean :read
      t.boolean :invited

      t.timestamps
    end
  end
end
