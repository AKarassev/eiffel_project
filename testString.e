class TESTSTRING


creation{ANY}
	main

feature{ANY}
main is
	local 
		str1, str2:STRING
		arr1, arr2 : ARRAY[STRING]
		i, y: INTEGER
	do
		create arr1.make(1,1)
		create arr2.make(1,1)
--		str1 := "Nom<Delahaye> ; Prenom<Benoit> ; Identifiant<bdelahay>"		
--		str1 := "DVD ; Titre<The lord of the rings> ; Annee<2004> ; Realisateur<Peter Jackson>; Acteur<Elijah Wood>; Type<Coffret> ; Nombre<2>"
		str1 := "DVD ; Titre<Harry Potter> ; Annee<2012> ; Realisateur<Chris Colombus> ; Realisateur<David Yates> ; Acteur<Daniel Radcliffe> ; Acteur<Emma Watson> ; Acteur <Rupert Grint> ; Type<Coffret>"
		str1.append(" ")
--		str2 := ""
--		io.put_string(str2.count.to_string+"%N")
--		str2 := "%S"
--		io.put_string(str2.count.to_string+"%N")
		str1.replace_all(' ','|')
		str1.replace_all('<',' ')
		str1.replace_all('>',' ')
		str1.replace_all(';',' ')
--		io.put_string(str1+"%N")
		arr1.copy(str1.split)


--		from 
--			i := 1
--		until
--			i = arr1.upper
--		loop
--			io.put_string(arr1.item(i)+"%N")
--			i := i + 1 	
--		end
		

		from 
			i := 1
		until
			i = arr1.upper
		loop
			arr1.item(i).replace_all('|',' ')
			arr1.item(i).left_adjust
			arr1.item(i).right_adjust

			if arr1.item(i).count > 0 then
				arr2.add(arr1.item(i), arr2.upper)
			end
			i := i+1
		end

--		io.put_string(arr2.item(4)+"%N")

		from 
			i := 1
		until
			i = arr2.upper
		loop
			io.put_string(arr2.item(i)+"%N")
			i := i + 1 	
		end

	end


end -- class TESTSTRING
