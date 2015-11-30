class ADMIN
--
-- 
--
inherit USER

creation{ANY}
	make

feature{ANY}
	

	ajouteruser (id, p, n : STRING; tu : ARRAY[USER]) is
		-- Ajout d'un nouvel utilisateur dans un tableau d'utilisateur
		--pre : l'identifiant doit être unique dans le tableau
		local
			new_user : USER
		do
			!!new_user.make(id, n, p)
			tu.add_first(new_user) -- Add a new item in first position : [...] all other items are shifted right.
		end -- fonction ajouteruser

		
		

       modifieruser (id, p, n : STRING; tu : ARRAY[USER]) is
		-- Modification d'un utilisateur se trouvant dans un tableau d'utilisateur
		-- pre: l'utilisateur correspondant à l'identifiant doit exister
		local
			i : INTEGER
			found : BOOLEAN
		do
			found := False
			from 
				i := 1
			until
				found = True or i = tu.upper
			loop
				if (id.is_equal(tu.item(i).getid)) then
					tu.item(i).setnom(n)
					tu.item(i).setprenom(p)
					found := True
				end
				i := i + 1
			end
			if (found = False) then
				io.put_string("Erreur: cet utilisateur n'existe pas %N")
			end
					
		end --fonction modifieruser
			
		

       supprimeruser (id : STRING; tu : ARRAY[USER]) is
		-- Suppression d'un utilisateur se trouvant dans un tableau d'utilisateur
		-- pre: l'utilisateur correspondant à l'identifiant doit exister
		local
			i : INTEGER
			found : BOOLEAN
		do
			found := False
			from 
				i := 1
			until
				found = True or i = tu.upper
			loop
				if (id.is_equal(tu.item(i).getid)) then
					tu.remove(i)
					found := True
				end
				i := i + 1
			end
			if (found = False) then
				io.put_string("Erreur: cet utilisateur n'existe pas %N")
			end
		end -- fonction supprimeruser
       
		


end -- classe ADMIN

			
			
