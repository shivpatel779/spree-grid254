class CreateSpreeReferralCredits < ActiveRecord::Migration
  def change
    create_table :spree_referral_credits do |t|
      t.references :user
      t.integer :credit, default: 10
      t.timestamps null: false
    end
  end
end
