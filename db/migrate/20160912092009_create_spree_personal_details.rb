class CreateSpreePersonalDetails < ActiveRecord::Migration
  def change
    create_table :spree_personal_details do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :date_of_birth
      t.string :national_id
      t.references :user

      t.timestamps null: false
    end
  end
end
