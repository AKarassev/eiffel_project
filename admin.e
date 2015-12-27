class ADMIN
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit 
	USER
	redefine to_string end

creation{ANY}
	make, make_from_user

feature{ANY}


	make_from_user ( u : USER ) is
		do
			iduser := u.getid
			nom := u.getnom
			prenom := u.getprenom
			mediatheque := u.getmediatheque
			quota := mediatheque.getquota
			nb_emprunt := 0			
		end
	

	ajouteruser (new_user : USER) is
		-- Ajout d'un nouvel utilisateur dans un tableau d'utilisateur
		--pre : iduser du nouveau user doit être unique dans le tableau
		--post : le nouveau user existe dans le tableau
		--post : la taille du tableau est incrémentée
		require
			user_not_exists : mediatheque.has_user(new_user) = False	
		do
			mediatheque.ajouteruser(new_user) -- Add a new item in first position : [...] all other items are shifted right.
		ensure
			user_exists : mediatheque.has_user(new_user) = True
			array_length_increment : mediatheque.getusers.upper = old mediatheque.getusers.upper + 1 
		end -- fonction ajouteruser

		
		

       modifieruser (old_user, new_user: USER) is
		-- Modification d'un utilisateur se trouvant dans un tableau d'utilisateur
		-- pre: old_user doit exister
		-- pre: seul un superadministrateur peut supprimer un administrateur
		-- post : l'identifiant de new_user doit être unique ou identique à celui de old_user TODO   @old
		require
			user_exists : mediatheque.has_user(old_user) = True
			is_superadmin : not ({SUPERADMIN} ?:= Current) implies not ({ADMIN} ?:= old_user)
		do
			mediatheque.modifieruser(old_user, new_user)		
		end --fonction modifieruser
			
		

       supprimeruser (rem_user : USER) is
		-- Suppression d'un utilisateur se trouvant dans un tableau d'utilisateur
		-- pre: le user correspondant à l'identifiant doit exister
		-- pre: seul un superadministrateur peut supprimer un autre administrateur	
		-- post: le user correspondant à l'identifiant n'existe plus dans le tableau
		-- post: la taille du tableau est décrémentée
		require
			user_exists : mediatheque.has_user(rem_user) = True
			is_superadmin: not ({SUPERADMIN} ?:= Current) implies not ({ADMIN} ?:= rem_user)
		do
			mediatheque.supprimeruser(rem_user)
		ensure
			user_not_exists : mediatheque.has_user(rem_user) = False
			array_length_decrement : mediatheque.getusers.upper = old mediatheque.getusers.upper - 1 		
		end -- fonction supprimeruser

	ajoutermedia (new_media : MEDIA) is
		-- pre : le media n'existe pas
		-- post : le media existe
		require
			media_not_exists : mediatheque.has_media(new_media) = False
		do
			mediatheque.ajoutermedia(new_media)
		ensure
			media_exists : mediatheque.has_media(new_media) = True
		end

	modifiermedia ( old_media, new_media : MEDIA ) is
		-- pre : old_media existe
		-- post : new_media est unique TODO @old
		require 
			media_exists : mediatheque.has_media(old_media) = True
		do
			mediatheque.modifiermedia(old_media, new_media)
		end

	supprimermedia ( rem_media : MEDIA ) is
		-- pre : le media existe
		-- post : le media n'existe pas
		require
			media_exists : mediatheque.has_media(rem_media) = True
		do
			mediatheque.supprimermedia(rem_media)
		ensure 
			media_not_exists : mediatheque.has_media(rem_media) = False
		end
		

	to_string : STRING is
		do
			Result := Precursor + " Admin: oui %N"
		end
       		


end -- classe ADMIN

			
			
