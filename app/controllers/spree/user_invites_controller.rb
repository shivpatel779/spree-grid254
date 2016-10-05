class Spree::UserInvitesController < ApplicationController

  before_filter :authenticate_spree_user!
  before_filter :split_emails, only: :create

  def index

  end

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      user = spree_current_user
      @users.each{|u| user.send_invite(u) }
      user.deduct_invite_credit(@users.size)
    end
    redirect_to root_url
  end

  private

  def split_emails
    @users = params[:email_address].split(' ')
  end

end
