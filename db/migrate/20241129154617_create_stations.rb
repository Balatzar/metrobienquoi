class CreateStations < ActiveRecord::Migration[8.0]
  def change
    create_table :stations do |t|
      t.integer :rang
      t.string :reseau
      t.string :name
      t.integer :trafic
      t.string :correspondance_1
      t.string :correspondance_2
      t.string :correspondance_3
      t.string :correspondance_4
      t.string :correspondance_5
      t.string :ville
      t.string :arrondissement_pour_paris

      t.timestamps
    end
  end
end
