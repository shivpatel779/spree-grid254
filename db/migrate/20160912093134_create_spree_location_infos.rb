class CreateSpreeLocationInfos < ActiveRecord::Migration
  def change
    create_table :spree_location_infos do |t|
      t.string :constituency
      t.string :address
      t.decimal :lat
      t.decimal :lng
      t.references :user

      t.timestamps null: false
    end
  end
end
