Spree::ProductsController.class_eval do

  # def index
  #   @products = Spree::Product.where("LOWER(name) LIKE ?", ("%"+params[:keywords].downcase+"%"))
  #   @treding_deal_product = Spree::Product.where.not(total_discount:nil).order( 'total_discount desc').first(4)
  # end

  def favorite_a_product
    @product = Spree::Product.friendly.find(params[:id])
    @product.favorite(spree_current_user.id)
    @total_favorites = @product.total_favorites
    
    respond_to do |format|
      format.js
    end
  end

  def unfavorite_a_product
    @product = Spree::Product.friendly.find(params[:id])
    @product.unfavorite(spree_current_user.id)
    @total_favorites = @product.total_favorites

    respond_to do |format|
      format.js
    end
  end

  def product_detail
    @product = Spree::Product.find(params[:id])
    @message = @product.stock_movements.collect(&:message).compact
    @variant = Spree::Variant.where(product_id: params[:id])
    @seller_ids = @product.seller_id.split(",").reject(&:blank?)
    @seller = Spree::Seller.find(@seller_ids)
    @store_ids = @seller.map(&:store_locations).flatten.collect(&:id)  
    # @store_locations = Spree::StockMovement.where(product_id:params[:id]).where(store_location_id:@store_ids)
    @store_locations = Spree::StockMovement.where(product_id:params[:id])
  end

  def product_offer_list
    if params[:id].eql?("Todays trending deals")
     @product_offer_list = Spree::Product.where.not(total_discount:nil).order( 'total_discount desc')
    
    elsif params[:id].eql?("search")
      products = Spree::Taxon.find_by_name(params[:product_type]).products if params[:product_type].present?
      products = Spree::Product.where.not(seller_id:"") unless params[:product_type].present?
      @product_offer_list = products.where("LOWER(name) LIKE ?", ("%"+params[:keywords].downcase+"%"))
      @product_offer_list = Spree::Product.where.not(seller_id:"") if params[:product_type].present? && params[:keywords].present?
    
    else
      treding_deal_products = Spree::Product.where.not(total_discount:nil).order( 'total_discount desc')
      @product_offer_list = treding_deal_products.where(discontinue_on: Date.today.strftime("%Y-%m-%d")+" 00:00:00"..Date.today.days_ago(-5).strftime("%Y-%m-%d")+" 00:00:00")   
    end
    filter_category
    update_array
    
    @product_offer_list = @product_offer_list.where(total_discount:@arr) unless params[:discount].nil?
    filter_date
    @product_offer_list = @product_offer_list.where.not(total_discount:nil) if params[:deal_type].present?

    @product_offer_list = @product_offer_list.where.not(total_discount:nil) if params[:deal_type].present?
    filter_range
  end

  def get_filter_query
    uri = URI.parse(params[:url])
    new_query_arr = Hash[*URI.decode_www_form(uri.query || '').flatten].merge(params[:data]).to_a
    uri.query = URI.encode_www_form(new_query_arr)
    respond_to do |format|
      format.json { render json: { data: (uri.path + '?' + uri.query) } }
    end
  end

  private 

  def filter_date
    @product_offer_list = @product_offer_list.sort_by(&:created_at).reverse if params[:sort_by].eql?("newest")
    @product_offer_list = @product_offer_list.sort_by(&:created_at) if params[:sort_by].eql?("oldest")
    @product_offer_list = @product_offer_list.sort_by(&:name) if params[:sort_by].eql?("atoz")
    @product_offer_list = @product_offer_list.sort_by(&:price) if params[:sort_by].eql?("price")
  end

  def update_array
    @arr = []
    unless params[:discount].nil?
      params[:discount].split(",").each do |num|
        temp = num.sub!("..", ",").split(',').map(&:to_i)
        @arr.push((temp[0]..temp[1]))
      end
    end
  end

  def filter_category
    @products = Spree::Taxon.find_by_name(params[:category_type]).products if params[:category_type].present?
    @product_offer_list = @products.where.not(total_discount:nil).order( 'total_discount desc') if params[:category_type].present?
  end

  def filter_range
   # @product_offer_list =@product_offer_list.select{|p| p if (p.price.to_i > params[:min].to_i && p.price.to_i < params[:max].to_i) } unless params[:max].nil?
   if ((params[:min].to_i > 0) && (params[:max].to_i > 0) && (params[:min].present?) && (params[:max].present?))
      @product_offer_list = @product_offer_list.collect{|p| p.variants}.flatten.select{|p| p if (p.sale_price.to_i > params[:min].to_i && p.sale_price.to_i < params[:max].to_i) } unless params[:max].nil?
    else
      @product_offer_list
    end
  end
end