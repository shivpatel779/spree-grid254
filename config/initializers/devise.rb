Devise.secret_key = "e69e771fb57640f7597f7e95c56f72bcd407b9a82fe6937ae3d80875e840599ab21d2802d1223d058780d5ea4e4e332d8acf"

# initializer for oauth linkedin
SpreeSocial::OAUTH_PROVIDERS << ['LinkedIn', 'linkedin', 'true']
SpreeSocial.init_provider('linkedin')

=begin
Devise.setup do |config|
  config.warden do |manager|
    manager.default_strategies(:scope => :user).unshift :two_factor_authenticatable
  end
end
=end
