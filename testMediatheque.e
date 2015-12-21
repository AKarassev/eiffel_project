class TESTMEDIATHEQUE
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
-- Classe de tests
--
creation{ANY}
	main

feature{ANY}
main is
	local
		mt1 : MEDIATHEQUE
		u1 : USER
		am1 : ARRAY[MEDIA]
		i : INTEGER	
	do
		io.put_string("%N%N-------- MEDIATHEQUE -------- %N%N")

		io.put_string("%N ------- Test de fichier_user ------- %N")
		create mt1.make(5,30)
		mt1.fichier_user("utilisateurs.txt")
--		io.put_string(mt1.to_string_all_user)
		io.put_string("%N ------- Test de fichier_media ------- %N")
		mt1.fichier_media("medias.txt")
--		io.put_string(mt1.to_string_all_media)
		io.put_string("%N ------- Test de fichier_media ------- %N")
		create u1.make("e130159c", "eflamm", "ollivier", mt1)
		create am1.make(1,1)
		am1 := u1.rechercher("Livre")
	
		from 
			i := 1
		until
			i = am1.upper
		loop
			io.put_string(am1.item(i).to_string + "%N")
			i := i + 1 	
		end
		
		
		

	end


end -- class TESTMEDIATHEQUE

--remove_all_occurrences
--replace_all
