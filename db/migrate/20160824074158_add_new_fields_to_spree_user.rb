class AddNewFieldsToSpreeUser < ActiveRecord::Migration
  def self.up
  	add_column :spree_users, :first_name, :string
  	add_column :spree_users, :middle_name, :string
  	add_column :spree_users, :last_name, :string
  	add_column :spree_users, :birth_date, :date
  	add_column :spree_users, :national_id, :string
  	add_column :spree_users, :phone, :string
  	add_column :spree_users, :constituency, :string

    change_table :spree_users do |t|
      t.references :spree_country, index: true, foreign_key: true
      t.references :spree_state, index: true, foreign_key: true
    end

  end


end