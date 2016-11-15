class AddMoreAttributesToStoreLocations < ActiveRecord::Migration
  def change
    add_column :spree_store_locations, :state_name, :string
    add_column :spree_store_locations, :city, :string
    add_column :spree_store_locations, :zipcode, :string
    add_column :spree_store_locations, :active, :boolean
    add_column :spree_store_locations, :name, :string

  end
end
