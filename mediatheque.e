class MEDIATHEQUE
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
-- Classe principale
--
creation{ANY}
	main

feature{ANY}
       user : USER -- un utilisateur
       dbuser : TEXT_FILE_READ -- la liste des utilisateurs
       tuser: ARRAY[USER] -- la liste des utilisateurs

feature{ANY}
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
		end

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
              end             
                            
	
end -- Classe Médiathèque

	
