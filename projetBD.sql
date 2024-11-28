-- Noms : Yann Gervais-Ricard & Wylliam Jalbert-Létourneau
-- Date de remise : 11-12-2024
-- Sujet : Projet final de BD
-- Matricules : (Yann) 1970628 & (Wylliam)

-- -----------------------------------------------------------------------

-- 3)  Création des tables

-- Client
CREATE TABLE Clients (
                         Id VARCHAR(100) DEFAULT 'Erreur' PRIMARY KEY,
                         nom VARCHAR(100) NOT NULL,
                         prenom VARCHAR(100) NOT NULL,
                         adresse TEXT NOT NULL,
                         date_naissance DATE NOT NULL,
                         age INT DEFAULT 0 NOT NULL
);

-- Activiter
CREATE TABLE Activites (
                           nom VARCHAR(100) PRIMARY KEY,
                           type VARCHAR(50) NOT NULL,
                           prix_organisation DECIMAL(10, 2) NOT NULL,
                           prix_clients DECIMAL(10, 2) NOT NULL
);

--  Séances
CREATE TABLE Seances (
                         Id INT AUTO_INCREMENT PRIMARY KEY,
                         date DATE NOT NULL,
                         heure TIME NOT NULL,
                         place_disponible INT NOT NULL,
                         place_maximum INT NOT NULL,
                         nom_activiter VARCHAR(100),
                         FOREIGN KEY (nom_activiter) REFERENCES Activites(nom)
                             ON DELETE SET NULL
                             ON UPDATE CASCADE
);

-- Inscription
CREATE TABLE Inscription (
                             Id INT AUTO_INCREMENT PRIMARY KEY,
                             id_clients VARCHAR(100) NOT NULL,
                             id_seance INT NOT NULL,
                             raiting INT,
                             FOREIGN KEY (id_clients) REFERENCES Clients(Id)
                                 ON DELETE CASCADE
                                 ON UPDATE CASCADE,
                             FOREIGN KEY (id_seance) REFERENCES Seances(Id)
                                 ON DELETE CASCADE
                                 ON UPDATE CASCADE
);


-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-**-*-*-*-*-*-*

-- -----------------------------------------------------------------------
-- 3) Déclencheurs



-- 3.1)  Créer un déclencheur qui permet de construire le numéro d’identification de
-- l’adhérent comme suit :
-- Le numéro d’identification est composé des initiales de l’adhérent, de son année de
-- naissance et d’un nombre aléatoire de 3 chiffres, le tout séparé par des tirets.
-- Exemple : une personne se nommant Alice Trudel née le 15 mai 2003 aura comme numéro
-- d’identification AT-2003-152

CREATE TRIGGER num_client_generator
    BEFORE INSERT ON clients
    FOR EACH ROW
    BEGIN
        SET NEW.Id = CONCAT(SUBSTRING(NEW.prenom,1,1),SUBSTRING(NEW.nom,1,1),'-',YEAR(NEW.date_naissance),'-', FLOOR(RAND()*(999-100+1)+100));
    END;

-- 3.2) Créer un déclencheur qui permet de gérer le nombre de places disponibles dans
-- chaque séance. À chaque fois, on ajoute un participant, le nombre de places incrémente

DELIMITER //

CREATE TRIGGER nombre_place_dispo_before_insert
BEFORE INSERT ON inscription
FOR EACH ROW
BEGIN

    IF (SELECT place_disponible FROM seances WHERE id_seance = NEW.id_seance) <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il ne reste plus de places disponibles pour cette séance.';
    ELSE
        UPDATE seances
        SET place_disponible = place_disponible - 1
        WHERE id_seance = NEW.id_seance;
    END IF;
END //

DELIMITER ;


-- 3.3) Créer un déclencheur qui permet d’insérer les participants dans une séance si le
-- nombre de places maximum n’est pas atteint. Sinon, il affiche un message d’erreur
-- avisant qu’il ne reste plus de places disponibles pour la séance choisie


DELIMITER //

CREATE TRIGGER verif_places_disponibles_before_insert
BEFORE INSERT ON inscription
FOR EACH ROW
BEGIN
    DECLARE nb_places_restantes INT;

    SELECT place_disponible INTO nb_places_restantes
    FROM seances
    WHERE id_seance = NEW.id_seance;

    IF nb_places_restantes <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur : Il ne reste plus de places disponibles pour cette séance.';
    END IF;
END //

DELIMITER ;



-- 3.4) Vous pouvez ajouter tout autre déclencheur que vous jugez pertinent pour le
-- fonctionnement de la BDD. Justifiez votre choix.

-- 1)
-- Pour mettre l'Age automatiquement (en se basant sur l'année de naissance)
CREATE TRIGGER age_client
    BEFORE INSERT ON Clients
    FOR EACH ROW
BEGIN
    SET NEW.age = FLOOR(DATEDIFF(CURDATE(),New.date_naissance) /365.25);
end;

-- 2) Mettre le nombre de place disponible = au nombre de place maxium, lorsqu'on crée une séance
CREATE TRIGGER place_dispo
    BEFORE INSERT ON Seances
    FOR EACH ROW
    BEGIN
        SET NEW.place_disponible = NEW.place_maximum;
    end;

-- -----------------------------------------------------------------------

-- 4) Insertion de données

-- Charger la base avec des données réalistes (chaque base devra comporter entre 50 et 100
-- occurrences) à partir des sites web fournis dans le cours (10 données par table à peu près),

-- CLIENTS
insert into Clients (nom, prenom, adresse, date_naissance) values ('Arel', 'Blind', '42739 Kipling Plaza', '2015-05-09');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Lacey', 'Grolmann', '298 Old Gate Place', '1969-03-09');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Caddric', 'Darnbrook', '22 Birchwood Alley', '2021-05-09');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Gonzales', 'Kippie', '166 Melrose Park', '1961-02-23');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Babara', 'Dilley', '25478 Holmberg Plaza', '2024-11-15');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Bertie', 'Theseira', '4 Ridgeview Street', '1945-03-22');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Abey', 'Woofinden', '97 Red Cloud Circle', '1968-11-17');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Miguel', 'Bastick', '10 Washington Hill', '1964-09-08');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Adler', 'Lamort', '49096 Talmadge Hill', '1962-08-03');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Chane', 'Millins', '4323 Sauthoff Avenue', '1981-06-19');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Vernor', 'L'' Anglois', '79 Butterfield Road', '1962-09-11');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Sayers', 'Tomasoni', '7771 Buhler Center', '1988-10-13');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Lombard', 'Tudgay', '2186 Mitchell Point', '1955-01-01');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Deeyn', 'Lipgens', '83074 Melrose Street', '1989-11-26');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Alvan', 'Mullaney', '38399 Ridge Oak Circle', '1945-04-26');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Townsend', 'Male', '350 Sunbrook Hill', '1978-02-19');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Verne', 'Snoden', '9 Bobwhite Pass', '1966-08-12');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Flori', 'Abisetti', '791 Arizona Avenue', '1984-03-04');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Cal', 'Skittrall', '18 Forest Plaza', '1972-03-14');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Gayelord', 'Latchmore', '345 Gateway Road', '2019-04-04');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Emmi', 'Robichon', '22 Pond Crossing', '2002-07-13');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Titus', 'Ormerod', '277 Barby Alley', '2013-04-06');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Arlie', 'St. Leger', '01 Magdeline Pass', '1963-05-06');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Aggi', 'Scoffham', '16 Colorado Avenue', '2000-12-31');
insert into Clients (nom, prenom, adresse, date_naissance) values ('Annmaria', 'Tutchell', '36 Farwell Drive', '1976-08-28');

-- activité

-- Inscription

-- seances


-- -----------------------------------------------------------------------

-- 5) Les vues

-- Toute la partie des statistiques doit être réalisés par des vues. Concevoir autant de vues
-- pour répondre aux statistiques suivants :


-- • Trouver le participant ayant le nombre de séances le plus élevé
CREATE VIEW participant_Plus_Grand_nb_Sceance AS
SELECT
    i.id_participant,
    CONCAT(p.nom, ' ', p.prenom) AS nom_complet,
    COUNT(i.id_seance) AS nb_seances
FROM inscription i JOIN participants p ON i.id_participant = p.id_participant
GROUP BY i.id_participant, p.nom, p.prenom
HAVING COUNT(i.id_seance) = (SELECT MAX(total_seances)
        FROM (
            SELECT COUNT(id_seance) AS total_seances
            FROM inscription
            GROUP BY id_participant
        ) AS sous_requete
    );


-- • Trouver le prix moyen par activité pour chaque participant
CREATE  VIEW prix_moyen_activité;

-- • Afficher les notes d’appréciation pour chaque activité
CREATE VIEW note_appreciation;

-- • Affiche la moyenne des notes d’appréciations pour toutes les activités
CREATE VIEW moyenne_note_activite;

-- • Afficher le nombre de participant pour chaque activité
CREATE VIEW nb_participant activité;

-- • Afficher le nombre de participant moyen pour chaque mois
CREATE VIEW nb_moyen_participant_par_mois;


-- -----------------------------------------------------------------------

-- 6) Procédures stockées :
-- • Faire des procédures stockées (au moins 5) pour automatiser certaines tâches à
-- effectuer pour votre application

-- 1)
CREATE PROCEDURE ;

-- 2)
CREATE PROCEDURE ;

-- 3)
CREATE PROCEDURE ;

-- 4)
CREATE PROCEDURE ;

-- 5)
CREATE PROCEDURE ;

-- -----------------------------------------------------------------------

-- 7) Fonctions stockées :
-- • Faire des fonctions stockées (au moins 5) pour automatiser certaines tâches à
-- effectuer pour votre application,

-- 1)
CREATE FUNCTION ;

-- 2)
CREATE FUNCTION ;

-- 3)
CREATE FUNCTION ;

-- 4)
CREATE FUNCTION ;

-- 5)
CREATE FUNCTION ;

-- -----------------------------------------------------------------------

-- 8) Gestion des erreurs :
-- • Afficher des messages d’erreurs pour gérer certains conflits dans la BDD (signal,
-- etc. voir dernier chapitre du cours). Utilisez au moins 3 codes d’erreurs différents.

-- 1)

-- 2)

-- 3)











