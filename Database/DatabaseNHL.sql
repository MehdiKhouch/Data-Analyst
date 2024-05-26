USE nhl;
CREATE TABLE franchises (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    city VARCHAR(25) NOT NULL,
    state VARCHAR(30),
    country VARCHAR(20) NOT NULL, 
    Salary_Cap int
);

ALTER TABLE franchises
ADD COLUMN conference ENUM('Est', 'West'),
ADD COLUMN division ENUM('Atlantic', 'Metropolitan', 'Central', 'Pacific');

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
    FOREIGN KEY (franchise_id) REFERENCES franchises(id)
);
CREATE TABLE free_agents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    age INT,
    position ENUM('F', 'W', 'D', 'G') NOT NULL,
    free_agent_status ENUM('UFA', 'RFA') NOT NULL
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
