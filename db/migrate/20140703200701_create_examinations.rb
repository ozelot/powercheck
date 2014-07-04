class CreateExaminations < ActiveRecord::Migration
  def change
    create_table :examinations do |t|
      t.integer :device_id
      t.boolean :result
      t.datetime :date

      t.timestamps
    end
  end
end
