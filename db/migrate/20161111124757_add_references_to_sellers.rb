class AddReferencesToSellers < ActiveRecord::Migration
  def change
    add_column :spree_store_locations, :seller_id, :integer, index: true, foreign_key: true
    add_column :spree_store_locations, :phone, :string
  end
end
