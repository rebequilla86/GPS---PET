class PetsController < ApplicationController

  def index
  	@pet = Pet.all
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
 
    if @pet.update(pet_params)
      redirect_to @pet
    else
      render 'edit'
    end
  end

  def destroy
    @pet = Pet.find(params[:id])
    @pet.destroy
 
    redirect_to root_path
  end

  private
    def pet_params
      params.require(:pet).permit(:name, :num_chip, :born_date, :user_id, :comment)# :race)
    end

end
