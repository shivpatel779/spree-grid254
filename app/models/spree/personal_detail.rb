class Spree::PersonalDetail < ActiveRecord::Base

  # validations
  validates :national_id, :length => { :minimum => 11, :message => 'ID should be 11 characters long' }, :format => { with: /[0-9]+/ }
  validates_presence_of :national_id

  # associations
  belongs_to :user, class_name: Spree.user_class.to_s, foreign_key: 'user_id'

end
