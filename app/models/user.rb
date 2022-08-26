class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :blogs
  has_many :comments

  # rolify
  after_create :assign_default_role



  def assign_default_role
    if User.count == 1
      self.add_role(:admin)
      self.add_role(:buyer)
    else
      self.add_role(:buyer)
    end
  end

end
