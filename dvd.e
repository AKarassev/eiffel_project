class DVD
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit MEDIA
	redefine to_string end

creation{ANY}
	make_dvd

feature{}
	realisateur : ARRAY[STRING]
	annee : INTEGER
	acteur : ARRAY[STRING]
	type : STRING

feature{ANY}
	make_dvd ( tit : STRING;  an : INTEGER; real , act : ARRAY[STRING]; ty : STRING; nb : INTEGER; mt : MEDIATHEQUE) is
	do
		make(tit, nb, mt)
		create realisateur.make(1,1)
		create acteur.make(1,1)
		realisateur.copy(real)
		acteur.copy(act)
		type := ty
		annee := an
		mediatheque := mt
	end

	setrealisateur (real : ARRAY[STRING]) is
	do
		realisateur.copy(real)
	end

	setacteur (a : ARRAY[STRING]) is
	do
		acteur.copy(a)
	end

	settype (t : STRING) is
	do
		type := t
	end

	getrealisateur : ARRAY[STRING]  is
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

	to_string : STRING is
	local
		out_str : STRING
		i : INTEGER
	do
		out_str := Precursor + "%N Année :"+ annee.to_string
		out_str := out_str+"%N Réalisateurs : "
		from 
			i := 1
		until
			i = realisateur.upper
		loop
			out_str := out_str + realisateur.item(i) + ", "
			i := i + 1 	
		end

		out_str := out_str+"%N Acteurs : "
		from 
			i := 1
		until
			i = acteur.upper
		loop
			out_str := out_str + acteur.item(i) + ", "
			i := i + 1 	
		end

		if type.count > 0 then
			out_str := out_str + "%N Type :" + type
		end
		Result := out_str
	end	


end -- class DVD
