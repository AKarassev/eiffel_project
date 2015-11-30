class DVD
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit MEDIA

creation{ANY}
	make_dvd

feature{}
	realisateur : STRING
	acteur : ARRAY[STRING]
	type : STRING

feature{ANY}
	make_dvd (id : INTEGER; tit : STRING;  an : INTEGER; g : STRING; r : STRING; act : ARRAY[STRING]; ty : STRING) is
		make(id, tit, an, g)
		realisateur := r
		acteur.copy(act)
		type := ty
	end

	setrealisateur (r : INTEGER) is
	do
		realisateur := r
	end

	setacteur (a : ARRAY[STRING]) is
	do
		acteur.copy(a)
	end

	settype (t : STRING) is
	do
		type := t
	end

	getrealisateur : STRING  is
	do
		Result := realisateur
	end

	getacteur : ARRAY[STRING]  is
	do
		Result := acteur
	end

	gettype : STRING  is
	do
		Result := type
	end	


end -- class DVD
