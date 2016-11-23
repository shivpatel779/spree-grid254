class AddPostalCodeAndLocationToSellerAddresses < ActiveRecord::Migration
  def change
    add_column :spree_seller_addresses, :zipcode, :string
    add_column :spree_seller_addresses, :location, :string
  end
end
