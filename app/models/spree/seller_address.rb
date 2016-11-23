class Spree::SellerAddress < ActiveRecord::Base
  belongs_to :seller, :class_name => 'Spree::Seller', foreign_key: :seller_id
  belongs_to :country, class_name: 'Spree::Country', foreign_key: :country_id
    belongs_to :state, class_name: 'Spree::State'

  validates_presence_of :constituency, :address1
  validates_format_of :constituency, :with => /[A-Za-z]/

end

