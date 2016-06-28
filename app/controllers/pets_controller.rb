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
 
    # if params[:pet][:remove_avatar] == '1' 
    #   @pet.remove_avatar!
    #   @pet.save
    # end
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

    @actual_time = Time.now.strftime('%H:%M:%S')

    @walk_in_process = Walk.where("pet_id = #{@pet_id} AND state = 0")
    if @walk_in_process.present? 
      @state = 0
      @points_locations = get_locations_in_process(@walk_in_process, @actual_time, @state)
      @account_points_locations = @points_locations.count
      @last_point = @points_locations.last if @points_locations.present?

      @coordinates = get_last_point_track(@walk_in_process, @state)

      unless @last_point.nil?
        @last_point_at_moment = get_last_point_at_moment(@last_point) 
        update_walk_in_process(@walk_in_process, @state, @account_points_locations, @last_point, @coordinates, @last_point_at_moment)
      end

      @duration = @last_point_track.timer unless @last_point_track.nil?
      if @duration.to_date == Time.now.to_date
        if (@duration.strftime('%H:%M:%S') < @actual_time) && (@last_point - @coordinates == [])
          @walk_in_process[0].state = 1
          @walk_in_process[0].last_data_received = @last_point_at_moment.timer
          @walk_in_process[0].duration = Time.at(@account_points_locations * 5).utc.strftime("%H:%M:%S") #@duration.strftime("%H:%M:%S") 
          @walk_in_process[0].save!
          @state = 1
        end 
      end unless @duration.nil?
    else
      @finished_walks = Walk.where("pet_id = #{@pet_id} AND state = 1").to_a
      @finished_walk = @finished_walks.max_by(&:id)
      if @finished_walk.present?
        @points_locations = get_locations_finalized(@finished_walk, @actual_time, 1)
        @last_point = @points_locations.last

        @state = 1
      else
        @location_gran_canaria = Location.create(latitude: 28.127222, longitude: -15.431389)
        @last_point = @location_gran_canaria
        @points_locations = [[@last_point.latitude, @last_point.longitude]]
        
        @state = 1
      end
    end

    @last_point_at_moment = get_last_point_at_moment(@last_point)

    @hash_map = Gmaps4rails.build_markers(@last_point_at_moment) do |location, marker|
      marker.lat location.latitude  
      marker.lng location.longitude  
    end

    unless @walk_in_process[0].nil?
      @walk_id = @finished_walk.present? ? @finished_walk.id : @walk_in_process[0].id
    end

    if current_user.is_walker.nil?
      @walker_current_user = User.where(walker: current_user.walker)
      @pet_current_user = Pet.where(user_id: current_user.walker).map(&:id)
    else
      @walker_current_user = User.where(walker: current_user.id)
      @pet_current_user = Pet.where(user_id: current_user.hired).map(&:id)
    end

    unless @walker_current_user.blank?
      @walker_current_user = @walker_current_user[0].id
      @pet_walker = Pet.where(user_id: @walker_current_user) 
    else
      @pet_walker = []
    end

    @walks = Walk.where(pet_id: @pet_id).order('created_at DESC').page(params[:page]).per(PER_PAGE)
    respond_to do |format| 
      format.html       
      format.json { render json: { points_locations: @points_locations, state: @state, hash_map: @hash_map, walk_id: @walk_id, walks: @walks, pet_id: @pet_id, pet_current_user: @pet_current_user } }
    end
  end

  def new_route
    @pet_id = params[:pet_id].to_i
    
    name_last_walk = Walk.where(pet_id: @pet_id).last
    if name_last_walk.nil? 
      num_walk = "0"
    else
      name_last_walk = name_last_walk.name
      num_walk = name_last_walk.partition('_').last unless name_last_walk.nil?
    end
    num_walk = num_walk.to_i + 1
    name_route = "Ruta_" + "#{num_walk}"
    
    @walk = Walk.create
    @walk.pet_id = @pet_id
    @walk.walker = current_user.name
    @walk.name = name_route 
    @walk.state = "in_progress"
    @walk.save!
    
    prng = Random.new
    num_file = prng.rand(10)
    @file = Nokogiri::XML(File.open("extra/kml_files/doc1-#{num_file}.kml"))
    
    @track = Track.create
    @track.file_name = "doc1-#{num_file}"
    @track.walk_id = @walk.id
    @track.save!

    first_time = 0
    
    @file.css('coordinates').each do |coordinates|
      coordinates.text.split(' ').each do |coordinate|
        (lat, lon, elevation) = coordinate.split(',')
        @location = Location.create
        @location.track_id = @track.id     
        @location.latitude = lat
        @location.longitude = lon
        if first_time == 0
          @time_without_seconds = Time.now
          @location.timer = @time_without_seconds
          @time_plus_seconds = @time_without_seconds
          first_time = 1
        else
          @time_plus_seconds = @time_plus_seconds + 5.seconds
          @location.timer = @time_plus_seconds
        end
        @location.save!
        puts "#{lat},#{lon}\n"
      end
    end

    redirect_to pet_routes_path(@pet_id)
  end

  def show_route
    @pet_id = params[:pet_id].to_i
    @walks = Walk.where(pet_id: @pet_id).order('created_at DESC').page(params[:page]).per(PER_PAGE)

    @actual_time = Time.now.strftime('%H:%M:%S')

    @walk_id = params[:walk_id].to_i
    @walk = Walk.find(@walk_id)
    @walk_name = @walk.name

    @points_locations = get_locations_finalized(@walk, @actual_time, 1)
    @last_point = @points_locations.last if @points_locations.present?

    unless @last_point.nil?
      @last_point_at_moment = get_last_point_at_moment(@last_point)
    end

    @hash_map = Gmaps4rails.build_markers(@last_point_at_moment) do |location, marker|
      marker.lat location.latitude  
      marker.lng location.longitude  
    end

    @state = 1
    @pet_walker = []
  end

  private
    def update_walk_in_process(walk_in_process, state, account_points_locations, last_point, coordinates, last_point_at_moment)
      @track_id = get_track_id(walk_in_process, state)
      @walk_in_process[0].last_data_received = last_point_at_moment.timer
      @walk_in_process[0].duration = Time.at(account_points_locations * 5).utc.strftime("%H:%M:%S")
      @walk_in_process[0].state = (last_point - coordinates == []) ? 1 : 0
      @walk_in_process[0].save!
    end

    def get_last_point_track(walk_in_process, state)
      @track_id = get_track_id(walk_in_process, state)
      @last_point_track = Location.where(track_id: @track_id).last
      @coordinates = []
      @coordinates << @last_point_track.latitude 
      return @coordinates << @last_point_track.longitude
    end

    def get_last_point_at_moment(last_point)
      if last_point.is_a?(ActiveRecord::Base)
        last_point_latitude = last_point.latitude
        last_point_longitude = last_point.longitude
      else
        last_point_latitude = last_point[0]
        last_point_longitude = last_point[1]
      end
      return @last_point_at_moment = Location.where("latitude = #{last_point_latitude} AND longitude = #{last_point_longitude}").last
    end

    def get_locations_track(walk_in_process, state)
      @track_id = get_track_id(walk_in_process, state)

      return @locations_track = Location.where(track_id: @track_id)
    end

    def get_track_id(walk_in_process, state)
      walk_id = state == 0 ? walk_in_process[0].id : walk_in_process.id
      track_in_process = Track.where(walk_id: walk_id)
      return @track_id = track_in_process.to_a[0].id
    end

    def get_locations_in_process(walk_in_process, actual_time, state)
      @locations_track = get_locations_track(walk_in_process, state)
      @points_locations = []

      @locations_track.each do |location_track|
        converted_timer = location_track.timer.strftime('%H:%M:%S')
        if ((state == 0) && (converted_timer <= actual_time) && (location_track.timer.to_date <= Time.now.to_date))
          @points_locations << [location_track.latitude, location_track.longitude] 
        else
          break
        end
      end

      return @points_locations
    end

    def get_locations_finalized(finished_walk, actual_time, state)
      @locations_track = get_locations_track(finished_walk, state)
      @points_locations = []
      
      @locations_track.each do |location_track|
        converted_timer = location_track.timer.strftime('%H:%M:%S')
        if ((state == 1) && (converted_timer <= actual_time)) || (location_track.timer.to_date <= Time.now.to_date)
          @points_locations << [location_track.latitude, location_track.longitude] 
        else
          break
        end
      end

      return @points_locations
    end

    def pet_params
      params.require(:pet).permit(:name, :num_chip, :born_date, :user_id, :comment, :race, :avatar)
    end

end
