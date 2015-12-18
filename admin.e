class ADMIN
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit USER

creation{ANY}
	make

feature{ANY}
	

	ajouteruser (new_user : USER; tu : ARRAY[USER]) is
		-- Ajout d'un nouvel utilisateur dans un tableau d'utilisateur
		--pre : iduser du nouveau user doit être unique dans le tableau
		--post : le nouveau user existe dans le tableau
		--post : la taille du tableau est incrémentée
		require
			user_not_exists : tu.has(new_user) = False	
		do
			--create new_user.make(id, n, p)
			tu.add_first(new_user) -- Add a new item in first position : [...] all other items are shifted right.
		ensure
			user_exists : tu.has(new_user) = True
			array_length_increment : tu.upper = old tu.upper + 1 
		end -- fonction ajouteruser

		
		

       modifieruser (old_user, new_user: USER; tu : ARRAY[USER]) is
		-- Modification d'un utilisateur se trouvant dans un tableau d'utilisateur
		-- pre: le user correspondant à l'identifiant doit exister 		
		-- pre: un admin ne peut pas modifier un autre administrateur			TODO
		require
			user_exists : tu.has(old_user) = True
		local
			i : INTEGER
		do
			i := tu.first_index_of(old_user)
			tu.force(new_user, i)			
		end --fonction modifieruser
			
		

       supprimeruser (rem_user : USER; tu : ARRAY[USER]) is
		-- Suppression d'un utilisateur se trouvant dans un tableau d'utilisateur
		-- pre: le user correspondant à l'identifiant doit exister
		-- pre: un administrateur ne peut pas supprimer un autre administrateur		TODO
		-- post: le user correspondant à l'identifiant n'existe plus dans le tableau
		-- post: la taille du tableau est décrémentée

		require
			user_exists : tu.has(rem_user) = True
		local
			i : INTEGER
		do
			i := tu.first_index_of(rem_user)
			tu.remove(i)
		ensure
			user_not_exists : tu.has(rem_user) = False
			array_length_decrement : tu.upper = old tu.upper - 1 		
		end -- fonction supprimeruser
       		


end -- classe ADMIN

			
			
