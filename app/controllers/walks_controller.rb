class WalksController < ApplicationController
  before_action :set_walk, only: [:show, :edit, :update, :destroy]

  # GET /walk
  # GET /walk.json
  def index
    @my_walks = Walk.where(walker: current_user.id).order('id DESC')
    @walks_in_process = Walk.where(state: 'in_process')
    @actual_time = Time.now.strftime('%H:%M:%S')

    if @my_walks.blank?
      @walk = []
      @location_gran_canaria = Location.create(latitude: 28.127222, longitude: -15.431389)
      @last_point = @location_gran_canaria
      @points_locations = [[@last_point.latitude, @last_point.longitude]]

      @state = 1
    else
      if @walks_in_process.size >= 1
        @walks_in_process.each do |w|
          @walk_id = w.id
          @walk_name = w.name
          @pet_name = Pet.find(w.pet_id).name

          update_walks(w, @actual_time)
        end
      else
        @walk = @my_walks.first
        @walk_id = @walk.id

        get_points_locations(@walk, @actual_time, 1)
      end
    end

    get_point_map(@last_point)

    @pet_walker = []
    respond_to do |format| 
      format.html       
      format.json { render json: { points_locations: @points_locations, state: @state, walk_id: @walk_id, walks: @walks_in_process } }
    end
  end

  # GET /walk/1
  # GET /walk/1.json
  def show
    @my_walks = Walk.where(walker: current_user.id).order('id DESC')
    @actual_time = Time.now.strftime('%H:%M:%S')

    @walk = params[:id].to_i.blank? ? @my_walks.first : Walk.find(params[:id].to_i)
    @walk_name = @walk.name
    @walk_id = @walk.id
  
    @pet_name = Pet.find(@walk.pet_id).name unless @walk.pet_id.blank?

    update_walks(@walk, @actual_time)

    get_point_map(@last_point)
    
    @pet_walker = []
    respond_to do |format| 
      format.html       
      format.json { render json: { points_locations: @points_locations, state: @state, walk_id: @walk.id, walk: @walk } }
    end
  end

  # GET /walk/new
  def new
    @walk = Walk.new
  end

  # GET /walk/1/edit
  def edit
  end

  # POST /walk
  # POST /walk.json
  def create
    @walk = Walk.new(walk_params)

    respond_to do |format|
      if @walk.save
        format.html { redirect_to @walk, notice: 'Route was successfully created.' }
        format.json { render :show, status: :created, location: @walk }
      else
        format.html { render :new }
        format.json { render json: @walk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /walk/1
  # PATCH/PUT /walk/1.json
  def update
    respond_to do |format|
      if @walk.update(walk_params)
        format.html { redirect_to @walk, notice: 'Route was successfully updated.' }
        format.json { render :show, status: :ok, location: @walk }
      else
        format.html { render :edit }
        format.json { render json: @walk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /walk/1
  # DELETE /walk/1.json
  def destroy
    @walk = Walk.find(params[:id])
    @walk.destroy
    @walk.save!
    respond_to do |format|
      format.html { redirect_to pet_routes_path(@walk.pet_id), notice: 'Se ha borrado la ruta satisfactoriamente.' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_walk
    @walk = Walk.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def walk_params
    params[:walk]
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

  def update_walk_in_process(walk_in_process, state, account_points_locations, last_point, coordinates, last_point_at_moment)
    @track_id = get_track_id(walk_in_process, state)
    duration_walk = Time.at(account_points_locations * 5).utc.strftime("%H:%M:%S")
    walk_in_process.last_data_received = last_point_at_moment.timer
    walk_in_process.duration = duration_walk
    walk_in_process.state = (last_point - coordinates == []) ? 1 : 0
    walk_in_process.save!
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
    @last_point_at_moment = Location.where("latitude = #{last_point_latitude} AND longitude = #{last_point_longitude}").last
    Rails.logger.info "....................."
    Rails.logger.info last_point_latitude
    Rails.logger.info last_point_longitude
    Rails.logger.info @last_point_at_moment.timer
    Rails.logger.info "....................."
    return @last_point_at_moment
  end

  def get_track_id(walk_in_process, state)
    walk_id = walk_in_process.id
    track_in_process = Track.where(walk_id: walk_id)
    return @track_id = track_in_process.to_a[0].id
  end

  def get_locations_track(walk_in_process, state)
    @track_id = get_track_id(walk_in_process, state)

    return @locations_track = Location.where(track_id: @track_id)
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

  def get_points_locations(walk, actual_time, state)
    @points_locations = get_locations_finalized(walk, actual_time, state)
    @last_point = @points_locations.last if @points_locations.present?

    unless @last_point.nil?
      @last_point_at_moment = get_last_point_at_moment(@last_point)
    end
    @state = state
  end

  def update_walks(walk, actual_time)
    if walk.state == 'in_progress' 
      @state = 0
      @points_locations = get_locations_in_process(walk, actual_time, @state)

      @account_points_locations = @points_locations.count
      @last_point = @points_locations.last if @points_locations.present?
      @coordinates = get_last_point_track(walk, @state)

      unless @last_point.nil?
        @last_point_at_moment = get_last_point_at_moment(@last_point) 
        update_walk_in_process(walk, @state, @account_points_locations, @last_point, @coordinates, @last_point_at_moment)
      end

      @duration = @last_point_track.timer unless @last_point_track.nil?
      if @duration.to_date == Time.now.to_date
        if (@duration.strftime('%H:%M:%S') < @actual_time) && (@last_point - @coordinates == [])
          walk.state = 1
          walk.last_data_received = @last_point_at_moment.timer
          walk.duration = Time.at(@account_points_locations * 5).utc.strftime("%H:%M:%S")
          walk.save!
          @state = 1
        end 
      end unless @duration.nil?
    else
      get_points_locations(walk, actual_time, 1)
    end
  end

  def get_point_map(last_point)
    @last_point_at_moment = get_last_point_at_moment(last_point) unless last_point.nil?

    @hash_map = Gmaps4rails.build_markers(@last_point_at_moment) do |location, marker|
      marker.lat location.latitude  
      marker.lng location.longitude  
    end

    if current_user.is_walker.nil?
      @walker_current_user = User.where(walker: current_user.walker)
      @pet_current_user = Pet.where(user_id: current_user.walker).map(&:id)
    else
      @walker_current_user = User.where(walker: current_user.id)
      @pet_current_user = Pet.where(user_id: current_user.hired).map(&:id)
    end
  end
end
