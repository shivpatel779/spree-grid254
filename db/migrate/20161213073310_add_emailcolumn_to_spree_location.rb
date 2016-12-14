class AddEmailcolumnToSpreeLocation < ActiveRecord::Migration
  def change
  	add_column :spree_store_locations, :email, :text
  	add_column :spree_store_locations, :contact_person, :string
  end
end
