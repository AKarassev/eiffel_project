class MEDIATHEQUE
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
-- Classe principale
--
creation{ANY}
	make

feature{}
       	dbuser : TEXT_FILE_READ 	-- la liste des utilisateurs
	dbmedia : TEXT_FILE_READ 	-- liste des medias
       	tuser: ARRAY[USER] 		-- la liste des utilisateurs
	tmedia: ARRAY[MEDIA] 		-- la liste des medias
	temprunt: ARRAY[EMPRUNT]	-- liste des emprunts



feature{ANY}

	make is
	do
		create tuser.make(1,1)
		create tmedia.make(1,1)
		create temprunt.make(1,1)
	end	

	
	--Construit la base de données des utilisateurs de la mediatheque à partir d'un fichier
	--path : chemin du fichier texte décrivant les utilisateurs
	--pre: le fichier existe									TODO
	--post: les users ont été ajouté au tableau							TODO
	fichier_user ( path : STRING ) is
		local
			fichier : TEXT_FILE_READ
			id, nom, prenom : STRING
			admin : BOOLEAN
			x, y : INTEGER
			arrstring : ARRAY[STRING]
			str : STRING 
		do
			create fichier.make
			fichier.connect_to(path)
			 create arrstring.make(1,1)

			-- boucle parcours de fichier
			from
			    x := 0
			until
			    fichier.end_of_input
			loop
				fichier.read_line

				--On parse la ligne
				str := fichier.last_string
				str.remove_all_occurrences(';')
				str.replace_all('<',' ')
				str.replace_all('>',' ')
				arrstring.copy(str.split)
				
				-- boucle parcours de ligne
				from
					y:=1
				until
					y > arrstring.upper
				loop
					-- on évalue la nature du champs, puis on stock la valeur associée
					inspect arrstring.item(y)
					when "Nom" then
						nom := arrstring.item(y+1)
					when "Prenom" then
						prenom := arrstring.item(y+1)
					when "Identifiant" then
						id := arrstring.item(y+1)
					when "Admin" then
						if arrstring.item(y+1).is_equal("OUI") then
							admin := True
						end
					end
					--on passe au prochain champ
					y := y + 2		
				end -- fin boucle parcours de ligne

				-- ajout de l'utilisateur ou de l'admin
				if admin = True then
					ajouteradmin(id, prenom, nom)
				else
					ajouteruser(id, prenom, nom)
				end
				nom := ""
				prenom := ""
				id := ""
				admin := False

			end -- fin boucle parcours de fichier
			fichier.disconnect
		end 

	affichertoususer : STRING is
		local		
			i : INTEGER
			str : STRING
		do
			create str.make(1)
			from 
				i := 1
			until
				i = tuser.upper
			loop
				str.append(tuser.item(i).to_string)
				i := i+1
			end
			Result := str
		end
     
 	ajouteruser (id, p, n : STRING) is
		local
 			new_user : USER
		do
			create new_user.make(id, p, n)
			tuser.add_first(new_user)	
		end

	ajouteradmin (id, p, n : STRING) is
		local
 			new_admin : ADMIN
		do
			create new_admin.make(id, p, n)
			tuser.add_first(new_admin)	
		end                          
	
end -- Classe Médiathèque

	
