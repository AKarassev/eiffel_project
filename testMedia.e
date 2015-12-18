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
		l1, l2, l3, l4: LIVRE
	do
		io.put_string("%N%N-------- LIVRE -------- %N%N")

		io.put_string("Test de make %N")
		create l1.make_livre("Le suicide français", 2014, "Eric Zemmour")
		io.put_string("Titre: "+l1.gettitre+"%N")
		io.put_string("Annee: ")
		io.put_integer(l1.getannee)
		io.put_new_line
		io.put_string("Auteur: "+l1.getauteur+"%N")

              io.put_string("Test de is_equal %N")
              create l2.make_livre("Le suicide français", 2014, "Eric Zemmour")
              create l3.make_livre("Le suicide français", 2014, "Eric Zemmour")
              create l4.make_livre("Merci pour ce moment", 2014, "Valérie Trierweiler")
              io.put_string("Attendu True: ")
              io.put_boolean(l2.is_equal(l3))
              io.put_new_line
              io.put_string("Attendu False: ")
              io.put_boolean(l2.is_equal(l4))
              io.put_new_line
	end


end -- class TESTMEDIA
