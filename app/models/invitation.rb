class Invitation < ActiveRecord::Base
  belongs_to :issuer, :class_name => User.name
  belongs_to :project

  validates :issuer, presence: true
  validates :project, presence: true
  validates :role, inclusion: {in: Right::ROLES}
  validates :email, presence: true, format: {with: Devise::email_regexp}, uniqueness: {scope: :project_id}

  after_create :queue_email

  def self.apply_all_to_user(user)
    invites = find_all_by_email(user.email)
    user.rights << invites.collect {|i| Right.new :project => i.project, :role => i.role, :user => user}
    if user.valid?
      invites.map(&:destroy)
    else
      false
    end
  end

private

  def queue_email
    Resque.enqueue(InvitationMailerQueue, id)
  end
end