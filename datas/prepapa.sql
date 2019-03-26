/* tables utilisateurs */
SELECT * FROM article;
SELECT * FROM categorie;
SELECT * FROM permission;
SELECT * FROM user;
SELECT * FROM user WHERE iduser=2;
SELECT * FROM images;
/* table de jointure many2many */
SELECT * FROM categorie_has_article;

/* 
one to one en partant de user, normalement un user 
doit avoir une image unique
Jointure interne : INNER JOIN
  */
SELECT user.thelogin, images.theurl
	FROM user
		INNER JOIN images
        ON images.user_iduser = user.iduser;
/* one to one en partant de images, normalement une 
image est liée à utilisateur unique  */
SELECT user.thelogin, images.theurl   
	FROM images
		INNER JOIN user
        ON images.user_iduser = user.iduser;

/*
many to one -> un user ne peut avoir qu'une seule permission
mais doit en avoir une
Jointure interne : INNER JOIN entre user et permission
*/
SELECT user.thelogin, images.theurl, permission.thename
	FROM user
		INNER JOIN permission
        ON permission.idpermission = user.permission_idpermission
		INNER JOIN images
        ON images.user_iduser = user.iduser
        ;
/*
many to one -> un user ne peut avoir qu'une seule permission
mais doit en avoir une
Jointure externe : RIGHT JOIN entre user et permission est
contrecarrée par le INNER JOIN qui VEUT obligatoirement
une image pour l'utilisateur
*/
SELECT user.thelogin, images.theurl, permission.thename
	FROM user
		RIGHT JOIN permission
        ON permission.idpermission = user.permission_idpermission
		INNER JOIN images
        ON images.user_iduser = user.iduser
        ;
/*
many to one -> un user ne peut avoir qu'une seule permission
mais doit en avoir une
Jointure externe : RIGHT JOIN entre user et permission est
acceptée car par le LEFT JOIN entre user et images permet
de prendre les utilisateurs sans images
*/
SELECT user.thelogin, images.theurl, permission.thename
	FROM user
		RIGHT JOIN permission
        ON permission.idpermission = user.permission_idpermission
		LEFT JOIN images
        ON images.user_iduser = user.iduser
        ;

/*
many to one entre article et user
JOINTURE interne car un article a toujours un auteur
*/
SELECT a.thetitle, u.thename 
	FROM article a
	INNER JOIN user u 
		ON a.user_iduser = u.iduser
    ;
/*
many to one entre article et user
JOINTURE externe RIGHT JOIN pour afficher tous les utilisateurs
*/
SELECT a.thetitle, u.thename 
	FROM article a
	RIGHT JOIN user u 
		ON a.user_iduser = u.iduser
    ;  
    
/*
many to one entre article et user
JOINTURE interne car un article a toujours un auteur
many to one entre user et permission
JOINTURE interne car un auteur a toujours une permission
*/
SELECT a.thetitle, u.thename, p.thename AS qualite 
	FROM article a
	INNER JOIN user u 
		ON a.user_iduser = u.iduser
    INNER JOIN permission p
		ON u.permission_idpermission = p.idpermission
		
    ;
    
/*
many to one entre article et user
JOINTURE interne car un article a toujours un auteur
many to one entre user et permission
JOINTURE interne car un auteur a toujours une permission

Many to many
On veut récupérer toutes les rubriques où sont contenus
les articles, en gardant les articles qui n'ont pas 
de catégories:
JOINTURE externe de type LEFT (par rapport à la 
table du FROM), on utilise en many to many le même mot
clef pour les 2 jointures (LEFT - LEFT, RIGHT - RIGHT, INNER - INNER) 

*/
SELECT a.thetitle, u.thename, 
	   p.thename AS qualite, c.thetitle AS categorieName
       
	FROM article a
    
    LEFT JOIN categorie_has_article h 
		ON h.article_idarticle = a.idarticle
    LEFT JOIN categorie c 
		ON h.categorie_idcategorie = c.idcategorie
    
	INNER JOIN user u 
		ON a.user_iduser = u.iduser
    INNER JOIN permission p
		ON u.permission_idpermission = p.idpermission
		
    ;   
    
    
/*
many to one entre article et user
JOINTURE interne car un article a toujours un auteur
many to one entre user et permission
JOINTURE interne car un auteur a toujours une permission

Many to many
On veut récupérer toutes les rubriques où sont contenus
les articles, en gardant les articles qui n'ont pas 
de catégories:
JOINTURE externe de type LEFT (par rapport à la 
table du FROM), on utilise en many to many le même mot
clef pour les 2 jointures (LEFT - LEFT, RIGHT - RIGHT, INNER - INNER) 

utilisation du group by pour éviter d'avoir les articles
autant de X qu'ils sont dans une catégorie. Généralement
on fait le group by sur la clef primaire.

Pour ne pas perdre l'information de catégorie, on doit utiliser
le group_concat()

*/
SELECT a.thetitle, u.thename, 
	   p.thename AS qualite, 
       GROUP_CONCAT(c.idcategorie) AS categorieId,
       GROUP_CONCAT(c.thetitle SEPARATOR'-|-|-') AS categorieName 
	FROM article a
    
    LEFT JOIN categorie_has_article h 
		ON h.article_idarticle = a.idarticle
    LEFT JOIN categorie c 
		ON h.categorie_idcategorie = c.idcategorie
    
	INNER JOIN user u 
		ON a.user_iduser = u.iduser
    INNER JOIN permission p
		ON u.permission_idpermission = p.idpermission
		
	GROUP BY a.idarticle
    ; 
    
/*
On veut ordonner les catégories par ordre alphabétique ascendant, si on le fait
seulement pour categorieName, les categorieId ne correspondent plus et on
a un gros problème de structure et d'affichage.
On doit appliquer le order by sur tous les champs venant de la même table

*/
SELECT a.thetitle, u.thename, 
	   p.thename AS qualite, 
       GROUP_CONCAT(c.idcategorie ORDER BY c.thetitle ASC ) AS categorieId,
       GROUP_CONCAT(c.thetitle ORDER BY c.thetitle ASC SEPARATOR'-|-|-' ) AS categorieName 
	FROM article a
    
    LEFT JOIN categorie_has_article h 
		ON h.article_idarticle = a.idarticle
    LEFT JOIN categorie c 
		ON h.categorie_idcategorie = c.idcategorie
    
	INNER JOIN user u 
		ON a.user_iduser = u.iduser
    INNER JOIN permission p
		ON u.permission_idpermission = p.idpermission
		
	GROUP BY a.idarticle
    ; 
    
 /*
On veut garder les articles qui ont la syllabe "le" dans leur titre ou leur texte
*/
SELECT a.thetitle, u.thename, 
	   p.thename AS qualite, 
       GROUP_CONCAT(c.idcategorie ORDER BY c.thetitle ASC ) AS categorieId,
       GROUP_CONCAT(c.thetitle ORDER BY c.thetitle ASC SEPARATOR'-|-|-' ) AS categorieName 
	FROM article a
    
    LEFT JOIN categorie_has_article h 
		ON h.article_idarticle = a.idarticle
    LEFT JOIN categorie c 
		ON h.categorie_idcategorie = c.idcategorie
    
	INNER JOIN user u 
		ON a.user_iduser = u.iduser
    INNER JOIN permission p
		ON u.permission_idpermission = p.idpermission
        
	WHERE a.thetitle LIKE '%le%' OR a.thetext LIKE '%le%'
	
	GROUP BY a.idarticle
    ;   
    
 /*
On veut également obtenir 350 caractères du texte de chaque article, on peut
utiliser left(nomDeChamps,350) ou substr(a.thetext,1,350) ou substring etc...
*/
SELECT a.thetitle, substr(a.thetext,3,350) AS thetext,
	   u.thename, 
	   p.thename AS qualite, 
       GROUP_CONCAT(c.idcategorie ORDER BY c.thetitle ASC ) AS categorieId,
       GROUP_CONCAT(c.thetitle ORDER BY c.thetitle ASC SEPARATOR'-|-|-' ) AS categorieName 
	FROM article a
    
    LEFT JOIN categorie_has_article h 
		ON h.article_idarticle = a.idarticle
    LEFT JOIN categorie c 
		ON h.categorie_idcategorie = c.idcategorie
    
	INNER JOIN user u 
		ON a.user_iduser = u.iduser
    INNER JOIN permission p
		ON u.permission_idpermission = p.idpermission
        
	WHERE a.thetitle LIKE '%le%' OR a.thetext LIKE '%le%'
	
	GROUP BY a.idarticle
    ; 
    
/*
On veut également récupérer l'id de l'article et l'id de son auteur
*/
SELECT a.idarticle, a.thetitle, substr(a.thetext,3,350) AS thetext,
	   u.iduser, u.thename, 
	   p.thename AS qualite, 
       GROUP_CONCAT(c.idcategorie ORDER BY c.thetitle ASC ) AS categorieId,
       GROUP_CONCAT(c.thetitle ORDER BY c.thetitle ASC SEPARATOR'-|-|-' ) AS categorieName 
	FROM article a
    
    LEFT JOIN categorie_has_article h 
		ON h.article_idarticle = a.idarticle
    LEFT JOIN categorie c 
		ON h.categorie_idcategorie = c.idcategorie
    
	INNER JOIN user u 
		ON a.user_iduser = u.iduser
    INNER JOIN permission p
		ON u.permission_idpermission = p.idpermission
        
	WHERE a.thetitle LIKE '%le%' OR a.thetext LIKE '%le%'
	
	GROUP BY a.idarticle
    ;    
    
/*
On veut également récupérer les images des utilisateurs, mais on garde les articles
actuels, même si les auteurs n'ont pas d'image
*/
SELECT a.idarticle, a.thetitle, substr(a.thetext,1,350) AS thetext,
	   u.iduser, u.thename, 
       i.theurl,
	   p.thename AS qualite, 
       GROUP_CONCAT(c.idcategorie ORDER BY c.thetitle ASC ) AS categorieId,
       GROUP_CONCAT(c.thetitle ORDER BY c.thetitle ASC SEPARATOR'-|-|-' ) AS categorieName 
	FROM article a
    
    LEFT JOIN categorie_has_article h 
		ON h.article_idarticle = a.idarticle
    LEFT JOIN categorie c 
		ON h.categorie_idcategorie = c.idcategorie
    
	INNER JOIN user u 
		ON a.user_iduser = u.iduser
    INNER JOIN permission p
		ON u.permission_idpermission = p.idpermission
    LEFT JOIN images i    
		ON i.user_iduser = u.iduser
        
	WHERE a.thetitle LIKE '%le%' OR a.thetext LIKE '%le%'
	
	GROUP BY a.idarticle
    ;   

/*
On veut séléctioner le 'thelogin' de tous les 'user', en sélectionnant
aussi 'theurl' de la table 'images' si il y en a une, en sélectionnant
aussi 'thename' de la table 'permission'.
*/
<<<<<<< HEAD
SELECT user.thelogin, images.theurl, permission.thename, 
GROUP_CONTACT(article.idarticle) AS idarticle, GROUP_CONTACT(article.thetitle SEPARATOR'|||') AS thetitle
FROM user
LEFT JOIN images ON user.iduser = images.user_iduser
INNER JOIN permission ON user.permission_idpermission = permission.idpermission
LEFT JOIN article on article.user_iduser = user.iduser
GROUP BY user.iduser;
=======
SELECT u.thelogin, i.theurl, p.thename
	FROM user u 
    LEFT JOIN images i 
		ON u.iduser = i.user_iduser
    INNER JOIN permission p 
		ON p.idpermission = u.permission_idpermission;
>>>>>>> 0074fa90c0ad6e91d51f5df73ffec2b884824328


/*
On va rajouter le champs 'idarticle' et 'thetitle' pour chaque auteur, 
en gardant une ligne par 'user', on garde l''user' même si il n'a pas d'article
*/
SELECT u.thelogin, i.theurl, p.thename,
	GROUP_CONCAT(a.idarticle) AS idarticle, GROUP_CONCAT(a.thetitle SEPARATOR'|||') AS thetitle
	FROM user u 
    LEFT JOIN images i 
		ON u.iduser = i.user_iduser
    INNER JOIN permission p 
		ON p.idpermission = u.permission_idpermission
    LEFT JOIN article a 
		ON a.user_iduser = u.iduser
    GROUP BY u.iduser    
        ;
/*
Jointure affichant toutes les catégories, avec toutes les tables
*/
SELECT categorie.idcategorie,categorie.thetitle, 
	   GROUP_CONCAT(article.idarticle) AS idarticle, 
       GROUP_CONCAT(article.thetitle SEPARATOR '|||') AS articleTitle,
       GROUP_CONCAT(user.iduser) AS iduser, GROUP_CONCAT(user.thelogin SEPARATOR'|||') AS thelogin,
       GROUP_CONCAT(permission.idpermission) AS idpermission, GROUP_CONCAT(permission.thename SEPARATOR'|||') AS thenamePerm,
       GROUP_CONCAT(images.theurl SEPARATOR'|||') AS theurl
       
FROM categorie
	LEFT JOIN categorie_has_article
		ON categorie.idcategorie = categorie_has_article.categorie_idcategorie
    LEFT JOIN article
		ON article.idarticle = categorie_has_article.article_idarticle
    LEFT JOIN user    
		ON user.iduser = article.user_iduser
    LEFT JOIN permission
		ON user.permission_idpermission = permission.idpermission
    LEFT JOIN images
		ON user.iduser = images.user_iduser
GROUP BY categorie.idcategorie        
    ;
    