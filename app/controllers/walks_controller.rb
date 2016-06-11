class WalksController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy]

  # GET /walk
  # GET /walk.json
  def index
    @walks = Walk.all
    @hash = Gmaps4rails.build_markers(@walks) do |walk, marker|
      marker.lat 43.124228 #walk.latitude
      marker.lng 5.928 # walk.longitude
    end
  end

  # GET /walk/1
  # GET /walk/1.json
  def show
  end

  # GET /walk/new
  # def new
  #   @walk = Walk.new
  # end

  # GET /walk/1/edit
  # def edit
  # end

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
    @walk.destroy
    respond_to do |format|
      format.html { redirect_to walk_url, notice: 'Route was successfully destroyed.' }
      format.json { head :no_content }
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
end
