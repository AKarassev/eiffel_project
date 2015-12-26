class SUPERADMIN

inherit
ADMIN

creation{ANY}
	make




feature{ANY}
--TODO importer la liste des utilisateurs

--Passe un user en admin
--pre: l'utilisateur doit exister 
--post: l'utilisateur est un administrateur TODO
upgrade_user (up_user : USER) is
require
	user_exists : mediatheque.has_user(up_user) = True
local
	i : INTEGER
	new_admin : ADMIN
do
	mediatheque.upgradeuser(up_user)
end -- upgrade_user

end -- class SUPERADMIN
