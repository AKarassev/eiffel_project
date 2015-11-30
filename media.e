class MEDIA
--
-- Classe représentant les médias
-- Cette classe sera abstraite par la suite
--
creation{ANY}
       make

feature{}
       idmedia : INTEGER
       titre : STRING

feature{ANY}
	make (id : INTEGER; t : STRING) is
	      -- Création d'un nouveau media
	require
		n >= 1
	do
		idmedia := id
		titre := t
	end	
			

end -- classe MEDIA

