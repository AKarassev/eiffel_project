class MEDIA
--
-- Classe représentant les médias
-- Cette classe sera abstraite par la suite
--
creation{ANY}
       make

feature{}
	titre : STRING
	annee : INTEGER 

feature{ANY}

	make (t : STRING;  a : INTEGER) is
	      -- Création d'un nouveau media
	do
		titre := t
		annee := a
	end

	settitre (t : STRING) is
	do
		titre := t
	end

	setannee (a : INTEGER) is
	do
		annee := a
	end

	gettitre : STRING is
	do
		Result := titre
	end

	getannee : INTEGER is
	do
		Result := annee
	end

		
			

end -- classe MEDIA

