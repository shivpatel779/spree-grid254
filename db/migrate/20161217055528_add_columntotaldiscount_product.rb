class AddColumntotaldiscountProduct < ActiveRecord::Migration
  def change
  	add_column :spree_products, :total_discount, :float
  end
end
