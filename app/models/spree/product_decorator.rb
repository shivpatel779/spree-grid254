Spree::Product.class_eval do
  has_many :favorites, class_name: 'Spree::Favorite', foreign_key: :product_id
  has_many :stock_movements
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