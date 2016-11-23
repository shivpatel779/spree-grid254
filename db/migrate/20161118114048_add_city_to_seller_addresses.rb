class AddCityToSellerAddresses < ActiveRecord::Migration
  def change
    add_column :spree_seller_addresses, :city, :string
  end
end
