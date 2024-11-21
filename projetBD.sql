-- Noms : Yann Gervais-Ricard & Wylliam Jalbert-Létourneau
-- Date de remise :
-- Sujet : Projet final de BD
-- Matricules : (Yann) 1970628 & (Wylliam)

-- -----------------------------------------------------------------------


-- 3)  Création des tables

-- TEST Pour l'instant (À modifier) : -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-**-*-*-*-*-*-*

CREATE TABLE activites (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL ,
    nom VARCHAR(64) NOT NULL ,
    type VARCHAR(64),
    prix_organisation DOUBLE,
    prix_vente DOUBLE

);

CREATE TABLE adherents (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL ,
    identification VARCHAR(11) UNIQUE,  -- INitiale + "-" + année + "-" +
    nom VARCHAR(64) NOT NULL ,
    prenom VARCHAR(64) NOT NULL ,
    adresse VARCHAR(128) NOT NULL ,
    date_naissance DATE NOT NULL ,
    seance_id INT,
    age INT CHECK ( age >=18 ),
    FOREIGN KEY (seance_id) REFERENCES
);

CREATE TABLE seance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(64),
    date DATE,
    heure_organisation VARCHAR(20)
);

CREATE TABLE administrateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(64)
);

CREATE TABLE compte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(128),
    acces INT
);





-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-**-*-*-*-*-*-*



-- -----------------------------------------------------------------------
-- 3) Déclancheurs

-- 3.1)  Créer un déclencheur qui permet de construire le numéro d’identification de
-- l’adhérent comme suit :
-- Le numéro d’identification est composé des initiales de l’adhérent, de son année de
-- naissance et d’un nombre aléatoire de 3 chiffres, le tout séparé par des tirets.
-- Exemple : une personne se nommant Alice Trudel née le 15 mai 2003 aura comme numéro
-- d’identification AT-2003-152


-- 3.2) Créer un déclencheur qui permet de gérer le nombre de places disponibles dans
-- chaque séance. À chaque fois, on ajoute un participant, le nombre de places incrémente

-- 3.3) Créer un déclencheur qui permet d’insérer les participants dans une séance si le
-- nombre de places maximum n’est pas atteint. Sinon, il affiche un message d’erreur
-- avisant qu’il ne reste plus de places disponibles pour la séance choisie

-- 3.4) Vous pouvez ajouter tout autre déclencheur que vous jugez pertinent pour le
-- fonctionnement de la BDD. Justifiez votre choix.

-- -----------------------------------------------------------------------

-- 4) Insertion de données

-- Charger la base avec des données réalistes (chaque base devra comporter entre 50 et 100
-- occurrences) à partir des sites web fournis dans le cours (10 données par table à peu près),

-- -----------------------------------------------------------------------

-- 5) Les vues

-- Toute la partie des statistiques doit être réalisés par des vues. Concevoir autant de vues
-- pour répondre aux statistiques suivants :
-- • Trouver le participant ayant le nombre de séances le plus élevé
-- • Trouver le prix moyen par activité pour chaque participant
-- • Afficher les notes d’appréciation pour chaque activité
-- • Affiche la moyenne des notes d’appréciations pour toutes les activités
-- • Afficher le nombre de participant pour chaque activité
-- • Afficher le nombre de participant moyen pour chaque mois

-- -----------------------------------------------------------------------

-- 6) Procédures stockées :
-- • Faire des procédures stockées (au moins 5) pour automatiser certaines tâches à
-- effectuer pour votre application

-- -----------------------------------------------------------------------

-- 7) Fonctions stockées :
-- • Faire des fonctions stockées (au moins 5) pour automatiser certaines tâches à
-- effectuer pour votre application,

-- -----------------------------------------------------------------------

-- 8) Gestion des erreurs :
-- • Afficher des messages d’erreurs pour gérer certains conflits dans la BDD (signal,
-- etc. voir dernier chapitre du cours). Utilisez au moins 3 codes d’erreurs différents.











