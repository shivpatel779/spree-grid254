class AddgiftvaluescolumnToProduct < ActiveRecord::Migration
  def change
  	add_column :spree_products, :giveaway_status, :boolean, default: false 
  	add_column :spree_products, :giveaway_name, :string
  	add_column :spree_products, :giveaway_description, :text
  	add_column :spree_products, :giveaway_value, :float
  end
end
