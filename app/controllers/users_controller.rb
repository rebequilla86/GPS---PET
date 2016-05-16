class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.all
    authorize User
  end

  def show
    @user = User.find(params[:id])
    @pets = Pet.where(user_id: params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => t('activerecord.attributes.user.updated_user')
    else
      redirect_to users_path, :alert => t('activerecord.attributes.user.unable_user')
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => t('activerecord.attributes.user.deleted_user')
  end

  def walker
    @users = User.walker
    authorize @users
  end

  private

  def secure_params
    params.require(:user).permit(:role, :name, :last_name, :phone, :is_walker, :dogs, :experience, :num_pets)
  end

end
