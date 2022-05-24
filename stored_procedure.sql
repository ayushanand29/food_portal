DELIMITER $$
CREATE PROCEDURE restaurantDetails(resId int)
BEGIN
SELECT name, price, description, type FROM menu WHERE res_id=resId;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE getUserId(email varchar(64))
BEGIN
SELECT id FROM users WHERE email=email;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE getOrderId(cus_id int, res_id int)
BEGIN
SELECT id FROM food_order WHERE customer_id=cus_id AND res_id=res_id ORDER BY id DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE getMenuId(name varchar(64), res_id varchar(64))
BEGIN
SET sql = 'SELECT id FROM menu WHERE name="' +name+ '" AND res_id=' + res_id
exec(sql)
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE menuItemPrice(id int)
BEGIN
SELECT price FROM menu WHERE id=id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE getResId(email varchar(64))
BEGIN
SELECT res_id FROM restaurant_staff WHERE email=email;
END$$
DELIMITER ;