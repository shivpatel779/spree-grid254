class Spree::LocationInfo < ActiveRecord::Base
  validates_format_of :constituency, :with => /[a-z]/
  belongs_to :user, class_name: Spree.user_class.to_s, foreign_key: 'user_id'
end