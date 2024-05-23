USE nhl;
CREATE TABLE BostonBruins (
    PlayerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(25),
    LastName VARCHAR(25),
    DateOfBirth DATE,
    Team VARCHAR(25),
    Country VARCHAR(25),
    Position VARCHAR(25),
    Salary DECIMAL(10, 2),
    DateExpiration DATE
);
Select * FROM BostonBruins;
INSERT INTO BostonBruins (FirstName, LastName, DateOfBirth, Team, Country, Position, Salary, DateExpiration)
VALUES ('David', 'Pastrnak', "1996-05-25", "Boston Bruins", "Czech Republic", "RW", 11250000, "2031-06-30"); 
INSERT INTO BostonBruins (FirstName, LastName, DateOfBirth, Team, Country, Position, Salary, DateExpiration)
VALUES 
('Brad', 'Marchand', "1988-05-11", "Boston Bruins", 'Canada', 'LW', 6125000, '2025-06-30'), 
('Charlie', 'Coyle', '1992-03-02', 'Boston Bruins', 'USA', 'C', 5250000, '2026-06-30'),
('Pavel', 'Zacha', '1997-04-06', 'Boston Bruins', "Czech Republic", 'C', 4750000, '2027-06-30'),
('Trent', 'Frederic', '1998-02-11', 'Boston Bruins', 'USA', 'LW', 2300000, '2025-06-30'),
('Morgan', 'Geekie', '1998-07-20', 'Boston Bruins', 'Canada', 'RW', 2000000, '2025-06-30'),
('John', 'Beecher', '2001-04-05', 'Boston Bruins', 'USA', 'C', 925000, '2025-06-30'), 
('Patrick', 'Brown', '1992-05-29', 'Boston Bruins', 'USA', 'C', 800000, '2025-06-30'),
('Jakub', 'Lauko', '2000-03-28', 'Boston Bruins', "Czech Republic", "RW", 787500, '2025-06-30'),
('Justin', 'Brazeau', '1998-02-02', 'Boston Bruins', 'Canada', 'RW', 775000, '2025-06-30');
Select * FROM BostonBruins;






