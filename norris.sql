DROP TABLE IF EXISTS websites;
DROP TABLE IF EXISTS vulnerabilities;
DROP TABLE IF EXISTS points_of_interest;
DROP TABLE IF EXISTS website_point_of_interest;
DROP TABLE IF EXISTS point_of_interest_vulnerability;
DROP TABLE IF EXISTS website_vulnerabilities;

CREATE TABLE websites (
    id INT(11) PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE vulnerabilities (
    id INT(11) PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(255) NOT NULL,
    input VARCHAR(255) NOT NULL
);

CREATE TABLE points_of_interest (
    id INT(11) PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(255) NOT NULL
);

CREATE TABLE website_point_of_interest (
    website_id INT(11),
    point_of_interest_id INT(11),
    PRIMARY KEY (website_id, point_of_interest_id)
);

CREATE TABLE point_of_interest_vulnerability (
    point_of_interest_id INT(11),
    vulnerability_id INT(11),
    PRIMARY KEY (point_of_interest_id, vulnerability_id)
);

CREATE TABLE website_vulnerabilites (
    website_id INT(11),
    vulnerability_id INT(11),
    PRIMARY KEY (website_id, vulnerability_id)
);