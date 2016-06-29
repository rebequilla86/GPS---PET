class WalksController < ApplicationController
  before_action :set_walk, only: [:show, :edit, :update, :destroy]

  # GET /walk
  # GET /walk.json
  def index
    #@walks = Walk.all
    @my_walks = Walk.where(walker: current_user.id).order('id DESC')
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
end
