class CreateSpreeSellerAddresses < ActiveRecord::Migration
  def change
    create_table :spree_seller_addresses do |t|
      t.integer  'seller_id'
      t.integer  'country_id'
      t.integer  'state_id'
      t.string   'constituency'
      t.string   'address1'
      t.string   'address2'
      t.string   'phone'
      t.float    'latitude'
      t.float    'longitude'
      t.timestamps null: false
    end
  end
end
