class Spree::SellerAddress < ActiveRecord::Base
  belongs_to :seller, :class_name => 'Spree::Seller', foreign_key: :seller_id
  belongs_to :country, class_name: 'Spree::Country', foreign_key: :country_id

  def from_google_maps?
    persisted? && ((city == '' && zipcode == '') || (city.nil? && zipcode.nil?))
  end

  # validates_presence_of :address1, :city, :zipcode
  #validates_format_of :constituency, :with => /[A-Za-z]/

end

