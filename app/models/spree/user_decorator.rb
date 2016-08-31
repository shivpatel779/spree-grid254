Spree::User.class_eval do

	validates :first_name, :middle_name, :last_name, :birth_date, :national_id, :phone, :country, :state, :constituency, presence: true

	validates :phone, :numericality => true, :length => { :minimum => 10, :maximum => 15 }
	
	



end