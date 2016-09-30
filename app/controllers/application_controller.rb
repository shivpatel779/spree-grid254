class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :create_user_wallet_if_missing

  def create_user_wallet_if_missing
    if spree_current_user
      spree_current_user.create_wallet if spree_current_user.wallet.nil?
    end
  end

end
