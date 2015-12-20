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
	--post: les users ont été ajouté au tableau							TODO
	fichier_user ( path : STRING ) is
		local
			fichier : TEXT_FILE_READ
			id, nom, prenom : STRING
			admin : BOOLEAN
			new_user : USER
			new_admin : ADMIN
			x, y : INTEGER
			arrstring : ARRAY[STRING]
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
				arrstring := (parse(fichier.last_string))
				
				-- boucle parcours de ligne
				from
					y:=1
				until
					y = arrstring.upper
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
					create new_admin.make(id, prenom, nom, Current)
					ajouteruser(new_admin)
				else
					create new_user.make(id, prenom, nom, Current)
					ajouteruser(new_user)
				end
				nom := ""
				prenom := ""
				id := ""
				admin := False

			end -- fin boucle parcours de fichier
			fichier.disconnect
		end -- fichier_user







	--Construit la base de données des médias de la mediatheque à partir d'un fichier
	--path : chemin du fichier texte décrivant les médias
	--post: les médias ont été ajouté au tableau							TODO
	fichier_media ( path : STRING ) is
		local
			fichier : TEXT_FILE_READ
			new_livre : LIVRE
			new_dvd : DVD
			is_livre, is_dvd : BOOLEAN
			titre, type, auteur : STRING
			realisateur, acteur : ARRAY[STRING]
			annee, nb_exemplaire : INTEGER
			x, y : INTEGER
			arrstring : ARRAY[STRING]
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
				arrstring := parse(fichier.last_string)
				if arrstring.upper > 1 then -- s'il y a une dernière ligne du fichier de taille 1 (FIX)
				create realisateur.make(1,1)
				create acteur.make(1,1)

					-- on regarde quelle type de média on traite
					if arrstring.item(1).is_equal("Livre") then
						is_livre := True
					elseif arrstring.item(1).is_equal("DVD") then
						is_dvd := True
					end
					-- boucle parcours de ligne
					from
						y:=2
					until
						y >= arrstring.upper
					loop
						-- on évalue la nature du champs, puis on stock la valeur associée
						if is_livre = True then
							inspect arrstring.item(y)
							when "Titre" then
								titre := arrstring.item(y+1)
							when "Auteur" then
								auteur := arrstring.item(y+1)
							when "Nombre" then
								nb_exemplaire := arrstring.item(y+1).to_integer  --- MODIF
							end
						elseif is_dvd = True then
							inspect arrstring.item(y)
							when "Titre" then
								titre := arrstring.item(y+1)
							when "Realisateur" then
								realisateur.add_first(arrstring.item(y+1))
							when "Acteur" then
								acteur.add_first(arrstring.item(y+1))
							when "Annee" then
								annee := arrstring.item(y+1).to_integer
							when "Type" then
								type := arrstring.item(y+1)
							when "Nombre" then
								nb_exemplaire := arrstring.item(y+1).to_integer
							end
						end					

						--on passe au prochain champ
						y := y + 2		
					end -- fin boucle parcours de ligne

					-- ajout de l'utilisateur ou de l'admin
					if is_livre = True then
						create new_livre.make_livre(titre, auteur, nb_exemplaire, Current)
						ajoutermedia(new_livre)

						-- on réinitilise les variables
						auteur := ""
						is_livre := False
					elseif is_dvd = True then
						create new_dvd.make_dvd(titre, annee, realisateur, acteur, type, nb_exemplaire, Current)
						ajoutermedia(new_dvd)
			
						-- on réinitilise les variables
						type := ""
						annee :=0
						is_dvd := False
					end
					-- on réinitilise les variables
					titre := ""
					nb_exemplaire := 1

				end -- s'il y a une dernière ligne du fichier de taille 1 (FIX)
			end -- fin boucle parcours de fichier
			fichier.disconnect
		end -- fichier_user









	parse (in : STRING) : ARRAY[STRING] is
		local
			arraystr, out_arraystr  : ARRAY[STRING]
			i: INTEGER
		do
			create arraystr.make(1,1)
			create out_arraystr.make(1,1)
			in.append(" ") -- éviter les bugs avec split, omission du dernier fragment
		
			--façon détournée de splitter au niveau des ';'
			in.replace_all(' ','|')
			in.replace_all('<',' ')
			in.replace_all('>',' ')
			in.replace_all(';',' ')
			arraystr.copy(in.split)

			from 
				i := 1
			until
				i > arraystr.upper
			loop
				-- on retransforme les '|' en espaces
				arraystr.item(i).replace_all('|',' ')
				arraystr.item(i).left_adjust
				arraystr.item(i).right_adjust
				--on ajoute la valeur du champ
				if arraystr.item(i).count > 0 then
					out_arraystr.add(arraystr.item(i), out_arraystr.upper) -- valeur du champ
				end
				i := i+1
			end

			Result := out_arraystr
		end





	to_string_all_user : STRING is
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

	to_string_all_media : STRING is
		local		
			i : INTEGER
			str : STRING
		do
			create str.make(1)
			from 
				i := 1
			until
				i = tmedia.upper
			loop
				str.append(tmedia.item(i).to_string)
				i := i+1
			end
			Result := str
		end



     
 	ajouteruser (new_user : USER) is
		do
			tuser.add_first(new_user)	
		end



 	ajoutermedia (new_media : MEDIA) is
		do
			tmedia.add_first(new_media)	
		end




	getusers : ARRAY[USER] is
		do
			Result := tuser
		end                          
	
end -- Classe Médiathèque

	
