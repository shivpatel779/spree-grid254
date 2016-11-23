class Spree::Admin::SellersController < Spree::Admin::BaseController

  before_filter :normalize_phone, only: :create

  def index
    @sellers = Spree::Seller.all
  end

  def new
    @seller = Spree::Seller.new
  end

  def create
    params[:seller].permit!
    @seller = Spree::Seller.new(params[:seller])
    normalize_phone if @seller.valid?
    if @seller.save
      @address = @seller.build_address
      flash.now[:success] = flash_message_for(@seller, :successfully_created)
      render :edit
    else
      render :new
    end

  end

  def edit
    @seller = Spree::Seller.find(params[:id])
    @address = @seller.address.nil? ? @seller.build_address : @seller.address
    multiple_phone = @seller.phone.include?(',')
    old_ph = @seller.phone
    @seller.phone = multiple_phone ? old_ph.split(',')[0] : old_ph
    @seller.phone_2 = old_ph.split(',')[1].tr(' ','') if multiple_phone
    @seller
  end

  def update

    if params.key?('seller_address')

      # update address
      params[:seller_address].permit!
      @seller = Spree::Seller.find(params[:seller_address][:seller_id])
      address = @seller.address.nil? ? @seller.build_address : @seller.address
      if address.persisted?
        if address.update_attributes(params[:seller_address])
          flash.now[:error] = Spree.t(:address_updated)
        end
      else
        address.assign_attributes(params[:seller_address])
        if address.save
          flash.now[:success] = Spree.t(:account_updated)
        else
          flash.now[:error] = 'Error updating address'
        end
      end

    else

      # update seller info
      params[:seller].permit!
      @seller = Spree::Seller.find(params[:id])

      normalize_phone if params[:seller][:phone_2] != ''

      if @seller.update_attributes(params[:seller])
        flash.now[:success] = Spree.t(:account_updated)
      end

    end

    form_info

    render :edit
  end

  def delete
  end

  private

  def normalize_phone
    if params[:seller][:phone_2] != ''
      params[:seller][:phone] = "#{params[:seller][:phone]}, #{params[:seller][:phone_2]}"
    end
    params[:seller].delete(:phone_2)
  end

  def form_info
    multiple_phone = @seller.phone.include?(',')
    old_ph = @seller.phone
    @seller.phone = multiple_phone ? old_ph.split(',')[0] : old_ph
    @seller.phone_2 = old_ph.split(',')[1].tr(' ','') if multiple_phone
    @address = @seller.address.nil? ? @seller.build_address : @seller.address
  end

end
