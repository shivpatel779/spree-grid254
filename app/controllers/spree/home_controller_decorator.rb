module Spree
  HomeController.class_eval do
    def sale
      @products = Product.joins(:variants_including_master).where('spree_variants.sale_price is not null').uniq
    end

    def index
    	@treding_deal_products = Spree::Product.where.not("total_discount = ? AND seller_id = ?",nil,"").order( 'total_discount desc')
    	@top_ending_deals_products = @treding_deal_products.where(discontinue_on: Date.today.strftime("%Y-%m-%d")+" 00:00:00"..Date.today.days_ago(-5).strftime("%Y-%m-%d")+" 00:00:00")
    	@products = Spree::Product.first(4)
    end
  end
end
