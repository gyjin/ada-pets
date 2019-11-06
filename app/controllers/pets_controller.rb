class PetsController < ApplicationController
  # def index
  #   pets = Pet.all
  
  #   # below code returns only the keys we specify 
  #   render :json => pets.as_json(only: [:id, :name, :age, :human]), status: :ok
  
  #   # below code returns all variables of each object
  #   # render json: pets, status: :ok
  # end
  
  def show
    pet = Pet.find_by_id(params[:id])
    
    if pet.nil?
      render json: {"errors" => "no pet by that ID"}, status: :not_found
      return
    end
    
    render :json => pet.as_json(only: [:id, :name, :age, :human]), status: :ok
  end
  
  private
  
  def pet_params
    params.require(:pet).permit(:name, :age, :human)
  end
end
