class Spree::Seller < ActiveRecord::Base

  has_many :products, class_name: 'Spree::Product'
  has_many :store_locations, :class_name => 'Spree::StoreLocation', foreign_key: :seller_id
  has_one :address, class_name: 'Spree::SellerAddress', foreign_key: :seller_id
  attr_accessor :phone_2

  serialize :phone_number, Hash
  serialize :email, Hash

  validates_presence_of :name, :email, :phone
  # validates_format_of :email, :with => Devise::email_regexp
  validates_uniqueness_of :email

  accepts_nested_attributes_for :address

  default_scope { order('created_at DESC')}


  def active_for_authentication?
    true
  end

  protected

  def confirmation_required?
    false
  end

end
