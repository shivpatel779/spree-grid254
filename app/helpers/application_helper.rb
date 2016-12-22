module ApplicationHelper

	def calculation_price product
		@master_price =  product.price.to_f
		@sale_price = Spree::Variant.where(product_id:product.id).first.sale_price.to_f 
		@give_values = product.giveaway_value.to_f
		@save = @master_price - @sale_price + @give_values
	end

end
