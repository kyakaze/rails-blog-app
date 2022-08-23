class Blog < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :categories
  belongs_to :user
  belongs_to :category
  validates :category_id, presence: true
end
