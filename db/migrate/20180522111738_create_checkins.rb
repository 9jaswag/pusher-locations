class CreateCheckins < ActiveRecord::Migration[5.1]
  def change
    create_table :checkins do |t|
      t.references :trip, foreign_key: true
      t.decimal :lat
      t.decimal :long

      t.timestamps
    end
  end
end
