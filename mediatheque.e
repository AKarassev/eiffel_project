class MEDIATHEQUE
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
-- Classe principale
--
creation{ANY}
	make

feature{}
	su : SUPERADMIN			-- superutilisateur e la mediatheque, il a tous les droits sur cette médiathèque
       	tuser: ARRAY[USER] 		-- la liste des utilisateurs
	tmedia: ARRAY[MEDIA] 		-- la liste des medias
	temprunt: ARRAY[EMPRUNT]	-- liste des emprunts
	quota_defaut : INTEGER		-- le quota par défaut de la médiathèque
	delai_defaut : INTEGER		-- le délai par défaut pour rendre un média, en nombre de jours



feature{ANY}

	-- pre: les quotas et les délais doivent être positifs
	make(qd, dd : INTEGER) is
	require 
		positif : qd>0 and dd>0
	do
		create tuser.make(1,1)
		create tmedia.make(1,1)
		create temprunt.make(1,1)
		quota_defaut := qd
		delai_defaut := dd
		create su.make("su", "", "", Current)
	end	

	
	--Construit la base de données des utilisateurs de la mediatheque à partir d'un fichier
	--path : chemin du fichier texte décrivant les utilisateurs
	-- pre : le fichier en entrée doit être bien construit
	-- post: les users ont été ajouté au tableau							TODO
	import_user ( path : STRING ) is
		local
			fichier : TEXT_FILE_READ
			id, nom, prenom : STRING
			admin : BOOLEAN
			new_user : USER
			new_admin : ADMIN
			x, y : INTEGER
			arrstring : ARRAY[STRING]
		do

			-- on vide le tableau d'utilisateurs de la mediatheque
			tuser.make(1,1)

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
	-- pre : le fichier en entrée doit être bien construit
	--post: les médias ont été ajouté au tableau							TODO
	import_media ( path : STRING ) is
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
			-- on vide le tableau des medias de la mediatheque
			tmedia.make(1,1)

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


	export_user ( path : STRING ) is
	local
		fichier : TEXT_FILE_WRITE
		i : INTEGER
		user : USER
		string_user : STRING
	do
		create fichier.make
		fichier.connect_to(path)
		from i := 1
		until i = tuser.upper
		loop
			user := tuser.item(i)
			string_user := "Nom<"+user.getnom+"> ; Prenom<"+user.getprenom+"> ; Identifiant<"+user.getid+">"
			if {ADMIN} ?:= user then
				string_user := string_user+" ; Admin<OUI>"
			end
			string_user := string_user+"%N"
			fichier.put_string(string_user)
			i := i + 1
		end -- loop
		fichier.disconnect
	end

	export_media ( path : STRING ) is
	local
		fichier : TEXT_FILE_WRITE
		i : INTEGER
		media : MEDIA
		string_media : STRING
	do
		create fichier.make
		fichier.connect_to(path)
		from i := 1
		until i = tmedia.upper
		loop
			media := tmedia.item(i)
			string_media := media.to_string_export+"%N"
			fichier.put_string(string_media)
			i := i + 1
		end -- loop
		fichier.disconnect
	end


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
				str.append(tuser.item(i).to_string+"%N")
				i := i+1
			end
			Result := str
		end


	-- Retourne une chaîne de caractère affichant tous les médias
	-- type = 'm', tous les médias
	-- type = 'l', tous les livres
	-- type = 'd', tous les dvds
	to_string_all_media ( type : CHARACTER ) : STRING is
		local		
			i : INTEGER
			found : BOOLEAN
			str : STRING
		do
			create str.make(1)
			from 
				i := 1
			until
				i = tmedia.upper
			loop
				from i := 1 found := False 
				until i = tmedia.upper or found = True
				loop
					inspect type
					when 'l' then
						if {LIVRE} ?:= tmedia.item(i)  then
							str.append("%N"+tmedia.item(i).to_string+"%N")
						end
					when 'd' then			
						if {DVD} ?:= tmedia.item(i) then
							str.append("%N"+tmedia.item(i).to_string+"%N")
						end
					when 'm' then
						str.append("%N"+tmedia.item(i).to_string+"%N")
					end -- inspect
					i := i + 1
				end
			end
			Result := str
		end

	to_string_array_media ( array_media : ARRAY[MEDIA]) : STRING is
		local
			i : INTEGER
			str : STRING
		do
			create str.make(1)
			from 
				i := 1
			until
				i = array_media.upper
			loop
				str.append("%N%NRésultat n°"+i.to_string+"%N"+array_media.item(i).to_string)
				i := i + 1 	
			end
			Result := str
		end

	to_string_all_emprunt : STRING is
		local		
			i : INTEGER
			str : STRING
		do
			create str.make(1)
			from 
				i := 1
			until
				i = temprunt.upper
			loop
				str.append(temprunt.item(i).to_string)
				i := i+1
			end
			Result := str
		end

	to_string_array_emprunt (array_emprunt : ARRAY[EMPRUNT] ) : STRING is
		local		
			i : INTEGER
			str : STRING
		do
			create str.make(1)
			from 
				i := 1
			until
				i = array_emprunt.upper
			loop
				str.append(array_emprunt.item(i).to_string)
				i := i+1
			end -- loop
			Result := str
		end



     	-- pre : le nouvel utilisateur n'existe pas DELETED
	-- post : le nouvel utilisateur existe
 	ajouteruser (new_user : USER) is
		require 
			--user_not_exists : has_user(new_user) = False
		do
			if has_user(new_user) = False then
				tuser.add_first(new_user)
			end
		ensure
			user_exists : has_user(new_user) = True	
		end

	-- pre: old_user existe
	modifieruser (old_user, new_user : USER) is
		require
			user_exists : has_user(old_user) = True
		local
			i : INTEGER
		do
			i := indexof_user(old_user)
			tuser.put(new_user, i)	
		end

	supprimeruser (rem_user : USER) is
		require
			user_exists : has_user(rem_user) = True
		local
			i : INTEGER
		do
			i := indexof_user(rem_user)
			tuser.remove(i)
		ensure
			user_not_exists : has_user(rem_user) = False
		end

	-- pre : l'utilisateur existe
	-- post : l'utilisateur est un administrateur TODO
	upgradeuser (up_user : USER) is
		require
			user_exists : has_user(up_user) = True
		local
			i : INTEGER
			new_admin : ADMIN
		do
			i := indexof_user(up_user)
			create new_admin.make_from_user(up_user)
			modifieruser(up_user, new_admin)
		end -- upgrade_user



	-- pre : le media n'existe pas DELETED
	-- post : le media existe
 	ajoutermedia (new_media : MEDIA) is
		require
			--media_not_exists : has_media(new_media) = False
		do
			if has_media(new_media) = False then
				tmedia.add_first(new_media)
			end
		ensure
			media_exists : has_media(new_media) = True	
		end

	-- pre : le media à modifier doit exister
	-- post : new_media est unique TODO
	modifiermedia ( old_media, new_media : MEDIA) is
		require
			media_exists : has_media(old_media) = True
		local
			i : INTEGER		
		do
			i := indexof_media(old_media)
			tmedia.put(new_media, i)			
		end
	
	-- pre : le media à supprimer doit exister
	-- post : le media n'existe plus
	supprimermedia ( rem_media : MEDIA ) is
		require
			media_exists : has_media(rem_media) = True
		local
			i : INTEGER
		do
			i := indexof_media(rem_media)
			tmedia.remove(i)
		ensure
			media_not_exists : has_media(rem_media) = False
		end
	

	ajouteremprunt (new_emprunt : EMPRUNT) is
		do
			temprunt.add_first(new_emprunt)
		end


	getusers : ARRAY[USER] is
		do
			Result := tuser
		end  

	getsu : SUPERADMIN is
		do
			Result := su
		end

	getmedias : ARRAY[MEDIA] is
		do
			Result := tmedia
		end  
	
	getemprunts : ARRAY[EMPRUNT] is
		do
			Result := temprunt
		end

	-- Renvoie l'indice de l'utilisateur, sinon upper du tableau
	indexof_user ( u : USER ) : INTEGER is
		local
			i : INTEGER
			found : BOOLEAN
		do
			Result := tuser.upper
			from i:= 1 found := False 
			until i = tuser.upper or found = True
			loop
				if u.is_equal(tuser@i) then
					Result := i
					found := True
				end
				i := i + 1
			end
		end

	-- Renvoie l'indice de l'utilisateur, sinon upper du tableau
	indexof_media ( m : MEDIA ) : INTEGER is
		local
			i : INTEGER
			found : BOOLEAN
			type : CHARACTER
		do

			-- On analyse le type du media passé en paramètre
			if {LIVRE} ?:= m then
				type := 'l'
			elseif {DVD} ?:= m then
				type := 'd'
			else
				type := 'm'
			end

			Result := tmedia.upper
			-- On fait la comparaison seulement si le type de l'élément à l'indice i est le même que celui média passé en paramètre
			from i:= 1 found := False 
			until i = tmedia.upper or found = True
			loop
				inspect type
				when 'l' then
					if {LIVRE} ?:= tmedia.item(i)  then
						Result := i
						found := tmedia.item(i).is_equal(m)
					end
				when 'd' then			
					if {DVD} ?:= tmedia.item(i) then
						Result := i
						found := tmedia.item(i).is_equal(m)
					end
				when 'm' then
					Result := i
					found := tmedia.item(i).is_equal(m)
				end -- inspect
				i := i + 1
			end

		end

	-- Renvoie l'indice de l'utilisateur, sinon upper du tableau
	has_user ( u : USER ) : BOOLEAN is
		local
			i : INTEGER
			found : BOOLEAN
		do
			Result := False
			if tuser.is_empty = False then
				from i:= 1 found := False 
				until i = tuser.upper or found = True
				loop
					if u.is_equal(tuser.item(i)) then
						found := True
					end
					i := i + 1
				end
				Result := found
			end
		end

	-- Renvoie l'indice de l'utilisateur, sinon upper du tableau
	has_media ( m : MEDIA ) : BOOLEAN is
		local
			i : INTEGER
			found : BOOLEAN
			type : CHARACTER
		do
			-- On analyse le type du media passé en paramètre
			if {LIVRE} ?:= m then
				type := 'l'
			elseif {DVD} ?:= m then
				type := 'd'
			else
				type := 'm'
			end

			-- On fait la comparaison seulement si le type de l'élément à l'indice i est le même que celui média passé en paramètre
			from i:= 1 found := False 
			until i = tmedia.upper or found = True
			loop
				inspect type
				when 'l' then
					if {LIVRE} ?:= tmedia.item(i)  then
						found := tmedia.item(i).is_equal(m)
					end
				when 'd' then			
					if {DVD} ?:= tmedia.item(i) then
						found := tmedia.item(i).is_equal(m)
					end
				when 'm' then
					found := tmedia.item(i).is_equal(m)
				end -- inspect
				i := i + 1
			end
			Result := found
		end
	  

	--Retourne un tableau d'emprunts qui ont le même user et le même média emprunté et non rendu
	--Si les paramètres sont passés à Void , tous les emprunts non rendus sont retournés
	--Si l'utilisateur est à Void, on fait la recherche sur le média passé en paramètre
	--Si le media est à Void, on fait la recherche sur l'utilisateur passé en paramètre
	--pre: si passé en paramètre, l'utilisateur doit exister 
	--pre: si passé en paramètre, le media doit exister 
	get_emprunts_non_rendus(u : USER; m : MEDIA) : ARRAY[EMPRUNT] is
		require
			user_exists : u /= Void implies has_user(u) = True
			media_exists : m /= Void implies has_media(m) = True
		local
			i : INTEGER
			out_emprunt : ARRAY[EMPRUNT]
		do
			create out_emprunt.make(1,1)
			from 
				i := 1
			until
				i = temprunt.upper
			loop
				if u = Void and m = Void and temprunt.item(i).getis_rendu = False then
					out_emprunt.add_first(temprunt.item(i))
				elseif u = Void then
					--FIX On rajoute un second if, au cas où m serait vide
					if m.is_equal(temprunt.item(i).getmedia) and temprunt.item(i).getis_rendu = False then
						out_emprunt.add_first(temprunt.item(i))
					end
				elseif m = Void  then
					--FIX On rajoute un second if, au cas où u serait vide
					if u.is_equal(temprunt.item(i).getuser) and temprunt.item(i).getis_rendu = False then
						out_emprunt.add_first(temprunt.item(i))
					end
				elseif u.is_equal(temprunt.item(i).getuser) and m.is_equal(temprunt.item(i).getmedia) and temprunt.item(i).getis_rendu = False then
					out_emprunt.add_first(temprunt.item(i))
				end					
				i := i + 1 	
			end

			Result := out_emprunt	
		end

	get_emprunts_en_retards ( array_emprunt : ARRAY[EMPRUNT] ) : ARRAY[EMPRUNT] is
	local
		i : INTEGER
		is_rendu : BOOLEAN
		out_emprunt : ARRAY[EMPRUNT]
		t : TIME
	do
		t.update
		from i := 1
		until i = array_emprunt.upper
		loop
			if t > array_emprunt.item(i).getdatedelai and is_rendu = False then
				out_emprunt.add_first(array_emprunt.item(i))
			end
		end
		Result := out_emprunt
	end

	--Retourne l'emprunt le plus récent 
	--pre: le tableau d'emprunt doit être non-vide TODO
	oldest_emprunt(array_emprunt : ARRAY[EMPRUNT]) : EMPRUNT is
		local
			i : INTEGER
			out_emprunt : EMPRUNT
		do
			out_emprunt := array_emprunt.item(1)
			from 
				i := 2
			until
				i = array_emprunt.upper
			loop
				
				if out_emprunt > array_emprunt.item(i) then
					out_emprunt := 	array_emprunt.item(i)
				end					
				i := i + 1 	
			end
			
			Result := out_emprunt	
		end

	getquota : INTEGER is
		do
			Result := quota_defaut
		end

	setquota ( qd : INTEGER) is
		do
			quota_defaut := qd
		end  

	getdelai : INTEGER is
		do
			Result := delai_defaut
		end

	setdelai ( dd : INTEGER) is
		do
			delai_defaut := dd
		end     
                 
	
end -- Classe Médiathèque

	
