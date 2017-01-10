Spree::StockMovement.class_eval do
	belongs_to :product
	belongs_to :store_location

	validates :product_id, uniqueness: true, if: 'Spree::StockMovement.where(store_location_id: self.store_location_id).present?', on: :create

	def readonly?
		false
	end

end