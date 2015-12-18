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
             	u1, u2, u31, u32, u33 u41, u42, u51, u52, u61 : USER
		a1, a2, a3 : ADMIN
		tu1, tu2, tu3 : ARRAY[USER]
		l1 : LIVRE
		te1 : ARRAY[EMPRUNT]
	do
		io.put_string("%N%N-------- USER -------- %N%N")

		io.put_string("%N Test de make %N")
		create u1.make("e130159c", "eflamm", "ollivier")
		io.put_string(u1.to_string)

		io.put_string("%N Test de emprunter %N")
		create u2.make("e130159c", "eflamm", "ollivier")
		create l1.make_livre("Le suicide français", 2014, "Eric Zemmour")
		create te1.make(1,1)
		u2.emprunter(l1, te1)
		io.put_string("Titre du media emprunté : "+te1.item(1).getmedia.gettitre+" %N")
		io.put_string("Nom de l'emprunteur : "+te1.item(1).getuser.to_string+" %N")

		io.put_string("%N Test de is_equal %N")
		create u31.make("e130159c", "eflamm", "ollivier")
		create u32.make("e130159c", "mmalfe", "reivillo")
		create u33.make("c951031e", "mmalfe", "reivillo")
		io.put_string("Les users sont équivalents : "+u31.is_equal(u32).to_string+" %N")
		io.put_string("Les users sont différents : "+u31.is_equal(u33).to_string+" %N")


		io.put_string("%N-------- ADMIN --------%N")

		io.put_string("%N Test de ajouteruser %N")
		create a1.make("admin1", "bob", "leponge")
		create tu1.make(1,1)
		create u41.make("e130159c", "eflamm", "ollivier")
		create u42.make("c951031e", "mmalfe", "reivillo")
		a1.ajouteruser(u41, tu1)
		a1.ajouteruser(u42, tu1)
		io.put_string("Première valeur du tableau d'utilisateur : "+tu1.item(1).getid+" %N")
		io.put_string("Deuxième valeur du tableau d'utilisateur : "+tu1.item(2).getid+" %N")

		io.put_string("%N Test de modifieruser %N")
		create a2.make("admin2", "patrick", "star")
		create u51.make("e130159c", "eflamm", "ollivier")
		create u52.make("e130159c", "mmalfe", "reivillo") -- user modifié
		create tu2.make(1,1)
		a2.ajouteruser(u51, tu2)
		io.put_string("Valeur de l'élément non-modifié : "+tu2.item(1).to_string)
		a2.modifieruser(u51, u52, tu2)
		--a2.modifieruser("c951031e", "mmalfe", "reivillo", tu2) -- utilisateur inexistant
		io.put_string("Valeur de l'élément modifié : "+tu2.item(1).to_string+" %N")

		io.put_string("%N Test de supprimeruser %N")
		create a3.make("admin2", "patrick", "star")
		create tu3.make(1,1)
		create u61.make("e130159c", "eflamm", "ollivier")
		a3.ajouteruser(u61, tu3)
		io.put_string("Ajout d'un utilisateur, existance: "+tu3.has(u61).to_string+" %N")
		a3.supprimeruser(u61, tu3)
		io.put_string("suppression de l'utilisateur, existance: "+tu3.has(u61).to_string+" %N")
	end


end -- class testuser
