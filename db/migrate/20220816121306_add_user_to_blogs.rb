class AddUserToBlogs < ActiveRecord::Migration
  def change
    add_reference :blogs, :user, index: true, null: false
    add_foreign_key :blogs, :users
  end
end
