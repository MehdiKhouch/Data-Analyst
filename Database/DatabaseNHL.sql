USE nhl;
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

CREATE TABLE buyout (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    buyout_end_date DATE,
    buyout_value DECIMAL(15, 2),
    
    franchise_id INT,
    FOREIGN KEY (franchise_id) REFERENCES franchises(franchise_id)
);

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
SET SQL_SAFE_UPDATES = 0;
UPDATE franchises
SET Salary_Cap = 87700000.00;
SET SQL_SAFE_UPDATES = 1;

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

CREATE TRIGGER after_buyout_delete 
AFTER DELETE ON buyout 
FOR EACH ROW 
BEGIN 
    UPDATE franchises 
    SET Salary_Cap = Salary_Cap + OLD.buyout_value 
    WHERE franchise_id = OLD.franchise_id; 
END $$

DELIMITER ;


INSERT INTO players (first_name, last_name, date_of_birth, age, position, contract_end_date, contract_value, free_agent_status, franchise_id) VALUES
('Brad', 'Marchand', '1988-05-11', TIMESTAMPDIFF(YEAR, '1988-05-11', CURDATE()), 'W', '2025-06-30', 6125000.00, 'UFA', 1),
('David', 'Pastrnak', '1996-05-25', TIMESTAMPDIFF(YEAR, '1996-05-25', CURDATE()), 'W', '2031-06-30', 11250000.00, 'UFA', 1),
('Pavel', 'Zacha', '1997-04-06', TIMESTAMPDIFF(YEAR, '1997-04-06', CURDATE()), 'F', '2027-06-30', 4750000.00, 'UFA', 1),
('Taylor', 'Hall', '1991-11-14', TIMESTAMPDIFF(YEAR, '1991-11-14', CURDATE()), 'W', '2025-06-30', 6000000.00, 'UFA', 17),
('Charlie', 'Coyle', '1992-03-02', TIMESTAMPDIFF(YEAR, '1992-03-02', CURDATE()), 'F', '2026-06-30', 5250000.00, 'UFA', 1),
('Nick', 'Foligno', '1987-10-31', TIMESTAMPDIFF(YEAR, '1987-10-31', CURDATE()), 'W', '2026-06-30', 4500000.00, 'UFA', 17),
('Trent', 'Frederic', '1998-02-11', TIMESTAMPDIFF(YEAR, '1998-02-11', CURDATE()), 'F', '2025-06-30', 2300000.00, 'UFA', 1),
('Connor', 'Clifton', '1995-04-28', TIMESTAMPDIFF(YEAR, '1995-04-28', CURDATE()), 'D', '2026-06-30', 3333333.00, 'UFA', 4),
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

INSERT INTO buyout (first_name, last_name, buyout_end_date, buyout_value, franchise_id) VALUES
('Mike', 'Reilly', '2025-06-30', 1333334.00, 1);
