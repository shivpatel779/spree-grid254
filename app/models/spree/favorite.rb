class Spree::Favorite < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'

  validates :product_id, uniqueness: { scope: :user_id, message: "'You can't favrite a product more than once" }
end
