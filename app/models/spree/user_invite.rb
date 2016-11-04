class Spree::UserInvite < ActiveRecord::Base
  belongs_to :user, class_name: Spree.user_class.to_s, foreign_key: 'user_id'
  validates_presence_of :invited_email

  REF_TEXT = "Join #{spree_current_user.full_name} and thousands of households in Kenya using Grid254 to stay informed and access the discount offers on different products and services in your location"

end
