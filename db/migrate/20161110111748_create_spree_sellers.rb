class CreateSpreeSellers < ActiveRecord::Migration
  def change
    create_table :spree_sellers do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.timestamps null: false
    end
  end
end
