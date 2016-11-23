class CreateSpreeLocations < ActiveRecord::Migration
  def change
    create_table :spree_locations do |t|
      t.references :spree_constituency, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
