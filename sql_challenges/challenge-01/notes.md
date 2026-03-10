### SECTION 1: 
##### SELECT QUERIES 101 - Exercise 1 Tasks

* Find the title of each film
    ```sql
    SELECT title FROM movies;
    ```
* Find the director of each film
    ```sql
    SELECT director FROM movies;
    ```
* Find the title and director of each film
    ```sql
    SELECT title, director FROM movies;
    ```
* Find the title and year of each film
    ```sql
    SELECT title, year FROM movies;
    ```
* Find all the information about each film
    ```sql
    SELECT * FROM movies;
    ```

### SECTION 2:
##### QUERIES WITH CONSTRAINTS PT1 - Exercise 2 Tasks
* Find the movie with a row id of 6
    ```sql
    SELECT * FROM movies WHERE id = 6;
    ```
* Find the movies realeased in the years between 2000 and 2010
    ```sql
    SELECT * FROM movies WHERE year BETWEEN 2000 AND 2010;
    ```
* Find the movies not released in the years between 2000 and 2010
    ```sql
    SELECT * FROM movies WHERE year NOT BETWEEN 2000 AND 2010;
    ```
* Find the first 5 Pixar movies and their release year
    ```sql
    SELECT * FROM movies WHERE id BETWEEN 1 AND 5;
    ```

### SECTION 3:
#### QUERIES WITH CONSTRAINTS PT2 - Exercise 3 Tasks
* Find all the Toy Story Movies
    ```sql
    SELECT  * FROM movies WHERE title LIKE "Toy Story%";
    ```
* Find all the movies directed by John Lester
    ```sql
    SELECT * FROM movies WHERE director = "John Lasseter";
    ```
* Find all the movies (and director) not directed by John Lasseter
    ```sql
    SELECT * FROM movies WHERE director != "John Lasseter";
    ```
* Find all the WALL-* movies
    ```sql
    SELECT * FROM movies WHERE title LIKE "wall-%";
    ```

### SECTION 4:
##### FILTERING AND SORTING QUERY RESULTS - Exercise 4 Tasks
* List all directors of Pixar movies (alphabetically), without duplicates
    ```sql
    SELECT DISTINCT director FROM movies ORDER BY director ASC;
    ```
* List the last four Pixar movies released (ordered from most recent to least)
    ```sql
    SELECT * FROM movies ORDER BY year DESC LIMIT 4;
    ```
* List the first five Pixar movies sorted alphabetically
    ```sql
    SELECT * FROM movies ORDER BY title ASC LIMIT 5;
    ```
* List the next five Pixar movies sorted alphabetically
    ```sql
    SELECT * FROM movies ORDER BY title ASC LIMIT 5 OFFSET 5;
    ```

### SECTION 5:
##### SIMPLE SELECT QUERIES - Exercise 5 Tasks
* List all the Canadian cities and their populations
    ```sql
    SELECT city, population FROM north_american_cities WHERE country = "Canada";
    ```
* Order all the cities in the United States by their latitude from north to south
    ```sql
    SELECT city FROM north_american_cities WHERE country = "United States" ORDER BY latitude DESC;
    ```
* List all the cities west of Chicago, ordered from west to east
    ```sql
    SELECT city FROM north_american_cities WHERE longitude < -87.629798 ORDER BY longitude ASC;
    ```
* List the two largest cities in Mexico (by population)
    ```sql
    SELECT city FROM north_american_cities WHERE country = "Mexico" ORDER BY population DESC LIMIT 2;
    ```
* List the third and fourth largest cities (by population) in the United States and their population
    ```sql
    SELECT city, population FROM north_american_cities WHERE country = "United States" ORDER BY population DESC LIMIT 2 OFFSET 2;
    ```