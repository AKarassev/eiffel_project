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
       
	-- pre : le nombre d'emprunt actuel du user doit être strictement inférieur au quota qu'il lui a été accordé 
	-- pre : le media doit avoir au moins un exemplaire disponible
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

	-- on rend le premiere occurence du media emprunté
	-- pre : on ne peut pas rendre plus de medias que n'on en a emprunté
	-- pre : il doit exister un emprunt correspondant au media, dont is_rendu = False TODO
	rendre (m : MEDIA; dr : TIME) is
		require
			nb_emprunt_minimum : nb_emprunt >= 0
		local
			e : EMPRUNT
		do
			-- TODO on récupère l'emprunt le plus ancien avec is_rendu = false, on incrémente le nombre d'exemplaires disponibles et on passe is_rendu := True
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

			
			
