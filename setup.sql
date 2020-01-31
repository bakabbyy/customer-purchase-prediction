CREATE DATABASE events;

\connect events;

CREATE TABLE all_events (
  event_time timestamp,
  event_type text,
  product_id integer,
  category_id integer,
  category_code text,
  brand text,
  price numeric,
  user_id integer,
  user_session text
);

\copy all_events FROM 'data/2019-Oct.csv' DELIMITER ',' CSV;
\copy all_events FROM 'data/2019-Nov.csv' DELIMITER ',' CSV;