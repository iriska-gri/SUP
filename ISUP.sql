--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

-- Started on 2023-09-11 08:10:32

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

DROP DATABASE dbsup;
--
-- TOC entry 3669 (class 1262 OID 16394)
-- Name: dbsup; Type: DATABASE; Schema: -; Owner: pgsup
--

CREATE DATABASE dbsup WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Russian_Russia.1251';


ALTER DATABASE dbsup OWNER TO pgsup;

\connect dbsup

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16396)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO pgsup;

--
-- TOC entry 239 (class 1259 OID 26136)
-- Name: assignments; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.assignments (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    status integer NOT NULL,
    timeneeded integer,
    lastchanged timestamp without time zone,
    dateend timestamp without time zone,
    parent integer NOT NULL,
    responsible integer,
    datestart timestamp without time zone,
    author integer,
    description text,
    getstarted timestamp without time zone,
    difficult integer,
    longname character varying(500),
    info json
);


ALTER TABLE public.assignments OWNER TO pgsup;

--
-- TOC entry 238 (class 1259 OID 26135)
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assignments_id_seq OWNER TO pgsup;

--
-- TOC entry 3670 (class 0 OID 0)
-- Dependencies: 238
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.assignments_id_seq OWNED BY public.assignments.id;


--
-- TOC entry 211 (class 1259 OID 25595)
-- Name: assignmentstatuses; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.assignmentstatuses (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.assignmentstatuses OWNER TO pgsup;

--
-- TOC entry 210 (class 1259 OID 25594)
-- Name: assignmentstatuses_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.assignmentstatuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assignmentstatuses_id_seq OWNER TO pgsup;

--
-- TOC entry 3671 (class 0 OID 0)
-- Dependencies: 210
-- Name: assignmentstatuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.assignmentstatuses_id_seq OWNED BY public.assignmentstatuses.id;


--
-- TOC entry 259 (class 1259 OID 36329)
-- Name: chatmessages; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.chatmessages (
    id integer NOT NULL,
    chat integer,
    sender integer,
    text text NOT NULL,
    messagetime timestamp without time zone
);


ALTER TABLE public.chatmessages OWNER TO pgsup;

--
-- TOC entry 258 (class 1259 OID 36328)
-- Name: chatmessages_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.chatmessages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chatmessages_id_seq OWNER TO pgsup;

--
-- TOC entry 3672 (class 0 OID 0)
-- Dependencies: 258
-- Name: chatmessages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.chatmessages_id_seq OWNED BY public.chatmessages.id;


--
-- TOC entry 255 (class 1259 OID 36286)
-- Name: chats; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.chats (
    id integer NOT NULL,
    name text,
    level integer,
    parent integer,
    admin integer
);


ALTER TABLE public.chats OWNER TO pgsup;

--
-- TOC entry 254 (class 1259 OID 36285)
-- Name: chats_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.chats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chats_id_seq OWNER TO pgsup;

--
-- TOC entry 3673 (class 0 OID 0)
-- Dependencies: 254
-- Name: chats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.chats_id_seq OWNED BY public.chats.id;


--
-- TOC entry 257 (class 1259 OID 36312)
-- Name: chatusers; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.chatusers (
    id integer NOT NULL,
    "user" integer,
    chat integer
);


ALTER TABLE public.chatusers OWNER TO pgsup;

--
-- TOC entry 256 (class 1259 OID 36311)
-- Name: chatusers_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.chatusers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chatusers_id_seq OWNER TO pgsup;

--
-- TOC entry 3674 (class 0 OID 0)
-- Dependencies: 256
-- Name: chatusers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.chatusers_id_seq OWNED BY public.chatusers.id;


--
-- TOC entry 243 (class 1259 OID 26801)
-- Name: departments; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    name character varying(100),
    postal_code character varying(100),
    city character varying(200),
    region character varying(200),
    street character varying(200)
);


ALTER TABLE public.departments OWNER TO pgsup;

--
-- TOC entry 242 (class 1259 OID 26800)
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departments_id_seq OWNER TO pgsup;

--
-- TOC entry 3675 (class 0 OID 0)
-- Dependencies: 242
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- TOC entry 213 (class 1259 OID 25604)
-- Name: doctypes; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.doctypes (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.doctypes OWNER TO pgsup;

--
-- TOC entry 212 (class 1259 OID 25603)
-- Name: doctypes_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.doctypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctypes_id_seq OWNER TO pgsup;

--
-- TOC entry 3676 (class 0 OID 0)
-- Dependencies: 212
-- Name: doctypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.doctypes_id_seq OWNED BY public.doctypes.id;


--
-- TOC entry 233 (class 1259 OID 25924)
-- Name: documentations; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.documentations (
    id integer NOT NULL,
    project integer,
    doctype integer,
    created timestamp without time zone NOT NULL,
    vrersion json NOT NULL,
    comment text,
    approved integer,
    approvedtime timestamp without time zone,
    approver integer,
    docnumber character varying(100),
    path character varying(100)
);


ALTER TABLE public.documentations OWNER TO pgsup;

--
-- TOC entry 232 (class 1259 OID 25923)
-- Name: documentations_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.documentations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.documentations_id_seq OWNER TO pgsup;

--
-- TOC entry 3677 (class 0 OID 0)
-- Dependencies: 232
-- Name: documentations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.documentations_id_seq OWNED BY public.documentations.id;


--
-- TOC entry 249 (class 1259 OID 36045)
-- Name: docusers; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.docusers (
    id integer NOT NULL,
    comment text,
    accepted integer,
    acceptedtime timestamp without time zone,
    "user" integer,
    doc integer
);


ALTER TABLE public.docusers OWNER TO pgsup;

--
-- TOC entry 248 (class 1259 OID 36044)
-- Name: docusers_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.docusers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.docusers_id_seq OWNER TO pgsup;

--
-- TOC entry 3678 (class 0 OID 0)
-- Dependencies: 248
-- Name: docusers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.docusers_id_seq OWNED BY public.docusers.id;


--
-- TOC entry 215 (class 1259 OID 25640)
-- Name: historyactions; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.historyactions (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.historyactions OWNER TO pgsup;

--
-- TOC entry 214 (class 1259 OID 25639)
-- Name: historyactions_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.historyactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.historyactions_id_seq OWNER TO pgsup;

--
-- TOC entry 3679 (class 0 OID 0)
-- Dependencies: 214
-- Name: historyactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.historyactions_id_seq OWNED BY public.historyactions.id;


--
-- TOC entry 245 (class 1259 OID 27651)
-- Name: organizations; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.organizations (
    id integer NOT NULL,
    name character varying(500) NOT NULL
);


ALTER TABLE public.organizations OWNER TO pgsup;

--
-- TOC entry 244 (class 1259 OID 27650)
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.organizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organizations_id_seq OWNER TO pgsup;

--
-- TOC entry 3680 (class 0 OID 0)
-- Dependencies: 244
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- TOC entry 217 (class 1259 OID 25667)
-- Name: otdels; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.otdels (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    shortname character varying(7)
);


ALTER TABLE public.otdels OWNER TO pgsup;

--
-- TOC entry 216 (class 1259 OID 25666)
-- Name: otdels_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.otdels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otdels_id_seq OWNER TO pgsup;

--
-- TOC entry 3681 (class 0 OID 0)
-- Dependencies: 216
-- Name: otdels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.otdels_id_seq OWNED BY public.otdels.id;


--
-- TOC entry 219 (class 1259 OID 25676)
-- Name: positions; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.positions (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.positions OWNER TO pgsup;

--
-- TOC entry 218 (class 1259 OID 25675)
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.positions_id_seq OWNER TO pgsup;

--
-- TOC entry 3682 (class 0 OID 0)
-- Dependencies: 218
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.positions_id_seq OWNED BY public.positions.id;


--
-- TOC entry 265 (class 1259 OID 36732)
-- Name: projectcheckpoints; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.projectcheckpoints (
    id integer NOT NULL,
    project integer,
    checkpoint date
);


ALTER TABLE public.projectcheckpoints OWNER TO pgsup;

--
-- TOC entry 264 (class 1259 OID 36731)
-- Name: projectcheckpoints_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.projectcheckpoints_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projectcheckpoints_id_seq OWNER TO pgsup;

--
-- TOC entry 3683 (class 0 OID 0)
-- Dependencies: 264
-- Name: projectcheckpoints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.projectcheckpoints_id_seq OWNED BY public.projectcheckpoints.id;


--
-- TOC entry 251 (class 1259 OID 36074)
-- Name: projectfiles; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.projectfiles (
    id integer NOT NULL,
    project integer,
    task integer,
    work integer,
    assignment integer,
    sender integer,
    datetime timestamp without time zone NOT NULL,
    filepath text NOT NULL,
    visible character varying(5),
    counter integer
);


ALTER TABLE public.projectfiles OWNER TO pgsup;

--
-- TOC entry 250 (class 1259 OID 36073)
-- Name: projectfiles_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.projectfiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projectfiles_id_seq OWNER TO pgsup;

--
-- TOC entry 3684 (class 0 OID 0)
-- Dependencies: 250
-- Name: projectfiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.projectfiles_id_seq OWNED BY public.projectfiles.id;


--
-- TOC entry 253 (class 1259 OID 36253)
-- Name: projecthistorys; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.projecthistorys (
    id integer NOT NULL,
    author integer,
    project integer NOT NULL,
    action integer,
    createdate timestamp without time zone,
    info json,
    task integer,
    work integer,
    comment text,
    assignment integer,
    level integer
);


ALTER TABLE public.projecthistorys OWNER TO pgsup;

--
-- TOC entry 252 (class 1259 OID 36252)
-- Name: projecthistorys_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.projecthistorys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projecthistorys_id_seq OWNER TO pgsup;

--
-- TOC entry 3685 (class 0 OID 0)
-- Dependencies: 252
-- Name: projecthistorys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.projecthistorys_id_seq OWNED BY public.projecthistorys.id;


--
-- TOC entry 261 (class 1259 OID 36445)
-- Name: projectroles; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.projectroles (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.projectroles OWNER TO pgsup;

--
-- TOC entry 260 (class 1259 OID 36444)
-- Name: projectroles_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.projectroles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projectroles_id_seq OWNER TO pgsup;

--
-- TOC entry 3686 (class 0 OID 0)
-- Dependencies: 260
-- Name: projectroles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.projectroles_id_seq OWNED BY public.projectroles.id;


--
-- TOC entry 231 (class 1259 OID 25837)
-- Name: projects; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name character varying(255),
    status integer,
    author integer NOT NULL,
    datestart date,
    dateend date,
    lastchanged timestamp without time zone,
    ptype integer,
    difficult integer,
    longname character varying(500),
    info json
);


ALTER TABLE public.projects OWNER TO pgsup;

--
-- TOC entry 230 (class 1259 OID 25836)
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_id_seq OWNER TO pgsup;

--
-- TOC entry 3687 (class 0 OID 0)
-- Dependencies: 230
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- TOC entry 221 (class 1259 OID 25685)
-- Name: projectstatuses; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.projectstatuses (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.projectstatuses OWNER TO pgsup;

--
-- TOC entry 220 (class 1259 OID 25684)
-- Name: projectstatuses_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.projectstatuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projectstatuses_id_seq OWNER TO pgsup;

--
-- TOC entry 3688 (class 0 OID 0)
-- Dependencies: 220
-- Name: projectstatuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.projectstatuses_id_seq OWNED BY public.projectstatuses.id;


--
-- TOC entry 241 (class 1259 OID 26649)
-- Name: projecttypes; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.projecttypes (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.projecttypes OWNER TO pgsup;

--
-- TOC entry 240 (class 1259 OID 26648)
-- Name: projecttypes_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.projecttypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projecttypes_id_seq OWNER TO pgsup;

--
-- TOC entry 3689 (class 0 OID 0)
-- Dependencies: 240
-- Name: projecttypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.projecttypes_id_seq OWNED BY public.projecttypes.id;


--
-- TOC entry 235 (class 1259 OID 26073)
-- Name: projectusers; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.projectusers (
    id integer NOT NULL,
    involved boolean,
    "user" integer,
    project integer,
    role integer,
    percent integer
);


ALTER TABLE public.projectusers OWNER TO pgsup;

--
-- TOC entry 234 (class 1259 OID 26072)
-- Name: projectusers_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.projectusers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projectusers_id_seq OWNER TO pgsup;

--
-- TOC entry 3690 (class 0 OID 0)
-- Dependencies: 234
-- Name: projectusers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.projectusers_id_seq OWNED BY public.projectusers.id;


--
-- TOC entry 223 (class 1259 OID 25694)
-- Name: ranks; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.ranks (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.ranks OWNER TO pgsup;

--
-- TOC entry 222 (class 1259 OID 25693)
-- Name: ranks_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.ranks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ranks_id_seq OWNER TO pgsup;

--
-- TOC entry 3691 (class 0 OID 0)
-- Dependencies: 222
-- Name: ranks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.ranks_id_seq OWNED BY public.ranks.id;


--
-- TOC entry 237 (class 1259 OID 26090)
-- Name: tasks; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    name character varying(500),
    status integer,
    datestart date,
    dateend date,
    responsible integer,
    lastchanged timestamp without time zone,
    parent integer,
    description text,
    difficult integer,
    longname character varying(500)
);


ALTER TABLE public.tasks OWNER TO pgsup;

--
-- TOC entry 236 (class 1259 OID 26089)
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasks_id_seq OWNER TO pgsup;

--
-- TOC entry 3692 (class 0 OID 0)
-- Dependencies: 236
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- TOC entry 225 (class 1259 OID 25703)
-- Name: taskstages; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.taskstages (
    id integer NOT NULL,
    name character varying(500) NOT NULL
);


ALTER TABLE public.taskstages OWNER TO pgsup;

--
-- TOC entry 224 (class 1259 OID 25702)
-- Name: taskstages_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.taskstages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taskstages_id_seq OWNER TO pgsup;

--
-- TOC entry 3693 (class 0 OID 0)
-- Dependencies: 224
-- Name: taskstages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.taskstages_id_seq OWNED BY public.taskstages.id;


--
-- TOC entry 227 (class 1259 OID 25712)
-- Name: taskstatuses; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.taskstatuses (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.taskstatuses OWNER TO pgsup;

--
-- TOC entry 226 (class 1259 OID 25711)
-- Name: taskstatuses_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.taskstatuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taskstatuses_id_seq OWNER TO pgsup;

--
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 226
-- Name: taskstatuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.taskstatuses_id_seq OWNED BY public.taskstatuses.id;


--
-- TOC entry 263 (class 1259 OID 36621)
-- Name: userratings; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.userratings (
    id integer NOT NULL,
    "user" integer NOT NULL,
    rating integer,
    level integer,
    project integer,
    task integer,
    work integer,
    assignment integer,
    author integer NOT NULL,
    createdate timestamp without time zone
);


ALTER TABLE public.userratings OWNER TO pgsup;

--
-- TOC entry 262 (class 1259 OID 36620)
-- Name: userratings_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.userratings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userratings_id_seq OWNER TO pgsup;

--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 262
-- Name: userratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.userratings_id_seq OWNED BY public.userratings.id;


--
-- TOC entry 229 (class 1259 OID 25749)
-- Name: users; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.users (
    id integer NOT NULL,
    phone character varying(50),
    email character varying(150),
    otdel integer,
    "position" integer,
    rank integer,
    superuser boolean,
    department integer,
    active boolean,
    "physicalDeliveryOfficeName" character varying(100),
    "givenName" character varying(250) NOT NULL,
    sn character varying(100) NOT NULL,
    "telephoneNumber" character varying(50),
    organization integer,
    username character varying(250) NOT NULL,
    avatar text
);


ALTER TABLE public.users OWNER TO pgsup;

--
-- TOC entry 228 (class 1259 OID 25748)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO pgsup;

--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 228
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 247 (class 1259 OID 35952)
-- Name: works; Type: TABLE; Schema: public; Owner: pgsup
--

CREATE TABLE public.works (
    id integer NOT NULL,
    parent integer,
    name character varying(500) NOT NULL,
    status integer,
    description text,
    datestart date,
    dateend date,
    responsible integer,
    lastchanged timestamp without time zone,
    difficult integer,
    longname character varying(500)
);


ALTER TABLE public.works OWNER TO pgsup;

--
-- TOC entry 246 (class 1259 OID 35951)
-- Name: works_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsup
--

CREATE SEQUENCE public.works_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.works_id_seq OWNER TO pgsup;

--
-- TOC entry 3697 (class 0 OID 0)
-- Dependencies: 246
-- Name: works_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsup
--

ALTER SEQUENCE public.works_id_seq OWNED BY public.works.id;


--
-- TOC entry 3317 (class 2604 OID 26449)
-- Name: assignments id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.assignments ALTER COLUMN id SET DEFAULT nextval('public.assignments_id_seq'::regclass);


--
-- TOC entry 3303 (class 2604 OID 26450)
-- Name: assignmentstatuses id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.assignmentstatuses ALTER COLUMN id SET DEFAULT nextval('public.assignmentstatuses_id_seq'::regclass);


--
-- TOC entry 3327 (class 2604 OID 36332)
-- Name: chatmessages id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chatmessages ALTER COLUMN id SET DEFAULT nextval('public.chatmessages_id_seq'::regclass);


--
-- TOC entry 3325 (class 2604 OID 36289)
-- Name: chats id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chats ALTER COLUMN id SET DEFAULT nextval('public.chats_id_seq'::regclass);


--
-- TOC entry 3326 (class 2604 OID 36315)
-- Name: chatusers id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chatusers ALTER COLUMN id SET DEFAULT nextval('public.chatusers_id_seq'::regclass);


--
-- TOC entry 3319 (class 2604 OID 26804)
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- TOC entry 3304 (class 2604 OID 26456)
-- Name: doctypes id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.doctypes ALTER COLUMN id SET DEFAULT nextval('public.doctypes_id_seq'::regclass);


--
-- TOC entry 3314 (class 2604 OID 26457)
-- Name: documentations id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.documentations ALTER COLUMN id SET DEFAULT nextval('public.documentations_id_seq'::regclass);


--
-- TOC entry 3322 (class 2604 OID 36048)
-- Name: docusers id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.docusers ALTER COLUMN id SET DEFAULT nextval('public.docusers_id_seq'::regclass);


--
-- TOC entry 3305 (class 2604 OID 26468)
-- Name: historyactions id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.historyactions ALTER COLUMN id SET DEFAULT nextval('public.historyactions_id_seq'::regclass);


--
-- TOC entry 3320 (class 2604 OID 27654)
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- TOC entry 3306 (class 2604 OID 26476)
-- Name: otdels id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.otdels ALTER COLUMN id SET DEFAULT nextval('public.otdels_id_seq'::regclass);


--
-- TOC entry 3307 (class 2604 OID 26477)
-- Name: positions id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.positions ALTER COLUMN id SET DEFAULT nextval('public.positions_id_seq'::regclass);


--
-- TOC entry 3330 (class 2604 OID 36735)
-- Name: projectcheckpoints id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectcheckpoints ALTER COLUMN id SET DEFAULT nextval('public.projectcheckpoints_id_seq'::regclass);


--
-- TOC entry 3323 (class 2604 OID 36077)
-- Name: projectfiles id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectfiles ALTER COLUMN id SET DEFAULT nextval('public.projectfiles_id_seq'::regclass);


--
-- TOC entry 3324 (class 2604 OID 36256)
-- Name: projecthistorys id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projecthistorys ALTER COLUMN id SET DEFAULT nextval('public.projecthistorys_id_seq'::regclass);


--
-- TOC entry 3328 (class 2604 OID 36448)
-- Name: projectroles id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectroles ALTER COLUMN id SET DEFAULT nextval('public.projectroles_id_seq'::regclass);


--
-- TOC entry 3313 (class 2604 OID 26479)
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- TOC entry 3308 (class 2604 OID 26480)
-- Name: projectstatuses id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectstatuses ALTER COLUMN id SET DEFAULT nextval('public.projectstatuses_id_seq'::regclass);


--
-- TOC entry 3318 (class 2604 OID 26652)
-- Name: projecttypes id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projecttypes ALTER COLUMN id SET DEFAULT nextval('public.projecttypes_id_seq'::regclass);


--
-- TOC entry 3315 (class 2604 OID 26481)
-- Name: projectusers id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectusers ALTER COLUMN id SET DEFAULT nextval('public.projectusers_id_seq'::regclass);


--
-- TOC entry 3309 (class 2604 OID 26482)
-- Name: ranks id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.ranks ALTER COLUMN id SET DEFAULT nextval('public.ranks_id_seq'::regclass);


--
-- TOC entry 3316 (class 2604 OID 26484)
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- TOC entry 3310 (class 2604 OID 26485)
-- Name: taskstages id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.taskstages ALTER COLUMN id SET DEFAULT nextval('public.taskstages_id_seq'::regclass);


--
-- TOC entry 3311 (class 2604 OID 26486)
-- Name: taskstatuses id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.taskstatuses ALTER COLUMN id SET DEFAULT nextval('public.taskstatuses_id_seq'::regclass);


--
-- TOC entry 3329 (class 2604 OID 36624)
-- Name: userratings id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.userratings ALTER COLUMN id SET DEFAULT nextval('public.userratings_id_seq'::regclass);


--
-- TOC entry 3312 (class 2604 OID 26489)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3321 (class 2604 OID 35955)
-- Name: works id; Type: DEFAULT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.works ALTER COLUMN id SET DEFAULT nextval('public.works_id_seq'::regclass);


--
-- TOC entry 3607 (class 0 OID 16396)
-- Dependencies: 209
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.alembic_version (version_num) VALUES ('be36fa6bb3ca');


--
-- TOC entry 3637 (class 0 OID 26136)
-- Dependencies: 239
-- Data for Name: assignments; Type: TABLE DATA; Schema: public; Owner: pgsup
--



--
-- TOC entry 3609 (class 0 OID 25595)
-- Dependencies: 211
-- Data for Name: assignmentstatuses; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.assignmentstatuses (id, name) VALUES (5, 'Завершено');
INSERT INTO public.assignmentstatuses (id, name) VALUES (1, 'Открыто');
INSERT INTO public.assignmentstatuses (id, name) VALUES (3, 'Приостановлено');
INSERT INTO public.assignmentstatuses (id, name) VALUES (4, 'На проверке');
INSERT INTO public.assignmentstatuses (id, name) VALUES (2, 'Исполнение');


--
-- TOC entry 3657 (class 0 OID 36329)
-- Dependencies: 259
-- Data for Name: chatmessages; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (240, 74, 421, 'ыва', '2023-02-28 15:28:34.472496');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (241, 74, 421, 'seffeef', '2023-02-28 16:27:38.08892');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (242, 74, 421, 'rtre', '2023-02-28 16:27:46.276618');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (243, 77, 421, 'цккцкцк', '2023-02-28 16:50:50.930258');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (244, 76, 437, 'ит им', '2023-02-28 16:59:38.513258');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (245, 72, 421, 'цуе4уце', '2023-02-28 17:00:32.303044');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (246, 79, 421, 'sef', '2023-03-01 09:41:43.547351');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (247, 76, 421, 'цв', '2023-03-02 08:19:17.539797');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (248, 76, 421, 'цв', '2023-03-02 08:19:26.462165');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (249, 76, 421, 'ттттт', '2023-03-02 08:19:55.282485');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (250, 76, 421, 'йцйцйцйцй', '2023-03-02 08:20:01.158269');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (251, 76, 421, 'цуа', '2023-03-02 08:22:17.436365');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (252, 72, 421, 's', '2023-03-02 08:36:56.841347');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (253, 76, 421, 'sfesf', '2023-03-02 08:37:03.546498');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (254, 76, 437, 'tfh', '2023-03-02 08:45:47.91397');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (255, 76, 437, 'th', '2023-03-02 08:45:56.273939');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (256, 76, 437, 'dg', '2023-03-02 08:46:07.872683');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (257, 76, 421, 'фцв', '2023-03-02 08:50:33.544796');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (258, 76, 421, 'фф', '2023-03-02 08:50:36.428602');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (259, 72, 421, 'e', '2023-03-02 09:00:04.090717');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (260, 76, 421, 'qwe', '2023-03-02 09:01:26.643525');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (261, 76, 421, '2222', '2023-03-02 09:12:12.523113');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (262, 76, 421, 'adw', '2023-03-02 09:12:56.65669');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (263, 76, 421, 'adw', '2023-03-02 09:14:22.584508');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (264, 76, 421, 'erg', '2023-03-02 09:15:04.25837');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (265, 76, 421, 'adw', '2023-03-02 09:15:40.816291');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (266, 76, 421, 'et4', '2023-03-02 09:16:23.032271');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (267, 76, 421, '123', '2023-03-02 09:16:35.594924');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (268, 76, 421, 'yj', '2023-03-02 09:17:17.782233');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (269, 76, 421, 'yjt', '2023-03-02 09:17:29.523356');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (270, 76, 437, 'tt', '2023-03-02 09:18:14.511456');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (271, 76, 437, 'ty454', '2023-03-02 09:18:26.258098');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (272, 76, 421, 'wef', '2023-03-02 09:19:58.355145');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (273, 76, 421, 'sef', '2023-03-02 09:22:49.464664');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (274, 76, 421, 'qwe', '2023-03-02 09:23:24.935859');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (275, 76, 421, 'aw', '2023-03-02 09:23:51.359556');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (276, 76, 421, '211', '2023-03-02 09:24:12.604104');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (277, 76, 421, '222222222', '2023-03-02 09:24:20.420159');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (278, 76, 421, 't', '2023-03-02 09:29:32.481813');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (279, 76, 421, 'sf', '2023-03-02 09:33:10.341473');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (280, 76, 421, 'www', '2023-03-02 09:33:26.714775');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (281, 76, 421, '4564323456', '2023-03-02 09:35:26.42777');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (282, 76, 421, 'qw', '2023-03-02 09:36:34.090234');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (283, 76, 421, 'qw123', '2023-03-02 09:37:24.364048');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (284, 76, 421, '2', '2023-03-02 09:42:35.026471');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (285, 76, 421, '3345', '2023-03-02 09:42:58.014597');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (286, 76, 421, '3453', '2023-03-02 09:43:08.138276');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (287, 76, 437, 'fff', '2023-03-02 09:46:23.720612');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (288, 76, 437, 'hhhhh', '2023-03-02 09:46:44.209996');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (289, 76, 421, 'wqd', '2023-03-02 10:12:10.890003');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (290, 76, 421, 's', '2023-03-02 10:46:59.161414');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (291, 76, 421, 'se', '2023-03-02 10:47:08.589304');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (292, 72, 421, '21', '2023-03-02 11:06:18.007601');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (293, 72, 421, '33', '2023-03-02 11:06:23.279568');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (294, 72, 421, '111', '2023-03-02 11:06:28.106236');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (295, 72, 421, '2', '2023-03-02 11:06:49.62266');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (296, 76, 421, 'уцвау', '2023-03-02 13:46:53.232566');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (297, 76, 421, 'ii', '2023-03-02 15:52:43.909987');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (298, 76, 421, 'wae', '2023-03-02 15:53:28.838171');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (299, 76, 421, '&&', '2023-03-03 15:22:40.569839');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (300, 72, 421, 'awd', '2023-03-06 14:05:29.200647');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (301, 76, 421, 'awd', '2023-03-06 14:06:08.578176');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (302, 76, 421, 'awda', '2023-03-06 14:06:12.896631');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (303, 76, 421, 'ыуа', '2023-03-06 14:07:54.165112');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (304, 76, 421, 'ыуа', '2023-03-06 14:08:13.343184');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (305, 76, 421, 'фц', '2023-03-06 14:08:45.647686');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (306, 76, 421, 'ыв', '2023-03-07 09:20:03.468756');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (307, 76, 421, 'ва', '2023-03-10 09:51:39.121933');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (308, 76, 421, 'лп', '2023-03-10 14:31:29.977057');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (309, 80, 421, 'awd', '2023-03-10 14:50:22.536412');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (310, 74, 421, 'фцв', '2023-03-10 15:45:51.926306');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (311, 76, 421, 'ыв', '2023-03-13 09:08:56.105563');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (312, 76, 421, 'ыв', '2023-03-13 09:09:11.664701');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (313, 76, 421, 'фывфы', '2023-03-13 09:11:18.677736');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (314, 76, 421, 'фыс', '2023-03-13 09:24:07.937337');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (315, 76, 437, 'ыв', '2023-03-13 09:31:52.946313');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (316, 76, 421, 'фыс', '2023-03-13 09:40:52.917844');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (317, 76, 421, 'fu', '2023-03-13 10:26:27.540829');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (319, 76, 421, 'ф', '2023-03-13 10:42:22.610429');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (318, 76, 421, 'ф', '2023-03-13 10:42:22.556574');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (320, 76, 437, 'ыв', '2023-03-13 10:43:05.187595');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (321, 76, 421, 'sdfs', '2023-03-13 10:48:09.821346');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (322, 76, 421, 'saf', '2023-03-13 10:48:20.372877');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (323, 76, 421, 'wdq', '2023-03-13 10:49:40.596852');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (324, 76, 421, 'qwd', '2023-03-13 10:50:14.88359');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (325, 76, 421, 'wqd', '2023-03-13 10:50:24.392472');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (326, 76, 421, 'йцв', '2023-03-13 10:52:52.937095');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (327, 76, 421, 'awd', '2023-03-13 10:53:27.655545');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (328, 76, 421, 'qw', '2023-03-13 10:53:49.166648');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (329, 76, 421, 'qwd', '2023-03-13 10:56:18.276415');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (330, 76, 421, 'sd', '2023-03-13 10:58:09.943858');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (331, 76, 421, 'awd', '2023-03-13 10:59:30.850472');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (332, 72, 421, 'sef', '2023-03-13 11:25:46.273396');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (333, 72, 421, 'sdf', '2023-03-13 11:26:56.92086');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (334, 72, 421, 'sfe', '2023-03-13 11:28:44.263877');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (335, 72, 421, 'sdf', '2023-03-13 11:29:37.40303');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (336, 72, 421, 'awd', '2023-03-13 11:38:19.395069');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (337, 72, 421, 'aaaa', '2023-03-13 11:38:23.458235');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (338, 76, 437, 'awd', '2023-03-13 11:38:41.766297');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (339, 76, 437, 'aaa', '2023-03-13 11:38:51.406081');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (340, 76, 421, 'awd', '2023-03-13 11:38:53.759993');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (341, 72, 421, 'asd', '2023-03-13 11:59:49.055941');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (342, 72, 421, 'йцвйцв', '2023-03-13 13:53:53.746715');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (343, 72, 421, 'фцв11', '2023-03-13 13:54:54.980285');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (344, 72, 437, 'фы', '2023-03-13 13:55:32.642596');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (345, 72, 421, 'фцв', '2023-03-13 13:55:38.364821');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (346, 72, 421, 'йц', '2023-03-13 13:58:54.731641');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (347, 76, 421, 'jvbjbvjhhj', '2023-03-13 15:10:40.708129');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (348, 72, 421, 'sef', '2023-03-13 15:12:04.990806');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (349, 72, 421, 'asdas', '2023-03-14 09:06:47.607364');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (350, 74, 421, 'sef', '2023-03-14 09:11:30.43635');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (351, 72, 421, 'awd', '2023-03-14 09:12:06.486333');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (352, 72, 421, '2', '2023-03-14 09:12:19.817314');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (353, 83, 421, 'ыуа', '2023-03-14 09:50:49.997246');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (354, 83, 421, 'фцв', '2023-03-14 09:51:19.165042');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (355, 83, 421, 'йу2йу', '2023-03-14 09:51:28.823882');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (356, 83, 421, 'фф', '2023-03-14 09:51:47.132327');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (357, 74, 421, 'awd', '2023-03-14 11:48:53.637987');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (358, 76, 421, '!!!!', '2023-03-14 12:46:07.867494');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (359, 76, 421, 'se', '2023-03-14 12:49:22.761202');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (360, 72, 421, '!!!!', '2023-03-14 12:50:46.9867');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (361, 76, 421, 'awdaw', '2023-03-14 12:50:59.542022');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (362, 76, 421, 'ascasas', '2023-03-14 14:50:03.29285');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (363, 76, 421, 'cszc', '2023-03-14 14:50:06.893288');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (364, 76, 421, 'sczzczz', '2023-03-14 14:50:13.609098');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (365, 76, 421, 'sd', '2023-03-14 16:44:43.179326');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (366, 72, 421, 'awdda', '2023-03-14 16:45:08.408388');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (367, 76, 421, 'awda', '2023-03-14 16:50:46.664736');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (368, 76, 421, 'xdv', '2023-03-15 13:09:59.59075');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (369, 84, 421, 'e2', '2023-03-15 16:29:42.300465');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (370, 84, 421, 'qe', '2023-03-15 16:29:45.417588');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (371, 84, 421, 'q2e', '2023-03-15 16:29:55.713679');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (372, 84, 421, 'sef', '2023-03-16 12:00:34.674422');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (373, 83, 421, 'gff', '2023-03-16 12:11:16.511872');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (374, 85, 421, 'опаоп', '2023-03-16 12:44:44.572566');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (375, 85, 421, 'пиарап', '2023-03-16 12:44:50.981675');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (376, 85, 421, 'онаоао', '2023-03-16 12:45:29.723091');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (377, 76, 437, ',ljn', '2023-03-16 16:54:40.583488');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (392, 76, 421, 'АУК', '2023-03-17 12:11:39.993299');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (393, 73, 421, 'jhfu', '2023-03-17 12:35:08.832775');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (394, 73, 421, 'jhg', '2023-03-17 12:35:44.039227');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (395, 89, 421, 'ad', '2023-03-17 13:01:39.378703');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (396, 90, 421, 'sef', '2023-03-17 15:06:34.359211');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (397, 74, 421, 'esf', '2023-03-17 15:07:01.213794');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (398, 76, 421, '123', '2023-03-17 15:11:27.299273');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (399, 76, 421, '1231', '2023-03-17 15:11:37.655994');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (405, 76, 421, 'yuyui', '2023-03-17 15:44:17.850584');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (411, 76, 437, 'zcz', '2023-03-21 07:36:13.1503');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (412, 73, 437, 'klho', '2023-03-21 07:40:04.090242');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (413, 76, 437, '54', '2023-03-21 07:51:53.430708');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (414, 76, 437, '3213', '2023-03-21 07:52:16.190837');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (415, 76, 437, '321', '2023-03-21 07:53:17.569986');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (416, 76, 437, '541', '2023-03-21 07:53:55.517267');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (417, 76, 437, '13', '2023-03-21 07:53:56.398882');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (418, 76, 437, '316', '2023-03-21 07:53:57.310585');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (419, 84, 437, '546+5', '2023-03-21 07:54:00.952361');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (420, 76, 437, '1', '2023-03-21 08:05:28.224922');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (421, 76, 437, '2', '2023-03-21 08:05:29.318626');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (422, 76, 437, '3', '2023-03-21 08:05:30.330876');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (423, 76, 437, '1', '2023-03-21 08:06:49.537989');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (424, 76, 437, '2', '2023-03-21 08:06:50.641666');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (425, 76, 437, '3', '2023-03-21 08:06:51.439968');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (426, 76, 437, '1', '2023-03-21 08:07:34.371995');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (427, 76, 437, '231', '2023-03-21 08:09:53.975359');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (428, 76, 437, '231', '2023-03-21 08:11:29.558913');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (429, 76, 437, '35213', '2023-03-21 08:12:45.887091');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (430, 84, 437, 'ljhfg', '2023-03-21 08:13:25.902489');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (431, 84, 437, 'jkhg', '2023-03-21 08:13:37.433798');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (432, 84, 437, '321', '2023-03-21 08:14:17.042304');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (433, 84, 437, 'ko;', '2023-03-21 08:15:54.472537');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (434, 84, 437, 'xv', '2023-03-21 08:20:30.513351');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (435, 84, 437, '321', '2023-03-21 08:22:25.401766');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (436, 84, 437, '2313', '2023-03-21 08:23:13.376951');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (437, 84, 437, '3213', '2023-03-21 08:25:06.14356');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (438, 76, 437, '654', '2023-03-21 08:27:52.472111');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (439, 84, 437, '657', '2023-03-21 08:27:59.811602');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (440, 84, 437, '313', '2023-03-21 08:31:52.634503');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (441, 76, 437, '646', '2023-03-21 08:34:08.861865');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (442, 84, 437, '56746', '2023-03-21 08:34:17.730913');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (443, 84, 437, 'hjf', '2023-03-21 08:36:23.333036');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (444, 84, 437, '654', '2023-03-21 08:37:06.634106');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (445, 74, 437, '6846', '2023-03-21 08:38:30.119887');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (446, 84, 437, '65465', '2023-03-21 08:40:09.153341');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (447, 84, 437, 'hgf', '2023-03-21 08:41:17.62289');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (448, 84, 437, 'jkg', '2023-03-21 08:42:49.523194');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (449, 84, 437, '546', '2023-03-21 08:44:16.725462');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (450, 84, 437, '654', '2023-03-21 08:44:51.1832');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (451, 84, 437, '[[[', '2023-03-21 08:47:22.293262');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (452, 76, 437, '64', '2023-03-21 09:02:07.353055');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (453, 73, 437, 'asd', '2023-03-21 09:39:38.37225');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (454, 74, 437, 'asd', '2023-03-21 09:41:30.794389');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (455, 74, 437, 'wqd', '2023-03-21 09:41:34.751993');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (456, 76, 421, 'qwd', '2023-03-21 09:42:01.670011');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (457, 76, 437, 'ef', '2023-03-21 09:56:57.071115');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (458, 76, 437, 'wefww23', '2023-03-21 09:57:09.329652');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (459, 76, 437, 'po[o', '2023-03-21 10:14:08.613924');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (460, 76, 437, 'p[pppp', '2023-03-21 10:14:26.016427');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (461, 76, 437, 'k[k', '2023-03-21 10:14:30.772685');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (462, 76, 437, ';[', '2023-03-21 10:16:10.961289');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (463, 76, 437, 'l]l', '2023-03-21 10:16:15.321344');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (464, 76, 437, 'saca', '2023-03-21 10:17:20.229102');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (465, 76, 437, 'asc', '2023-03-21 10:17:23.814203');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (466, 76, 437, 'ac', '2023-03-21 10:17:32.480787');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (467, 76, 437, 'qw', '2023-03-21 10:20:41.342215');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (468, 76, 437, 'daaa', '2023-03-21 10:20:45.041564');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (469, 76, 437, 'adacs', '2023-03-21 10:20:56.983596');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (470, 76, 437, '!!!!', '2023-03-21 10:27:31.900434');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (471, 76, 437, 'asd', '2023-03-21 10:29:20.203871');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (472, 76, 437, 'daw', '2023-03-21 10:29:36.890332');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (473, 76, 437, 'ad', '2023-03-21 10:29:41.344661');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (474, 74, 437, 'awd', '2023-03-21 10:30:25.065848');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (475, 74, 437, 'wadawd', '2023-03-21 10:30:32.791176');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (476, 74, 437, 'awwqqwd', '2023-03-21 10:30:40.73045');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (477, 74, 437, 'awdadw', '2023-03-21 10:31:50.01992');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (478, 74, 437, '!!!!', '2023-03-21 10:32:04.361205');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (479, 74, 437, 'asdasdwq212', '2023-03-21 10:32:24.588063');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (480, 74, 437, 'adwaaaa', '2023-03-21 10:32:55.48765');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (481, 76, 437, 'wqdwq', '2023-03-21 10:33:42.591785');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (482, 76, 437, 'wq2321312', '2023-03-21 10:33:50.964195');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (483, 76, 437, 'qwdqdqdwqw', '2023-03-21 10:34:02.142097');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (484, 76, 437, 'qwd', '2023-03-21 10:34:13.127997');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (485, 76, 437, 'wdq', '2023-03-21 10:35:36.056522');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (486, 76, 437, 'wdq', '2023-03-21 10:35:44.003393');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (487, 74, 437, 'q2134', '2023-03-21 10:35:54.036083');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (488, 74, 437, '121', '2023-03-21 10:35:58.947937');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (489, 76, 437, 'q2q2eqe', '2023-03-21 10:36:20.637594');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (490, 76, 437, 'we21', '2023-03-21 10:38:24.702505');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (491, 76, 437, '1', '2023-03-21 10:39:30.71202');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (492, 76, 437, '12', '2023-03-21 10:39:42.603004');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (493, 76, 437, 'qw', '2023-03-21 10:41:53.240741');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (494, 76, 437, '231', '2023-03-21 10:44:14.372484');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (495, 76, 437, 'asdf', '2023-03-21 10:45:27.880053');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (496, 76, 437, 'adw', '2023-03-21 10:46:34.089867');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (497, 76, 437, 'trrt', '2023-03-21 10:52:03.369091');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (498, 76, 437, 'rt', '2023-03-21 10:53:51.010517');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (499, 76, 437, 'fg', '2023-03-21 10:53:55.381202');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (500, 76, 437, 'cf', '2023-03-21 10:54:05.117881');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (501, 76, 437, 'ss', '2023-03-21 10:54:08.093694');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (504, 76, 421, 'gyugyugug', '2023-03-21 11:25:30.463889');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (506, 76, 421, 'kg', '2023-03-21 11:29:54.217537');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (507, 76, 437, '1231321', '2023-03-21 11:34:38.919367');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (508, 76, 437, '564654', '2023-03-21 11:36:32.806636');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (509, 76, 437, '6465', '2023-03-21 11:36:57.718697');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (510, 76, 437, '65465', '2023-03-21 11:37:25.563575');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (511, 76, 437, '654', '2023-03-21 11:37:37.434464');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (512, 76, 437, '231', '2023-03-21 11:37:51.986504');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (513, 76, 437, '365', '2023-03-21 11:39:23.113898');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (514, 84, 421, 'sef', '2023-03-22 12:33:16.030608');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (515, 83, 421, 'ad', '2023-03-22 12:33:30.807873');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (516, 84, 437, 'efsfssffssfe', '2023-03-22 15:04:59.247113');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (517, 76, 421, 'dgdgdgdgdgdgg', '2023-03-22 15:08:33.888759');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (518, 94, 421, 'wq', '2023-03-22 16:50:08.111041');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (519, 76, 421, 'kjlkm', '2023-03-23 08:23:18.411157');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (520, 76, 421, ';mk;', '2023-03-23 08:23:24.226433');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (521, 76, 421, ';kmjp;m', '2023-03-23 08:23:28.584788');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (522, 83, 421, '!!!', '2023-03-23 08:27:31.884756');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (523, 87, 421, 'lkn', '2023-03-23 08:36:28.837418');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (524, 76, 421, 'l;jggt', '2023-03-23 09:29:41.215245');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (525, 76, 421, 'ho;h;', '2023-03-23 09:29:50.420202');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (531, 74, 421, 'll', '2023-03-27 10:41:17.23987');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (532, 84, 421, 'kgk', '2023-03-27 10:41:58.849931');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (533, 100, 421, 'jvbhjbh', '2023-03-27 16:44:15.711228');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (534, 100, 421, 'kjho', '2023-03-27 16:44:27.221473');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (535, 101, 421, 'kljhh', '2023-03-27 16:51:07.902575');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (539, 76, 421, ' vb ', '2023-04-03 08:26:34.977519');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (540, 76, 421, 'vgh', '2023-04-03 08:26:41.817092');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (541, 76, 421, 'vghhvhvg', '2023-04-03 08:27:08.977384');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (542, 84, 421, 'xdg', '2023-04-03 08:27:15.41888');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (543, 84, 421, 'ып', '2023-04-03 08:27:33.844415');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (545, 76, 421, 'коллапс', '2023-05-23 16:54:54.470064');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (546, 76, 421, 'полный', '2023-05-23 16:55:06.201396');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (547, 76, 421, 'пипец', '2023-05-23 16:55:10.392251');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (548, 76, 421, 'труьа', '2023-05-23 16:55:20.636097');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (549, 76, 421, 'труба', '2023-05-23 16:55:33.210677');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (550, 76, 421, 'не работает', '2023-05-23 16:55:45.013349');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (551, 76, 421, 'епгегнг', '2023-05-23 16:56:18.438869');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (552, 76, 421, 'лдоиждлои', '2023-05-23 16:56:25.147882');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (557, 76, 421, 'вм', '2023-05-24 08:14:40.002349');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (558, 76, 421, 'ва', '2023-05-24 08:41:08.808389');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (559, 115, 421, 'ен', '2023-05-24 09:00:05.465783');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (566, 95, 421, 'we', '2023-05-24 11:29:11.422932');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (567, 95, 421, 'ds', '2023-05-24 11:29:34.558914');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (568, 95, 421, 'p', '2023-05-24 14:21:19.294682');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (572, 117, 421, 'rrtryrt', '2023-06-05 15:18:13.647074');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (574, 117, 421, '2', '2023-06-05 15:27:56.995292');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (575, 117, 421, '3', '2023-06-05 15:27:58.275068');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (576, 117, 421, '4', '2023-06-05 15:27:59.396097');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (577, 117, 421, '5', '2023-06-05 15:28:00.24383');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (578, 117, 421, '6', '2023-06-05 15:28:01.013745');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (579, 117, 421, '7', '2023-06-05 15:28:02.26975');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (580, 117, 421, '8', '2023-06-05 15:28:03.285006');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (581, 117, 421, '9', '2023-06-05 15:28:04.277354');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (582, 117, 421, '10', '2023-06-05 15:28:05.8302');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (583, 117, 421, '11', '2023-06-05 15:30:02.407322');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (584, 117, 421, '12', '2023-06-05 15:30:03.934266');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (585, 117, 421, '13', '2023-06-05 15:30:05.264426');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (586, 117, 421, '14', '2023-06-05 15:30:06.831578');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (587, 117, 421, '15', '2023-06-05 15:30:08.042342');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (588, 117, 421, '16', '2023-06-05 15:30:09.3658');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (589, 117, 421, '17', '2023-06-05 15:30:10.367121');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (590, 117, 421, '18', '2023-06-05 15:30:12.019734');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (591, 117, 421, '19', '2023-06-05 15:30:13.241436');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (592, 117, 421, '20', '2023-06-05 15:30:15.16529');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (593, 95, 421, 'j', '2023-06-05 15:31:05.158893');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (594, 95, 421, '5', '2023-06-05 15:31:15.289799');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (595, 95, 421, '6', '2023-06-05 15:31:16.207861');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (596, 95, 421, '7', '2023-06-05 15:31:17.18228');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (597, 95, 421, '8', '2023-06-05 15:31:17.921304');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (598, 95, 421, '9', '2023-06-05 15:31:18.647336');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (599, 95, 421, '0', '2023-06-05 15:31:19.238753');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (600, 95, 421, '2', '2023-06-05 15:31:20.348828');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (601, 95, 421, '2', '2023-06-05 15:31:21.12524');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (602, 95, 421, '3', '2023-06-05 15:31:22.163475');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (603, 95, 421, '56', '2023-06-05 15:31:22.959347');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (604, 95, 421, '567', '2023-06-05 15:31:23.816308');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (605, 95, 421, '768', '2023-06-05 15:31:24.663043');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (610, 120, 421, 'kl', '2023-06-07 08:39:31.054439');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (611, 94, 421, 'ydy', '2023-06-16 12:11:11.968813');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (612, 94, 421, 'dydhyh', '2023-06-16 12:11:14.355959');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (613, 94, 421, 'dhrdthtrf', '2023-06-16 12:11:19.604921');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (614, 94, 421, 'dytht', '2023-06-16 12:11:21.974525');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (616, 95, 421, 'sef', '2023-06-16 15:43:45.777571');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (617, 95, 421, 'sef', '2023-06-16 15:43:46.685398');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (618, 95, 421, 'sef', '2023-06-16 15:43:47.644471');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (619, 95, 421, 'sef', '2023-06-16 15:43:48.302393');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (620, 95, 421, 'sfe', '2023-06-16 15:43:48.867886');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (621, 95, 421, 'sfe', '2023-06-16 15:43:49.495207');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (622, 95, 421, 'sef', '2023-06-16 15:43:50.145465');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (623, 95, 421, 'sef', '2023-06-16 15:43:50.742866');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (624, 95, 421, 'sef', '2023-06-16 15:43:51.31237');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (625, 95, 421, 'sef', '2023-06-16 15:43:51.883812');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (626, 95, 421, 'sf', '2023-06-16 15:43:52.578886');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (627, 95, 421, 'sef', '2023-06-16 15:43:53.320051');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (628, 95, 421, 'sef', '2023-06-16 15:43:54.028737');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (629, 95, 421, 'fdd', '2023-06-16 15:43:55.63194');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (630, 95, 421, 'dfg', '2023-06-16 15:43:56.640992');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (631, 95, 421, 'asefwe', '2023-06-16 15:43:58.157993');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (632, 95, 421, 'gasag', '2023-06-16 15:43:59.692621');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (640, 104, 421, 'yuiol', '2023-07-04 12:54:22.146582');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (641, 104, 421, 'itiguolo;', '2023-07-04 12:54:23.424081');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (642, 104, 421, 'iul', '2023-07-04 12:54:24.505388');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (643, 104, 421, 'tiul', '2023-07-04 12:54:25.515185');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (644, 104, 421, 'f7i7', '2023-07-04 12:54:26.708485');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (645, 104, 421, 'ykuilku89', '2023-07-04 12:54:28.026013');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (646, 104, 421, '87o987o', '2023-07-04 12:54:29.251032');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (647, 104, 421, 'iluiol', '2023-07-04 12:54:30.432287');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (648, 104, 421, 'yuio', '2023-07-04 12:54:31.567336');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (649, 104, 421, '1', '2023-07-04 12:56:05.298931');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (650, 104, 421, '2', '2023-07-04 12:56:06.037254');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (651, 104, 421, '3', '2023-07-04 12:56:07.070019');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (652, 104, 421, '4', '2023-07-04 12:56:07.796088');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (653, 104, 421, '5', '2023-07-04 12:56:08.546079');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (654, 104, 421, '6', '2023-07-04 12:56:09.31318');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (655, 104, 421, '7', '2023-07-04 12:56:10.396589');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (656, 104, 421, '8', '2023-07-04 12:56:11.067793');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (657, 104, 421, '9', '2023-07-04 12:56:12.795598');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (658, 104, 421, '10', '2023-07-04 12:56:15.21172');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (659, 104, 421, '11', '2023-07-04 12:56:16.644228');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (660, 104, 421, '12', '2023-07-04 12:56:18.479283');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (661, 104, 421, '14', '2023-07-04 12:56:19.871164');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (664, 121, 421, '1', '2023-07-04 13:59:47.88922');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (665, 121, 421, '2', '2023-07-04 13:59:49.139356');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (666, 121, 421, '3', '2023-07-04 13:59:50.131003');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (667, 121, 421, '4', '2023-07-04 13:59:53.762531');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (668, 121, 421, '5', '2023-07-04 13:59:56.239443');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (669, 121, 421, '6', '2023-07-04 13:59:59.550004');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (670, 121, 421, '7', '2023-07-04 14:00:01.077419');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (671, 121, 421, '8', '2023-07-04 14:00:01.947627');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (672, 121, 421, '9', '2023-07-04 14:00:03.344058');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (673, 121, 421, '10', '2023-07-04 14:00:05.160777');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (674, 121, 421, '11', '2023-07-04 14:00:07.257056');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (675, 121, 421, '12', '2023-07-04 14:00:35.961566');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (676, 121, 421, '13', '2023-07-04 14:00:38.111136');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (677, 121, 421, '14', '2023-07-04 14:00:40.907935');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (678, 121, 421, '15', '2023-07-04 14:00:47.267201');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (679, 121, 421, '16', '2023-07-04 14:02:21.568061');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (680, 121, 421, '17', '2023-07-04 14:02:24.407912');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (681, 121, 421, '18', '2023-07-04 14:02:26.527955');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (682, 121, 421, '19', '2023-07-04 14:02:28.556258');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (683, 121, 421, '20', '2023-07-04 14:02:31.465436');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (684, 121, 421, '21', '2023-07-04 14:04:06.013496');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (685, 121, 421, '\oi', '2023-07-04 14:35:57.949716');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (686, 121, 421, '23', '2023-07-04 14:39:14.898151');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (687, 121, 421, '24', '2023-07-04 14:39:16.136463');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (688, 121, 421, '25', '2023-07-04 14:39:17.336167');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (689, 121, 421, '26', '2023-07-04 14:39:18.606533');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (690, 121, 421, '27', '2023-07-04 14:39:19.666346');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (691, 121, 421, '28', '2023-07-04 14:39:20.671447');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (692, 121, 421, '29', '2023-07-04 14:39:21.724601');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (693, 121, 421, '30', '2023-07-04 14:39:22.787722');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (694, 121, 421, '31', '2023-07-04 14:39:26.980081');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (695, 72, 421, 'qwd', '2023-07-04 14:43:44.192409');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (696, 121, 421, 'qwd', '2023-07-04 14:44:06.386188');
INSERT INTO public.chatmessages (id, chat, sender, text, messagetime) VALUES (697, 122, 421, '1', '2023-08-25 08:45:20.753517');


--
-- TOC entry 3653 (class 0 OID 36286)
-- Dependencies: 255
-- Data for Name: chats; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.chats (id, name, level, parent, admin) VALUES (75, '546', 4, 26, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (77, '2', 4, 17, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (78, '1', 4, 16, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (79, 'tpt jlyj hghjfh', 4, 28, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (94, 'работа для работы', 3, 8, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (96, 'Поручение специально для тех,кто пытался создать поручение, специально претендуя на длинное название', 4, 15, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (99, 'w657w647w56w567', 3, 16, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (100, '122222', 3, 9, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (101, '687496', 3, 19, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (102, 'РАботка', 3, 23, 437);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (103, 'work!!!', 3, 25, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (83, 'СапуноГв-Сапу-ишина', NULL, NULL, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (85, NULL, NULL, NULL, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (105, 'bmjhbmbb', 4, 78, 437);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (80, 'UHEGGF', NULL, NULL, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (106, '123456', 4, 79, 437);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (107, '1231232', 3, 26, 437);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (73, 'qe12231', 4, 7, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (86, 'sefsef23132', 4, 33, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (87, '!!!!!!!11123123', 4, 53, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (88, 'hfgj', 4, 57, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (89, '12211222', 4, 52, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (90, '11111', 4, 13, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (104, 'Задача 45', 2, 9, 437);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (91, '2221ввап', 4, 10, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (108, 'йййййййййййййййййййй', NULL, NULL, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (72, 'поручениеq', 4, 4, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (84, 'ОООГОКТПEY-22', NULL, NULL, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (109, 'DSLKJ', NULL, NULL, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (110, '5641641', 4, 69, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (111, 'ест редиски', 2, 19, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (112, 'Статусим', 4, 68, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (113, 'esfsfe', 2, 20, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (114, 'поросенок', 2, 17, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (74, 'Пробное пор', 4, 9, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (76, 'работа робота работающего рабочего Роботуна ', 3, 7, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (115, 't678t', 4, 82, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (116, 'Починить все', 3, 28, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (95, 'Картошкин маникюр', 2, 13, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (117, 'ИСУПян поросенок', 1, 11, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (119, 'wqdqwqdqwdqdqqa', 1, 22, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (120, 'test', 2, 25, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (121, '2', 3, 31, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (122, 'Новая работа - 2', 3, 76, 421);
INSERT INTO public.chats (id, name, level, parent, admin) VALUES (125, 'ИСУП', 1, 63, 421);


--
-- TOC entry 3655 (class 0 OID 36312)
-- Dependencies: 257
-- Data for Name: chatusers; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.chatusers (id, "user", chat) VALUES (160, 421, 72);
INSERT INTO public.chatusers (id, "user", chat) VALUES (162, 424, 73);
INSERT INTO public.chatusers (id, "user", chat) VALUES (163, 421, 74);
INSERT INTO public.chatusers (id, "user", chat) VALUES (164, 424, 75);
INSERT INTO public.chatusers (id, "user", chat) VALUES (165, 421, 75);
INSERT INTO public.chatusers (id, "user", chat) VALUES (166, 421, 76);
INSERT INTO public.chatusers (id, "user", chat) VALUES (170, 424, 77);
INSERT INTO public.chatusers (id, "user", chat) VALUES (171, 421, 77);
INSERT INTO public.chatusers (id, "user", chat) VALUES (172, 438, 78);
INSERT INTO public.chatusers (id, "user", chat) VALUES (173, 421, 78);
INSERT INTO public.chatusers (id, "user", chat) VALUES (174, 424, 79);
INSERT INTO public.chatusers (id, "user", chat) VALUES (175, 421, 79);
INSERT INTO public.chatusers (id, "user", chat) VALUES (243, 421, 84);
INSERT INTO public.chatusers (id, "user", chat) VALUES (252, 438, 83);
INSERT INTO public.chatusers (id, "user", chat) VALUES (193, 421, 80);
INSERT INTO public.chatusers (id, "user", chat) VALUES (194, 437, 80);
INSERT INTO public.chatusers (id, "user", chat) VALUES (195, 424, 80);
INSERT INTO public.chatusers (id, "user", chat) VALUES (196, 438, 80);
INSERT INTO public.chatusers (id, "user", chat) VALUES (255, 437, 83);
INSERT INTO public.chatusers (id, "user", chat) VALUES (256, 421, 85);
INSERT INTO public.chatusers (id, "user", chat) VALUES (257, 424, 85);
INSERT INTO public.chatusers (id, "user", chat) VALUES (260, 421, 73);
INSERT INTO public.chatusers (id, "user", chat) VALUES (261, 437, 73);
INSERT INTO public.chatusers (id, "user", chat) VALUES (262, 438, 86);
INSERT INTO public.chatusers (id, "user", chat) VALUES (263, 421, 86);
INSERT INTO public.chatusers (id, "user", chat) VALUES (264, 438, 87);
INSERT INTO public.chatusers (id, "user", chat) VALUES (265, 421, 87);
INSERT INTO public.chatusers (id, "user", chat) VALUES (266, 437, 88);
INSERT INTO public.chatusers (id, "user", chat) VALUES (267, 421, 88);
INSERT INTO public.chatusers (id, "user", chat) VALUES (268, 438, 89);
INSERT INTO public.chatusers (id, "user", chat) VALUES (269, 421, 89);
INSERT INTO public.chatusers (id, "user", chat) VALUES (270, 438, 90);
INSERT INTO public.chatusers (id, "user", chat) VALUES (271, 421, 90);
INSERT INTO public.chatusers (id, "user", chat) VALUES (273, 438, 91);
INSERT INTO public.chatusers (id, "user", chat) VALUES (274, 421, 91);
INSERT INTO public.chatusers (id, "user", chat) VALUES (221, 421, 83);
INSERT INTO public.chatusers (id, "user", chat) VALUES (287, 437, 74);
INSERT INTO public.chatusers (id, "user", chat) VALUES (292, 437, 94);
INSERT INTO public.chatusers (id, "user", chat) VALUES (293, 421, 94);
INSERT INTO public.chatusers (id, "user", chat) VALUES (294, 438, 94);
INSERT INTO public.chatusers (id, "user", chat) VALUES (295, 424, 94);
INSERT INTO public.chatusers (id, "user", chat) VALUES (298, 421, 95);
INSERT INTO public.chatusers (id, "user", chat) VALUES (299, 438, 96);
INSERT INTO public.chatusers (id, "user", chat) VALUES (300, 421, 96);
INSERT INTO public.chatusers (id, "user", chat) VALUES (303, 443, 95);
INSERT INTO public.chatusers (id, "user", chat) VALUES (304, 438, 99);
INSERT INTO public.chatusers (id, "user", chat) VALUES (305, 438, 100);
INSERT INTO public.chatusers (id, "user", chat) VALUES (306, 421, 100);
INSERT INTO public.chatusers (id, "user", chat) VALUES (307, 421, 101);
INSERT INTO public.chatusers (id, "user", chat) VALUES (308, 421, 102);
INSERT INTO public.chatusers (id, "user", chat) VALUES (309, 421, 103);
INSERT INTO public.chatusers (id, "user", chat) VALUES (310, 421, 104);
INSERT INTO public.chatusers (id, "user", chat) VALUES (311, 438, 104);
INSERT INTO public.chatusers (id, "user", chat) VALUES (312, 421, 105);
INSERT INTO public.chatusers (id, "user", chat) VALUES (313, 437, 105);
INSERT INTO public.chatusers (id, "user", chat) VALUES (314, 421, 106);
INSERT INTO public.chatusers (id, "user", chat) VALUES (315, 437, 106);
INSERT INTO public.chatusers (id, "user", chat) VALUES (316, 421, 107);
INSERT INTO public.chatusers (id, "user", chat) VALUES (317, 437, 107);
INSERT INTO public.chatusers (id, "user", chat) VALUES (318, 443, 104);
INSERT INTO public.chatusers (id, "user", chat) VALUES (319, 437, 104);
INSERT INTO public.chatusers (id, "user", chat) VALUES (320, 426, 108);
INSERT INTO public.chatusers (id, "user", chat) VALUES (321, 443, 108);
INSERT INTO public.chatusers (id, "user", chat) VALUES (322, 421, 108);
INSERT INTO public.chatusers (id, "user", chat) VALUES (323, 438, 108);
INSERT INTO public.chatusers (id, "user", chat) VALUES (324, 437, 84);
INSERT INTO public.chatusers (id, "user", chat) VALUES (325, 424, 76);
INSERT INTO public.chatusers (id, "user", chat) VALUES (326, 424, 84);
INSERT INTO public.chatusers (id, "user", chat) VALUES (329, 421, 109);
INSERT INTO public.chatusers (id, "user", chat) VALUES (330, 437, 109);
INSERT INTO public.chatusers (id, "user", chat) VALUES (331, 421, 110);
INSERT INTO public.chatusers (id, "user", chat) VALUES (332, 421, 111);
INSERT INTO public.chatusers (id, "user", chat) VALUES (333, 421, 112);
INSERT INTO public.chatusers (id, "user", chat) VALUES (334, 438, 112);
INSERT INTO public.chatusers (id, "user", chat) VALUES (335, 421, 113);
INSERT INTO public.chatusers (id, "user", chat) VALUES (336, 438, 113);
INSERT INTO public.chatusers (id, "user", chat) VALUES (337, 421, 114);
INSERT INTO public.chatusers (id, "user", chat) VALUES (338, 438, 114);
INSERT INTO public.chatusers (id, "user", chat) VALUES (340, 437, 76);
INSERT INTO public.chatusers (id, "user", chat) VALUES (342, 426, 76);
INSERT INTO public.chatusers (id, "user", chat) VALUES (343, 443, 76);
INSERT INTO public.chatusers (id, "user", chat) VALUES (344, 421, 115);
INSERT INTO public.chatusers (id, "user", chat) VALUES (345, 421, 116);
INSERT INTO public.chatusers (id, "user", chat) VALUES (348, 437, 95);
INSERT INTO public.chatusers (id, "user", chat) VALUES (349, 443, 117);
INSERT INTO public.chatusers (id, "user", chat) VALUES (350, 437, 117);
INSERT INTO public.chatusers (id, "user", chat) VALUES (351, 438, 117);
INSERT INTO public.chatusers (id, "user", chat) VALUES (352, 421, 117);
INSERT INTO public.chatusers (id, "user", chat) VALUES (353, 426, 119);
INSERT INTO public.chatusers (id, "user", chat) VALUES (354, 421, 119);
INSERT INTO public.chatusers (id, "user", chat) VALUES (355, 421, 120);
INSERT INTO public.chatusers (id, "user", chat) VALUES (356, 438, 120);
INSERT INTO public.chatusers (id, "user", chat) VALUES (357, 421, 121);
INSERT INTO public.chatusers (id, "user", chat) VALUES (358, 438, 121);
INSERT INTO public.chatusers (id, "user", chat) VALUES (359, 421, 122);
INSERT INTO public.chatusers (id, "user", chat) VALUES (360, 438, 122);
INSERT INTO public.chatusers (id, "user", chat) VALUES (365, 421, 125);
INSERT INTO public.chatusers (id, "user", chat) VALUES (366, 438, 125);


--
-- TOC entry 3641 (class 0 OID 26801)
-- Dependencies: 243
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.departments (id, name, postal_code, city, region, street) VALUES (17, 'МИ ФНС России по ЦОД № 2', NULL, NULL, NULL, NULL);
INSERT INTO public.departments (id, name, postal_code, city, region, street) VALUES (1, '00 -Заместители Руководителя', NULL, NULL, NULL, NULL);
INSERT INTO public.departments (id, name, postal_code, city, region, street) VALUES (2, '1- Аналитическое Управление', NULL, NULL, NULL, NULL);
INSERT INTO public.departments (id, name, postal_code, city, region, street) VALUES (3, '2- Контрольное Управление', NULL, NULL, NULL, NULL);
INSERT INTO public.departments (id, name, postal_code, city, region, street) VALUES (4, '3- Управление Налогообложения Юридических Лиц', NULL, NULL, NULL, NULL);
INSERT INTO public.departments (id, name, postal_code, city, region, street) VALUES (5, '4- Управление Кадров', NULL, NULL, NULL, NULL);
INSERT INTO public.departments (id, name, postal_code, city, region, street) VALUES (6, 'Руководство', NULL, NULL, NULL, NULL);
INSERT INTO public.departments (id, name, postal_code, city, region, street) VALUES (16, 'string', 'string', 'string', 'string', 'string');
INSERT INTO public.departments (id, name, postal_code, city, region, street) VALUES (18, '22 Управление по крупнейшим налогоплательщикам', NULL, NULL, NULL, NULL);


--
-- TOC entry 3611 (class 0 OID 25604)
-- Dependencies: 213
-- Data for Name: doctypes; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.doctypes (id, name) VALUES (1, 'Приказ');
INSERT INTO public.doctypes (id, name) VALUES (6, 'Отчет');
INSERT INTO public.doctypes (id, name) VALUES (7, 'Итог');
INSERT INTO public.doctypes (id, name) VALUES (8, 'Протокол');
INSERT INTO public.doctypes (id, name) VALUES (2, 'Распоряжение');
INSERT INTO public.doctypes (id, name) VALUES (5, 'План-график');


--
-- TOC entry 3631 (class 0 OID 25924)
-- Dependencies: 233
-- Data for Name: documentations; Type: TABLE DATA; Schema: public; Owner: pgsup
--



--
-- TOC entry 3647 (class 0 OID 36045)
-- Dependencies: 249
-- Data for Name: docusers; Type: TABLE DATA; Schema: public; Owner: pgsup
--



--
-- TOC entry 3613 (class 0 OID 25640)
-- Dependencies: 215
-- Data for Name: historyactions; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.historyactions (id, name) VALUES (1, 'Создание');
INSERT INTO public.historyactions (id, name) VALUES (2, 'Изменение');
INSERT INTO public.historyactions (id, name) VALUES (3, 'Удаление');
INSERT INTO public.historyactions (id, name) VALUES (4, 'Изменение статуса');
INSERT INTO public.historyactions (id, name) VALUES (5, 'Загрузка файла');
INSERT INTO public.historyactions (id, name) VALUES (6, 'Удаление файла');
INSERT INTO public.historyactions (id, name) VALUES (7, 'Подготовка отчетности');
INSERT INTO public.historyactions (id, name) VALUES (8, 'Взято в работу');


--
-- TOC entry 3643 (class 0 OID 27651)
-- Dependencies: 245
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.organizations (id, name) VALUES (1, 'string');
INSERT INTO public.organizations (id, name) VALUES (2, 'Центральный аппарат ФНС России');
INSERT INTO public.organizations (id, name) VALUES (3, 'Межрегиональные ИФНС');
INSERT INTO public.organizations (id, name) VALUES (4, 'Центральный аппарат ФНС Росси');


--
-- TOC entry 3615 (class 0 OID 25667)
-- Dependencies: 217
-- Data for Name: otdels; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.otdels (id, name, shortname) VALUES (37, 'string', '');
INSERT INTO public.otdels (id, name, shortname) VALUES (38, '03 Отдел по стандартизации процессов НА КН', '');
INSERT INTO public.otdels (id, name, shortname) VALUES (36, 'Отдел контроля технологических процессов', '');
INSERT INTO public.otdels (id, name, shortname) VALUES (39, 'ОООГ', NULL);


--
-- TOC entry 3617 (class 0 OID 25676)
-- Dependencies: 219
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.positions (id, name) VALUES (30, 'Заместитель начальника отдела');
INSERT INTO public.positions (id, name) VALUES (31, 'string');
INSERT INTO public.positions (id, name) VALUES (32, 'Руководитель');
INSERT INTO public.positions (id, name) VALUES (33, 'Консультант');


--
-- TOC entry 3663 (class 0 OID 36732)
-- Dependencies: 265
-- Data for Name: projectcheckpoints; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.projectcheckpoints (id, project, checkpoint) VALUES (16, 63, '2023-08-14');
INSERT INTO public.projectcheckpoints (id, project, checkpoint) VALUES (17, 63, '2023-08-21');
INSERT INTO public.projectcheckpoints (id, project, checkpoint) VALUES (18, 63, '2023-08-28');


--
-- TOC entry 3649 (class 0 OID 36074)
-- Dependencies: 251
-- Data for Name: projectfiles; Type: TABLE DATA; Schema: public; Owner: pgsup
--



--
-- TOC entry 3651 (class 0 OID 36253)
-- Dependencies: 253
-- Data for Name: projecthistorys; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (390, 421, 63, 1, '2023-09-05 08:23:04.740423', '{"description": "dfdf", "datestart": "2023-09-06", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-20", "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u043055\u0447\u0430", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "543"}', 69, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (391, 421, 63, 1, '2023-09-05 08:25:42.307379', '{"description": "awewe", "datestart": "2023-09-05", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "123", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "qwqwwq"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (392, 421, 63, 1, '2023-09-05 08:25:42.335305', '{"description": "dfdf", "datestart": "2023-09-06", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-20", "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u043055\u0447\u0430", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "543"}', 69, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (393, 421, 63, 1, '2023-09-05 08:26:20.486893', '{"description": "awewe", "datestart": "2023-09-05", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "123", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "qwqwwq"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (394, 421, 63, 1, '2023-09-05 08:26:20.501852', '{"description": "dfdf", "datestart": "2023-09-06", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-20", "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u043055\u0447\u0430", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "543"}', 69, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (395, 421, 63, 1, '2023-09-05 08:38:31.272575', '{"datestart": "2023-09-05", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "123321qqq", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "awewe", "longname": "qwqwwq"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (396, 421, 63, 1, '2023-09-05 08:40:30.099531', '{"datestart": "2023-09-05", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "123321qqqww", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "awewe", "longname": "qwqwwq"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (397, 421, 63, 1, '2023-09-05 08:40:30.215217', '{"longname": "wefw", "datestart": "2023-09-06", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-19", "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430ww", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "ssss"}', 68, 89, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (398, 421, 63, 1, '2023-09-05 08:43:52.513148', '{"datestart": "2023-09-05", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "123321qqqww", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "awewe", "longname": "qwqwwq"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (399, 421, 63, 1, '2023-09-05 08:43:52.59694', '{"datestart": "2023-09-06", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-19", "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430ww", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "wefw", "description": "ssss"}', 68, 89, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (400, 421, 63, 1, '2023-09-05 08:43:52.63793', '{"description": "wewefwfwf", "datestart": "2023-09-12", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-28", "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u0430\u0447\u0430ww", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "we"}', 70, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (401, 421, 63, 1, '2023-09-05 08:43:52.703498', '{"longname": "", "datestart": "2023-09-06", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u043021212", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "sefefe"}', 70, 90, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (402, 421, 63, 1, '2023-09-05 08:45:09.334889', '{"datestart": "2023-09-05", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "123321qqqww", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "awewe", "longname": "qwqwwq"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (403, 421, 63, 1, '2023-09-05 08:45:09.418665', '{"longname": "wee", "datestart": "2023-09-05", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "weweeeee"}', 68, 91, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (404, 421, 63, 1, '2023-09-05 08:45:09.472522', '{"datestart": "2023-09-12", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-28", "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u0430\u0447\u0430ww", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "wewefwfwf", "longname": "we"}', 70, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (405, 421, 63, 1, '2023-09-05 08:45:09.57165', '{"datestart": "2023-09-06", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u043021212", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "", "description": "sefefe"}', 70, 90, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (406, 421, 63, 1, '2023-09-05 08:45:29.886156', '{"datestart": "2023-09-05", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "123321qqqww", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "awewe", "longname": "qwqwwq"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (407, 421, 63, 1, '2023-09-05 08:45:29.967954', '{"longname": "wee", "datestart": "2023-09-05", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "weweeeee"}', 68, 92, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (408, 421, 63, 1, '2023-09-05 08:45:30.01384', '{"datestart": "2023-09-12", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-28", "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u0430\u0447\u0430ww", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "description": "wewefwfwf", "longname": "we"}', 70, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (409, 421, 63, 1, '2023-09-05 08:45:30.072075', '{"datestart": "2023-09-06", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "dateend": "2023-09-27", "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u043021212", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "", "description": "sefefe"}', 70, 90, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (410, 421, 63, 2, '2023-09-06 12:47:03.094072', '{"description": "awewe", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "qwqwwq", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "123321qqqww", "dateend": "2023-09-27", "datestart": "2023-09-05"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (411, 421, 63, 2, '2023-09-06 12:47:03.239752', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 91, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (412, 421, 63, 2, '2023-09-06 12:47:03.33348', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 92, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (413, 421, 63, 2, '2023-09-06 12:47:03.395993', '{"description": "wewefwfwf", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "we", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u0430\u0447\u0430ww", "dateend": "2023-09-28", "datestart": "2023-09-12"}', 70, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (414, 421, 63, 2, '2023-09-06 12:47:03.474073', '{"description": "sefefe", "longname": "", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u043021212", "datestart": "2023-09-06", "dateend": "2023-09-27"}', 70, 90, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (415, 421, 63, 2, '2023-09-06 12:47:42.468676', '{"description": "awewe", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "qwqwwq", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "123321qqqww", "dateend": "2023-09-27", "datestart": "2023-09-05"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (416, 421, 63, 2, '2023-09-06 12:47:42.562404', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 91, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (417, 421, 63, 2, '2023-09-06 12:47:42.640486', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 92, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (418, 421, 63, 2, '2023-09-06 12:47:42.734213', '{"description": "wewefwfwf", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "we", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u0430\u0447\u0430ww", "dateend": "2023-09-28", "datestart": "2023-09-12"}', 70, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (419, 421, 63, 2, '2023-09-06 12:47:42.812356', '{"description": "sefefe", "longname": "", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u043021212", "datestart": "2023-09-06", "dateend": "2023-09-27"}', 70, 90, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (420, 421, 63, 2, '2023-09-06 12:48:15.436752', '{"description": "awewe", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "qwqwwq", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "123321qqqww", "dateend": "2023-09-27", "datestart": "2023-09-05"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (421, 421, 63, 2, '2023-09-06 12:48:15.530453', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 91, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (422, 421, 63, 2, '2023-09-06 12:48:15.608557', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 92, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (423, 421, 63, 2, '2023-09-06 12:48:15.6867', '{"description": "wewefwfwf", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "we", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u0430\u0447\u0430ww", "dateend": "2023-09-28", "datestart": "2023-09-12"}', 70, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (424, 421, 63, 2, '2023-09-06 12:48:15.764799', '{"description": "sefefe", "longname": "", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 438, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u043021212", "datestart": "2023-09-06", "dateend": "2023-09-27"}', 70, 90, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (425, 421, 63, 2, '2023-09-06 12:49:26.968408', '{"description": "awewe", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "qwqwwq", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "123321qqqww", "dateend": "2023-09-27", "datestart": "2023-09-05"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (426, 421, 63, 2, '2023-09-06 12:49:27.062168', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 91, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (427, 421, 63, 2, '2023-09-06 12:49:27.171488', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 92, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (428, 421, 63, 2, '2023-09-06 12:49:27.233998', '{"description": "wewefwfwf", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "we", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u0430\u0447\u0430ww", "dateend": "2023-09-28", "datestart": "2023-09-12"}', 70, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (429, 421, 63, 2, '2023-09-06 12:49:27.343347', '{"description": "sefefe", "longname": "", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u043021212", "datestart": "2023-09-06", "dateend": "2023-09-27"}', 70, 90, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (430, 421, 63, 2, '2023-09-07 08:08:16.487291', '{"description": "awewe", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "qwqwwq", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "123321qqqww", "dateend": "2023-09-27", "datestart": "2023-09-05"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (431, 421, 63, 2, '2023-09-07 08:08:16.627913', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 91, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (432, 421, 63, 2, '2023-09-07 08:08:16.728812', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 92, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (433, 421, 63, 2, '2023-09-07 08:08:16.791328', '{"description": "wewefwfwf", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "we", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u0430\u0447\u0430ww", "dateend": "2023-09-28", "datestart": "2023-09-12"}', 70, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (434, 421, 63, 2, '2023-09-07 08:08:16.88503', '{"description": "sefefe", "longname": "", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u043021212", "datestart": "2023-09-06", "dateend": "2023-09-27"}', 70, 90, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (435, 421, 63, 2, '2023-09-08 08:14:18.952277', '{"description": "awewe", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "qwqwwq", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "123321qqqww", "dateend": "2023-09-27", "datestart": "2023-09-05"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (436, 421, 63, 2, '2023-09-08 08:14:19.061594', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 91, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (437, 421, 63, 2, '2023-09-08 08:14:19.155322', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 92, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (438, 421, 63, 2, '2023-09-08 08:14:19.217836', '{"description": "wewefwfwf", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "we", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u0430\u0447\u0430ww", "dateend": "2023-09-28", "datestart": "2023-09-12"}', 70, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (439, 421, 63, 2, '2023-09-08 08:14:19.295942', '{"description": "sefefe", "longname": "", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u043021212ddd", "datestart": "2023-09-06", "dateend": "2023-09-27"}', 70, 90, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (440, 421, 63, 2, '2023-09-08 08:15:28.309627', '{"description": "awewe", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "qwqwwq", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "1", "dateend": "2023-09-27", "datestart": "2023-09-05"}', 68, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (441, 421, 63, 2, '2023-09-08 08:15:28.387705', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 91, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (442, 421, 63, 2, '2023-09-08 08:15:28.465841', '{"description": "weweeeee", "longname": "wee", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u0430wer", "datestart": "2023-09-05", "dateend": "2023-09-27"}', 68, 92, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (443, 421, 63, 2, '2023-09-08 08:15:28.528296', '{"description": "wewefwfwf", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "we", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0437\u0430\u0434\u0430\u0447\u0430ww", "dateend": "2023-09-28", "datestart": "2023-09-12"}', 70, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (444, 421, 63, 2, '2023-09-08 08:15:28.622056', '{"description": "sefefe", "longname": "", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u041d\u043e\u0432\u0430\u044f \u0440\u0430\u0431\u043e\u0442\u043021212ddd", "datestart": "2023-09-06", "dateend": "2023-09-27"}', 70, 90, NULL, NULL, 3);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (445, 421, 63, 1, '2023-09-08 11:55:29.968713', '{"datestart": "2023-09-08", "dateend": "2023-09-15", "description": "", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "longname": "", "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u0414\u043e\u043a\u0443\u043c\u0435\u043d\u0442\u0430\u0446\u0438\u044f"}', 71, NULL, NULL, NULL, 2);
INSERT INTO public.projecthistorys (id, author, project, action, createdate, info, task, work, comment, assignment, level) VALUES (446, 421, 63, 1, '2023-09-08 11:55:30.123457', '{"description": "", "longname": "", "status": {"id": 1, "name": "\u0417\u0430\u043f\u043b\u0430\u043d\u0438\u0440\u043e\u0432\u0430\u043d\u0430"}, "responsible": {"givenName": "\u0412\u0438\u0442\u0430\u043b\u0438\u0439 \u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440\u043e\u0432\u0438\u0447", "id": 421, "sn": "\u0421\u0430\u043f\u0443\u043d\u043e\u0432"}, "name": "\u0422\u0435\u0441\u0442\u0438\u0440\u043e\u0432\u0430\u043d\u0438\u0435", "datestart": "2023-09-08", "dateend": "2023-09-09"}', 71, 93, NULL, NULL, 3);


--
-- TOC entry 3659 (class 0 OID 36445)
-- Dependencies: 261
-- Data for Name: projectroles; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.projectroles (id, name) VALUES (1, 'Директор');
INSERT INTO public.projectroles (id, name) VALUES (2, 'Руководитель проекта');
INSERT INTO public.projectroles (id, name) VALUES (3, 'Секретарь');
INSERT INTO public.projectroles (id, name) VALUES (4, 'Координатор');
INSERT INTO public.projectroles (id, name) VALUES (5, 'Участник');
INSERT INTO public.projectroles (id, name) VALUES (6, 'Наблюдатель');


--
-- TOC entry 3629 (class 0 OID 25837)
-- Dependencies: 231
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.projects (id, name, status, author, datestart, dateend, lastchanged, ptype, difficult, longname, info) VALUES (63, 'ИСУП', 1, 421, '2023-08-11', '2023-08-31', NULL, 2, 4, 'Информационная система управления проектами', '{"criteria": ["\u0423\u0441\u043f\u0435\u0445", "\u044b\u0432\u0430\u044b\u0432\u0430"], "docnumber": "", "dop_info": "\u0414\u043e\u043f\u043e\u043b\u043d\u0438\u0442\u0435\u043b\u044c\u043d\u0430\u044f \u0438\u043d\u0444\u043e\u0440\u043c\u0430\u0446\u0438\u044f:", "financial_support": "\u0424\u0438\u043d\u0430\u043d\u0441\u043e\u0432\u043e\u0435 \u043e\u0431\u0435\u0441\u043f\u0435\u0447\u0435\u043d\u0438\u0435 \u0440\u0430\u0441\u0445\u043e\u0434\u043d\u044b\u0445 \u043e\u0431\u044f\u0437\u0430\u0442\u0435\u043b\u044c\u0441\u0442\u0432:", "grounds": "\u041e\u0441\u043d\u043e\u0432\u0430\u043d\u0438\u044f \u0434\u043b\u044f \u0438\u043d\u0438\u0446\u0438\u0430\u043b\u0438\u0437\u0430\u0446\u0438\u0438 \u043f\u0440\u043e\u0435\u043a\u0442\u0430:", "influence": "", "interactions": ["\u0421\u0432\u044f\u0437\u0438", "\u044b\u0432\u0430\u0432\u044b\u0430"], "passport_last_date": "2023-08-11", "project_sphere": "\u041a\u0440\u0443\u0433\u043b\u0430\u044f", "result": ["\u0420\u0435\u0437\u0443\u043b\u044c\u0442\u0430\u0442", "\u0432\u044b\u0430\u044b\u0432\u0430"], "risks": ["\u0420\u0438\u0441\u043a\u0438", "\u044b\u0432\u0430\u044b\u0432\u0430"], "target": ["\u0426\u0435\u043b\u044c", "\u044b\u0432\u044b\u044b\u044b\u044b\u044b\u044b\u044b"]}');
INSERT INTO public.projects (id, name, status, author, datestart, dateend, lastchanged, ptype, difficult, longname, info) VALUES (64, 'фуааыуа', 1, 421, '2023-09-01', '2023-09-30', NULL, 2, 3, 'хававв', '{"financial_support": "\u0443\u0432\u044b\u0444\u0432", "project_sphere": "\u0444\u0446\u0432", "passport_last_date": "2023-09-05", "influence": "", "grounds": "\u044b\u0444\u0432\u044b\u0444\u0432\u0444\u044b", "target": [], "result": [], "criteria": [], "risks": [], "interactions": [], "dop_info": "\u0432\u0443\u0443\u0443\u0443", "docnumber": ""}');


--
-- TOC entry 3619 (class 0 OID 25685)
-- Dependencies: 221
-- Data for Name: projectstatuses; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.projectstatuses (id, name) VALUES (2, 'На согласовании');
INSERT INTO public.projectstatuses (id, name) VALUES (3, 'Утвержден');
INSERT INTO public.projectstatuses (id, name) VALUES (5, 'Приостановлен');
INSERT INTO public.projectstatuses (id, name) VALUES (6, 'Закрыт');
INSERT INTO public.projectstatuses (id, name) VALUES (1, 'Планирование');
INSERT INTO public.projectstatuses (id, name) VALUES (4, 'Исполнение');
INSERT INTO public.projectstatuses (id, name) VALUES (7, 'Завершен');


--
-- TOC entry 3639 (class 0 OID 26649)
-- Dependencies: 241
-- Data for Name: projecttypes; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.projecttypes (id, name) VALUES (1, 'Стратегический');
INSERT INTO public.projecttypes (id, name) VALUES (2, 'Оперативный');


--
-- TOC entry 3633 (class 0 OID 26073)
-- Dependencies: 235
-- Data for Name: projectusers; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.projectusers (id, involved, "user", project, role, percent) VALUES (466, false, 421, 64, 1, 2);
INSERT INTO public.projectusers (id, involved, "user", project, role, percent) VALUES (467, false, 421, 64, 2, 4);
INSERT INTO public.projectusers (id, involved, "user", project, role, percent) VALUES (538, false, 421, 63, 1, 1);
INSERT INTO public.projectusers (id, involved, "user", project, role, percent) VALUES (539, false, 421, 63, 2, 1);


--
-- TOC entry 3621 (class 0 OID 25694)
-- Dependencies: 223
-- Data for Name: ranks; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.ranks (id, name) VALUES (18, '');
INSERT INTO public.ranks (id, name) VALUES (19, 'string');


--
-- TOC entry 3635 (class 0 OID 26090)
-- Dependencies: 237
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.tasks (id, name, status, datestart, dateend, responsible, lastchanged, parent, description, difficult, longname) VALUES (71, 'Документация', 1, '2023-09-08', '2023-09-15', 421, '2023-09-08 11:55:29.869977', 63, '', 2, '');


--
-- TOC entry 3623 (class 0 OID 25703)
-- Dependencies: 225
-- Data for Name: taskstages; Type: TABLE DATA; Schema: public; Owner: pgsup
--



--
-- TOC entry 3625 (class 0 OID 25712)
-- Dependencies: 227
-- Data for Name: taskstatuses; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.taskstatuses (id, name) VALUES (3, 'Приостановлена');
INSERT INTO public.taskstatuses (id, name) VALUES (5, 'Завершена');
INSERT INTO public.taskstatuses (id, name) VALUES (4, 'На проверке');
INSERT INTO public.taskstatuses (id, name) VALUES (2, 'Исполнение');
INSERT INTO public.taskstatuses (id, name) VALUES (1, 'Запланирована');


--
-- TOC entry 3661 (class 0 OID 36621)
-- Dependencies: 263
-- Data for Name: userratings; Type: TABLE DATA; Schema: public; Owner: pgsup
--



--
-- TOC entry 3627 (class 0 OID 25749)
-- Dependencies: 229
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.users (id, phone, email, otdel, "position", rank, superuser, department, active, "physicalDeliveryOfficeName", "givenName", sn, "telephoneNumber", organization, username, avatar) VALUES (424, NULL, NULL, 36, 32, NULL, false, 17, true, 'ул. Неглинная, 23, кабинет 804', 'Даниил Вячеславович', 'Егоров', '8(99)1100', 3, '0000-06-903', '/static/default/avatardef.png');
INSERT INTO public.users (id, phone, email, otdel, "position", rank, superuser, department, active, "physicalDeliveryOfficeName", "givenName", sn, "telephoneNumber", organization, username, avatar) VALUES (426, NULL, NULL, 39, 33, NULL, false, 17, true, 'Рахмановский пер., 4 стр. 1, каб 903', 'Наталья Дмитриевна', 'Орехова', '8(99)0000', 3, '0000-09-663', '/static/default/avatardef.png');
INSERT INTO public.users (id, phone, email, otdel, "position", rank, superuser, department, active, "physicalDeliveryOfficeName", "givenName", sn, "telephoneNumber", organization, username, avatar) VALUES (437, NULL, 'g', 36, 30, NULL, true, 17, true, '8.12', 'Ирина Сергеевна', 'Гришина', NULL, 3, '9966-00-107', '/static/default/avatardef.png');
INSERT INTO public.users (id, phone, email, otdel, "position", rank, superuser, department, active, "physicalDeliveryOfficeName", "givenName", sn, "telephoneNumber", organization, username, avatar) VALUES (438, NULL, NULL, 39, 33, NULL, NULL, 17, NULL, NULL, 'Виталий Владимирович', 'Сапунов', NULL, 3, '9966-00-126', '/static/default/avatardef.png');
INSERT INTO public.users (id, phone, email, otdel, "position", rank, superuser, department, active, "physicalDeliveryOfficeName", "givenName", sn, "telephoneNumber", organization, username, avatar) VALUES (440, NULL, NULL, 38, 33, NULL, false, 18, true, 'Рахмановский пер., 4 стр. 1, каб 903', 'Наталья Дмитриевна', 'Ореховая', '8(99)0000', 2, '0000-09-665', '/static/default/avatardef.png');
INSERT INTO public.users (id, phone, email, otdel, "position", rank, superuser, department, active, "physicalDeliveryOfficeName", "givenName", sn, "telephoneNumber", organization, username, avatar) VALUES (441, NULL, NULL, 38, 33, NULL, false, 18, true, 'Рахмановскийй пер., 4 стр. 1, каб 903', 'Наталья Дмитриевна', 'Ореховая', '8(99)0000', 4, '0000-09-660', '/static/default/avatardef.png');
INSERT INTO public.users (id, phone, email, otdel, "position", rank, superuser, department, active, "physicalDeliveryOfficeName", "givenName", sn, "telephoneNumber", organization, username, avatar) VALUES (443, NULL, NULL, 39, 30, NULL, false, 17, NULL, NULL, 'Все фигня', 'Переделывай', '8(80)999', 3, '9966-00-777', '/static/default/avatardef.png');
INSERT INTO public.users (id, phone, email, otdel, "position", rank, superuser, department, active, "physicalDeliveryOfficeName", "givenName", sn, "telephoneNumber", organization, username, avatar) VALUES (421, NULL, 'asd/asd/a', 36, 32, 19, false, 17, true, '8.12', 'Виталий Владимирович', 'Сапунов', '8(80)5933', 3, '9966-00-125', '/static/default/avatardef.png');


--
-- TOC entry 3645 (class 0 OID 35952)
-- Dependencies: 247
-- Data for Name: works; Type: TABLE DATA; Schema: public; Owner: pgsup
--

INSERT INTO public.works (id, parent, name, status, description, datestart, dateend, responsible, lastchanged, difficult, longname) VALUES (93, 71, 'Тестирование', 1, '', '2023-09-08', '2023-09-09', 421, '2023-09-08 11:54:30.767633', 3, '');


--
-- TOC entry 3698 (class 0 OID 0)
-- Dependencies: 238
-- Name: assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.assignments_id_seq', 105, true);


--
-- TOC entry 3699 (class 0 OID 0)
-- Dependencies: 210
-- Name: assignmentstatuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.assignmentstatuses_id_seq', 10, true);


--
-- TOC entry 3700 (class 0 OID 0)
-- Dependencies: 258
-- Name: chatmessages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.chatmessages_id_seq', 697, true);


--
-- TOC entry 3701 (class 0 OID 0)
-- Dependencies: 254
-- Name: chats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.chats_id_seq', 125, true);


--
-- TOC entry 3702 (class 0 OID 0)
-- Dependencies: 256
-- Name: chatusers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.chatusers_id_seq', 366, true);


--
-- TOC entry 3703 (class 0 OID 0)
-- Dependencies: 242
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.departments_id_seq', 18, true);


--
-- TOC entry 3704 (class 0 OID 0)
-- Dependencies: 212
-- Name: doctypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.doctypes_id_seq', 8, true);


--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 232
-- Name: documentations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.documentations_id_seq', 137, true);


--
-- TOC entry 3706 (class 0 OID 0)
-- Dependencies: 248
-- Name: docusers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.docusers_id_seq', 57, true);


--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 214
-- Name: historyactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.historyactions_id_seq', 8, true);


--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 244
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.organizations_id_seq', 4, true);


--
-- TOC entry 3709 (class 0 OID 0)
-- Dependencies: 216
-- Name: otdels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.otdels_id_seq', 39, true);


--
-- TOC entry 3710 (class 0 OID 0)
-- Dependencies: 218
-- Name: positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.positions_id_seq', 33, true);


--
-- TOC entry 3711 (class 0 OID 0)
-- Dependencies: 264
-- Name: projectcheckpoints_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.projectcheckpoints_id_seq', 18, true);


--
-- TOC entry 3712 (class 0 OID 0)
-- Dependencies: 250
-- Name: projectfiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.projectfiles_id_seq', 130, true);


--
-- TOC entry 3713 (class 0 OID 0)
-- Dependencies: 252
-- Name: projecthistorys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.projecthistorys_id_seq', 446, true);


--
-- TOC entry 3714 (class 0 OID 0)
-- Dependencies: 260
-- Name: projectroles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.projectroles_id_seq', 6, true);


--
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 230
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.projects_id_seq', 64, true);


--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 220
-- Name: projectstatuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.projectstatuses_id_seq', 12, true);


--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 240
-- Name: projecttypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.projecttypes_id_seq', 4, true);


--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 234
-- Name: projectusers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.projectusers_id_seq', 539, true);


--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 222
-- Name: ranks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.ranks_id_seq', 19, true);


--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 236
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.tasks_id_seq', 71, true);


--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 224
-- Name: taskstages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.taskstages_id_seq', 1, false);


--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 226
-- Name: taskstatuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.taskstatuses_id_seq', 11, true);


--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 262
-- Name: userratings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.userratings_id_seq', 3, true);


--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 228
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.users_id_seq', 443, true);


--
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 246
-- Name: works_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsup
--

SELECT pg_catalog.setval('public.works_id_seq', 93, true);


--
-- TOC entry 3332 (class 2606 OID 16400)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 3386 (class 2606 OID 26141)
-- Name: assignments assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 3334 (class 2606 OID 25602)
-- Name: assignmentstatuses assignmentstatuses_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.assignmentstatuses
    ADD CONSTRAINT assignmentstatuses_name_key UNIQUE (name);


--
-- TOC entry 3336 (class 2606 OID 25600)
-- Name: assignmentstatuses assignmentstatuses_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.assignmentstatuses
    ADD CONSTRAINT assignmentstatuses_pkey PRIMARY KEY (id);


--
-- TOC entry 3414 (class 2606 OID 36336)
-- Name: chatmessages chatmessages_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chatmessages
    ADD CONSTRAINT chatmessages_pkey PRIMARY KEY (id);


--
-- TOC entry 3408 (class 2606 OID 36293)
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- TOC entry 3412 (class 2606 OID 36317)
-- Name: chatusers chatusers_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chatusers
    ADD CONSTRAINT chatusers_pkey PRIMARY KEY (id);


--
-- TOC entry 3392 (class 2606 OID 26808)
-- Name: departments departments_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_name_key UNIQUE (name);


--
-- TOC entry 3394 (class 2606 OID 26806)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- TOC entry 3338 (class 2606 OID 25611)
-- Name: doctypes doctypes_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.doctypes
    ADD CONSTRAINT doctypes_name_key UNIQUE (name);


--
-- TOC entry 3340 (class 2606 OID 25609)
-- Name: doctypes doctypes_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.doctypes
    ADD CONSTRAINT doctypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3378 (class 2606 OID 25929)
-- Name: documentations documentations_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.documentations
    ADD CONSTRAINT documentations_pkey PRIMARY KEY (id);


--
-- TOC entry 3402 (class 2606 OID 36052)
-- Name: docusers docusers_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.docusers
    ADD CONSTRAINT docusers_pkey PRIMARY KEY (id);


--
-- TOC entry 3342 (class 2606 OID 25647)
-- Name: historyactions historyactions_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.historyactions
    ADD CONSTRAINT historyactions_name_key UNIQUE (name);


--
-- TOC entry 3344 (class 2606 OID 25645)
-- Name: historyactions historyactions_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.historyactions
    ADD CONSTRAINT historyactions_pkey PRIMARY KEY (id);


--
-- TOC entry 3396 (class 2606 OID 27658)
-- Name: organizations organizations_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_name_key UNIQUE (name);


--
-- TOC entry 3398 (class 2606 OID 27656)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 3346 (class 2606 OID 25674)
-- Name: otdels otdels_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.otdels
    ADD CONSTRAINT otdels_name_key UNIQUE (name);


--
-- TOC entry 3348 (class 2606 OID 25672)
-- Name: otdels otdels_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.otdels
    ADD CONSTRAINT otdels_pkey PRIMARY KEY (id);


--
-- TOC entry 3350 (class 2606 OID 25683)
-- Name: positions positions_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_name_key UNIQUE (name);


--
-- TOC entry 3352 (class 2606 OID 25681)
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- TOC entry 3422 (class 2606 OID 36737)
-- Name: projectcheckpoints projectcheckpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectcheckpoints
    ADD CONSTRAINT projectcheckpoints_pkey PRIMARY KEY (id);


--
-- TOC entry 3404 (class 2606 OID 36081)
-- Name: projectfiles projectfiles_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectfiles
    ADD CONSTRAINT projectfiles_pkey PRIMARY KEY (id);


--
-- TOC entry 3406 (class 2606 OID 36260)
-- Name: projecthistorys projecthistorys_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projecthistorys
    ADD CONSTRAINT projecthistorys_pkey PRIMARY KEY (id);


--
-- TOC entry 3416 (class 2606 OID 36452)
-- Name: projectroles projectroles_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectroles
    ADD CONSTRAINT projectroles_name_key UNIQUE (name);


--
-- TOC entry 3418 (class 2606 OID 36450)
-- Name: projectroles projectroles_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectroles
    ADD CONSTRAINT projectroles_pkey PRIMARY KEY (id);


--
-- TOC entry 3376 (class 2606 OID 25844)
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- TOC entry 3354 (class 2606 OID 25692)
-- Name: projectstatuses projectstatuses_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectstatuses
    ADD CONSTRAINT projectstatuses_name_key UNIQUE (name);


--
-- TOC entry 3356 (class 2606 OID 25690)
-- Name: projectstatuses projectstatuses_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectstatuses
    ADD CONSTRAINT projectstatuses_pkey PRIMARY KEY (id);


--
-- TOC entry 3388 (class 2606 OID 26656)
-- Name: projecttypes projecttypes_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projecttypes
    ADD CONSTRAINT projecttypes_name_key UNIQUE (name);


--
-- TOC entry 3390 (class 2606 OID 26654)
-- Name: projecttypes projecttypes_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projecttypes
    ADD CONSTRAINT projecttypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3380 (class 2606 OID 26078)
-- Name: projectusers projectusers_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectusers
    ADD CONSTRAINT projectusers_pkey PRIMARY KEY (id);


--
-- TOC entry 3358 (class 2606 OID 25701)
-- Name: ranks ranks_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.ranks
    ADD CONSTRAINT ranks_name_key UNIQUE (name);


--
-- TOC entry 3360 (class 2606 OID 25699)
-- Name: ranks ranks_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.ranks
    ADD CONSTRAINT ranks_pkey PRIMARY KEY (id);


--
-- TOC entry 3384 (class 2606 OID 26097)
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 3362 (class 2606 OID 25710)
-- Name: taskstages taskstages_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.taskstages
    ADD CONSTRAINT taskstages_name_key UNIQUE (name);


--
-- TOC entry 3364 (class 2606 OID 25708)
-- Name: taskstages taskstages_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.taskstages
    ADD CONSTRAINT taskstages_pkey PRIMARY KEY (id);


--
-- TOC entry 3366 (class 2606 OID 25719)
-- Name: taskstatuses taskstatuses_name_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.taskstatuses
    ADD CONSTRAINT taskstatuses_name_key UNIQUE (name);


--
-- TOC entry 3368 (class 2606 OID 25717)
-- Name: taskstatuses taskstatuses_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.taskstatuses
    ADD CONSTRAINT taskstatuses_pkey PRIMARY KEY (id);


--
-- TOC entry 3410 (class 2606 OID 36348)
-- Name: chats uc_chats_level_parent; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT uc_chats_level_parent UNIQUE (level, parent);


--
-- TOC entry 3382 (class 2606 OID 36473)
-- Name: projectusers uc_projectusers_project_user_role; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectusers
    ADD CONSTRAINT uc_projectusers_project_user_role UNIQUE (project, "user", role);


--
-- TOC entry 3420 (class 2606 OID 36626)
-- Name: userratings userratings_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.userratings
    ADD CONSTRAINT userratings_pkey PRIMARY KEY (id);


--
-- TOC entry 3370 (class 2606 OID 26647)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3372 (class 2606 OID 25756)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3374 (class 2606 OID 27753)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3400 (class 2606 OID 35959)
-- Name: works works_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT works_pkey PRIMARY KEY (id);


--
-- TOC entry 3440 (class 2606 OID 26142)
-- Name: assignments fk_assignments_assignmentstatuses_id_status; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT fk_assignments_assignmentstatuses_id_status FOREIGN KEY (status) REFERENCES public.assignmentstatuses(id);


--
-- TOC entry 3442 (class 2606 OID 36068)
-- Name: assignments fk_assignments_users_id_author; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT fk_assignments_users_id_author FOREIGN KEY (author) REFERENCES public.users(id);


--
-- TOC entry 3441 (class 2606 OID 36039)
-- Name: assignments fk_assignments_users_id_responsible; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT fk_assignments_users_id_responsible FOREIGN KEY (responsible) REFERENCES public.users(id);


--
-- TOC entry 3443 (class 2606 OID 36424)
-- Name: assignments fk_assignments_works_id_parent; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT fk_assignments_works_id_parent FOREIGN KEY (parent) REFERENCES public.works(id) ON DELETE CASCADE;


--
-- TOC entry 3459 (class 2606 OID 36778)
-- Name: chatmessages fk_chatmessages_chats_id_chat; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chatmessages
    ADD CONSTRAINT fk_chatmessages_chats_id_chat FOREIGN KEY (chat) REFERENCES public.chats(id) ON DELETE CASCADE;


--
-- TOC entry 3460 (class 2606 OID 36342)
-- Name: chatmessages fk_chatmessages_users_id_sender; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chatmessages
    ADD CONSTRAINT fk_chatmessages_users_id_sender FOREIGN KEY (sender) REFERENCES public.users(id);


--
-- TOC entry 3456 (class 2606 OID 36418)
-- Name: chats fk_chats_users_id_admin; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT fk_chats_users_id_admin FOREIGN KEY (admin) REFERENCES public.users(id);


--
-- TOC entry 3457 (class 2606 OID 36318)
-- Name: chatusers fk_chatusers_chats_chat_id; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chatusers
    ADD CONSTRAINT fk_chatusers_chats_chat_id FOREIGN KEY (chat) REFERENCES public.chats(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3458 (class 2606 OID 36323)
-- Name: chatusers fk_chatusers_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.chatusers
    ADD CONSTRAINT fk_chatusers_users_user_id FOREIGN KEY ("user") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3431 (class 2606 OID 25930)
-- Name: documentations fk_documentations_doctypes_id_doctype; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.documentations
    ADD CONSTRAINT fk_documentations_doctypes_id_doctype FOREIGN KEY (doctype) REFERENCES public.doctypes(id);


--
-- TOC entry 3432 (class 2606 OID 25935)
-- Name: documentations fk_documentations_projects_id_project; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.documentations
    ADD CONSTRAINT fk_documentations_projects_id_project FOREIGN KEY (project) REFERENCES public.projects(id);


--
-- TOC entry 3433 (class 2606 OID 36063)
-- Name: documentations fk_documentations_users_id_approver; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.documentations
    ADD CONSTRAINT fk_documentations_users_id_approver FOREIGN KEY (approver) REFERENCES public.users(id);


--
-- TOC entry 3448 (class 2606 OID 36568)
-- Name: docusers fk_docusers_documentations_id_doc; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.docusers
    ADD CONSTRAINT fk_docusers_documentations_id_doc FOREIGN KEY (doc) REFERENCES public.documentations(id) ON DELETE CASCADE;


--
-- TOC entry 3447 (class 2606 OID 36563)
-- Name: docusers fk_docusers_users_id_user; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.docusers
    ADD CONSTRAINT fk_docusers_users_id_user FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- TOC entry 3467 (class 2606 OID 36738)
-- Name: projectcheckpoints fk_projectcheckpoints_projects_id_project; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectcheckpoints
    ADD CONSTRAINT fk_projectcheckpoints_projects_id_project FOREIGN KEY (project) REFERENCES public.projects(id);


--
-- TOC entry 3449 (class 2606 OID 36082)
-- Name: projectfiles fk_projectfiles_assignments_id_assignment; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectfiles
    ADD CONSTRAINT fk_projectfiles_assignments_id_assignment FOREIGN KEY (assignment) REFERENCES public.assignments(id);


--
-- TOC entry 3450 (class 2606 OID 36087)
-- Name: projectfiles fk_projectfiles_projects_id_project; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectfiles
    ADD CONSTRAINT fk_projectfiles_projects_id_project FOREIGN KEY (project) REFERENCES public.projects(id);


--
-- TOC entry 3452 (class 2606 OID 36097)
-- Name: projectfiles fk_projectfiles_tasks_id_task; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectfiles
    ADD CONSTRAINT fk_projectfiles_tasks_id_task FOREIGN KEY (task) REFERENCES public.tasks(id);


--
-- TOC entry 3451 (class 2606 OID 36092)
-- Name: projectfiles fk_projectfiles_users_id_sender; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectfiles
    ADD CONSTRAINT fk_projectfiles_users_id_sender FOREIGN KEY (sender) REFERENCES public.users(id);


--
-- TOC entry 3453 (class 2606 OID 36102)
-- Name: projectfiles fk_projectfiles_works_id_work; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectfiles
    ADD CONSTRAINT fk_projectfiles_works_id_work FOREIGN KEY (work) REFERENCES public.works(id);


--
-- TOC entry 3454 (class 2606 OID 36261)
-- Name: projecthistorys fk_projecthistorys_historyactions_id_action; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projecthistorys
    ADD CONSTRAINT fk_projecthistorys_historyactions_id_action FOREIGN KEY (action) REFERENCES public.historyactions(id);


--
-- TOC entry 3455 (class 2606 OID 36266)
-- Name: projecthistorys fk_projecthistorys_users_id_author; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projecthistorys
    ADD CONSTRAINT fk_projecthistorys_users_id_author FOREIGN KEY (author) REFERENCES public.users(id);


--
-- TOC entry 3429 (class 2606 OID 25855)
-- Name: projects fk_projects_projectstatuses_id_status; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT fk_projects_projectstatuses_id_status FOREIGN KEY (status) REFERENCES public.projectstatuses(id);


--
-- TOC entry 3430 (class 2606 OID 26689)
-- Name: projects fk_projects_projecttypes_id_ptype; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT fk_projects_projecttypes_id_ptype FOREIGN KEY (ptype) REFERENCES public.projecttypes(id);


--
-- TOC entry 3428 (class 2606 OID 25845)
-- Name: projects fk_projects_users_id_author; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT fk_projects_users_id_author FOREIGN KEY (author) REFERENCES public.users(id);


--
-- TOC entry 3434 (class 2606 OID 36455)
-- Name: projectusers fk_projectusers_projectroles_id_role; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectusers
    ADD CONSTRAINT fk_projectusers_projectroles_id_role FOREIGN KEY (role) REFERENCES public.projectroles(id);


--
-- TOC entry 3436 (class 2606 OID 36465)
-- Name: projectusers fk_projectusers_projects_id_project; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectusers
    ADD CONSTRAINT fk_projectusers_projects_id_project FOREIGN KEY (project) REFERENCES public.projects(id);


--
-- TOC entry 3435 (class 2606 OID 36460)
-- Name: projectusers fk_projectusers_users_id_user; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.projectusers
    ADD CONSTRAINT fk_projectusers_users_id_user FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- TOC entry 3437 (class 2606 OID 36783)
-- Name: tasks fk_tasks_projects_id_parent; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_tasks_projects_id_parent FOREIGN KEY (parent) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 3439 (class 2606 OID 26113)
-- Name: tasks fk_tasks_taskstatuses_id_status; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_tasks_taskstatuses_id_status FOREIGN KEY (status) REFERENCES public.taskstatuses(id);


--
-- TOC entry 3438 (class 2606 OID 26103)
-- Name: tasks fk_tasks_users_id_responsible; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_tasks_users_id_responsible FOREIGN KEY (responsible) REFERENCES public.users(id);


--
-- TOC entry 3461 (class 2606 OID 36627)
-- Name: userratings fk_userratings_assignments_id_assignment; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.userratings
    ADD CONSTRAINT fk_userratings_assignments_id_assignment FOREIGN KEY (assignment) REFERENCES public.assignments(id);


--
-- TOC entry 3462 (class 2606 OID 36637)
-- Name: userratings fk_userratings_projects_id_project; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.userratings
    ADD CONSTRAINT fk_userratings_projects_id_project FOREIGN KEY (project) REFERENCES public.projects(id);


--
-- TOC entry 3463 (class 2606 OID 36642)
-- Name: userratings fk_userratings_tasks_id_task; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.userratings
    ADD CONSTRAINT fk_userratings_tasks_id_task FOREIGN KEY (task) REFERENCES public.tasks(id);


--
-- TOC entry 3464 (class 2606 OID 36632)
-- Name: userratings fk_userratings_users_id_author; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.userratings
    ADD CONSTRAINT fk_userratings_users_id_author FOREIGN KEY (author) REFERENCES public.users(id);


--
-- TOC entry 3465 (class 2606 OID 36647)
-- Name: userratings fk_userratings_users_id_user; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.userratings
    ADD CONSTRAINT fk_userratings_users_id_user FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- TOC entry 3466 (class 2606 OID 36652)
-- Name: userratings fk_userratings_works_id_work; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.userratings
    ADD CONSTRAINT fk_userratings_works_id_work FOREIGN KEY (work) REFERENCES public.works(id);


--
-- TOC entry 3426 (class 2606 OID 26823)
-- Name: users fk_users_departments_id_department; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_departments_id_department FOREIGN KEY (department) REFERENCES public.departments(id);


--
-- TOC entry 3427 (class 2606 OID 27659)
-- Name: users fk_users_organizations_id_organization; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_organizations_id_organization FOREIGN KEY (organization) REFERENCES public.organizations(id);


--
-- TOC entry 3423 (class 2606 OID 25759)
-- Name: users fk_users_otdels_id_otdel; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_otdels_id_otdel FOREIGN KEY (otdel) REFERENCES public.otdels(id);


--
-- TOC entry 3424 (class 2606 OID 25764)
-- Name: users fk_users_positions_id_position; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_positions_id_position FOREIGN KEY ("position") REFERENCES public.positions(id);


--
-- TOC entry 3425 (class 2606 OID 25769)
-- Name: users fk_users_ranks_id_rank; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_ranks_id_rank FOREIGN KEY (rank) REFERENCES public.ranks(id);


--
-- TOC entry 3444 (class 2606 OID 36788)
-- Name: works fk_works_tasks_id_parent; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT fk_works_tasks_id_parent FOREIGN KEY (parent) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 3445 (class 2606 OID 35965)
-- Name: works fk_works_taskstatuses_id_status; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT fk_works_taskstatuses_id_status FOREIGN KEY (status) REFERENCES public.taskstatuses(id);


--
-- TOC entry 3446 (class 2606 OID 36032)
-- Name: works fk_works_users_id_responsible; Type: FK CONSTRAINT; Schema: public; Owner: pgsup
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT fk_works_users_id_responsible FOREIGN KEY (responsible) REFERENCES public.users(id);


-- Completed on 2023-09-11 08:10:33

--
-- PostgreSQL database dump complete
--

