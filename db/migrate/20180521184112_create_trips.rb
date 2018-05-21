class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.decimal :long
      t.decimal :lat
      t.string :name
      t.string :uuid

      t.timestamps
    end
    add_index :trips, :uuid
  end
end
