class CreateGeeks < ActiveRecord::Migration[7.2]
  def change
    create_table :geeks do |t|
      t.string :name
      t.string :stack
      t.string :resume

      t.timestamps
    end
  end
end
