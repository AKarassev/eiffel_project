class USER
--
-- Projet de Génie Logiciel à Objets
-- Eflamm Ollivier & Aurore Bouchet
--
inherit
	COMPARABLE 
	redefine is_equal end

creation{ANY}
	make, setnom, setprenom

feature{}
	nom, prenom, iduser : STRING
	mediatheque : MEDIATHEQUE
	nb_emprunt, quota : INTEGER

feature{ANY}
	
	--pre : vérifier que l'identifiant est unique			TODO
	make (id, p, n : STRING; mt : MEDIATHEQUE)  is
		do
			iduser := id
			nom := n
			prenom := p
			mediatheque := mt
			quota := mediatheque.getquota -- on définit le quota du user par rapport au quota par défaut de la médiatheque
			nb_emprunt := 0
		end

	setnom (n : STRING) is
		-- Modification du nom de l'utilisateur
		do
			nom := n
		end

	setprenom (n : STRING) is
		-- Modification du prénom de l'utilisateur
		do
			prenom := n
		end

	getnom : STRING is
		-- Retourne le nom
		do
			Result:=nom
		end

	getprenom : STRING is
		--Retourne le prenom
		do
			Result:=prenom
		end

	getid : STRING is
		--Retourne l'identifiant
		do
			Result:=iduser
		end

	getmediatheque : MEDIATHEQUE is
	do
		Result := mediatheque
	end

	-- Faire une recherche parmi les médias, dont les données pourraient correpsondre à la chaîne de caractère
	-- Si cat = 0 alors on fait une recherche sur tous les médias
	-- Si cat = 1 alors on fait une recherche sur tous les livre
	-- Si cat = 2 alors on fait une recherche sur tous les dvd
	-- TODO on peut améliorer le filtre
	-- pre: cat doit être compris entre 0 et 2
	rechercher (s : STRING; cat : INTEGER) : ARRAY[MEDIA] is
	require
		is_categorie : cat >= 0 and cat <= 2
	local
		i, j : INTEGER
		out_medias : ARRAY[MEDIA]
		array_split : ARRAY[STRING]
		m : MEDIA
	do
		create out_medias.make(1,1)
		create array_split.make(1,1)
		s.append(" |")  		--FIX bug de split, qui jète le dernier élément
		array_split := s.split

		from 
			i := 1
		until
			i = mediatheque.getmedias.upper
		loop
			m := mediatheque.getmedias.item(i)
			from
				j := 1
			until
				j = array_split.upper
			loop
				inspect cat
				when 0 then
					if m.to_string.has_substring(array_split.item(j)) then
						out_medias.add_first(m)
					end
				when 1 then
					if m.to_string.has_substring(array_split.item(j)) and {LIVRE} ?:= m then
						out_medias.add_first(m)
					end
				when 2 then
					if m.to_string.has_substring(array_split.item(j)) and {DVD} ?:= m then
						out_medias.add_first(m)
					end
				end	
				j := j + 1
			end
			i := i + 1 	
		end
		Result := out_medias
	end

       
	-- pre : le nombre d'emprunt actuel du user doit être strictement inférieur au quota qu'il lui a été accordé 
	-- pre : le media doit exister dans la mediatheque TODO
	-- pre : le media doit avoir au moins un exemplaire disponible
	-- post : le nombre d'emprunt de l'utilisateur est incrémenté de 1 TODO
	-- post : le nombre d'exemplaire disponible pour le média concerné est décrémenté de 1 TODO
	-- post : le nouvel emprunt a bien été enregistré dans la médiathèque TODO
	emprunter (m : MEDIA; de : TIME) is
		require
			quota_atteint : nb_emprunt < quota
			exemplaire_disponible : m.getnb_exemplaire > 0
		local	
			new_emprunt : EMPRUNT
			dd : TIME			
		do
			dd := de
			dd.add_day(mediatheque.getdelai)
			create new_emprunt.make(Current, m, de, dd)
			mediatheque.ajouteremprunt(new_emprunt)
			nb_emprunt := nb_emprunt + 1 			-- on incrémente le nombre de médias empruntés
			m.setnb_exemplaire(m.getnb_exemplaire-1) 	-- on décrémente le nombre d'exemplaires disponibles pour le media
		end

	-- on rend le plus ancien emprunt du media emprunté
	-- pre : on ne peut pas rendre plus de médias que l'on n’en a emprunté
	-- pre : il doit exister un emprunt correspondant au media, dont is_rendu = False TODO
	-- post : le media concerné voit son nombre d'exemplaire incrémenté de 1 TODO
	-- post : l'emprunt concerné voit la valeur de is_rendu passé à True TODO 
	rendre (m : MEDIA; dr : TIME) is
		require
			nb_emprunt_minimum : nb_emprunt >= 0
		local
			e : EMPRUNT
		do
			e := mediatheque.oldest_emprunt(mediatheque.get_same_emprunts_non_rendu(Current, m))
			e.setis_rendu(True)			
			-- TODO que faire si l'utilisateur le rend en retard
			m.setnb_exemplaire(m.getnb_exemplaire+1)			
			nb_emprunt := nb_emprunt + 1
		end

	to_string : STRING is
		do
			Result := "%N Identifiant :"+iduser+"%N Nom: "+nom+"%N Prénom: "+prenom+"%N"
		end

	--L'égalité de deux users se fait uniquement sur iduser
	is_equal(other : like Current) : BOOLEAN is
		do
			Result := iduser.is_equal(other.getid)
		end

	--Méthode nécessaire pour implémenter is_equal
	infix "<" (other: like Current) : BOOLEAN is
		do	
			Result := iduser < other.getid
		end

end -- classe USER

			
			
