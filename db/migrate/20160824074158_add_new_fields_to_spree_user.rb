class AddNewFieldsToSpreeUser < ActiveRecord::Migration
  def self.up
  	add_column :spree_users, :first_name, :string
  	add_column :spree_users, :middle_name, :string
  	add_column :spree_users, :last_name, :string
  	add_column :spree_users, :birth_date, :date
  	add_column :spree_users, :national_id, :string
  	add_column :spree_users, :phone, :string
  	add_column :spree_users, :country, :string
  	add_column :spree_users, :state, :string
  	add_column :spree_users, :constituency, :string
  end

  def self.down
  	remove_column :spree_users, :first_name
  	remove_column :spree_users, :middle_name
  	remove_column :spree_users, :last_name
  	remove_column :spree_users, :birth_date
  	remove_column :spree_users, :national_id
  	remove_column :spree_users, :phone
  	remove_column :spree_users, :country
  	remove_column :spree_users, :state
  	remove_column :spree_users, :constituency
  end
end