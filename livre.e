class LIVRE
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit MEDIA	

creation{ANY}
	make_livre

feature{}
	auteur : STRING

feature{ANY}

	make_livre (id : INTEGER; t : STRING;  an : INTEGER; g : STRING; aut : STRING) is
		make(id, t, an, g)
		auteur := aut
	end

	setauteur (a : STRING) is
	do
		auteur := a
	end

	getauteur : STRING is
	do
		Result := auteur
	end


end -- class LIVRE
