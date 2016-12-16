class AddColumnInSeller < ActiveRecord::Migration
  def change
  	add_column :spree_sellers, :contact_person, :string 
  	add_column :spree_sellers, :contact_email, :string
  	add_column :spree_sellers, :contact_person_phone, :text 
  end
end
