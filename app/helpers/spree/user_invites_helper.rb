module Spree::UserInvitesHelper

  def referral_url_string
    #"http://fierce-reef-22139.herokuapp.com/signup?c=#{spree_current_user.referral_code}"
    "#{request.protocol}#{request.host}#{Rails.env.development? ? (':'+request.port.to_s) : ''}/signup?c=#{spree_current_user.referral_code}"
  end

  def touch_device?
    user_agent = request.headers["HTTP_USER_AGENT"]
    user_agent.present? && user_agent =~ /\b(Android|iPhone|iPad|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook)\b/i
  end

  def social_share_button_tag(title = "", opts = {})

    opts[:allow_sites] ||= SocialShareButton.config.allow_sites

    extra_data = {}
    rel        = opts[:rel]
    html       = []
    html << "<div class='social-share-button' data-title='#{h title}' data-img='#{opts[:image]}'"
    html << "data-url='#{opts[:url]}' data-desc='#{opts[:desc]}' data-via='#{opts[:via]}'>"


    ref_text = "Join #{spree_current_user.full_name} and thousands of households in Kenya using Grid254 to stay informed and access the discount offers on different products and services in your location"

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
