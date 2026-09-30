CREATE DATABASE IF NOT EXISTS spread_db;
USE spread_db;

-- =========================================================
-- LOCATIONS
-- Farms, processors, distribution centers, restaurants, etc.
-- =========================================================

CREATE TABLE locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL,
    location_type VARCHAR(50) NOT NULL,
    address VARCHAR(150),
    city VARCHAR(75),
    state CHAR(2),
    zip_code VARCHAR(10),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);


-- =========================================================
-- FOOD PRODUCTS
-- General food/product information
-- =========================================================

CREATE TABLE food_products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    food_type VARCHAR(50) NOT NULL
);


-- =========================================================
-- LOTS
-- A specific production lot of a food product
-- =========================================================

CREATE TABLE lots (
    lot_id INT AUTO_INCREMENT PRIMARY KEY,
    lot_code VARCHAR(50) NOT NULL UNIQUE,
    product_id INT NOT NULL,
    production_location_id INT NOT NULL,
    production_date DATE NOT NULL,
    expiration_date DATE,
    quantity_produced INT,

    FOREIGN KEY (product_id)
        REFERENCES food_products(product_id),

    FOREIGN KEY (production_location_id)
        REFERENCES locations(location_id)
);


-- =========================================================
-- SHIPMENTS
-- Represents movement between two locations
-- =========================================================

CREATE TABLE shipments (
    shipment_id INT AUTO_INCREMENT PRIMARY KEY,
    origin_location_id INT NOT NULL,
    destination_location_id INT NOT NULL,
    ship_date DATE NOT NULL,
    arrival_date DATE,
    shipment_status VARCHAR(30),

    FOREIGN KEY (origin_location_id)
        REFERENCES locations(location_id),

    FOREIGN KEY (destination_location_id)
        REFERENCES locations(location_id)
);


-- =========================================================
-- SHIPMENT ITEMS
-- Allows one shipment to contain multiple lots
-- and one lot to appear in multiple shipments
-- =========================================================

CREATE TABLE shipment_items (
    shipment_item_id INT AUTO_INCREMENT PRIMARY KEY,
    shipment_id INT NOT NULL,
    lot_id INT NOT NULL,
    quantity_shipped INT NOT NULL,

    FOREIGN KEY (shipment_id)
        REFERENCES shipments(shipment_id),

    FOREIGN KEY (lot_id)
        REFERENCES lots(lot_id)
);


-- =========================================================
-- PATHOGENS
-- Includes bacteria, viruses, parasites, etc.
-- =========================================================

CREATE TABLE pathogens (
    pathogen_id INT AUTO_INCREMENT PRIMARY KEY,
    pathogen_name VARCHAR(100) NOT NULL,
    pathogen_type VARCHAR(30) NOT NULL,
    description VARCHAR(255)
);


-- =========================================================
-- LAB TESTS
-- Records tests performed on food lots
-- =========================================================

CREATE TABLE lab_tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    lot_id INT NOT NULL,
    location_id INT,
    pathogen_id INT NOT NULL,
    sample_type VARCHAR(50),
    test_date DATE NOT NULL,
    result VARCHAR(20) NOT NULL,
    notes VARCHAR(255),

    FOREIGN KEY (lot_id)
        REFERENCES lots(lot_id),

    FOREIGN KEY (location_id)
        REFERENCES locations(location_id),

    FOREIGN KEY (pathogen_id)
        REFERENCES pathogens(pathogen_id)
);

show databases;
show tables from spread_db;

# db established with tables

-- =========================================================
-- SAMPLE LOCATIONS
-- =========================================================

INSERT INTO locations
(location_name, location_type, city, state)
VALUES
('Green Valley Farm', 'Farm', 'Shelbyville', 'TN'),
('Central Food Processing', 'Processor', 'Murfreesboro', 'TN'),
('Nashville Distribution Center', 'Distribution Center', 'Nashville', 'TN'),
('Downtown Market', 'Grocery Store', 'Nashville', 'TN'),
('Riverfront Grill', 'Restaurant', 'Nashville', 'TN');


-- =========================================================
-- SAMPLE PRODUCTS
-- =========================================================

INSERT INTO food_products
(product_name, food_type)
VALUES
('Whole Milk', 'Dairy'),
('Cheddar Cheese', 'Dairy'),
('Ground Beef', 'Meat');


-- =========================================================
-- SAMPLE LOTS
-- =========================================================

INSERT INTO lots
(lot_code, product_id, production_location_id,
 production_date, expiration_date, quantity_produced)
VALUES
(
    'MILK-2026-001',
    1,
    1,
    '2026-09-01',
    '2026-09-15',
    5000
),
(
    'CHEESE-2026-001',
    2,
    2,
    '2026-09-03',
    '2026-12-03',
    2000
);


-- =========================================================
-- SAMPLE SHIPMENTS
-- =========================================================

INSERT INTO shipments
(origin_location_id, destination_location_id,
 ship_date, arrival_date, shipment_status)
VALUES
(1, 2, '2026-09-01', '2026-09-01', 'Delivered'),

(2, 3, '2026-09-04', '2026-09-04', 'Delivered'),

(3, 4, '2026-09-05', '2026-09-05', 'Delivered'),

(3, 5, '2026-09-05', '2026-09-05', 'Delivered');


-- =========================================================
-- ASSOCIATE LOTS WITH SHIPMENTS
-- =========================================================

INSERT INTO shipment_items
(shipment_id, lot_id, quantity_shipped)
VALUES
(1, 1, 1000),
(2, 2, 800),
(3, 2, 300),
(4, 2, 250);

# sample synthetic data

INSERT INTO pathogens
(pathogen_name, pathogen_type, description)
VALUES
(
    'Salmonella enterica',
    'Bacterium',
    'A common cause of foodborne illness.'
),
(
    'Listeria monocytogenes',
    'Bacterium',
    'A foodborne pathogen associated with serious infections.'
),
(
    'Norovirus',
    'Virus',
    'A highly contagious virus that can cause gastroenteritis.'
);

# pathogens

INSERT INTO lab_tests
(
    lot_id,
    location_id,
    pathogen_id,
    sample_type,
    test_date,
    result,
    notes
)
VALUES
(
    2,
    3,
    2,
    'Food Sample',
    '2026-09-07',
    'Positive',
    'Synthetic positive test for demonstration purposes.'
);

# test lab discovery

SELECT
    l.lot_code,
    fp.product_name,
    origin.location_name AS origin,
    destination.location_name AS destination,
    s.ship_date,
    si.quantity_shipped
FROM lots l
JOIN food_products fp
    ON l.product_id = fp.product_id
JOIN shipment_items si
    ON l.lot_id = si.lot_id
JOIN shipments s
    ON si.shipment_id = s.shipment_id
JOIN locations origin
    ON s.origin_location_id = origin.location_id
JOIN locations destination
    ON s.destination_location_id = destination.location_id
WHERE l.lot_code = 'CHEESE-2026-001';

# sample contamination

SELECT
    lt.test_id,
    l.lot_code,
    fp.product_name,
    p.pathogen_name,
    loc.location_name,
    lt.test_date,
    lt.result
FROM lab_tests lt
JOIN lots l
    ON lt.lot_id = l.lot_id
JOIN food_products fp
    ON l.product_id = fp.product_id
JOIN pathogens p
    ON lt.pathogen_id = p.pathogen_id
LEFT JOIN locations loc
    ON lt.location_id = loc.location_id
WHERE lt.result = 'Positive';

# search for pathogens

CREATE TABLE illness_reports (
    illness_id INT AUTO_INCREMENT PRIMARY KEY,
    report_date DATE NOT NULL,
    onset_date DATE,
    symptoms VARCHAR(255),
    hospitalized BOOLEAN DEFAULT FALSE,
    outcome VARCHAR(50),
    pathogen_id INT,

    FOREIGN KEY (pathogen_id)
        REFERENCES pathogens(pathogen_id)
);

CREATE TABLE exposures (
    exposure_id INT AUTO_INCREMENT PRIMARY KEY,
    illness_id INT NOT NULL,
    location_id INT NOT NULL,
    product_id INT,
    exposure_date DATE,
    notes VARCHAR(255),

    FOREIGN KEY (illness_id)
        REFERENCES illness_reports(illness_id),

    FOREIGN KEY (location_id)
        REFERENCES locations(location_id),

    FOREIGN KEY (product_id)
        REFERENCES food_products(product_id)
);

CREATE TABLE recalls (
    recall_id INT AUTO_INCREMENT PRIMARY KEY,
    recall_date DATE NOT NULL,
    reason VARCHAR(255),
    status VARCHAR(50)
);

CREATE TABLE recall_items (
    recall_item_id INT AUTO_INCREMENT PRIMARY KEY,
    recall_id INT NOT NULL,
    lot_id INT NOT NULL,
    quantity_affected INT,

    FOREIGN KEY (recall_id)
        REFERENCES recalls(recall_id),

    FOREIGN KEY (lot_id)
        REFERENCES lots(lot_id)
);

# creating outbreak search

SELECT
    ir.illness_id,
    ir.onset_date,
    p.pathogen_name,
    loc.location_name,
    fp.product_name,
    e.exposure_date
FROM illness_reports ir
JOIN exposures e
    ON ir.illness_id = e.illness_id
JOIN locations loc
    ON e.location_id = loc.location_id
LEFT JOIN food_products fp
    ON e.product_id = fp.product_id
LEFT JOIN pathogens p
    ON ir.pathogen_id = p.pathogen_id;
    
# pathogen selection

SELECT
    fp.product_name,
    l.lot_code,
    destination.location_name,
    COUNT(DISTINCT ir.illness_id) AS reported_illnesses
FROM illness_reports ir
JOIN exposures e
    ON ir.illness_id = e.illness_id
JOIN food_products fp
    ON e.product_id = fp.product_id
JOIN lots l
    ON fp.product_id = l.product_id
JOIN shipment_items si
    ON l.lot_id = si.lot_id
JOIN shipments s
    ON si.shipment_id = s.shipment_id
JOIN locations destination
    ON s.destination_location_id = destination.location_id
WHERE destination.location_id = e.location_id
GROUP BY
    fp.product_name,
    l.lot_code,
    destination.location_name;
    
# investigation query


# sample queries for presentation purposes

SELECT
    l.lot_code,
    fp.product_name,
    p.pathogen_name,
    lt.test_date,
    lt.result
FROM lab_tests lt
JOIN lots l
    ON lt.lot_id = l.lot_id
JOIN food_products fp
    ON l.product_id = fp.product_id
JOIN pathogens p
    ON lt.pathogen_id = p.pathogen_id
WHERE lt.result = 'Positive';

# identifies the contaminated lot, next

SELECT
    l.lot_code,
    origin.location_name AS origin,
    destination.location_name AS destination,
    s.ship_date,
    si.quantity_shipped
FROM lots l
JOIN shipment_items si
    ON l.lot_id = si.lot_id
JOIN shipments s
    ON si.shipment_id = s.shipment_id
JOIN locations origin
    ON s.origin_location_id = origin.location_id
JOIN locations destination
    ON s.destination_location_id = destination.location_id
WHERE l.lot_code = 'CHEESE-2026-001';

# where it went, then

INSERT INTO illness_reports
(report_date, onset_date, symptoms, hospitalized, outcome, pathogen_id)
VALUES
('2026-09-08', '2026-09-06', 'Fever, nausea, stomach cramps', FALSE, 'Recovered', 2),
('2026-09-09', '2026-09-07', 'Fever, diarrhea, fatigue', TRUE, 'Recovered', 2),
('2026-09-10', '2026-09-08', 'Nausea, vomiting', FALSE, 'Recovered', NULL);

INSERT INTO exposures
(illness_id, location_id, product_id, exposure_date, notes)
VALUES
(1, 5, 2, '2026-09-04', 'Ate cheddar cheese at Riverfront Grill'),
(2, 4, 2, '2026-09-05', 'Purchased cheddar cheese at Downtown Market'),
(3, 5, NULL, '2026-09-06', 'Ate at Riverfront Grill; exact product unknown');

SELECT
    ir.illness_id,
    ir.onset_date,
    loc.location_name,
    fp.product_name,
    p.pathogen_name
FROM illness_reports ir
JOIN exposures e
    ON ir.illness_id = e.illness_id
JOIN locations loc
    ON e.location_id = loc.location_id
LEFT JOIN food_products fp
    ON e.product_id = fp.product_id
LEFT JOIN pathogens p
    ON ir.pathogen_id = p.pathogen_id
ORDER BY ir.onset_date;

SELECT
    ir.illness_id,
    ir.onset_date,
    loc.location_name,
    fp.product_name,
    p.pathogen_name
FROM illness_reports ir
JOIN exposures e
    ON ir.illness_id = e.illness_id
JOIN locations loc
    ON e.location_id = loc.location_id
LEFT JOIN food_products fp
    ON e.product_id = fp.product_id
LEFT JOIN pathogens p
    ON ir.pathogen_id = p.pathogen_id
ORDER BY ir.onset_date;

# who got ill