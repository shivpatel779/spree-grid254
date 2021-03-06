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
      @product_offer_list = Spree::Product.product_validity.where.not(total_discount:nil).order( 'total_discount desc') 
    
    elsif params[:id].eql?("recommended")
      if spree_current_user
        if spree_current_user.product_favorites.present?
          @product_offer_list = spree_current_user.product_favorites.collect{|p| p.product}.collect{|t| t.taxons}.flatten.map{|p| p.products}.flatten
        else
          @product_offer_list = Spree::Product.product_validity.where.not( seller_id: "")
        end
      else
        @product_offer_list =Spree::Product.product_validity.where.not( seller_id: "")
      end

    elsif params[:id].eql?("search")
      products = Spree::Taxon.find_by_name(params[:browse]).products if params[:browse].present?
      products = Spree::Product.product_validity.where.not(seller_id:"") unless params[:browse].present?
      @product_offer_list = products.where("LOWER(name) LIKE ?", ("%"+params[:keywords].downcase+"%")) if params[:keywords].present?
      @product_offer_list = Spree::Product.product_validity.where.not(seller_id:"") unless params[:browse].present? && params[:keywords].present?
    
    elsif params[:id].eql?("All")
      @product_offer_list = Spree::Taxon.find_by_name(params[:browse]).products if params[:browse].present?
    else
      treding_deal_products = Spree::Product.product_validity.where.not(total_discount:nil).order( 'total_discount desc')
      @product_offer_list = treding_deal_products.where(discontinue_on: Date.today.strftime("%Y-%m-%d")+" 00:00:00"..Date.today.days_ago(-5).strftime("%Y-%m-%d")+" 00:00:00")   
    end

    filter_category
    update_array
    @product_offer_list = @product_offer_list.where.not(seller_id:"").where.not(giveaway_value:0) if params[:deal_type].eql?("giveaways")

    @product_offer_list = @product_offer_list.where(total_discount:@arr) unless params[:discount].nil?
    filter_date
    filter_range
  end

  def get_filter_query
    uri = URI.parse(params[:url])
    new_query_arr = Hash[*URI.decode_www_form(uri.query || '').flatten].merge(params[:data]).to_a
    uri.query = URI.encode_www_form(new_query_arr)
    respond_to do |format|
      format.json { render json: { data: (uri.path + '?' + uri.query) } } if params[:data]["browse"].present?
      format.json { render json: { data: (uri.path + '?' + uri.query) } } if params[:data][:sort_by].present?
    end
  end

  private 

  def filter_date
    @product_offer_list = @product_offer_list.sort_by(&:created_at).reverse if params[:sort_by].eql?("newest")
    @product_offer_list = @product_offer_list.sort_by(&:created_at) if params[:sort_by].eql?("oldest")
    @product_offer_list = @product_offer_list.sort_by(&:name) if params[:sort_by].eql?("atoz")
    @product_offer_list = @product_offer_list.collect{|p| p.variants}.flatten.sort_by {|u| u.sale_price || 0}.collect{|pp| pp.product} if params[:sort_by].eql?("price")
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
   if ((params[:min].to_i > 0) && (params[:max].to_i > 0) && (params[:min].present?) && (params[:max].present?))
      @product_offer_list = @product_offer_list.collect{|p| p.variants}.flatten.select{|p| p if (p.sale_price.to_i > params[:min].to_i && p.sale_price.to_i < params[:max].to_i) } unless params[:max].nil?
    else
      @product_offer_list
    end
  end
end