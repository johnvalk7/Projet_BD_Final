-- Noms : Yann Gervais-Ricard & Wylliam Jalbert-Létourneau
-- Date de remise : 11-12-2024
-- Sujet : Projet final de BD
-- Matricules : (Yann) 1970628 & (Wylliam) 1286834

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
                         nom_activite VARCHAR(100),
                         FOREIGN KEY (nom_activite) REFERENCES Activites(nom)
                             ON DELETE SET NULL
                             ON UPDATE CASCADE
);

-- Inscription
CREATE TABLE Inscription (
                             Id INT AUTO_INCREMENT PRIMARY KEY,
                             id_clients VARCHAR(100) NOT NULL,
                             id_seance INT NOT NULL,
                             rating INT,
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
INSERT INTO Activites (nom, type, prix_organisation, prix_clients) VALUES
('Cours de Zumba', 'Fitness', 5.00, 12.00),
('Atelier de Sculpture sur Bois', 'Artisanat', 8.00, 18.00),
('Tournoi de Badminton', 'Sport', 4.00, 10.00),
('Initiation au Théâtre', 'Culture', 7.50, 15.00),
('Atelier de Bricolage', 'Créatif', 6.00, 14.00),
('Soirée Karaoké', 'Divertissement', 4.50, 10.00),
('Cours de Skateboard', 'Sport', 7.00, 15.00),
('Atelier de Fabrication de Bijoux', 'Artisanat', 5.50, 12.00),
('Tournoi de Jeu Vidéo', 'Techno', 6.00, 13.00),
('Club de Modélisme', 'Créatif', 5.00, 11.00),
('Atelier de Dessin Manga', 'Art', 6.50, 14.00),
('Randonnée Guidée', 'Outdoor', 4.50, 10.00),
('Cours d’Escalade', 'Sport', 8.00, 18.00),
('Tournoi de Foot en Salle', 'Sport', 5.50, 12.00),
('Atelier Photo', 'Techno', 7.00, 16.00);

-- seances
INSERT INTO Seances (date, heure, place_disponible, place_maximum, nom_activite) VALUES
('2024-12-01', '10:00:00', 12, 20, 'Cours de Zumba'),
('2024-12-01', '15:00:00', 10, 20, 'Cours de Zumba'),
('2024-12-01', '18:30:00', 8, 20, 'Cours de Zumba'),
('2024-12-02', '14:00:00', 7, 10, 'Atelier de Sculpture sur Bois'),
('2024-12-02', '18:00:00', 5, 10, 'Atelier de Sculpture sur Bois'),
('2024-12-03', '09:30:00', 6, 12, 'Tournoi de Badminton'),
('2024-12-03', '17:00:00', 8, 12, 'Tournoi de Badminton'),
('2024-12-04', '13:00:00', 6, 12, 'Initiation au Théâtre'),
('2024-12-04', '19:00:00', 4, 12, 'Initiation au Théâtre'),
('2024-12-05', '10:30:00', 8, 10, 'Atelier de Bricolage'),
('2024-12-05', '15:30:00', 6, 10, 'Atelier de Bricolage'),
('2024-12-06', '19:00:00', 10, 15, 'Soirée Karaoké'),
('2024-12-07', '09:30:00', 8, 12, 'Cours de Skateboard'),
('2024-12-07', '14:30:00', 10, 12, 'Cours de Skateboard'),
('2024-12-08', '10:00:00', 6, 8, 'Atelier de Fabrication de Bijoux'),
('2024-12-08', '15:00:00', 5, 8, 'Atelier de Fabrication de Bijoux'),
('2024-12-09', '18:30:00', 12, 20, 'Tournoi de Jeu Vidéo'),
('2024-12-10', '11:00:00', 10, 15, 'Club de Modélisme'),
('2024-12-10', '16:00:00', 7, 15, 'Club de Modélisme'),
('2024-12-11', '10:00:00', 6, 10, 'Atelier de Dessin Manga'),
('2024-12-11', '14:00:00', 8, 10, 'Atelier de Dessin Manga'),
('2024-12-12', '09:30:00', 20, 25, 'Randonnée Guidée'),
('2024-12-13', '09:00:00', 8, 15, 'Cours d’Escalade'),
('2024-12-13', '13:30:00', 10, 15, 'Cours d’Escalade'),
('2024-12-14', '10:00:00', 10, 12, 'Tournoi de Foot en Salle'),
('2024-12-14', '18:00:00', 6, 12, 'Tournoi de Foot en Salle'),
('2024-12-15', '09:00:00', 5, 10, 'Atelier Photo'),
('2024-12-15', '15:00:00', 5, 10, 'Atelier Photo');

-- Inscription
INSERT INTO Inscription (id_clients, id_seance, rating) VALUES
('AF-1984-668', 1, 4),
('BA-2015-553', 2, 3),
('BM-1964-805', 3, 5),
('DB-2024-382', 4, 4),
('DC-2021-424', 5, 3),
('GL-1969-977', 6, 1),
('KG-1961-891', 7, 5),
('LA-1962-795', 8, 5),
('LD-1989-241', 9, 3),
('LG-2019-500', 10, 4),
('LV-1962-317', 11, 2),
('MA-1945-896', 12, 5),
('MC-1981-560', 13, 4),
('MT-1978-955', 14, 2),
('OT-2013-794', 15, 3),
('RE-2002-659', 1, 4),
('SA-1963-995', 2, 5),
('SA-2000-694', 3, 3),
('SC-1972-881', 4, 4),
('SV-1966-186', 5, 1),
('TA-1976-383', 6, 4),
('TB-1945-938', 7, 5),
('TL-1955-671', 8, 3),
('TS-1988-704', 9, 4),
('WA-1968-744', 10, 1);


-- -----------------------------------------------------------------------

-- 5) Les vues

-- Toute la partie des statistiques doit être réalisés par des vues. Concevoir autant de vues
-- pour répondre aux statistiques suivants :


-- • Trouver le participant ayant le nombre de séances le plus élevé
CREATE VIEW participant_Plus_Grand_nb_Sceance AS
SELECT
    i.id_clients AS id_participant,
    CONCAT(c.nom, ' ', c.prenom) AS nom_complet,
    COUNT(i.id_seance) AS nb_seances
FROM Inscription i
JOIN Clients c ON i.id_clients = c.Id
GROUP BY i.id_clients, c.nom, c.prenom
HAVING COUNT(i.id_seance) = (
    SELECT MAX(total_seances)
    FROM (
        SELECT COUNT(id_seance) AS total_seances
        FROM Inscription
        GROUP BY id_clients
    ) AS sous_requete
);

-- • Trouver le prix moyen par activité pour chaque participant
CREATE VIEW prix_moyen_activite AS
SELECT
    i.id_clients AS id_participant,
    CONCAT(c.nom, ' ', c.prenom) AS nom_complet,
    s.nom_activite,
    AVG(a.prix_clients) AS prix_moyen
FROM Inscription i
JOIN Seances s ON i.id_seance = s.Id
JOIN Activites a ON s.nom_activite = a.nom
JOIN Clients c ON i.id_clients = c.Id
GROUP BY i.id_clients, c.nom, c.prenom, s.nom_activite;


-- • Afficher les notes d’appréciation pour chaque activité
CREATE VIEW note_appreciation AS
SELECT
    a.nom AS nom_activite,
    s.Id AS id_seance,
    CONCAT(c.nom, ' ', c.prenom) AS participant,
    i.rating AS note_appreciation
FROM Inscription i
JOIN Seances s ON i.id_seance = s.Id
JOIN Activites a ON s.nom_activite = a.nom
JOIN Clients c ON i.id_clients = c.Id
WHERE i.rating IS NOT NULL;

-- • Affiche la moyenne des notes d’appréciations pour toutes les activités
CREATE VIEW moyenne_note_activite AS
SELECT
    a.nom AS nom_activite,
    AVG(i.rating) AS moyenne_note
FROM Inscription i
JOIN Seances s ON i.id_seance = s.Id
JOIN Activites a ON s.nom_activite = a.nom
WHERE i.rating IS NOT NULL
GROUP BY a.nom;

-- • Afficher le nombre de participant pour chaque activité
CREATE VIEW nb_participant_activite AS
SELECT
    a.nom AS nom_activite,
    COUNT(DISTINCT i.id_clients) AS nombre_participants
FROM Inscription i
JOIN Seances s ON i.id_seance = s.Id
JOIN Activites a ON s.nom_activite = a.nom
GROUP BY a.nom;

-- • Afficher le nombre de participant moyen pour chaque mois
CREATE VIEW nb_moyen_participant_par_mois AS
SELECT
    MONTH(participants_par_seance.date) AS mois,
    YEAR(participants_par_seance.date) AS annee,
    AVG(participants_par_seance.nb_participants) AS nb_moyen_participants
FROM (
    SELECT
        s.Id AS id_seance,
        COUNT(DISTINCT i.id_clients) AS nb_participants,
        s.date
    FROM Inscription i
    JOIN Seances s ON i.id_seance = s.Id
    GROUP BY s.Id, s.date
) AS participants_par_seance
GROUP BY YEAR(participants_par_seance.date), MONTH(participants_par_seance.date)
ORDER BY annee, mois;


-- -----------------------------------------------------------------------

-- 6) Procédures stockées :
-- • Faire des procédures stockées (au moins 5) pour automatiser certaines tâches à
-- effectuer pour votre application

-- 1)
DELIMITER //
CREATE FUNCTION SeancesPopulaires(note_min DECIMAL(3, 2))
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE result TEXT;


    SET result = '';

    -- stocker dans la variable result
    SELECT GROUP_CONCAT(DISTINCT CONCAT(nom_activite, ' (Note : ', avg_rating, ')') SEPARATOR ', ')
    INTO result
    FROM (
        SELECT nom_activite, AVG(rating) AS avg_rating
        FROM Seances
        JOIN Inscription ON Seances.Id = Inscription.id_seance
        GROUP BY nom_activite
        HAVING avg_rating >= note_min
    ) AS subquery;


    RETURN result;
END;
//
DELIMITER ;

-- 2) Ajouter un participant à une séance

DELIMITER //

CREATE PROCEDURE ajouter_participant_seance(
    IN id_client VARCHAR(100),
    IN id_seance INT
)
BEGIN
    -- Ajouter le participant à la séance
    INSERT INTO Inscription (id_clients, id_seance)
    VALUES (id_client, id_seance);

    SELECT 'Participant ajouté avec succès.' AS message;
END //

DELIMITER ;

-- 3) Supprimer un participant d'une seance
DELIMITER //

CREATE PROCEDURE supprimer_participant_seance(
    IN id_client VARCHAR(100),
    IN id_seance INT
)
BEGIN
    -- Supprimer l'inscription du participant
    DELETE FROM Inscription
    WHERE id_clients = id_client AND id_seance = id_seance;

    -- Mettre à jour le nombre de places disponibles
    UPDATE Seances
    SET place_disponible = place_disponible + 1
    WHERE Id = id_seance;

    SELECT 'Participant supprimé avec succès.' AS message;
END //

DELIMITER ;

-- 4) Créer une nouvelle séance pour une activité donnée
DELIMITER //

CREATE PROCEDURE creer_seance(
    IN date_seance DATE,
    IN heure_seance TIME,
    IN nom_activite VARCHAR(100),
    IN place_maximum INT
)
BEGIN
    DECLARE place_disponible INT;

    -- Définir le nombre de places disponibles
    SET place_disponible = place_maximum;

    -- Insérer la nouvelle séance
    INSERT INTO Seances (date, heure, place_disponible, place_maximum, nom_activite)
    VALUES (date_seance, heure_seance, place_disponible, place_maximum, nom_activite);

    SELECT 'Séance créée avec succès.' AS message;
END //

DELIMITER ;

-- 5) Calculer le revenu généré par une activité
DELIMITER //

CREATE PROCEDURE calculer_revenu_activite(
    IN nom_activite VARCHAR(100)
)
BEGIN
    DECLARE revenu DECIMAL(10, 2);

    -- Calculer le revenu pour l'activité donnée
    SELECT SUM(a.prix_clients) INTO revenu
    FROM Inscription i
    JOIN Seances s ON i.id_seance = s.Id
    JOIN Activites a ON s.nom_activite = a.nom
    WHERE a.nom = nom_activite;

    IF revenu IS NULL THEN
        SET revenu = 0;
    END IF;

    SELECT CONCAT('Revenu total généré par l\'activité ', nom_activite, ' : ', revenu) AS message;
END //
DELIMITER ;


-- 6) 
      DELIMITER //

CREATE PROCEDURE mettre_a_jour_adresse_participant(
    IN id_client VARCHAR(100),
    IN nouvelle_adresse TEXT
)
BEGIN
    -- Mettre à jour l'adresse du participant
    UPDATE Clients
    SET adresse = nouvelle_adresse
    WHERE Id = id_client;

    SELECT 'Adresse mise à jour avec succès.' AS message;
END //

DELIMITER ;

-- -----------------------------------------------------------------------

-- 7) Fonctions stockées :
-- • Faire des fonctions stockées (au moins 5) pour automatiser certaines tâches à
-- effectuer pour votre application,

-- 1)
-- function pour afficher un string des activiter qui on une moyenne de note surperieur a L'input
-- la function prend un decimal en paramettre qui est le minimum de la note moyenne voulue.
DELIMITER //
CREATE FUNCTION SeancesPopulaires(note_min DECIMAL(3, 2))
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE result TEXT;


    SET result = '';

    -- stocker dans la variable result
    SELECT GROUP_CONCAT(DISTINCT CONCAT(nom_activite, ' (Note : ', avg_rating, ')') SEPARATOR ', ')
    INTO result
    FROM (
        SELECT nom_activite, AVG(rating) AS avg_rating
        FROM Seances
        JOIN Inscription ON Seances.Id = Inscription.id_seance
        GROUP BY nom_activite
        HAVING avg_rating >= note_min
    ) AS subquery;


    RETURN result;
END;
//
DELIMITER ;

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

-- 1) 45000 à été utilisé dans un trigger

-- 2)

-- 3)











