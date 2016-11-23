class CreateSpreeConstituencies < ActiveRecord::Migration
  def change
    create_table :spree_constituencies do |t|
      t.references :spree_state, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
