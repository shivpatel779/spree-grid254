class Spree::UserWallet < ActiveRecord::Base
  belongs_to :user, class_name: Spree.user_class.to_s, foreign_key: 'user_id'
  has_many :wallet_transactions, :class_name => 'Spree::WalletTransaction', foreign_key: :spree_user_wallet_id
end