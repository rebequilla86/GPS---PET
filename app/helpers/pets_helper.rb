module PetsHelper
	def get_pets(onwer_hire_walker)
		onwer_hire_walker.each do |owner| 
    	@pets = Pet.where(user_id: owner.id) 
    end
	end
end
