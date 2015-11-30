class MEDIA
--
-- Classe représentant les médias
-- Cette classe sera abstraite par la suite
--
creation{ANY}
       make

feature{}
       idmedia : INTEGER
       titre : STRING

feature{ANY}
       make is
              -- Création d'un nouveau media
              require
                     n >= 1

end -- classe MEDIA

