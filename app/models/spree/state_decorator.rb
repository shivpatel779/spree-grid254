Spree::State.class_eval do
  has_many :constituencies, :class_name => 'Spree::Constituency', foreign_key: :spree_state_id
end