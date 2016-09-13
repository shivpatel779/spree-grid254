Spree::User.class_eval do
  has_one :personal_detail, :class_name => 'Spree::PersonalDetail', foreign_key: 'user_id'
  has_one :location_info, :class_name => 'Spree::LocationInfo', foreign_key: 'user_id'
end