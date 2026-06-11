--
-- PostgreSQL database dump
--

\restrict neRnFEjD7ENaSkrEirEbeNCq64cKMKShBtlyb0CzzoGdjCLUliZYGXikCFbz56x

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.0

-- Started on 2026-06-11 09:42:13

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
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 266 (class 1255 OID 16562)
-- Name: make_case_number(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.make_case_number() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  seq BIGINT;
BEGIN
  seq := nextval('intake_case_seq');
  RETURN to_char((now() AT TIME ZONE 'Europe/Zurich'), 'YYYYMMDD') || '-' || lpad(seq::text, 5, '0');
END;
$$;


ALTER FUNCTION public.make_case_number() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 16440)
-- Name: contact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    address text NOT NULL,
    zip text NOT NULL,
    city text NOT NULL,
    phone text NOT NULL,
    phone_private text,
    email text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.contact OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16519)
-- Name: emergency_contact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emergency_contact (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    first_name text,
    last_name text,
    address text,
    phone text,
    created_at timestamp with time zone DEFAULT now(),
    zip character varying(20),
    city character varying(255)
);


ALTER TABLE public.emergency_contact OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16536)
-- Name: intake_case; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.intake_case (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    case_number text DEFAULT public.make_case_number() NOT NULL,
    token uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    status text DEFAULT 'open'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.intake_case OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16535)
-- Name: intake_case_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.intake_case_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.intake_case_seq OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16477)
-- Name: medical_cardio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_cardio (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    blood_pressure boolean,
    exertion_pain_breath boolean,
    flat_lying_problem boolean,
    irregular_pulse boolean,
    night_symptoms boolean,
    swollen_legs boolean,
    thrombosis boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.medical_cardio OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16461)
-- Name: medical_general; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_general (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    hospitalized boolean,
    hospitalized_when text,
    hospitalized_where text,
    hospitalized_why text,
    regular_gp boolean,
    regular_gp_why text,
    regular_medication boolean,
    medications text,
    allergies boolean,
    allergies_text text,
    created_at timestamp with time zone DEFAULT now(),
    weight_kg integer,
    height_cm integer,
    limited_activity boolean,
    limited_activity_how text,
    limited_activity_since text,
    pregnant_possible boolean,
    breastfeeding boolean,
    anesthesia boolean,
    anesthesia_why text,
    anesthesia_problems boolean,
    anesthesia_problems_which text,
    family_anesthesia_problems boolean,
    medications_json jsonb
);


ALTER TABLE public.medical_general OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16491)
-- Name: medical_lung; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_lung (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    smoker boolean,
    dyspnea boolean,
    asthma boolean,
    created_at timestamp with time zone DEFAULT now(),
    inhaler boolean
);


ALTER TABLE public.medical_lung OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16505)
-- Name: medical_other; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_other (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    diabetes boolean,
    cancer boolean,
    coagulation boolean,
    created_at timestamp with time zone DEFAULT now(),
    paralysis_stroke boolean,
    neurological boolean,
    kidney_problem boolean,
    liver_problem boolean,
    reflux boolean,
    anemia boolean,
    transfusion boolean,
    transfusion_problems boolean,
    infection_disease boolean,
    wound_healing_problems boolean,
    inflammation_last_12mo boolean,
    substances boolean,
    bad_teeth boolean,
    dentures boolean,
    implanted_device boolean
);


ALTER TABLE public.medical_other OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16427)
-- Name: patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    birth_date date NOT NULL,
    ahv_number text,
    created_at timestamp with time zone DEFAULT now(),
    gender text,
    CONSTRAINT patient_gender_check CHECK (((gender IS NULL) OR (gender = ANY (ARRAY['male'::text, 'female'::text, 'other'::text, ''::text]))))
);


ALTER TABLE public.patient OWNER TO postgres;

--
-- TOC entry 5122 (class 0 OID 16440)
-- Dependencies: 221
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('23e5441a-e2c6-448f-8adb-710794b5cd73', 'ca55b4e0-d723-4add-a8e4-74945a7e655a', 'Kellerweg 45', '2567', 'Biel', '079 456 12 21', NULL, 'trudi.widmer@outlook.com', '2026-01-14 22:35:42.702714+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('5fba2034-ba15-41eb-ac3d-7f6b8171c9a4', 'c7fb002e-18d0-4e5b-b645-68922cc1ca81', 'g', 'g', 'g', 'g', NULL, 'g@gmail.com', '2026-01-15 05:27:03.244069+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('f69ad305-c6e9-482c-a3ee-df17cde77b16', 'cfac0d6b-4742-41ca-9736-c5731266b324', 'z', 'z', 'z', 'z', NULL, 'z@z.ch', '2026-01-15 05:35:21.411158+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('42132186-b7ca-4e2f-bb27-560f8e57efd5', 'ea3e097e-d630-48a8-ba63-6ff16642df04', 'Zikenweg 10', '3003', 'Bern', '077 777 10 10', NULL, 'ziki@gmail.com', '2026-01-15 05:58:18.629224+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('2e682e98-b3ca-437f-9397-b546434d5a60', '88d0bace-da1a-4b1e-b925-c4285c416271', 'Kirchgasse 11', '3176', 'Neuenegg', '076 566 65 65', NULL, 'georg.hamlet@gmail.com', '2026-01-15 07:38:46.978144+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('e5d002ea-bf9f-41f1-b10f-ea358a0a9613', 'dd91f468-2185-4ebe-a795-efb06c78b6c1', 'Sesamweg 12', '3018', 'Bümpliz', '079 551 98 89', NULL, 'kilian.k@gmail.com', '2026-01-15 23:45:24.818842+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('5bfa27a9-05b8-4e63-88ee-51cfab014709', 'eed357d0-f9af-428b-b50b-bb8482f3d679', 'Markusweg 9', '3097', 'Liebefeld', '079 199 21 01', NULL, 'heinz.mond@outlook.com', '2026-01-21 13:45:40.693893+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('7f07ed24-5a7d-4a00-8c77-40d1de1e31b2', 'd7f4f8b0-d16d-486d-8a19-0a07fcafa832', 'Höheweg 10', '2502', 'Biel', '0761501970', NULL, 'kurt.wenger1970@gmail.com', '2026-01-22 02:49:26.070397+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('6a13b155-c16e-4b28-8baf-5517a9bed82a', '9febaaee-3c78-4e14-a93e-84172e7804cb', 'Rosenweg 10', '3010', 'Bern', '0781001010', NULL, 'johann.j@gmail.com', '2026-03-27 14:46:41.590631+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('3e1ce17c-6d4a-4820-8d95-44b0e054209c', '1ebc794a-b65e-46b0-92fb-4e4ce5a6c112', 'Musterstrasse 20', '3000', 'Bern', '0762000101', NULL, 'maxmustermann@gmail.com', '2026-03-27 15:11:01.518144+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('2815a738-c936-4632-b6d3-564fcf24155b', '22373fb9-09ac-4508-8e2e-eb3b2cfc17f9', 'Junkerweg 15', '3000', 'Bern', '0785151515', NULL, 'lea.meiser@gmail.com', '2026-05-20 02:38:02.069189+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('3b82b9f3-882e-4891-b638-92087447f70a', '5ab48509-e3e7-4cdf-b095-2159157f64f9', 'Musterstrasse 6', '3000', 'Bern', '0770552005', NULL, 'maxine.mustermann@gmail.com', '2026-01-22 02:03:16.353401+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('2910b2af-da99-4153-82ed-4ab624dfc16b', 'd553f409-a44f-4acc-8e26-4ac31ae36be1', 'Musterstrasse 6', '3000', 'Bern', '0791011010', NULL, NULL, '2026-06-10 14:29:15.049731+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('af32678d-34fa-4faf-b015-3ce837894021', '3ffaedad-873d-458e-b6e3-d60a2059ae07', 'Ü', 'Ü', 'Ü', '0776660606', NULL, NULL, '2026-06-10 14:54:26.869294+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('034f8625-315f-4173-8a7c-685f668845ac', '00646193-214e-4620-acae-08be9e5d661b', 'Ä', 'Ä', 'Ä', '0791110011', NULL, NULL, '2026-06-10 15:48:19.856898+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('886794c9-a6a1-4106-b77a-9d7d577befca', 'da33cdee-a6a0-444b-8591-3eb20fcff244', 'O', 'O', 'O', '0770001100', NULL, NULL, '2026-06-10 16:06:53.503302+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('48892926-6716-4371-9cf9-6d4c9f7ed71d', '2551e0b1-6816-458c-aa23-e0b43133d612', 'T', 'T', 'T', '0779676769', NULL, NULL, '2026-06-10 17:06:37.353974+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('9bd55277-46ce-4e4d-bcf1-2d1df916f79f', '5d9a75de-1a53-4cd0-8b94-f9494a79081c', 'K', 'L', 'O', '0770009988', NULL, NULL, '2026-06-10 19:56:13.595507+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('77cf4d0b-cc07-4240-86ad-f271e01c4073', '1df17a24-06b3-46d5-bf0d-c2de2a0aea38', 'D', 'D', 'D', '0771112233', NULL, NULL, '2026-06-10 20:08:23.830427+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('6e4520b8-4b25-4cbd-b225-dedbee437807', '8fd59ec6-a651-4e32-96eb-7b634703466a', 'U', 'U', 'U', '0769996767', NULL, NULL, '2026-06-10 20:19:02.336315+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('90c0ea11-ed7d-4b8b-be2b-91c938631bbd', '9309fd04-32c4-4f3c-8e98-dbb1d01036c1', 'Jupiterstrasse 10', '3015', 'Bern', '0781991010', NULL, 'arasaka.m@gmail.com', '2026-06-11 03:24:20.842287+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('80b4c91f-5654-4c3a-a7cc-53299b1a18ad', 'e8425de0-abce-43c9-a999-4b2c9768cc5f', 'Hubertweg 8', '3018', 'Bümpliz', '0781980808', NULL, 'ben.hub@gmail.com', '2026-06-11 04:16:01.40255+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('0bf4f2cb-b9a4-4df6-bc50-8ec32e1fbd5b', 'b94dfa2b-8312-4dde-a957-6b39f901b003', 'Zenitweg 10', '3010', 'Bern', '0781001001', NULL, 'sam.horn@outlook.com', '2026-06-11 04:59:29.11184+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('acf9ff6a-9a6e-42e7-9c3a-2dbd18df074d', 'cb7ee1a9-080d-4f98-ad10-36069fe15d67', 'Fernweg 44', '3098', 'Köniz', '0774440404', NULL, 'd.schmitz04@gmail.com', '2026-06-11 05:12:42.045602+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('57e207ff-ac3a-4125-b53e-2effadf40829', 'a49a35cb-2def-4553-9d60-ae0ed71bd9ed', 'G', 'G', 'G', '0776660606', NULL, NULL, '2026-06-11 02:38:45.226632+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('79ff89af-40ee-4537-81c4-27eb92bc7450', '968cd7b1-dab2-4297-b554-98b52e862118', 'P', 'P', 'P', '0779996699', NULL, NULL, '2026-06-11 05:27:36.380038+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('89d3d266-fb06-45a5-9be4-8e6c9aa87c17', 'b0242073-334d-44ca-908a-45ba27f97095', 'Hohweg 80', '2567', 'Biel', '0769008090', NULL, NULL, '2026-06-11 05:46:56.233788+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('1dfa7474-f87a-42e9-82ff-268c8272f9de', '9252faae-55ce-4a88-8f5d-f3a84bf981d8', 'Ruppertstrasse 18', '3097', 'Liebefeld', '0788987667', NULL, 'ting.liu@gmail.com', '2026-06-11 06:02:22.999095+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('59dd1cac-4e5c-438c-8b8d-42e5c6788368', '8bc10c93-af3a-4f65-85f7-e6f2b1a78b27', 'Tulpenweg 67', '3098', 'Köniz', '0781951505', NULL, 'jana.wyss@outlook.com', '2026-06-11 06:25:46.078759+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('530dfe96-77d0-472d-834e-6beb7e2d35ff', '0ccdfc56-fd39-49ba-8dc3-f0873f51f581', 'R', 'R', 'R', '0779998877', NULL, NULL, '2026-06-11 06:43:00.720684+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('0abb4080-c1cf-4338-bae9-f1a6c76eb87a', 'f7df8fce-ecaf-477e-9869-338f5c741044', 'B', 'B', 'B', '0778881122', NULL, NULL, '2026-06-11 06:50:50.067092+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('0ec8ffeb-aa41-4920-8f04-23612efc0b6d', 'b27a82a2-24b4-4876-b97c-d414d7c2f010', 'Kirchgasse 11', '3176', 'Neuenegg', '0777978877', NULL, 'reyyuumi@gmail.com', '2026-06-11 07:11:17.558832+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('51ac160f-0294-42ff-b9a4-ca4b9ee6327e', '988674b0-d2b7-42bd-accf-7df1429108c9', 'a', 'a', 'a', '0761110404', NULL, NULL, '2026-06-11 07:32:49.809737+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('0f0b422c-fc12-4a1b-8e16-4e45f65e7e88', '5921d4e2-85d7-43c1-828a-dee8f2402e05', 'Mattenweg 7', '3003', 'Bern', '0797770707', NULL, 'sommer.johann@outlook.com', '2026-06-11 07:53:51.117932+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('a179a95e-6298-4c68-bb6b-a15734cd7f20', '5d2deb16-ed70-4727-bacf-d7a78c671779', 'f', 'd', 'Bern', '0797977997', NULL, NULL, '2026-06-11 08:26:34.5373+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('efb91bc9-8896-4bf0-88d3-0b55fd22a6ca', '03778cd7-7171-4aff-af59-442ef3367f5a', 'r', 'r', 'r', '0797977997', NULL, NULL, '2026-01-21 18:38:57.862871+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('61045c81-a237-4c72-8ed3-057e09843512', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'Musterstrasse 6', '3000', 'Bern', '0797977997', NULL, 'maxmustermann@gmail.com', '2025-12-15 14:36:58.272879+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('0234823d-aa4a-4efe-8b9e-c5614f2d3df2', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'Musterstrasse 6', '3000', 'Bern', '0797977997', NULL, 'maxmustermann@gmail.com', '2025-12-15 14:47:18.666655+01');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('117a4836-03d2-47db-83b9-44806e713a84', '67c4b0cf-dd4e-44bf-b0bf-a9d5d0e47214', 'Buchenweg 3', '3003', 'Bern', '0763002003', NULL, 'tom.burri@gmail.com', '2026-06-11 08:16:03.252931+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('c90e80a2-e2ca-47b8-a431-4b34340dce99', '27b2fd2b-a890-4ff0-89a1-1e6466305130', 'Hirtenweg 12', '2626', 'Aarberg', '0798526341', NULL, NULL, '2026-06-11 09:16:32.72375+02');
INSERT INTO public.contact (id, patient_id, address, zip, city, phone, phone_private, email, created_at) VALUES ('fa53573c-4f32-41f2-9af8-30536788c8e2', '491d45d9-c3dc-4217-bccd-818c807eca6b', 'Akademiestrasse 31', '8031', 'Domino City', '0798883108', NULL, 'jayuki@gmail.com', '2026-06-11 09:25:59.949142+02');


--
-- TOC entry 5127 (class 0 OID 16519)
-- Dependencies: 226
-- Data for Name: emergency_contact; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('747c222a-e080-47eb-bec6-bf4de5b61222', 'ca55b4e0-d723-4add-a8e4-74945a7e655a', 'Hans', 'Widmer', 'Kellerweg 45, 2567 Biel', '079 852 52 25', '2026-01-14 22:35:42.702714+01', NULL, NULL);
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('a59d2ec2-04aa-4cbf-8fc0-efbc66a95adb', '88d0bace-da1a-4b1e-b925-c4285c416271', 'Susie', 'Hamlet', 'Kirchgasse 11, 3176 Neuenegg', '079 852 52 25', '2026-01-15 07:38:46.978144+01', NULL, NULL);
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('4d57b378-b761-4be4-b8cd-f787575a5b0e', 'dd91f468-2185-4ebe-a795-efb06c78b6c1', 'Hannah', 'König', 'Sesamweg 12, 3018 Bümpliz', '076 222 56 00', '2026-01-15 23:45:24.818842+01', NULL, NULL);
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('f545ab6e-9399-45c9-9994-e87c6aa1ca79', '03778cd7-7171-4aff-af59-442ef3367f5a', 'Hans', 'Widmer', 'Kramgasse 8, 3001 Bern', NULL, '2026-01-21 18:38:57.862871+01', NULL, NULL);
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('eb72dd81-aff1-4f56-a4bb-81a57d9a82c3', 'd7f4f8b0-d16d-486d-8a19-0a07fcafa832', 'Beatrice', 'Wenger', 'Höheweg 10, 2502 Biel', '0762008070', '2026-01-22 02:49:26.070397+01', NULL, NULL);
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('2c3128fa-54aa-4ccb-951c-1a45608e6542', '22373fb9-09ac-4508-8e2e-eb3b2cfc17f9', 'Lena', 'Meiser', 'Junkerweg 15', '0795006789', '2026-05-20 02:38:02.069189+02', NULL, NULL);
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('3ccba8a7-3b00-458a-a751-8bf9c089c1ca', '5ab48509-e3e7-4cdf-b095-2159157f64f9', 'Beat', 'Mustermann', 'Musterstrasse 6', NULL, '2026-06-09 17:29:32.139644+02', '3000', 'Bern');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('7df3699f-d2fc-46f0-b883-5b435eaf5d7e', 'd553f409-a44f-4acc-8e26-4ac31ae36be1', 'Beat', 'Mustermann', 'Musterstrasse 6', NULL, '2026-06-10 14:29:15.049731+02', '3000', 'Bern');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('c7917d89-ecac-4f39-bc6e-25cab286a507', 'a49a35cb-2def-4553-9d60-ae0ed71bd9ed', 'Maria', 'Tobler', 'Gässli 6', '0796001090', '2026-06-11 02:38:45.226632+02', '3202', 'Frauenkappelen');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('f1ac7da6-c324-4e0a-a3f0-ea2b5f7bd1ca', '9309fd04-32c4-4f3c-8e98-dbb1d01036c1', 'Ken', 'Myura', NULL, '0778001010', '2026-06-11 03:24:20.842287+02', NULL, NULL);
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('78f3e358-f205-4d74-ac3e-045bbe261724', 'e8425de0-abce-43c9-a999-4b2c9768cc5f', 'Eliane', 'Schlosser', 'Hubertweg 8', '0780000808', '2026-06-11 04:16:01.40255+02', '3018', 'Bümpliz');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('a11f7417-8758-48fd-8bc6-3dddc6a567fc', 'b94dfa2b-8312-4dde-a957-6b39f901b003', 'Manuela', 'Horn', 'Zenitweg 10', '0762341010', '2026-06-11 04:59:29.11184+02', '3010', 'Bern');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('b7493b44-a6c5-4cf0-845d-ce1911662419', '9252faae-55ce-4a88-8f5d-f3a84bf981d8', 'Han', 'Liu', 'Ruppertstrasse 18', '0782001010', '2026-06-11 06:02:22.999095+02', '3097', 'Liebefeld');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('389c8023-7d86-42b6-b05d-9314b214ebac', '8bc10c93-af3a-4f65-85f7-e6f2b1a78b27', 'Aninna', 'Wyss', 'Tulpenweg 67', '0797002505', '2026-06-11 06:25:46.078759+02', '3098', 'Köniz');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('d1a16fe5-a915-46fe-8b26-947d699d8a16', 'b27a82a2-24b4-4876-b97c-d414d7c2f010', 'Lea', 'Yuumi', 'Kirchgasse 11, 3176 Neuenegg', '0778001010', '2026-06-11 07:11:17.558832+02', '3176', 'Neuenegg');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('70d43795-9bfa-4ed9-982f-2e52b4bade78', '5921d4e2-85d7-43c1-828a-dee8f2402e05', 'Gerhard', 'Sommer', 'Höheweg 10', '0765206767', '2026-06-11 07:53:51.117932+02', '2502', 'Biel');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('cc7c9826-7d88-460d-b5d5-6a8baba0ff04', '5d2deb16-ed70-4727-bacf-d7a78c671779', 'Anna', 'Bennet', 'Musterstrasse 11', '0797002505', '2026-06-11 08:26:34.5373+02', '3011', 'Bern');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('71caedb6-146b-4a0b-8363-5a14541ad2fc', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'Beat', 'Mustermann', 'Musterstrasse 6', '0798525225', '2026-06-11 08:50:51.29654+02', '3000', 'Bern');
INSERT INTO public.emergency_contact (id, patient_id, first_name, last_name, address, phone, created_at, zip, city) VALUES ('c25f0487-ac1a-4f4f-bbf5-d4d51a2c5e7c', '491d45d9-c3dc-4217-bccd-818c807eca6b', 'Alexis', 'Rhodes', 'Akademiestrasse 31', '0761002585', '2026-06-11 09:25:59.949142+02', '8031', 'Domino City');


--
-- TOC entry 5129 (class 0 OID 16536)
-- Dependencies: 228
-- Data for Name: intake_case; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('af2c6fd9-b5ca-43c1-ba80-cde5baaaf365', '20260115-00001', '4491d265-59cf-4d2e-a5ec-fa3eaaa1fd64', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'open', '2026-01-15 01:08:38.467646+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('c8b1f042-bd5e-4ab3-b475-98eea93d31d3', '20260115-00002', 'eb1dbcb9-f4db-4b40-81e1-f75010c2c31a', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'open', '2026-01-15 01:22:44.600316+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('0a8541eb-2732-4ba3-bcf7-e86dc76793fd', '20260115-00003', '07dd08fb-c7d2-4756-b26c-16b8130366e8', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'open', '2026-01-15 01:25:55.866718+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('b520146c-dfaa-4b20-8777-946d954931f8', '20260115-00004', 'f771dc25-1064-49d3-87a0-0c1edd01eea7', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'open', '2026-01-15 01:26:26.617393+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('0a6e48fb-6e29-47d1-aa48-d6863a668e75', '20260115-00005', '219a23d7-5d81-46cf-8196-f2919dc9eeb5', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'open', '2026-01-15 01:27:26.32347+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('a458d892-6683-422c-bd8f-d2138ea92585', '20260115-00006', '35c8fc9c-06e0-4338-82c0-7238131f9026', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'open', '2026-01-15 01:30:44.414854+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('78c3d0c8-728d-41d3-95dd-21c59b9f5320', '20260115-00007', 'fd2b9166-9c40-4385-8166-f7e739506923', '4b29af2c-3737-4221-917a-8c6c493cef23', 'open', '2026-01-15 02:33:54.141909+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('5761bd33-e8c4-4a25-8a17-f59c66048994', '20260115-00008', '2230e801-8ce3-45ee-b1fe-d449692a5e02', '4b29af2c-3737-4221-917a-8c6c493cef23', 'open', '2026-01-15 02:34:14.291647+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('4edba681-965f-4be0-93d8-c933b55e3bc3', '20260115-00009', '16c287ff-724e-4549-8915-c48da74820f8', 'cae2fe6e-5842-46f7-bcae-90fed29eb9d0', 'open', '2026-01-15 02:52:00.957736+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('ac44732f-613d-4386-a21b-0f274cc68ae7', '20260115-00010', '96d17899-ac7b-49cc-aed2-2e152d8c5a54', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'open', '2026-01-15 03:03:44.80171+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('7e3440ee-a134-46dd-bec7-51eebc501d40', '20260115-00011', '099f9183-ee40-4427-9f60-dfcf57139060', '88040572-339c-4eca-a80d-7a8553d2d527', 'open', '2026-01-15 03:17:44.242766+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('b32fad79-7f1a-4a82-bde5-8f1508a25e51', '20260115-00012', '05e928a0-df00-46fc-b43a-d3cf06ac89b3', 'fe016cb6-b3ed-4f8e-95cb-cfc7c093702d', 'open', '2026-01-15 03:28:31.438286+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('0da7a971-42e7-4360-8a14-eef283f96302', '20260115-00013', '3474c77b-6615-405c-a03e-96ac403becd5', 'fe016cb6-b3ed-4f8e-95cb-cfc7c093702d', 'open', '2026-01-15 03:29:36.151358+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('c25444f2-4769-4ef9-9293-e7e6a63bd75e', '20260115-00014', '54d027c3-b7a4-4609-80ee-e6dacbf58b07', 'd955785e-7004-493c-9667-a5ddf4fb2700', 'open', '2026-01-15 03:40:52.970172+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('52dfc27b-40fa-4191-9e5d-a3f6366053aa', '20260115-00015', 'f2f3394b-8caf-4f20-a855-8d73de96cb54', '516a9c92-e780-4cfb-9e91-7241131bb386', 'open', '2026-01-15 04:20:34.781519+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('eba76d75-0a86-43d5-a9e2-fda7f967092b', '20260115-00016', '5ce15eda-307d-4f18-ab64-31aaf57632bf', '516a9c92-e780-4cfb-9e91-7241131bb386', 'open', '2026-01-15 05:01:42.91015+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('1c587f3a-288d-4210-9f07-1b1b7c09434d', '20260115-00017', 'b2d1a1b7-878c-4ec7-8297-d442cd908b92', '45ca6e6c-16e7-4904-a469-a0ec05df647d', 'open', '2026-01-15 05:15:15.004297+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('1acf0f5e-4e7b-4740-8376-ed5fe39cb9fc', '20260115-00018', 'ca5b3242-7ff4-429b-b10e-6406c5b005da', '65651a34-c377-4478-8fed-9f7fb037387e', 'open', '2026-01-15 05:27:56.995109+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('54c597a0-f092-4119-ae9d-fd38710dbab3', '20260115-00019', '140c4287-9ffd-424c-a1d8-509ff27085f2', 'cfac0d6b-4742-41ca-9736-c5731266b324', 'open', '2026-01-15 05:35:47.042644+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('d79587a8-804f-4f74-b40f-56ea5a4fdefd', '20260115-00020', '5f72c62f-2f25-4b32-bb5d-1405069702c9', '4cbd6e32-1b3d-4c6e-a32a-36d0d4262aca', 'open', '2026-01-15 05:44:32.259428+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('b942cab7-d2f8-4997-99ef-810b9b7d5df2', '20260115-00021', '482580f8-cc62-4cce-a319-3b0a3776e0e1', '65a13598-7310-409c-81c9-51acf0fd459f', 'open', '2026-01-15 05:56:13.897598+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('4262dbd9-5037-4dc3-856d-a59581d49ef8', '20260115-00022', '3ac443d4-1657-440f-aa44-464b7fd4f171', 'f3f87759-5fb8-41ec-811f-557c99fcd871', 'open', '2026-01-15 07:04:06.246333+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('08cc4ccc-ebbb-4932-8f9a-3b6078f00006', '20260115-00023', '772eb8ec-643b-4841-88a1-64657b3449c8', '23d867b8-4ab5-440f-9f72-ad36c26ae125', 'open', '2026-01-15 23:34:52.814719+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('744c1015-c00b-4f3c-a8fe-d89d47720009', '20260121-00024', '7bc3ec8a-040a-4d1e-91f9-a27fe011f7e5', '9399e42e-f2cf-469f-a199-e13b74fe33be', 'open', '2026-01-21 13:43:14.570111+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('fadaab05-0144-47de-8366-8dd9f70da097', '20260122-00025', '0da2912e-2b3b-48b1-a891-502750b98aae', '5ab48509-e3e7-4cdf-b095-2159157f64f9', 'open', '2026-01-22 01:54:49.183412+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('cb2873cc-3913-4699-b685-1d6ef842a2a9', '20260122-00026', 'd5f40ba5-7e79-43d1-8d9b-753afda3d857', 'd7f4f8b0-d16d-486d-8a19-0a07fcafa832', 'open', '2026-01-22 02:33:08.254691+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('ba496465-0049-4693-8014-04cc4c65a23b', '20260327-00027', 'ce5abc8e-f034-4b6d-92b5-9a3d0c9a94d6', '9febaaee-3c78-4e14-a93e-84172e7804cb', 'open', '2026-03-27 14:38:56.810544+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('8b332d10-db0a-4517-b01a-69b26dfaf151', '20260327-00028', '04bce6f2-cc1d-463b-b383-9f3c508c625a', '1ebc794a-b65e-46b0-92fb-4e4ce5a6c112', 'open', '2026-03-27 15:03:14.02001+01');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('3661bbb4-dab5-4886-aa09-ad02b3212457', '20260409-00029', '02c102e9-93f1-4230-8221-01bf865c9b52', '20168276-26cc-4bfd-b839-4dc534645a2b', 'open', '2026-04-09 13:07:46.837319+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('8df21257-a797-409a-9f5f-d46cdfabcb97', '20260519-00030', '21cf3d27-7c89-44b6-a76e-99034df43245', '1ebc794a-b65e-46b0-92fb-4e4ce5a6c112', 'open', '2026-05-19 15:52:35.505297+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('926b2f13-8e9c-4057-a001-b03d5a422ce4', '20260519-00031', 'a3428659-4464-4d29-8051-04526a0cb1f8', 'bd500fff-2b8b-4c10-b793-b2689bda1469', 'open', '2026-05-19 22:31:08.943758+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('56a985f7-3f5f-40e6-a795-ca53fd42b270', '20260519-00032', '26b9c990-52c5-4712-b2cc-5dfea595b46c', 'bd500fff-2b8b-4c10-b793-b2689bda1469', 'open', '2026-05-19 22:34:12.928312+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('4de236b3-42e1-4af8-b359-03f73d528a61', '20260520-00033', 'cdae7c36-4ae7-4621-931b-1d3304801cad', '979805aa-d355-4176-ac40-af24db0963ea', 'open', '2026-05-20 02:28:28.879157+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('cd918498-35d1-4b04-bddd-8b4898da6581', '20260611-00034', 'bc67f232-557d-44a2-bfaf-3ec13f9b25ba', 'a49a35cb-2def-4553-9d60-ae0ed71bd9ed', 'open', '2026-06-11 03:16:40.120087+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('39ad1e31-68a2-4059-81da-b7e9fc444ef3', '20260611-00035', '00703b79-e1f5-44e9-b9a3-924c2d1a9e23', '9309fd04-32c4-4f3c-8e98-dbb1d01036c1', 'open', '2026-06-11 03:17:55.985366+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('dafc05db-30d4-4152-ba4c-0e1e9edd71e0', '20260611-00036', '29f18d5b-7cd0-471a-a12a-91ce037813d3', 'e8425de0-abce-43c9-a999-4b2c9768cc5f', 'open', '2026-06-11 04:10:50.911348+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('4349c0bd-f9b7-4ade-9b16-fbe69908d4a2', '20260611-00037', '83ac2546-4890-4715-af5d-a34d2cc09936', '9aef3fbd-b66f-4f1b-939d-fcec1d6b20d1', 'open', '2026-06-11 04:26:24.236574+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('1fc1c182-f685-4c55-8edb-c3cea32bb540', '20260611-00038', '7e03d70d-d5b3-46ac-aa26-20ffb2d0b44a', '9aef3fbd-b66f-4f1b-939d-fcec1d6b20d1', 'open', '2026-06-11 04:26:56.629087+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('065df87a-03a4-4388-8aa3-167ba37ba295', '20260611-00039', '036d2f3d-dfcb-476e-b309-4bca51bf4d16', 'b94dfa2b-8312-4dde-a957-6b39f901b003', 'open', '2026-06-11 04:52:48.110039+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('a3269e0e-cfce-4052-8367-a50c4881a533', '20260611-00040', '39f5604b-eb7e-4821-886b-25d8e683f866', 'cb7ee1a9-080d-4f98-ad10-36069fe15d67', 'open', '2026-06-11 05:06:55.808901+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('a0c918be-ab64-472c-9399-5d7a2818fe23', '20260611-00041', '684099bf-e123-4ae1-b321-b87fd41ab1b8', '264fdedd-f54b-437d-8cb0-3a1f49a60c86', 'open', '2026-06-11 05:16:53.967602+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('fe77686c-f021-462c-bd66-456839c167d6', '20260611-00042', '738cea96-aa47-4d16-b4a2-b2d87eb79d15', 'f4d6ee9b-fdb3-4682-bd61-81c42d0475bb', 'open', '2026-06-11 05:17:25.820732+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('2cc94552-5049-4b49-bdf5-35453f82010b', '20260611-00043', '97cfbcf3-82e1-410f-9df4-162f1292755f', '968cd7b1-dab2-4297-b554-98b52e862118', 'open', '2026-06-11 05:26:44.364691+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('6e078760-aa2e-48e5-b252-da3c0f05f4df', '20260611-00044', '2a57b71b-ef88-46ca-9627-6b2bbac81bbd', 'b0242073-334d-44ca-908a-45ba27f97095', 'open', '2026-06-11 05:44:23.702383+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('03d6e288-d112-40af-a85e-102a58baabdd', '20260611-00045', '0f60b4ac-efe2-48b7-963f-506c18393002', '9252faae-55ce-4a88-8f5d-f3a84bf981d8', 'open', '2026-06-11 05:58:39.903066+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('2a7a155d-5ba6-4ac1-8dac-139ca4c26a52', '20260611-00046', '8a5580ac-fd7a-403c-bd41-6c6f9d9e072a', '8bc10c93-af3a-4f65-85f7-e6f2b1a78b27', 'open', '2026-06-11 06:22:21.035685+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('a7756302-c736-4bef-8309-264dd206ba79', '20260611-00047', 'e6b38727-d56c-40da-90ae-e9275e5ed197', '0ccdfc56-fd39-49ba-8dc3-f0873f51f581', 'open', '2026-06-11 06:42:16.680375+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('30268f8e-dc8c-41b6-b91b-92291f9fb461', '20260611-00048', '5d2101d0-d469-4949-b2c5-f49688f6c627', 'f7df8fce-ecaf-477e-9869-338f5c741044', 'open', '2026-06-11 06:50:03.307442+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('ce6feb20-d815-4ad6-b873-ffa40657198b', '20260611-00049', '11c3582c-e59d-4658-b12d-47718c1b101d', 'b27a82a2-24b4-4876-b97c-d414d7c2f010', 'open', '2026-06-11 07:09:07.234163+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('b89c134b-c3c3-45b7-85cc-5bffb881aca9', '20260611-00050', '8c4114c6-baf1-4ff1-bbbb-dffca28f4998', '988674b0-d2b7-42bd-accf-7df1429108c9', 'open', '2026-06-11 07:31:35.243156+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('b1988ef2-ca58-4782-8ad3-87076938c6f1', '20260611-00051', '1ab90f0c-d5d5-4e44-8f21-35792d58332c', '5921d4e2-85d7-43c1-828a-dee8f2402e05', 'open', '2026-06-11 07:51:04.968072+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('c8200eca-f6bb-4ee4-b7b7-62113dd9783d', '20260611-00052', '03b5a3be-a344-4174-bc04-dce65f4eabdf', '67c4b0cf-dd4e-44bf-b0bf-a9d5d0e47214', 'open', '2026-06-11 08:15:17.66337+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('53412022-2789-4630-b2f4-14d062fb50b0', '20260611-00053', '9ffc71c1-4368-42a5-b840-37b16d5c71f2', '5d2deb16-ed70-4727-bacf-d7a78c671779', 'open', '2026-06-11 08:24:11.134726+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('5dd7582f-3560-48a4-8391-b7b9969acf82', '20260611-00054', '5d79de9c-653f-4396-8607-c2ee9d6df36b', '5d2deb16-ed70-4727-bacf-d7a78c671779', 'open', '2026-06-11 08:36:48.026687+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('131ed1c1-3ead-49f0-b15a-81b566b47763', '20260611-00055', '2063d64d-7c9b-4c2f-917e-944c85c8ec23', '1ebc794a-b65e-46b0-92fb-4e4ce5a6c112', 'open', '2026-06-11 08:41:13.614089+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('6b089e9f-d19c-4ad7-b939-4af45f643ecc', '20260611-00056', '1b0d75f1-9f07-4bdf-bc29-3500768b77b0', '9b37e3c8-4aa6-4384-9712-7d44e7083530', 'open', '2026-06-11 08:47:56.473031+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('9a666cbc-682a-4749-b412-7d93b8386c90', '20260611-00057', '67313446-cd30-49a2-8aa3-5ab901047af6', '1ebc794a-b65e-46b0-92fb-4e4ce5a6c112', 'open', '2026-06-11 08:49:24.723528+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('c49dc8f0-38e8-4666-9ada-a48d5bb69089', '20260611-00058', '076ade70-6c5d-4ec6-b47c-3af6424010d0', '594c0a5c-15ff-420f-a1a7-293c60eb7f06', 'open', '2026-06-11 09:05:53.80058+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('c40895b1-29fc-4666-a29e-9067dbe4f8b7', '20260611-00059', 'a3ece9ce-72ae-405e-af8e-9ff06e3e753b', '27b2fd2b-a890-4ff0-89a1-1e6466305130', 'open', '2026-06-11 09:14:28.770695+02');
INSERT INTO public.intake_case (id, case_number, token, patient_id, status, created_at) VALUES ('24041ab5-162d-4f00-8642-0092e49033b3', '20260611-00060', '255ca86d-1712-4d49-af6b-e6e01fea5f64', '491d45d9-c3dc-4217-bccd-818c807eca6b', 'open', '2026-06-11 09:23:23.582249+02');


--
-- TOC entry 5124 (class 0 OID 16477)
-- Dependencies: 223
-- Data for Name: medical_cardio; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('886a844c-08e8-4ef9-87f4-6ab06db85245', 'd7f4f8b0-d16d-486d-8a19-0a07fcafa832', false, true, false, false, false, false, false, '2026-01-22 02:49:26.070397+01');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('4123bd31-060a-4437-9568-f2ff55d739a2', '9febaaee-3c78-4e14-a93e-84172e7804cb', false, false, false, false, false, false, false, '2026-03-27 14:46:41.590631+01');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('e7d6820a-559d-4ff1-beb4-5c9ff67872d5', '1ebc794a-b65e-46b0-92fb-4e4ce5a6c112', false, false, false, false, false, false, false, '2026-03-27 15:11:01.518144+01');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('95a290ce-e32f-4710-b98d-32839dec908d', '22373fb9-09ac-4508-8e2e-eb3b2cfc17f9', false, false, false, false, true, false, false, '2026-05-20 02:38:02.069189+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('7723698f-9785-4ff1-a7be-7a5a92426323', '5ab48509-e3e7-4cdf-b095-2159157f64f9', false, false, true, false, false, false, false, '2026-01-22 02:03:16.353401+01');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('abec7cd3-f255-4c06-b81e-e6258f6fea81', 'd553f409-a44f-4acc-8e26-4ac31ae36be1', false, false, false, false, false, false, false, '2026-06-10 14:29:15.049731+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('3b8c82c0-9a22-4de4-b041-85a5da634150', '3ffaedad-873d-458e-b6e3-d60a2059ae07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-10 14:54:26.869294+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('c138145f-42c8-45ab-a149-974f4372bb2e', '00646193-214e-4620-acae-08be9e5d661b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-10 15:48:19.856898+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('85c76c97-7687-45db-b0ee-81de98eb2825', 'da33cdee-a6a0-444b-8591-3eb20fcff244', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-10 16:06:53.503302+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('5a80f343-ec8d-4a5c-bc99-f01967530de2', '2551e0b1-6816-458c-aa23-e0b43133d612', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-10 17:06:37.353974+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('a553082d-a6d1-4082-95f1-a1ac001be49e', '5d9a75de-1a53-4cd0-8b94-f9494a79081c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-10 19:56:13.595507+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('e0d1d4c5-48ad-49fb-856a-4d62c3b4a129', '1df17a24-06b3-46d5-bf0d-c2de2a0aea38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-10 20:08:23.830427+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('6b7139e3-f9b9-433f-90b5-7478d9b91918', '8fd59ec6-a651-4e32-96eb-7b634703466a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-10 20:19:02.336315+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('2b351164-4d57-4123-bcef-665541f0d685', '9309fd04-32c4-4f3c-8e98-dbb1d01036c1', false, false, false, false, false, false, false, '2026-06-11 03:24:20.842287+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('3d996b07-d37f-4733-9a44-70a458f18556', 'e8425de0-abce-43c9-a999-4b2c9768cc5f', false, false, false, false, false, false, false, '2026-06-11 04:16:01.40255+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('8e1713a5-9e37-421f-a52c-70db864e4293', 'b94dfa2b-8312-4dde-a957-6b39f901b003', false, false, false, false, false, false, false, '2026-06-11 04:59:29.11184+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('edb96462-42fb-4d33-b1bb-2e618c16cf07', 'cb7ee1a9-080d-4f98-ad10-36069fe15d67', false, false, false, false, false, false, false, '2026-06-11 05:12:42.045602+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('3cc70034-7995-4740-b5bd-9270ae730100', 'a49a35cb-2def-4553-9d60-ae0ed71bd9ed', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 02:38:45.226632+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('f38c7bc0-01b9-449d-bc38-deaf565003ee', '968cd7b1-dab2-4297-b554-98b52e862118', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 05:27:36.380038+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('564e26d6-431f-4eee-8b19-08febdca413c', 'b0242073-334d-44ca-908a-45ba27f97095', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 05:46:56.233788+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('49180450-41a4-4955-a0d8-963b1527307b', '9252faae-55ce-4a88-8f5d-f3a84bf981d8', false, false, false, false, false, false, false, '2026-06-11 06:02:22.999095+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('dabf2b2a-e726-408c-a6bf-0e6898096b23', '8bc10c93-af3a-4f65-85f7-e6f2b1a78b27', false, false, false, false, false, false, false, '2026-06-11 06:25:46.078759+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('4b23b859-ee7a-4389-b547-dc690bdebf7f', '0ccdfc56-fd39-49ba-8dc3-f0873f51f581', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 06:43:00.720684+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('464fe6a5-4336-4549-b710-3e893c97e282', 'f7df8fce-ecaf-477e-9869-338f5c741044', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 06:50:50.067092+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('700fbe62-7492-45c5-8a1a-3f54e8cd759a', 'b27a82a2-24b4-4876-b97c-d414d7c2f010', false, false, false, false, false, false, false, '2026-06-11 07:11:17.558832+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('418c10f2-a37f-4b80-9707-ecf8ecb18ed6', '988674b0-d2b7-42bd-accf-7df1429108c9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 07:32:49.809737+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('2cca2d8b-73b7-47c6-a0a4-55813da53dfa', '5921d4e2-85d7-43c1-828a-dee8f2402e05', false, false, false, false, false, false, false, '2026-06-11 07:53:51.117932+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('713b4da0-eec1-4350-8e68-459083f164aa', '5d2deb16-ed70-4727-bacf-d7a78c671779', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 08:26:34.5373+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('8bd1aa69-4c91-4c4b-8a5f-423908f6c794', '03778cd7-7171-4aff-af59-442ef3367f5a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-21 18:38:57.862871+01');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('bf5cdbbd-7038-47e4-a883-566d629f6216', 'd955785e-7004-493c-9667-a5ddf4fb2700', false, false, false, false, false, false, false, '2025-12-15 14:37:29.860217+01');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('beae55ab-f2f1-4dae-a510-e1e2db16b6f4', '67c4b0cf-dd4e-44bf-b0bf-a9d5d0e47214', false, false, false, false, false, false, false, '2026-06-11 08:16:03.252931+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('a276388a-d887-459f-818c-230d6e8bfc7a', '27b2fd2b-a890-4ff0-89a1-1e6466305130', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 09:16:32.72375+02');
INSERT INTO public.medical_cardio (id, patient_id, blood_pressure, exertion_pain_breath, flat_lying_problem, irregular_pulse, night_symptoms, swollen_legs, thrombosis, created_at) VALUES ('2e07181a-330a-4be2-8025-385bec29424f', '491d45d9-c3dc-4217-bccd-818c807eca6b', true, false, false, false, false, false, false, '2026-06-11 09:25:59.949142+02');


--
-- TOC entry 5123 (class 0 OID 16461)
-- Dependencies: 222
-- Data for Name: medical_general; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('490595b0-a53c-4620-acea-37b3ca727e85', 'ca55b4e0-d723-4add-a8e4-74945a7e655a', true, 'April 2025', 'Burgdorf', 'Magen-Darm Beschwerden', false, NULL, true, 'Diuretika', false, NULL, '2026-01-14 22:35:42.702714+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('da2211aa-b63d-4ae0-9b52-2c6d86df9f1d', 'c7fb002e-18d0-4e5b-b645-68922cc1ca81', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-15 05:27:03.244069+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('7d05368c-82a0-4159-9a9f-1d40590ca5d7', 'cfac0d6b-4742-41ca-9736-c5731266b324', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-15 05:35:21.411158+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('1de416f3-5b28-44c7-8cb7-418000e79a82', 'ea3e097e-d630-48a8-ba63-6ff16642df04', false, NULL, NULL, NULL, false, NULL, false, NULL, false, NULL, '2026-01-15 05:58:18.629224+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('ce190dc3-9830-4d71-a976-d95074bd9157', '88d0bace-da1a-4b1e-b925-c4285c416271', true, 'Weihnachten 2025', 'Basel', 'Atembeschwerden', true, 'Atembeschwerden', false, NULL, false, NULL, '2026-01-15 07:38:46.978144+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('db6c3c0a-4f6f-41ba-8bc7-206713343ac6', 'dd91f468-2185-4ebe-a795-efb06c78b6c1', true, 'April 2025', 'Inselspital', 'Schlüsselbeinbruch', false, NULL, false, NULL, true, 'Nickel-Allergie, Pollen Allergie', '2026-01-15 23:45:24.818842+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('4e27e810-c5ba-48c4-93dd-7bef6f6468dd', 'eed357d0-f9af-428b-b50b-bb8482f3d679', false, NULL, NULL, NULL, false, NULL, false, NULL, false, NULL, '2026-01-21 13:45:40.693893+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('89fdecbe-78a8-488a-969c-92a7bcb34b2f', 'd7f4f8b0-d16d-486d-8a19-0a07fcafa832', true, '15.11.2025', 'Spitalzentrum Biel', 'Schulter Operation nach Unfall', false, NULL, true, 'Blutverdünner wegen der Operation.', false, NULL, '2026-01-22 02:49:26.070397+01', 86, 178, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('595ef392-a9f4-4eac-b8e3-29a325dfb6f3', '9febaaee-3c78-4e14-a93e-84172e7804cb', false, NULL, NULL, NULL, false, NULL, false, NULL, false, NULL, '2026-03-27 14:46:41.590631+01', 60, 165, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('73fd8601-1a6e-4504-b862-cee3b7bd2350', '1ebc794a-b65e-46b0-92fb-4e4ce5a6c112', true, 'Sommer 2025', 'Spital Emmental Burgdorf', 'Magendarm', false, NULL, false, NULL, true, 'Penicillin', '2026-03-27 15:11:01.518144+01', 80, 180, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('ee09759f-7ee0-4b71-a43a-33c1a755b627', '22373fb9-09ac-4508-8e2e-eb3b2cfc17f9', true, 'Februar 2026', 'Spital Emmental', 'Arm gebrochen', false, NULL, false, 'Aspirin C Brausetabl (Akut), TRIOFAN Hustenstiller Tropfen (Akut)', true, 'Pollen, Heu', '2026-05-20 02:38:02.069189+02', 45, 155, true, 'Ich kann meinen Arm nicht komplett strecken', 'Februar 2026', false, false, true, 'Arm operiert', false, NULL, true, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('ab9c333d-c183-4622-aeb5-0a6c68c005d8', '5ab48509-e3e7-4cdf-b095-2159157f64f9', true, 'Februar 2026', 'Spital Emmental', 'Darmspiegelung', false, NULL, true, 'Pantoprazol Sandoz Filmtabl 20 mg (Akut), VITAMIN D3 Streuli 4000 IE/ml zur Therapie (Dauermedikation)', true, 'Penicillin', '2026-01-22 02:03:16.353401+01', 85, 171, false, NULL, NULL, true, false, true, 'Darmspiegelung', false, NULL, false, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('e37aeae1-11db-488a-a075-cddc0957f959', 'd553f409-a44f-4acc-8e26-4ac31ae36be1', false, NULL, NULL, NULL, false, NULL, false, 'Aspirin Brausetabl 500 mg (Akut)', true, 'Pollen (Hasel)', '2026-06-10 14:29:15.049731+02', 75, 167, false, NULL, NULL, false, false, false, NULL, NULL, NULL, false, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('4c497f35-8110-4f98-9cd9-070f96da1c6a', '3ffaedad-873d-458e-b6e3-d60a2059ae07', NULL, NULL, NULL, NULL, NULL, NULL, false, 'VITAMIN D3 Streuli 4000 IE/ml zur Therapie (Akut)', NULL, NULL, '2026-06-10 14:54:26.869294+02', 50, 150, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('77e5effe-f37a-49fe-938c-b974214adf9d', '00646193-214e-4620-acae-08be9e5d661b', NULL, NULL, NULL, NULL, NULL, NULL, false, 'VITAMIN D3 Streuli 4000 IE/ml zur Therapie (Akut), Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut)', NULL, NULL, '2026-06-10 15:48:19.856898+02', 70, 170, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('ad99ab62-fc48-4419-a139-e22ecf641965', 'da33cdee-a6a0-444b-8591-3eb20fcff244', NULL, NULL, NULL, NULL, NULL, NULL, false, 'Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut), VITAMIN D3 Streuli 4000 IE/ml zur Therapie (Akut)', NULL, NULL, '2026-06-10 16:06:53.503302+02', 100, 200, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('4d65f3ee-0c7c-46e0-9c36-7aa65feb53b8', '2551e0b1-6816-458c-aa23-e0b43133d612', NULL, NULL, NULL, NULL, NULL, NULL, false, 'VITAMIN D3 Streuli 4000 IE/ml zur Therapie (Akut), Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut), Unbekanntes Medikament (Akut)', NULL, NULL, '2026-06-10 17:06:37.353974+02', 80, 180, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('a5a56140-1f75-41ca-8238-35b510ac6ae4', '5d9a75de-1a53-4cd0-8b94-f9494a79081c', NULL, NULL, NULL, NULL, NULL, NULL, true, 'Medikament (Keine ID hinterlegt) (Dauermedikation), Medikament (Pharmacode: 1358676) (Dauermedikation), Medikament (Pharmacode: 4146) (Dauermedikation), Medikament (Pharmacode: 5800) (Dauermedikati...', NULL, NULL, '2026-06-10 19:56:13.595507+02', 69, 189, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('c8ee2dc6-8f7c-4802-a760-8968ae3a1237', '1df17a24-06b3-46d5-bf0d-c2de2a0aea38', NULL, NULL, NULL, NULL, NULL, NULL, false, 'Radiogardase Cs (IMP D) Kaps 500 mg (Akut), Medikament (Keine Daten hinterlegt) (Akut), Medikament (Pharmacode: 1358676) (Akut), Medikament (Pharmacode: 4146) (Akut), Medikament (Pharmacode: 5800) ...', NULL, NULL, '2026-06-10 20:08:23.830427+02', 65, 170, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('793c442a-0a39-4821-9c04-cd898d7ed6e7', '8fd59ec6-a651-4e32-96eb-7b634703466a', NULL, NULL, NULL, NULL, NULL, NULL, false, 'GREENBIRD Bio Hanfsamen geschält (Akut), Medikament (Keine IDs hinterlegt) (Akut), PRAMIPEXOL Mepha Tabl 0.25 mg (Akut), Unbekanntes Produkt (ID: 4146) (Akut), LASIX Inj Lös 20 mg/2ml (Akut), CIPRO...', NULL, NULL, '2026-06-10 20:19:02.336315+02', 67, 169, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('bc030212-16af-47c1-916e-54037353fa0d', '9309fd04-32c4-4f3c-8e98-dbb1d01036c1', false, NULL, NULL, NULL, false, NULL, false, 'Valette Drag (Dauermedikation), Peptamen Neutral (Akut), Salbei Pastillen ohne Zucker (Akut)', false, NULL, '2026-06-11 03:24:20.842287+02', 66, 166, false, NULL, NULL, true, false, false, NULL, NULL, NULL, false, '[{"id": "1277337", "name": "Valette Drag", "category": "regular", "description": "Aus Documedis API"}, {"id": "1406543", "name": "Peptamen Neutral", "category": "acute", "description": "Aus Documedis API"}, {"id": "1005178", "name": "Salbei Pastillen ohne Zucker", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('adfbedc5-0607-46bc-b7b9-75b3c78e09d8', 'e8425de0-abce-43c9-a999-4b2c9768cc5f', true, 'April 2026', 'Inselspital', 'Schulter ausgekugelt', false, NULL, false, 'Irfen Filmtabl 600 mg (Akut), VITAMIN D3 Streuli 4000 IE/ml zur Therapie (Akut)', false, NULL, '2026-06-11 04:16:01.40255+02', 85, 180, true, 'Schulter eingeschränkt', 'April 2026', NULL, NULL, false, NULL, NULL, NULL, false, '[{"id": "1601442", "name": "Irfen Filmtabl 600 mg", "category": "acute", "description": "Aus Documedis API"}, {"id": "1269881", "name": "VITAMIN D3 Streuli 4000 IE/ml zur Therapie", "category": "acute", "description": "Gescannter Barcode: 7680334810020"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('e185ac3c-8107-41e1-a0fc-8ffabe37a5cf', 'b94dfa2b-8312-4dde-a957-6b39f901b003', true, 'Januar 2026', 'Lindenhofspital', 'Handgelenk gebrochen', false, NULL, false, 'Irfen Filmtabl 400 mg (Akut), Pantoprazol NOBEL Filmtabl 20 mg (Akut)', true, 'Silikon', '2026-06-11 04:59:29.11184+02', 57, 165, true, 'Hand noch in einer Schiene', 'Januar 2026', NULL, NULL, true, 'Hand Operation', false, NULL, false, '[{"id": "1601444", "name": "Irfen Filmtabl 400 mg", "category": "acute", "description": "Aus Documedis API"}, {"id": "1423898", "name": "Pantoprazol NOBEL Filmtabl 20 mg", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('81f1d123-2d1d-4957-bca3-e5bbfae98869', 'cb7ee1a9-080d-4f98-ad10-36069fe15d67', false, NULL, NULL, NULL, true, 'Haut nach Leberflecken kontrollieren lassen', false, 'Concerta Ret Tabl 18 mg (Dauermedikation), Ritalin LA Kaps 20 mg (Akut), VITAMIN D3 Streuli 4000 IE/ml zur Therapie (Dauermedikation)', false, NULL, '2026-06-11 05:12:42.045602+02', 65, 176, false, NULL, NULL, false, false, false, NULL, NULL, NULL, false, '[{"id": "124646", "name": "Concerta Ret Tabl 18 mg", "category": "regular", "description": "Aus Documedis API"}, {"id": "109043", "name": "Ritalin LA Kaps 20 mg", "category": "acute", "description": "Aus Documedis API"}, {"id": "1269881", "name": "VITAMIN D3 Streuli 4000 IE/ml zur Therapie", "category": "regular", "description": "Gescannter Barcode: 7680334810020"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('8cf4b524-e15b-4b91-a7d0-be9294545ad7', 'a49a35cb-2def-4553-9d60-ae0ed71bd9ed', NULL, NULL, NULL, NULL, NULL, NULL, false, 'Ritalin LA Kaps 40 mg (Dauermedikation), vitamin C-Loges (IMP D) Inj Lös 500 mg/5ml (Akut)', NULL, NULL, '2026-06-11 02:38:45.226632+02', 96, 190, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[{"id": "109085", "name": "Ritalin LA Kaps 40 mg", "category": "regular", "description": "Aus Documedis API"}, {"id": "1629664", "name": "vitamin C-Loges (IMP D) Inj Lös 500 mg/5ml", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('a30f1cb4-3b9b-43ab-b41c-66ca4a048e95', '968cd7b1-dab2-4297-b554-98b52e862118', NULL, NULL, NULL, NULL, NULL, NULL, false, 'Concerta Ret Tabl 18 mg (Dauermedikation)', NULL, NULL, '2026-06-11 05:27:36.380038+02', 50, 160, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[{"id": "124646", "name": "Concerta Ret Tabl 18 mg", "category": "regular", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('98df5783-d3d8-4844-8f0e-d98b11e18025', 'b0242073-334d-44ca-908a-45ba27f97095', NULL, NULL, NULL, NULL, NULL, NULL, false, 'Ritalin LA Kaps 20 mg (Dauermedikation), Aspirin Brausetabl 500 mg (Akut)', NULL, NULL, '2026-06-11 05:46:56.233788+02', 76, 167, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[{"id": "109043", "name": "Ritalin LA Kaps 20 mg", "category": "regular", "description": "Aus Documedis API"}, {"id": "110558", "name": "Aspirin Brausetabl 500 mg", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('b4b7ba21-8108-4dc8-8919-351ec4a75fa0', '9252faae-55ce-4a88-8f5d-f3a84bf981d8', false, NULL, NULL, NULL, false, NULL, false, 'Paracetamol Sandoz eco Tabl 500 mg (Akut), Allergie-Notfallset ISPI Filmtabl 10 mg/100 mg (Akut)', true, 'Laktose, Wallnüsse', '2026-06-11 06:02:22.999095+02', 85, 178, false, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, false, '[{"id": "1547675", "name": "Paracetamol Sandoz eco Tabl 500 mg", "category": "acute", "description": "Aus Documedis API"}, {"id": "1504294", "name": "Allergie-Notfallset ISPI Filmtabl 10 mg/100 mg", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('8ffd3ff4-5e90-4f22-a601-923962936123', '8bc10c93-af3a-4f65-85f7-e6f2b1a78b27', false, NULL, NULL, NULL, false, NULL, true, 'Ritalin LA Kaps 20 mg (Dauermedikation), Pharmalp Intimpflege Intimate Care (Akut)', false, NULL, '2026-06-11 06:25:46.078759+02', 55, 165, false, NULL, NULL, false, false, false, NULL, NULL, NULL, false, '[{"id": "109043", "name": "Ritalin LA Kaps 20 mg", "category": "regular", "description": "Aus Documedis API"}, {"id": "1426514", "name": "Pharmalp Intimpflege Intimate Care", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('74abb5b0-e370-4ed8-9c3a-af381926ef88', '0ccdfc56-fd39-49ba-8dc3-f0873f51f581', NULL, NULL, NULL, NULL, NULL, NULL, false, 'Ritalin LA Kaps 10 mg (Dauermedikation), Concerta Ret Tabl 36 mg (Dauermedikation)', NULL, NULL, '2026-06-11 06:43:00.720684+02', 60, 160, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[{"id": "1128496", "name": "Ritalin LA Kaps 10 mg", "category": "regular", "description": "Aus Documedis API"}, {"id": "124648", "name": "Concerta Ret Tabl 36 mg", "category": "regular", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('d3103705-1bfd-4377-8529-f0d8c5afea9e', 'f7df8fce-ecaf-477e-9869-338f5c741044', NULL, NULL, NULL, NULL, NULL, NULL, true, 'Concerta Ret Tabl 54 mg (Dauermedikation), Dafalgan Brausetabl 500 mg (Akut)', NULL, NULL, '2026-06-11 06:50:50.067092+02', 69, 177, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[{"id": "124650", "name": "Concerta Ret Tabl 54 mg", "category": "regular", "description": "Aus Documedis API"}, {"id": "17778", "name": "Dafalgan Brausetabl 500 mg", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('b8ead7c0-1275-4d73-8004-bef20b82077b', 'b27a82a2-24b4-4876-b97c-d414d7c2f010', false, NULL, NULL, NULL, false, NULL, true, 'Concerta Ret Tabl 36 mg (Dauermedikation), Triofan Allergie Lutschtabl (Akut)', false, NULL, '2026-06-11 07:11:17.558832+02', 65, 175, false, NULL, NULL, false, true, false, NULL, NULL, NULL, false, '[{"id": "124648", "name": "Concerta Ret Tabl 36 mg", "category": "regular", "description": "Aus Documedis API"}, {"id": "1035585", "name": "Triofan Allergie Lutschtabl", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('914cc745-54eb-40b1-811c-522629ff5a66', '988674b0-d2b7-42bd-accf-7df1429108c9', NULL, NULL, NULL, NULL, NULL, NULL, true, 'Concerta Ret Tabl 18 mg (Dauermedikation)', NULL, NULL, '2026-06-11 07:32:49.809737+02', 74, 174, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[{"id": "124646", "name": "Concerta Ret Tabl 18 mg", "category": "regular", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('68e9262a-b1ff-4c01-ba98-58ad53f02f28', '5921d4e2-85d7-43c1-828a-dee8f2402e05', false, NULL, NULL, NULL, false, NULL, true, 'Ritalin LA Kaps 20 mg (Dauermedikation), Dafalgan Supp 600 mg (Akut)', false, NULL, '2026-06-11 07:53:51.117932+02', 66, 172, false, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, false, '[{"id": "109043", "name": "Ritalin LA Kaps 20 mg", "category": "regular", "description": "Aus Documedis API"}, {"id": "35605", "name": "Dafalgan Supp 600 mg", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('37d69cb7-7915-460c-9d33-dd78b35cdb03', '5d2deb16-ed70-4727-bacf-d7a78c671779', NULL, NULL, NULL, NULL, NULL, NULL, true, 'Aspirin Complex Gran (Akut), Vitrakvi Kaps 25 mg (Akut)', NULL, NULL, '2026-06-11 08:26:34.5373+02', 85, 180, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[{"id": "1051753", "name": "Aspirin Complex Gran", "category": "acute", "description": "Aus Documedis API"}, {"id": "1443604", "name": "Vitrakvi Kaps 25 mg", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('b0df3f71-7beb-4557-8f4e-8d89268b76be', '03778cd7-7171-4aff-af59-442ef3367f5a', NULL, NULL, NULL, NULL, NULL, NULL, true, 'Concerta Ret Tabl 27 mg (Dauermedikation), Aspirin C Brausetabl (Akut)', NULL, NULL, '2026-01-21 18:38:57.862871+01', 60, 165, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[{"id": "1063900", "name": "Concerta Ret Tabl 27 mg", "category": "regular", "description": "Aus Documedis API"}, {"id": "2525", "name": "Aspirin C Brausetabl", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('d11ca2aa-2b5f-4bf0-b8f2-c05da2dbbcca', 'd955785e-7004-493c-9667-a5ddf4fb2700', false, NULL, NULL, NULL, false, NULL, true, 'Aspirin C Brausetabl (Dauermedikation)', false, NULL, '2025-12-15 14:48:18.280052+01', 85, 185, false, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, false, '[{"id": "2525", "name": "Aspirin C Brausetabl", "category": "regular", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('802be636-4a5a-42ac-ba32-585dd2004a95', '67c4b0cf-dd4e-44bf-b0bf-a9d5d0e47214', false, NULL, NULL, NULL, false, NULL, true, 'Flatulex Kautabl 42 mg (Akut), Diazepam Supp 5 mg (Akut)', false, NULL, '2026-06-11 08:16:03.252931+02', 75, 170, false, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, false, '[{"id": "24728", "name": "Flatulex Kautabl 42 mg", "category": "acute", "description": "Aus Documedis API"}, {"id": "1183852", "name": "Diazepam Supp 5 mg", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('f37f8626-5f9f-44d0-b379-aeb31a2b5aa6', '27b2fd2b-a890-4ff0-89a1-1e6466305130', NULL, NULL, NULL, NULL, NULL, NULL, true, 'Triofan Heuschnupfen Promopaket 03.2026 italienisch (Akut), Fexofenadin Sandoz Filmtabl 120 mg (Akut)', NULL, NULL, '2026-06-11 09:16:32.72375+02', 86, 186, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[{"id": "1650039", "name": "Triofan Heuschnupfen Promopaket 03.2026 italienisch", "category": "acute", "description": "Aus Documedis API"}, {"id": "1341239", "name": "Fexofenadin Sandoz Filmtabl 120 mg", "category": "acute", "description": "Aus Documedis API"}]');
INSERT INTO public.medical_general (id, patient_id, hospitalized, hospitalized_when, hospitalized_where, hospitalized_why, regular_gp, regular_gp_why, regular_medication, medications, allergies, allergies_text, created_at, weight_kg, height_cm, limited_activity, limited_activity_how, limited_activity_since, pregnant_possible, breastfeeding, anesthesia, anesthesia_why, anesthesia_problems, anesthesia_problems_which, family_anesthesia_problems, medications_json) VALUES ('2fd68deb-e06e-4e43-8719-9ddf1e1704c4', '491d45d9-c3dc-4217-bccd-818c807eca6b', false, NULL, NULL, NULL, false, NULL, true, 'Vitamin C PANPHARMA (IMP D) Inj Lös 500 mg/5ml (Dauermedikation), Magnesium Axapharm Brausetabl 375 mg (Akut)', false, NULL, '2026-06-11 09:25:59.949142+02', 60, 166, false, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, false, '[{"id": "1635692", "name": "Vitamin C PANPHARMA (IMP D) Inj Lös 500 mg/5ml", "category": "regular", "description": "Aus Documedis API"}, {"id": "1306405", "name": "Magnesium Axapharm Brausetabl 375 mg", "category": "acute", "description": "Aus Documedis API"}]');


--
-- TOC entry 5125 (class 0 OID 16491)
-- Dependencies: 224
-- Data for Name: medical_lung; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('55bec776-1690-4c88-aef7-7343cb6f4f43', 'd7f4f8b0-d16d-486d-8a19-0a07fcafa832', true, true, true, '2026-01-22 02:49:26.070397+01', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('35acff64-9ede-452f-a3ad-755317ba5d34', '9febaaee-3c78-4e14-a93e-84172e7804cb', false, false, false, '2026-03-27 14:46:41.590631+01', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('98e1e750-22e3-4b98-acac-14b6585bec2f', '1ebc794a-b65e-46b0-92fb-4e4ce5a6c112', false, false, false, '2026-03-27 15:11:01.518144+01', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('85d14199-4850-46e1-acb6-bf16d7d7508b', '22373fb9-09ac-4508-8e2e-eb3b2cfc17f9', false, false, true, '2026-05-20 02:38:02.069189+02', true);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('fdd101fd-0962-407f-ab07-e0f20b3fd555', '5ab48509-e3e7-4cdf-b095-2159157f64f9', false, false, false, '2026-01-22 02:03:16.353401+01', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('f8a22901-e576-488c-a6bd-11628408af7c', 'd553f409-a44f-4acc-8e26-4ac31ae36be1', false, false, false, '2026-06-10 14:29:15.049731+02', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('17428321-9c39-4c00-8f8e-27a4f3662232', '3ffaedad-873d-458e-b6e3-d60a2059ae07', NULL, NULL, NULL, '2026-06-10 14:54:26.869294+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('4a5a8609-7776-4de2-8119-c546a5b45d8c', '00646193-214e-4620-acae-08be9e5d661b', NULL, NULL, NULL, '2026-06-10 15:48:19.856898+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('a132ca31-a707-4360-8a4c-63f2e50c08bc', 'da33cdee-a6a0-444b-8591-3eb20fcff244', NULL, NULL, NULL, '2026-06-10 16:06:53.503302+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('14704318-8990-4ce0-bc9a-8bfefa232b05', '2551e0b1-6816-458c-aa23-e0b43133d612', NULL, NULL, NULL, '2026-06-10 17:06:37.353974+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('2f9d048c-3aaf-4964-bd63-78ba879b2f6a', '5d9a75de-1a53-4cd0-8b94-f9494a79081c', NULL, NULL, NULL, '2026-06-10 19:56:13.595507+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('be3d04de-3e20-4736-aa0d-9a2c5988d015', '1df17a24-06b3-46d5-bf0d-c2de2a0aea38', NULL, NULL, NULL, '2026-06-10 20:08:23.830427+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('80d8b49f-9d6d-45d2-904f-3a52cc334578', '8fd59ec6-a651-4e32-96eb-7b634703466a', NULL, NULL, NULL, '2026-06-10 20:19:02.336315+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('7d25683e-299d-4362-be0f-9a875506e1c7', '9309fd04-32c4-4f3c-8e98-dbb1d01036c1', false, false, false, '2026-06-11 03:24:20.842287+02', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('f0af6133-892e-4e1a-97bd-4998dcefaf1d', 'e8425de0-abce-43c9-a999-4b2c9768cc5f', false, false, false, '2026-06-11 04:16:01.40255+02', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('1b291882-636f-4115-bf63-358167511d87', 'b94dfa2b-8312-4dde-a957-6b39f901b003', false, false, false, '2026-06-11 04:59:29.11184+02', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('080efb0c-2493-4c81-9974-aa09b09f1a8c', 'cb7ee1a9-080d-4f98-ad10-36069fe15d67', false, false, false, '2026-06-11 05:12:42.045602+02', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('9c0ff255-8742-4dfd-83d7-fb48473e9fb4', 'a49a35cb-2def-4553-9d60-ae0ed71bd9ed', NULL, NULL, NULL, '2026-06-11 02:38:45.226632+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('bc619b85-6204-4e82-9bde-ec2a3b8c8add', '968cd7b1-dab2-4297-b554-98b52e862118', NULL, NULL, NULL, '2026-06-11 05:27:36.380038+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('97968f31-ca26-4ef6-9548-f26a0f010dc5', 'b0242073-334d-44ca-908a-45ba27f97095', NULL, NULL, NULL, '2026-06-11 05:46:56.233788+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('f19e56e7-de32-4449-902d-ec592a099a28', '9252faae-55ce-4a88-8f5d-f3a84bf981d8', false, false, false, '2026-06-11 06:02:22.999095+02', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('4af925e6-bef3-4446-9eaa-55af22bccfb3', '8bc10c93-af3a-4f65-85f7-e6f2b1a78b27', false, false, false, '2026-06-11 06:25:46.078759+02', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('3f090e39-569a-4dff-92ba-a7db15f61cd8', '0ccdfc56-fd39-49ba-8dc3-f0873f51f581', NULL, NULL, NULL, '2026-06-11 06:43:00.720684+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('5f8bf99f-f6e6-457f-93cf-66b81a822f18', 'f7df8fce-ecaf-477e-9869-338f5c741044', NULL, NULL, NULL, '2026-06-11 06:50:50.067092+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('102727a0-642e-4c87-9f86-25b843677d17', 'b27a82a2-24b4-4876-b97c-d414d7c2f010', false, false, false, '2026-06-11 07:11:17.558832+02', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('41d0350d-d484-450a-9cba-dd4d8d722fb4', '988674b0-d2b7-42bd-accf-7df1429108c9', NULL, NULL, NULL, '2026-06-11 07:32:49.809737+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('43939838-0bef-4ada-89c7-38147e28adb1', '5921d4e2-85d7-43c1-828a-dee8f2402e05', false, false, false, '2026-06-11 07:53:51.117932+02', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('3d021087-c57a-419b-89d0-e130322d1bdb', '5d2deb16-ed70-4727-bacf-d7a78c671779', NULL, NULL, NULL, '2026-06-11 08:26:34.5373+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('3738b90f-d8a3-48db-b5d5-26b4ba90489b', '03778cd7-7171-4aff-af59-442ef3367f5a', NULL, NULL, NULL, '2026-01-21 18:38:57.862871+01', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('a6ce993b-1319-49c2-bd74-c50399642e57', 'd955785e-7004-493c-9667-a5ddf4fb2700', false, false, false, '2025-12-15 14:38:15.403187+01', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('62c0938a-b782-4ffc-843f-dc05105d3e27', '67c4b0cf-dd4e-44bf-b0bf-a9d5d0e47214', false, false, false, '2026-06-11 08:16:03.252931+02', false);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('29c93f9c-e5e1-4fba-a28b-d776d52ec940', '27b2fd2b-a890-4ff0-89a1-1e6466305130', NULL, NULL, NULL, '2026-06-11 09:16:32.72375+02', NULL);
INSERT INTO public.medical_lung (id, patient_id, smoker, dyspnea, asthma, created_at, inhaler) VALUES ('4b21f51b-59fb-41a3-8f47-709a9ec26de0', '491d45d9-c3dc-4217-bccd-818c807eca6b', false, false, false, '2026-06-11 09:25:59.949142+02', false);


--
-- TOC entry 5126 (class 0 OID 16505)
-- Dependencies: 225
-- Data for Name: medical_other; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('1b65e7d9-a823-4faa-b8c0-4d04bba99535', 'd7f4f8b0-d16d-486d-8a19-0a07fcafa832', false, false, false, '2026-01-22 02:49:26.070397+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('1380d3da-e26d-40ef-9a3b-0a61518a8263', '9febaaee-3c78-4e14-a93e-84172e7804cb', false, false, false, '2026-03-27 14:46:41.590631+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('7dd3c1fe-2ac3-4e4d-9a22-27c3dc419936', '1ebc794a-b65e-46b0-92fb-4e4ce5a6c112', false, false, false, '2026-03-27 15:11:01.518144+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('9537d619-5367-4c89-9c8c-eb41b3b3b7cc', '22373fb9-09ac-4508-8e2e-eb3b2cfc17f9', true, false, false, '2026-05-20 02:38:02.069189+02', false, false, false, false, true, false, false, NULL, false, false, false, false, true, true, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('7b931029-8fa9-4a74-b9aa-5955d4941bd7', '5ab48509-e3e7-4cdf-b095-2159157f64f9', false, false, false, '2026-01-22 02:03:16.353401+01', false, false, false, false, true, false, false, NULL, false, false, false, true, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('cf16750e-335d-440d-9935-7018dec71098', 'd553f409-a44f-4acc-8e26-4ac31ae36be1', false, false, false, '2026-06-10 14:29:15.049731+02', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('a98b30af-021c-4334-8dcd-624c3ef98f9f', '3ffaedad-873d-458e-b6e3-d60a2059ae07', NULL, NULL, NULL, '2026-06-10 14:54:26.869294+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('3d82bdce-6674-4aeb-bbcc-76a18c3f9bdc', '00646193-214e-4620-acae-08be9e5d661b', NULL, NULL, NULL, '2026-06-10 15:48:19.856898+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('b1132e0e-34ed-465a-a04d-7d3a4d937f98', 'da33cdee-a6a0-444b-8591-3eb20fcff244', NULL, NULL, NULL, '2026-06-10 16:06:53.503302+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('748f0a9a-a1e1-4eb9-be34-c1153d537da9', '2551e0b1-6816-458c-aa23-e0b43133d612', NULL, NULL, NULL, '2026-06-10 17:06:37.353974+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('79be7301-8e6a-4a3f-b569-7817a8b304a7', '5d9a75de-1a53-4cd0-8b94-f9494a79081c', NULL, NULL, NULL, '2026-06-10 19:56:13.595507+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('11fbff03-c411-477e-a39a-3d6ed10753bf', '1df17a24-06b3-46d5-bf0d-c2de2a0aea38', NULL, NULL, NULL, '2026-06-10 20:08:23.830427+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('cce5f09b-e87a-474a-a90f-b73268f4d868', '8fd59ec6-a651-4e32-96eb-7b634703466a', NULL, NULL, NULL, '2026-06-10 20:19:02.336315+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('7d7eb309-469f-46f3-8e82-f145ca234bdf', '9309fd04-32c4-4f3c-8e98-dbb1d01036c1', false, false, false, '2026-06-11 03:24:20.842287+02', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('3e24e7d2-0c20-456a-8a49-edde71eef5f5', 'e8425de0-abce-43c9-a999-4b2c9768cc5f', false, false, false, '2026-06-11 04:16:01.40255+02', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('4dee1622-e10a-4f34-820b-33b9318d2d2a', 'b94dfa2b-8312-4dde-a957-6b39f901b003', false, false, false, '2026-06-11 04:59:29.11184+02', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('59326cd8-7222-4902-9bbc-53231ac5d6d9', 'cb7ee1a9-080d-4f98-ad10-36069fe15d67', false, true, false, '2026-06-11 05:12:42.045602+02', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('6140a3cb-45a1-4dbc-a0f9-c374dd066e1b', 'a49a35cb-2def-4553-9d60-ae0ed71bd9ed', NULL, NULL, NULL, '2026-06-11 02:38:45.226632+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('43239ae9-dece-4e9a-9bb5-fdc887d49ae7', '968cd7b1-dab2-4297-b554-98b52e862118', NULL, NULL, NULL, '2026-06-11 05:27:36.380038+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('e99cc051-f464-43ad-84ff-cd116f2f96bb', 'b0242073-334d-44ca-908a-45ba27f97095', NULL, NULL, NULL, '2026-06-11 05:46:56.233788+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('9b7981fd-a026-4d56-b536-81b965d806f9', '9252faae-55ce-4a88-8f5d-f3a84bf981d8', false, false, false, '2026-06-11 06:02:22.999095+02', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('15aff6ce-dc9d-49c6-a524-1f1abc523319', '8bc10c93-af3a-4f65-85f7-e6f2b1a78b27', false, false, false, '2026-06-11 06:25:46.078759+02', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('a22f6ef7-d7e4-4ecd-9b78-8f9de652e299', '0ccdfc56-fd39-49ba-8dc3-f0873f51f581', NULL, NULL, NULL, '2026-06-11 06:43:00.720684+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('bdd9d5c0-f5b3-479a-97eb-c3e0b6b7e9fb', 'f7df8fce-ecaf-477e-9869-338f5c741044', NULL, NULL, NULL, '2026-06-11 06:50:50.067092+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('e609cb17-7a95-4e55-a0e5-1ea1e797515a', 'b27a82a2-24b4-4876-b97c-d414d7c2f010', false, false, false, '2026-06-11 07:11:17.558832+02', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('3ea9f411-f330-4364-aef4-ab77092fb752', '988674b0-d2b7-42bd-accf-7df1429108c9', NULL, NULL, NULL, '2026-06-11 07:32:49.809737+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('613146be-d55b-40bc-85ad-a6e1d25a8b40', '5921d4e2-85d7-43c1-828a-dee8f2402e05', false, false, false, '2026-06-11 07:53:51.117932+02', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('394e547d-9190-4f99-839c-3771105505f8', '5d2deb16-ed70-4727-bacf-d7a78c671779', NULL, NULL, NULL, '2026-06-11 08:26:34.5373+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('11fc94c5-0fd6-406e-beed-b22c7900a6bd', '03778cd7-7171-4aff-af59-442ef3367f5a', NULL, NULL, NULL, '2026-01-21 18:38:57.862871+01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('3373befa-51da-43e5-92a3-8bac002e92b3', 'd955785e-7004-493c-9667-a5ddf4fb2700', false, false, false, '2025-12-15 14:38:41.804295+01', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('4cb15978-0346-4133-9193-58549112d09a', '67c4b0cf-dd4e-44bf-b0bf-a9d5d0e47214', false, false, false, '2026-06-11 08:16:03.252931+02', false, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('c479b3a9-a2bb-4258-a7a2-d6a71a837e24', '27b2fd2b-a890-4ff0-89a1-1e6466305130', NULL, NULL, NULL, '2026-06-11 09:16:32.72375+02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.medical_other (id, patient_id, diabetes, cancer, coagulation, created_at, paralysis_stroke, neurological, kidney_problem, liver_problem, reflux, anemia, transfusion, transfusion_problems, infection_disease, wound_healing_problems, inflammation_last_12mo, substances, bad_teeth, dentures, implanted_device) VALUES ('22c1feb3-8df1-468f-9f51-c2698181b6aa', '491d45d9-c3dc-4217-bccd-818c807eca6b', false, false, false, '2026-06-11 09:25:59.949142+02', true, false, false, false, false, false, false, NULL, false, false, false, false, false, false, false);


--
-- TOC entry 5121 (class 0 OID 16427)
-- Dependencies: 220
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('d955785e-7004-493c-9667-a5ddf4fb2700', 'Max', 'Muster', '1985-06-15', '756.1234.5678.90', '2025-12-15 14:35:33.732512+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('ca55b4e0-d723-4add-a8e4-74945a7e655a', 'Trudi', 'Widmer', '1978-08-10', '756.2000.3333.55', '2026-01-14 22:35:42.702714+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('999e3814-a82e-49f8-bb9a-2b785d9739a8', 'Hans', 'Gerber', '1988-05-04', '756.1233.3321.55', '2026-01-15 01:01:36.837628+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('eef15250-a3e2-4846-9414-42af12e15eed', 'Ulrich', 'Moser', '1973-06-06', '756.7890.0987.55', '2026-01-15 01:17:33.670631+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('64e80b3b-2524-4dea-83ee-d4c353721fc7', 'Tom', 'Hänni', '2000-03-02', '756.5555.6666.00', '2026-01-15 02:02:06.668324+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('4b29af2c-3737-4221-917a-8c6c493cef23', 'Dieter', 'Kuhn', '1994-04-04', '756.0404.4040.99', '2026-01-15 02:33:48.962178+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('cae2fe6e-5842-46f7-bcae-90fed29eb9d0', 'Heinz', 'Moser', '1990-10-10', '756.1111.2222.33', '2026-01-15 02:51:55.712773+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('88040572-339c-4eca-a80d-7a8553d2d527', 'Jakob', 'Sulzer', '1975-12-22', '756.9999.8888.77', '2026-01-15 03:17:41.879635+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('581ff8db-70c2-4d3e-b46b-3cb379c4de93', 'Bob', 'Marley', '1995-09-05', '756.3636.6363.11', '2026-01-15 03:27:35.963084+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('fe016cb6-b3ed-4f8e-95cb-cfc7c093702d', 'Bob', 'Martin', '1995-05-05', '756.5555.5555.55', '2026-01-15 03:28:29.954102+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('516a9c92-e780-4cfb-9e91-7241131bb386', 'Hannah', 'Feller', '2004-04-04', '756.4444.4444.44', '2026-01-15 04:20:09.235282+01', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('45ca6e6c-16e7-4904-a469-a0ec05df647d', 'Herbert', 'Trachsel', '1983-03-03', '756.3333.3333.33', '2026-01-15 05:15:12.114732+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('c7fb002e-18d0-4e5b-b645-68922cc1ca81', 'g', 'g', '2001-11-11', '756.1111.1111.11', '2026-01-15 05:27:03.244069+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('65651a34-c377-4478-8fed-9f7fb037387e', 'Anna', 'Egli', '1996-06-06', '756.0606.0606.66', '2026-01-15 05:27:55.434803+01', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('cfac0d6b-4742-41ca-9736-c5731266b324', 'z', 'z', '2000-12-12', '756.1212.1212.12', '2026-01-15 05:35:21.411158+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('4cbd6e32-1b3d-4c6e-a32a-36d0d4262aca', 'Simon', 'Schwarz', '1999-10-10', '756.1010.1010.10', '2026-01-15 05:44:31.090202+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('65a13598-7310-409c-81c9-51acf0fd459f', 'Viki', 'Ziki', '2004-04-04', '756.4000.0004.04', '2026-01-15 05:56:12.169433+01', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('ea3e097e-d630-48a8-ba63-6ff16642df04', 'Viki', 'Ziki', '2004-04-04', '756.4000.0004.04', '2026-01-15 05:58:18.629224+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('f3f87759-5fb8-41ec-811f-557c99fcd871', 'Georg', 'Hamlet', '1978-05-10', '756.8220.0008.82', '2026-01-15 07:03:26.266005+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('88d0bace-da1a-4b1e-b925-c4285c416271', 'Georg', 'Hamlet', '1978-10-05', '756.8220.0008.82', '2026-01-15 07:38:46.978144+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('23d867b8-4ab5-440f-9f72-ad36c26ae125', 'Kilian', 'König', '1998-08-19', '756.6008.9874.99', '2026-01-15 23:34:47.539956+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('dd91f468-2185-4ebe-a795-efb06c78b6c1', 'Kilian', 'König', '1998-08-19', '756.6008.9874.99', '2026-01-15 23:45:24.818842+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('9399e42e-f2cf-469f-a199-e13b74fe33be', 'Heinz', 'Mond', '1990-01-21', '756.1990.2101.21', '2026-01-21 13:31:51.543923+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('eed357d0-f9af-428b-b50b-bb8482f3d679', 'Heinz', 'Mond', '1990-01-21', '756 1990.2101.21', '2026-01-21 13:45:40.693893+01', NULL);
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('03778cd7-7171-4aff-af59-442ef3367f5a', 'Anna', 'Widmer', '1998-08-08', '756.1998.0808.08', '2026-01-21 18:38:57.862871+01', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('5ab48509-e3e7-4cdf-b095-2159157f64f9', 'Fiona', 'Schwab', '2005-05-05', '756.2005.0505.05', '2026-01-22 01:54:49.172756+01', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('d7f4f8b0-d16d-486d-8a19-0a07fcafa832', 'Kurt', 'Wenger', '1970-10-05', '756.1970.0510.10', '2026-01-22 02:33:08.244346+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('9febaaee-3c78-4e14-a93e-84172e7804cb', 'Johann', 'Junker', '2010-10-10', '756.1000.1000.10', '2026-03-27 14:38:56.789386+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('1ebc794a-b65e-46b0-92fb-4e4ce5a6c112', 'Max', 'Muster', '2000-01-01', '756.2000.0101.01', '2026-03-27 15:03:02.308606+01', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('20168276-26cc-4bfd-b839-4dc534645a2b', 'Brijesh', 'Shivanna', '2000-10-10', '756.2000.2000.10', '2026-04-09 13:07:46.822514+02', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('bd500fff-2b8b-4c10-b793-b2689bda1469', 'Bob', 'Muster', '2002-02-02', '756.2002.2002.22', '2026-05-19 22:31:08.886375+02', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('979805aa-d355-4176-ac40-af24db0963ea', 'Lea', 'Meiser', '2015-05-05', '756.2015.0505.05', '2026-05-20 02:28:28.810846+02', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('22373fb9-09ac-4508-8e2e-eb3b2cfc17f9', 'Lea', 'Meiser', '2015-05-15', '756.0515.2025.15', '2026-05-20 02:38:02.069189+02', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('d553f409-a44f-4acc-8e26-4ac31ae36be1', 'Helen', 'Mustermann', '1980-08-08', '756.1980.1010.10', '2026-06-10 14:29:15.049731+02', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('3ffaedad-873d-458e-b6e3-d60a2059ae07', 'Ü', 'Ü', '2026-06-06', '756.6666.0606.06', '2026-06-10 14:54:26.869294+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('00646193-214e-4620-acae-08be9e5d661b', 'Ä', 'Ä', '2026-06-01', '756.0000.1111.00', '2026-06-10 15:48:19.856898+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('da33cdee-a6a0-444b-8591-3eb20fcff244', 'L', 'L', '2026-06-10', '756.0000.0000.00', '2026-06-10 16:06:53.503302+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('2551e0b1-6816-458c-aa23-e0b43133d612', 'T', 'T', '2026-06-10', '756.9999.6666.77', '2026-06-10 17:06:37.353974+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('5d9a75de-1a53-4cd0-8b94-f9494a79081c', 'K', 'Kk', '2026-06-10', '756.8989.8787.00', '2026-06-10 19:56:13.595507+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('1df17a24-06b3-46d5-bf0d-c2de2a0aea38', 'D', 'De', '2026-06-10', '756.1234.4321.00', '2026-06-10 20:08:23.830427+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('8fd59ec6-a651-4e32-96eb-7b634703466a', 'H', 'H', '2026-06-10', '756.6789.0000.99', '2026-06-10 20:19:02.336315+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('a49a35cb-2def-4553-9d60-ae0ed71bd9ed', 'Tim', 'Tobler', '2006-06-06', '756.2006.0606.06', '2026-06-11 02:38:45.226632+02', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('9309fd04-32c4-4f3c-8e98-dbb1d01036c1', 'Mina', 'Arasaka', '1991-10-10', '756.1991.1010.10', '2026-06-11 03:17:55.978617+02', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('e8425de0-abce-43c9-a999-4b2c9768cc5f', 'Ben', 'Schlosser', '1988-08-08', '756.0808.1988.88', '2026-06-11 04:10:50.811081+02', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('9aef3fbd-b66f-4f1b-939d-fcec1d6b20d1', 'Clara', 'Himmel', '2002-09-11', '756.1109.2002.11', '2026-06-11 04:26:24.191522+02', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('b94dfa2b-8312-4dde-a957-6b39f901b003', 'Samuel', 'Horn', '2010-01-10', '756.1001.2010.10', '2026-06-11 04:52:48.066308+02', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('cb7ee1a9-080d-4f98-ad10-36069fe15d67', 'Daria', 'Schmitz', '1994-04-04', '756.1994.0404.04', '2026-06-11 05:06:55.764403+02', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('264fdedd-f54b-437d-8cb0-3a1f49a60c86', 'G', 'G', '2006-06-06', '756.0606.2006.06', '2026-06-11 05:16:53.928318+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('f4d6ee9b-fdb3-4682-bd61-81c42d0475bb', 'G', 'G', '2006-06-06', '756.2006.0606.06', '2026-06-11 05:17:25.773871+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('968cd7b1-dab2-4297-b554-98b52e862118', 'P', 'P', '2026-06-11', '756.6666.9999.00', '2026-06-11 05:26:44.319256+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('b0242073-334d-44ca-908a-45ba27f97095', 'Ho', 'Hi', '1986-06-18', '756.1986.1806.18', '2026-06-11 05:44:23.656629+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('9252faae-55ce-4a88-8f5d-f3a84bf981d8', 'Ting', 'Liu', '2002-02-02', '756.2002.0202.02', '2026-06-11 05:58:39.85336+02', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('8bc10c93-af3a-4f65-85f7-e6f2b1a78b27', 'Jana', 'Wyss', '1995-05-15', '756.1995.1505.15', '2026-06-11 06:22:20.948418+02', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('0ccdfc56-fd39-49ba-8dc3-f0873f51f581', 'R', 'Ra', '2007-06-07', '756.6767.2007.67', '2026-06-11 06:42:16.636063+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('f7df8fce-ecaf-477e-9869-338f5c741044', 'B', 'B', '2006-06-11', '756.2006.1106.11', '2026-06-11 06:50:03.262485+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('b27a82a2-24b4-4876-b97c-d414d7c2f010', 'Rey', 'Yuumi', '2000-05-15', '756.2000.1505.15', '2026-06-11 07:09:07.196111+02', 'female');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('988674b0-d2b7-42bd-accf-7df1429108c9', 'a', 'a', '2004-04-04', '756.2004.0404.04', '2026-06-11 07:31:35.204974+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('5921d4e2-85d7-43c1-828a-dee8f2402e05', 'Johan', 'Sommer', '1997-07-07', '756.1997.0707.07', '2026-06-11 07:51:04.928143+02', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('67c4b0cf-dd4e-44bf-b0bf-a9d5d0e47214', 'd', 'd', '2003-03-03', '756.2003.0303.03', '2026-06-11 08:15:17.624885+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('5d2deb16-ed70-4727-bacf-d7a78c671779', 'trent', 'bennet', '1999-11-11', '756.1999.1111.11', '2026-06-11 08:24:11.046806+02', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('9b37e3c8-4aa6-4384-9712-7d44e7083530', 'r', 'r', '1998-08-08', '756.1998.0808.08', '2026-06-11 08:47:56.384667+02', 'other');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('594c0a5c-15ff-420f-a1a7-293c60eb7f06', 'Tom', 'Burri', '2003-03-03', '756.2003.0303.03', '2026-06-11 09:05:53.718689+02', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('27b2fd2b-a890-4ff0-89a1-1e6466305130', 'Kurt', 'Zbinden', '1982-12-12', '756.1982.1212.12', '2026-06-11 09:14:28.732931+02', 'male');
INSERT INTO public.patient (id, first_name, last_name, birth_date, ahv_number, created_at, gender) VALUES ('491d45d9-c3dc-4217-bccd-818c807eca6b', 'Jaden', 'Yuki', '1988-08-31', '756.1988.3108.31', '2026-06-11 09:23:23.542536+02', 'male');


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 227
-- Name: intake_case_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.intake_case_seq', 60, true);


--
-- TOC entry 4948 (class 2606 OID 16455)
-- Name: contact contact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- TOC entry 4958 (class 2606 OID 16529)
-- Name: emergency_contact emergency_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emergency_contact
    ADD CONSTRAINT emergency_contact_pkey PRIMARY KEY (id);


--
-- TOC entry 4960 (class 2606 OID 16554)
-- Name: intake_case intake_case_case_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intake_case
    ADD CONSTRAINT intake_case_case_number_key UNIQUE (case_number);


--
-- TOC entry 4962 (class 2606 OID 16552)
-- Name: intake_case intake_case_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intake_case
    ADD CONSTRAINT intake_case_pkey PRIMARY KEY (id);


--
-- TOC entry 4964 (class 2606 OID 16556)
-- Name: intake_case intake_case_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intake_case
    ADD CONSTRAINT intake_case_token_key UNIQUE (token);


--
-- TOC entry 4952 (class 2606 OID 16485)
-- Name: medical_cardio medical_cardio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_cardio
    ADD CONSTRAINT medical_cardio_pkey PRIMARY KEY (id);


--
-- TOC entry 4950 (class 2606 OID 16471)
-- Name: medical_general medical_general_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_general
    ADD CONSTRAINT medical_general_pkey PRIMARY KEY (id);


--
-- TOC entry 4954 (class 2606 OID 16499)
-- Name: medical_lung medical_lung_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_lung
    ADD CONSTRAINT medical_lung_pkey PRIMARY KEY (id);


--
-- TOC entry 4956 (class 2606 OID 16513)
-- Name: medical_other medical_other_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_other
    ADD CONSTRAINT medical_other_pkey PRIMARY KEY (id);


--
-- TOC entry 4946 (class 2606 OID 16439)
-- Name: patient patient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (id);


--
-- TOC entry 4943 (class 1259 OID 16567)
-- Name: ix_patient_ahv_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_patient_ahv_number ON public.patient USING btree (ahv_number);


--
-- TOC entry 4944 (class 1259 OID 16568)
-- Name: ix_patient_lastname_birth; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_patient_lastname_birth ON public.patient USING btree (last_name, birth_date);


--
-- TOC entry 4965 (class 1259 OID 16566)
-- Name: ux_intake_case_case_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_intake_case_case_number ON public.intake_case USING btree (case_number);


--
-- TOC entry 4966 (class 1259 OID 16565)
-- Name: ux_intake_case_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_intake_case_token ON public.intake_case USING btree (token);


--
-- TOC entry 4972 (class 2606 OID 16530)
-- Name: emergency_contact emergency_contact_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emergency_contact
    ADD CONSTRAINT emergency_contact_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patient(id) ON DELETE CASCADE;


--
-- TOC entry 4967 (class 2606 OID 16456)
-- Name: contact fk_contact_patient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT fk_contact_patient FOREIGN KEY (patient_id) REFERENCES public.patient(id) ON DELETE CASCADE;


--
-- TOC entry 4969 (class 2606 OID 16486)
-- Name: medical_cardio fk_medical_cardio_patient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_cardio
    ADD CONSTRAINT fk_medical_cardio_patient FOREIGN KEY (patient_id) REFERENCES public.patient(id) ON DELETE CASCADE;


--
-- TOC entry 4968 (class 2606 OID 16472)
-- Name: medical_general fk_medical_general_patient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_general
    ADD CONSTRAINT fk_medical_general_patient FOREIGN KEY (patient_id) REFERENCES public.patient(id) ON DELETE CASCADE;


--
-- TOC entry 4970 (class 2606 OID 16500)
-- Name: medical_lung fk_medical_lung_patient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_lung
    ADD CONSTRAINT fk_medical_lung_patient FOREIGN KEY (patient_id) REFERENCES public.patient(id) ON DELETE CASCADE;


--
-- TOC entry 4971 (class 2606 OID 16514)
-- Name: medical_other fk_medical_other_patient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_other
    ADD CONSTRAINT fk_medical_other_patient FOREIGN KEY (patient_id) REFERENCES public.patient(id) ON DELETE CASCADE;


--
-- TOC entry 4973 (class 2606 OID 16557)
-- Name: intake_case intake_case_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intake_case
    ADD CONSTRAINT intake_case_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patient(id) ON DELETE CASCADE;


-- Completed on 2026-06-11 09:42:13

--
-- PostgreSQL database dump complete
--

\unrestrict neRnFEjD7ENaSkrEirEbeNCq64cKMKShBtlyb0CzzoGdjCLUliZYGXikCFbz56x

