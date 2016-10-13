class Spree::WalletController < ApplicationController

  before_filter :authenticate_spree_user!

  def show
    @wallet = spree_current_user.wallet
    @payment_sources = spree_current_user.credit_cards.with_payment_profile

  end

  def credit_money
    exit
  end
end
