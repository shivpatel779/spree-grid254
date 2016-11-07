class CreateSpreeFavorites < ActiveRecord::Migration
  def change
    create_table :spree_favorites do |t|
      t.integer :user_id, index: true, foreign_key: true
      t.integer :product_id, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
