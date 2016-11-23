class ChangeConstituencyRefToState < ActiveRecord::Migration
  def change
    rename_column :spree_constituencies, :spree_country_id, :spree_state_id
  end
end
