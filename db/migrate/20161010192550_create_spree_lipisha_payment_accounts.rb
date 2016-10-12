class CreateSpreeLipishaPaymentAccounts < ActiveRecord::Migration
  def change
    create_table :spree_lipisha_payment_accounts do |t|
      t.string :account_num
      t.string :account_name
      t.string :account_manager
      t.references :user
      t.timestamps null: false
    end
  end
end
