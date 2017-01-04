class Spree::Admin::StoreLocationController < Spree::Admin::BaseController

#  before_action :set_country, only: :new

  def index
    @store_locations = Spree::StoreLocation.all
  end

  def new
    @store_location = Spree::StoreLocation.new
    @store_location.country = default_country
  end

  def create
    
    params[:store_location].permit!
    @store_location = Spree::StoreLocation.new(params[:store_location])
    if @store_location.save
      flash.now[:success] = flash_message_for(@store_location, :successfully_created)
      render :edit
    else
      render :new
    end
  end

  def edit
    @store_location = Spree::StoreLocation.find(params[:id])
  end

  def update
    params[:store_location].permit!
    @store_location = Spree::StoreLocation.find(params[:id])
    if params[:store_location][:longitude].present?
      params[:store_location][:address1] = params[:map_address]
    end
    if @store_location.update_attributes(params[:store_location])
      flash.now[:success] = Spree.t(:account_updated)
    end
    render :edit
  end

  def delete
  end

  private

  def set_country
    @store_location.country = default_country
  rescue ActiveRecord::RecordNotFound
    flash[:error] = Spree.t(:stock_locations_need_a_default_country)
    redirect_to admin_stock_locations_path
  end

  def default_country
    Spree::Country.find_by(name:"Kenya")
  end

end
