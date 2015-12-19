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
	do
		io.put_string("%N%N-------- MEDIATHEQUE -------- %N%N")

		io.put_string("Test de fichier_user %N")
		create mt1.make
		mt1.fichier_user("utilisateurs.txt")
		io.put_string(mt1.affichertoususer)
		

	end


end -- class TESTMEDIATHEQUE

--remove_all_occurrences
--replace_all
