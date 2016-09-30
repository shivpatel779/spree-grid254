class CreateSpreeUserWallets < ActiveRecord::Migration
  def change
    create_table :spree_user_wallets do |t|
      t.decimal :wallet_balance
      t.references :user

      t.timestamps null: false
    end
  end
end
