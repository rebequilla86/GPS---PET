module ApplicationHelper
	def avatar_url(user, size)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.pngs?=#{size}"
  end

	def sortable(column, title = nil)
	  title ||= column.titleize
	  css_class = column == sort_column ? "current #{sort_direction}" : nil
	  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
	  link_to title, {:sort => column, :direction => direction}, {:class => css_class}
	end

	def get_races(user)
		owner_hire_walker = User.where(walker: user.id) 
		@races = []
  	owner_hire_walker.each do |user|
  		@pets = Pet.where(user_id: user.id)
  		@pets.each do |pet|
  			@races << pet.race
  		end
    end
    return @races
	end

end
