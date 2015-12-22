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
mt : MEDIATHEQUE

feature{ANY}

-- visiteur : utilisateur non authentifier
-- utilisateur : instance de la classe user
-- administrateur : instance de la classe admin 


demarrage is
local
	choix : INTEGER
	entree : STRING
do
	io.put_string("%N%N-------- LOGICIEL DE LA MEDIATHEQUE -------- %N%N")

	from 
		choix := -1
	until 
		choix >= 0 and choix <= 2
	loop
		io.put_string("1 - Se connecter à la médiathèque %N")
		io.put_string("0 - Quitter %N")

		io.read_integer
		choix := io.last_integer
		io.put_string(choix.to_string + "%N")

		inspect choix
		when 1 then
			authentification
		end
	end	
end

--L'utilisateur s'identifie
authentification : USER is
local
	i : INTEGER
do
	io.put_string("%NEntrez votre identifiant%N")
	io.read_line
	entree := io.last_string
	create user.make(entree, "", "", mt)
	-- on récupère l'utilisateur
	if mt.getusers.has(user) then
		i := mt.getusers.first_index_of(user)
		user := mt.getusers.item(i)
		-- user et admin contiendront la même personne
		if {ADMIN} ?:= user then
			-- admin permettra d'effectuer plus facilement les opérations d'administrateur
			create admin.make_from_user(user)
		end
		
	-- sinon on affiche un message d'erreur et on retourne à l'écran de démarrage
	else
		demarrage
	end
end


-- choix des fonctionnalité
menu is
local
	choix : INTEGER
do
	io.put_string("%NMENU%N")
	io.put_string("%N 1 - Emprunter un média %N")
	io.put_string("%N 2 - Rendre un média %N")
	if {ADMIN} ?:= user then
	io.put_string("%N 3 - Ajouter un utilisateur %N")
	io.put_string("%N 4 - Modifier un utilisateur %N")
	io.put_string("%N 5 - Supprimer un utilisateur %N")
	end
	if {SUPERADMIN} ?:= then
	io.put_string("%N 6 - Passer un utilisateur en administrateur %N")
	end
	io.put_string("%N 0 - Quitter %N")

	io.read_integer
	choix := io.last_integer

	inspect choix
	when 1 then
		authentification
	end	
end



-- le visiteur choisit
initialisation is
local
	path : STRING
do
	io.put_string("%NEntrez le chemin du fichier d'initialisation des utilisateurs de la médiathèque: %N")
	io.read.line
	path := io.last_string
		
end




end -- class TESTMEDIATHEQUE
