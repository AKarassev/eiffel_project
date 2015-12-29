class INTERFACE
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
-- Classe de tests
--
creation{ANY}
	demarrage

feature
user : USER
admin : ADMIN
su : SUPERADMIN
mt : MEDIATHEQUE

feature{ANY}

-- visiteur : utilisateur non authentifier
-- utilisateur : instance de la classe user
-- administrateur : instance de la classe admin 
demarrage is
do
	create mt.make(5,30) -- par défaut
	-- TODO vérifier que les fichiers existent
	mt.import_user("utilisateurs.txt")
	mt.import_media("medias.txt")
	ecran_titre
end -- demarrage

ecran_titre is
local
	choix : INTEGER
do
	io.put_string("%N______________________________________________________%N%N")
	io.put_string("%N%N-------- LOGICIEL DE LA MEDIATHEQUE -------- %N%N")

	from 
		choix := -1
	until 
		choix = 0 
	loop
		io.put_string("1 - Se connecter à la médiathèque %N")
		io.put_string("0 - Quitter %N")
		
		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer
		inspect choix
		when 1 then
			authentification
		when 0 then
			--quitter le programme
			io.put_string("Vous quittez le programme %N")
		else
			io.put_string("Choix incorrect %N")
		end -- inspect
	end -- loop
end -- ecran_titre

--L'utilisateur s'identifie
authentification is
local
	i : INTEGER
	entree : STRING
do
	io.put_string("%NEntrez votre identifiant%N")
	io.read_line
	entree := ""
	entree.copy(io.last_string)
	create user.make(entree, "", "", mt)
	-- si user
	if mt.has_user(user) then 
		i := mt.indexof_user(user)
		user := mt.getusers.item(i)
		if {ADMIN} ?:= user then
			create admin.make_from_user(user)
		end
		io.put_string("Authentification réussie%N%N Bonjour, "+user.getprenom+"%N")
		menu	
	-- si superadmin
	elseif ( user.getid.is_equal(mt.getsu.getid)) then
		io.put_string("Authentification réussie, en tant que superutilisateur%N")
		user := mt.getsu
		admin := mt.getsu
		su :=  mt.getsu
		menu
	-- sinon on affiche un message d'erreur et on retourne à l'écran de démarrage
	else
		io.put_string("Identifiant incorrect%N")
		demarrage
	end -- if
end -- authentification


-- choix des fonctionnalité
menu is
local
	choix : INTEGER
do
	from
		choix := -1
	until
		choix = 0
	loop
		io.put_string("%N______________________________________________________%N%N")
		io.put_string("%NMENU%N")
		io.put_string("%N 1 - Emprunter un média")
		io.put_string("%N 2 - Rendre un média")
		io.put_string("%N 3 - Consulter ses emprunts%N")
		if {ADMIN} ?:= user then
		io.put_string("%N 4 - Gérer les utilisateurs")
		io.put_string("%N 5 - Gérer les médias")
		io.put_string("%N 6 - Gérer les emprunts%N")
		io.put_string("%N 7 - Importer un fichier")
		io.put_string("%N 8 - Exporter un fichier%N")
		io.put_string("%N 9 - Paramètres de la médiathèque%N")
		end -- if
		io.put_string("%N 0 - Se déconnecter %N")


		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer

		if {ADMIN} ?:= user then
			inspect choix
			when 1 then
				emprunter_un_media	
			when 2 then
				rendre_un_media
			when 3 then
				consulter_ses_emprunts
			when 4 then
				gerer_les_utilisateurs
			when 5 then
				gerer_les_medias
			when 6 then
				gerer_les_emprunts
			when 7 then
				importer_fichier
			when 8 then
				exporter_fichier
			when 9 then
				parametres
			when 0 then
				user := Void
				admin := Void
				su := Void
				io.put_string("%NDéconnexion%N%N")
			else
				io.put_string("%NChoix incorrect%N")
			end -- inspect
		else -- {USER}
			inspect choix
			when 1 then
				emprunter_un_media	
			when 2 then
				rendre_un_media
			when 3 then
				consulter_ses_emprunts
			when 0 then
				user := Void
				io.put_string("%NDéconnexion%N%N")				
			else
				if choix >= 4 and choix <=8 then -- trop la flemme de faire une autre boucle pour les user
					choix := -1
				end
				io.put_string("%NChoix incorrect%N")
			end
		end --if
	end -- loop
end -- menu

rechercher_un_media : ARRAY[MEDIA] is
local
	cat, choix : INTEGER
	key_word : STRING
	out_media : ARRAY[MEDIA]
do
--		io.put_string("%NEntrez le type du média que vous recherchez%N")
		io.put_string("%N 1 - Tous les médias")
		io.put_string("%N 2 - Livres")
		io.put_string("%N 3 - DVD%N")
		io.put_string("%N 0 - Retour %N")

		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer

		inspect choix
		when 1 then
			cat := 0	
		when 2 then
			cat := 1
		when 3 then
			cat := 2
		when 0 then
			-- que faire
		else
			io.put_string("%NChoix incorrect%N")
		end

		io.put_string("%NMots de votre recherche (titre, année, ...) : %N")
		io.read_line
		io.put_new_line
		key_word := io.last_string
		out_media := user.rechercher(key_word, cat)
		Result := out_media
		io.put_string(mt.to_string_array_media(out_media))
		io.put_new_line
		io.put_string("%NAppuyez sur ENTREE pour continuer%N")
		io.read_line
end

emprunter_un_media is
local
	numero : INTEGER
	media : MEDIA
	temps : TIME
	array_media : ARRAY[MEDIA]
do
	-- si l'utilisateur n'a pas atteint son quota d'emprunt
	if user.getquota >= user.getnb_emprunt then
		io.put_string("%NEntrez le type du média que vous voulez emprunter%N")
		array_media := rechercher_un_media
		-- s'il y a des résultats dans la recherche
		if array_media.item(1) /= Void then
			io.put_string("%NEntrez le numéro du média dans la liste%N")
			io.read_integer
			numero := io.last_integer
			media := array_media.item(numero)
			if mt.has_media(media) and numero < array_media.upper and numero >= 0  then
				if media.getnb_exemplaire > 0 then
					temps.update
					user.emprunter(media, temps)
					io.put_string("Emprunt enregistré")
				else
					io.put_string("Il n'y a plus d'exemplaires disponibles pour ce media")
				end -- if
			else
				io.put_string("Erreur, vous avez rentrer un mauvais numéro%N")
			end -- if
		-- si la recherche ne retourne aucun résultat
		else
			io.put_string("Aucun résultat%N")
		end -- if
	-- si le quota est atteint
	else
		io.put_string("Vous ne pouvez plus emprunter, vous avez atteint votre quota%N")
	end
end

rendre_un_media is
local
	numero : INTEGER
	media : MEDIA
	temps : TIME
	array_media : ARRAY[MEDIA]
	tmp_emprunt : EMPRUNT
do
	-- si l'utilisateur n'a pas atteint son quota d'emprunt
	if user.getquota >= user.getnb_emprunt then
		io.put_string("%NEntrez le type du média que vous voulez emprunter%N")
		array_media := rechercher_un_media
		-- s'il y a des résultats dans la recherche
		if array_media.item(1) /= Void then
			io.put_string("%NEntrez le numéro du média dans la liste%N")
			io.read_integer
			numero := io.last_integer
			media := array_media.item(numero)
			if mt.has_media(media) and numero < array_media.upper and numero >= 0 then
				temps.update
				create tmp_emprunt.make(user, media, temps)
				-- l'utilisateur doit avoir emprunté le media
				if mt.getemprunts.has(tmp_emprunt) then
					user.rendre(media, temps)
					io.put_string("Emprunt rendu")
				else
					io.put_string("Il n'y a plus d'exemplaires disponibles pour ce media")
				end -- if
			else
				io.put_string("Erreur, vous avez rentrer un mauvais numéro%N")
			end -- if
		-- si la recherche ne retourne aucun résultat
		else
			io.put_string("Aucun résultat%N")
		end -- if
	-- si le quota est atteint
	else
		io.put_string("Vous ne pouvez plus emprunter, vous avez atteint votre quota%N")
	end
end

consulter_ses_emprunts is
local
	array_emprunt : ARRAY[EMPRUNT]
	i : INTEGER
	choix : CHARACTER
do
	create array_emprunt.make(1,1)
	
	io.put_string("%NN'afficher que les emprunts en retard [y/n]%N")
	from 
		choix := 'a'
	until 
		choix = 'y' or choix = 'n'
	loop
		io.read_character
--		io.read_line -- FIX read_character saute le prochain read_line
		choix := io.last_character
		if not (choix = 'y' or choix = 'n') then
			io.put_string("Entrez 'y' pour oui, ou bien 'n' pour non%N")
		end -- if
	end -- loop

	if choix = 'y' then
		array_emprunt := user.get_emprunts(True)
	else -- choix = 'n'
		array_emprunt := user.get_emprunts(False)
	end -- if
	
	from
		i := 1
	until
		i = array_emprunt.upper
	loop
		if array_emprunt.item(i) /=Void then
			io.put_string(array_emprunt.item(i).to_string)
			io.put_new_line
			io.put_new_line
			i := i + 1
		end
	end -- loop	
	io.put_string("%NAppuyez sur ENTREE pour revenir au menu principal%N")
	io.read_line
end -- consulter_ses_emprunts













--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
-----------------------------------  GERER LES UTILISATEURS  -------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

gerer_les_utilisateurs is
local 
	choix : INTEGER
do
	from 
		choix := -1
	until 
		choix = 0
	loop
		io.put_string("%N______________________________________________________%N%N")
		io.put_string("%NQuelle action voulez-vous effectuer:%N%N")
		io.put_string("%N 1 - Ajouter un utilisateur")
		io.put_string("%N 2 - Modifier un utilisateur")
		io.put_string("%N 3 - Supprimer un utilisateur")
		io.put_string("%N 4 - Afficher tous les utilisateurs")
		if {SUPERADMIN} ?:= user then
		io.put_string("%N 5 - Promouvoir un utilisateur %N")
		end -- if
		io.put_string("%N 0 - Quitter %N")

		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer

		inspect choix
		when 1 then
			ajouter_utilisateur
		when 2 then
			modifier_utilisateur
		when 3 then
			supprimer_utilisateur
		when 4 then
			afficher_utilisateurs
		when 5 then
			if {SUPERADMIN} ?:= user then
				promouvoir_utilisateur
			else
				io.put_string("%NChoix incorrect%N")	
			end
		when 0 then
			-- ne rien faire
		else
			io.put_string("%NChoix incorrect%N")		
		end -- inspect		
	end -- loop
	--retour au menu principal
end -- gerer_les_utilisateurs


ajouter_utilisateur is
local
	is_unique : BOOLEAN -- l'identifiant de l'utilisateur est-il unique
	id, n, p : STRING
	u, tmp_u : USER
do
	io.put_string("%NAjouter un utilisateur %N")
	-- On entre l'identifiant du nouvel utilisateur
	-- On vérifie que cet identifiant est unique
	
	from 
		is_unique := False
	until
		is_unique = True
	loop
		io.put_string("Identifiant: ")
		io.read_line
		id := ""
		id.copy(io.last_string) -- FIX: les variables id, n, p pointaient vers la même
		create tmp_u.make(id, "", "", mt)
		is_unique := not (mt.getusers.has(tmp_u))
		if is_unique = False then 
			io.put_string("%NCet identifiant existe déjà, veuillez en choisir un autre%N")
		end -- if
	end -- loop
	-- On entre le nom du nouvel utilisateur
	io.put_string("Nom: ")
	io.read_line
	n := ""
	n.copy(io.last_string)
	-- On entre le prenom du nouvel utilisateur
	io.put_string("Prenom: ")
	io.read_line
	p := ""
	p.copy(io.last_string)
	
	-- On ajoute le nouvel utilisateur dans la médiathèque
	create u.make(id, p, n, mt)
	admin.ajouteruser(u)
	io.put_string("%NUtilisateur ajouté%N")
end -- ajouter_utilisateur


modifier_utilisateur is
local
	id, n, p : STRING
	continue : CHARACTER
	is_unique : BOOLEAN
	choix, i, q : INTEGER
	u, tmp_u : USER
do
	io.put_string("%NModifier un utilisateur %N")
	io.put_string("%NEntrez l'identifiant de l'utilisateur que vous voulez modifier:")
	-- on récupère l'utilisateur à modifier
	from 	
		is_unique := False
		continue := 'y' 
	until 	
		is_unique = True or continue = 'n'
	loop
		io.put_string("%NIdentifiant: ")
		io.read_line
		id := ""
		id.copy(io.last_string)
		create tmp_u.make(id, "", "", mt)
		is_unique := mt.has_user(tmp_u)
		if is_unique = False then 
			io.put_string("%NCet utilisateur n'existe pas")
			io.put_string("%NVoulez-vous continuer?[y/n]")
			from continue := 'a'
			until continue = 'y' or continue = 'n'
			loop
				io.read_character
				continue := io.last_character
				if not ( continue = 'y' or continue = 'n' ) then
					io.put_string("%NChoix incorrect")
				end -- if
			end -- loop
		else -- is_unique = True
			continue := 'n'
		end -- if
	end -- loop

	-- si l'utilisateur n'existe pas, et l'utilisateur ne souhaite pas continuer
	-- si l'utilisateur existe
	if continue = 'n' then
		-- On récupère l'utilisateur correspondant à l'identifiant
		i := mt.indexof_user(tmp_u)
		u := mt.getusers.item(i)
		io.put_string("Utilisateur trouvé%N")
	
		-- On modifie l'utilisateur récupéré précédemment
		from 	
			choix := -1
			continue := 'y'
		until 	
			(choix >= 0 and choix <= 4) and ( continue = 'n' )
		loop
			io.put_string("%NQue voulez-vous modifier")
			io.put_string("%N 1 - Identifiant")
			io.put_string("%N 2 - Nom")
			io.put_string("%N 3 - Prenom")
			io.put_string("%N 4 - Quota d'emprunts")
			io.put_string("%N 0 - Quitter")
			io.put_string("%N%NEntrez votre choix %N")
			io.read_integer
			io.read_line -- FIX read_integer saute le prochain read_line
			choix := io.last_integer
			inspect choix
			when 1 then 
				from 	is_unique := False
				until	is_unique = True
				loop
					io.put_string("%NIdentifiant: ")
					io.read_line
					id := ""
					id.copy(io.last_string)
					create tmp_u.make(id, "", "", mt)
					is_unique :=  not mt.has_user(tmp_u)
					if is_unique = False then 
						io.put_string("%NCet identifiant existe déjà")
					end -- if
				end -- loop 
				u.setid(id)
			when 2 then
				io.put_string("Nom: ")
				io.read_line
				n := ""
				n.copy(io.last_string)
				u.setnom(n)
			when 3 then
				io.put_string("Prenom: ")
				io.read_line
				p := ""
				p.copy(io.last_string)
				u.setprenom(p)	
			when 4 then
				from q := -1
				until q >= 0
				loop
					io.put_string("Quota: ")
					io.read_integer
					io.read_line -- FIX read_integer saute le prochain read_line
					q := io.last_integer
					if q < 0 then
						io.put_string("%NLe quota doit être positif")
					else
						u.setquota(q)
					end -- if 
				end -- loop
			when 0 then
				continue := 'n'
			end -- inspect
		end -- loop

		-- on modifie l'utilisateur
		admin.modifieruser(mt.getusers.item(i), u)
		io.put_string("%NUtilisateur modifié%N")
	end -- if
end -- modifier_utilisateur



supprimer_utilisateur is
local
	tmp_u : USER
	user_exists : BOOLEAN
	continue : CHARACTER
	id : STRING
do
	io.put_string("%NSupprimer un utilisateur %N")
	io.put_string("%NEntrez l'identifiant de l'utilisateur que vous voulez supprimer:")
	from 	continue := 'y' 
	until 	continue = 'n'
	loop
		user_exists := False
		io.put_string("%NIdentifiant: ")
		io.read_line
		id := ""
		id.copy(io.last_string)
		create tmp_u.make(id, "", "", mt)
		user_exists := mt.has_user(tmp_u)
		if user_exists = False then 
			io.put_string("%NCet utilisateur n'existe pas")
			io.put_string("%NVoulez-vous continuer?[y/n]%N")
			from continue := 'a'
			until continue = 'y' or continue = 'n'
			loop
				io.read_character
				continue := io.last_character
				if not ( continue = 'y' or continue = 'n' ) then
					io.put_string("%NChoix incorrect")
				end -- if
			end -- loop
		else -- is_unique = True
			admin.supprimeruser(tmp_u)
			continue := 'n'
			io.put_string("%NUtilisateur supprimé")
		end -- if
	end -- loop
end

afficher_utilisateurs is
do
	io.put_string("%N%N%NListe des utilisateurs de la médiathèque:%N")
	io.flush
	io.put_string(mt.to_string_all_user)
	io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
	io.read_line
end


promouvoir_utilisateur is
local
	tmp_u : USER
	is_unique : BOOLEAN
	continue : CHARACTER
	id : STRING
do
	io.put_string("%NPromouvoir un utilisateur %N")
	io.put_string("%NEntrez l'identifiant de l'utilisateur que vous voulez promouvoir:")
	from 	
		is_unique := False
		continue := 'y' 
	until 	is_unique = True and continue = 'n'
	loop
		io.put_string("%NIdentifiant: ")
		io.read_line
		id := ""
		id.copy(io.last_string)
		create tmp_u.make(id, "", "", mt)
		is_unique := mt.has_user(tmp_u)
		if is_unique = False then 
			io.put_string("%NCet utilisateur n'existe pas")
			io.put_string("%NVoulez-vous continuer?[y/n]")
			from continue := 'a'
			until continue = 'y' or continue = 'n'
			loop
				io.read_character
				continue := io.last_character
				if not ( continue = 'y' or continue = 'n' ) then
					io.put_string("%NChoix incorrect")
				end -- if
			end -- loop
		else -- is_unique = True
			su.upgradeuser(tmp_u)
			continue := 'n'
			io.put_string("%NUtilisateur promu en administrateur")
		end -- if
	end -- loop
end


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
------------------------------  FIN DE GERER LES UTILISATEURS  -----------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------  GERER LES MEDIAS  ----------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

gerer_les_medias is
local 
	choix : INTEGER
do
	from 
		choix := -1
	until 
		choix = 0
	loop
		io.put_string("%N______________________________________________________%N%N")
		io.put_string("%NQuelle action voulez-vous effectuer:%N%N")
		io.put_string("%N 1 - Gérer les livres")
		io.put_string("%N 2 - Gérer les DVD")
		io.put_string("%N 3 - Afficher tous les médias")
		io.put_string("%N 0 - Quitter %N")

		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer

		inspect choix
		when 1 then
			gerer_livre
		when 2 then
			gerer_dvd
		when 3 then
			afficher_medias
		when 0 then
			-- ne rien faire
		else
			io.put_string("%NChoix incorrect%N")		
		end -- inspect		
	end -- loop
	--retour au menu principal
end -- gerer_les_utilisateurs

afficher_medias is
do
	io.put_string("%N%N%NListe des médias de la médiathèque:%N")
	io.flush
	io.put_string(mt.to_string_all_media('m'))
	io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
	io.read_line
end

--------------------------------------------------------------------------------------------------------
--------------------------------------  GERER LES LIVRES  ----------------------------------------------
--------------------------------------------------------------------------------------------------------

gerer_livre is
local 
	choix : INTEGER
do
	from 
		choix := -1
	until 
		choix = 0
	loop
		io.put_string("%N______________________________________________________%N%N")
		io.put_string("%NQuelle action voulez-vous effectuer:%N%N")
		io.put_string("%N 1 - Ajouter un livre")
		io.put_string("%N 2 - Modifier un livre")
		io.put_string("%N 3 - Supprimer un livre")
		io.put_string("%N 4 - Afficher tous les médias")
		io.put_string("%N 0 - Quitter %N")

		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer

		inspect choix
		when 1 then
			ajouter_livre
		when 2 then
			modifier_livre
		when 3 then
			supprimer_livre
		when 4 then
			afficher_livres
		when 0 then
			-- ne rien faire
		else
			io.put_string("%NChoix incorrect%N")		
		end -- inspect		
	end -- loop
	--retour au menu principal
end -- gerer_les_utilisateurs


ajouter_livre is
local
	t, a : STRING
	l : LIVRE
do
	io.put_string("%NAjouter un livre %N")

	-- On entre le titre du livre
	io.put_string("Titre: ")
	io.read_line
	t := ""
	t.copy(io.last_string)

	-- On entre le nom de l'auteur du livre
	io.put_string("Auteur: ")
	io.read_line
	a := ""
	a.copy(io.last_string)

	create l.make_livre(t, a, 1, mt)
	-- si le livre n'existe pas, on l'ajoute à la médiathèque
	if mt.has_media(l) = False then
		admin.ajoutermedia(l)
		io.put_string("%NLivre ajouté%N")
	else
		io.put_string("Le livre existe déjà%N")
		io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
		io.read_line
	end	
end


modifier_livre is
local
	t, a : STRING
	n : INTEGER
	old_l, new_l : LIVRE	
do
	io.put_string("%NModifier un livre %N")
	io.put_string("%NEntrer le titre et l'auteur du livre que vous voulez modifier %N")

	-- On entre le titre du livre
	io.put_string("Titre: ")
	io.read_line
	t := ""
	t.copy(io.last_string)

	-- On entre le nom de l'auteur du livre
	io.put_string("Auteur: ")
	io.read_line
	a := ""
	a.copy(io.last_string)

	create old_l.make_livre(t, a, 1, mt)
	-- si le livre acutel existe, on peux le modifier
	if mt.has_media(old_l) = True then
		io.put_string("%NLivre trouvé%N%NVeuillez entrer les nouvelles informations du livre%N")
		-- On entre le titre du livre
		io.put_string("Titre: ")
		io.read_line
		t := ""
		t.copy(io.last_string)

		-- On entre le nom de l'auteur du livre
		io.put_string("Auteur: ")
		io.read_line
		a := ""
		a.copy(io.last_string)

		-- On entre le nom de l'auteur du livre
		io.put_string("Nombre d'exemplaires: ")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		n := io.last_integer


		create new_l.make_livre(t, a, n, mt)
		-- si le nouveau livre n'existe pas, on remplace le livre actuel par le nouveau livre
		if mt.has_media(new_l) = False then
			admin.modifiermedia(old_l, new_l)
		else
			io.put_string("Le livre existe déjà%N")
			io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
			io.read_line
		end
	else
		io.put_string("Ce livre n'existe pas%N")
		io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
		io.read_line
	end
end

supprimer_livre is
local
	t, a : STRING
	l : LIVRE
do
	io.put_string("%NSupprimer un livre %N")
	io.put_string("%NEntrer le titre et l'auteur du livre que vous voulez supprimer %N")

	-- On entre le titre du livre
	io.put_string("Titre: ")
	io.read_line
	t := ""
	t.copy(io.last_string)

	-- On entre le nom de l'auteur du livre
	io.put_string("Auteur: ")
	io.read_line
	a := ""
	a.copy(io.last_string)

	create l.make_livre(t, a, 1, mt)
	-- si le livre existe, on le supprime de la médiathèque
	if mt.has_media(l) = True then
		admin.supprimermedia(l)
		io.put_string("%NLivre supprimé%N")
	else
		io.put_string("Ce livre n'existe pas%N")
		io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
		io.read_line
	end
end

actualiser_nombre_exemplaire is
do

end

afficher_livres is
do
	io.put_string("%N%N%NListe des médias de la médiathèque:%N")
	io.flush
	io.put_string(mt.to_string_all_media('l'))
	io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
	io.read_line
end


--------------------------------------------------------------------------------------------------------
-----------------------------------  FIN DE GERER LES LIVRES  ------------------------------------------
--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------
----------------------------------------  GERER LES DVD  -----------------------------------------------
--------------------------------------------------------------------------------------------------------

gerer_dvd is
local 
	choix : INTEGER
do
	from 
		choix := -1
	until 
		choix = 0
	loop
		io.put_string("%N______________________________________________________%N%N")
		io.put_string("%NQuelle action voulez-vous effectuer:%N%N")
		io.put_string("%N 1 - Ajouter un DVD")
		io.put_string("%N 2 - Modifier un DVD - PAS IMPLEMENTE")
		io.put_string("%N 3 - Supprimer un DVD")
		io.put_string("%N 4 - Afficher tous les DVD")
		io.put_string("%N 0 - Quitter %N")

		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer

		inspect choix
		when 1 then
			ajouter_dvd
		when 2 then
			modifier_dvd
		when 3 then
			supprimer_dvd
		when 4 then
			afficher_dvds
		when 0 then
			-- ne rien faire
		else
			io.put_string("%NChoix incorrect%N")		
		end -- inspect		
	end -- loop
	--retour au menu principal
end -- gerer_les_utilisateurs



ajouter_dvd is
local
	realisateurs, acteurs : ARRAY[STRING]
	titre, type, acteur, realisateur : STRING
	annee : INTEGER
	continue : CHARACTER
	new_d : DVD
do
	
	
	-- On entre le prenom du nouvel utilisateur
	io.put_string("Titre: ")
	io.read_line
	titre := ""
	titre.copy(io.last_string)

	-- On entre le prenom du nouvel utilisateur
	io.put_string("Annee: ")
	io.read_integer
	io.read_line -- FIX read_integer saute le prochain read_line
	annee := io.last_integer
	
	create realisateurs.make(1,1)
	create acteurs.make(1,1)
	create new_d.make_dvd(titre, annee, realisateurs, acteurs, "", 1, mt)
	if mt.has_media(new_d) = True then
		io.put_string("Ce DVD existe déjà%N")
	else
		
		from continue := 'y'
		until continue = 'n'
		loop
			io.put_string("Realisateur: ")
			io.read_line
			realisateur := ""
			realisateur.copy(io.last_string)
			io.put_string(realisateur+"%N")
			realisateurs.add_first(realisateur)
			from continue := 'a'
			until continue = 'y' or continue = 'n'
			loop
				io.put_string("Y a-t-il un autre réalisateur?[y/n]%N")
				io.read_character
				continue := io.last_character
				io.read_line -- FIX read_character saute le prochain read_line
				if not ( continue = 'y' or continue = 'n' ) then
					io.put_string("Choix incorrect%N")
				end -- if
			end -- loop
		end

	
		
		from continue := 'y'
		until continue = 'n'
		loop
			io.put_string("Acteur: ")
			io.read_line
			acteur := ""
			acteur.copy(io.last_string)
			acteurs.add_first(acteur)
			from continue := 'a'
			until continue = 'y' or continue = 'n'
			loop
				io.put_string("Y a-t-il un autre acteur?[y/n]%N")
				io.read_character
				continue := io.last_character
				io.read_line -- FIX read_character saute le prochain read_line
				if not ( continue = 'y' or continue = 'n' ) then
					io.put_string("Choix incorrect%N")
				end -- if
			end -- loop
		end

		-- On entre le prenom du nouvel utilisateur
		io.put_string("Type: ")
		io.read_line
		type := ""
		type.copy(io.last_string)

		-- une fois tous les champs remplis on ajoute le dvd dans la médiathèque
		new_d.setrealisateur(realisateurs)
		new_d.setacteur(acteurs)
		new_d.settype(type)
		admin.ajoutermedia(new_d)
		io.put_string("DVD ajouté%N")
	end -- if
end


-- ISSUE : on ne peut pas récupérer les attributs DVD car la variable qui le contient est de type MEDIA, on ne peut pas parser MEDIA en DVD
modifier_dvd is
--local
--	titre, type : STRING
--	i, annee : INTEGER
--	old_d, new_d : DVD
--	is_unique : BOOLEAN
--	array : ARRAY[STRING]	
do
--	io.put_string("%NModifier un DVD %N")
--	io.put_string("%NEntrer le titre et l'année de sortie du DVD que vous voulez modifier %N")

--	-- On entre le titre du DVD
--	io.put_string("Titre: ")
--	io.read_line
--	titre := ""
--	titre.copy(io.last_string)

--	-- On entre l'année de sortie du DVD
--	io.put_string("Année: ")
--	io.read_line
--	annee := ""
--	annee.copy(io.last_string)

--	create array.make(1,1)
--	create old_d.make_dvd(titre, annee, array, array, "", 1, mt)
--	-- si le livre actuel existe, on peut le modifier
--	if mt.has_media(old_d) = True then
--		io.put_string("%NDVD trouvé, entrez désormais les nouvelles informations du DVD%N")
--		i := mt.indexof_media(old_d)
--		new_d :=  mt.getmedias.item(i) 
--		
--		-- On entre le prenom du nouvel utilisateur
--		io.put_string("Titre: ")
--		io.read_line
--		titre := ""
--		titre.copy(io.last_string)
--		new_d.settitre(titre)

--		-- On entre le prenom du nouvel utilisateur
--		io.put_string("Annee: ")
--		io.read_integer
--		io.read_line -- FIX read_integer saute le prochain read_line
--		annee := io.last_integer
--		new_d.setannee(annee)

--		-- On entre le prenom du nouvel utilisateur
--		io.put_string("Type: ")
--		io.read_line
--		type := ""
--		type.copy(io.last_string)
--		new_d.settype(type)

--		-- si le nouveau DVD n'existe pas, on remplace le DVD actuel par le nouveau DVD
--		if mt.has_media(new_d) = False then
--			admin.modifiermedia(old_d, new_d)
--		else
--			io.put_string("Le DVD existe déjà")
--		end
--	else
--		io.put_string("Ce DVD n'existe pas")
--	end
end

supprimer_dvd is
local
	t : STRING
	a : INTEGER
	array : ARRAY[STRING]
	d : DVD
do
	io.put_string("%NSupprimer un DVD %N")
	io.put_string("%NEntrer le titre et l'année de sortie du DVD que vous voulez supprimer %N")

	-- On entre le prenom du nouvel utilisateur
	io.put_string("Titre: ")
	io.read_line
	t := ""
	t.copy(io.last_string)

	-- On entre le prenom du nouvel utilisateur
	io.put_string("Année: ")
	io.read_integer
	io.read_line -- FIX read_integer saute le prochain read_line
	a := io.last_integer

	create array.make(1,1)
	create d.make_dvd(t, a, array, array, "", 1, mt)
	-- si le livre existe, on le supprime de la médiathèque
	if mt.has_media(d) = True then
		admin.supprimermedia(d)
		io.put_string("%NDVD supprimé%N")
	else
		io.put_string("Ce DVD n'existe pas")
	end
end

ajouter_acteur is
do

end

modifier_acteur is
do

end

supprimer_acteur is
do

end

ajouter_realisateur is
do

end

modifier_realisateur is
do

end

supprimer_realisateur is
do

end

afficher_dvds is
do
	io.put_string("%N%N%NListe des médias de la médiathèque:%N")
	io.flush
	io.put_string(mt.to_string_all_media('d'))
	io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
	io.read_line
end

--------------------------------------------------------------------------------------------------------
--------------------------------------  FIN DE GERER LES DVD  ------------------------------------------
--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
------------------------------------  FIN DE GERER LES MEDIAS  -----------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------  GERER LES EMPRUNTS  --------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

gerer_les_emprunts is
local 
	choix : INTEGER
do
	from 
		choix := -1
	until 
		choix = 0
	loop
		io.put_string("%N______________________________________________________%N%N")
		io.put_string("%NQuelle action voulez-vous effectuer:%N%N")
		io.put_string("%N 1 - Consulter les emprunts en cours d'un utilisateur")
		io.put_string("%N 2 - Consulter les emprunts en retard")
		io.put_string("%N 0 - Quitter %N")

		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer

		inspect choix
		when 1 then
			consulter_emprunts_en_cours_utilisateur
		when 2 then
			consulter_emprunts_en_retards
		when 0 then
			-- rien faire
		else
			io.put_string("%NChoix incorrect%N")		
		end -- inspect		
	end -- loop
	--retour au menu principal
end -- gerer_les_emprunts


consulter_emprunts_en_cours_utilisateur is
local
	continue : CHARACTER
	is_unique : BOOLEAN
	tmp_u : USER
	id : STRING
do
	io.put_string("%NConsulter les emprunts en cours d'un utilisateur %N")
	io.put_string("%NEntrez l'identifiant de l'utilisateur:")
	-- on récupère l'utilisateur à modifier
	from 	
		is_unique := False
		continue := 'y' 
	until 	
		is_unique = True or continue = 'n'
	loop
		io.put_string("%NIdentifiant: ")
		io.read_line
		id := ""
		id.copy(io.last_string)
		create tmp_u.make(id, "", "", mt)
		is_unique := mt.has_user(tmp_u)
		if is_unique = False then 
			io.put_string("%NCet utilisateur n'existe pas")
			io.put_string("%NVoulez-vous continuer?[y/n]")
			from continue := 'a'
			until continue = 'y' or continue = 'n'
			loop
				io.read_character
				continue := io.last_character
				if not ( continue = 'y' or continue = 'n' ) then
					io.put_string("%NChoix incorrect")
				end -- if
			end -- loop
		else -- is_unique = True
			continue := 'n'
		end -- if
	end -- loop

	if continue = 'n' then
		io.put_string(mt.to_string_array_emprunt(mt.get_emprunts_non_rendus(tmp_u, Void)))
	end -- if
	io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
	io.read_line
end -- consulter_emprunts_en_cours_utilisateur

consulter_emprunts_en_cours_media is
local
	continue : CHARACTER
	is_unique : BOOLEAN
	tmp_m : MEDIA
	id : STRING
do
--	io.put_string("%NConsulter les emprunts en cours d'un média %N")
--	io.put_string("%NEntrez l'identifiant de l'utilisateur:")
--	-- on récupère l'utilisateur à modifier
--	from 	
--		is_unique := False
--		continue := 'y' 
--	until 	
--		is_unique = True or continue = 'n'
--	loop
--		io.put_string("%NIdentifiant: ")
--		io.read_line
--		id := ""
--		id.copy(io.last_string)
--		create tmp_m.make(id, "", "", mt)
--		is_unique := mt.has_media(tmp_m)
--		if is_unique = False then 
--			io.put_string("%NCet utilisateur n'existe pas")
--			io.put_string("%NVoulez-vous continuer?[y/n]")
--			from continue := 'a'
--			until continue = 'y' or continue = 'n'
--			loop
--				io.read_character
--				continue := io.last_character
--				if not ( continue = 'y' or continue = 'n' ) then
--					io.put_string("%NChoix incorrect")
--				end -- if
--			end -- loop
--		else -- is_unique = True
--			continue := 'n'
--		end -- if
--	end -- loop

--	if continue = 'n' then
--		io.put_string(mt.to_string_array_emprunt(mt.get_emprunts_non_rendus(Void, tmp_m)))
--	end -- if
--	io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
--	io.read_line
end


consulter_emprunts_en_retards is
do
	io.put_string(mt.to_string_array_emprunt(mt.get_emprunts_en_retards(mt.getemprunts)))
	io.put_string("%NAppuyez sur ENTREE pour revenir au menu précédent%N")
	io.read_line
end


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
------------------------------------  FIN DE GERER LES EMPRUNTS  ---------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
---------------------------------------  IMPORTER EXPORTER  ---------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

importer_fichier is
local
	choix : INTEGER
do
	from 
		choix := -1
	until 
		choix = 0 
	loop
		io.put_string("1 - Importer un fichier de medias%N")
		if {SUPERADMIN} ?:= user then
			io.put_string("2 - Importer un fichier d'utilisateurs%N")
		end
		io.put_string("0 - Quitter %N")
		
		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer
		inspect choix
		when 1 then
			importer_medias
		when 2 then
			if {SUPERADMIN} ?:= user then
				importer_utilisateurs
			else
				io.put_string("Choix incorrect %N")
			end
		when 0 then
			--ne rien faire
		else
			io.put_string("Choix incorrect %N")
		end -- inspect
	end -- loop
end

importer_medias is
local
	chemin : STRING
do
	io.put_string("Entrez le chemin du fichier de medias à importer%N")
	io.read_line
	chemin := io.last_string
	mt.import_media(chemin)
	io.put_string("%NFichier importé%N%N")
end

importer_utilisateurs is
local
	chemin : STRING
do
	io.put_string("Entrez le chemin du fichier d'utilisateurs à importer%N")
	io.read_line
	chemin := io.last_string
	mt.import_user(chemin)
	io.put_string("%NFichier importé%N%N")
end

exporter_fichier is
local
	choix : INTEGER
do
	from 
		choix := -1
	until 
		choix = 0 
	loop
		io.put_string("1 - Exporter un fichier de medias%N")
		io.put_string("2 - Exporter un fichier d'utilisateurs%N")
		io.put_string("0 - Quitter %N")
		
		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer
		inspect choix
		when 1 then
			exporter_medias
		when 2 then
			exporter_utilisateurs
		when 0 then
			--ne rien faire
		else
			io.put_string("Choix incorrect %N")
		end -- inspect
	end -- loop
end

exporter_medias is
local
	chemin : STRING
do
	io.put_string("Entrez le chemin du fichier de medias vers lequel vous voulez exporter%N")
	io.read_line
	chemin := io.last_string
	mt.export_media(chemin)
	io.put_string("%NFichier exporté dans "+chemin+"%N%N")
end

exporter_utilisateurs is
local
	chemin : STRING
do
	io.put_string("Entrez le chemin du fichier d'utilisateurs vers lequel vous voulez exporter%N")
	io.read_line
	chemin := io.last_string
	mt.export_user(chemin)
	io.put_string("%NFichier exporté dans "+chemin+"%N%N")
end

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
---------------------------------------  FIN IMPORTER EXPORTER  ----------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------  PARAMETRES  ----------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

parametres is
local
	choix : INTEGER
do
	from 
		choix := -1
	until 
		choix = 0 
	loop
		io.put_string("%N______________________________________________________%N%N")
		io.put_string("%NParamètres%N")
		io.put_string("1 - Modifier le quota maximum d'emprunts%N")
		io.put_string("2 - Modifier le délai maximum de rendu des médias%N")
		io.put_string("0 - Quitter %N")
		
		io.put_string("%NEntrez votre choix %N")
		io.read_integer
		io.read_line -- FIX read_integer saute le prochain read_line
		choix := io.last_integer
		inspect choix
		when 1 then
			changer_quota
		when 2 then
			changer_delai
		when 0 then
			--ne rien faire
		else
			io.put_string("Choix incorrect %N")
		end -- inspect
	end -- loop
end

changer_quota is
local
	quota : INTEGER
do
	io.put_string("Le quota est actuellement de "+mt.getquota.to_string+" médias maximum.%N")
	io.put_string("Entrez la nouvelle valeur: ")
	io.read_integer
	io.read_line -- FIX read_integer saute le prochain read_line
	quota := io.last_integer
	io.put_new_line
	if quota < 0 then
		io.put_string("Valeur entrée incorrecte")
	else
		mt.setquota(quota)
	end
end

changer_delai is
local
	delai : INTEGER
do
	io.put_string("Le délai d'un emprunt est actuellement de "+mt.getdelai.to_string+" jours.%N")
	io.put_string("Entrez la nouvelle valeur: ")
	io.read_integer
	io.read_line -- FIX read_integer saute le prochain read_line
	delai := io.last_integer
	io.put_new_line
	if delai < 0 then
		io.put_string("Valeur entrée incorrecte")
	else
		mt.setdelai(delai)
	end

end


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
------------------------------------------  FIN PARAMETRES  --------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------



end -- class TESTMEDIATHEQUE
