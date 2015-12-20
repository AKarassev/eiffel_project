class ADMIN
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit 
	USER
	redefine to_string end

creation{ANY}
	make

feature{ANY}
	

	ajouteruser (new_user : USER) is
		-- Ajout d'un nouvel utilisateur dans un tableau d'utilisateur
		--pre : iduser du nouveau user doit être unique dans le tableau
		--post : le nouveau user existe dans le tableau
		--post : la taille du tableau est incrémentée
		require
			user_not_exists : mediatheque.getusers.has(new_user) = False	
		do
			mediatheque.ajouteruser(new_user) -- Add a new item in first position : [...] all other items are shifted right.
		ensure
			user_exists : mediatheque.getusers.has(new_user) = True
			array_length_increment : mediatheque.getusers.upper = old mediatheque.getusers.upper + 1 
		end -- fonction ajouteruser

		
		

       modifieruser (old_user, new_user: USER) is
		-- Modification d'un utilisateur se trouvant dans un tableau d'utilisateur
		-- pre: le user correspondant à l'identifiant doit exister 		
		-- pre: un admin ne peut pas modifier un autre administrateur			TODO
		require
			user_exists : mediatheque.getusers.has(old_user) = True
		local
			i : INTEGER
		do
			i := mediatheque.getusers.first_index_of(old_user)
			mediatheque.getusers.force(new_user, i)			
		end --fonction modifieruser
			
		

       supprimeruser (rem_user : USER) is
		-- Suppression d'un utilisateur se trouvant dans un tableau d'utilisateur
		-- pre: le user correspondant à l'identifiant doit exister
		-- pre: un administrateur ne peut pas supprimer un autre administrateur		TODO
		-- post: le user correspondant à l'identifiant n'existe plus dans le tableau
		-- post: la taille du tableau est décrémentée

		require
			user_exists : mediatheque.getusers.has(rem_user) = True
		local
			i : INTEGER
		do
			i := mediatheque.getusers.first_index_of(rem_user)
			mediatheque.getusers.remove(i)
		ensure
			user_not_exists : mediatheque.getusers.has(rem_user) = False
			array_length_decrement : mediatheque.getusers.upper = old mediatheque.getusers.upper - 1 		
		end -- fonction supprimeruser

	to_string : STRING is
		do
			Result := Precursor + " Admin: oui %N"
		end
       		


end -- classe ADMIN

			
			
