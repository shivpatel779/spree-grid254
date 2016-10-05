class CreateSpreeUserInvites < ActiveRecord::Migration
  def change
    create_table :spree_user_invites do |t|
      t.references :user
      t.string :invited_email
      t.timestamps null: false
    end
  end
end
