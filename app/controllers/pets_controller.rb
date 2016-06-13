class PetsController < ApplicationController
  PER_PAGE = 2

  def index
    @own_pets = Pet.where(user_id: current_user.id).order('name ASC').page(params[:page]).per(PER_PAGE)

    @onwer_hire_walker = User.where(walker: current_user.id)
    @onwer_hire_walker.each do |owner| 
      @pets = Pet.where(user_id: owner.id).order('name ASC').page(params[:page]).per(PER_PAGE)
    end
  end

  def show
    @pet = Pet.find(params[:id])
  end

  def new
  	@pet = Pet.new
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def create
    @pet = Pet.new(pet_params)
    @pet.user_id = current_user.id if current_user
     
    if @pet.save
      flash[:success] = t('activerecord.attributes.pet.confirmation')
      redirect_to @pet
    else
      render 'new'
    end
  end

  def update
    @pet = Pet.find(params[:id])
 
    if params[:pet][:remove_avatar] == '1' 
      @pet.remove_avatar!
      @pet.save
    end
    if @pet.update(pet_params)
      redirect_to @pet
    else
      render 'edit'
    end
  end

  def destroy
    @pet = Pet.find(params[:id])
    @pet.destroy
 
    redirect_to pets_path
  end

  def routes
    @walks = Walk.all
    @hash = Gmaps4rails.build_markers(@walks) do |walk, marker|
      marker.lat 43.124228 #walk.latitude
      marker.lng 5.928 # walk.longitude
    end
  end

  def new_route
    @walk = Walk.new(walk_params)
    @pet = params[:pet_id].to_i
    %x(bundle exec rake gps_simulator:process_kml_file[#{@walk},#{@pet}])
    render "routes"
  end

  private
    def pet_params
      params.require(:pet).permit(:name, :num_chip, :born_date, :user_id, :comment, :race, :avatar)
    end

    def walk_params
      params[:walk]
    end
end
