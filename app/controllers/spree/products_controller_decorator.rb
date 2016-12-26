Spree::ProductsController.class_eval do

  def index
    @products = Spree::Product.where("LOWER(name) LIKE ?", ("%"+params[:keywords].downcase+"%"))
    @treding_deal_product = Spree::Product.where.not(total_discount:nil).order( 'total_discount desc').first(4)
  end

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

  def product_offer_list
    if  params[:id].eql?("Todays trending deals")
     @product_offer_list = Spree::Product.where.not(total_discount:nil).order( 'total_discount desc')
    else
      treding_deal_products = Spree::Product.where.not(total_discount:nil).order( 'total_discount desc')
      @product_offer_list = treding_deal_products.where(discontinue_on: Date.today.strftime("%Y-%m-%d")+" 00:00:00"..Date.today.days_ago(-5).strftime("%Y-%m-%d")+" 00:00:00")   
    end
  end
end