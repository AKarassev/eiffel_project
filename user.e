class USER
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit
	COMPARABLE 
	redefine is_equal end

creation{ANY}
	make, setnom, setprenom

feature{}
	nom, prenom, iduser : STRING
	mediatheque : MEDIATHEQUE

feature{ANY}
	
	make (id, p, n : STRING; mt : MEDIATHEQUE)  is
		do
			iduser := id
			nom := n
			prenom := p
			mediatheque := mt
		end

	setnom (n : STRING) is
		-- Modification du nom de l'utilisateur
		do
			nom := n
		end

	setprenom (n : STRING) is
		-- Modification du prénom de l'utilisateur
		do
			prenom := n
		end

	getnom : STRING is
		-- Retourne le nom
		do
			Result:=nom
		end

	getprenom : STRING is
		--Retourne le prenom
		do
			Result:=prenom
		end

	getid : STRING is
		--Retourne l'identifiant
		do
			Result:=iduser
		end
       

	emprunter (m : MEDIA; te : ARRAY[EMPRUNT]) is
		local	
			new_emprunt : EMPRUNT
		do
			create new_emprunt.make(Current, m, 0,0,0) --TODO gérer les dates pour les emprunts. Constantes pour le delai?
			te.add_first(new_emprunt)
		end

	to_string : STRING is
		do
			Result := "%N Identifiant :"+iduser+"%N Nom: "+nom+"%N Prénom: "+prenom+"%N"
		end

	--L'égalité de deux users se fait uniquement sur iduser
	is_equal(other : like Current) : BOOLEAN is
		do
			Result := iduser.is_equal(other.getid)
		end

	--Méthode nécessaire pour implémenter is_equal
	infix "<" (other: like Current) : BOOLEAN is
		do	
			Result := iduser < other.getid
		end

end -- classe USER

			
			
