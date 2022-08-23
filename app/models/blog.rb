class Blog < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :user

  has_and_belongs_to_many :categories


  def has_categories?
    categories.length > 0
  end
end
