class AddTermsConditionProduct < ActiveRecord::Migration
  def change
  	add_column :spree_products, :terms_conditions, :text
  end
end
