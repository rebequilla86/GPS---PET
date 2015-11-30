class PetsController < ApplicationController

  def index
  	@pet = Pet.all
  	authorize @pet
  end

  def show
    @pet = Pet.find(params[:id])
    authorize @pet
  end

  def new
  	@pet = Pet.new
  	authorize @pet
  end

  def edit
    @pet = Pet.find(params[:id])
    authorize @pet
  end

  def create
    @pet = Pet.new(pet_params)
    
    if @pet.save
      redirect_to @pet
    else
      render 'new'
    end
  end

  def update
    @pet = Pet.find(params[:id])
    authorize @pet
 
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

  private
    def pet_params
      params.require(:pet).permit(:name, :num_chip, :born_date, :color_hair, :color_eyes, :comment)#:race,
    end

end
