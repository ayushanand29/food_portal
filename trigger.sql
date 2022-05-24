DELIMITER $$
CREATE TRIGGER total_bill_menu AFTER INSERT ON order_details FOR EACH ROW begin
update
  food_order f,
  (
    select
      f.id,
      sum(price) as pr
    from
      food_order as f
      inner join order_details as o on f.id = o.order_id
    group by
      f.id
  ) as b
set
  f.total_bill = b.pr
where
  b.id = f.id;
END;
$$

DELIMITER ;