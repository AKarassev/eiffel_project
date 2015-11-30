class ADMIN
--
-- 
--
inherit USER

creation{ANY}
	make

feature{ANY}
	

	ajouteruser (id, n, p : STRING; tu: ARRAY[USER]) is
		-- Ajout d'un nouvel utilisateur dans un tableau d'utilisateur
		--pre : l'identifiant doit être unique dans le tableau
		local
			new_user : USER
		do
			!!new_user.make(id, n, p)
			tu.add_last(new_user)
		end -- fonction ajouteruser

		
		

       modifieruser (id, n, p: STRING) is
		-- Modification d'un utilisateur se trouvant dans un tableau d'utilisateur
		-- pre: l'utilisateur correspondant à l'identifiant doit exister
		local
			i : INTEGER
		do
		
		end --fonction modifieruser
			
		

       supprimeruser (id: STRING) is
		-- Suppression d'un utilisateur se trouvant dans un tableau d'utilisateur
		local
			i : INTEGER
		do

		end -- fonction supprimeruser
       
		


end -- classe ADMIN

			
			
