class TESTHERITAGE


creation{ANY}
	main

feature

m : MEDIATHEQUE
u : USER
a : ADMIN
s : SUPERADMIN

feature{ANY}

main is
local
	v, tmp : USER
	tmpadmin : ADMIN
	ai : ARRAY[INTEGER]
	l1, l2 : LIVRE
	d1, d2 : DVD
	m1 : MEDIA
	array : ARRAY[STRING]
do

	create m.make(5,30)
	create u.make("utilisateur", "", "", m)
	create a.make("administrateur", "", "", m)
	create s.make("su", "", "", m)
	create l1.make_livre("titre a", "auteur a", 3, m)
	create l2.make_livre("titre a", "auteur b", 3, m)
	create array.make(1,1)
	create d1.make_dvd("titre a", 2015, array, array, "type", 3, m)
	create d2.make_dvd("titre a", 2015, array, array, "type", 3, m)
	m1 := d1
--	d2 := m
	m.ajoutermedia(l1)
	m.ajoutermedia(d1) 


	m.ajouteruser(a)
	m.ajouteruser(u)
--	m.ajouteruser(s)

	--tmp := m.getusers.item(1)

	if {ADMIN} ?:= tmp then
--		io.put_string("%NC'est un administrateur%N")
		--create {ADMIN} tmp.make_from_user(a)
--		tmpadmin := a
--		tmpadmin.ajouteruser(u)
	else
--		io.put_string("%NC'est un utilisateur%N")
	end

	tmp := m.getusers.item(2)
--	io.put_string("%N"+tmp.to_string+"%N")
--	io.put_string("%NNombre de users : "+m.getusers.upper.to_string+"%N")

--	fonction(v)	

	create ai.make(0,0)
	create tmp.make("administrateur", "", "", m)
	m1 := d1
	d2.copy(m1)
--	io.put_string("%NTaille d'un tableau vide "+ai.count.to_string+"%N")
--	io.put_string("%NEQUAL LIVRE LIVRE "+l1.is_equal(l2).to_string+"%N")
--	io.put_string("%NEQUAL DVD DVD "+d1.is_equal(d2).to_string+"%N")
--	io.put_string("%NEQUAL LIVRE DVD "+l1.is_equal(d1)+"%N")
--	io.put_string("%NTO STRING "+m1.to_string+"%N")
--	io.put_string("%NHAS "+m.has_media(l2).to_string+"%N")
--	io.put_string("%NHAS "+m.has_user(tmp).to_string+"%N")
	io.put_string("%NDVD METHOD "+d2.getannee.to_string+"%N")

end

fonction (plop : USER) is
do
	if plop = Void then
		io.put_string("%NLa variable est à null%N")
	end
end

end -- class TESTHERITAGE 
