\restrict dbmate

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissions (
    id uuid DEFAULT uuidv7() NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT permissions_name_check CHECK ((name ~ '^[a-z_]+:[a-z_]+$'::text))
);


--
-- Name: project_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_images (
    id uuid DEFAULT uuidv7() NOT NULL,
    project_id uuid NOT NULL,
    storage_key text NOT NULL,
    alt text NOT NULL,
    caption text DEFAULT ''::text NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_cover boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT project_images_alt_check CHECK (((length(alt) >= 1) AND (length(alt) <= 250))),
    CONSTRAINT project_images_height_check CHECK ((height > 0)),
    CONSTRAINT project_images_width_check CHECK ((width > 0))
);


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id uuid DEFAULT uuidv7() NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    meta_description text DEFAULT ''::text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    published_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT projects_check CHECK (((status = 'draft'::text) OR (published_at IS NOT NULL))),
    CONSTRAINT projects_meta_description_check CHECK ((length(meta_description) <= 160)),
    CONSTRAINT projects_slug_check CHECK (((slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'::text) AND (length(slug) <= 100))),
    CONSTRAINT projects_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text]))),
    CONSTRAINT projects_title_check CHECK (((length(title) >= 1) AND (length(title) <= 200)))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_tokens (
    id uuid DEFAULT uuidv7() NOT NULL,
    user_id uuid NOT NULL,
    family_id uuid NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked_at timestamp with time zone,
    replaced_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id uuid DEFAULT uuidv7() NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT roles_name_check CHECK ((name ~ '^[a-z_]+$'::text))
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tip_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tip_categories (
    id uuid DEFAULT uuidv7() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    intro text DEFAULT ''::text NOT NULL,
    meta_description text DEFAULT ''::text NOT NULL,
    cover_image_key text,
    cover_image_alt text,
    cover_image_width integer,
    cover_image_height integer,
    sort_order integer DEFAULT 0 NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT tip_categories_check CHECK ((num_nulls(cover_image_key, cover_image_alt, cover_image_width, cover_image_height) = ANY (ARRAY[0, 4]))),
    CONSTRAINT tip_categories_cover_image_alt_check CHECK (((length(cover_image_alt) >= 1) AND (length(cover_image_alt) <= 250))),
    CONSTRAINT tip_categories_cover_image_height_check CHECK ((cover_image_height > 0)),
    CONSTRAINT tip_categories_cover_image_width_check CHECK ((cover_image_width > 0)),
    CONSTRAINT tip_categories_meta_description_check CHECK ((length(meta_description) <= 160)),
    CONSTRAINT tip_categories_name_check CHECK (((length(name) >= 1) AND (length(name) <= 100))),
    CONSTRAINT tip_categories_slug_check CHECK (((slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'::text) AND (length(slug) <= 100))),
    CONSTRAINT tip_categories_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text])))
);


--
-- Name: tips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tips (
    id uuid DEFAULT uuidv7() NOT NULL,
    category_id uuid NOT NULL,
    title text NOT NULL,
    body text DEFAULT ''::text NOT NULL,
    image_key text,
    image_alt text,
    image_width integer,
    image_height integer,
    sort_order integer DEFAULT 0 NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT tips_check CHECK ((num_nulls(image_key, image_alt, image_width, image_height) = ANY (ARRAY[0, 4]))),
    CONSTRAINT tips_image_alt_check CHECK (((length(image_alt) >= 1) AND (length(image_alt) <= 250))),
    CONSTRAINT tips_image_height_check CHECK ((image_height > 0)),
    CONSTRAINT tips_image_width_check CHECK ((image_width > 0)),
    CONSTRAINT tips_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text]))),
    CONSTRAINT tips_title_check CHECK (((length(title) >= 1) AND (length(title) <= 200)))
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT uuidv7() NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    role_id uuid NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT users_email_check CHECK (((email = lower(email)) AND (length(email) <= 254) AND (POSITION(('@'::text) IN (email)) > 1)))
);


--
-- Name: permissions permissions_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_key UNIQUE (name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: project_images project_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_images
    ADD CONSTRAINT project_images_pkey PRIMARY KEY (id);


--
-- Name: project_images project_images_storage_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_images
    ADD CONSTRAINT project_images_storage_key_key UNIQUE (storage_key);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects projects_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_slug_key UNIQUE (slug);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_hash_key UNIQUE (token_hash);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tip_categories tip_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tip_categories
    ADD CONSTRAINT tip_categories_name_key UNIQUE (name);


--
-- Name: tip_categories tip_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tip_categories
    ADD CONSTRAINT tip_categories_pkey PRIMARY KEY (id);


--
-- Name: tip_categories tip_categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tip_categories
    ADD CONSTRAINT tip_categories_slug_key UNIQUE (slug);


--
-- Name: tips tips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tips
    ADD CONSTRAINT tips_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: project_images_one_cover_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX project_images_one_cover_idx ON public.project_images USING btree (project_id) WHERE is_cover;


--
-- Name: project_images_project_id_sort_order_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX project_images_project_id_sort_order_idx ON public.project_images USING btree (project_id, sort_order);


--
-- Name: projects_status_published_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX projects_status_published_at_idx ON public.projects USING btree (status, published_at DESC);


--
-- Name: refresh_tokens_expires_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_tokens_expires_at_idx ON public.refresh_tokens USING btree (expires_at);


--
-- Name: refresh_tokens_family_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_tokens_family_id_idx ON public.refresh_tokens USING btree (family_id);


--
-- Name: refresh_tokens_replaced_by_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_tokens_replaced_by_idx ON public.refresh_tokens USING btree (replaced_by);


--
-- Name: refresh_tokens_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_tokens_user_id_idx ON public.refresh_tokens USING btree (user_id);


--
-- Name: role_permissions_permission_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX role_permissions_permission_id_idx ON public.role_permissions USING btree (permission_id);


--
-- Name: tip_categories_status_sort_order_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tip_categories_status_sort_order_idx ON public.tip_categories USING btree (status, sort_order);


--
-- Name: tips_category_id_sort_order_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tips_category_id_sort_order_idx ON public.tips USING btree (category_id, sort_order);


--
-- Name: users_role_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_role_id_idx ON public.users USING btree (role_id);


--
-- Name: project_images project_images_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER project_images_set_updated_at BEFORE UPDATE ON public.project_images FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: projects projects_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER projects_set_updated_at BEFORE UPDATE ON public.projects FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: tip_categories tip_categories_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tip_categories_set_updated_at BEFORE UPDATE ON public.tip_categories FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: tips tips_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tips_set_updated_at BEFORE UPDATE ON public.tips FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: users users_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER users_set_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: project_images project_images_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_images
    ADD CONSTRAINT project_images_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_replaced_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_replaced_by_fkey FOREIGN KEY (replaced_by) REFERENCES public.refresh_tokens(id) ON DELETE SET NULL;


--
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: tips tips_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tips
    ADD CONSTRAINT tips_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.tip_categories(id) ON DELETE RESTRICT;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict dbmate


--
-- Dbmate schema migrations
--

INSERT INTO public.schema_migrations (version) VALUES
    ('20261109120000'),
    ('20261109120100'),
    ('20261109120200'),
    ('20261109120300'),
    ('20261109162922');
