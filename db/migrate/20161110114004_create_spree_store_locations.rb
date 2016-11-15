class CreateSpreeStoreLocations < ActiveRecord::Migration
  def change
    create_table :spree_store_locations do |t|
      t.integer :country_id, index: true, foreign_key: true
      t.integer :state_id, index: true, foreign_key: true
      t.string :constituency
      t.string :address1
      t.string :address2
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
