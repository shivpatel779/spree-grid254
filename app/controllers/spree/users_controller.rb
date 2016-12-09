class Spree::UsersController < Spree::StoreController
  skip_before_filter :set_current_order, :only => :show
  prepend_before_filter :load_object, :only => [:show, :edit, :update]
  prepend_before_filter :authorize_actions, :only => :new

  include Spree::Core::ControllerHelpers

  def show
    @orders = @user.orders.complete.order('completed_at desc')
  end

  def edit

  end

  def create

    @user = Spree::User.new(user_params)
    if @user.save
      session[:guest_token] = nil if current_order
      redirect_back_or_default(root_url)
    else
      render :new
    end
  end

  def update
    if params.key?(:personal_detail)

      pd_params = params[:personal_detail]

      dob = Date.new pd_params['date_of_birth(1i)'].to_i, pd_params['date_of_birth(2i)'].to_i, pd_params['date_of_birth(3i)'].to_i
      params[:personal_detail][:date_of_birth] = dob.to_formatted_s(:db)

      params[:personal_detail].delete('date_of_birth(1i)')
      params[:personal_detail].delete('date_of_birth(2i)')
      params[:personal_detail].delete('date_of_birth(3i)')

      params.permit!
      #personal_detail = spree_current_user.personal_detail.nil? ? Spree::PersonalDetail.new(user_id: spree_current_user.id) : spree_current_user.personal_detail
      if @personal_detail.update_attributes(params[:personal_detail])
        redirect_to spree.edit_account_url+'#tab3', :notice => 'Personal info updated successfully'
      else
        render :edit
      end

    elsif params.key?(:location_info)
      params.permit!
      location_info   = spree_current_user.location_info.nil? ? Spree::LocationInfo.new(user_id: spree_current_user.id) : spree_current_user.location_info
      if location_info.update_attributes(params[:location_info])
        redirect_to spree.edit_account_url, :notice => 'Location info updated successfully'
      else
        redirect_to spree.edit_account_url+'#tab3'
      end

    else
      if params[:user][:password].present?
        @user.update_attributes(phone:params[:user][:phone])
        if @user.update_attributes(user_params)
          if params[:user][:password].present?
            # this logic needed b/c devise wants to log us out after password changes
            user = Spree::User.reset_password_by_token(params[:user])
            sign_in(@user, :event => :authentication, :bypass => !Spree::Auth::Config[:signout_after_password_change])
          end
          # redirect_to spree.account_url, :notice => Spree.t(:account_updated)
          redirect_to spree.edit_account_url+'#tab2', :notice => Spree.t(:account_updated)
        else
          redirect_to spree.edit_account_url
        end

      else
        if @user.update_without_password(user_params)
          @user.update_attributes(phone:params[:user][:phone])
          if params[:user][:password].present?
            # this logic needed b/c devise wants to log us out after password changes
            user = Spree::User.reset_password_by_token(params[:user])
            sign_in(@user, :event => :authentication, :bypass => !Spree::Auth::Config[:signout_after_password_change])
          end
          # redirect_to spree.account_url, :notice => Spree.t(:account_updated)
          redirect_to spree.edit_account_url+'#tab2', :notice => Spree.t(:account_updated)
        else
          render :edit
        end
      end
    end

  end

  private
  def user_params
    params.require(:user).permit(:mobile)
  end

  def load_object
    @user ||= spree_current_user
    @personal_detail = spree_current_user.personal_detail.nil? ? Spree::PersonalDetail.new(user: spree_current_user) : spree_current_user.personal_detail
    @location_info   = spree_current_user.location_info.nil? ? Spree::LocationInfo.new(user: spree_current_user) : spree_current_user.location_info

    authorize! params[:action].to_sym, @user
  end

  def authorize_actions
    authorize! params[:action].to_sym, Spree::User.new
  end

  def accurate_title
    Spree.t(:my_account)
  end

end
