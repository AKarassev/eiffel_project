class TESTADMIN


creation{ANY}
	main

feature{ANY}

main is
local
u1 : USER
l1 : LIVRE
m1 : MEDIATHEQUE
t1 : TIME

do

io.put_string("Cas n°1: ajouter un utilisateur %N%N")

create m1.make(5, 30)
create u1.make("e130159c", "Eflamm", "Ollivier", m1)
io.put_string("Attendu True: ")
io.put_boolean(m1.has_user(u1))

io.put_string("Cas n°2: ajouter un utilisateur %N%N")

create u1.make("e130159c", "Eflamm", "Ollivier", m1)
io.put_string("Attendu True: ")
io.put_boolean(m1.has_user(u1))

io.put_string("Cas n°3: modifier utilisateur qui existe %N%N")

io.put_string("Cas n°4: modifier utilisateur qui n'existe pas %N%N")

io.put_string("Cas n°5: supprimer utilisateur qui existe %N%N")

io.put_string("Cas n°6: modifier utilisateur qui existe %N%N")





end -- main



end -- class TESTADMIN
