class TESTUSER
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
             	u1, u31, u32, u33 u41, u42, u51, u52, u61 : USER
		a1, a2, a3 : ADMIN
		m1, m2, m3, m4, m5: MEDIATHEQUE
	do
		io.put_string("%N%N-------- USER -------- %N%N")

		io.put_string("%N Test de make %N")
		create m4.make
		create u1.make("e130159c", "eflamm", "ollivier", m4)
		io.put_string(u1.to_string)

		io.put_string("%N Test de is_equal %N")
		create m5.make
		create u31.make("e130159c", "eflamm", "ollivier", m5)
		create u32.make("e130159c", "mmalfe", "reivillo", m5)
		create u33.make("c951031e", "mmalfe", "reivillo", m5)
		io.put_string("Les users sont équivalents : "+u31.is_equal(u32).to_string+" %N")
		io.put_string("Les users sont différents : "+u31.is_equal(u33).to_string+" %N")


		io.put_string("%N-------- ADMIN --------%N")

		io.put_string("%N Test de ajouteruser %N")
		create m1.make
		create a1.make("admin1", "bob", "leponge", m1)
		create u41.make("e130159c", "eflamm", "ollivier", m1)
		create u42.make("c951031e", "mmalfe", "reivillo", m1)
		a1.ajouteruser(u41)
		a1.ajouteruser(u42)
		io.put_string("Première valeur du tableau d'utilisateur : "+m1.getusers.item(1).getid+" %N")
		io.put_string("Deuxième valeur du tableau d'utilisateur : "+m1.getusers.item(2).getid+" %N")

		io.put_string("%N Test de modifieruser %N")
		create m2.make
		create a2.make("admin2", "patrick", "star", m2)
		create u51.make("e130159c", "eflamm", "ollivier", m2)
		create u52.make("e130159c", "mmalfe", "reivillo", m2) -- user modifié
		a2.ajouteruser(u51)
		io.put_string("Valeur de l'élément non-modifié : "+m2.getusers.item(1).to_string)
		a2.modifieruser(u51, u52)
		io.put_string("Valeur de l'élément modifié : "+m2.getusers.item(1).to_string+" %N")

		io.put_string("%N Test de supprimeruser %N")
		create m3.make
		create a3.make("admin2", "patrick", "star", m3)
		create u61.make("e130159c", "eflamm", "ollivier", m3)
		a3.ajouteruser(u61)
		io.put_string("Ajout d'un utilisateur, existance: "+m3.getusers.has(u61).to_string+" %N")
		a3.supprimeruser(u61)
		io.put_string("suppression de l'utilisateur, existance: "+m3.getusers.has(u61).to_string+" %N")
	end


end -- class testuser
