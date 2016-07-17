class WalksController < ApplicationController
  before_action :set_walk, only: [:show, :edit, :update, :destroy]

  # GET /walk
  # GET /walk.json
  def index
    @my_walks = Walk.where(walker: current_user.id).order('id DESC')
    @actual_time = Time.now.strftime('%H:%M:%S')

    @walk = params[:walk_id].blank? ? @my_walks.first : Walk.find(params[:walk_id].to_i)
    @walk_name = @walk.name
    @pet_name = Pet.find(params[:pet_id].to_i).name unless params[:pet_id].blank?

    if @walk.state == 'in_progress' 
      @state = 0
      @points_locations = get_locations_in_process(@walk, @actual_time, @state)

      @account_points_locations = @points_locations.count
      @last_point = @points_locations.last if @points_locations.present?
      @coordinates = get_last_point_track(@walk, @state)

      unless @last_point.nil?
        @last_point_at_moment = get_last_point_at_moment(@last_point) 
        update_walk_in_process(@walk, @state, @account_points_locations, @last_point, @coordinates, @last_point_at_moment)
      end

      @duration = @last_point_track.timer unless @last_point_track.nil?
      if @duration.to_date == Time.now.to_date
        if (@duration.strftime('%H:%M:%S') < @actual_time) && (@last_point - @coordinates == [])
          @walk.state = 1
          @walk.last_data_received = @last_point_at_moment.timer
          @walk.duration = Time.at(@account_points_locations * 5).utc.strftime("%H:%M:%S") #@duration.strftime("%H:%M:%S") 
          @walk.save!
          @state = 1
        end 
      end unless @duration.nil?
    else
      @points_locations = get_locations_finalized(@walk, @actual_time, 1)
      @last_point = @points_locations.last if @points_locations.present?

      unless @last_point.nil?
        @last_point_at_moment = get_last_point_at_moment(@last_point)
      end
      @state = 1
    end

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

    @pet_walker = []
    respond_to do |format| 
      format.html       
      format.json { render json: { points_locations: @points_locations, state: @state, walk_id: @walk.id, walks: @my_walks } }
    end
  end

  # GET /walk/1
  # GET /walk/1.json
  def show
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
      @walk.last_data_received = last_point_at_moment.timer
      @walk.duration = duration_walk
      @walk.state = (last_point - coordinates == []) ? 1 : 0
      @walk.save!
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
end
