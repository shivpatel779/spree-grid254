class Spree::StoreLocation < ActiveRecord::Base
  belongs_to :country
  belongs_to :state, class_name: 'Spree::State'
  belongs_to :seller, :class_name => 'Spree::Seller', foreign_key: :seller_id
  belongs_to :constituency, class_name: 'Spree::Constituency', foreign_key: :constituency_id
  belongs_to :location, class_name: 'Spree::Location', foreign_key: :location_id
  # validates_presence_of :name, :address1, :city, :zipcode,  :country_id

  serialize :phone, Array
  serialize :email, Array


  def from_google_maps?
    persisted? && ((city == '' && zipcode == '') || (city.nil? && zipcode.nil?))
  end
end
