class UsersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def update
    if params[:admins].present?
      @new_admins = User.not_admins.where(:id => params[:admins])
      @new_admins.map {|user| user.admin = true}
      @no_longer_admins = User.admins.where('id NOT IN (?)', params[:admins])
      @no_longer_admins.map {|user| user.admin = false}
      if (@new_admins + @no_longer_admins).all? {|user| user.save}
        flash[:success] = 'Admins updated'
      else
        flash[:error] = 'Error updating the admins, please try again'
      end
    else
      flash[:error] = "You can't remove ALL the admins!"
    end
    redirect_to users_url
  end

  def new
  end

  def create
    if @user.save
      @user.update_attribute :admin, true
      flash[:success] = 'Welcome to Bennett!'
      sign_in(@user, :bypass => true)
      redirect_to root_url
    else
      render :new
    end
  end

end
