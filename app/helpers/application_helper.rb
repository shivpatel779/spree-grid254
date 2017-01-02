module ApplicationHelper

	def calculation_price product
		@master_price =  product.price.to_f
		@sale_price = Spree::Variant.where(product_id:product.id).first.sale_price.to_f 
		@give_values = product.giveaway_value.to_f
		@save = @master_price - @sale_price + @give_values
	end

	def update_url_single_parameter type, data
		uri = URI.parse(request.url)
		new_query_arr = Hash[*URI.decode_www_form(uri.query || '').flatten].merge(Hash[*[type,data]]).to_a
		uri.query = URI.encode_www_form(new_query_arr)
		(uri.path + '?' + uri.query)
	end

	def this_filter_is_checked? type, data
		uri = URI.parse(request.url)
		query = Hash[*URI.decode_www_form(uri.query || '').flatten]
		query[type].split(',').include?(data) rescue false
	end

	def update_url type, data
		uri = URI.parse(request.url)
		current_par = Hash[*URI.decode_www_form(uri.query || '').flatten]
		
		new_query_arr = if current_par[type].present? 
											add_or_remove_parameter_value(current_par, data, type)
										else
											URI.decode_www_form(uri.query || '') << [type, data]
										end
		uri.query = URI.encode_www_form(new_query_arr)
		(uri.path + '?' + uri.query)
	end

	def add_or_remove_parameter_value current_par, data, type
		par_value = current_par[type]
		if par_value.include?(data)
			if par_value == data
				current_par = current_par.reject{|k,v| data==v }
			else
				array = par_value.split(',')
				array.delete(data)
				current_par[type] = array.join(',')
			end
		else
			current_par[type] = par_value+','+data
		end
		current_par.to_a
	end

	def total_offer type
		if type.eql?("discounts")
			@total = Spree::Product.all.collect(&:total_discount).reject(&:nil?).count
		else
			@total = Spree::Product.all.collect(&:giveaway_value).reject(&:nil?).count
		end
	end
end