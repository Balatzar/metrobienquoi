class CreateItineraries < ActiveRecord::Migration[8.0]
  def change
    create_table :itineraries do |t|
      t.references :start_station, null: false, foreign_key: { to_table: :stations }
      t.references :end_station, null: false, foreign_key: { to_table: :stations }
      t.integer :distance
      t.integer :duration
      t.timestamps
    end
  end
end
