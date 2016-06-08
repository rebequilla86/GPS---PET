class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  helper_method :sort_column, :sort_direction

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
    @hired = params[:hired] || "Contratar"

    @users = User.walker.order(:name)
    #@users = @users.order(sort_column + " " + sort_direction)
    authorize @users
  end

  def hire_walker
    if (params[:hire].include?"Contratar") && (current_user.walker.nil?)
      @hired = "Dejar servicios"
      current_user.walker = params[:walker]
      current_user.save!

      hired_walker = User.find(params[:walker])
      hired_walker.hired = current_user.id
      hired_walker.save!
    else
      if (params[:hire].include?"Dejar servicios") && (current_user.walker.present?)
        @hired = "Contratar"
        hired_walker = User.find(current_user.walker)
        hired_walker.hired = nil
        hired_walker.save!

        current_user.walker = nil
        current_user.save!
      end
    end
    @users = User.walker.order(:name)
    #@users = @users.order(sort_column + " " + sort_direction)
    render "walker"
    authorize @users
  end

  private
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def secure_params
    params.require(:user).permit(:role, :name, :last_name, :phone, :is_walker, :dogs, :experience, :hired)
  end

end
