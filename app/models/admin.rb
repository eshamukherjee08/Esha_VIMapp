class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :forgot_your_password
  
  validates :email, :password, :password_confirmation, :presence => true
  
  after_destroy :ensure_an_admin_remains

    def ensure_an_admin_remains 
      if Admin.count.zero? 
        raise "Can't delete last user" 
      end 
    end
end
