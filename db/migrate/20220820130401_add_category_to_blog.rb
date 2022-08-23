class AddCategoryToBlog < ActiveRecord::Migration
  def change
    add_reference :blogs, :category, index: true, foreign_key: true
    add_column :blogs, :category, :string
    add_index :blogs, :category, unique: true
  end
end
