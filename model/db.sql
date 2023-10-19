-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.checkout_cart
(
    payment_date timestamp with time zone NOT NULL,
    trade_history json,
    user_id integer NOT NULL,
    history_id integer NOT NULL DEFAULT nextval('checkout_cart_history_id_seq'::regclass),
    currency character varying COLLATE pg_catalog."default" NOT NULL,
    payment_method json,
    status character varying COLLATE pg_catalog."default" NOT NULL
);

CREATE TABLE IF NOT EXISTS public.country
(
    code character varying(3) COLLATE pg_catalog."default" NOT NULL,
    name character varying COLLATE pg_catalog."default",
    CONSTRAINT country_pkey PRIMARY KEY (code)
);

CREATE TABLE IF NOT EXISTS public.initialize_cart
(
    session_user_id integer NOT NULL,
    created_on timestamp without time zone,
    CONSTRAINT initialize_cart_pkey PRIMARY KEY (session_user_id)
);

CREATE TABLE IF NOT EXISTS public.merchant
(
    id bigint NOT NULL DEFAULT nextval('merchant_id_seq'::regclass),
    user_id integer,
    merchant_name character varying COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    CONSTRAINT merchant_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.payment
(
    method character varying COLLATE pg_catalog."default",
    user_id integer,
    card_number numeric(32, 0),
    created_on timestamp without time zone NOT NULL,
    CONSTRAINT payment_user_id_key UNIQUE (user_id)
);

CREATE TABLE IF NOT EXISTS public.product
(
    id bigint NOT NULL DEFAULT nextval('product_id_seq'::regclass),
    category_id integer,
    merchant_id integer,
    product_name character varying COLLATE pg_catalog."default",
    unit_available integer,
    created_at timestamp without time zone,
    price numeric,
    CONSTRAINT product_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.product_cart
(
    product_id integer NOT NULL,
    cart_id integer NOT NULL,
    quantity integer NOT NULL,
    total_cost numeric NOT NULL,
    price numeric NOT NULL,
    productcart_id integer NOT NULL DEFAULT nextval('product_cart_productcart_id_seq'::regclass),
    CONSTRAINT product_cart_pkey PRIMARY KEY (product_id, cart_id)
);

CREATE TABLE IF NOT EXISTS public.product_category
(
    id bigint NOT NULL DEFAULT nextval('category_id_seq'::regclass),
    category_name character varying COLLATE pg_catalog."default",
    parent_id integer,
    CONSTRAINT category_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.user_address
(
    id bigint NOT NULL DEFAULT nextval('user_address_id_seq'::regclass),
    user_id integer,
    street_name character varying COLLATE pg_catalog."default",
    street_number integer,
    postcode character varying(32) COLLATE pg_catalog."default",
    city character varying COLLATE pg_catalog."default",
    province character varying COLLATE pg_catalog."default",
    country_code character varying COLLATE pg_catalog."default",
    updated_on timestamp without time zone,
    CONSTRAINT user_address_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.user_data
(
    id bigint NOT NULL DEFAULT nextval('user_id_seq'::regclass),
    title character varying COLLATE pg_catalog."default",
    fullname character varying COLLATE pg_catalog."default" NOT NULL,
    gender gender_type NOT NULL,
    birth_date date,
    email character varying COLLATE pg_catalog."default",
    telephone integer NOT NULL,
    user_type user_type NOT NULL,
    created_at timestamp without time zone NOT NULL,
    password character varying COLLATE pg_catalog."default" NOT NULL,
    updated_on timestamp without time zone,
    payment_id integer,
    CONSTRAINT user_pkey PRIMARY KEY (id),
    CONSTRAINT unique_email UNIQUE (email)
);

ALTER TABLE IF EXISTS public.checkout_cart
    ADD CONSTRAINT checkout_cart_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.user_data (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.merchant
    ADD CONSTRAINT merchant_userid_fkey FOREIGN KEY (user_id)
    REFERENCES public.user_data (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.payment
    ADD CONSTRAINT payment_userdata_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.user_data (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS payment_user_id_key
    ON public.payment(user_id);


ALTER TABLE IF EXISTS public.product
    ADD CONSTRAINT product_categoryid_fkey FOREIGN KEY (category_id)
    REFERENCES public.product_category (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.product
    ADD CONSTRAINT product_merchantid_fkey FOREIGN KEY (merchant_id)
    REFERENCES public.merchant (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.product_cart
    ADD CONSTRAINT cartproduct_productid FOREIGN KEY (product_id)
    REFERENCES public.product (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.product_cart
    ADD CONSTRAINT productcart_sessionuserid_fkey FOREIGN KEY (cart_id)
    REFERENCES public.initialize_cart (session_user_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.product_category
    ADD CONSTRAINT category_parent_id_fkey FOREIGN KEY (parent_id)
    REFERENCES public.product_category (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.user_address
    ADD CONSTRAINT useraddress_countrycode_fkey FOREIGN KEY (country_code)
    REFERENCES public.country (code) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.user_address
    ADD CONSTRAINT useraddress_userid_fkey FOREIGN KEY (user_id)
    REFERENCES public.user_data (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;

END;