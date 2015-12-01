class TESTMEDIA
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
		l1 : LIVRE
	do
		io.put_string("%N%N-------- LIVRE -------- %N%N")

		io.put_string("Test de make %N")
		!!l1.make_livre("Le suicide français", 2014, "Eric Zemmour")
		io.put_string("Titre: "+l1.gettitre+"%N")
		io.put_string("Annee: ")
		io.put_integer(l1.getannee)
		io.put_new_line
		io.put_string("Auteur: "+l1.getauteur+"%N")
	end


end -- class TESTMEDIA
