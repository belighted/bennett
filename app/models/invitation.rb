class Invitation < ActiveRecord::Base
  belongs_to :issuer, :class_name => User.name
  belongs_to :project

  validates :issuer, presence: true
  validates :project, presence: true
  validates :role, inclusion: {in: Right::ROLES}
  validates :email, presence: true

  def self.apply_all_to_user(user)
    invites = find_all_by_email(user.email)
    user.rights << invites.collect {|i| Right.new :project => i.project, :role => i.role}
    if user.save
      invites.map(&:destroy)
    else
      false
    end
  end
end