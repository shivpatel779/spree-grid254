Spree::ProductsController.class_eval do

  def favorite_a_product
    @product = Spree::Product.friendly.find(params[:product_id])
    @product.favorite(spree_current_user.id)
    @total_favorites = @product.total_favorites

    respond_to do |format|
      format.js
    end
  end

  def unfavorite_a_product
    @product = Spree::Product.friendly.find(params[:product_id])
    @product.unfavorite(spree_current_user.id)
    @total_favorites = @product.total_favorites

    respond_to do |format|
      format.js
    end
  end

end