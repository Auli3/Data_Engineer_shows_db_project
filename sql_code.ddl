-- First we have to run only the query to create the database or else it will cause an error.

CREATE DATABASE shows_db;

-- The rest of the queries can be run at the same time but only after having made the connection to the database.


------------------------------------------------------------ Creating the "about" table.

CREATE TABLE IF NOT EXISTS public.about
(
    about_id serial NOT NULL,
    type character varying COLLATE pg_catalog."default",
    listed_in character varying COLLATE pg_catalog."default",
    duration_min integer,
    duration_seasons integer,
    rating character varying COLLATE pg_catalog."default",
    description character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_about PRIMARY KEY (about_id)
)

TABLESPACE pg_default;


------------------------------------------------------------ Creating the "category" table.

CREATE TABLE IF NOT EXISTS public.category
(
    category_id serial NOT NULL,
    category character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_category PRIMARY KEY (category_id) 
)

TABLESPACE pg_default;


------------------------------------------------------------ Creating the "listed_in" table..

CREATE TABLE IF NOT EXISTS public.listed_in
(
    listed_in_id serial NOT NULL,
    category_id integer,
    about_id integer,
    CONSTRAINT pk_listed_in PRIMARY KEY (listed_in_id),
    CONSTRAINT fk_listed_in_category FOREIGN KEY (category_id)
        REFERENCES public.category (category_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_listed_in_about FOREIGN KEY (about_id)
        REFERENCES public.about (about_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION 
)

TABLESPACE pg_default;

------------------------------------------------------------ Creating the "season" table.

CREATE TABLE IF NOT EXISTS public.season
(
    season_id serial NOT NULL,
    season character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_season PRIMARY KEY (season_id)
)

TABLESPACE pg_default;


------------------------------------------------------------ Creating the "calendar" table.

CREATE TABLE IF NOT EXISTS public.calendar
(
    date timestamp without time zone NOT NULL,
    week_day character varying COLLATE pg_catalog."default",
    day integer,
    month integer,
    week integer,
    year integer,
    season_id integer,
    CONSTRAINT pk_calendar PRIMARY KEY (date),
    CONSTRAINT fk_calendar_season FOREIGN KEY (season_id)
        REFERENCES public.season (season_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;


------------------------------------------------------------ Creating the "production" table.

CREATE TABLE IF NOT EXISTS public.production
(
    production_id serial NOT NULL,
    director character varying COLLATE pg_catalog."default",
    "cast" text[] COLLATE pg_catalog."default",
    country character varying COLLATE pg_catalog."default",
    release_year integer,
    CONSTRAINT pk_production PRIMARY KEY (production_id)
)

TABLESPACE pg_default;

------------------------------------------------------------ Creating the "director" table.

CREATE TABLE IF NOT EXISTS public.director
(
    director_id serial NOT NULL,
    director character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_director PRIMARY KEY (director_id)
)

TABLESPACE pg_default;

------------------------------------------------------------ Creating the "direction" table.

CREATE TABLE IF NOT EXISTS public.direction
(
    direction_id serial NOT NULL,
    director_id integer,
    production_id integer,
    CONSTRAINT pk_direction PRIMARY KEY (direction_id),
    CONSTRAINT fk_direction_director FOREIGN KEY (director_id)
        REFERENCES public.director (director_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_direction_production FOREIGN KEY (production_id)
        REFERENCES public.production (production_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;


------------------------------------------------------------ Creating the "actor" table.

CREATE TABLE IF NOT EXISTS public.actor
(
    actor_id serial NOT NULL,
    actor character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_actor PRIMARY KEY (actor_id)
)

TABLESPACE pg_default;

------------------------------------------------------------ Creating the "cast" table.

CREATE TABLE IF NOT EXISTS public.cast
(
    cast_id serial NOT NULL,
    actor_id integer,
    production_id integer,
    CONSTRAINT pk_cast PRIMARY KEY (cast_id),
    CONSTRAINT fk_cast_actor FOREIGN KEY (actor_id)
        REFERENCES public.actor (actor_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_cast_production FOREIGN KEY (production_id)
        REFERENCES public.production (production_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;


------------------------------------------------------------ Creating the "auxiliar" table.

CREATE TABLE IF NOT EXISTS public.auxiliar
(
    aux_id serial NOT NULL DEFAULT nextval('auxiliar_aux_id_seq'::regclass),
    null_field character varying COLLATE pg_catalog."default",
    action character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_auxiliar PRIMARY KEY (aux_id)
)

TABLESPACE pg_default;


------------------------------------------------------------ Creating the "show" table.

CREATE TABLE IF NOT EXISTS public.show
(
    show_id serial NOT NULL,
    platform character varying COLLATE pg_catalog."default",
    title character varying COLLATE pg_catalog."default",
    date_added timestamp without time zone,
    about_id integer,
    production_id integer,
    aux_id integer,
    CONSTRAINT pk_show PRIMARY KEY (show_id),
    CONSTRAINT fk_show_about FOREIGN KEY (about_id)
        REFERENCES public.about (about_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_show_aux FOREIGN KEY (aux_id)
        REFERENCES public.auxiliar (aux_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_show_calendar FOREIGN KEY (date_added)
        REFERENCES public.calendar (date) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_show_production FOREIGN KEY (production_id)
        REFERENCES public.production (production_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;



---------------------------------------- Creating the stored procedure that will return the 5 longest film given the year parameter.

CREATE OR REPLACE FUNCTION public.longestfilmsofyear(
	desired_year integer)
    RETURNS TABLE("Title" character varying, "Mins" integer) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

SELECT s.title AS "Title", a.duration_min AS "Duration_mins"
FROM about a
JOIN show s ON (a.about_id = s.about_id)
JOIN calendar c ON (s.date_added = c.date)
WHERE a.type = 'Movie' AND c.year = desired_year
ORDER BY "Duration_mins" DESC
LIMIT 5;

$BODY$;