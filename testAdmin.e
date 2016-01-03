class TESTADMIN


creation{ANY}
	main

feature{ANY}

main is
local
u1 : USER
u2 : USER
l1 : LIVRE
l2 : LIVRE
m1 : MEDIATHEQUE
t1 : TIME
a1 : ADMIN

do

io.put_string("Tests : gestion des utilisateurs %N%N")
io.put_new_line

io.put_string("Cas n°1: ajouter un utilisateur %N%N")

create m1.make(5, 30)
create a1.make("e115286l", "Aurore", "Bouchet", m1)
create u1.make("e130159c", "Eflamm", "Ollivier", m1)
a1.ajouteruser(u1)
io.put_string("Attendu True: ")
io.put_boolean(m1.has_user(u1))

io.put_string("Cas n°2: ajouter un utilisateur %N%N")

a1.ajouteruser(u1)
io.put_string("Attendu True: ")
io.put_boolean(m1.has_user(u1))

io.put_string("Cas n°3: modifier utilisateur qui existe %N%N")

create u1.make("e130159c", "Eflamm", "Chabada", m1)
a1.modifieruser(u1,u2)
io.put_string("Attendu True: ")
io.put_boolean(m1.has_user(u2))

io.put_string("Cas n°4: modifier utilisateur qui n'existe pas %N%N")

a1.modifieruser(u3,u2)
io.put_string("Attendu False: ")
io.put_boolean(m1.has_user(u2))

io.put_string("Cas n°5: supprimer utilisateur qui existe %N%N")

a1.supprimeruser(u1)
io.put_string("Attendu False: ")
io.put_boolean(m1.has_user(u1))

io.put_string("Cas n°6: supprimer utilisateur qui n'existe pas %N%N")

a1.supprimeruser(u4)
io.put_string("Attendu False: ")
io.put_boolean(m1.has_user(u4))

io.put_string("Cas n°7: Administrateur qui supprime un administrateur %N%N")

io.put_string("Attendu True: ")

io.put_string("Cas n°7: Administrateur qui supprime un administrateur %N%N")

io.put_string("Tests : gestion des médias %N%N")
io.put_new_line

io.put_string("Cas n°1: Ajouter un média %N%N")

create l1.make_livre("Le suicide français", "Eric Zemmour", 1, m1)
a1.ajoutermedia(l1)
io.put_string("Attendu True: ")
io.put_boolean(m1.has_media(l1)

io.put_string("Cas n°2: Modifier un média %N%N")

create l1.make_livre("Le suicide français", "Eric Zemourr", 1, m1)
a1.modifiermedia(l1,l2)
io.put_string("Attendu True: ")
io.put_boolean(m1.has_media(l2)

io.put_string("Cas n°3: Supprimer un média %N%N")

a1.supprimermedia(l1)
io.put_string("Attendu False: ")
io.put_boolean(m1.has_media(l1)


end -- main



end -- class TESTADMIN
