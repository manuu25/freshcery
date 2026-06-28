-- Freshcery — PostgreSQL schema + seed data
-- Converted from the MySQL dump (freshcery.sql) for deployment on Render Postgres.
-- Safe to run multiple times: it drops and recreates the tables.

DROP TABLE IF EXISTS admins, cart, categories, orders, products, users CASCADE;

CREATE TABLE admins (
  id         SERIAL PRIMARY KEY,
  adminname  VARCHAR(200) NOT NULL,
  email      VARCHAR(200) NOT NULL,
  mypassword VARCHAR(200) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cart (
  id           SERIAL PRIMARY KEY,
  pro_id       INTEGER NOT NULL,
  pro_title    VARCHAR(200) NOT NULL,
  pro_image    VARCHAR(200) NOT NULL,
  pro_price    INTEGER NOT NULL,
  pro_qty      INTEGER NOT NULL,
  pro_subtotal INTEGER NOT NULL,
  user_id      INTEGER NOT NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(200) NOT NULL,
  image       VARCHAR(200) NOT NULL,
  icon        VARCHAR(200) NOT NULL,
  description VARCHAR(200) NOT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
  id           SERIAL PRIMARY KEY,
  name         VARCHAR(200) NOT NULL,
  lname        VARCHAR(200) NOT NULL,
  company_name VARCHAR(200) NOT NULL,
  address      VARCHAR(200) NOT NULL,
  city         VARCHAR(200) NOT NULL,
  country      VARCHAR(200) NOT NULL,
  zip_code     BIGINT NOT NULL,
  email        VARCHAR(200) NOT NULL,
  phone_number BIGINT NOT NULL,
  order_notes  TEXT NOT NULL,
  status       VARCHAR(200) NOT NULL DEFAULT 'sent to admins',
  price        INTEGER NOT NULL,
  user_id      INTEGER NOT NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  id          SERIAL PRIMARY KEY,
  title       VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  price       VARCHAR(10) NOT NULL,
  quantity    INTEGER NOT NULL DEFAULT 1,
  image       VARCHAR(200) NOT NULL,
  exp_date    VARCHAR(200) NOT NULL,
  category_id INTEGER NOT NULL,
  status      INTEGER NOT NULL DEFAULT 1,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
  id           SERIAL PRIMARY KEY,
  fullname     VARCHAR(200) NOT NULL,
  email        VARCHAR(200) NOT NULL,
  username     VARCHAR(200) NOT NULL,
  mypassword   VARCHAR(200) NOT NULL,
  image        VARCHAR(200) NOT NULL,
  address      TEXT DEFAULT NULL,
  city         VARCHAR(200) DEFAULT NULL,
  country      VARCHAR(200) DEFAULT NULL,
  zip_code     VARCHAR(10) DEFAULT NULL,
  phone_number VARCHAR(30) DEFAULT NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- Seed data
--

INSERT INTO admins (id, adminname, email, mypassword, created_at) VALUES
(1, 'admin.first', 'admin.first@gmail.com', '$2y$10$EvaSGxbY90rOqk0fkdvmoOJToy5s4oVfZlJzph..4vqQT4jpPCDHS', '2022-12-12 11:33:37'),
(2, 'admin.second', 'admin.second@gmail.com', '$2y$10$nEx02PaHMHQaKPoosW8nQeMunZopWa7K.UAh6onmxgw4GldIEYDG.', '2022-12-12 12:10:05');

INSERT INTO categories (id, name, image, icon, description, created_at) VALUES
(1, 'VEGETABLES', 'vegetables.jpg', 'bistro-carrot', 'Rapidiously foster exceptional alignments for plug-and-play interfaces. Progressively expedite cross-platform core competencies vis-a-vis cross-media', '2022-12-07 12:11:04'),
(2, 'MEATS', 'meats.jpg', 'bistro-roast-leg', 'Rapidiously foster exceptional alignments for plug-and-play interfaces. Progressively expedite cross-platform core competencies vis-a-vis cross-media', '2022-12-07 12:11:04'),
(3, 'FISHES', 'fish.jpg', 'bistro-fish-1', 'Continually reintermediate impactful web-readiness with enabled catalysts for change. Globally synthesize go forward information for sustainable ', '2022-12-07 13:15:14'),
(4, 'FRUITS', 'fruits.jpg', 'bistro-apple', 'Continually reintermediate impactful web-readiness with enabled catalysts for change. Globally synthesize go forward information for sustainable ', '2022-12-07 13:15:14');

INSERT INTO orders (id, name, lname, company_name, address, city, country, zip_code, email, phone_number, order_notes, status, price, user_id, created_at) VALUES
(5, 'Mohamed', 'Hassan', 'web coding', 'Appropriately recaptiualize professional metrics vis-a-vis reliable core competencies. Monotonectally initiate performance based models after real-time', 'Cairo', 'Egypt', 3232332, 'user1@user.com', 223321323, 'Appropriately recaptiualize professional metrics vis-a-vis reliable core competencies. Monotonectally initiate performance based models after real-time', 'sent to admins', 110, 1, '2022-12-14 12:47:47');

INSERT INTO products (id, title, description, price, quantity, image, exp_date, category_id, status, created_at) VALUES
(1, 'VEGETABLES', 'Collaboratively extend collaborative ROI after client-centric metrics. Energistically enhance scalable scenarios whereas long-term high-impact architectures. Uniquely formulate leading-edge experiences through installed base technology. Quickly pontificate focused data after cutting-edge', '10', 1, 'vegetables.jpg', '2025', 1, 1, '2022-12-07 14:07:43'),
(2, 'MEATS', 'Enthusiastically enable competitive e-business rather than efficient total linkage. Professionally predominate superior infrastructures with unique technology. Assertively plagiarize premium communities vis-a-vis professional channels. ', '40', 1, 'meats.jpg', '2023', 2, 1, '2022-12-07 14:07:43'),
(3, 'FISHES', 'Interactively predominate cross-media web services and leveraged e-tailers. Authoritatively drive visionary leadership without resource maximizing value. Credibly transform an expanded array of architectures for compelling results. ', '50', 1, 'fish.jpg', '2024', 3, 1, '2022-12-07 15:30:26'),
(4, 'FRUITS', 'Uniquely incentivize real-time services through e-business intellectual capital. Dramatically recaptiualize global internal or "organic" sources after timely schemas. Progressively network cross ', '40', 1, 'fruits.jpg', '2024', 4, 1, '2022-12-07 15:30:26'),
(5, 'meat loaf', 'Quickly administrate viral best practices without out-of-the-box benefits. Competently formulate bleeding-edge metrics without flexible niche markets. Conveniently customize leveraged networks via orthogonal convergence. Appropriately ', '30', 1, 'meats.jpg', '2024', 2, 1, '2022-12-08 09:24:54'),
(6, 'tomatos', 'Globally coordinate cross-media e-tailers vis-a-vis quality methodologies. Efficiently parallel task competitive synergy after ubiquitous metrics. Efficiently synthesize cost effective core ', '10', 1, 'vegetables.jpg', '2024', 1, 1, '2022-12-08 09:32:32');

INSERT INTO users (id, fullname, email, username, mypassword, image, address, city, country, zip_code, phone_number, created_at) VALUES
(1, 'Mohamed Hassan', 'mohame@gmail.com', 'Mohamed Hassan', '$2y$10$EvaSGxbY90rOqk0fkdvmoOJToy5s4oVfZlJzph..4vqQT4jpPCDHS', 'user.png', 'Rapidiously extend diverse models before one-to-one architectures. Phosfluorescently envisioneer impactful users rather than corporate action ite', 'berlin', 'Germany', '3333322111', '3333322111', '2022-12-04 14:57:34'),
(2, 'joe doe', 'joe@gmail.com', 'joe@gmail.com', '$2y$10$tRmAQOgx4m8KGIHTAUDd/u3BPsYH1LJZnGlxXouTdsbkBEfa.uM3O', 'user.png', '', '', '', '0', '0', '2022-12-04 14:58:52'),
(50, 'web coding', 'web@gmail.com', 'web@gmail.com', '$2y$10$kJnCoRMo9O147I/UXh.ZQutUs7vLp9p8eBchUaT5Schm9pVGUc/4e', 'user.png', '', '', '', '0', '0', '2022-12-06 15:08:09'),
(51, 'user@gmail.com', 'user@gmail.com', 'user@gmail.com', '$2y$10$fBD2JqjhcoGv/uHxtFDFvuT79OpPRQKAa.6GdsEYt4lNX6ExbsfHy', 'user.png', '', '', '', '0', '0', '2022-12-06 15:09:35');

--
-- Re-sync SERIAL sequences so future auto-generated ids don't collide with seeds
--
SELECT setval('admins_id_seq',     (SELECT MAX(id) FROM admins));
SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories));
SELECT setval('orders_id_seq',     (SELECT MAX(id) FROM orders));
SELECT setval('products_id_seq',   (SELECT MAX(id) FROM products));
SELECT setval('users_id_seq',      (SELECT MAX(id) FROM users));
