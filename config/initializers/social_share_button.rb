SocialShareButton.configure do |config|
  # config.allow_sites = %w(twitter facebook google_plus weibo qq douban google_bookmark
  #                         delicious tumblr pinterest email linkedin wechat vkontakte
  #                         xing reddit hacker_news)

 # SocialShareButton.configure do |config|
    config.allow_sites = %w(twitter facebook whatsapp telegram)
 # end

end

ActiveSupport.on_load(:action_view) do
  include SocialShareButton::Helper
end
