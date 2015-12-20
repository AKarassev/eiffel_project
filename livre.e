class LIVRE
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit MEDIA
	redefine to_string end	

creation{ANY}
	make_livre

feature{}
	auteur : STRING

feature{ANY}

	make_livre (t : STRING; aut : STRING; nb : INTEGER; mt : MEDIATHEQUE) is
	do
		make( t, nb, mt)
		auteur := aut
		mediatheque := mt
	end

	setauteur (a : STRING) is
	do
		auteur := a
	end

	getauteur : STRING is
	do
		Result := auteur
	end

	to_string : STRING is
		do
			Result := Precursor + "%N Auteur :" + auteur + "%N"
		end


end -- class LIVRE
