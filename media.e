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
	annee : INTEGER 
	genre : STRING

feature{ANY}

	make (id : INTEGER; t : STRING;  a : INTEGER; g : STRING) is
	      -- Création d'un nouveau media
	do
		idmedia := id
		titre := t
		annee := a
		genre := g
	end

	setid (id : INTEGER) is
	do
		idmedia := id
	end

	settitre (t : STRING) is
	do
		titre := t
	end

	setannee (a : INTEGER) is
	do
		annee := a
	end

	setgenre (g : INTEGER) is
	do
		genre := g
	end

	getid : STRING is
	do
		Result := idmedia
	end

	gettitre : STRING is
	do
		Result := titre
	end

	getannee : INTEGER is
	do
		Result := annee
	end

	getgenre : STRING  is
	do
		Result := genre
	end
		
			

end -- classe MEDIA

