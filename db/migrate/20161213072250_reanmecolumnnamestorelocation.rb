class Reanmecolumnnamestorelocation < ActiveRecord::Migration
  def change
  	change_column :spree_store_locations, :phone, :text  	
  end
end
