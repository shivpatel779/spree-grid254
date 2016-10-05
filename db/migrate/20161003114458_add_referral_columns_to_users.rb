class AddReferralColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :is_invited, :boolean, default: false
    add_column :spree_users, :referral_code, :string
  end
end