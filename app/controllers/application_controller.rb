class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :initialize_user_data

  def initialize_user_data
    if spree_current_user
      spree_current_user.create_wallet if spree_current_user.wallet.nil?
      spree_current_user.create_referral_credit if spree_current_user.spree_referral_credit.nil?
    end
  end

end
