class UpdateStationsStructure < ActiveRecord::Migration[8.0]
  def change
    # Remove old columns
    remove_column :stations, :rang
    remove_column :stations, :reseau
    remove_column :stations, :trafic
    remove_column :stations, :correspondance_1
    remove_column :stations, :correspondance_2
    remove_column :stations, :correspondance_3
    remove_column :stations, :correspondance_4
    remove_column :stations, :correspondance_5
    remove_column :stations, :ville
    remove_column :stations, :arrondissement_pour_paris

    # Add new columns
    add_column :stations, :external_id, :string
    add_column :stations, :version, :string
    add_column :stations, :station_type, :string
    add_column :stations, :x_coord, :decimal, precision: 10, scale: 2
    add_column :stations, :y_coord, :decimal, precision: 10, scale: 2
    add_column :stations, :city, :string
    add_column :stations, :postal_code, :string
    add_column :stations, :accessibility, :boolean
    add_column :stations, :audible_signals, :string
    add_column :stations, :visual_signs, :string
    add_column :stations, :fare_zone, :integer
    add_column :stations, :zda_id, :string
    add_column :stations, :latitude, :decimal, precision: 10, scale: 8
    add_column :stations, :longitude, :decimal, precision: 10, scale: 8

    add_index :stations, :external_id, unique: true
  end
end
