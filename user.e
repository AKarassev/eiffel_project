class USER
--
-- 
--

creation{ANY}
	make, setNom, setPrenom, getNom, getPrenom

feature{ANY}
	idUser : INTEGER
	nom, prenom : STRING

feature{}
	make (n : INTEGER;a,b : STRING) is
		-- Création d'un nouvel utilisateur
		require
			n >= 1
		do
			idUser := n
			nom := a
			prenom := b
		end

	setNom (n : STRING) is
			-- Modification du nom de l'utilisateur
		do
			nom := n
		end

	setPrenom (n : STRING) is
			-- Modification du prénom de l'utilisateur
		do
			prenom := n
		end

end -- classe USER

			
			
