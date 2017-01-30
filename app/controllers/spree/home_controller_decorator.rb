module Spree
  HomeController.class_eval do
    def sale
      @products = Product.joins(:variants_including_master).where('spree_variants.sale_price is not null').uniq
    end

    def index
      # @treding_deal_products = Spree::Product.where.not("total_discount = ? AND seller_id = ?",nil,"").order( 'total_discount desc')
    	@treding_deal_products = Spree::Product.product_validity.where.not("total_discount = ? AND seller_id = ?",nil,"").order( 'total_discount desc')
      @top_ending_deals_products = @treding_deal_products.where(discontinue_on: Date.today.strftime("%Y-%m-%d")+" 00:00:00"..Date.today.days_ago(-5).strftime("%Y-%m-%d")+" 00:00:00")
    	@products = Spree::Product.first(4)
      if spree_current_user
        if spree_current_user.product_favorites.present?
          @recommended = spree_current_user.product_favorites.collect{|p| p.product}.collect{|t| t.taxons}.flatten.map{|p| p.products}.flatten
        else
          @recommended = Spree::Product.product_validity.where.not( seller_id: "")
        end
      else
        @recommended = Spree::Product.product_validity.where.not( seller_id: "")
      end
    end
  end
end
