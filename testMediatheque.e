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
		u1 u2: USER
		a1, a2: ADMIN
		am1 : ARRAY[MEDIA]
		l1, l2 : LIVRE
		t : TIME
	do
		io.put_string("%N%N-------- MEDIATHEQUE -------- %N%N")

		io.put_string("%N ------- Test de fichier_user ------- %N")
		create mt1.make(5,30)
--		mt1.fichier_user("utilisateurs.txt")
--		io.put_string(mt1.to_string_all_user)
		io.put_string("%N ------- Test de fichier_media ------- %N")
		mt1.fichier_media("medias.txt")
--		io.put_string(mt1.to_string_all_media)
		io.put_string("%N ------- Test de fichier_media ------- %N")
		create a1.make("e130159c", "eflamm", "ollivier", mt1)
		create a2.make("e130159c", "eflamm", "ollivier", mt1)
		create u2.make("e130159c", "eflamm", "ollivier", mt1)
		create l1.make_livre("titre a", "auteur a", 3, mt1)
		create l2.make_livre("titre b", "auteur b", 3, mt1)
--		io.put_string("TEST HAS MEDIA : "+mt1.has_media(l1).to_string+"%N")
		mt1.ajoutermedia(l1)
		mt1.ajoutermedia(l2)
		mt1.ajouteruser(a1)
		create am1.make(1,1)
		am1 := a1.rechercher("2004", 2)
		--io.put_string(mt1.to_string_array_media(am1))
		t.update
--		a1.emprunter(mt1.getmedias.item(1), t)
		u1 := a1
--		io.put_string("EQUAL ADMIN: "+a1.is_equal(u2).to_string+"%N")
--		io.put_string("EQUAL USER: "+u2.is_equal(a1).to_string+"%N")
--		io.put_string("EQUAL USER: "+mt1.getusers.item(1).is_equal(u2).to_string+"%N")
		io.put_string("ADMIN EXIST: "+mt1.has_user(u2).to_string+"%N")
--		io.put_string(mt1.get_emprunts_non_rendu(u1, Void).item(1).to_string)
--		if u2  ?:= a1 then
--			b := True
--		else 
--			b := False
--		end
		io.put_string("TEST TYPE:"+mt1.getusers.upper.to_string+"%N")
	end


end -- class TESTMEDIATHEQUE

--remove_all_occurrences
--replace_all
