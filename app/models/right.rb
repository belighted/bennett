class Right < ActiveRecord::Base
  ROLES = %w(admin developer auditor)

  belongs_to :project
  belongs_to :user

  validates :project, :user, presence: true
  validates :user_id, uniqueness: {scope: :project_id}
  validates :role, inclusion: {in: ROLES}

  ROLES.each do |r|
    define_method "#{r}?" do
      role == r
    end
  end
end
