# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

# race_list = [ 
# 	"Affenpinscher", "Airedale Terrier", "Akita Inu Americano", "Akita Inu Japonés", "Alano Español", "Alaskan Malamute",
# 	"American Bully", "American Staffordshire Terrier", "American Water Spaniel", "Anglo-Francais de Petite Vénerie",
# 	"Australian Terrier", "Barbet", "Barbino", "Basenji", "Basset Artésien Normand", "Basset Azul de Gascuña",
# 	"Basset Fauve de Bretagne", "Basset Hound", "Beagle", "Beagle Harrier",	"Bearded Collie",	"Beauceron",
# 	"Bedlington Terrier", "Bichón Frise", "Bichón Habanero", "Bichón Maltés", "Billy", "Blanck and Tan Coonhound",
# 	"Bloodhound", "Bobtail", "Bodeguero Andaluz", "Boerboel", "Border Collie", "Border Terrier", "Borzoi", 
# 	"Boston Terrier", "Bóxer", "Boyero", "Braco", "Briard", "Brittany", "Broholmer", "Buhund noruego", "Bull Terrier",
# 	"Bulldog", "Bullmastín", "Cairn Terrier", "Cane Corso", "Caniche", "Carlino", "Cavalier King Charles", "Chihuahua",
# 	"Chin Japonés", "Chow Chow", "Cimarrón Uruguayo", "Cinerco Del Etna", "Clumber Spaniel", "Cobrador de Nueva Escocia",
# 	"Coocker", "Collie", "Corgi Galés", "Cotón de Tuléar", "Curly Coated Retriever", "Dálmata", "Dandie", "Deerhound", 
# 	"Doberman", "Dogo", "Drever", "Elkhound", "Epagneul", "Eurasier", "Faraón Hound", "Field", "Fila", "Fox Terrier",
# 	"Foxhound", "Galgo", "Gascon", "Glen Of Imaal Terrier", "Golden Retriever", "Gran Basset", "Gran Danés", 
# 	"Greyhound", "Grifón", "Hamilton Stovare", "Harrier", "Husky Siberiano", "Irish Soft", "Jack Russell",
# 	"Jamthund", "Kai", "Kerry Blue", "Korea Jinco Dog", "Kuvasz", "Labrador Retriever", "Laïka de Siberia oriental",
# 	"Lakeland Terrier", "Lebrel Húngaro", "Lhasa Apso", "Löwchen", "Malamute de Alaska", "Mastín", "Mudi",
# 	"Otterhound", "Papillon", "Pastor Alemán", "Pastor Belga", "Pastor de Beauce", "Pequinés", "Perdiguero",
# 	"Perro de Agua", "Perro de Groenlandia", "Perro de pastor", "Perro Lobo de Sarloos", "Pointer", "Rastreador de Hannover",
# 	"Rottweiler", "Sabueso", "Samoyedo", "San Bernardo", "Schnauzer", "Shar Pei", "Staffordshire Bull Terrier", 
# 	"Terranova", "Terrier", "Volpino Italiano", "Wetterhound", "Whippet", "Yorkshire Terrier"
# ]

# race_list.each do |name|
#   Race.create( name: name )
# end
