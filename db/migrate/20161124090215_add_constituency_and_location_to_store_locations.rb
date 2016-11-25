class AddConstituencyAndLocationToStoreLocations < ActiveRecord::Migration
  def change
    add_column :spree_store_locations, :constituency_id, :integer
    add_column :spree_store_locations, :location_id, :integer
    #add_column :spree_store_locations, :latitude, :float
    #add_column :spree_store_locations, :longitude, :float
  end
end
