Spree::Product.class_eval do
  has_many :favorites, class_name: 'Spree::Favorite', foreign_key: :product_id, :dependent => :destroy
  has_many :stock_movements
  has_many :variants
  
  # scope 
  scope :product_validity, -> { where(['discontinue_on >= ?', Date.today.strftime("%Y-%m-%d")+" 00:00:00"]) }

  def total_favorites
    favorites.count.to_s
  end

  def favorited_by?(user_id)
    favorites.where(user_id: user_id).any?
  end

  def unfavorite(user_id)
    favorites.find_by(user_id: user_id).destroy
  end

  def favorite(user_id)
    favorites.create(user_id: user_id)
  end
end