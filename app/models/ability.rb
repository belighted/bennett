class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.persisted?
      if user.admin?
        can :manage, :all
      else
        can [:read, :update, :destroy], Project do |p|
          Right.find_by_project_id_and_user_id(p.id, user.id).try :admin?
        end
        can :read, Project do |p|
          r = Right.find_or_initialize_by_project_id_and_user_id(p.id, user.id)
          r.developer? || r.auditor?
        end

        can :manage, Command do |c|
          Right.find_by_project_id_and_user_id(c.project_id, user.id).try :admin?
        end

        can :manage, Build do |b|
          Right.find_by_project_id_and_user_id(b.project_id, user.id).try :admin?
        end
        can :create, Build do |b|
          Right.find_by_project_id_and_user_id(b.project_id, user.id).try :developer?
        end
        can :read, Build do |b|
          Right.find_by_project_id_and_user_id(b.project_id, user.id).present?
        end

        can :read, Result do |r|
          Right.find_by_project_id_and_user_id(r.build.project_id, user.id).present?
        end

        can :create, Invitation do |i|
          Right.find_by_project_id_and_user_id(i.project_id, user.id).try :admin?
        end
        can :manage, Right do |r|
          Right.find_by_project_id_and_user_id(r.project_id, user.id).try :admin?
        end
      end
    else
      can :create, User do |u|
        !User.any?
      end
    end

  end
end
