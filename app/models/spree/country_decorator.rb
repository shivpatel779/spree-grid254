Spree::Country.class_eval do
  has_many :seller_addresses, :class_name => 'Spree::SellerAddress', foreign_key: :country_id
end