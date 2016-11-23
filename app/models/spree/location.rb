class Spree::Location < ActiveRecord::Base
  belongs_to :spree_constituency, class_name: 'Spree::Constituency', foreign_key: :spree_constituency_id
end
