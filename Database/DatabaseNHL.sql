USE nhl;

-- CREATE FRANCHISE TABLE
CREATE TABLE franchises (
    franchise_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    city VARCHAR(25) NOT NULL,
    state VARCHAR(30),
    country VARCHAR(20) NOT NULL, 
    Salary_Cap DECIMAL(15, 2), 
    conference ENUM('Est', 'West'),
    division ENUM('Atlantic', 'Metropolitan', 'Central', 'Pacific')
);

-- CREATE PLAYERS TABLE
CREATE TABLE players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    date_of_birth DATE NOT NULL,
    age INT,
    position ENUM('F', 'W', 'D', 'G') NOT NULL,
    contract_end_date DATE,
    contract_value DECIMAL(15, 2),
    free_agent_status ENUM('UFA', 'RFA') DEFAULT NULL,
    franchise_id INT,
    FOREIGN KEY (franchise_id) REFERENCES franchises(franchise_id)
);

-- CREATE BUYOUT TABLE
CREATE TABLE buyout (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    buyout_end_date DATE,
    buyout_value DECIMAL(15, 2),
    franchise_id INT,
    FOREIGN KEY (franchise_id) REFERENCES franchises(franchise_id)
);

-- INSERT FRANCHISE INFORMATION
INSERT INTO franchises (name, city, state, country, conference, division) VALUES 
('Boston Bruins', 'Boston', 'MA', 'USA', 'Est', 'Atlantic'), 
('Toronto Maple Leafs', 'Toronto', 'ON', 'Canada', 'Est', 'Atlantic'), 
('Montreal Canadiens', 'Montreal', 'QC', 'Canada', 'Est', 'Atlantic'), 
('Buffalo Sabres', 'Buffalo', 'NY', 'USA', 'Est', 'Atlantic'), 
('Detroit Red Wings', 'Detroit', 'MI', 'USA', 'Est', 'Atlantic'), 
('Florida Panthers', 'Sunrise', 'FL', 'USA', 'Est', 'Atlantic'), 
('Ottawa Senators', 'Ottawa', 'ON', 'Canada', 'Est', 'Atlantic'), 
('Tampa Bay Lightning', 'Tampa', 'FL', 'USA', 'Est', 'Atlantic'), 
('Carolina Hurricanes', 'Raleigh', 'NC', 'USA', 'Est', 'Metropolitan'), 
('Columbus Blue Jackets', 'Columbus','OH', 'USA', 'Est', 'Metropolitan'), 
('New Jersey Devils', 'Newark', 'NJ', 'USA', 'Est', 'Metropolitan'), 
('New York Islanders', 'Uniondale', 'NY', 'USA', 'Est', 'Metropolitan'), 
('New York Rangers', 'New York', 'NY', 'USA', 'Est', 'Metropolitan'), 
('Philadelphia Flyers', 'Philadelphia', 'PA', 'USA', 'Est', 'Metropolitan'), 
('Pittsburgh Penguins', 'Pittsburgh', 'PA', 'USA', 'Est', 'Metropolitan'), 
('Washington Capitals', 'Washington', 'DC', 'USA', 'Est', 'Metropolitan');

INSERT INTO franchises (name, city, state, country, conference, division) VALUES 
('Chicago Blackhawks', 'Chicago', 'IL', 'USA', 'West', 'Central'), 
('Colorado Avalanche', 'Denver', 'CO', 'USA', 'West', 'Central'), 
('Dallas Stars', 'Dallas', 'TX', 'USA', 'West', 'Central'), 
('Minnesota Wild', 'Saint Paul', 'MN', 'USA', 'West', 'Central'), 
('Nashville Predators', 'Nashville', 'TN', 'USA', 'West', 'Central'), 
('St. Louis Blues', 'St. Louis', 'MO', 'USA', 'West', 'Central'), 
('Winnipeg Jets', 'Winnipeg', 'MB', 'Canada', 'West', 'Central'), 
('Anaheim Ducks', 'Anaheim', 'CA', 'USA', 'West', 'Pacific'), 
('Arizona Coyotes', 'Glendale', 'AZ', 'USA', 'West', 'Pacific'), 
('Calgary Flames', 'Calgary', 'AB', 'Canada', 'West', 'Pacific'), 
('Edmonton Oilers', 'Edmonton', 'AB', 'Canada', 'West', 'Pacific'), 
('Los Angeles Kings', 'Los Angeles', 'CA', 'USA', 'West', 'Pacific'), 
('San Jose Sharks', 'San Jose', 'CA', 'USA', 'West', 'Pacific'), 
('Seattle Kraken', 'Seattle', 'WA', 'USA', 'West', 'Pacific'), 
('Vancouver Canucks', 'Vancouver', 'BC', 'Canada', 'West', 'Pacific'), 
('Vegas Golden Knights', 'Paradise', 'NV', 'USA', 'West', 'Pacific');

-- INSERT 2024 SALARY CAP
SET SQL_SAFE_UPDATES = 0;
UPDATE franchises
SET Salary_Cap = 87700000.00;
SET SQL_SAFE_UPDATES = 1;

-- INSERT TRIGGER FOR EACH ADDITIONAL PLAYER 
DELIMITER $$

CREATE TRIGGER after_player_insert
AFTER INSERT ON players
FOR EACH ROW
BEGIN
    UPDATE franchises
    SET Salary_Cap = Salary_Cap - NEW.contract_value
    WHERE franchise_id = NEW.franchise_id;
END $$

DELIMITER ;

-- INSERT TRIGGER FOR EACH ADDITIONAL BUYOUT 
DELIMITER $$

CREATE TRIGGER after_buyout_insert
AFTER INSERT ON buyout
FOR EACH ROW
BEGIN
    UPDATE franchises
    SET Salary_Cap = Salary_Cap - NEW.buyout_value
    WHERE franchise_id = NEW.franchise_id;
END $$

DELIMITER ;

-- INSERT TRIGGER FOR EACH REMOVE PLAYER 
DELIMITER $$

CREATE TRIGGER after_player_delete 
AFTER DELETE ON players 
FOR EACH ROW 
BEGIN 
    UPDATE franchises 
    SET Salary_Cap = Salary_Cap + OLD.contract_value 
    WHERE franchise_id = OLD.franchise_id; 
END $$

DELIMITER ;

DELIMITER $$

-- INSERT TRIGGER FOR EACH REMOVE BUYOUT
CREATE TRIGGER after_buyout_delete 
AFTER DELETE ON buyout 
FOR EACH ROW 
BEGIN 
    UPDATE franchises 
    SET Salary_Cap = Salary_Cap + OLD.buyout_value 
    WHERE franchise_id = OLD.franchise_id; 
END $$

DELIMITER ;

-- INSERT BRUINS PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Brad', 'Marchand', '1988-05-11', TIMESTAMPDIFF(YEAR, '1988-05-11', CURDATE()), 'W', '2025-06-30', 6125000.00, 'UFA', 1),
('David', 'Pastrnak', '1996-05-25', TIMESTAMPDIFF(YEAR, '1996-05-25', CURDATE()), 'W', '2031-06-30', 11250000.00, 'UFA', 1),
('Pavel', 'Zacha', '1997-04-06', TIMESTAMPDIFF(YEAR, '1997-04-06', CURDATE()), 'F', '2027-06-30', 4750000.00, 'UFA', 1),
('Taylor', 'Hall', '1991-11-14', TIMESTAMPDIFF(YEAR, '1991-11-14', CURDATE()), 'W', '2025-06-30', 6000000.00, 'UFA', 17),
('Charlie', 'Coyle', '1992-03-02', TIMESTAMPDIFF(YEAR, '1992-03-02', CURDATE()), 'F', '2026-06-30', 5250000.00, 'UFA', 1),
('Nick', 'Foligno', '1987-10-31', TIMESTAMPDIFF(YEAR, '1987-10-31', CURDATE()), 'W', '2026-06-30', 4500000.00, 'UFA', 17),
('Trent', 'Frederic', '1998-02-11', TIMESTAMPDIFF(YEAR, '1998-02-11', CURDATE()), 'F', '2025-06-30', 2300000.00, 'UFA', 1),
('Morgan', 'Geekie', '1998-07-20', TIMESTAMPDIFF(YEAR, '1998-07-20', CURDATE()), 'W', '2025-06-30', 2000000.00, 'RFA', 1),
('John', 'Beecher', '2001-04-05', TIMESTAMPDIFF(YEAR, '2001-04-05', CURDATE()), 'F', '2025-06-30', 925000.00, 'RFA', 1),
('Patrick', 'Brown', '1992-05-29', TIMESTAMPDIFF(YEAR, '1992-05-29', CURDATE()), 'F', '2025-06-30', 800000.00, 'UFA', 1),
('Jakub', 'Lauko', '2000-03-28', TIMESTAMPDIFF(YEAR, '2000-03-28', CURDATE()), 'W', '2025-06-30', 787000.00, 'RFA', 1),
('Justin', 'Brazeau', '1998-02-02', TIMESTAMPDIFF(YEAR, '1998-02-02', CURDATE()), 'W', '2025-06-30', 775000.00, 'UFA', 1),
('Matthew', 'Poitras', '2004-03-10', TIMESTAMPDIFF(YEAR, '2004-03-10', CURDATE()), 'F', '2026-06-30', 870000.00, 'RFA', 1),
('Charlie', 'McAvoy', '1997-12-21', TIMESTAMPDIFF(YEAR, '1997-12-21', CURDATE()), 'D', '2030-06-30', 9500000.00, 'UFA', 1),
('Hampus', 'Lindholm', '1994-01-20', TIMESTAMPDIFF(YEAR, '1994-01-20', CURDATE()), 'D', '2030-06-30', 6500000.00, 'UFA', 1),
('Brandon', 'Carlo', '1996-11-26', TIMESTAMPDIFF(YEAR, '1996-11-26', CURDATE()), 'D', '2027-06-30', 4100000.00, 'UFA', 1),
('Mason', 'Lohrei', '1996-11-26', TIMESTAMPDIFF(YEAR, '1996-01-17', CURDATE()), 'D', '2025-06-30', 925000.00, 'RFA', 1), 
('Andrew', 'Peeke', '1998-03-17', TIMESTAMPDIFF(YEAR, '1998-03-17', CURDATE()), 'D', '2026-06-30', 2750000.00, 'UFA', 1),
('Parker', 'Wotherspoon', '1997-08-24', TIMESTAMPDIFF(YEAR, '1997-08-24', CURDATE()), 'D', '2025-06-30', 800000.00, 'UFA', 1), 
('Linus', 'Ullmark', '1993-07-31', TIMESTAMPDIFF(YEAR, '1993-07-31', CURDATE()), 'G', '2025-06-30', 5000000.00, 'UFA', 1)
;

-- INSERT ADDITION OF BRUINS PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Jesper', 'Boqvist', '1998-10-30', TIMESTAMPDIFF(YEAR, '1998-10-30', CURDATE()), 'F', '2024-06-30', 0.00 ,'RFA', 1),
('Jake', 'DeBrusk', '1996-10-17', TIMESTAMPDIFF(YEAR, '1996-10-17', CURDATE()), 'W', '2024-06-30', 0.00 ,'UFA', 1),
('Danton', 'Heinen', '1995-07-05', TIMESTAMPDIFF(YEAR, '1995-07-05', CURDATE()), 'W','2024-06-30', 0.00 ,'UFA', 1),
('Patrick', 'Maroon', '1988-04-23', TIMESTAMPDIFF(YEAR, '1988-04-23', CURDATE()), 'W','2024-06-30', 0.00 ,'UFA', 1),
('James', 'van Riemsdyk', '1989-05-04', TIMESTAMPDIFF(YEAR, '1989-05-04', CURDATE()), 'W','2024-06-30', 0.00 ,'UFA', 1),
('Derek', 'Forbort', '1992-03-04', TIMESTAMPDIFF(YEAR, '1992-03-04', CURDATE()), 'D','2024-06-30', 0.00 ,'UFA', 1),
('Matt', 'Grzelcyk', '1994-01-04',TIMESTAMPDIFF(YEAR, '1994-01-04', CURDATE()), 'D','2024-06-30', 0.00 ,'UFA', 1),
('Kevin', 'Shattenkirk', '1989-01-29', TIMESTAMPDIFF(YEAR, '1989-01-29', CURDATE()), 'D','2024-06-30', 0.00 ,'UFA', 1),
('Jeremy', 'Swayman', '1998-11-24', TIMESTAMPDIFF(YEAR, '1998-11-24', CURDATE()), 'G', '2024-06-30', 0.00 ,'RFA', 1),
('Brandon', 'Bussi', '1998-06-25', TIMESTAMPDIFF(YEAR, '1998-06-25', CURDATE()), 'G', '2024-06-30', 0.00 ,'RFA', 1)
;

-- INSERT BRUINS BUYOUT
INSERT INTO buyout (first_name, last_name, buyout_end_date, buyout_value, franchise_id) VALUES
('Mike', 'Reilly', '2025-06-30', 1333334.00, 1);

-- INSERT MAPLE LEAFS PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Auston', 'Matthews', '1997-09-17', TIMESTAMPDIFF(YEAR, '1997-09-17', CURDATE()), 'F', '2028-06-30', 13250000, 'UFA', 2),
('William', 'Nylander', '1996-05-01', TIMESTAMPDIFF(YEAR, '1996-05-01', CURDATE()), 'W', '2032-06-30', 11500000, 'UFA', 2),
('John', 'Tavares', '1990-09-20', TIMESTAMPDIFF(YEAR, '1990-09-20', CURDATE()), 'F', '2025-06-30', 11000000, 'UFA', 2),
('Mitchell', 'Marner', '1997-05-05', TIMESTAMPDIFF(YEAR, '1997-05-05', CURDATE()), 'W', '2025-06-30', 10903000, 'UFA', 2),
('David', 'Kampf', '1995-01-12', TIMESTAMPDIFF(YEAR, '1995-01-12', CURDATE()), 'F', '2027-06-30', 2400000, 'UFA', 2),
('Calle', 'Jarnkrok', '1991-09-25', TIMESTAMPDIFF(YEAR, '1991-09-25', CURDATE()), 'W', '2026-06-30', 2100000, 'UFA', 2),
('Ryan', 'Reaves', '1987-01-20', TIMESTAMPDIFF(YEAR, '1987-01-20', CURDATE()), 'W', '2026-06-30', 1350000, 'UFA', 2),
('Bobby', 'McMann', '1996-06-15', TIMESTAMPDIFF(YEAR, '1996-06-15', CURDATE()), 'W', '2026-06-30', 1350000, 'UFA', 2),
('Matthew', 'Knies', '2002-10-17', TIMESTAMPDIFF(YEAR, '2002-10-17', CURDATE()), 'W', '2025-06-30', 925000, 'RFA', 2),
('Pontus', 'Holmberg', '1999-03-09', TIMESTAMPDIFF(YEAR, '1999-03-09', CURDATE()), 'F', '2025-06-30', 800000, 'RFA', 2),
('Morgan', 'Rielly', '1994-03-09', TIMESTAMPDIFF(YEAR, '1994-03-09', CURDATE()), 'D', '2030-06-30', 7500000, 'UFA', 2),
('Jake', 'McCabe', '1993-10-12', TIMESTAMPDIFF(YEAR, '1993-10-12', CURDATE()), 'D', '2025-06-30', 2000000, 'UFA', 2),
('Simon', 'Benoit', '1998-09-19', TIMESTAMPDIFF(YEAR, '1998-09-19', CURDATE()), 'D', '2027-06-30', 1350000, 'UFA', 2),
('Conor', 'Timmins', '1998-09-18', TIMESTAMPDIFF(YEAR, '1998-09-18', CURDATE()), 'D', '2025-06-30', 1100000, 'RFA', 2),
('Cade', 'Webber', '2001-01-05', TIMESTAMPDIFF(YEAR, '2001-01-05', CURDATE()), 'D', '2025-06-30', 850000, 'RFA', 2),
('Joseph', 'Woll', '1998-07-12', TIMESTAMPDIFF(YEAR, '1998-07-12', CURDATE()), 'G', '2025-06-30', 766667, 'RFA', 2);

-- INSERT ADDITION OF MAPLE LEAFS PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Dewar', 'Connor','1999-06-26', TIMESTAMPDIFF(YEAR, '1999-06-26', CURDATE()), 'W', '2024-06-30', 0.00, 'RFA', 2),
('Gregor', 'Noah', '1998-07-28', TIMESTAMPDIFF(YEAR, '1998-07-28', CURDATE()), 'W', '2024-06-30', 0.00, 'RFA', 2),
('Nicholas', 'Robertson','2001-09-11', TIMESTAMPDIFF(YEAR, '2001-09-11', CURDATE()), 'W', '2024-06-30', 0.00, 'RFA', 2),
('Tyler', 'Bertuzzi', '1995-02-24', TIMESTAMPDIFF(YEAR, '1995-02-24', CURDATE()), 'W', '2024-06-30', 0.00, 'UFA', 2),
('Max', 'Domi', '1995-03-02', TIMESTAMPDIFF(YEAR, '1995-03-02', CURDATE()), 'W', '2024-06-30', 0.00, 'UFA', 2),
('John', 'Klingberg', '1992-08-14', TIMESTAMPDIFF(YEAR, '1992-08-14', CURDATE()), 'D', '2024-06-30', 0.00, 'UFA', 2),
('Timothy', 'Liljegren', '1999-04-30', TIMESTAMPDIFF(YEAR, '1999-04-30', CURDATE()), 'D', '2024-06-30', 0.00, 'RFA', 2),
('TJ', 'Brodie', '1990-06-07', TIMESTAMPDIFF(YEAR, '1990-06-07', CURDATE()), 'D', '2024-06-30', 0.00, 'UFA', 2),
('Joel', 'Edmundson', '1993-06-28', TIMESTAMPDIFF(YEAR, '1993-06-28', CURDATE()), 'D', '2024-06-30', 0.00, 'UFA', 2),
('Mark', 'Giordano', '1983-10-03', TIMESTAMPDIFF(YEAR, '1983-10-03', CURDATE()), 'D', '2024-06-30', 0.00, 'UFA', 2),
('Ilya', 'Lyubushkin', '1994-04-06', TIMESTAMPDIFF(YEAR, '1983-10-03', CURDATE()), 'D', '2024-06-30', 0.00, 'UFA', 2),
('Matt', 'Murray', '1994-05-25', TIMESTAMPDIFF(YEAR, '1994-05-25', CURDATE()), 'G', '2024-06-30', 0.00, 'UFA', 2),
('Ilya', 'Samsonov', '1997-02-22', TIMESTAMPDIFF(YEAR, '1997-02-22', CURDATE()), 'G', '2024-06-30', 0.00, 'UFA', 2),
('Martin', 'Jones', '1990-01-10', TIMESTAMPDIFF(YEAR, '1990-01-10', CURDATE()), 'G', '2024-06-30', 0.00, 'UFA', 2);

-- INSERT CANADIANS PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Nick', 'Suzuki', '1999-08-10', TIMESTAMPDIFF(YEAR, '1999-08-10', CURDATE()), 'F', '2030-06-30', 7875000, 'UFA', 3),
('Cole', 'Caufield', '2001-01-02', TIMESTAMPDIFF(YEAR, '2001-01-02', CURDATE()), 'W', '2030-06-30', 7850000, 'UFA', 3),
('Brendan', 'Gallagher', '1992-05-06', TIMESTAMPDIFF(YEAR, '1992-05-06', CURDATE()), 'W', '2026-06-30', 6500000, 'UFA', 3),
('Josh', 'Anderson', '1994-05-07', TIMESTAMPDIFF(YEAR, '1994-05-07', CURDATE()), 'W', '2026-06-30', 5500000, 'UFA', 3),
('Christian', 'Dvorak', '1996-02-02', TIMESTAMPDIFF(YEAR, '1996-02-02', CURDATE()), 'F', '2025-06-30', 4450000, 'UFA', 3),
('Joel', 'Armia', '1993-05-31', TIMESTAMPDIFF(YEAR, '1993-05-31', CURDATE()), 'W', '2025-06-30', 3400000, 'UFA', 3),
('Alex', 'Newhook', '2001-01-28', TIMESTAMPDIFF(YEAR, '2001-01-28', CURDATE()), 'F', '2026-06-30', 2900000, 'RFA', 3),
('Jake', 'Evans', '1996-06-02', TIMESTAMPDIFF(YEAR, '1996-06-02', CURDATE()), 'F', '2025-06-30', 1700000, 'UFA', 3),
('Rafaël', 'Harvey-Pinard', '1999-01-06', TIMESTAMPDIFF(YEAR, '1999-01-06', CURDATE()), 'W', '2025-06-30', 1100000, 'RFA', 3),
('Juraj', 'Slafkovsky', '2004-03-30', TIMESTAMPDIFF(YEAR, '2004-03-30', CURDATE()), 'W', '2025-06-30', 950000, 'RFA', 3),
('Michael', 'Pezzetta', '1998-03-13', TIMESTAMPDIFF(YEAR, '1998-03-13', CURDATE()), 'W', '2025-06-30', 812500, 'UFA', 3),
('Michael', 'Matheson', '1994-02-27', TIMESTAMPDIFF(YEAR, '1994-02-27', CURDATE()), 'D', '2026-06-30', 4875000, 'UFA', 3),
('David', 'Savard', '1990-10-22', TIMESTAMPDIFF(YEAR, '1990-10-22', CURDATE()), 'D', '2025-06-30', 3500000, 'UFA', 3),
('Jordan', 'Harris', '2000-07-07', TIMESTAMPDIFF(YEAR, '2000-07-07', CURDATE()), 'D', '2025-06-30', 1400000, 'RFA', 3),
('Lane', 'Hutson', '2004-05-14', TIMESTAMPDIFF(YEAR, '2004-05-14', CURDATE()), 'D', '2026-06-30', 950000, 'RFA', 3),
('Kaiden', 'Guhle', '2002-01-18', TIMESTAMPDIFF(YEAR, '2002-01-18', CURDATE()), 'D', '2025-06-30', 863333, 'RFA', 3),
('Johnathan', 'Kovacevic', '1997-07-12', TIMESTAMPDIFF(YEAR, '1997-07-12', CURDATE()), 'D', '2025-06-30', 766667, 'UFA', 3),
('Samuel', 'Montembeault', '1996-10-30', TIMESTAMPDIFF(YEAR, '1996-10-30', CURDATE()), 'G', '2026-06-30', 3150000, 'UFA', 3),
('Cayden', 'Primeau', '1999-08-11', TIMESTAMPDIFF(YEAR, '1999-08-11', CURDATE()), 'G', '2025-06-30', 890000, 'RFA', 3),
('Kirby', 'Dach', '2001-01-21', TIMESTAMPDIFF(YEAR, '2001-01-21', CURDATE()), 'F', '2026-06-30', 3362500, 'RFA', 3);

-- INSERT ADDITION OF CANADIANS PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Jesse', 'Ylönen', '1999-10-03', TIMESTAMPDIFF(YEAR, '1999-10-03', CURDATE()), 'W', '2024-06-30', 0.00, 'RFA', 3),
('Tanner', 'Pearson', '1992-08-10', TIMESTAMPDIFF(YEAR, '1992-08-10', CURDATE()), 'W', '2024-06-30', 0.00, 'UFA', 3),
('Colin', 'White', '1997-01-30', TIMESTAMPDIFF(YEAR, '1997-01-30', CURDATE()), 'F', '2024-06-30', 0.00, 'UFA', 3),
('Arber', 'Xhekaj', '2001-01-30', TIMESTAMPDIFF(YEAR, '2001-01-30', CURDATE()), 'D', '2024-06-30', 0.00, 'RFA', 3)
('Chris', 'Wideman', '1990-01-07', TIMESTAMPDIFF(YEAR, '1990-01-07', CURDATE()), 'D', '2024-06-30', 0.00, 'UFA', 3);

-- INSERT CANADIANS BUYOUT
INSERT INTO buyout (first_name, last_name, buyout_end_date, buyout_value, franchise_id) VALUES
('Carey', 'Price', '2026-06-30', 10500000.00, 3),
('Jeff', 'Petry', '2025-06-30',  2343750.00, 3),
('Jake', 'Allen', '2025-06-30',  1925000.00, 3);


-- INSERT SABRES PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Jeff', 'Skinner', '1992-05-16', TIMESTAMPDIFF(YEAR, '1992-05-16', CURDATE()), 'W', '2027-06-30', 9000000, 'UFA', 4),
('Tage', 'Thompson', '1997-10-30', TIMESTAMPDIFF(YEAR, '1997-10-30', CURDATE()), 'F', '2030-06-30', 7142857, 'UFA', 4),
('Dylan', 'Cozens', '2001-02-09', TIMESTAMPDIFF(YEAR, '2001-02-09', CURDATE()), 'f', '2030-06-30', 7100000, 'UFA', 4),
('Alex', 'Tuch', '1996-05-10', TIMESTAMPDIFF(YEAR, '1996-05-10', CURDATE()), 'W', '2026-06-30', 4750000, 'UFA', 4),
('Jordan', 'Greenway', '1997-02-16', TIMESTAMPDIFF(YEAR, '1997-02-16', CURDATE()), 'W', '2025-06-30', 3000000, 'UFA', 4),
('Zach', 'Benson', '2004-05-12', TIMESTAMPDIFF(YEAR, '2004-05-12', CURDATE()), 'W', '2026-06-30', 950000, 'RFA', 4),
('Jack', 'Quinn', '2002-09-19', TIMESTAMPDIFF(YEAR, '2002-09-19', CURDATE()), 'W', '2025-06-30', 863333, 'RFA', 4),
('John-Jason', 'Peterka', '2002-01-14', TIMESTAMPDIFF(YEAR, '2002-01-14', CURDATE()), 'W', '2025-06-30', 855833, 'RFA', 4),
('Rasmus', 'Dahlin', '2000-04-13', TIMESTAMPDIFF(YEAR, '2000-04-13', CURDATE()), 'D', '2032-06-30', 11000000, 'UFA', 4),
('Owen', 'Power', '2003-11-22', TIMESTAMPDIFF(YEAR, '2003-11-22', CURDATE()), 'D', '2031-06-30', 8350000, 'UFA', 4),
('Mattias', 'Samuelsson', '2000-03-14', TIMESTAMPDIFF(YEAR, '2000-03-14', CURDATE()), 'D', '2030-06-30', 4285714, 'UFA', 4),
('Bowen', 'Byram', '2001-06-13', TIMESTAMPDIFF(YEAR, '2001-06-13', CURDATE()), 'D', '2025-06-30', 3850000, 'RFA', 4),
('Connor', 'Clifton', '1995-04-28', TIMESTAMPDIFF(YEAR, '1995-04-28', CURDATE()), 'D', '2026-06-30', 3333333.00, 'UFA', 4);

-- INSERT ADDITION OF SABRES PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Peyton', 'Krebs', '2001-01-26', TIMESTAMPDIFF(YEAR, '2001-01-26', CURDATE()), 'F', '2024-06-30', 0.00, 'RFA', 4),
('Zemgus', 'Girgensons', '1994-01-05', TIMESTAMPDIFF(YEAR, '1994-01-05', CURDATE()), 'W', '2024-06-30', 0.00, 'UFA', 4),
('Tyson', 'Jost', '1998-03-14', TIMESTAMPDIFF(YEAR, '1998-03-14', CURDATE()), 'F', '2024-06-30', 0.00, 'UFA', 4),
('Victor', 'Olofsson', '1996-07-18', TIMESTAMPDIFF(YEAR, '1996-07-18', CURDATE()), 'W', '2024-06-30', 0.00, 'UFA', 4),
('Eric', 'Robinson', '1995-06-14', TIMESTAMPDIFF(YEAR, '1995-06-14', CURDATE()), 'W', '2024-06-30', 0.00, 'UFA', 4),
('Jacob', 'Bryson', '1997-11-18', TIMESTAMPDIFF(YEAR, '1997-11-18', CURDATE()), 'D', '2024-06-30', 0.00, 'RFA', 4),
('Kale', 'Clague', '1998-06-05', TIMESTAMPDIFF(YEAR, '1998-06-05', CURDATE()), 'D', '2024-06-30', 0.00, 'RFA', 4),
('Henri', 'Jokiharju', '1999-06-17', TIMESTAMPDIFF(YEAR, '1999-06-17', CURDATE()), 'D', '2024-06-30', 0.00, 'RFA', 4),
('Ukko-Pekka', 'Luukkonen', '1999-03-09', TIMESTAMPDIFF(YEAR, '1999-03-09', CURDATE()), 'G', '2024-06-30', 0.00, 'RFA', 4),
('Eric', 'Comrie', '1995-07-06', TIMESTAMPDIFF(YEAR, '1995-07-06', CURDATE()), 'G', '2024-06-30', 0.00, 'UFA', 4);

-- INSERT RED WINGS PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Dylan', 'Larkin', '1996-07-30', TIMESTAMPDIFF(YEAR, '1996-07-30', CURDATE()), 'F', '2031-06-30', 8700000, 'UFA', 5),
('Alex', 'DeBrincat', '1997-12-18', TIMESTAMPDIFF(YEAR, '1997-12-18', CURDATE()), 'W', '2027-06-30', 7875000, 'UFA', 5),
('Andrew', 'Copp', '1994-07-08', TIMESTAMPDIFF(YEAR, '1994-07-08', CURDATE()), 'F', '2027-06-30', 5625000, 'UFA', 5),
('J.T.', 'Compher', '1994-04-08', TIMESTAMPDIFF(YEAR, '1994-04-08', CURDATE()), 'F', '2028-06-30', 5100000, 'UFA', 5),
('Robby', 'Fabbri', '1996-01-22', TIMESTAMPDIFF(YEAR, '1996-01-22', CURDATE()), 'W', '2025-06-30', 4000000, 'UFA', 5),
('Michael', 'Rasmussen', '1999-04-17', TIMESTAMPDIFF(YEAR, '1999-04-17', CURDATE()), 'F', '2028-06-30', 3200000, 'UFA', 5),
('Ben', 'Chiarot', '1991-05-09', TIMESTAMPDIFF(YEAR, '1991-05-09', CURDATE()), 'D', '2026-06-30', 4750000, 'UFA', 5),
('Justin', 'Holl', '1992-01-30', TIMESTAMPDIFF(YEAR, '1992-01-30', CURDATE()), 'D', '2026-06-30', 3400000, 'UFA', 5),
('Jake', 'Walman', '1996-02-20', TIMESTAMPDIFF(YEAR, '1996-02-20', CURDATE()), 'D', '2026-06-30', 3400000, 'UFA', 5),
('Olli', 'Määttä', '1994-08-22', TIMESTAMPDIFF(YEAR, '1994-08-22', CURDATE()), 'D', '2025-06-30', 3000000, 'UFA', 5),
('Jeff', 'Petry', '1987-12-09', TIMESTAMPDIFF(YEAR, '1987-12-09', CURDATE()), 'D', '2025-06-30', 2343750, 'UFA', 5),
('Ville', 'Husso', '1995-02-06', TIMESTAMPDIFF(YEAR, '1995-02-06', CURDATE()), 'G', '2025-06-30', 4750000, 'UFA', 5),
('Alex', 'Lyon', '1992-12-09', TIMESTAMPDIFF(YEAR, '1992-12-09', CURDATE()), 'G', '2025-06-30', 900000, 'UFA', 5);


-- INSERT ADDITION OF RED WINGS PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Lucas', 'Raymond', '2001-03-28', TIMESTAMPDIFF(YEAR, '2001-03-28', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 5),
('Joseph', 'Veleno', '1999-01-13', TIMESTAMPDIFF(YEAR, '1999-01-13', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 5),
('Christian', 'Fischer', '1997-04-15', TIMESTAMPDIFF(YEAR, '1997-04-15', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 5),
('Patrick', 'Kane', '1988-11-19', TIMESTAMPDIFF(YEAR, '1988-11-19', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 5),
('David', 'Perron', '1987-05-28', TIMESTAMPDIFF(YEAR, '1987-05-28', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 5),
('Daniel', 'Sprong', '1997-03-17', TIMESTAMPDIFF(YEAR, '1997-03-17', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 5),
('Moritz', 'Seider', '2001-04-06', TIMESTAMPDIFF(YEAR, '2001-04-06', CURDATE()), 'D', '2024-06-30', 0, 'RFA', 5),
('Shayne', 'Gostisbehere', '1993-04-20', TIMESTAMPDIFF(YEAR, '1993-04-20', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 5),
('James', 'Reimer', '1988-03-15', TIMESTAMPDIFF(YEAR, '1988-03-15', CURDATE()), 'G', '2024-06-30', 0, 'UFA', 5);

-- INSERT RED WINGS BUYOUT
INSERT INTO buyout (first_name, last_name, buyout_end_date, buyout_value, franchise_id) VALUES
('Justin', 'Abdelkader', '2026-06-30', 1055556, 5),
('Kailer', 'Yamamoto', '2025-06-30', 533334, 5);

-- INSERT PANTHERS PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Aleksander', 'Barkov', '1995-09-02', TIMESTAMPDIFF(YEAR, '1995-09-02', CURDATE()), 'F', '2030-06-30', 10000000, 'UFA', 6),
('Matthew', 'Tkachuk', '1997-12-11', TIMESTAMPDIFF(YEAR, '1997-12-11', CURDATE()), 'W', '2030-06-30', 9500000, 'UFA', 6),
('Sam', 'Bennett', '1996-06-20', TIMESTAMPDIFF(YEAR, '1996-06-20', CURDATE()), 'F', '2025-06-30', 4425000, 'UFA', 6),
('Carter', 'Verhaeghe', '1995-08-14', TIMESTAMPDIFF(YEAR, '1995-08-14', CURDATE()), 'W', '2025-06-30', 4166667, 'UFA', 6),
('Evan', 'Rodrigues', '1993-07-28', TIMESTAMPDIFF(YEAR, '1993-07-28', CURDATE()), 'F', '2027-06-30', 3000000, 'UFA', 6),
('Eetu', 'Luostarinen', '1998-09-02', TIMESTAMPDIFF(YEAR, '1998-09-02', CURDATE()), 'F', '2027-06-30', 3000000, 'UFA', 6),
('Jonah', 'Gadjovich', '1998-10-12', TIMESTAMPDIFF(YEAR, '1998-10-12', CURDATE()), 'W', '2026-06-30', 775000, 'UFA', 6),
('Aaron', 'Ekblad', '1996-02-07', TIMESTAMPDIFF(YEAR, '1996-02-07', CURDATE()), 'D', '2025-06-30', 7500000, 'UFA', 6),
('Gustav', 'Forsling', '1996-06-12', TIMESTAMPDIFF(YEAR, '1996-06-12', CURDATE()), 'D', '2032-06-30', 5750000, 'UFA', 6),
('Niko', 'Mikkola', '1996-04-27', TIMESTAMPDIFF(YEAR, '1996-04-27', CURDATE()), 'D', '2026-06-30', 2500000, 'UFA', 6),
('Uvis', 'Balinskis', '1996-07-01', TIMESTAMPDIFF(YEAR, '1996-07-01', CURDATE()), 'D', '2026-06-30', 850000, 'UFA', 6),
('Tobias', 'Björnfot', '2000-04-06', TIMESTAMPDIFF(YEAR, '2000-04-06', CURDATE()), 'D', '2025-06-30', 775000, 'RFA', 6),
('Sergei', 'Bobrovsky', '1988-09-20', TIMESTAMPDIFF(YEAR, '1988-09-20', CURDATE()), 'G', '2026-06-30', 10000000, 'UFA', 6),
('Spencer', 'Knight', '2001-04-19', TIMESTAMPDIFF(YEAR, '2001-04-19', CURDATE()), 'G', '2026-06-30', 4500000, 'RFA', 6);

-- INSERT ADDITION OF PANTHERS PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Anton', 'Lundell', '2001-10-03', TIMESTAMPDIFF(YEAR, '2001-10-03', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 6),
('Nick', 'Cousins', '1993-07-20', TIMESTAMPDIFF(YEAR, '1993-07-20', CURDATE()), 'F', '2024-06-30', 0, 'UFA', 6),
('Ryan', 'Lomberg', '1994-12-16', TIMESTAMPDIFF(YEAR, '1994-12-16', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 6),
('Steven', 'Lorentz', '1996-04-13', TIMESTAMPDIFF(YEAR, '1996-04-13', CURDATE()), 'F', '2024-06-30', 0, 'UFA', 6),
('Kyle', 'Okposo', '1988-04-16', TIMESTAMPDIFF(YEAR, '1988-04-16', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 6),
('Sam', 'Reinhart', '1995-11-06', TIMESTAMPDIFF(YEAR, '1995-11-06', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 6),
('Kevin', 'Stenlund', '1996-09-20', TIMESTAMPDIFF(YEAR, '1996-09-20', CURDATE()), 'F', '2024-06-30', 0, 'UFA', 6),
('Vladimir', 'Tarasenko', '1991-12-13', TIMESTAMPDIFF(YEAR, '1991-12-13', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 6),
('Josh', 'Mahura', '1998-05-05', TIMESTAMPDIFF(YEAR, '1998-05-05', CURDATE()), 'D', '2024-06-30', 0, 'RFA', 6),
('Oliver', 'Ekman-Larsson', '1991-07-17', TIMESTAMPDIFF(YEAR, '1991-07-17', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 6),
('Dmitry', 'Kulikov', '1990-10-29', TIMESTAMPDIFF(YEAR, '1990-10-29', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 6),
('Brandon', 'Montour', '1994-04-11', TIMESTAMPDIFF(YEAR, '1994-04-11', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 6),
('Anthony', 'Stolarz', '1994-01-20', TIMESTAMPDIFF(YEAR, '1994-01-20', CURDATE()), 'G', '2024-06-30', 0, 'UFA', 6);

-- INSERT PANTHERS BUYOUT
INSERT INTO buyout (first_name, last_name, buyout_end_date, buyout_value, franchise_id) VALUES
('Keith', 'Yandle', '2025-06-30', 1241667, 6);

-- INSERT SENATORS PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Tim', 'Stützle', '2002-01-15', TIMESTAMPDIFF(YEAR, '2002-01-15', CURDATE()), 'F', '2031-06-30', 8350000, 'UFA', 7),
('Joshua', 'Norris', '1999-05-05', TIMESTAMPDIFF(YEAR, '1999-05-05', CURDATE()), 'F', '2030-06-30', 7950000, 'UFA', 7),
('Brady', 'Tkachuk', '1999-09-16', TIMESTAMPDIFF(YEAR, '1999-09-16', CURDATE()), 'W', '2028-06-30', 8205714, 'UFA', 7),
('Claude', 'Giroux', '1988-01-12', TIMESTAMPDIFF(YEAR, '1988-01-12', CURDATE()), 'F', '2025-06-30', 6500000, 'UFA', 7),
('Drake', 'Batherson', '1998-04-27', TIMESTAMPDIFF(YEAR, '1998-04-27', CURDATE()), 'W', '2027-06-30', 4975000, 'UFA', 7),
('Mathieu', 'Joseph', '1997-02-09', TIMESTAMPDIFF(YEAR, '1997-02-09', CURDATE()), 'W', '2026-06-30', 2950000, 'UFA', 7),
('Ridly', 'Greig', '2002-08-08', TIMESTAMPDIFF(YEAR, '2002-08-08', CURDATE()), 'F', '2025-06-30', 863333, 'RFA', 7),
('Mark', 'Kastelic', '1999-03-11', TIMESTAMPDIFF(YEAR, '1999-03-11', CURDATE()), 'F', '2025-06-30', 835000, 'RFA', 7),
('Zack', 'MacEwen', '1996-07-08', TIMESTAMPDIFF(YEAR, '1996-07-08', CURDATE()), 'F', '2026-06-30', 775000, 'UFA', 7),
('Jake', 'Sanderson', '2002-07-08', TIMESTAMPDIFF(YEAR, '2002-07-08', CURDATE()), 'D', '2032-06-30', 8050000, 'UFA', 7),
('Thomas', 'Chabot', '1997-01-30', TIMESTAMPDIFF(YEAR, '1997-01-30', CURDATE()), 'D', '2028-06-30', 8000000, 'UFA', 7),
('Jakob', 'Chychrun', '1998-03-31', TIMESTAMPDIFF(YEAR, '1998-03-31', CURDATE()), 'D', '2025-06-30', 4600000, 'UFA', 7),
('Artem', 'Zub', '1995-10-03', TIMESTAMPDIFF(YEAR, '1995-10-03', CURDATE()), 'D', '2027-06-30', 4600000, 'UFA', 7),
('Travis', 'Hamonic', '1990-08-16', TIMESTAMPDIFF(YEAR, '1990-08-16', CURDATE()), 'D', '2025-06-30', 1100000, 'UFA', 7),
('Jacob', 'Bernard-Docker', '2000-06-30', TIMESTAMPDIFF(YEAR, '2000-06-30', CURDATE()), 'D', '2025-06-30', 805000, 'RFA', 7),
('Joonas', 'Korpisalo', '1994-04-28', TIMESTAMPDIFF(YEAR, '1994-04-28', CURDATE()), 'G', '2028-06-30', 4000000, 'UFA', 7),
('Anton', 'Forsberg', '1992-11-27', TIMESTAMPDIFF(YEAR, '1992-11-27', CURDATE()), 'G', '2025-06-30', 2750000, 'UFA', 7);

-- INSERT ADDITION OF SENATORS PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Boris', 'Katchouk', '1998-06-18', TIMESTAMPDIFF(YEAR, '1998-06-18', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 7),
('Parker', 'Kelly', '1999-01-14', TIMESTAMPDIFF(YEAR, '1999-01-14', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 7),
('Shane', 'Pinto', '2000-11-12', TIMESTAMPDIFF(YEAR, '2000-11-12', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 7),
('Dominik', 'Kubalik', '1995-08-21', TIMESTAMPDIFF(YEAR, '1995-08-21', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 7),
('Erik', 'Brännström', '1999-09-02', TIMESTAMPDIFF(YEAR, '1999-09-02', CURDATE()), 'D', '2024-06-30', 0, 'RFA', 7);

-- INSERT SENATORS BUYOUT
INSERT INTO buyout (first_name, last_name, buyout_end_date, buyout_value, franchise_id) VALUES
('Colin', 'White', '2028-06-30', 875000, 7);

-- INSERT LIGHTNING PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Nikita', 'Kucherov', '1993-06-17', TIMESTAMPDIFF(YEAR, '1993-06-17', CURDATE()), 'W', '2027-06-30', 9500000, 'UFA', 8),
('Brayden', 'Point', '1996-03-13', TIMESTAMPDIFF(YEAR, '1996-03-13', CURDATE()), 'F', '2032-06-30', 9500000, 'UFA', 8),
('Brandon', 'Hagel', '1998-08-27', TIMESTAMPDIFF(YEAR, '1998-08-27', CURDATE()), 'W', '2030-06-30', 6500000, 'UFA', 8),
('Anthony', 'Cirelli', '1997-07-15', TIMESTAMPDIFF(YEAR, '1997-07-15', CURDATE()), 'F', '2031-06-30', 6250000, 'UFA', 8),
('Nicholas', 'Paul', '1995-03-20', TIMESTAMPDIFF(YEAR, '1995-03-20', CURDATE()), 'F', '2029-06-30', 3150000, 'UFA', 8),
('Tanner', 'Jeannot', '1997-05-29', TIMESTAMPDIFF(YEAR, '1997-05-29', CURDATE()), 'W', '2025-06-30', 2665000, 'UFA', 8),
('Conor', 'Sheary', '1992-06-08', TIMESTAMPDIFF(YEAR, '1992-06-08', CURDATE()), 'W', '2026-06-30', 2000000, 'UFA', 8),
('Michael', 'Eyssimont', '1996-09-09', TIMESTAMPDIFF(YEAR, '1996-09-09', CURDATE()), 'F', '2025-06-30', 800000, 'UFA', 8),
('Luke', 'Glendening', '1989-04-28', TIMESTAMPDIFF(YEAR, '1989-04-28', CURDATE()), 'F', '2025-06-30', 800000, 'UFA', 8),
('Mitchell', 'Chaffee', '1997-01-26', TIMESTAMPDIFF(YEAR, '1997-01-26', CURDATE()), 'W', '2026-06-30', 800000, 'UFA', 8),
('Mikhail', 'Sergachev', '1998-06-25', TIMESTAMPDIFF(YEAR, '1998-06-25', CURDATE()), 'D', '2031-06-30', 8500000, 'UFA', 8),
('Victor', 'Hedman', '1990-12-18', TIMESTAMPDIFF(YEAR, '1990-12-18', CURDATE()), 'D', '2025-06-30', 7875000, 'UFA', 8),
('Ryan', 'McDonagh', '1989-06-13', TIMESTAMPDIFF(YEAR, '1989-06-13', CURDATE()), 'D', '2026-06-30', 6750000, 'UFA', 8),
('Erik', 'Cernak', '1997-05-28', TIMESTAMPDIFF(YEAR, '1997-05-28', CURDATE()), 'D', '2031-06-30', 5200000, 'UFA', 8),
('Nick', 'Perbix', '1998-06-15', TIMESTAMPDIFF(YEAR, '1998-06-15', CURDATE()), 'D', '2025-06-30', 1125000, 'UFA', 8),
('Darren', 'Raddysh', '1997-02-28', TIMESTAMPDIFF(YEAR, '1997-02-28', CURDATE()), 'D', '2026-06-30', 975000, 'UFA', 8),
('Andrei', 'Vasilevskiy', '1994-07-25', TIMESTAMPDIFF(YEAR, '1994-07-25', CURDATE()), 'G', '2028-06-30', 9500000, 'UFA', 8),
('Jonas', 'Johansson', '1995-09-19', TIMESTAMPDIFF(YEAR, '1995-09-19', CURDATE()), 'G', '2025-06-30', 775000, 'UFA', 8);

-- INSERT ADDITION OF SENATORS PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Anthony', 'Duclair', '1995-08-26', TIMESTAMPDIFF(YEAR, '1995-08-26', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 8),
('Tyler', 'Motte', '1995-03-10', TIMESTAMPDIFF(YEAR, '1995-03-10', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 8),
('Steven', 'Stamkos', '1990-02-07', TIMESTAMPDIFF(YEAR, '1990-02-07', CURDATE()), 'F', '2024-06-30', 0, 'UFA', 8),
('Austin', 'Watson', '1992-01-13', TIMESTAMPDIFF(YEAR, '1992-01-13', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 8),
('Calvin', 'De Haan', '1991-05-09', TIMESTAMPDIFF(YEAR, '1991-05-09', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 8),
('Matt', 'Dumba', '1994-07-25', TIMESTAMPDIFF(YEAR, '1994-07-25', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 8),
('Haydn', 'Fleury', '1996-07-08', TIMESTAMPDIFF(YEAR, '1996-07-08', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 8),
('Logan', 'Brown', '1998-03-05', TIMESTAMPDIFF(YEAR, '1998-03-05', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 8);

-- INSERT HURRICANES PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Sebastian', 'Aho', '1997-07-26', TIMESTAMPDIFF(YEAR, '1997-07-26', CURDATE()), 'F', '2032-06-30', 9750000, 'UFA', 9),
('Andrei', 'Svechnikov', '2000-03-26', TIMESTAMPDIFF(YEAR, '2000-03-26', CURDATE()), 'W', '2029-06-30', 7750000, 'UFA', 9),
('Jesperi', 'Kotkaniemi', '2000-07-06', TIMESTAMPDIFF(YEAR, '2000-07-06', CURDATE()), 'F', '2030-06-30', 4820000, 'UFA', 9),
('Evgeny', 'Kuznetsov', '1992-05-19', TIMESTAMPDIFF(YEAR, '1992-05-19', CURDATE()), 'F', '2025-06-30', 3900000, 'UFA', 9),
('Jordan', 'Staal', '1988-09-10', TIMESTAMPDIFF(YEAR, '1988-09-10', CURDATE()), 'F', '2027-06-30', 2900000, 'UFA', 9),
('Jesper', 'Fast', '1991-12-02', TIMESTAMPDIFF(YEAR, '1991-12-02', CURDATE()), 'W', '2025-06-30', 2400000, 'UFA', 9),
('Bradly', 'Nadeau', '2003-02-05', TIMESTAMPDIFF(YEAR, '2003-02-05', CURDATE()), 'W', '2027-06-30', 918333, 'RFA', 9),
('Jackson', 'Blake', '2002-08-16', TIMESTAMPDIFF(YEAR, '2002-08-16', CURDATE()), 'W', '2026-06-30', 905833, 'RFA', 9),
('Brendan', 'Lemieux', '1996-03-15', TIMESTAMPDIFF(YEAR, '1996-03-15', CURDATE()), 'W', '2025-06-30', 775000, 'UFA', 9),
('Dmitry', 'Orlov', '1991-07-23', TIMESTAMPDIFF(YEAR, '1991-07-23', CURDATE()), 'D', '2025-06-30', 7750000, 'UFA', 9),
('Jaccob', 'Slavin', '1994-05-01', TIMESTAMPDIFF(YEAR, '1994-05-01', CURDATE()), 'D', '2025-06-30', 5300000, 'UFA', 9),
('Brent', 'Burns', '1985-03-09', TIMESTAMPDIFF(YEAR, '1985-03-09', CURDATE()), 'D', '2025-06-30', 5280000, 'UFA', 9),
('Scott', 'Morrow', '2003-11-01', TIMESTAMPDIFF(YEAR, '2003-11-01', CURDATE()), 'D', '2026-06-30', 916667, 'RFA', 9),
('Ronan', 'Seeley', '2003-08-02', TIMESTAMPDIFF(YEAR, '2003-08-02', CURDATE()), 'D', '2025-06-30', 810000, 'RFA', 9),
('Frederik', 'Andersen', '1989-10-02', TIMESTAMPDIFF(YEAR, '1989-10-02', CURDATE()), 'G', '2025-06-30', 3400000, 'UFA', 9),
('Pyotr', 'Kochetkov', '1999-06-25', TIMESTAMPDIFF(YEAR, '1999-06-25', CURDATE()), 'G', '2027-06-30', 2000000, 'UFA', 9),
('Spencer', 'Martin', '1995-06-08', TIMESTAMPDIFF(YEAR, '1995-06-08', CURDATE()), 'G', '2025-06-30', 775000, 'UFA', 9);

-- INSERT ADDITION OF HURRICANES PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Maxime', 'Comtois', '1999-01-08', TIMESTAMPDIFF(YEAR, '1999-01-08', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 9),
('Jack', 'Drury', '1998-02-03', TIMESTAMPDIFF(YEAR, '1998-02-03', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 9),
('Seth', 'Jarvis', '2002-02-01', TIMESTAMPDIFF(YEAR, '2002-02-01', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 9),
('Martin', 'Necas', '1999-01-15', TIMESTAMPDIFF(YEAR, '1999-01-15', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 9),
('Ryan', 'Suzuki', '2001-05-28', TIMESTAMPDIFF(YEAR, '2001-05-28', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 9),
('Jake', 'Guentzel', '1994-10-06', TIMESTAMPDIFF(YEAR, '1994-10-06', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 9),
('Jordan', 'Martinook', '1992-07-25', TIMESTAMPDIFF(YEAR, '1992-07-25', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 9),
('Stefan', 'Noesen', '1993-02-12', TIMESTAMPDIFF(YEAR, '1993-02-12', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 9),
('Teuvo', 'Teräväinen', '1994-09-11', TIMESTAMPDIFF(YEAR, '1994-09-11', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 9),
('Brett', 'Pesce', '1994-11-15', TIMESTAMPDIFF(YEAR, '1994-11-15', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 9),
('Brady', 'Skjei', '1994-03-26', TIMESTAMPDIFF(YEAR, '1994-03-26', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 9);

-- INSERT COLUMBUS PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Johnny', 'Gaudreau', '1993-08-13', TIMESTAMPDIFF(YEAR, '1993-08-13', CURDATE()), 'W', '2029-06-30', 9750000, 'UFA', 10),
('Patrik', 'Laine', '1998-04-19', TIMESTAMPDIFF(YEAR, '1998-04-19', CURDATE()), 'F', '2026-06-30', 8700000, 'UFA', 10),
('Boone', 'Jenner', '1993-06-15', TIMESTAMPDIFF(YEAR, '1993-06-15', CURDATE()), 'F', '2026-06-30', 3750000, 'UFA', 10),
('Sean', 'Kuraly', '1993-01-20', TIMESTAMPDIFF(YEAR, '1993-01-20', CURDATE()), 'F', '2025-06-30', 2500000, 'UFA', 10),
('Mathieu', 'Olivier', '1997-02-11', TIMESTAMPDIFF(YEAR, '1997-02-11', CURDATE()), 'W', '2025-06-30', 1100000, 'UFA', 10),
('Justin', 'Danforth', '1993-03-15', TIMESTAMPDIFF(YEAR, '1993-03-15', CURDATE()), 'F', '2025-06-30', 1100000, 'UFA', 10),
('Gavin', 'Brindley', '2004-01-14', TIMESTAMPDIFF(YEAR, '2004-01-14', CURDATE()), 'F', '2026-06-30', 950000, 'RFA', 10),
('Adam', 'Fantilli', '2004-10-12', TIMESTAMPDIFF(YEAR, '2004-10-12', CURDATE()), 'F', '2026-06-30', 950000, 'RFA', 10),
('Dmitri', 'Voronkov', '1999-09-10', TIMESTAMPDIFF(YEAR, '1999-09-10', CURDATE()), 'F', '2025-06-30', 925000, 'RFA', 10),
('Zachary', 'Werenski', '1997-07-19', TIMESTAMPDIFF(YEAR, '1997-07-19', CURDATE()), 'D', '2028-06-30', 9583333, 'UFA', 10),
('Damon', 'Severson', '1994-08-07', TIMESTAMPDIFF(YEAR, '1994-08-07', CURDATE()), 'D', '2031-06-30', 6250000, 'UFA', 10),
('Ivan', 'Provorov', '1997-01-13', TIMESTAMPDIFF(YEAR, '1997-01-13', CURDATE()), 'D', '2025-06-30', 4725000, 'UFA', 10),
('Erik', 'Gudbranson', '1992-01-07', TIMESTAMPDIFF(YEAR, '1992-01-07', CURDATE()), 'D', '2026-06-30', 4000000, 'UFA', 10),
('Adam', 'Boqvist', '2000-08-15', TIMESTAMPDIFF(YEAR, '2000-08-15', CURDATE()), 'D', '2025-06-30', 2600000, 'RFA', 10),
('Elvis', 'Merzlikins', '1994-04-13', TIMESTAMPDIFF(YEAR, '1994-04-13', CURDATE()), 'G', '2027-06-30', 5400000, 'UFA', 10),
('Daniil', 'Tarasov', '1999-03-27', TIMESTAMPDIFF(YEAR, '1999-03-27', CURDATE()), 'G', '2025-06-30', 1050000, 'RFA', 10);

-- INSERT ADDITION OF COLUMBUS PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Yegor', 'Chinakhov', '2001-02-01', TIMESTAMPDIFF(YEAR, '2001-02-01', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 10),
('Kirill', 'Marchenko', '2000-07-21', TIMESTAMPDIFF(YEAR, '2000-07-21', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 10),
('Alexander', 'Nylander', '1998-03-02', TIMESTAMPDIFF(YEAR, '1998-03-02', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 10),
('Cole', 'Sillinger', '2003-05-16', TIMESTAMPDIFF(YEAR, '2003-05-16', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 10),
('Alexandre', 'Texier', '1999-09-13', TIMESTAMPDIFF(YEAR, '1999-09-13', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 10),
('Carson', 'Meyer', '1997-08-26', TIMESTAMPDIFF(YEAR, '1997-08-26', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 10),
('Jake', 'Bean', '1998-06-09', TIMESTAMPDIFF(YEAR, '1998-06-09', CURDATE()), 'D', '2024-06-30', 0, 'RFA', 10),
('Kent', 'Johnson', '2002-10-18', TIMESTAMPDIFF(YEAR, '2002-10-18', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 10);

-- INSERT COLUMBUS BUYOUT
INSERT INTO buyout (first_name, last_name, buyout_end_date, buyout_value, franchise_id) VALUES
('Alexander', 'Wennberg', '2025-06-30', 891667, 10);

-- INSERT DEVILS PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Timo', 'Meier', '1996-10-08', TIMESTAMPDIFF(YEAR, '1996-10-08', CURDATE()), 'W', '2031-06-30', 8800000, 'UFA', 11),
('Jack', 'Hughes', '2001-05-14', TIMESTAMPDIFF(YEAR, '2001-05-14', CURDATE()), 'F', '2030-06-30', 8000000, 'UFA', 11),
('Jesper', 'Bratt', '1998-07-30', TIMESTAMPDIFF(YEAR, '1998-07-30', CURDATE()), 'W', '2031-06-30', 7875000, 'UFA', 11),
('Nico', 'Hischier', '1999-01-04', TIMESTAMPDIFF(YEAR, '1999-01-04', CURDATE()), 'F', '2027-06-30', 7250000, 'UFA', 11),
('Ondrej', 'Palat', '1991-03-28', TIMESTAMPDIFF(YEAR, '1991-03-28', CURDATE()), 'W', '2027-06-30', 6000000, 'UFA', 11),
('Erik', 'Haula', '1991-03-23', TIMESTAMPDIFF(YEAR, '1991-03-23', CURDATE()), 'F', '2026-06-30', 3150000, 'UFA', 11),
('Curtis', 'Lazar', '1995-02-02', TIMESTAMPDIFF(YEAR, '1995-02-02', CURDATE()), 'F', '2025-06-30', 1000000, 'UFA', 11),
('Alexander', 'Holtz', '2002-01-23', TIMESTAMPDIFF(YEAR, '2002-01-23', CURDATE()), 'W', '2025-06-30', 894167, 'RFA', 11),
('Dougie', 'Hamilton', '1993-06-17', TIMESTAMPDIFF(YEAR, '1993-06-17', CURDATE()), 'D', '2028-06-30', 9000000, 'UFA', 11),
('Nathan', 'Bastian', '1997-12-06', TIMESTAMPDIFF(YEAR, '1997-12-06', CURDATE()), 'W', '2025-06-30', 1350000, 'UFA', 11),
('John', 'Marino', '1997-05-21', TIMESTAMPDIFF(YEAR, '1997-05-21', CURDATE()), 'D', '2027-06-30', 4400000, 'UFA', 11),
('Jonas', 'Siegenthaler', '1997-05-06', TIMESTAMPDIFF(YEAR, '1997-05-06', CURDATE()), 'D', '2028-06-30', 3400000, 'UFA', 11),
('Kurtis', 'MacDermid', '1994-03-25', TIMESTAMPDIFF(YEAR, '1994-03-25', CURDATE()), 'D', '2027-06-30', 1150000, 'UFA', 11),
('Kevin', 'Bahl', '2000-06-27', TIMESTAMPDIFF(YEAR, '2000-06-27', CURDATE()), 'D', '2025-06-30', 1050000, 'RFA', 11),
('Luke', 'Hughes', '2003-09-09', TIMESTAMPDIFF(YEAR, '2003-09-09', CURDATE()), 'D', '2025-06-30', 925000, 'RFA', 11),
('Simon', 'Nemec', '2004-02-15', TIMESTAMPDIFF(YEAR, '2004-02-15', CURDATE()), 'D', '2026-06-30', 918333, 'RFA', 11),
('Jake', 'Allen', '1990-08-07', TIMESTAMPDIFF(YEAR, '1990-08-07', CURDATE()), 'G', '2025-06-30', 1925000, 'UFA', 11);


-- INSERT ADDITION OF DEVILS PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Nolan', 'Foote', '2000-11-29', TIMESTAMPDIFF(YEAR, '2000-11-29', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 11),
('Dawson', 'Mercer', '2001-10-27', TIMESTAMPDIFF(YEAR, '2001-10-27', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 11),
('Tomas', 'Nosek', '1992-09-01', TIMESTAMPDIFF(YEAR, '1992-09-01', CURDATE()), 'F', '2024-06-30', 0, 'UFA', 11),
('Chris', 'Tierney', '1994-07-01', TIMESTAMPDIFF(YEAR, '1994-07-01', CURDATE()), 'F', '2024-06-30', 0, 'UFA', 11),
('Nick', 'DeSimone', '1994-11-21', TIMESTAMPDIFF(YEAR, '1994-11-21', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 11),
('Brendan', 'Smith', '1989-02-08', TIMESTAMPDIFF(YEAR, '1989-02-08', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 11),
('Kaapo', 'Kähkönen', '1996-08-16', TIMESTAMPDIFF(YEAR, '1996-08-16', CURDATE()), 'G', '2024-06-30', 0, 'UFA', 11);


-- INSERT DEVILS BUYOUT
INSERT INTO buyout (first_name, last_name, buyout_end_date, buyout_value, franchise_id) VALUES
('Ilya', 'Kovalchuk', '2025-06-30', 250000, 11);

-- INSERT ISLANDERS PLAYERS
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Mathew', 'Barzal', '1997-05-26', TIMESTAMPDIFF(YEAR, '1997-05-26', CURDATE()), 'F', '2031-06-30', 9150000, 'UFA', 12),
('Bo', 'Horvat', '1995-04-05', TIMESTAMPDIFF(YEAR, '1995-04-05', CURDATE()), 'F', '2031-06-30', 8500000, 'UFA', 12),
('Anders', 'Lee', '1990-07-03', TIMESTAMPDIFF(YEAR, '1990-07-03', CURDATE()), 'W', '2026-06-30', 7000000, 'UFA', 12),
('Brock', 'Nelson', '1991-10-15', TIMESTAMPDIFF(YEAR, '1991-10-15', CURDATE()), 'F', '2025-06-30', 6000000, 'UFA', 12),
('Jean-Gabriel', 'Pageau', '1992-11-11', TIMESTAMPDIFF(YEAR, '1992-11-11', CURDATE()), 'F', '2026-06-30', 5000000, 'UFA', 12),
('Kyle', 'Palmieri', '1991-02-01', TIMESTAMPDIFF(YEAR, '1991-02-01', CURDATE()), 'W', '2025-06-30', 5000000, 'UFA', 12),
('Pierre', 'Engvall', '1996-05-31', TIMESTAMPDIFF(YEAR, '1996-05-31', CURDATE()), 'W', '2030-06-30', 3000000, 'UFA', 12),
('Casey', 'Cizikas', '1991-02-27', TIMESTAMPDIFF(YEAR, '1991-02-27', CURDATE()), 'F', '2027-06-30', 2500000, 'UFA', 12),
('Julien', 'Gauthier', '1997-10-15', TIMESTAMPDIFF(YEAR, '1997-10-15', CURDATE()), 'W', '2025-06-30', 787500, 'UFA', 12),
('Hudson', 'Fasching', '1995-07-28', TIMESTAMPDIFF(YEAR, '1995-07-28', CURDATE()), 'W', '2025-06-30', 775000, 'UFA', 12),
('Ryan', 'Pulock', '1994-10-06', TIMESTAMPDIFF(YEAR, '1994-10-06', CURDATE()), 'D', '2030-06-30', 6150000, 'UFA', 12),
('Adam', 'Pelech', '1994-08-16', TIMESTAMPDIFF(YEAR, '1994-08-16', CURDATE()), 'D', '2029-06-30', 5750000, 'UFA', 12),
('Noah', 'Dobson', '2000-01-07', TIMESTAMPDIFF(YEAR, '2000-01-07', CURDATE()), 'D', '2025-06-30', 4000000, 'RFA', 12),
('Alexander', 'Romanov', '2000-01-06', TIMESTAMPDIFF(YEAR, '2000-01-06', CURDATE()), 'D', '2025-06-30', 2500000, 'RFA', 12),
('Samuel', 'Bolduc', '2000-12-09', TIMESTAMPDIFF(YEAR, '2000-12-09', CURDATE()), 'D', '2025-06-30', 800000, 'RFA', 12),
('Scott', 'Mayfield', '1992-10-14', TIMESTAMPDIFF(YEAR, '1992-10-14', CURDATE()), 'D', '2030-06-30', 3500000, 'UFA', 12),
('Ilya', 'Sorokin', '1995-08-04', TIMESTAMPDIFF(YEAR, '1995-08-04', CURDATE()), 'G', '2032-06-30', 8250000, 'UFA', 12),
('Semyon', 'Varlamov', '1988-04-27', TIMESTAMPDIFF(YEAR, '1988-04-27', CURDATE()), 'G', '2027-06-30', 2750000, 'UFA', 12);

-- INSERT ADDITION OF ISLANDERS PLAYERS AT THE END OF THEIR CONTRACT 
INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Simon', 'Holmström', '2000-05-24', TIMESTAMPDIFF(YEAR, '2000-05-24', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 12),
('Ruslan', 'Iskhakov', '2000-08-10', TIMESTAMPDIFF(YEAR, '2000-08-10', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 12),
('Kyle', 'MacLean', '1998-04-29', TIMESTAMPDIFF(YEAR, '1998-04-29', CURDATE()), 'F', '2024-06-30', 0, 'RFA', 12),
('Oliver', 'Wahlstrom', '2000-06-13', TIMESTAMPDIFF(YEAR, '2000-06-13', CURDATE()), 'W', '2024-06-30', 0, 'RFA', 12),
('Cal', 'Clutterbuck', '1987-11-18', TIMESTAMPDIFF(YEAR, '1987-11-18', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 12),
('Karson', 'Kuhlman', '1995-09-26', TIMESTAMPDIFF(YEAR, '1995-09-26', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 12),
('Matt', 'Martin', '1989-05-08', TIMESTAMPDIFF(YEAR, '1989-05-08', CURDATE()), 'W', '2024-06-30', 0, 'UFA', 12),
('Brian', 'Pinho', '1995-05-11', TIMESTAMPDIFF(YEAR, '1995-05-11', CURDATE()), 'F', '2024-06-30', 0, 'UFA', 12),
('Dennis', 'Cholowski', '1998-02-15', TIMESTAMPDIFF(YEAR, '1998-02-15', CURDATE()), 'D', '2024-06-30', 0, 'RFA', 12),
('Sebastian', 'Aho', '1996-02-17', TIMESTAMPDIFF(YEAR, '1996-02-17', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 12),
('Robert', 'Bortuzzo', '1989-03-18', TIMESTAMPDIFF(YEAR, '1989-03-18', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 12),
('Mike', 'Reilly', '1993-07-13', TIMESTAMPDIFF(YEAR, '1993-07-13', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 12),
('Robin', 'Salo', '1998-10-13', TIMESTAMPDIFF(YEAR, '1998-10-13', CURDATE()), 'D', '2024-06-30', 0, 'UFA', 12);

select * from franchises;