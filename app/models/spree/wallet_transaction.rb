class Spree::WalletTransaction < ActiveRecord::Base
  belongs_to :spree_user_wallet
  belongs_to :order
end
