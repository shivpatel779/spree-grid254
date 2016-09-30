class CreateSpreeWalletTransactions < ActiveRecord::Migration
  def change
    create_table :spree_wallet_transactions do |t|
      t.references :spree_user_wallet, index: true, foreign_key: true
      t.references :order
      t.decimal :payment_amount

      t.timestamps null: false
    end
  end
end
