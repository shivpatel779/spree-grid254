class ChangedatatypeToseller < ActiveRecord::Migration
  def change
  	change_column :spree_sellers, :email, :text  	
  end
end
