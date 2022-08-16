class AddUserToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :user, index: true, null: false
    add_foreign_key :comments, :users
  end
end
