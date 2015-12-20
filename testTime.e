class TESTTIME


creation{ANY}
	main

feature{ANY}

main is
local
	temps : TIME_IN_FRENCH
	time1, time2 : TIME
do
--	create time
	time1.update
	create temps
	temps.set_time(time1)
	io.put_string(temps.to_string+"%N")

	time2 := time1
	time2.add_day(30)
	temps.set_time(time2)
	io.put_string(temps.to_string+"%N")

	
	io.put_string("Comparaison: "+(time1<time2).to_string+"%N")

end -- main



end -- class TESTTIME
