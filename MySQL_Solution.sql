-- Question Set 1 – Easy

-- 1. Who is the senior most employee based on job title?
SELECT * FROM employee ORDER BY title DESC LIMIT 1;

-- 2. Which countries have the most Invoices?
SELECT billing_country, COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;

-- 3. What are top 3 values of total invoice?
SELECT total FROM invoice
ORDER BY total DESC
LIMIT 3;

-- 4. Which city has the best customers (highest invoice total)?
SELECT billing_city, SUM(total) AS total_revenue
FROM invoice
GROUP BY billing_city
ORDER BY total_revenue DESC
LIMIT 1;

-- 5. Who is the best customer (spent the most money)?
SELECT c.customer_id,
       MAX(c.first_name) AS first_name,
       MAX(c.last_name) AS last_name,
       SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;

-- Question Set 2 – Moderate

-- 1. Return email, name, and genre of all Rock music listeners ordered by email
SELECT DISTINCT c.email, c.first_name, c.last_name, g.name AS genre
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;

-- 2. Top 10 Rock bands (artists with most Rock tracks)
SELECT MAX(a.name) AS artist_name, COUNT(t.track_id) AS track_count
FROM artist a
JOIN album2 al ON a.artist_id = al.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id
ORDER BY track_count DESC
LIMIT 10;

-- 3. Return track names longer than average duration
SELECT name, milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) FROM track
)
ORDER BY milliseconds DESC;

-- Question Set 3 – Advance

-- 1. Amount spent by each customer on each artist
SELECT 
    MAX(c.first_name) AS first_name,
    MAX(c.last_name) AS last_name,
    MAX(a.name) AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album2 al ON t.album_id = al.album_id
JOIN artist a ON al.artist_id = a.artist_id
GROUP BY c.customer_id, a.artist_id
ORDER BY total_spent DESC;

-- 2. Most popular genre for each country based on purchases
WITH genre_sales AS (
    SELECT c.country, MAX(g.name) AS genre, COUNT(*) AS purchases
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY c.country, g.genre_id
),
max_genre_sales AS (
    SELECT country, MAX(purchases) AS max_purchases
    FROM genre_sales
    GROUP BY country
)
SELECT gs.country, gs.genre, gs.purchases
FROM genre_sales gs
JOIN max_genre_sales mgs
  ON gs.country = mgs.country AND gs.purchases = mgs.max_purchases
ORDER BY gs.country;

-- 3. Top customer per country based on amount spent
WITH customer_spend AS (
    SELECT c.customer_id,
           MAX(c.first_name) AS first_name,
           MAX(c.last_name) AS last_name,
           MAX(c.country) AS country,
           SUM(i.total) AS total_spent
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
),
max_spend AS (
    SELECT country, MAX(total_spent) AS max_spent
    FROM customer_spend
    GROUP BY country
)
SELECT cs.country, cs.first_name, cs.last_name, cs.total_spent
FROM customer_spend cs
JOIN max_spend ms ON cs.country = ms.country AND cs.total_spent = ms.max_spent
ORDER BY cs.country;

-- End of Assignment --





