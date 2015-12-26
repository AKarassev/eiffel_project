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
	mt.fichier_user("utilisateurs.txt")
	mt.fichier_media("medias.txt")
	ecran_titre
end -- demarrage

ecran_titre is
local
	choix : INTEGER
do
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
					
			when 2 then

			when 3 then
				consulter_ses_emprunts
			when 4 then
				gerer_les_utilisateurs
			when 5 then

			when 6 then

			when 7 then

			when 8 then

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
					
			when 2 then

			when 3 then
				consulter_ses_emprunts
			when 0 then
				
			else
				if choix >= 4 and choix <=8 then -- trop la flemme de faire une autre boucle pour les user
					choix := -1
				end
				io.put_string("%NChoix incorrect%N")
			end
		end --if
	end -- loop
end -- menu


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
		io.put_string(array_emprunt.item(1).to_string)
		
		i := i + 1
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
			menu
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









end -- class TESTMEDIATHEQUE
