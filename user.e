class USER
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--

creation{ANY}
	make, setnom, setprenom

feature{}
	nom, prenom, iduser : STRING

feature{ANY}
	
	make (id, p, n : STRING)  is
		do
			iduser := id
			nom := n
			prenom := p
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
			!!new_emprunt.make(Current, m, 0,0,0) --TODO gérer les dates pour les emprunts. Constantes pour le delai?
			te.add_first(new_emprunt)
		end

	to_string : STRING is
		do
			Result := "%N Identifiant :"+iduser+"%N Prénom: "+prenom+"%N Nom: "+nom+"%N"
		end

	--Comment redéfinir la fonction is_equal?
	--is_equal(other : USER) : BOOLEAN is

		--do
			--Result := iduser.is_equal(u.getid)
		--end

end -- classe USER

			
			
