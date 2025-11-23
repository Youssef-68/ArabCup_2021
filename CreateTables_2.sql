/* 1) Create Basic Reference Tables */
CREATE TABLE Players (
    PlayerID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerName NVARCHAR(100)
);

CREATE TABLE Clubs (
    ClubID INT IDENTITY(1,1) PRIMARY KEY,
    ClubName NVARCHAR(100)
);

/* 2) Insert Data to Basic Tables */
INSERT INTO Players (PlayerName)
SELECT DISTINCT Player FROM Scorers WHERE Player IS NOT NULL
UNION
SELECT DISTINCT Player FROM Assists WHERE Player IS NOT NULL
UNION
SELECT DISTINCT Player FROM Games WHERE Player IS NOT NULL
UNION
SELECT DISTINCT Player FROM FairPlay WHERE Player IS NOT NULL;

INSERT INTO Clubs (ClubName)
SELECT DISTINCT Club FROM Scorers WHERE Club IS NOT NULL
UNION
SELECT DISTINCT Club FROM Assists WHERE Club IS NOT NULL
UNION
SELECT DISTINCT Club FROM Games WHERE Club IS NOT NULL
UNION
SELECT DISTINCT Club FROM FairPlay WHERE Club IS NOT NULL
UNION
SELECT DISTINCT Club FROM ClubsStats WHERE Club IS NOT NULL;

/* 3) Alter Tables and Add Relationships */
-- Scorers
ALTER TABLE Scorers ADD PlayerID INT, ClubID INT;
UPDATE Scorers SET PlayerID = p.PlayerID FROM Players p WHERE Scorers.Player = p.PlayerName;
UPDATE Scorers SET ClubID = c.ClubID FROM Clubs c WHERE Scorers.Club = c.ClubName;
ALTER TABLE Scorers DROP COLUMN Player, Club;

-- Assists
ALTER TABLE Assists ADD PlayerID INT, ClubID INT;
UPDATE Assists SET PlayerID = p.PlayerID FROM Players p WHERE Assists.Player = p.PlayerName;
UPDATE Assists SET ClubID = c.ClubID FROM Clubs c WHERE Assists.Club = c.ClubName;
ALTER TABLE Assists DROP COLUMN Player, Club;

-- Games
ALTER TABLE Games ADD PlayerID INT, ClubID INT;
UPDATE Games SET PlayerID = p.PlayerID FROM Players p WHERE Games.Player = p.PlayerName;
UPDATE Games SET ClubID = c.ClubID FROM Clubs c WHERE Games.Club = c.ClubName;
ALTER TABLE Games DROP COLUMN Player, Club;

-- CleanSheets
ALTER TABLE CleanSheets ADD PlayerID INT, ClubID INT;
UPDATE CleanSheets SET PlayerID = p.PlayerID FROM Players p WHERE CleanSheets.Player = p.PlayerName;
UPDATE CleanSheets SET ClubID = c.ClubID FROM Clubs c WHERE CleanSheets.Club = c.ClubName;
ALTER TABLE CleanSheets DROP COLUMN Player, Club;

-- FairPlay
ALTER TABLE FairPlay ADD PlayerID INT, ClubID INT;
UPDATE FairPlay SET PlayerID = p.PlayerID FROM Players p WHERE FairPlay.Player = p.PlayerName;
UPDATE FairPlay SET ClubID = c.ClubID FROM Clubs c WHERE FairPlay.Club = c.ClubName;
ALTER TABLE FairPlay DROP COLUMN Player, Club;

-- ClubsStats
ALTER TABLE ClubsStats ADD ClubID INT;
UPDATE ClubsStats SET ClubID = c.ClubID FROM Clubs c WHERE ClubsStats.Club = c.ClubName;
ALTER TABLE ClubsStats DROP COLUMN Club;

-- AgeStats
ALTER TABLE AgeStats ADD ClubID INT;
UPDATE AgeStats SET ClubID = c.ClubID FROM Clubs c WHERE AgeStats.Club = c.ClubName;
ALTER TABLE AgeStats DROP COLUMN Club;

/* 4) Add Foreign Key Constraints */
ALTER TABLE Scorers ADD CONSTRAINT FK_Scorers_Players FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID);
ALTER TABLE Scorers ADD CONSTRAINT FK_Scorers_Clubs FOREIGN KEY (ClubID) REFERENCES Clubs(ClubID);
ALTER TABLE Assists ADD CONSTRAINT FK_Assists_Players FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID);
ALTER TABLE Assists ADD CONSTRAINT FK_Assists_Clubs FOREIGN KEY (ClubID) REFERENCES Clubs(ClubID);
ALTER TABLE Games ADD CONSTRAINT FK_Games_Players FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID);
ALTER TABLE Games ADD CONSTRAINT FK_Games_Clubs FOREIGN KEY (ClubID) REFERENCES Clubs(ClubID);
ALTER TABLE CleanSheets ADD CONSTRAINT FK_CleanSheets_Players FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID);
ALTER TABLE CleanSheets ADD CONSTRAINT FK_CleanSheets_Clubs FOREIGN KEY (ClubID) REFERENCES Clubs(ClubID);
ALTER TABLE FairPlay ADD CONSTRAINT FK_FairPlay_Players FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID);
ALTER TABLE FairPlay ADD CONSTRAINT FK_FairPlay_Clubs FOREIGN KEY (ClubID) REFERENCES Clubs(ClubID);
ALTER TABLE ClubsStats ADD CONSTRAINT FK_ClubsStats_Clubs FOREIGN KEY (ClubID) REFERENCES Clubs(ClubID);
ALTER TABLE AgeStats ADD CONSTRAINT FK_AgeStats_Clubs FOREIGN KEY (ClubID) REFERENCES Clubs(ClubID);