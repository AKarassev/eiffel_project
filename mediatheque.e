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



feature{ANY}

	make is
	do
		!!tuser.make(1,1)
		!!tmedia.make(1,1)
	end	

	main is
		local
                     x : INTEGER
		do
                     io.put_string("Bienvenue à la médiathèque %N")
                     io.flush
                     
                     io.put_string("Initialisation de la DB utilisateur %N")
                     create dbuser.make
                     dbuser.connect_to("utilisateurs.txt")
                     from
                            x := 0
                     until
                            dbuser.end_of_input
                     loop
                            dbuser.read_line
                            io.put_string(dbuser.last_string+"%N")
                     end
                     --create user1.make(1,"Daudet","Alphonse")
                     --io.put_string("Utilisateur créé %N")
		end -- fonction main

       parser (n : STRING):ARRAY[STRING] is
              local
                     res : ARRAY[STRING] -- tableau de résultat de la ligne
                     iin : INTEGER -- indice de parcourt du tableau d'entrée
                     s : STRING -- variable locale pour écrire dans le tableau de résultat
                     b : BOOLEAN -- si le booléen est à true, on écrit le caractère lu dans s
              do
                     b := False
                     from
                            iin := 1 -- on commence au début de la ligne
                     until
                            iin = n.count+1 -- parcourt jusqu'à la fin de la ligne
                     loop
                            if n @ iin = '<' then -- si on rencontre '<' on initialise le booléen à true pour commencer l'écriture
                              b := True
                            elseif n @ iin = '>' then -- si on rencontre '>' on set le booléen à false, on insère le mot dans le tableau de résultat, puis on vide la variable de stockage du mot pour passer à la suite
                              b := False
                              res.add_last(s)
                              s := ""
                            end

                            if b = True then
                              s.add_last(n @ iin)
                            end
                     end
                     Result:=res
              end  -- fonction parser  
	
	--Construit la base de données des utilisateurs de la mediatheque à partir d'un fichier
	--path : chemin du fichier texte décrivant les utilisateurs
	fichier_user ( path : STRING ) is
		local
			fichier : TEXT_FILE_READ
			id, nom, prenom : STRING
			x, y : INTEGER
			arrstring : ARRAY[STRING]
			str : STRING 
		do
			create fichier.make
			fichier.connect_to(path)
			!!arrstring.make(1,1)
			from
			    x := 0
			until
			    fichier.end_of_input
			loop
				fichier.read_line
				--io.put_string(fichier.last_string+"%N")
				str := fichier.last_string
				str.remove_all_occurrences(';')
				str.replace_all('<',' ')
				str.replace_all('>',' ')
				arrstring.copy(str.split)
				--io.put_string("Taille des split: ")
				--io.put_integer(arrstring.count)
				--io.put_string("%N")
				from
					y:=1
				until
					y > arrstring.upper
				loop
					--io.put_string(arrstring.item(y)+"%N")
					--io.put_integer(y)
					--io.put_string("%N")
					if(arrstring.item(y).is_equal("Nom")) then
						--io.put_string("Nom"+arrstring.item(y)+"%N")
						nom := arrstring.item(y+1)
										
					elseif (arrstring.item(y).is_equal("Prenom")) then
						--io.put_string("Prenom"+arrstring.item(y)+"%N")
						prenom := arrstring.item(y+1)
					
					elseif (arrstring.item(y).is_equal("Identifiant")) then
						--io.put_string("Idnetifiant"+arrstring.item(y)+"%N")
						id := arrstring.item(y+1)
						if ( arrstring.count = 6 ) then
							--io.put_string("User "+ id +" " + prenom + " " + nom +"%N")
							ajouteruser(id, prenom, nom)
						end	
					elseif (arrstring.item(y).is_equal("Admin")) then
						--io.put_string("Admin "+ id +" " + prenom + " " + nom +"%N")
						ajouteradmin(id, prenom, nom)
						
					end
					y := y + 2
				end
				io.put_new_line
				io.put_new_line

			end
			fichier.disconnect
		end 

	affichertoususer is
		local		
			i : INTEGER
			--str : STRING
		do
			
			from 
				i := 1
			until
				i = tuser.upper
			loop
				--str.append(tuser.item(i).to_string)
				io.put_string(tuser.item(i).to_string)
				i := i+1
			end
			--Result := str
		end
     
 	ajouteruser (id, p, n : STRING) is
		local
 			new_user : USER
		do
			!!new_user.make(id, p, n)
			--io.put_string(new_user.to_string)
			tuser.add_first(new_user)	
		end

	ajouteradmin (id, p, n : STRING) is
		local
 			new_admin : ADMIN
		do
			!!new_admin.make(id, p, n)
			--io.put_string(new_admin.to_string)
			tuser.add_first(new_admin)	
		end                          
	
end -- Classe Médiathèque

	
