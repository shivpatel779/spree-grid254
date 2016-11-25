class Spree::Constituency < ActiveRecord::Base
  belongs_to :state, class_name: 'Spree::State', foreign_key: :spree_state_id
  has_many :locations, class_name: 'Spree::Location', foreign_key: :spree_constituency_id
  has_many :store_locations, class_name: 'Spree::StoreLocation', foreign_key: :location_id
end