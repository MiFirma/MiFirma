require 'csv'

module ProposalsHelper

def attestors_list
  
	## OJO, los t�tulos de los campos est�n en la vista list.csv.erb
	## Nombre, Apellidos, DNI, email
  CSV.generate do |csv| 
    @attestors.each do |attestor|
      csv << [ attestor.name, attestor.surname, attestor.dni, attestor.email ]
    end
  end
end

end
