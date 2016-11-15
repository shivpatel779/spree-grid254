class ChangeSellerIdTypeIntoProducts < ActiveRecord::Migration
  def change
    change_column :spree_products, :seller_id, :string
  end
end
