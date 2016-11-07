class Spree::UserInvite < ActiveRecord::Base
  belongs_to :user, class_name: Spree.user_class.to_s, foreign_key: 'user_id'
  validates_presence_of :invited_email

end
