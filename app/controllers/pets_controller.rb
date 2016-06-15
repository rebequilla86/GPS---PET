class PetsController < ApplicationController
  PER_PAGE = 4

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
    @pet_id = params[:pet_id].to_i
    @walks = Walk.where(pet_id: @pet_id).order('created_at DESC').page(params[:page]).per(PER_PAGE)
    #@track_id = Track.where(walk_id: @walks.last.id)    
    @locations_track = Location.where(track_id: 12)
    @array = [[-15.4912661389, 28.1188646983],
         [-15.4508335143, 28.1300607417],
         [-15.5475988146, 28.0596369971],
         [-15.5475665443, 28.0595917348],
         [-15.5474957172, 28.0597048905],
         [-15.5474359542, 28.0598180462],
         [-15.5473939609, 28.0598720256],
         [-15.5473659653, 28.0598909687],
         [-15.5471209623, 28.0600389931],
         [-15.5469219759, 28.060196992],
         [-15.546783004, 28.0602949765],
         [-15.546606984, 28.0604340322],
         [-15.5465290323, 28.0606920272],
         [-15.5464609712, 28.060882967],
         [-15.5464550201, 28.0608900078],
         [-15.5464909784, 28.0609569792],
         [-15.546487039, 28.0609989725],
         [-15.5464420281, 28.0610429775],
         [-15.5464359932, 28.0610620044],
         [-15.5464499909, 28.0611400399]]
    @hash = Gmaps4rails.build_markers(@locations_track) do |location, marker|
      marker.lat -15.5464499909  #location.latitude   # 43.124228
      marker.lng 28.0611400399  #location.longitude  # 5.928
    end
  end

  def new_route
    @pet_id = params[:pet_id].to_i
    num_walk = Walk.where(pet_id: @pet_id).count + 1

    @walk = Walk.create
    @walk.pet_id = @pet_id
    @walk.walker = current_user
    @walk.name = "Ruta_" + "#{num_walk}"
    @walk.save!

    @file = Nokogiri::XML(File.open("extra/kml_files/doc1.kml"))
    @track.file_name = "doc1.kml"
    @file.css('coordinates').each do |coordinates|
      coordinates.text.split(' ').each do |coordinate|
        (lat, lon, elevation) = coordinate.split(',')
        @location = Location.create
        @location.track_id = @track.id
        @location.latitude = lat
        @location.longitude = lon
        @location.save!
      end
    end
    
    @locations_track = Location.where(track_id: @track.id)

    redirect_to pet_routes_path(@pet_id)
  end

  private
    def pet_params
      params.require(:pet).permit(:name, :num_chip, :born_date, :user_id, :comment, :race, :avatar)
    end

end
