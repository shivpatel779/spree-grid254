class AddStateNameToSellerAddresses < ActiveRecord::Migration
  def change
    add_column :spree_seller_addresses, :state_name, :string
  end
end
