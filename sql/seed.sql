--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-2.pgdg100+1)
-- Dumped by pg_dump version 12.2 (Debian 12.2-2.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: agg_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agg_result (
    min_timestamp double precision,
    au01r double precision,
    au02r double precision,
    au04r double precision,
    au05r double precision,
    au06r double precision,
    au07r double precision,
    au09r double precision,
    au10r double precision,
    au12r double precision,
    au14r double precision,
    au15r double precision,
    au17r double precision,
    au20r double precision,
    au23r double precision,
    au25r double precision,
    au26r double precision,
    au45r double precision,
    au01c double precision,
    au02c double precision,
    au04c double precision,
    au05c double precision,
    au06c double precision,
    au07c double precision,
    au09c double precision,
    au10c double precision,
    au12c double precision,
    au14c double precision,
    au15c double precision,
    au17c double precision,
    au20c double precision,
    au23c double precision,
    au25c double precision,
    au26c double precision,
    au28c double precision,
    au45c double precision,
    grouped_seconds double precision,
    success numeric,
    topic bigint,
    pitch double precision,
    intensity double precision,
    silence boolean
);


ALTER TABLE public.agg_result OWNER TO postgres;

--
-- Name: COLUMN agg_result.au01r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au01r IS 'Inner brow raiser(intensity)';


--
-- Name: COLUMN agg_result.au02r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au02r IS 'Outer brow raiser(intensity)';


--
-- Name: COLUMN agg_result.au04r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au04r IS 'Brow lowerer(intensity)';


--
-- Name: COLUMN agg_result.au05r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au05r IS 'Upper lid raiser(intensity)';


--
-- Name: COLUMN agg_result.au06r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au06r IS 'Cheek raiser(intensity)';


--
-- Name: COLUMN agg_result.au07r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au07r IS 'Lid Tightener(intensity)';


--
-- Name: COLUMN agg_result.au09r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au09r IS 'Nose Wrinkler(intensity)';


--
-- Name: COLUMN agg_result.au10r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au10r IS 'Upper Lip Raiser(intensity)';


--
-- Name: COLUMN agg_result.au12r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au12r IS 'Lip Corner Puller(intensity)';


--
-- Name: COLUMN agg_result.au14r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au14r IS 'Dimpler(intensity)';


--
-- Name: COLUMN agg_result.au15r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au15r IS 'Lip Corner Depressor(intensity)';


--
-- Name: COLUMN agg_result.au17r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au17r IS 'Chin Raiser(intensity)';


--
-- Name: COLUMN agg_result.au20r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au20r IS 'Lip stretcher(intensity)';


--
-- Name: COLUMN agg_result.au23r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au23r IS 'Lip Tightener(intensity)';


--
-- Name: COLUMN agg_result.au25r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au25r IS 'Lips part**(intensity)';


--
-- Name: COLUMN agg_result.au26r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au26r IS 'Jaw Drop(intensity)';


--
-- Name: COLUMN agg_result.au45r; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au45r IS 'Blink(intensity)';


--
-- Name: COLUMN agg_result.au01c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au01c IS 'Inner brow raiser(presence)';


--
-- Name: COLUMN agg_result.au02c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au02c IS 'Outer brow raiser(presence)';


--
-- Name: COLUMN agg_result.au04c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au04c IS 'Brow lowerer(presence)';


--
-- Name: COLUMN agg_result.au05c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au05c IS 'Upper lid raiser(presence)';


--
-- Name: COLUMN agg_result.au06c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au06c IS 'Cheek raiser(presence)';


--
-- Name: COLUMN agg_result.au07c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au07c IS 'Lid Tightener(presence)';


--
-- Name: COLUMN agg_result.au09c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au09c IS 'Nose Wrinkler(presence)';


--
-- Name: COLUMN agg_result.au10c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au10c IS 'Upper Lip Raiser(presence)';


--
-- Name: COLUMN agg_result.au12c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au12c IS 'Lip Corner Puller(presence)';


--
-- Name: COLUMN agg_result.au14c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au14c IS 'Dimpler(presence)';


--
-- Name: COLUMN agg_result.au15c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au15c IS 'Lip Corner Depressor(presence)';


--
-- Name: COLUMN agg_result.au17c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au17c IS 'Chin Raiser(presence)';


--
-- Name: COLUMN agg_result.au20c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au20c IS 'Lip stretcher(presence)';


--
-- Name: COLUMN agg_result.au23c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au23c IS 'Lip Tightener(presence)';


--
-- Name: COLUMN agg_result.au25c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au25c IS 'Lips part**(presence)';


--
-- Name: COLUMN agg_result.au26c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au26c IS 'Jaw Drop(presence)';


--
-- Name: COLUMN agg_result.au28c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au28c IS 'Lip Suck(presence)';


--
-- Name: COLUMN agg_result.au45c; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.agg_result.au45c IS 'Blink(presence)';


--
-- Name: aggregate_features(double precision, double precision, double precision, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.aggregate_features(start_time double precision, end_time double precision, resolution double precision, video_hash character varying) RETURNS SETOF public.agg_result
    LANGUAGE sql STABLE
    AS $$
select
  FLOOR(timestamp / resolution) * resolution as min_timestamp,
  avg("AU01_r"),
  avg("AU02_r"),
  avg("AU04_r"),
  avg("AU05_r"),
  avg("AU06_r"),
  avg("AU07_r"),
  avg("AU09_r"),
  avg("AU10_r"),
  avg("AU12_r"),
  avg("AU14_r"),
  avg("AU15_r"),
  avg("AU17_r"),
  avg("AU20_r"),
  avg("AU23_r"),
  avg("AU25_r"),
  avg("AU26_r"),
  avg("AU45_r"),
  avg("AU01_c"),
  avg("AU02_c"),
  avg("AU04_c"),
  avg("AU05_c"),
  avg("AU06_c"),
  avg("AU07_c"),
  avg("AU09_c"),
  avg("AU10_c"),
  avg("AU12_c"),
  avg("AU14_c"),
  avg("AU15_c"),
  avg("AU17_c"),
  avg("AU20_c"),
  avg("AU23_c"),
  avg("AU25_c"),
  avg("AU26_c"),
  avg("AU28_c"),
  avg("AU45_c"),
  FLOOR(timestamp / resolution) as grouped_seconds,
  avg("success"),
  min("topic") as topic,
  avg("pitch"),
  avg("intensity"),
  bool_and("silence")
from
  data d inner join videos v
on d.video = v.id
where
  timestamp >= start_time
  AND timestamp < end_time
  AND v.hash = video_hash
group by
  grouped_seconds
order by min_timestamp;
$$;


ALTER FUNCTION public.aggregate_features(start_time double precision, end_time double precision, resolution double precision, video_hash character varying) OWNER TO postgres;

--
-- Name: data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data (
    frame bigint,
    face_id bigint,
    "timestamp" double precision,
    confidence double precision,
    success bigint,
    gaze_0_x double precision,
    gaze_0_y double precision,
    gaze_0_z double precision,
    gaze_1_x double precision,
    gaze_1_y double precision,
    gaze_1_z double precision,
    gaze_angle_x double precision,
    gaze_angle_y double precision,
    eye_lmk_x_0 double precision,
    eye_lmk_x_1 double precision,
    eye_lmk_x_2 double precision,
    eye_lmk_x_3 double precision,
    eye_lmk_x_4 double precision,
    eye_lmk_x_5 double precision,
    eye_lmk_x_6 double precision,
    eye_lmk_x_7 double precision,
    eye_lmk_x_8 double precision,
    eye_lmk_x_9 double precision,
    eye_lmk_x_10 double precision,
    eye_lmk_x_11 double precision,
    eye_lmk_x_12 double precision,
    eye_lmk_x_13 double precision,
    eye_lmk_x_14 double precision,
    eye_lmk_x_15 double precision,
    eye_lmk_x_16 double precision,
    eye_lmk_x_17 double precision,
    eye_lmk_x_18 double precision,
    eye_lmk_x_19 double precision,
    eye_lmk_x_20 double precision,
    eye_lmk_x_21 double precision,
    eye_lmk_x_22 double precision,
    eye_lmk_x_23 double precision,
    eye_lmk_x_24 double precision,
    eye_lmk_x_25 double precision,
    eye_lmk_x_26 double precision,
    eye_lmk_x_27 double precision,
    eye_lmk_x_28 double precision,
    eye_lmk_x_29 double precision,
    eye_lmk_x_30 double precision,
    eye_lmk_x_31 double precision,
    eye_lmk_x_32 double precision,
    eye_lmk_x_33 double precision,
    eye_lmk_x_34 double precision,
    eye_lmk_x_35 double precision,
    eye_lmk_x_36 double precision,
    eye_lmk_x_37 double precision,
    eye_lmk_x_38 double precision,
    eye_lmk_x_39 double precision,
    eye_lmk_x_40 double precision,
    eye_lmk_x_41 double precision,
    eye_lmk_x_42 double precision,
    eye_lmk_x_43 double precision,
    eye_lmk_x_44 double precision,
    eye_lmk_x_45 double precision,
    eye_lmk_x_46 double precision,
    eye_lmk_x_47 double precision,
    eye_lmk_x_48 double precision,
    eye_lmk_x_49 double precision,
    eye_lmk_x_50 double precision,
    eye_lmk_x_51 double precision,
    eye_lmk_x_52 double precision,
    eye_lmk_x_53 double precision,
    eye_lmk_x_54 double precision,
    eye_lmk_x_55 double precision,
    eye_lmk_y_0 double precision,
    eye_lmk_y_1 double precision,
    eye_lmk_y_2 double precision,
    eye_lmk_y_3 double precision,
    eye_lmk_y_4 double precision,
    eye_lmk_y_5 double precision,
    eye_lmk_y_6 double precision,
    eye_lmk_y_7 double precision,
    eye_lmk_y_8 double precision,
    eye_lmk_y_9 double precision,
    eye_lmk_y_10 double precision,
    eye_lmk_y_11 double precision,
    eye_lmk_y_12 double precision,
    eye_lmk_y_13 double precision,
    eye_lmk_y_14 double precision,
    eye_lmk_y_15 double precision,
    eye_lmk_y_16 double precision,
    eye_lmk_y_17 double precision,
    eye_lmk_y_18 double precision,
    eye_lmk_y_19 double precision,
    eye_lmk_y_20 double precision,
    eye_lmk_y_21 double precision,
    eye_lmk_y_22 double precision,
    eye_lmk_y_23 double precision,
    eye_lmk_y_24 double precision,
    eye_lmk_y_25 double precision,
    eye_lmk_y_26 double precision,
    eye_lmk_y_27 double precision,
    eye_lmk_y_28 double precision,
    eye_lmk_y_29 double precision,
    eye_lmk_y_30 double precision,
    eye_lmk_y_31 double precision,
    eye_lmk_y_32 double precision,
    eye_lmk_y_33 double precision,
    eye_lmk_y_34 double precision,
    eye_lmk_y_35 double precision,
    eye_lmk_y_36 double precision,
    eye_lmk_y_37 double precision,
    eye_lmk_y_38 double precision,
    eye_lmk_y_39 double precision,
    eye_lmk_y_40 double precision,
    eye_lmk_y_41 double precision,
    eye_lmk_y_42 double precision,
    eye_lmk_y_43 double precision,
    eye_lmk_y_44 double precision,
    eye_lmk_y_45 double precision,
    eye_lmk_y_46 double precision,
    eye_lmk_y_47 double precision,
    eye_lmk_y_48 double precision,
    eye_lmk_y_49 double precision,
    eye_lmk_y_50 double precision,
    eye_lmk_y_51 double precision,
    eye_lmk_y_52 double precision,
    eye_lmk_y_53 double precision,
    eye_lmk_y_54 double precision,
    eye_lmk_y_55 double precision,
    "eye_lmk_X_0" double precision,
    "eye_lmk_X_1" double precision,
    "eye_lmk_X_2" double precision,
    "eye_lmk_X_3" double precision,
    "eye_lmk_X_4" double precision,
    "eye_lmk_X_5" double precision,
    "eye_lmk_X_6" double precision,
    "eye_lmk_X_7" double precision,
    "eye_lmk_X_8" double precision,
    "eye_lmk_X_9" double precision,
    "eye_lmk_X_10" double precision,
    "eye_lmk_X_11" double precision,
    "eye_lmk_X_12" double precision,
    "eye_lmk_X_13" double precision,
    "eye_lmk_X_14" double precision,
    "eye_lmk_X_15" double precision,
    "eye_lmk_X_16" double precision,
    "eye_lmk_X_17" double precision,
    "eye_lmk_X_18" double precision,
    "eye_lmk_X_19" double precision,
    "eye_lmk_X_20" double precision,
    "eye_lmk_X_21" double precision,
    "eye_lmk_X_22" double precision,
    "eye_lmk_X_23" double precision,
    "eye_lmk_X_24" double precision,
    "eye_lmk_X_25" double precision,
    "eye_lmk_X_26" double precision,
    "eye_lmk_X_27" double precision,
    "eye_lmk_X_28" double precision,
    "eye_lmk_X_29" double precision,
    "eye_lmk_X_30" double precision,
    "eye_lmk_X_31" double precision,
    "eye_lmk_X_32" double precision,
    "eye_lmk_X_33" double precision,
    "eye_lmk_X_34" double precision,
    "eye_lmk_X_35" double precision,
    "eye_lmk_X_36" double precision,
    "eye_lmk_X_37" double precision,
    "eye_lmk_X_38" double precision,
    "eye_lmk_X_39" double precision,
    "eye_lmk_X_40" double precision,
    "eye_lmk_X_41" double precision,
    "eye_lmk_X_42" double precision,
    "eye_lmk_X_43" double precision,
    "eye_lmk_X_44" double precision,
    "eye_lmk_X_45" double precision,
    "eye_lmk_X_46" double precision,
    "eye_lmk_X_47" double precision,
    "eye_lmk_X_48" double precision,
    "eye_lmk_X_49" double precision,
    "eye_lmk_X_50" double precision,
    "eye_lmk_X_51" double precision,
    "eye_lmk_X_52" double precision,
    "eye_lmk_X_53" double precision,
    "eye_lmk_X_54" double precision,
    "eye_lmk_X_55" double precision,
    "eye_lmk_Y_0" double precision,
    "eye_lmk_Y_1" double precision,
    "eye_lmk_Y_2" double precision,
    "eye_lmk_Y_3" double precision,
    "eye_lmk_Y_4" double precision,
    "eye_lmk_Y_5" double precision,
    "eye_lmk_Y_6" double precision,
    "eye_lmk_Y_7" double precision,
    "eye_lmk_Y_8" double precision,
    "eye_lmk_Y_9" double precision,
    "eye_lmk_Y_10" double precision,
    "eye_lmk_Y_11" double precision,
    "eye_lmk_Y_12" double precision,
    "eye_lmk_Y_13" double precision,
    "eye_lmk_Y_14" double precision,
    "eye_lmk_Y_15" double precision,
    "eye_lmk_Y_16" double precision,
    "eye_lmk_Y_17" double precision,
    "eye_lmk_Y_18" double precision,
    "eye_lmk_Y_19" double precision,
    "eye_lmk_Y_20" double precision,
    "eye_lmk_Y_21" double precision,
    "eye_lmk_Y_22" double precision,
    "eye_lmk_Y_23" double precision,
    "eye_lmk_Y_24" double precision,
    "eye_lmk_Y_25" double precision,
    "eye_lmk_Y_26" double precision,
    "eye_lmk_Y_27" double precision,
    "eye_lmk_Y_28" double precision,
    "eye_lmk_Y_29" double precision,
    "eye_lmk_Y_30" double precision,
    "eye_lmk_Y_31" double precision,
    "eye_lmk_Y_32" double precision,
    "eye_lmk_Y_33" double precision,
    "eye_lmk_Y_34" double precision,
    "eye_lmk_Y_35" double precision,
    "eye_lmk_Y_36" double precision,
    "eye_lmk_Y_37" double precision,
    "eye_lmk_Y_38" double precision,
    "eye_lmk_Y_39" double precision,
    "eye_lmk_Y_40" double precision,
    "eye_lmk_Y_41" double precision,
    "eye_lmk_Y_42" double precision,
    "eye_lmk_Y_43" double precision,
    "eye_lmk_Y_44" double precision,
    "eye_lmk_Y_45" double precision,
    "eye_lmk_Y_46" double precision,
    "eye_lmk_Y_47" double precision,
    "eye_lmk_Y_48" double precision,
    "eye_lmk_Y_49" double precision,
    "eye_lmk_Y_50" double precision,
    "eye_lmk_Y_51" double precision,
    "eye_lmk_Y_52" double precision,
    "eye_lmk_Y_53" double precision,
    "eye_lmk_Y_54" double precision,
    "eye_lmk_Y_55" double precision,
    "eye_lmk_Z_0" double precision,
    "eye_lmk_Z_1" double precision,
    "eye_lmk_Z_2" double precision,
    "eye_lmk_Z_3" double precision,
    "eye_lmk_Z_4" double precision,
    "eye_lmk_Z_5" double precision,
    "eye_lmk_Z_6" double precision,
    "eye_lmk_Z_7" double precision,
    "eye_lmk_Z_8" double precision,
    "eye_lmk_Z_9" double precision,
    "eye_lmk_Z_10" double precision,
    "eye_lmk_Z_11" double precision,
    "eye_lmk_Z_12" double precision,
    "eye_lmk_Z_13" double precision,
    "eye_lmk_Z_14" double precision,
    "eye_lmk_Z_15" double precision,
    "eye_lmk_Z_16" double precision,
    "eye_lmk_Z_17" double precision,
    "eye_lmk_Z_18" double precision,
    "eye_lmk_Z_19" double precision,
    "eye_lmk_Z_20" double precision,
    "eye_lmk_Z_21" double precision,
    "eye_lmk_Z_22" double precision,
    "eye_lmk_Z_23" double precision,
    "eye_lmk_Z_24" double precision,
    "eye_lmk_Z_25" double precision,
    "eye_lmk_Z_26" double precision,
    "eye_lmk_Z_27" double precision,
    "eye_lmk_Z_28" double precision,
    "eye_lmk_Z_29" double precision,
    "eye_lmk_Z_30" double precision,
    "eye_lmk_Z_31" double precision,
    "eye_lmk_Z_32" double precision,
    "eye_lmk_Z_33" double precision,
    "eye_lmk_Z_34" double precision,
    "eye_lmk_Z_35" double precision,
    "eye_lmk_Z_36" double precision,
    "eye_lmk_Z_37" double precision,
    "eye_lmk_Z_38" double precision,
    "eye_lmk_Z_39" double precision,
    "eye_lmk_Z_40" double precision,
    "eye_lmk_Z_41" double precision,
    "eye_lmk_Z_42" double precision,
    "eye_lmk_Z_43" double precision,
    "eye_lmk_Z_44" double precision,
    "eye_lmk_Z_45" double precision,
    "eye_lmk_Z_46" double precision,
    "eye_lmk_Z_47" double precision,
    "eye_lmk_Z_48" double precision,
    "eye_lmk_Z_49" double precision,
    "eye_lmk_Z_50" double precision,
    "eye_lmk_Z_51" double precision,
    "eye_lmk_Z_52" double precision,
    "eye_lmk_Z_53" double precision,
    "eye_lmk_Z_54" double precision,
    "eye_lmk_Z_55" double precision,
    "pose_Tx" double precision,
    "pose_Ty" double precision,
    "pose_Tz" double precision,
    "pose_Rx" double precision,
    "pose_Ry" double precision,
    "pose_Rz" double precision,
    x_0 double precision,
    x_1 double precision,
    x_2 double precision,
    x_3 double precision,
    x_4 double precision,
    x_5 double precision,
    x_6 double precision,
    x_7 double precision,
    x_8 double precision,
    x_9 double precision,
    x_10 double precision,
    x_11 double precision,
    x_12 double precision,
    x_13 double precision,
    x_14 double precision,
    x_15 double precision,
    x_16 double precision,
    x_17 double precision,
    x_18 double precision,
    x_19 double precision,
    x_20 double precision,
    x_21 double precision,
    x_22 double precision,
    x_23 double precision,
    x_24 double precision,
    x_25 double precision,
    x_26 double precision,
    x_27 double precision,
    x_28 double precision,
    x_29 double precision,
    x_30 double precision,
    x_31 double precision,
    x_32 double precision,
    x_33 double precision,
    x_34 double precision,
    x_35 double precision,
    x_36 double precision,
    x_37 double precision,
    x_38 double precision,
    x_39 double precision,
    x_40 double precision,
    x_41 double precision,
    x_42 double precision,
    x_43 double precision,
    x_44 double precision,
    x_45 double precision,
    x_46 double precision,
    x_47 double precision,
    x_48 double precision,
    x_49 double precision,
    x_50 double precision,
    x_51 double precision,
    x_52 double precision,
    x_53 double precision,
    x_54 double precision,
    x_55 double precision,
    x_56 double precision,
    x_57 double precision,
    x_58 double precision,
    x_59 double precision,
    x_60 double precision,
    x_61 double precision,
    x_62 double precision,
    x_63 double precision,
    x_64 double precision,
    x_65 double precision,
    x_66 double precision,
    x_67 double precision,
    y_0 double precision,
    y_1 double precision,
    y_2 double precision,
    y_3 double precision,
    y_4 double precision,
    y_5 double precision,
    y_6 double precision,
    y_7 double precision,
    y_8 double precision,
    y_9 double precision,
    y_10 double precision,
    y_11 double precision,
    y_12 double precision,
    y_13 double precision,
    y_14 double precision,
    y_15 double precision,
    y_16 double precision,
    y_17 double precision,
    y_18 double precision,
    y_19 double precision,
    y_20 double precision,
    y_21 double precision,
    y_22 double precision,
    y_23 double precision,
    y_24 double precision,
    y_25 double precision,
    y_26 double precision,
    y_27 double precision,
    y_28 double precision,
    y_29 double precision,
    y_30 double precision,
    y_31 double precision,
    y_32 double precision,
    y_33 double precision,
    y_34 double precision,
    y_35 double precision,
    y_36 double precision,
    y_37 double precision,
    y_38 double precision,
    y_39 double precision,
    y_40 double precision,
    y_41 double precision,
    y_42 double precision,
    y_43 double precision,
    y_44 double precision,
    y_45 double precision,
    y_46 double precision,
    y_47 double precision,
    y_48 double precision,
    y_49 double precision,
    y_50 double precision,
    y_51 double precision,
    y_52 double precision,
    y_53 double precision,
    y_54 double precision,
    y_55 double precision,
    y_56 double precision,
    y_57 double precision,
    y_58 double precision,
    y_59 double precision,
    y_60 double precision,
    y_61 double precision,
    y_62 double precision,
    y_63 double precision,
    y_64 double precision,
    y_65 double precision,
    y_66 double precision,
    y_67 double precision,
    "X_0" double precision,
    "X_1" double precision,
    "X_2" double precision,
    "X_3" double precision,
    "X_4" double precision,
    "X_5" double precision,
    "X_6" double precision,
    "X_7" double precision,
    "X_8" double precision,
    "X_9" double precision,
    "X_10" double precision,
    "X_11" double precision,
    "X_12" double precision,
    "X_13" double precision,
    "X_14" double precision,
    "X_15" double precision,
    "X_16" double precision,
    "X_17" double precision,
    "X_18" double precision,
    "X_19" double precision,
    "X_20" double precision,
    "X_21" double precision,
    "X_22" double precision,
    "X_23" double precision,
    "X_24" double precision,
    "X_25" double precision,
    "X_26" double precision,
    "X_27" double precision,
    "X_28" double precision,
    "X_29" double precision,
    "X_30" double precision,
    "X_31" double precision,
    "X_32" double precision,
    "X_33" double precision,
    "X_34" double precision,
    "X_35" double precision,
    "X_36" double precision,
    "X_37" double precision,
    "X_38" double precision,
    "X_39" double precision,
    "X_40" double precision,
    "X_41" double precision,
    "X_42" double precision,
    "X_43" double precision,
    "X_44" double precision,
    "X_45" double precision,
    "X_46" double precision,
    "X_47" double precision,
    "X_48" double precision,
    "X_49" double precision,
    "X_50" double precision,
    "X_51" double precision,
    "X_52" double precision,
    "X_53" double precision,
    "X_54" double precision,
    "X_55" double precision,
    "X_56" double precision,
    "X_57" double precision,
    "X_58" double precision,
    "X_59" double precision,
    "X_60" double precision,
    "X_61" double precision,
    "X_62" double precision,
    "X_63" double precision,
    "X_64" double precision,
    "X_65" double precision,
    "X_66" double precision,
    "X_67" double precision,
    "Y_0" double precision,
    "Y_1" double precision,
    "Y_2" double precision,
    "Y_3" double precision,
    "Y_4" double precision,
    "Y_5" double precision,
    "Y_6" double precision,
    "Y_7" double precision,
    "Y_8" double precision,
    "Y_9" double precision,
    "Y_10" double precision,
    "Y_11" double precision,
    "Y_12" double precision,
    "Y_13" double precision,
    "Y_14" double precision,
    "Y_15" double precision,
    "Y_16" double precision,
    "Y_17" double precision,
    "Y_18" double precision,
    "Y_19" double precision,
    "Y_20" double precision,
    "Y_21" double precision,
    "Y_22" double precision,
    "Y_23" double precision,
    "Y_24" double precision,
    "Y_25" double precision,
    "Y_26" double precision,
    "Y_27" double precision,
    "Y_28" double precision,
    "Y_29" double precision,
    "Y_30" double precision,
    "Y_31" double precision,
    "Y_32" double precision,
    "Y_33" double precision,
    "Y_34" double precision,
    "Y_35" double precision,
    "Y_36" double precision,
    "Y_37" double precision,
    "Y_38" double precision,
    "Y_39" double precision,
    "Y_40" double precision,
    "Y_41" double precision,
    "Y_42" double precision,
    "Y_43" double precision,
    "Y_44" double precision,
    "Y_45" double precision,
    "Y_46" double precision,
    "Y_47" double precision,
    "Y_48" double precision,
    "Y_49" double precision,
    "Y_50" double precision,
    "Y_51" double precision,
    "Y_52" double precision,
    "Y_53" double precision,
    "Y_54" double precision,
    "Y_55" double precision,
    "Y_56" double precision,
    "Y_57" double precision,
    "Y_58" double precision,
    "Y_59" double precision,
    "Y_60" double precision,
    "Y_61" double precision,
    "Y_62" double precision,
    "Y_63" double precision,
    "Y_64" double precision,
    "Y_65" double precision,
    "Y_66" double precision,
    "Y_67" double precision,
    "Z_0" double precision,
    "Z_1" double precision,
    "Z_2" double precision,
    "Z_3" double precision,
    "Z_4" double precision,
    "Z_5" double precision,
    "Z_6" double precision,
    "Z_7" double precision,
    "Z_8" double precision,
    "Z_9" double precision,
    "Z_10" double precision,
    "Z_11" double precision,
    "Z_12" double precision,
    "Z_13" double precision,
    "Z_14" double precision,
    "Z_15" double precision,
    "Z_16" double precision,
    "Z_17" double precision,
    "Z_18" double precision,
    "Z_19" double precision,
    "Z_20" double precision,
    "Z_21" double precision,
    "Z_22" double precision,
    "Z_23" double precision,
    "Z_24" double precision,
    "Z_25" double precision,
    "Z_26" double precision,
    "Z_27" double precision,
    "Z_28" double precision,
    "Z_29" double precision,
    "Z_30" double precision,
    "Z_31" double precision,
    "Z_32" double precision,
    "Z_33" double precision,
    "Z_34" double precision,
    "Z_35" double precision,
    "Z_36" double precision,
    "Z_37" double precision,
    "Z_38" double precision,
    "Z_39" double precision,
    "Z_40" double precision,
    "Z_41" double precision,
    "Z_42" double precision,
    "Z_43" double precision,
    "Z_44" double precision,
    "Z_45" double precision,
    "Z_46" double precision,
    "Z_47" double precision,
    "Z_48" double precision,
    "Z_49" double precision,
    "Z_50" double precision,
    "Z_51" double precision,
    "Z_52" double precision,
    "Z_53" double precision,
    "Z_54" double precision,
    "Z_55" double precision,
    "Z_56" double precision,
    "Z_57" double precision,
    "Z_58" double precision,
    "Z_59" double precision,
    "Z_60" double precision,
    "Z_61" double precision,
    "Z_62" double precision,
    "Z_63" double precision,
    "Z_64" double precision,
    "Z_65" double precision,
    "Z_66" double precision,
    "Z_67" double precision,
    p_scale double precision,
    p_rx double precision,
    p_ry double precision,
    p_rz double precision,
    p_tx double precision,
    p_ty double precision,
    p_0 double precision,
    p_1 double precision,
    p_2 double precision,
    p_3 double precision,
    p_4 double precision,
    p_5 double precision,
    p_6 double precision,
    p_7 double precision,
    p_8 double precision,
    p_9 double precision,
    p_10 double precision,
    p_11 double precision,
    p_12 double precision,
    p_13 double precision,
    p_14 double precision,
    p_15 double precision,
    p_16 double precision,
    p_17 double precision,
    p_18 double precision,
    p_19 double precision,
    p_20 double precision,
    p_21 double precision,
    p_22 double precision,
    p_23 double precision,
    p_24 double precision,
    p_25 double precision,
    p_26 double precision,
    p_27 double precision,
    p_28 double precision,
    p_29 double precision,
    p_30 double precision,
    p_31 double precision,
    p_32 double precision,
    p_33 double precision,
    "AU01_r" double precision,
    "AU02_r" double precision,
    "AU04_r" double precision,
    "AU05_r" double precision,
    "AU06_r" double precision,
    "AU07_r" double precision,
    "AU09_r" double precision,
    "AU10_r" double precision,
    "AU12_r" double precision,
    "AU14_r" double precision,
    "AU15_r" double precision,
    "AU17_r" double precision,
    "AU20_r" double precision,
    "AU23_r" double precision,
    "AU25_r" double precision,
    "AU26_r" double precision,
    "AU45_r" double precision,
    "AU01_c" double precision,
    "AU02_c" double precision,
    "AU04_c" double precision,
    "AU05_c" double precision,
    "AU06_c" double precision,
    "AU07_c" double precision,
    "AU09_c" double precision,
    "AU10_c" double precision,
    "AU12_c" double precision,
    "AU14_c" double precision,
    "AU15_c" double precision,
    "AU17_c" double precision,
    "AU20_c" double precision,
    "AU23_c" double precision,
    "AU25_c" double precision,
    "AU26_c" double precision,
    "AU28_c" double precision,
    "AU45_c" double precision,
    pitch double precision,
    intensity double precision,
    topic bigint,
    silence boolean,
    video bigint
);


ALTER TABLE public.data OWNER TO postgres;

--
-- Name: topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.topics (
    video integer NOT NULL,
    index integer NOT NULL,
    start_time double precision,
    end_time double precision,
    description character varying
);


ALTER TABLE public.topics OWNER TO postgres;

--
-- Name: videos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.videos (
    id integer NOT NULL,
    hash character varying,
    study character varying,
    participant integer,
    session integer,
    experiment character varying,
    memory_type character varying,
    memory_index integer
);


ALTER TABLE public.videos OWNER TO postgres;

--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.videos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.videos_id_seq OWNER TO postgres;

--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.videos_id_seq OWNED BY public.videos.id;


--
-- Name: videos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.videos ALTER COLUMN id SET DEFAULT nextval('public.videos_id_seq'::regclass);


--
-- Name: videos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.videos_id_seq', 5, true);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (video, index);


--
-- Name: videos videos_hash_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_hash_key UNIQUE (hash);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

