class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :rights
  has_many :projects, through: :rights
  has_many :invitations

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  before_create :apply_invites

  scope :admins, where(:admin => true)
  scope :not_admins, where(:admin => false)

  def projects
    admin? ? Project.all : super
  end

private

  def apply_invites
    Invitation.apply_all_to_user(self)
  end
end
