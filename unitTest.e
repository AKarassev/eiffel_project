class UNITTEST

creation{ANY}
       main

feature{ANY}

main is
local
	u : TESTUSER
	a : TESTADMIN
	mt : TESTMEDIATHEQUE
do
	io.put_new_line
	io.put_string("--------------------------------------------------------------------- %N")
	io.put_string("-------------------------- TESTS UNITAIRES -------------------------- %N")
	io.put_string("--------------------------------------------------------------------- %N")
	create u.main
	io.put_new_line
	create a.main
	io.put_new_line
	create mt.main
	io.put_new_line
	io.put_string("--------------------------------------------------------------------- %N")
	io.put_string("----------------------- FIN TESTS UNITAIRES ------------------------- %N")
	io.put_string("--------------------------------------------------------------------- %N")
	io.put_new_line
end


end -- class UNITTEST
