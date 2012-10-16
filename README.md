### Blog with rails

Vous trouverez ici le résultat de ma permière rencontre avec Ruby on Rails.

J'ai tenté d'y développer un blog avec pour fonctionnalités:

- Post (création / edition / suppression)
- Commentaire (création / edition / suppression)
 - J'aurais préféré mettre du Disqus mais bon ... :)
- Upload d'image d'illustration pour les articles à l'aide de paperclip et imagemagick
- Export pdf des articles (mise en page primaire) à l'aide de prawn
- Le body des articles et commentaire s'écrit en markdown, à l'aide de bluecloth
- Export des articles en xml et json
- Et bien sur un peu de js bourrin dégueu pour rigoler
 - Logo yeux qui tirent des lasers ... j'avais pas de meilleur idée :C
 - Bg bulle de bière
- Le html est rédigé en haml, le js en CoffeeScript
- Historique HTML pushState blabla - pas d'utilisation d'history.js parce que ca fonctionne tres bien sur chrome et ff
- Chargement des contenu en ajax - c'est assé bourin
- Utilisation de zepto.js pour chargement ajax
- Pour l'admin - utilisation d'Active Admin
 - Login : admin@example.com
 - Mot de passe : doublerainbowinthesky
 - acces _/admin_

![Coucou](https://i.canvasugc.com/ugc/original/8f718d6fd18207699929bbf002917c48c193d29c.gif)
