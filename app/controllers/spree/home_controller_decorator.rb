module Spree
  HomeController.class_eval do
    def sale
      @products = Product.joins(:variants_including_master).where('spree_variants.sale_price is not null').uniq
    end

    def index
    	@treding_deal_product = Spree::Product.where.not(total_discount:nil).order( 'total_discount desc').first(8)
    	@products = Spree::Product.first(5)
    end
  end
end
