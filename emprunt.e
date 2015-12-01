class EMPRUNT
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--


--TODO : que faire de l'emprunt une fois qu'il a été créé?

creation{ANY}
	make

feature{}
	dateemprunt, daterendu, datedelai : INTEGER --quel type utilisé? DATE_EVENT?
	user : USER
	media : MEDIA

feature{ANY}

	make ( u : USER; m : MEDIA; de, dr, dd : INTEGER) is
	do
		user := u
		media := m
		dateemprunt := de
		daterendu := dr
		datedelai := dd
	end

	setuser (u : USER) is
	do
		user := u
	end

	getuser : USER is
	do
		Result := user
	end

	setmedia (m : MEDIA) is
	do
		media := m
	end

	getmedia : MEDIA is
	do
		Result := media
	end



end -- classe EMPRUNT
