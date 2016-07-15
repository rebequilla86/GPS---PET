class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  helper_method :sort_column, :sort_direction

  PER_PAGE = 5
  PER_PAGE_ADMIN = 10

  def index
    @users = User.all.order('name ASC').reorder('last_name DESC').page(params[:page]).per(PER_PAGE_ADMIN)
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
      @user.is_walker = (@user.role == 2) ? "1" : nil
      @user.save!
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
    @page = params[:page]

    @users = User.walker.order('name ASC').reorder('last_name DESC').page(params[:page]).per(PER_PAGE)
    @num_pets = Pet.where(user_id: current_user.id).count
    authorize @users
    @walker = current_user.walker if current_user.walker.present?
  end

  def hire_walker
    @id_walker = params[:button].partition('-').last.to_i     
    if (params[:button].include?"Contratar") && (!@id_walker.nil?) && (!current_user.walker.nil?) && (current_user.walker != @id_walker) 
      flash[:notice] = "Ya tiene contratado un paseador. Para contratar a otro tiene que dejar los servicios del paseador actual."
      @walker = current_user.walker if current_user.walker.present?
    else
      if (params[:button].include?"Contratar") && (current_user.walker.nil?)
        @hired = "Liberar"
        
        current_user.walker = @id_walker
        current_user.save!

        hired_walker = User.find(@id_walker)
        hired_walker.hired = current_user.id
        hired_walker.save!
        flash[:notice] = "Ha contratado a " + hired_walker.name
      else
        if (params[:button].include?"Liberar") && (current_user.walker.present?)
          @hired = "Contratar"
          hired_walker = User.find(current_user.walker)
          hired_walker.hired = nil
          hired_walker.save!

          current_user.walker = nil
          current_user.save!
          flash[:notice] = "Ha dejado de contratar los servicios de  " + hired_walker.name
        end
      end
    end
    @users = User.walker.order('name ASC').reorder('last_name DESC').page(params[:page]).per(PER_PAGE)
    authorize @users
    redirect_to walker_users_path
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
