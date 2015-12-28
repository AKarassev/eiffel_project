class LIVRE
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit MEDIA
	redefine to_string, is_equal, infix "<" end	

creation{ANY}
	make_livre, make_livre_from_media

feature{}
	auteur : STRING

feature{ANY}

	make_livre (t : STRING; aut : STRING; nb : INTEGER; mt : MEDIATHEQUE) is
	do
		make( t, nb, mt)
		auteur := aut
	end

	make_livre_from_media(m : MEDIA) is
	do
		make(m.gettitre, m.getnb_exemplaire, m.getmediatheque)
		auteur := ""
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
			Result := Precursor + "%N Auteur : " + auteur + "%N"
		end

       is_equal(other: like Current): BOOLEAN is
       do
		if titre.is_equal(other.gettitre) then
			if auteur.is_equal(other.getauteur) then
				Result := True
			end
		else	
			Result := False
		end
       end


	infix "<" (other : like Current): BOOLEAN is
       	do
		if not (titre < other.gettitre) and not (other.gettitre < titre) then
			Result := auteur < other.getauteur
		else 
			Result := titre < other.gettitre
		end
       	end



end -- class LIVRE
