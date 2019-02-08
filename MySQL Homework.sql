-- 1a
select first_name, last_name from actor;

-- 1b
select concat(first_name, ', ' , last_name) as Actor_Name from actor;

-- 2a 
select actor_id, first_name, last_name from actor
where first_name = 'Joe';

-- 2B
select * from actor
where last_name like "%GEN%";

-- 2C
select * from actor
where last_name like "%LI%"
order by last_name, first_name;

-- 2d 
select country_id, country from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD COLUMN Description blob AFTER last_update ;

-- 3b
ALTER TABLE actor
DROP COLUMN Description;

-- 4a
select last_name, count(last_name) number_of_actors
from actor 
group by 1
order by 2 desc;

-- 4b
select * from (
select last_name, count(last_name) as number_of_actors
from actor
group by last_name) t where number_of_actors >= 2 order by 2;

-- 4c
update 
    actor 
set 
	first_name = 'HARPO'
Where
	first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d 
update 
    actor 
set 
	first_name = 'GROUCHO'
Where
	first_name = 'HARPO' and last_name = 'WILLIAMS';
    
-- 5a
show create table address;

-- 6a
select s.first_name, s.last_name, a.address
from staff s 
	join address a on s.address_id = a.address_id;

-- 6b
select t1.first_name, t1.last_name, t1.year_and_month, sum(t1.amount) as total_amount
from(
select s.first_name, s.last_name, p.amount, extract(year_month from p.payment_date) as year_and_month
from payment p 
	left join staff s on p.staff_id = s.staff_id) t1
where year_and_month = '200508'
group by 1,2,3;

-- 6c
select f.title, count(fa.actor_id) as number_of_actors
from film f
	join film_actor fa on f.film_id = fa.film_id
group by 1
order by 2 desc;

-- 6d
select f.title, count(*) as total_number_of_copies
from inventory i
	left  join film f on i.film_id = f.film_id
where f.title = 'Hunchback Impossible'
group by 1;

-- 6e
select p.customer_id, c.last_name, c.first_name, sum(p.amount) as total_paid
from payment p
	left join customer c on p.customer_id = c.customer_id
group by 1,2,3
order by 2;

-- 7a
select f.title, l.name
from film f
	left join language l on l.language_id = f.language_id
where l.name = 'English' and f.title like "K%" or  f.title like "Q%" ;

-- 7b 
select a.first_name, a.last_name
from 
(select fa.actor_id from film_actor fa
where film_id = 
(select f.film_id from film f where f.title = 'Alone Trip')) t 
	join actor a on t.actor_id = a.actor_id;
    
-- using join to do it
select f.title, a.first_name, a.last_name
from film f
	join film_actor fa on f.film_id = fa.film_id
    join actor a on fa.actor_id = a.actor_id
where f.title = 'Alone Trip';

-- 7c
select c.first_name, c.last_name, c.email, co.country
from customer c
	left join address a on a.address_id = c.address_id
    left join city ci on ci.city_id = a.city_id
    left join country co on co. country_id = ci.country_id
where co.country = 'Canada';

-- 7d
select f.title, c.name
from film f
	join film_category fc on fc.film_id = f.film_id
    join category c on c.category_id = fc.category_id
where c.name = 'family';

-- 7e
select f.title, count(*)
from rental r 
	left join inventory i on i.inventory_id = r.inventory_id
	left join film f on f.film_id = i.film_id
group by 1
order by 2 desc; 

-- 7f
select s.store_id, sum(p.amount) as total_sales
from payment p 
	join staff s on s.staff_id = p.staff_id
group by 1;

-- 7g
select s.store_id, ci.city, co.country
from store s
	left join address a on a.address_id = s.address_id
    left join city ci on ci.city_id = a.city_id
    left join country co on co. country_id = ci.country_id;

-- 7h
select c.name, sum(p.amount)as gross_revenue
from payment p
	left join rental r on r.rental_id = p.rental_id
    left join inventory i on i.inventory_id = r.inventory_id
    left join film_category f on f.film_id = i.film_id
    left join category c on c.category_id = f.category_id
group by 1
order by 2 desc
limit 5;

-- 8a 
CREATE VIEW `Top_five_genres_in_gross_revenue` AS
select c.name, sum(p.amount)as gross_revenue
from payment p
	left join rental r on r.rental_id = p.rental_id
    left join inventory i on i.inventory_id = r.inventory_id
    left join film_category f on f.film_id = i.film_id
    left join category c on c.category_id = f.category_id
group by 1
order by 2 desc
limit 5;

-- 8b
select * from top_five_genres_in_gross_revenue;

-- 8c
DROP VIEW top_five_genres_in_gross_revenue
