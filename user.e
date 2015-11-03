class USER
--
-- 
--

creation{ANY}
	make, setnom, setprenom--, getnom--, getall--, getnom, getprenom

feature{ANY}
	nom, prenom, iduser : STRING

feature{}
	make (n,a,b : STRING) is
		-- Création d'un nouvel utilisateur
		do
			iduser := n
			nom := a
			prenom := b
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

end -- classe USER

			
			
