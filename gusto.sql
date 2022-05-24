CREATE TABLE users (
  id int AUTO_INCREMENT PRIMARY KEY,
  name varchar(64) NOT NULL,
  email varchar(64) NOT NULL,
  auth_string varchar(64) NOT NULL,
  phone_number varchar(10) NOT NULL,
  CONSTRAINT table_uindex UNIQUE (email)
);

CREATE TABLE address (
	id int AUTO_INCREMENT PRIMARY KEY,
	user_id int NOT NULL,
	address varchar(64) NOT NULL,
	landmark varchar(64) NULL,
	city varchar(64) NOT NULL,
	state varchar(10) NOT NULL,
	pincode varchar(6) NOT NULL,
	CONSTRAINT address_user_id_fk FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE restaurant (
	id int AUTO_INCREMENT PRIMARY KEY,
	name varchar(64) NOT NULL,
	type varchar(64) NULL,
	location varchar(64) NOT NULL
);

CREATE TABLE restaurant_staff (
	id int AUTO_INCREMENT PRIMARY KEY,
	name varchar(64) NOT NULL,
	role varchar(64) NOT NULL,
	auth_string varchar(64) NOT NULL,
	res_id int NOT NULL,
	CONSTRAINT staff_res_id_fk  FOREIGN KEY (res_id) REFERENCES restaurant (id)
);

CREATE TABLE menu (
	id int AUTO_INCREMENT PRIMARY KEY,
	name varchar(64) NOT NULL,
	price int NOT NULL,
	res_id int NOT NULL,
	CONSTRAINT menu_res_id_fk FOREIGN KEY (res_id) REFERENCES restaurant (id)
);

CREATE TABLE food_order (
	id int AUTO_INCREMENT PRIMARY KEY,
	customer_id int NOT NULL,
	res_id int NOT NULL,
	order_status varchar(20) NOT NULL,
	total_bill int NULL,
	FOREIGN KEY (customer_id) REFERENCES users (id),
	FOREIGN KEY (res_id) REFERENCES restaurant (id)
);

CREATE TABLE order_details (
	id int AUTO_INCREMENT PRIMARY KEY,
	order_id int NOT NULL,
	menu_id int NOT NULL,
	quantity int NOT NULL,
	order_status varchar(20) NOT NULL,
	price int NOT NULL,
	FOREIGN KEY (order_id) REFERENCES food_order (id),
	FOREIGN KEY (menu_id) REFERENCES menu (id)
);

CREATE TABLE payment_details (
	id int AUTO_INCREMENT PRIMARY KEY,
	customer_id int NOT NULL,
	cost int NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES users (id)
);

CREATE TABLE payment (
	id int AUTO_INCREMENT PRIMARY KEY,
	order_id int NOT NULL,
	type varchar(64) NOT NULL,
	status varchar(20) NOT NULL,
	payment_id int NOT NULL,
	FOREIGN KEY (payment_id) REFERENCES payment_details (id),
	FOREIGN KEY (order_id) REFERENCES food_order (id)
);

ALTER TABLE menu ADD description varchar(128);
ALTER TABLE menu ADD type varchar(24);

ALTER TABLE restaurant_staff ADD email varchar(24) NOT NULL UNIQUE;

INSERT INTO restaurant (name, type, location) VALUES ('Nandana Hotel', 'West Indian', 'Vijayanagar');
INSERT INTO restaurant (name, type, location) VALUES ('Santhi Sagar', 'North Indian', 'Jayanagar');
INSERT INTO restaurant (name, type, location) VALUES ('BBQ Nation', 'East Indian', 'NR layout');
INSERT INTO restaurant (name, type, location) VALUES ('Janatha hotel', 'South Indian', 'RR Nagar');

INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Garlic Bread',100, "Lorem ipsum dolor sit amet, consectetur adipiscing elit","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'BBQ Wings',150,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Mixed Salad',400,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Pizza',200,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Roti',300,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Chicken Tikka Masala',245,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Pizza',54,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Cake',244,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Fudge',453,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Pastery',224,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Coke',121,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (1,'Pepsi',32,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");

INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Garlic Bread',100, "Lorem ipsum dolor sit amet, consectetur adipiscing elit","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'BBQ Wings',150,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Mixed Salad',400,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Pizza',200,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Roti',300,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Chicken Tikka Masala',245,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Pizza',54,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Cake',244,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Fudge',453,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Pastery',224,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Coke',121,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (2,'Pepsi',32,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");

INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Garlic Bread',100, "Lorem ipsum dolor sit amet, consectetur adipiscing elit","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'BBQ Wings',150,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Mixed Salad',400,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Pizza',200,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Roti',300,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Chicken Tikka Masala',245,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Pizza',54,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Cake',244,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Fudge',453,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Pastery',224,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Coke',121,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (3,'Pepsi',32,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");

INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Garlic Bread',100, "Lorem ipsum dolor sit amet, consectetur adipiscing elit","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'BBQ Wings',150,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Mixed Salad',400,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","STARTER");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Pizza',200,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Roti',300,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Chicken Tikka Masala',245,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","MAIN");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Pizza',54,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Cake',244,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Fudge',453,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DESERT");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Pastery',224,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Coke',121,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");
INSERT INTO menu  (res_id, name, price, description, type) VALUES (4,'Pepsi',32,"Lorem ipsum dolor sit amet, consectetur adipiscing elit Ut enim ad minim venia, nostrud exercitation ullamco.","DRINK");