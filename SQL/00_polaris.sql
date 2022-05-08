#### Enabling this line is *inadvisable*.
# DROP DATABASE IF EXISTS polaris;

#### Enabling these lines is for testing.
#### Create a user with better credentials or suffer.
# DROP USER IF EXISTS 'polaris'@'%';
# CREATE USER 'polaris'@'%' IDENTIFIED BY 'polaris';
# GRANT ALL PRIVILEGES ON polaris.* TO 'polaris'@'%';


#### Schema building begins here.
CREATE DATABASE IF NOT EXISTS polaris
	DEFAULT CHARSET=utf8mb4
	COLLATE=utf8mb4_unicode_520_ci;

USE polaris;


CREATE TABLE IF NOT EXISTS admin (
	id INT NOT NULL AUTO_INCREMENT,
	ckey VARCHAR(32) NOT NULL,
	rank VARCHAR(32) NOT NULL DEFAULT 'Administrator',
	level INT NOT NULL DEFAULT 0,
	flags INT NOT NULL DEFAULT 0,

	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS admin_log (
	id INT NOT NULL AUTO_INCREMENT,
	datetime DATETIME NOT NULL,
	adminckey VARCHAR(32) NOT NULL,
	adminip VARCHAR(18) NOT NULL,
	log TEXT NOT NULL,

	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS ban (
	id INT NOT NULL AUTO_INCREMENT,
	bantime DATETIME NOT NULL,
	serverip VARCHAR(18) NOT NULL,
	reason TEXT NOT NULL,
	job VARCHAR(32),
	duration INT NOT NULL,
	rounds INT,
	expiration_time DATETIME NOT NULL,
	ckey VARCHAR(32) NOT NULL,
	computerid VARCHAR(32) NOT NULL,
	ip VARCHAR(18) NOT NULL,
	a_ckey VARCHAR(32) NOT NULL,
	a_computerid VARCHAR(32) NOT NULL,
	a_ip VARCHAR(18) NOT NULL,
	who TEXT NOT NULL,
	adminwho TEXT NOT NULL,
	edits TEXT,
	unbanned BOOLEAN,
	unbanned_datetime DATETIME,
	unbanned_ckey VARCHAR(32),
	unbanned_computerid VARCHAR(32),
	unbanned_ip VARCHAR(18),

	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS feedback (
	id INT NOT NULL AUTO_INCREMENT,
	time DATETIME NOT NULL,
	round_id INT NOT NULL,
	var_name VARCHAR(32) NOT NULL,
	var_value INT,
	details TEXT,

	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS player (
	id INT NOT NULL AUTO_INCREMENT,
	ckey VARCHAR(32) NOT NULL,
	firstseen DATETIME NOT NULL,
	lastseen DATETIME NOT NULL,
	ip VARCHAR(18) NOT NULL,
	computerid VARCHAR(32) NOT NULL,
	lastadminrank VARCHAR(32) NOT NULL DEFAULT 'Player',

	PRIMARY KEY (id),
	UNIQUE (ckey)
);


CREATE TABLE IF NOT EXISTS poll_option (
	id INT NOT NULL AUTO_INCREMENT,
	pollid INT NOT NULL,
	text VARCHAR(255) NOT NULL,
	percentagecalc BOOLEAN NOT NULL DEFAULT 1,
	minval INT,
	maxval INT,
	descmin VARCHAR(32),
	descmid VARCHAR(32),
	descmax VARCHAR(32),

	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS poll_question (
	id INT NOT NULL AUTO_INCREMENT,
	polltype VARCHAR(16) NOT NULL DEFAULT 'OPTION',
	starttime DATETIME NOT NULL,
	endtime DATETIME NOT NULL,
	question VARCHAR(255) NOT NULL,
	adminonly BOOLEAN DEFAULT 0,

	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS poll_textreply (
	id INT NOT NULL AUTO_INCREMENT,
	datetime DATETIME NOT NULL,
	pollid INT NOT NULL,
	ckey VARCHAR(32) NOT NULL,
	ip VARCHAR(18) NOT NULL,
	replytext TEXT NOT NULL,
	adminrank VARCHAR(32) NOT NULL DEFAULT 'Player',

	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS poll_vote (
	id INT NOT NULL AUTO_INCREMENT,
	DATETIME DATETIME NOT NULL,
	pollid INT NOT NULL,
	optionid INT NOT NULL,
	ckey VARCHAR(32) NOT NULL,
	ip VARCHAR(18) NOT NULL,
	adminrank VARCHAR(32) NOT NULL,
	rating INT,

	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS privacy (
	id INT NOT NULL AUTO_INCREMENT,
	datetime DATETIME NOT NULL,
	ckey VARCHAR(32) NOT NULL,
	option VARCHAR(128) NOT NULL,

	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS death (
	id INT NOT NULL AUTO_INCREMENT,
	pod TEXT NOT NULL,
	coord TEXT NOT NULL,
	tod DATETIME NOT NULL,
	job TEXT NOT NULL,
	special TEXT NOT NULL,
	name TEXT NOT NULL,
	byondkey TEXT NOT NULL,
	laname TEXT NOT NULL,
	lakey TEXT NOT NULL,
	gender TEXT NOT NULL,
	bruteloss INT NOT NULL,
	brainloss INT NOT NULL,
	fireloss INT NOT NULL,
	oxyloss INT NOT NULL,

	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS library (
	id INT NOT NULL AUTO_INCREMENT,
	author TEXT NOT NULL,
	title TEXT NOT NULL,
	content TEXT NOT NULL,
	category TEXT NOT NULL,

	PRIMARY KEY (id)
);


CREATE TABLE if NOT EXISTS population (
	id INT NOT NULL AUTO_INCREMENT,
	time DATETIME NOT NULL,
	playercount INT,
	admincount INT,

	PRIMARY KEY (id)
);
