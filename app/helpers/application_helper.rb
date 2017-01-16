module ApplicationHelper


	def update_stock_movement product
		seller_id = @product.seller_id
		seller_ids = @product.seller_id.split(",").reject(&:blank?)
		seller = Spree::Seller.find(seller_ids)
		@store_locations = seller.map(&:store_locations).flatten
	end

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


	def product_share_url
    #"http://fierce-reef-22139.herokuapp.com/signup?c=#{spree_current_user.referral_code}"
    "#{request.protocol}#{request.host}#{Rails.env.development? ? (':'+request.port.to_s) : ''}/signup?c=#{spree_current_user.referral_code}"
  end

  def touch_device?
    user_agent = request.headers["HTTP_USER_AGENT"]
    user_agent.present? && user_agent =~ /\b(Android|iPhone|iPad|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook)\b/i
  end

  def social_share_button1_tag(title = "", opts = {})
    opts[:allow_sites] ||= SocialShareButton.config.allow_sites

    extra_data = {}
    rel        = opts[:rel]
    html       = []
    # html << "<div class='social-share-button' data-title='#{h title}' data-img='#{opts[:image]}'"

		html << "<div class='social-share-button' data-title='#{@product.name}' data-img='#{opts[:image]}'"
      

    html << "data-url='#{opts[:url]}' data-desc='#{@product.description}' data-via='#{opts[:via]}'>"


    ref_text = "Join #{spree_current_user.full_name} would like you view this product #{@product.name} that is on offer and is currently listed on Grid254"

    opts[:allow_sites].each do |name|

      if name.eql?('whatsapp')


        if touch_device?
          html<< link_to(image_tag('1477405766_whatsapp.png', height: '18', width: '18'), ("whatsapp://send?text=#{ref_text} #{opts[:url]}").html_safe)
        else
          html << link_to(image_tag('1477405766_whatsapp.png', height: '18', width: '18'), 'https://web.whatsapp.com', target: '_false')
        end

      else

        if name.eql?('telegram')
          html << link_to(image_tag('1477523495_Telegram.png', height: '18', width: '18'), "#{ref_text} https://telegram.me/share/url?url=#{opts[:url]}", target: '_false')
        else

          if name.eql?('email')
            html << link_to(image_tag('1477606885_mail-icon.png', height: '18', width: '18'), "/invite")
          else

            extra_data                         = opts.select { |k, _| k.to_s.start_with?('data') } if name.eql?('tumblr')
            special_data                       = opts.select { |k, _| k.to_s.start_with?('data-' + name) }

            special_data["data-wechat-footer"] = t "social_share_button.wechat_footer" if name == "wechat"

            link_title = t "social_share_button.share_to", :name => t("social_share_button.#{name.downcase}")
            html << link_to("", "#", { :rel        => ["nofollow", rel],
                                       "data-site" => name,
                                       :class      => "ssb-icon ssb-#{name}",
                                       :onclick    => "return SocialShareButton.share(this);",
                                       :title      => h(link_title) }.merge(extra_data).merge(special_data).merge('data-quote' => ref_text)).html_safe
          end

        end

      end

    end
    html << "</div>"
    raw html.join("\n")
  end
end