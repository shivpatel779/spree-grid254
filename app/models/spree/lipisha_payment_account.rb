class Spree::LipishaPaymentAccount < ActiveRecord::Base
  belongs_to :spree_user, class_name: Spree.user_class.to_s, foreign_key: 'user_id'

end
