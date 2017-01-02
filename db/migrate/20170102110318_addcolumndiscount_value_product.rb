class AddcolumndiscountValueProduct < ActiveRecord::Migration
  def change
  	add_column :spree_products, :discount_value, :float
  end
end
