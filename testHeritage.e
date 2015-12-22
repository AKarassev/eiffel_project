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
	tmp : USER
	tmpadmin : ADMIN
do

	create m.make(5,30)
	create u.make("utilisateur", "", "", m)
	create a.make("administrateur", "", "", m)
	create s.make("su", "", "", m)


	--m.ajouteruser(u)
	m.ajouteruser(s)

	--tmp := m.getusers.item(1)

	if {ADMIN} ?:= tmp then
		io.put_string("%NC'est un administrateur%N")
		--create {ADMIN} tmp.make_from_user(a)
		tmpadmin := a
		tmpadmin.ajouteruser(u)
	else
		io.put_string("%NC'est un utilisateur%N")
	end

	tmp := m.getusers.item(2)
	io.put_string("%N"+tmp.to_string+"%N")
	io.put_string("%NNombre de users : "+m.getusers.upper.to_string+"%N")

end

end -- class TESTHERITAGE 
