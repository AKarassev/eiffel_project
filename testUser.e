class TESTUSER
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
-- Classe de tests
--
creation{ANY}
	main

feature{ANY}

--Certains cas sont mis en commentaires intentionnellement
--Cela ne veut pas dire qu'ils sont inutiles
--Ils servent à tester les contrats des méthodes
main is
do
	io.put_string("%N ------- Tests unitaires de la classe USER ------- %N")
	io.put_string("Test n°1%N")
	cas11
	io.put_string("Test n°2%N")
	cas21
	cas22
	cas23
	cas24
--	cas25 -- Assertion Violated
	io.put_string("Test n°3%N")
	cas31
--	cas32 -- Assertion Violated
--	cas33 -- Assertion Violated
	io.put_string("Test n°4%N")
	cas41
--	cas42 -- Assertion Violated
	io.put_string("Test n°5%N")
	cas51
	cas52
	io.put_string("%N ------- Fin des tests unitaires de la classe USER ------- %N")
end


--test n°1 - make

cas11 is
local
	u : USER
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	assert := u.getid.is_equal("e130159c") and u.getprenom.is_equal("Eflamm") and u.getnom.is_equal("Ollivier") and u.getnb_emprunt = 0
	assert := assert and u.getmediatheque /= Void and u.getquota = mt.getquota
	if assert = True then
		io.put_string("     Cas n°1.1 : réussite%N")
	else
		io.put_string("     Cas n°1.1 : échec%N")
	end
end

--test n°2 - rechercher

cas21 is
local
	u : USER
	l : LIVRE
	mt : MEDIATHEQUE
	assert : BOOLEAN
	array_m : ARRAY[MEDIA]
do
	create mt.make(5,30)
	create l.make_livre("titre", "auteur", 1, mt)
	mt.ajoutermedia(l)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	create array_m.make(1,1)

	array_m := u.rechercher("aut", 0)
	assert := array_m.item(1).gettitre.is_equal("titre")
	if assert = True then
		io.put_string("     Cas n°2.1 : réussite%N")
	else
		io.put_string("     Cas n°2.1 : échec%N")
	end
end

cas22 is
local
	u : USER
	l : LIVRE
	d : DVD
	mt : MEDIATHEQUE
	assert : BOOLEAN
	array_m : ARRAY[MEDIA]
	array_str : ARRAY[STRING]
do
	create array_str.make(1,1)
	create mt.make(5,30)
	create l.make_livre("titre1", "auteur", 1, mt)
	create d.make_dvd("titre2", 2016, array_str, array_str, "type", 1, mt) 
	mt.ajoutermedia(l)
	mt.ajoutermedia(d)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	create array_m.make(1,1)

	array_m := u.rechercher("tit", 0)
	assert := array_m.item(1).gettitre.is_equal("titre1") and array_m.item(2).gettitre.is_equal("titre2")
	if assert = True then
		io.put_string("     Cas n°2.2 : réussite%N")
	else
		io.put_string("     Cas n°2.2 : échec%N")
	end
end

cas23 is
local
	u : USER
	l : LIVRE
	mt : MEDIATHEQUE
	assert : BOOLEAN
	array_m : ARRAY[MEDIA]
do
	create mt.make(5,30)
	create l.make_livre("titre", "auteur", 1, mt)
	mt.ajoutermedia(l)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	create array_m.make(1,1)

	array_m := u.rechercher("aze", 0)
	-- il n'y a pas de résultats
	assert := array_m.item(1) = Void
	if assert = True then
		io.put_string("     Cas n°2.3 : réussite%N")
	else
		io.put_string("     Cas n°2.3 : échec%N")
	end
end

cas24 is
local
	u : USER
	l : LIVRE
	d : DVD
	mt : MEDIATHEQUE
	assert : BOOLEAN
	array_m : ARRAY[MEDIA]
	array_str : ARRAY[STRING]
do
	create array_str.make(1,1)
	create mt.make(5,30)
	create l.make_livre("azerty", "auteur", 1, mt)
	create d.make_dvd("uiop", 2016, array_str, array_str, "type", 1, mt) 
	mt.ajoutermedia(l)
	mt.ajoutermedia(d)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	create array_m.make(1,1)

	array_m := u.rechercher("azer", 2)
	-- il n'y a pas de résultats
	assert := array_m.item(1) = Void
	if assert = True then
		io.put_string("     Cas n°2.4 : réussite%N")
	else
		io.put_string("     Cas n°2.4 : échec%N")
	end
end

cas25 is
local
	u : USER
	l : LIVRE
	mt : MEDIATHEQUE
	assert : BOOLEAN
	array_m : ARRAY[MEDIA]
do
	create mt.make(5,30)
	create l.make_livre("titre", "auteur", 1, mt)
	mt.ajoutermedia(l)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	create array_m.make(1,1)

	--numéro de catégorie incorrect
	array_m := u.rechercher("aut", 3)
	io.put_string("     Cas n°2.5 : échec%N")
end

--test n°3 - emprunter

cas31 is
local
	u : USER
	l : LIVRE
	mt : MEDIATHEQUE
	assert : BOOLEAN
	array_e : ARRAY[EMPRUNT]
	t : TIME
	nbe1, nbe2 : INTEGER
do
	create mt.make(5,30)
	create l.make_livre("titre", "auteur", 1, mt)
	mt.ajoutermedia(l)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	create array_e.make(1,1)
	t.update

	nbe1 := u.getnb_emprunt
	u.emprunter(l, t)
	nbe2 := u.getnb_emprunt
	array_e := mt.getemprunts
	assert := array_e.item(1).getuser.is_equal(u) and array_e.item(1).getmedia.is_equal(l) and nbe2 = nbe1 + 1
	if assert = True then
		io.put_string("     Cas n°3.1 : réussite%N")
	else
		io.put_string("     Cas n°3.1 : échec%N")
	end
end

cas32 is
local
	u : USER
	l1, l2 : LIVRE
	mt : MEDIATHEQUE
	array_e : ARRAY[EMPRUNT]
	t : TIME
do
	create mt.make(1,30)
	create l1.make_livre("titre1", "auteur", 1, mt)
	create l2.make_livre("titre2", "auteur", 1, mt)
	mt.ajoutermedia(l1)
	mt.ajoutermedia(l2)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	create array_e.make(1,1)
	t.update

	-- génère un erreur
	u.emprunter(l1, t)
	u.emprunter(l2, t)
	io.put_string("     Cas n°3.2 : échec%N")
end

cas33 is
local
	u : USER
	l : LIVRE
	mt : MEDIATHEQUE
	array_e : ARRAY[EMPRUNT]
	t : TIME
do
	create mt.make(1,30)
	create l.make_livre("titre", "auteur", 0, mt)
	mt.ajoutermedia(l)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	create array_e.make(1,1)
	t.update

	-- génère un erreur
	u.emprunter(l, t)
	io.put_string("     Cas n°3.3 : échec%N")
end

--test n°4 - emprunter

cas41 is
local
	u : USER
	l : LIVRE
	mt : MEDIATHEQUE
	assert : BOOLEAN
	array_e : ARRAY[EMPRUNT]
	t : TIME
	nbe1, nbe2 : INTEGER
do
	create mt.make(5,30)
	create l.make_livre("titre", "auteur", 1, mt)
	mt.ajoutermedia(l)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	mt.ajouteruser(u)
	create array_e.make(1,1)
	t.update

	u.emprunter(l, t)
	nbe1 := u.getnb_emprunt
	u.rendre(l,t)
	nbe2 := u.getnb_emprunt
	array_e := mt.getemprunts
	assert := array_e.item(1).getis_rendu = True and nbe2 = nbe1 - 1
	if assert = True then
		io.put_string("     Cas n°4.1 : réussite%N")
	else
		io.put_string("     Cas n°4.1 : échec%N")
	end
end


cas42 is
local
	u : USER
	l : LIVRE
	mt : MEDIATHEQUE
	array_e : ARRAY[EMPRUNT]
	t : TIME
do
	create mt.make(5,30)
	create l.make_livre("titre", "auteur", 1, mt)
	mt.ajoutermedia(l)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	mt.ajouteruser(u)
	create array_e.make(1,1)
	t.update

	u.rendre(l,t)
	io.put_string("     Cas n°4.2 : échec%N")

end

--test n°5 - is_equal

cas51 is
local
	u1, u2 : USER
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create u1.make("e130159c", "Eflamm", "Ollivier", mt)
	create u2.make("e130159c", "Mmalfe", "Reivillo", mt)
	assert := u1.is_equal(u2) and u2.is_equal(u1)
	if assert = True then
		io.put_string("     Cas n°5.1 : réussite%N")
	else
		io.put_string("     Cas n°5.1 : échec%N")
	end
end

cas52 is
local
	u1, u2 : USER
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create u1.make("e130159c", "Eflamm", "Ollivier", mt)
	create u2.make("c951031e", "Eflamm", "Ollivier", mt)
	assert := not (u1.is_equal(u2) and u2.is_equal(u1))
	if assert = True then
		io.put_string("     Cas n°5.2 : réussite%N")
	else
		io.put_string("     Cas n°5.2 : échec%N")
	end
end

end -- class testuser
