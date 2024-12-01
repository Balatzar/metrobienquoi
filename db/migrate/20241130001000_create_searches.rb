class CreateSearches < ActiveRecord::Migration[8.0]
  def change
    create_table :searches do |t|
      t.timestamps
    end

    create_table :searches_stations do |t|
      t.belongs_to :search, null: false, foreign_key: true
      t.belongs_to :station, null: false, foreign_key: true
      t.timestamps
    end

    add_index :searches_stations, [ :search_id, :station_id ], unique: true
  end
end
