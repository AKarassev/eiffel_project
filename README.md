# eiffel_project


Configurer Git

1)Créer un nouveau répertoire
mkdir Messagerie
cd Messagerie
2) Initialiser comme répertoire git
$git init
3)Cloner le repo en ligne
$git clone git@github.com:EflammOllivier/Messagerie.git
4) Relier le repo en local avec le repo en ligne
git remote add origin git@github.com:EflammOllivier/Messagerie.git
git remote set-url origin git@github.com:EflammOllivier/Messagerie.git


Uploader les données

1)Modifier un fichier
2)Faire un commit pour enregistrer les modifications:
$commit -m "faire un commentaire"
(utiliser la commande $git status pour savoir si il y a quelque chose à commité)
3)Envoyer les commit sur le serveur
$git push origin master
origin: nom du lien
master: branche principale du repo

Pour ajouter un fichier
$git add -A
