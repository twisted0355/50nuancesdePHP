# sélection de toutes les news
SELECT * FROM news;

# sélection des user
SELECT * FROM user;

# sélection des categ
SELECT * FROM categ;

# sélection des permission
SELECT * FROM permission;


# sélection du 'title' et 'content' des 'news' et le 'name' venant de la table 'user'
SELECT  news.title, news.content, user.name
FROM news
INNER JOIN user
ON user.iduser = news.user_iduser;

# sélection du 'title' et 'content' des 'news' et le 'name' venant de la table 'user' ainsi que le 'name' renommé en 'pname' et le 'level' de la table permission
SELECT news.title, news.content, permission.level, user.name AS pname
FROM news
INNER JOIN user
ON user.iduser = news.user_iduser
INNER JOIN permission
ON permission.idpermission = user.permission_idpermission;

    
# sélection de tous les champs de "user", et du "name" renommé "pname" qui ont le level "3" depuis "permission"
SELECT user.*, permission.name AS pname, permission.level
FROM user
INNER JOIN permission
ON user.permission_idpermission = permission.idpermission
WHERE permission.level LIKE '%3%';

# Sélection de tous les champs de "user" et le "level" de "permission" lorsque "user.login" vaut "editor" et "user.pwd" vaut "editor"
SELECT user.*, permission.level
FROM user
INNER JOIN permission
ON user.permission_idpermission = permission.idpermission
WHERE user.login LIKE '%edit%' AND user.pwd LIKE '%edit%';

    
# sélection des categ pour le menu (idcateg et name)
SELECT categ.idcateg, categ.name
FROM categ;


# Sélection de toutes les "news" (idnews, title, content, publication) LORSQUE "news.visible"=1
SELECT news.*
FROM news
WHERE news.visible LIKE '%1%';

    
# Sélection de toutes les "news" (idnews, title, 220 caractères de content, publication) LORSQUE "news.visible"=1
SELECT news.*, left(news.content,220)
FROM news
WHERE news.visible LIKE '%1%';

    
# Sélection de toutes les "news" (idnews, title, 220 caractères de content, publication), lien non obligatoire avec "categ" (idcateg,name)  LORSQUE "news.visible"=1
SELECT news.*, left(news.content,220), categ.idcateg, categ.name
FROM news
INNER JOIN categ
ON categ.idcateg = news.idnews
WHERE news.visible LIKE '%1%';
    
# Sélection de toutes les "news" (idnews, title, 220 caractères de content, publication), lien non obligatoire avec "categ" (idcateg,name => SONT résultats concaténés, idcateg avec une ",", name avec "_€.€_")  LORSQUE "news.visible"=1 le tout groupé par "n.idnews"
   SELECT news.*, left(news.content,220),
   GROUP_CONCAT(categ.idcateg SEPARATOR ','),
   GROUP_CONCAT(categ.name SEPARATOR '_€.€_')
   FROM news
   LEFT JOIN categ
   ON categ.idcateg = news.idnews
   WHERE news.visible LIKE '%1%';


# Sélection de toutes les "news" (idnews, title, 220 caractères de content, publication), lien non obligatoire avec "categ" (idcateg,name => SONT résultats concaténés, idcateg avec une ",", name avec "_€.€_") AVEC user.iduser et user.login  LORSQUE "news.visible"=1 et "news.idnews"=1  le tout groupé par "n.idnews"
SELECT news.*, left(news.content,220),
GROUP_CONCAT(categ.idcateg SEPARATOR ','),
GROUP_CONCAT(categ.name SEPARATOR '_€.€_')
FROM news
LEFT JOIN categ
ON categ.idcateg = news.idnews;
    
# sélection de l'utilisateur admin grâce à son login et mot de passe, avec ses permissions

    
