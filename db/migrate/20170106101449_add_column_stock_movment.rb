class AddColumnStockMovment < ActiveRecord::Migration
  def change
  	add_column :spree_stock_movements, :message, :string
  	add_column :spree_stock_movements, :product_id, :integer
  	add_column :spree_stock_movements, :store_location_id, :integer
  end
end
