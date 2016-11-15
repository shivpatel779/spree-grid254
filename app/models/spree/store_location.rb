class Spree::StoreLocation < ActiveRecord::Base
  belongs_to :country
  belongs_to :state, class_name: 'Spree::State'
  belongs_to :seller, :class_name => 'Spree::Seller', foreign_key: :seller_id

  validates_presence_of :name, :constituency, :address1, :city, :zipcode, :phone, :country_id


end
