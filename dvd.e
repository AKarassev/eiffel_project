class DVD
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit MEDIA
	redefine to_string end

creation{ANY}
	make_dvd, make_dvd_from_media

feature{}
	realisateur, acteur : ARRAY[STRING]
	annee : INTEGER
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
	end

	make_dvd_from_media ( m : MEDIA ) is
	do
		make(m.gettitre, m.getnb_exemplaire, m.getmediatheque)
		create realisateur.make(1,1)
		create acteur.make(1,1)	
		type := ""
		annee := 0	
	end

	setannee ( a : INTEGER ) is
	do
		annee := a
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
	
	getannee : INTEGER is
	do
		Result := annee
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

	ajouteracteur ( a : STRING ) is
	do
		acteur.add_first(a)
	end

	supprimeracteur ( a :STRING ) is
	local
		i : INTEGER	
	do
		i := acteur.first_index_of(a)
		realisateur.remove(i)
	end

	ajouterrealisateur ( r : STRING ) is
	do
		realisateur.add_first(r)
	end

	supprimerrealisateur ( r : STRING ) is
	local
		i : INTEGER
	do
		i := realisateur.first_index_of(r)
		realisateur.remove(i)
	end

	to_string : STRING is
	local
		out_str : STRING
		i : INTEGER
	do
		out_str := Precursor + "%N Année : "+ annee.to_string
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
			out_str := out_str + "%N Type : " + type
		end
		Result := out_str
	end	


end -- class DVD
