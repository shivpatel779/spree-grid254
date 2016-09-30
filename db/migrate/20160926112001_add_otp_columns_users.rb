class AddOtpColumnsUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :otp_secret, :string
    add_column :spree_users, :current_otp, :string
    add_column :spree_users, :phone_verified, :boolean, default: false
  end
end
