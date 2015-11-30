class USER
--
-- 
--

creation{ANY}
	make, setnom, setprenom

feature{ANY}
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


	--is_equal(other : USER) : BOOLEAN is

		--do
			--Result := iduser.is_equal(u.getid)
		--end

end -- classe USER

			
			
