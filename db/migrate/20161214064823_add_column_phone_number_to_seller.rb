class AddColumnPhoneNumberToSeller < ActiveRecord::Migration
  def change
  	add_column :spree_sellers, :phone_number, :text
  end
end
