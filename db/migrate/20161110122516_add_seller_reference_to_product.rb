class AddSellerReferenceToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :seller_id, :integer, index: true, foreign_key: true
  end
end
