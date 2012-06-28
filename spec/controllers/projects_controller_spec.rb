require 'spec_helper'

describe ProjectsController do
  extend CanSpec

  can_spec(:project, {
    user: [:index],
    auditor: [:index, :show],
    developer: [:index, :show],
    admin: [:index, :show, :edit, :update, :destroy],
    global_admin: [:index, :new, :create, :show, :edit, :update, :destroy]
  })


  it "refuses to add existing user unless admin or global admin" do
    project = FactoryGirl.create(:project)
    new_user = FactoryGirl.create(:user)
    myparams = {project_id: project.id, user_id: new_user.id, role: 'auditor'}

    sign_in FactoryGirl.create(:user)
    put 'add_user_or_invite', myparams
    response.should redirect_to(root_url)
    right = FactoryGirl.create :right, user: subject.current_user, project: project, role: 'auditor'
    put 'add_user_or_invite', myparams
    response.should redirect_to(root_url)
    right.update_attribute :role, 'developer'
    put 'add_user_or_invite', myparams
    response.should redirect_to(root_url)
  end

  it "refuses to invite user unless admin or global admin" do
    project = FactoryGirl.create(:project)
    myparams = {project_id: project.id, email: 'newguy@bennett.com', role: 'auditor'}

    sign_in FactoryGirl.create(:user)
    put 'add_user_or_invite', myparams
    response.should redirect_to(root_url)
    right = FactoryGirl.create :right, user: subject.current_user, project: project, role: 'auditor'
    put 'add_user_or_invite', myparams
    response.should redirect_to(root_url)
    right.update_attribute :role, 'developer'
    put 'add_user_or_invite', myparams
    response.should redirect_to(root_url)
  end

  it "adds exsiting user if admin" do
    admin = FactoryGirl.create :admin
    project = admin.projects.last
    new_user = FactoryGirl.create :user
    sign_in admin
    lambda do
      put 'add_user_or_invite', project_id: project.id, user_id: new_user.id, role: 'auditor'
      response.should redirect_to(project)
    end.should change(Right, :count).by(1)
  end

  it "adds exsiting user if global admin" do
    admin = FactoryGirl.create :global_admin
    project = FactoryGirl.create :project
    new_user = FactoryGirl.create :user
    sign_in admin
    lambda do
      put 'add_user_or_invite', project_id: project.id, user_id: new_user.id, role: 'auditor'
      response.should redirect_to(project)
    end.should change(Right, :count).by(1)
  end

  it "invites new user if admin" do
    admin = FactoryGirl.create :admin
    project = admin.projects.last
    sign_in admin
    lambda do
      put 'add_user_or_invite', project_id: project.id, email: 'newguy@bennett.com', role: 'auditor'
      response.should redirect_to(project)
    end.should change(Invitation, :count).by(1)
  end

  it "invites new user if global admin" do
    admin = FactoryGirl.create :global_admin
    project = FactoryGirl.create :project
    sign_in admin
    lambda do
      put 'add_user_or_invite', project_id: project.id, email: 'newguy@bennett.com', role: 'auditor'
      response.should redirect_to(project)
    end.should change(Invitation, :count).by(1)
  end

end
