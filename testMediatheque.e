class TESTMEDIATHEQUE
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
	io.put_string("%N ------- Tests unitaires de la classe MEDIATHEQUE ------- %N")
	io.put_string("Test n°1%N")
	cas11	
--	cas12 -- Assertion Violated
	io.put_string("Test n°2%N")
	cas21
	io.put_string("Test n°3%N")
	cas31
	io.put_string("Test n°4%N")
	cas41
	cas42
--	cas43 -- Assertion Violated
	cas44
--	cas45 -- Assertion Violated
	io.put_string("Test n°5%N")
	cas51
	cas52
	io.put_string("%N ------- Fin des tests unitaires de la classe MEDIATHEQUE ------- %N")
end

-- Test n°1

cas11 is
local
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	assert := mt.getquota = 5 and mt.getdelai = 30 and mt.getsu.getid.is_equal("su")
	if assert = True then
		io.put_string("     Cas n°1.1 : réussite%N")
	else
		io.put_string("     Cas n°1.1 : échec%N")
	end
end

cas12 is
local
	mt : MEDIATHEQUE
do
	create mt.make(0,30)
	io.put_string("     Cas n°1.2 : échec%N")
end

-- test n°2 

cas21 is
local
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	mt.import_user("utilisateurs.txt")
	assert := mt.getusers.item(1) /= Void
	if assert = True then
		io.put_string("     Cas n°2.1 : réussite%N")
	else
		io.put_string("     Cas n°2.1 : échec%N")
	end
end

-- test n°3 

cas31 is
local
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	mt.import_media("medias.txt")
	assert := mt.getmedias.item(1) /= Void
	if assert = True then
		io.put_string("     Cas n°3.1 : réussite%N")
	else
		io.put_string("     Cas n°3.1 : échec%N")
	end
end

-- test n°4

cas41 is
local
	u : USER
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	mt.ajouteruser(u)
	assert := mt.getusers.item(1).getid.is_equal("e130159c")
	if assert = True then
		io.put_string("     Cas n°4.1 : réussite%N")
	else
		io.put_string("     Cas n°4.1 : échec%N")
	end
end

cas42 is
local
	u1, u2 : USER
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create u1.make("e130159c", "Eflamm", "Ollivier", mt)
	create u2.make("e130159c", "Mmalfe", "Reivillo", mt)
	mt.ajouteruser(u1)
	assert := mt.getusers.item(1).getnom.is_equal("Ollivier")
	mt.modifieruser(u1, u2)
	assert :=assert and mt.getusers.item(1).getnom.is_equal("Reivillo")
	if assert = True then
		io.put_string("     Cas n°4.2 : réussite%N")
	else
		io.put_string("     Cas n°4.2 : échec%N")
	end
end

cas43 is
local
	u1, u2 : USER
	mt : MEDIATHEQUE
do
	create mt.make(5,30)
	create u1.make("e130159c", "Eflamm", "Ollivier", mt)
	create u2.make("c951031e", "Mmalfe", "Reivillo", mt)
	mt.ajouteruser(u1)

	mt.modifieruser(u2, u1)
	io.put_string("     Cas n°4.3 : échec%N")
end

cas44 is
local
	u : USER
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	mt.ajouteruser(u)
	mt.supprimeruser(u)
	assert := mt.getusers.item(1) = Void
	if assert = True then
		io.put_string("     Cas n°4.4 : réussite%N")
	else
		io.put_string("     Cas n°4.4 : échec%N")
	end
end

cas45 is
local
	u : USER
	mt : MEDIATHEQUE
do
	create mt.make(5,30)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	mt.supprimeruser(u)
	io.put_string("     Cas n°4.5 : échec%N")
end


-- test n°5

cas51 is
local
	u : USER
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	mt.ajouteruser(u)
	mt.upgradeuser(u)
	assert := {ADMIN} ?:= mt.getusers.item(1)
	if assert = True then
		io.put_string("     Cas n°5.1 : réussite%N")
	else
		io.put_string("     Cas n°5.1 : échec%N")
	end
end

cas52 is
local
	a : ADMIN
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create a.make("e130159c", "Eflamm", "Ollivier", mt)
	mt.ajouteruser(a)
	mt.upgradeuser(a)
	assert := {ADMIN} ?:= mt.getusers.item(1)
	if assert = True then
		io.put_string("     Cas n°5.2 : réussite%N")
	else
		io.put_string("     Cas n°5.2 : échec%N")
	end
end

end -- class TESTMEDIATHEQUE

--remove_all_occurrences
--replace_all
