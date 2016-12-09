class RenameColumnPhoneUser < ActiveRecord::Migration
  def change
  	change_column :spree_users, :phone, :text  	
  end
end
