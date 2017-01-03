class Spree::Admin::SellersController < Spree::Admin::BaseController

  before_filter :normalize_phone, only: :create

  def index
    @sellers = Spree::Seller.all
  end

  def get_constituencies
    state = Spree::State.find(params[:state_id])
    respond_to do |format|
      format.json {render json: {constituencies: state.constituencies.select('id, name')}}
    end

  end

  def get_locations    
    constituency = locations params[:constituency_id]
    respond_to do |format|
      format.json {render json: {locations: constituency.locations.select('id, name')}}
    end
  end

  def locations id
    Spree::Constituency.find(id)
  end

  def new
    @seller = Spree::Seller.new
  end

  def create
    update_params
    update_params_phone
    update_params_contact_phone
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

      if params[:address_option] == false

      end

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
          p address.errors.inspect
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

  def update_params
    hash = {}
    params[:seller][:email].map{|k,v| hash[v[:type]] = v[:phone] }
    params[:seller][:email] = hash
  end

  def update_params_phone
    hash = {}
    params[:seller][:phone_number].map{|k,v| hash[v[:type_phone]] = v[:phone1] }  
    params[:seller][:phone_number] = hash
  end

  def update_params_contact_phone
    hash = {}
    params[:seller][:contact_person_phone].map{|k,v| hash[v[:type_contact]] = v[:phone2] }
    params[:seller][:contact_person_phone] = hash

  end
  
  def seller_params
    params.require(:seller).permit(:name)
  end

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
