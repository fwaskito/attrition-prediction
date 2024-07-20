--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Ubuntu 16.3-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.3 (Ubuntu 16.3-1.pgdg22.04+1)

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
-- Name: act_employee_bd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.act_employee_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO employee_history
		SELECT 	e.id, 'delete', current_date, 'Yes',
				e.age, e.department_id, e.dist_from_home, e.edu,
				e.edu_field, e.env_sat, e.job_sat, e.marital_sts,
				e.num_comp_worked, e.salary, e.wlb, e.years_at_comp
		FROM employee AS e
        WHERE e.id = old.id;

	RETURN old;
END;
$$;


ALTER FUNCTION public.act_employee_bd() OWNER TO postgres;

--
-- Name: act_employee_bu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.act_employee_bu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM employee_history
	WHERE employee_id = old.id
		AND mod_action='update'
		AND EXISTS (SELECT r_count
					FROM (SELECT count(*) r_count
						  FROM employee_history
						  WHERE employee_id = old.id
						  	  AND mod_action='update')
					AS t);

    INSERT INTO employee_history
		SELECT 	e.id, 'update', current_date, 'No',
				e.age, e.department_id, e.dist_from_home, e.edu,
				e.edu_field, e.env_sat, e.job_sat, e.marital_sts,
				e.num_comp_worked, e.salary, e.wlb, e.years_at_comp
		FROM employee AS e
        WHERE e.id = old.id;

	RETURN new;
END;
$$;


ALTER FUNCTION public.act_employee_bu() OWNER TO postgres;

--
-- Name: add_employee(character varying, character varying, integer, character varying, integer, integer, character varying, integer, integer, character varying, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_employee(p_id character varying, p_attrition character varying, p_age integer, p_department_id character varying, p_dist_from_home integer, p_edu integer, p_edu_field character varying, p_env_sat integer, p_job_sat integer, p_marital_sts character varying, p_num_comp_worked integer, p_salary integer, p_wlb integer, p_years_at_comp integer) RETURNS void
    LANGUAGE sql
    AS $$
	INSERT INTO employee
	VALUES (p_id, p_attrition,
			p_age, p_department_id,
			p_dist_from_home, p_edu,
			p_edu_field, p_env_sat,
			p_job_sat, p_marital_sts,
			p_num_comp_worked, p_salary,
			p_wlb, p_years_at_comp);
$$;


ALTER FUNCTION public.add_employee(p_id character varying, p_attrition character varying, p_age integer, p_department_id character varying, p_dist_from_home integer, p_edu integer, p_edu_field character varying, p_env_sat integer, p_job_sat integer, p_marital_sts character varying, p_num_comp_worked integer, p_salary integer, p_wlb integer, p_years_at_comp integer) OWNER TO postgres;

--
-- Name: delete_employee(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_employee(p_id character varying) RETURNS void
    LANGUAGE sql
    AS $$
	DELETE FROM employee
	WHERE id = p_id;
$$;


ALTER FUNCTION public.delete_employee(p_id character varying) OWNER TO postgres;

--
-- Name: get_employees(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_employees() RETURNS TABLE(id character varying, attrition character varying, age integer, department_name character varying, dist_from_home integer, edu integer, edu_field character varying, env_sat integer, job_sat integer, marital_sts character varying, num_comp_worked integer, salary integer, wlb integer, years_at_comp integer)
    LANGUAGE sql
    AS $$
	SELECT 	t1.id, attrition, age, name AS department_name,
			dist_from_home, edu, edu_field, env_sat, job_sat,
        	marital_sts, num_comp_worked, salary, wlb, years_at_comp
	FROM employee t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	ORDER BY t1.id;
$$;


ALTER FUNCTION public.get_employees() OWNER TO postgres;

--
-- Name: get_employees_history(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_employees_history() RETURNS TABLE(id character varying, attrition character varying, age integer, department_name character varying, dist_from_home integer, edu integer, edu_field character varying, env_sat integer, job_sat integer, marital_sts character varying, num_comp_worked integer, salary integer, wlb integer, years_at_comp integer, mod_action character varying, mod_date date)
    LANGUAGE sql
    AS $$
	SELECT 	employee_id, attrition, age, name AS department_name,
			dist_from_home, edu, edu_field, env_sat, job_sat,
        	marital_sts, num_comp_worked, salary, wlb, years_at_comp,
        	mod_action, mod_date
	FROM employee_history t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	ORDER BY employee_id;
$$;


ALTER FUNCTION public.get_employees_history() OWNER TO postgres;

--
-- Name: get_test_data(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_test_data() RETURNS TABLE(id character varying, attrition character varying, age integer, department_name character varying, dist_from_home integer, edu integer, edu_field character varying, env_sat integer, job_sat integer, marital_sts character varying, num_comp_worked integer, salary integer, wlb integer, years_at_comp integer)
    LANGUAGE sql
    AS $$
	SELECT 	t1.id, attrition, age, name AS department_name,
			dist_from_home, edu, edu_field, env_sat, job_sat,
        	marital_sts, num_comp_worked, salary, wlb, years_at_comp
	FROM employee t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	WHERE attrition IS NULL
	ORDER BY t1.id;
$$;


ALTER FUNCTION public.get_test_data() OWNER TO postgres;

--
-- Name: get_train_data(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_train_data() RETURNS TABLE(id character varying, attrition character varying, age integer, department_name character varying, dist_from_home integer, edu integer, edu_field character varying, env_sat integer, job_sat integer, marital_sts character varying, num_comp_worked integer, salary integer, wlb integer, years_at_comp integer)
    LANGUAGE sql
    AS $$
	SELECT 	employee_id, attrition, age, name AS department_name,
			dist_from_home, edu, edu_field, env_sat, job_sat,
        	marital_sts, num_comp_worked, salary, wlb, years_at_comp
	FROM employee_history t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	WHERE t1.employee_id = employee_id
		AND t1.mod_action=(CASE WHEN (SELECT count(*)
									  FROM employee_history
									  WHERE employee_id = t1.employee_id
										  AND mod_action='delete'
									 ) = 1
									 THEN 'delete'
								ELSE 'update'
						   END)
	ORDER BY employee_id;
$$;


ALTER FUNCTION public.get_train_data() OWNER TO postgres;

--
-- Name: get_train_data_distribution(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_train_data_distribution() RETURNS TABLE(total_data integer, class_yes integer, class_no integer)
    LANGUAGE sql
    AS $$
	SELECT count(*) total_data,
		   count(CASE WHEN attrition='Yes' THEN 1 END) class_yes,
		   count(CASE WHEN attrition='No' THEN 1 END) class_no
	FROM employee_history;
$$;


ALTER FUNCTION public.get_train_data_distribution() OWNER TO postgres;

--
-- Name: reset_test_data(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reset_test_data() RETURNS void
    LANGUAGE sql
    AS $$
	ALTER TABLE employee
	DISABLE TRIGGER employee_bu;

	UPDATE employee
	SET attrition = 'No'
	WHERE attrition IS NULL;

	ALTER TABLE employee
	ENABLE TRIGGER employee_bu;
$$;


ALTER FUNCTION public.reset_test_data() OWNER TO postgres;

--
-- Name: set_employee_attrition(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_employee_attrition(p_id character varying, p_attrition character varying) RETURNS void
    LANGUAGE sql
    AS $$
	UPDATE employee
	SET attrition = p_attrition
	WHERE id = p_id;
$$;


ALTER FUNCTION public.set_employee_attrition(p_id character varying, p_attrition character varying) OWNER TO postgres;

--
-- Name: update_employee(integer, character varying, integer, integer, character varying, integer, integer, character varying, integer, integer, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_employee(p_age integer, p_department_id character varying, p_dist_from_home integer, p_edu integer, p_edu_field character varying, p_env_sat integer, p_job_sat integer, p_marital_sts character varying, p_num_comp_worked integer, p_salary integer, p_wlb integer, p_years_at_comp integer, p_id character varying) RETURNS void
    LANGUAGE sql
    AS $$
	UPDATE employee
    SET attrition = NULL
    WHERE id = p_id;

	UPDATE employee
	SET age = p_age, department_id = p_department_id,
		dist_from_home = p_dist_from_home, edu = p_edu,
		edu_field = p_edu_field, marital_sts = p_marital_sts,
		num_comp_worked = p_num_comp_worked, salary = p_salary,
		wlb = p_wlb, years_at_comp = p_years_at_comp
	WHERE id = p_id;
$$;


ALTER FUNCTION public.update_employee(p_age integer, p_department_id character varying, p_dist_from_home integer, p_edu integer, p_edu_field character varying, p_env_sat integer, p_job_sat integer, p_marital_sts character varying, p_num_comp_worked integer, p_salary integer, p_wlb integer, p_years_at_comp integer, p_id character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    id character varying(10) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    id character varying(10) NOT NULL,
    attrition character varying(5),
    age integer NOT NULL,
    department_id character varying(10) NOT NULL,
    dist_from_home integer NOT NULL,
    edu integer NOT NULL,
    edu_field character varying(50) NOT NULL,
    env_sat integer NOT NULL,
    job_sat integer NOT NULL,
    marital_sts character varying(10) NOT NULL,
    num_comp_worked integer NOT NULL,
    salary integer NOT NULL,
    wlb integer NOT NULL,
    years_at_comp integer NOT NULL
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: employee_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_history (
    employee_id character varying(10) NOT NULL,
    mod_action character varying(8) DEFAULT 'update'::character varying NOT NULL,
    mod_date date NOT NULL,
    attrition character varying(5) NOT NULL,
    age integer NOT NULL,
    department_id character varying(10) NOT NULL,
    dist_from_home integer NOT NULL,
    edu integer NOT NULL,
    edu_field character varying(50) NOT NULL,
    env_sat integer NOT NULL,
    job_sat integer NOT NULL,
    marital_sts character varying(10) NOT NULL,
    num_comp_worked integer NOT NULL,
    salary integer NOT NULL,
    wlb integer NOT NULL,
    years_at_comp integer NOT NULL
);


ALTER TABLE public.employee_history OWNER TO postgres;

--
-- Name: sys_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_user (
    id character varying(10) NOT NULL,
    name character varying(50) NOT NULL,
    type character varying(10) NOT NULL,
    username character varying(15) NOT NULL,
    password character varying(100) NOT NULL
);


ALTER TABLE public.sys_user OWNER TO postgres;

--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.department (id, name) FROM stdin;
DP1	Research & Development
DP2	Sales
DP3	Human Resources
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (id, attrition, age, department_id, dist_from_home, edu, edu_field, env_sat, job_sat, marital_sts, num_comp_worked, salary, wlb, years_at_comp) FROM stdin;
EP0002	\N	49	DP1	8	1	Life Sciences	3	2	Married	1	5130	2	10
EP0004	No	33	DP1	3	4	Life Sciences	4	3	Married	1	2909	3	8
EP0005	No	27	DP1	2	1	Medical	1	2	Married	9	3468	3	2
EP0006	No	32	DP1	2	2	Life Sciences	4	4	Single	0	3068	2	7
EP0007	No	59	DP1	3	3	Medical	3	1	Married	4	2670	2	1
EP0008	No	30	DP1	24	1	Life Sciences	4	3	Divorced	1	2693	3	1
EP0009	No	38	DP1	23	3	Life Sciences	4	3	Single	0	9526	3	9
EP0010	No	36	DP1	27	3	Medical	3	3	Married	6	5237	2	7
EP0011	No	35	DP1	16	3	Medical	1	2	Married	0	2426	3	5
EP0012	No	29	DP1	15	2	Life Sciences	4	3	Single	0	4193	3	9
EP0013	No	31	DP1	26	1	Life Sciences	1	3	Divorced	1	2911	2	5
EP0014	No	34	DP1	19	2	Medical	2	4	Divorced	0	2661	3	2
EP0016	No	29	DP1	21	4	Life Sciences	2	1	Divorced	1	9980	3	10
EP0017	No	32	DP1	5	2	Life Sciences	1	2	Divorced	0	3298	2	6
EP0018	No	22	DP1	16	2	Medical	4	4	Divorced	1	2935	2	1
EP0019	No	53	DP2	2	4	Life Sciences	1	4	Married	2	15427	3	25
EP0020	No	38	DP1	2	3	Life Sciences	4	4	Single	5	3944	3	3
EP0021	No	24	DP1	11	2	Other	1	3	Divorced	0	4011	2	4
EP0023	No	34	DP1	7	4	Life Sciences	1	2	Single	0	11994	3	12
EP0024	No	21	DP1	15	2	Life Sciences	3	4	Single	1	1232	3	0
EP0026	No	53	DP1	5	3	Other	3	3	Divorced	4	19094	2	14
EP0028	No	42	DP2	8	4	Marketing	3	2	Married	0	6825	3	9
EP0029	No	44	DP1	7	4	Medical	1	4	Married	3	10248	3	22
EP0030	No	46	DP2	2	4	Marketing	2	1	Single	3	18947	2	2
EP0031	No	33	DP1	2	3	Medical	3	4	Single	4	2496	3	1
EP0032	No	44	DP1	10	4	Other	4	4	Married	2	6465	4	4
EP0033	No	30	DP1	9	2	Medical	4	3	Single	1	2206	3	10
EP0036	No	43	DP1	2	2	Medical	4	3	Divorced	1	2645	2	5
EP0038	No	35	DP2	2	3	Marketing	4	4	Married	1	2014	3	2
EP0039	No	36	DP1	5	4	Life Sciences	2	1	Married	9	3419	4	1
EP0040	No	33	DP2	1	3	Life Sciences	3	1	Married	2	5376	3	5
EP0041	No	35	DP1	4	2	Other	3	4	Divorced	1	1951	3	1
EP0042	No	27	DP1	2	4	Life Sciences	4	1	Divorced	1	2341	3	1
EP0044	No	27	DP2	8	3	Life Sciences	4	3	Single	1	8726	3	9
EP0045	No	30	DP1	1	2	Medical	3	4	Single	1	4011	3	12
EP0047	No	34	DP2	23	4	Marketing	2	3	Single	0	4568	3	9
EP0048	No	37	DP1	19	2	Life Sciences	2	2	Married	4	3022	3	1
EP0049	No	46	DP2	5	4	Marketing	1	4	Single	4	5772	3	9
EP0050	No	35	DP1	8	1	Life Sciences	4	4	Married	1	2269	3	1
EP0053	No	44	DP2	1	5	Marketing	2	1	Divorced	5	5454	2	4
EP0054	No	35	DP1	11	2	Medical	3	1	Married	2	9884	3	4
EP0055	No	26	DP2	23	3	Marketing	3	4	Married	7	4157	2	2
EP0056	No	33	DP1	1	2	Life Sciences	1	4	Single	1	13458	3	15
EP0057	No	35	DP2	18	5	Life Sciences	2	1	Married	1	9069	2	9
EP0058	No	35	DP1	23	4	Medical	3	1	Married	3	4014	3	2
EP0059	No	31	DP1	7	4	Life Sciences	4	4	Divorced	3	5915	2	7
EP0060	No	37	DP1	1	4	Life Sciences	1	3	Divorced	1	5993	4	7
EP0061	No	32	DP1	1	3	Medical	1	4	Married	1	6162	3	9
EP0062	No	38	DP1	29	5	Life Sciences	4	4	Single	1	2406	3	10
EP0063	No	50	DP1	7	2	Medical	2	3	Divorced	5	18740	2	27
EP0064	No	59	DP2	25	3	Life Sciences	1	1	Single	7	7637	2	21
EP0065	No	36	DP1	8	3	Technical Degree	3	3	Divorced	1	10096	3	17
EP0066	No	55	DP1	8	3	Medical	4	3	Divorced	2	14756	3	5
EP0067	No	36	DP1	11	3	Life Sciences	2	2	Single	1	6499	3	6
EP0068	No	45	DP1	7	3	Life Sciences	2	1	Divorced	2	9724	3	1
EP0069	No	35	DP1	1	3	Medical	2	1	Married	4	2194	2	3
EP0071	No	59	DP2	1	1	Life Sciences	1	3	Single	7	5473	2	4
EP0072	No	29	DP1	2	3	Life Sciences	3	2	Married	0	2703	3	5
EP0073	No	31	DP1	1	4	Medical	3	2	Single	1	2501	3	1
EP0074	No	32	DP1	1	3	Life Sciences	2	2	Married	1	6220	3	10
EP0075	No	36	DP1	6	3	Life Sciences	2	4	Married	3	3038	3	1
EP0076	No	31	DP1	8	4	Life Sciences	3	4	Single	1	4424	3	11
EP0077	No	35	DP2	1	4	Marketing	3	1	Single	0	4312	3	15
EP0078	No	45	DP1	6	4	Other	4	1	Married	4	13245	4	0
EP0079	No	37	DP1	7	4	Medical	1	3	Single	4	13664	4	5
EP0080	No	46	DP3	5	2	Medical	2	2	Divorced	8	5021	3	4
EP0081	No	30	DP1	1	1	Life Sciences	4	4	Married	1	5126	2	10
EP0082	No	35	DP1	1	3	Medical	2	3	Single	1	2859	3	6
EP0083	No	55	DP2	1	2	Life Sciences	1	4	Married	3	10239	3	1
EP0084	No	38	DP1	6	3	Medical	2	4	Divorced	7	5329	3	13
EP0085	No	34	DP1	1	2	Medical	1	2	Married	1	4325	3	5
EP0086	No	56	DP1	7	3	Life Sciences	4	4	Single	4	7260	2	6
EP0087	No	23	DP2	2	1	Technical Degree	3	1	Divorced	3	2322	3	0
EP0088	No	51	DP1	9	4	Life Sciences	4	4	Married	3	2075	3	4
EP0089	No	30	DP1	2	3	Life Sciences	3	4	Married	1	4152	3	11
EP0091	No	40	DP1	1	4	Life Sciences	3	2	Married	1	13503	2	22
EP0092	No	51	DP2	21	4	Marketing	3	4	Single	0	5441	1	10
EP0093	No	30	DP2	4	2	Medical	3	2	Divorced	1	5209	2	11
EP0094	No	46	DP1	1	3	Medical	3	1	Married	2	10673	2	10
EP0095	No	32	DP2	6	4	Medical	2	3	Single	1	5010	3	11
EP0096	No	54	DP1	2	4	Technical Degree	1	3	Married	9	13549	1	4
EP0097	No	24	DP2	3	2	Other	1	3	Married	0	4999	2	3
EP0098	No	28	DP2	4	3	Medical	2	3	Married	1	4221	4	5
EP0099	No	58	DP2	10	4	Medical	4	3	Single	0	13872	2	37
EP0100	No	44	DP1	23	3	Medical	2	2	Married	4	2042	4	3
EP0102	No	32	DP1	1	1	Life Sciences	4	1	Single	1	2956	3	1
EP0104	No	34	DP1	6	4	Other	1	3	Single	1	4809	3	16
EP0105	No	37	DP1	2	2	Life Sciences	3	4	Divorced	5	5163	4	1
EP0106	No	59	DP3	2	4	Human Resources	3	4	Married	9	18844	3	3
EP0107	No	50	DP1	1	3	Life Sciences	1	2	Married	3	18172	2	8
EP0109	No	25	DP1	7	1	Medical	4	4	Married	1	2889	3	2
EP0110	No	22	DP1	15	3	Medical	2	4	Single	1	2871	3	0
EP0111	No	51	DP1	1	4	Medical	1	1	Single	3	7484	2	13
EP0113	No	54	DP3	26	3	Human Resources	4	4	Single	2	17328	3	5
EP0114	No	24	DP1	18	1	Life Sciences	2	3	Married	0	2774	3	5
EP0115	No	34	DP1	6	4	Life Sciences	3	2	Divorced	6	4505	3	1
EP0116	No	37	DP2	3	3	Life Sciences	3	4	Single	2	7428	3	5
EP0117	No	34	DP1	5	3	Medical	3	1	Single	2	11631	3	11
EP0118	No	36	DP2	11	2	Technical Degree	2	4	Married	0	9738	3	9
EP0119	No	36	DP1	3	2	Life Sciences	1	4	Divorced	5	2835	3	1
EP0120	No	43	DP2	26	2	Life Sciences	3	4	Married	1	16959	4	25
EP0121	No	30	DP1	23	3	Life Sciences	1	3	Divorced	1	2613	2	10
EP0122	No	33	DP2	22	2	Marketing	3	2	Married	0	6146	4	7
EP0124	No	51	DP1	6	3	Life Sciences	1	3	Single	7	19537	3	20
EP0126	No	26	DP1	6	3	Other	3	2	Married	1	2368	2	5
EP0129	No	22	DP1	2	1	Technical Degree	3	4	Married	0	2523	3	2
EP0130	No	49	DP1	20	4	Medical	3	1	Married	1	6567	2	15
EP0131	No	43	DP1	28	3	Medical	2	3	Single	4	4739	3	3
EP0132	No	50	DP2	12	3	Marketing	3	4	Single	4	9208	3	2
EP0134	No	41	DP2	9	1	Life Sciences	3	3	Divorced	3	8189	3	9
EP0135	No	26	DP3	25	1	Life Sciences	3	3	Married	1	2942	3	8
EP0136	No	36	DP1	6	2	Medical	2	2	Divorced	6	4941	3	3
EP0138	No	39	DP2	4	4	Life Sciences	4	3	Married	4	5902	4	15
EP0139	No	25	DP2	28	3	Life Sciences	1	3	Married	2	8639	3	2
EP0140	No	30	DP3	9	3	Human Resources	3	4	Married	0	6347	1	11
EP0142	No	45	DP1	29	3	Medical	3	4	Single	5	3452	2	6
EP0143	No	38	DP1	3	5	Technical Degree	4	3	Single	3	4317	3	3
EP0144	No	30	DP1	18	3	Life Sciences	1	3	Single	1	2632	2	5
EP0145	No	32	DP2	9	2	Medical	4	4	Divorced	0	4668	4	8
EP0146	No	30	DP1	5	3	Technical Degree	4	1	Divorced	5	3204	3	3
EP0147	No	30	DP1	2	1	Medical	2	4	Single	0	2720	3	5
EP0148	No	41	DP1	10	3	Life Sciences	4	1	Divorced	4	17181	2	7
EP0149	No	41	DP1	9	4	Life Sciences	3	1	Married	2	2238	3	5
EP0150	No	19	DP1	3	1	Medical	2	2	Single	1	1483	3	1
EP0151	No	40	DP1	26	3	Medical	2	2	Divorced	1	5605	3	20
EP0152	No	35	DP2	1	5	Marketing	3	2	Married	1	7295	3	10
EP0153	No	53	DP2	6	2	Marketing	2	3	Married	2	2306	1	7
EP0154	No	45	DP1	9	3	Life Sciences	2	2	Divorced	8	2348	1	17
EP0155	No	32	DP2	8	3	Marketing	2	4	Single	1	8998	3	9
EP0156	No	29	DP1	1	1	Technical Degree	4	3	Married	1	4319	3	10
EP0157	No	51	DP1	7	4	Medical	2	3	Married	2	6132	3	1
EP0158	No	58	DP1	9	3	Medical	2	2	Married	4	3346	2	1
EP0159	No	40	DP2	4	4	Marketing	3	4	Married	7	10855	2	12
EP0160	No	34	DP2	2	4	Marketing	3	3	Married	6	2231	3	4
EP0161	No	22	DP1	19	1	Medical	3	4	Married	1	2323	3	2
EP0162	No	27	DP1	9	3	Medical	4	2	Divorced	6	2024	1	2
EP0163	No	28	DP1	21	3	Medical	3	4	Married	1	2713	1	5
EP0164	No	57	DP1	24	2	Life Sciences	3	4	Divorced	3	9439	1	5
EP0165	No	27	DP1	3	3	Medical	3	3	Divorced	1	2566	2	1
EP0166	No	50	DP1	11	3	Life Sciences	3	2	Single	3	19926	3	5
EP0167	No	41	DP1	14	3	Life Sciences	1	3	Divorced	4	2451	3	9
EP0168	No	30	DP2	5	3	Life Sciences	2	4	Married	2	9419	3	10
EP0169	No	38	DP2	1	4	Life Sciences	1	4	Single	4	8686	4	8
EP0170	No	32	DP1	6	5	Life Sciences	3	3	Single	3	3038	3	5
EP0171	No	27	DP1	17	3	Technical Degree	3	2	Married	0	3058	2	5
EP0173	No	36	DP1	3	2	Medical	4	2	Single	4	2088	2	8
EP0174	No	30	DP1	9	3	Medical	3	1	Divorced	1	3072	3	12
EP0175	No	45	DP2	4	2	Life Sciences	3	1	Divorced	4	5006	4	5
EP0176	No	56	DP1	8	3	Life Sciences	3	1	Divorced	4	4257	3	2
EP0177	No	33	DP1	2	3	Life Sciences	3	4	Single	0	2500	4	3
EP0179	No	46	DP2	1	2	Marketing	2	1	Divorced	1	10453	3	24
EP0180	No	38	DP1	9	2	Life Sciences	3	4	Single	1	2288	3	2
EP0181	No	31	DP1	12	1	Medical	3	4	Married	8	3929	3	4
EP0182	No	34	DP1	27	2	Medical	4	2	Single	2	2311	3	3
EP0184	No	50	DP1	1	3	Medical	3	3	Married	2	3690	2	3
EP0185	No	53	DP1	13	2	Medical	4	1	Divorced	1	4450	3	4
EP0186	No	33	DP1	14	3	Medical	4	2	Married	1	2756	3	8
EP0187	No	40	DP1	4	1	Medical	4	3	Married	1	19033	3	20
EP0188	No	55	DP1	14	4	Medical	3	2	Single	8	18722	3	24
EP0189	No	34	DP1	2	1	Life Sciences	4	3	Married	1	9547	2	10
EP0190	No	51	DP1	3	3	Medical	4	2	Single	3	13734	3	7
EP0191	No	52	DP1	1	4	Life Sciences	3	3	Married	0	19999	3	33
EP0192	No	27	DP1	9	3	Medical	4	2	Single	1	2279	2	7
EP0194	No	43	DP1	7	3	Medical	4	4	Divorced	4	2089	4	5
EP0195	No	45	DP1	2	2	Medical	1	4	Married	9	16792	3	20
EP0196	No	37	DP1	21	3	Life Sciences	2	1	Married	1	3564	2	8
EP0197	No	35	DP1	2	3	Medical	2	2	Single	5	4425	3	6
EP0198	No	42	DP1	21	2	Medical	3	3	Divorced	2	5265	3	5
EP0199	No	38	DP1	2	4	Life Sciences	4	3	Married	9	6553	3	1
EP0200	No	38	DP1	29	3	Technical Degree	4	4	Married	3	6261	1	7
EP0201	No	27	DP1	1	1	Technical Degree	3	1	Married	5	4298	3	2
EP0202	No	49	DP1	18	4	Life Sciences	4	4	Divorced	1	6804	3	7
EP0203	No	34	DP1	10	4	Medical	4	3	Divorced	1	3815	4	5
EP0204	No	40	DP1	19	2	Medical	3	4	Married	8	2741	4	7
EP0207	No	22	DP1	5	3	Life Sciences	4	2	Divorced	1	2328	2	4
EP0208	No	36	DP1	18	1	Medical	2	4	Single	1	2153	3	8
EP0209	No	40	DP1	9	5	Life Sciences	4	4	Married	9	4876	1	3
EP0210	No	46	DP1	1	4	Medical	4	1	Divorced	7	9396	3	4
EP0212	No	30	DP1	1	1	Life Sciences	3	3	Single	1	8474	3	11
EP0213	No	27	DP2	20	3	Life Sciences	4	3	Single	1	9981	3	7
EP0214	No	51	DP1	8	4	Life Sciences	2	2	Married	5	12490	1	10
EP0216	No	41	DP2	6	3	Life Sciences	4	4	Single	3	13591	3	1
EP0219	No	45	DP2	6	3	Medical	4	4	Single	6	8865	3	19
EP0220	No	54	DP2	3	3	Marketing	4	1	Married	2	5940	3	6
EP0221	No	36	DP1	5	2	Life Sciences	4	2	Single	8	5914	4	13
EP0222	No	33	DP1	4	4	Medical	3	2	Married	6	2622	3	3
EP0223	No	37	DP1	11	3	Other	2	4	Divorced	1	12185	3	10
EP0224	No	38	DP2	3	3	Life Sciences	1	3	Divorced	0	10609	2	16
EP0225	No	31	DP1	1	4	Medical	3	3	Married	0	4345	3	5
EP0226	No	59	DP1	3	3	Life Sciences	3	4	Married	3	2177	3	1
EP0227	No	37	DP2	4	4	Marketing	1	4	Divorced	4	2793	3	9
EP0228	No	29	DP2	1	1	Medical	2	4	Married	1	7918	3	11
EP0229	No	35	DP2	1	3	Marketing	3	3	Single	1	8789	4	10
EP0231	No	52	DP1	2	3	Life Sciences	3	4	Single	7	3212	2	2
EP0232	No	42	DP1	4	2	Technical Degree	3	4	Married	1	19232	3	22
EP0233	No	59	DP3	6	2	Medical	2	3	Married	8	2267	2	2
EP0234	No	50	DP2	1	4	Medical	4	4	Divorced	3	19517	2	7
EP0236	No	43	DP2	16	3	Marketing	4	4	Married	5	16064	3	17
EP0238	No	52	DP2	2	4	Life Sciences	1	3	Single	1	19068	4	33
EP0239	No	32	DP2	4	2	Life Sciences	3	2	Married	2	3931	3	4
EP0241	No	39	DP1	1	4	Medical	3	3	Divorced	7	2232	3	3
EP0242	No	32	DP2	26	4	Marketing	3	4	Married	0	4465	3	3
EP0243	No	41	DP1	19	2	Life Sciences	3	1	Divorced	2	3072	2	1
EP0244	No	40	DP1	24	2	Technical Degree	1	4	Divorced	1	3319	3	9
EP0245	No	45	DP1	1	3	Other	3	4	Married	0	19202	3	24
EP0246	No	31	DP1	3	4	Medical	2	3	Divorced	9	13675	3	2
EP0247	No	33	DP1	5	4	Life Sciences	3	4	Married	1	2911	2	2
EP0248	No	34	DP1	2	4	Life Sciences	4	1	Married	6	5957	3	11
EP0249	No	37	DP1	1	2	Medical	3	1	Married	2	3920	2	3
EP0250	No	45	DP1	7	4	Life Sciences	1	3	Married	4	6434	3	3
EP0252	No	39	DP1	2	4	Technical Degree	3	3	Single	0	10938	3	19
EP0253	No	29	DP1	15	3	Life Sciences	3	4	Single	1	2340	3	6
EP0254	No	42	DP1	17	2	Life Sciences	4	1	Single	3	6545	3	3
EP0255	No	29	DP2	20	2	Marketing	4	4	Divorced	2	6931	3	3
EP0256	No	25	DP1	1	3	Life Sciences	1	3	Married	0	4898	3	4
EP0257	No	42	DP1	2	3	Medical	4	1	Divorced	0	2593	3	9
EP0258	No	40	DP1	2	2	Medical	1	3	Divorced	0	19436	3	21
EP0259	No	51	DP1	1	3	Life Sciences	3	4	Married	1	2723	2	1
EP0261	No	32	DP1	7	3	Life Sciences	2	2	Married	1	2794	1	5
EP0262	No	38	DP2	2	2	Life Sciences	4	4	Married	3	5249	3	8
EP0263	No	32	DP1	2	1	Technical Degree	4	1	Single	4	2176	3	6
EP0264	No	46	DP2	2	3	Technical Degree	3	2	Married	3	16872	2	7
EP0266	No	29	DP2	2	3	Medical	1	2	Married	2	6644	3	0
EP0267	No	31	DP1	23	3	Medical	2	4	Married	0	5582	3	9
EP0268	No	25	DP1	5	2	Life Sciences	2	1	Divorced	1	4000	3	6
EP0269	No	45	DP1	20	2	Medical	3	4	Married	0	13496	3	20
EP0270	No	36	DP1	6	3	Life Sciences	4	4	Married	0	3210	3	15
EP0271	No	55	DP1	1	3	Medical	4	1	Single	0	19045	3	36
EP0273	No	28	DP1	9	3	Medical	4	4	Married	1	2070	2	5
EP0274	No	37	DP2	6	4	Medical	3	4	Married	4	6502	4	5
EP0275	No	21	DP1	3	2	Medical	4	3	Single	1	3230	4	3
EP0276	No	37	DP1	1	4	Medical	1	4	Divorced	2	13603	3	5
EP0277	No	35	DP1	22	3	Life Sciences	2	2	Divorced	7	11996	2	7
EP0278	No	38	DP2	7	2	Medical	1	1	Divorced	1	5605	3	8
EP0279	No	26	DP1	1	3	Life Sciences	3	2	Divorced	1	6397	1	6
EP0280	No	50	DP1	4	1	Life Sciences	1	2	Divorced	3	19144	2	10
EP0281	No	53	DP1	3	4	Medical	3	3	Married	3	17584	2	5
EP0282	No	42	DP2	1	1	Life Sciences	2	3	Married	1	4907	3	20
EP0283	No	29	DP2	2	2	Life Sciences	2	4	Single	1	4554	2	10
EP0284	No	55	DP1	20	2	Technical Degree	2	4	Married	3	5415	3	10
EP0285	No	26	DP1	11	2	Medical	1	1	Married	1	4741	3	5
EP0286	No	37	DP1	1	3	Life Sciences	4	4	Single	1	2115	3	17
EP0288	No	38	DP1	23	4	Life Sciences	4	4	Divorced	9	5745	3	2
EP0290	No	28	DP1	8	2	Life Sciences	4	4	Single	1	3310	3	5
EP0291	No	49	DP1	10	4	Life Sciences	3	1	Single	9	18665	3	3
EP0292	No	36	DP1	3	3	Technical Degree	3	2	Single	4	4485	3	8
EP0293	No	31	DP2	5	3	Marketing	4	2	Divorced	1	2789	2	2
EP0295	No	37	DP1	9	3	Medical	2	4	Married	1	2326	2	4
EP0296	No	42	DP2	26	3	Marketing	3	2	Married	5	13525	4	20
EP0298	No	35	DP2	16	3	Marketing	3	2	Married	0	8020	2	11
EP0299	No	36	DP1	18	4	Life Sciences	3	4	Married	4	3688	3	1
EP0300	No	51	DP1	2	3	Medical	4	2	Divorced	5	5482	3	4
EP0301	No	41	DP2	2	4	Life Sciences	4	2	Single	1	16015	3	22
EP0302	No	18	DP2	10	3	Medical	4	3	Single	1	1200	3	0
EP0303	No	28	DP1	16	2	Medical	2	1	Single	0	5661	3	8
EP0304	No	31	DP2	7	3	Technical Degree	2	4	Married	4	6929	2	8
EP0305	No	39	DP1	1	3	Medical	3	4	Divorced	0	9613	2	18
EP0306	No	36	DP1	24	4	Life Sciences	2	2	Married	7	5674	3	9
EP0307	No	32	DP2	7	3	Life Sciences	4	3	Married	1	5484	2	13
EP0308	No	38	DP1	25	2	Life Sciences	1	2	Married	3	12061	3	10
EP0309	No	58	DP1	1	4	Life Sciences	4	3	Divorced	2	5660	3	5
EP0310	No	31	DP1	5	4	Technical Degree	3	4	Married	0	4821	3	5
EP0311	No	31	DP3	2	3	Human Resources	1	1	Married	3	6410	3	2
EP0312	No	45	DP1	7	3	Life Sciences	1	1	Divorced	1	5210	3	24
EP0313	No	31	DP1	2	4	Life Sciences	3	4	Divorced	0	2695	1	2
EP0314	No	33	DP1	5	4	Life Sciences	4	2	Married	6	11878	3	10
EP0315	No	39	DP1	10	1	Medical	3	1	Married	1	17068	3	21
EP0316	No	43	DP1	10	4	Life Sciences	3	4	Single	0	2455	3	8
EP0317	No	49	DP1	1	2	Technical Degree	3	3	Single	7	13964	3	7
EP0319	No	27	DP1	5	3	Life Sciences	3	2	Single	1	2478	2	4
EP0320	No	32	DP2	8	2	Technical Degree	3	2	Married	1	5228	3	13
EP0321	No	27	DP2	2	3	Life Sciences	4	3	Single	1	4478	3	5
EP0322	No	31	DP2	7	3	Marketing	4	4	Divorced	4	7547	3	7
EP0323	No	32	DP1	2	4	Medical	1	4	Single	7	5055	2	7
EP0325	No	30	DP1	28	2	Medical	4	4	Married	1	5775	3	10
EP0326	No	31	DP1	7	2	Life Sciences	3	3	Married	1	8943	3	10
EP0327	No	39	DP1	7	2	Medical	3	4	Married	1	19272	3	21
EP0329	No	33	DP2	10	3	Marketing	2	4	Single	3	4682	2	7
EP0330	No	47	DP1	5	5	Life Sciences	4	3	Married	4	18300	3	3
EP0331	No	43	DP1	10	4	Life Sciences	3	3	Divorced	1	5257	4	9
EP0332	No	27	DP2	1	1	Marketing	3	2	Married	0	6349	3	5
EP0333	No	54	DP1	20	4	Life Sciences	4	3	Single	3	4869	2	4
EP0334	No	43	DP1	7	3	Life Sciences	3	1	Married	8	9985	2	1
EP0335	No	45	DP1	8	4	Other	4	4	Married	9	3697	3	10
EP0336	No	40	DP2	1	2	Medical	2	4	Married	2	7457	2	4
EP0338	No	29	DP1	9	5	Other	2	4	Single	0	3983	3	3
EP0339	No	30	DP2	5	3	Marketing	4	3	Divorced	1	6118	3	10
EP0340	No	27	DP2	8	4	Marketing	2	2	Married	1	6214	3	8
EP0341	No	37	DP1	5	2	Medical	4	4	Divorced	7	6347	2	6
EP0342	No	38	DP1	15	2	Life Sciences	3	4	Divorced	0	11510	3	11
EP0343	No	31	DP1	7	4	Medical	3	4	Single	1	7143	2	11
EP0344	No	29	DP2	10	1	Marketing	4	2	Divorced	1	8268	3	7
EP0345	No	35	DP1	5	4	Technical Degree	3	2	Single	0	8095	3	16
EP0346	No	23	DP1	26	1	Life Sciences	3	4	Divorced	1	2904	2	4
EP0347	No	41	DP1	6	3	Medical	4	2	Single	6	6032	3	5
EP0348	No	47	DP2	4	1	Medical	2	3	Single	3	2976	3	0
EP0349	No	42	DP1	23	5	Life Sciences	1	4	Single	2	15992	3	1
EP0350	No	29	DP2	2	3	Life Sciences	4	3	Married	1	4649	2	4
EP0351	No	42	DP3	2	1	Technical Degree	3	3	Divorced	0	2696	3	3
EP0352	No	32	DP1	2	3	Medical	3	2	Married	1	2370	3	8
EP0353	No	48	DP2	29	1	Medical	1	3	Married	3	12504	1	0
EP0354	No	37	DP1	6	3	Medical	3	1	Divorced	4	5974	3	7
EP0355	No	30	DP2	25	2	Technical Degree	4	3	Married	7	4736	4	2
EP0356	No	26	DP2	1	3	Life Sciences	3	3	Married	1	5296	3	8
EP0357	No	42	DP1	2	4	Other	1	4	Single	3	6781	3	1
EP0359	No	36	DP2	1	5	Medical	4	4	Single	4	6653	3	1
EP0360	No	36	DP2	3	4	Medical	1	4	Married	4	9699	3	13
EP0361	No	57	DP1	1	4	Medical	4	3	Married	2	6755	3	3
EP0362	No	40	DP1	10	4	Life Sciences	4	3	Married	3	2213	3	7
EP0363	No	21	DP2	9	2	Medical	1	4	Single	1	2610	2	3
EP0365	No	37	DP1	10	3	Medical	3	1	Married	6	3452	3	5
EP0366	No	46	DP1	7	4	Medical	3	3	Married	2	5258	4	1
EP0368	No	50	DP1	10	3	Technical Degree	4	4	Single	6	10496	3	4
EP0370	No	31	DP1	9	4	Life Sciences	3	2	Single	0	2657	3	2
EP0372	No	29	DP1	23	3	Life Sciences	4	4	Single	9	2201	3	3
EP0373	No	35	DP1	9	4	Life Sciences	3	2	Single	9	6540	3	1
EP0374	No	27	DP1	1	2	Medical	4	2	Divorced	1	3816	3	5
EP0375	No	28	DP2	9	4	Life Sciences	2	4	Single	1	5253	3	7
EP0376	No	49	DP1	7	3	Other	2	3	Single	8	10965	3	5
EP0377	No	51	DP2	14	2	Life Sciences	3	4	Married	4	4936	2	7
EP0378	No	36	DP1	2	3	Life Sciences	4	3	Married	4	2543	3	2
EP0380	No	55	DP1	2	3	Life Sciences	3	4	Single	2	16659	3	5
EP0381	No	24	DP2	10	4	Marketing	4	3	Divorced	1	4260	4	5
EP0382	No	30	DP2	2	1	Technical Degree	3	2	Married	1	2476	3	1
EP0384	No	22	DP1	11	3	Medical	1	2	Married	1	2244	3	2
EP0385	No	36	DP2	2	2	Medical	2	3	Married	1	7596	3	10
EP0387	No	37	DP1	14	3	Life Sciences	4	1	Divorced	1	3034	2	18
EP0388	No	40	DP2	2	2	Marketing	4	2	Divorced	7	5715	3	5
EP0389	No	42	DP1	1	4	Life Sciences	2	1	Divorced	3	2576	3	5
EP0390	No	37	DP1	10	4	Life Sciences	3	2	Single	2	4197	2	1
EP0391	No	43	DP1	12	3	Life Sciences	1	2	Divorced	1	14336	3	25
EP0392	No	40	DP1	2	3	Medical	2	3	Married	6	3448	3	1
EP0393	No	54	DP1	5	2	Medical	1	1	Married	4	19406	2	4
EP0394	No	34	DP2	4	4	Marketing	3	3	Married	9	6538	3	3
EP0395	No	31	DP1	7	2	Medical	2	1	Married	1	4306	1	13
EP0396	No	43	DP1	21	3	Medical	4	4	Married	7	2258	3	3
EP0397	No	43	DP1	8	4	Other	3	3	Divorced	4	4522	3	5
EP0398	No	25	DP2	4	2	Life Sciences	2	4	Single	1	4487	3	5
EP0399	No	37	DP1	25	5	Medical	2	3	Married	3	4449	3	13
EP0400	No	31	DP1	1	2	Life Sciences	4	1	Married	1	2218	3	4
EP0401	No	39	DP1	1	1	Life Sciences	2	3	Divorced	1	19197	3	21
EP0402	No	56	DP2	6	3	Life Sciences	3	1	Married	9	13212	2	7
EP0403	No	30	DP2	12	3	Technical Degree	2	3	Single	0	6577	3	5
EP0404	No	41	DP2	1	3	Marketing	2	1	Married	1	8392	3	10
EP0405	No	28	DP1	17	2	Medical	3	1	Divorced	1	4558	3	10
EP0407	No	52	DP1	3	3	Medical	4	3	Married	2	7969	3	5
EP0408	No	45	DP1	10	2	Life Sciences	1	4	Married	3	2654	2	2
EP0409	No	52	DP1	4	2	Life Sciences	4	4	Married	2	16555	1	5
EP0410	No	42	DP1	29	2	Life Sciences	1	3	Divorced	2	4556	3	5
EP0411	No	30	DP1	2	3	Life Sciences	3	4	Single	2	6091	3	5
EP0412	No	60	DP1	7	3	Life Sciences	1	1	Married	5	19566	1	29
EP0413	No	46	DP1	18	3	Medical	3	3	Divorced	2	4810	2	10
EP0414	No	42	DP1	28	4	Technical Degree	4	4	Married	0	4523	4	6
EP0417	No	38	DP1	2	2	Life Sciences	4	4	Married	1	1702	3	1
EP0418	No	40	DP2	2	4	Life Sciences	3	3	Married	0	18041	3	20
EP0419	No	26	DP1	23	3	Life Sciences	1	4	Divorced	1	2886	1	3
EP0420	No	30	DP1	3	3	Life Sciences	3	4	Married	4	2097	1	5
EP0421	No	29	DP1	3	4	Medical	2	3	Married	1	11935	3	10
EP0424	No	30	DP2	22	4	Other	3	1	Married	0	8412	3	9
EP0425	No	57	DP2	29	3	Marketing	1	4	Divorced	3	14118	2	1
EP0426	No	50	DP1	29	4	Life Sciences	2	3	Married	0	17046	3	27
EP0427	No	30	DP1	2	3	Medical	3	4	Single	0	2564	2	11
EP0428	No	60	DP2	28	3	Marketing	3	1	Married	4	10266	4	18
EP0429	No	47	DP1	2	2	Medical	1	4	Divorced	5	5070	3	5
EP0430	No	46	DP1	2	3	Life Sciences	1	3	Married	6	17861	1	3
EP0431	No	35	DP1	22	3	Life Sciences	4	3	Single	0	4230	3	5
EP0432	No	54	DP1	8	4	Life Sciences	3	3	Single	7	3780	3	1
EP0433	No	34	DP1	2	4	Life Sciences	4	3	Divorced	3	2768	3	7
EP0434	No	46	DP2	10	3	Marketing	3	4	Married	2	9071	3	3
EP0435	No	31	DP1	9	1	Life Sciences	3	2	Divorced	1	10648	4	13
EP0438	No	30	DP2	7	1	Marketing	4	2	Single	0	2983	3	3
EP0439	No	35	DP1	16	3	Life Sciences	4	3	Married	4	7632	3	8
EP0442	No	42	DP1	5	2	Other	2	3	Married	4	2093	3	2
EP0443	No	36	DP2	10	4	Medical	2	4	Single	1	9980	2	10
EP0445	No	48	DP2	2	5	Marketing	2	4	Married	2	4051	3	9
EP0446	No	55	DP2	18	5	Life Sciences	1	2	Single	3	16835	3	10
EP0447	No	41	DP2	10	2	Life Sciences	4	4	Single	7	6230	3	14
EP0448	No	35	DP2	1	3	Marketing	2	3	Married	9	4717	3	11
EP0449	No	40	DP1	6	3	Life Sciences	2	3	Single	7	13237	3	20
EP0450	No	39	DP1	8	1	Life Sciences	3	3	Married	1	3755	3	8
EP0451	No	31	DP2	2	1	Life Sciences	2	4	Single	4	6582	4	6
EP0452	No	42	DP1	24	3	Medical	4	1	Married	1	7406	2	10
EP0453	No	45	DP2	2	3	Other	4	2	Married	0	4805	4	8
EP0455	No	29	DP1	19	3	Technical Degree	4	4	Divorced	4	4262	4	3
EP0456	No	33	DP1	1	5	Medical	1	3	Divorced	4	16184	3	6
EP0457	No	31	DP2	7	3	Life Sciences	3	4	Divorced	9	11557	2	5
EP0459	No	40	DP2	28	3	Other	3	1	Divorced	3	10932	3	1
EP0460	No	41	DP1	2	4	Other	1	3	Single	2	6811	3	8
EP0461	No	26	DP2	29	2	Medical	1	3	Divorced	5	4306	3	0
EP0462	No	35	DP2	1	3	Medical	1	3	Single	1	4859	3	5
EP0463	No	34	DP2	21	4	Life Sciences	4	4	Single	1	5337	3	10
EP0465	No	37	DP1	1	3	Technical Degree	2	4	Single	4	7491	4	6
EP0466	No	46	DP1	18	1	Medical	1	3	Married	5	10527	2	2
EP0467	No	41	DP2	2	5	Life Sciences	2	1	Married	7	16595	3	18
EP0468	No	37	DP2	9	4	Medical	1	2	Divorced	1	8834	3	9
EP0469	No	52	DP1	6	2	Technical Degree	4	1	Divorced	3	5577	3	10
EP0471	No	24	DP2	24	3	Medical	4	4	Married	0	2400	3	2
EP0472	No	38	DP1	10	3	Medical	3	3	Married	3	9824	3	1
EP0473	No	37	DP1	1	4	Life Sciences	2	2	Married	6	6447	2	6
EP0474	No	49	DP1	18	4	Life Sciences	4	3	Divorced	1	19502	3	31
EP0475	No	24	DP1	23	3	Medical	2	4	Married	1	2725	3	6
EP0476	No	26	DP2	28	2	Marketing	1	2	Married	1	6272	4	5
EP0477	No	24	DP1	17	2	Other	4	2	Married	1	2127	3	1
EP0478	No	50	DP3	3	3	Medical	1	2	Married	1	18200	3	32
EP0479	No	25	DP2	13	1	Medical	2	3	Married	1	2096	3	7
EP0482	No	34	DP1	1	2	Life Sciences	2	4	Married	1	3622	3	6
EP0484	No	35	DP1	25	2	Other	1	4	Single	4	3681	3	3
EP0485	No	31	DP2	6	4	Medical	1	4	Divorced	4	5460	4	7
EP0486	No	27	DP1	6	4	Medical	1	3	Divorced	0	2187	2	5
EP0487	No	37	DP2	2	3	Marketing	4	3	Married	4	9602	2	3
EP0488	No	20	DP1	1	3	Life Sciences	4	2	Single	1	2836	4	1
EP0489	No	42	DP1	2	4	Life Sciences	3	4	Married	1	4089	3	10
EP0490	No	43	DP1	6	4	Other	2	4	Divorced	4	16627	2	1
EP0491	No	38	DP1	1	1	Life Sciences	3	1	Single	3	2619	2	0
EP0492	No	43	DP1	9	5	Medical	4	3	Divorced	3	5679	3	8
EP0493	No	48	DP1	1	4	Life Sciences	4	1	Married	7	15402	1	3
EP0494	No	44	DP3	1	4	Life Sciences	1	3	Single	4	5985	4	2
EP0495	No	34	DP2	14	3	Technical Degree	3	3	Divorced	1	2579	3	8
EP0497	No	21	DP2	22	1	Technical Degree	3	3	Single	1	3447	3	3
EP0498	No	44	DP1	3	4	Other	4	4	Married	4	19513	4	2
EP0499	No	22	DP1	6	1	Medical	1	3	Married	0	2773	3	2
EP0500	No	33	DP2	8	4	Marketing	3	3	Divorced	0	7104	3	5
EP0501	No	32	DP1	9	4	Life Sciences	1	4	Married	1	6322	2	6
EP0502	No	30	DP1	3	3	Medical	3	3	Divorced	1	2083	3	1
EP0503	No	53	DP2	1	1	Medical	4	1	Single	7	8381	4	14
EP0504	No	34	DP1	1	5	Life Sciences	2	4	Married	1	2691	2	10
EP0506	No	26	DP1	6	3	Life Sciences	3	4	Married	1	2659	3	3
EP0507	No	37	DP1	3	3	Other	3	3	Married	1	9434	3	10
EP0508	No	29	DP2	3	2	Medical	2	3	Married	1	5561	2	6
EP0509	No	35	DP1	6	4	Life Sciences	2	4	Single	1	6646	3	17
EP0510	No	33	DP1	6	3	Life Sciences	3	4	Divorced	3	7725	1	13
EP0511	No	54	DP3	19	4	Medical	3	2	Married	2	10725	4	9
EP0512	No	36	DP1	9	2	Medical	2	2	Divorced	2	8847	3	3
EP0513	No	27	DP1	3	4	Medical	1	4	Single	0	2045	3	4
EP0516	No	35	DP1	3	3	Life Sciences	3	3	Married	1	1281	3	1
EP0517	No	23	DP1	4	3	Medical	1	1	Married	2	2819	4	3
EP0518	No	25	DP2	8	3	Life Sciences	4	2	Married	0	4851	3	3
EP0519	No	38	DP2	7	4	Marketing	4	4	Single	0	4028	3	7
EP0520	No	29	DP1	1	4	Life Sciences	2	4	Divorced	1	2720	3	10
EP0521	No	48	DP2	2	1	Marketing	2	2	Married	3	8120	3	2
EP0522	No	27	DP2	3	1	Medical	4	4	Divorced	1	4647	3	6
EP0523	No	37	DP1	10	2	Life Sciences	4	4	Single	3	4680	3	1
EP0524	No	50	DP1	28	1	Medical	4	3	Married	1	3221	3	20
EP0525	No	34	DP1	9	3	Medical	4	2	Single	1	8621	4	8
EP0527	No	39	DP1	2	4	Technical Degree	4	3	Single	1	4553	3	20
EP0528	No	32	DP2	10	3	Marketing	4	4	Single	1	5396	2	10
EP0530	No	38	DP1	1	4	Life Sciences	2	4	Single	0	7625	2	9
EP0531	No	27	DP1	1	2	Life Sciences	3	1	Married	1	7412	3	9
EP0532	No	32	DP1	3	2	Life Sciences	3	4	Single	3	11159	3	7
EP0533	No	47	DP2	14	4	Marketing	4	1	Single	2	4960	3	7
EP0534	No	40	DP2	5	4	Life Sciences	4	1	Married	5	10475	3	18
EP0535	No	53	DP1	7	3	Life Sciences	3	3	Married	3	14814	3	5
EP0536	No	41	DP3	10	4	Human Resources	2	4	Divorced	3	19141	2	21
EP0537	No	60	DP2	16	4	Marketing	1	1	Single	8	5405	3	2
EP0538	No	27	DP1	10	2	Life Sciences	4	1	Divorced	1	8793	2	9
EP0539	No	41	DP3	1	3	Human Resources	4	3	Married	1	19189	3	22
EP0540	No	50	DP2	8	4	Marketing	4	2	Married	7	3875	3	2
EP0542	No	36	DP1	8	3	Life Sciences	1	1	Married	9	11713	3	8
EP0543	No	38	DP1	1	3	Life Sciences	3	3	Single	4	7861	4	1
EP0544	No	44	DP1	24	3	Medical	1	3	Single	2	3708	3	5
EP0545	No	47	DP2	3	3	Medical	4	3	Divorced	9	13770	2	22
EP0546	No	30	DP2	27	5	Marketing	3	4	Divorced	7	5304	2	8
EP0547	No	29	DP2	10	3	Life Sciences	3	3	Single	1	2642	3	1
EP0549	No	43	DP2	15	3	Life Sciences	4	4	Married	3	6804	3	2
EP0550	No	34	DP1	8	2	Medical	2	3	Single	3	6142	3	5
EP0551	No	23	DP1	9	1	Medical	2	1	Married	1	2500	4	4
EP0552	No	39	DP3	3	3	Human Resources	3	2	Married	9	6389	1	8
EP0553	No	56	DP1	9	3	Medical	3	4	Married	7	11103	2	10
EP0554	No	40	DP1	2	1	Medical	4	4	Single	0	2342	2	4
EP0555	No	27	DP1	7	3	Medical	4	1	Single	8	6811	1	7
EP0556	No	29	DP2	10	3	Marketing	4	2	Divorced	1	2297	3	2
EP0557	No	53	DP1	6	3	Life Sciences	4	4	Single	2	2450	3	2
EP0558	No	35	DP1	2	4	Life Sciences	4	1	Divorced	2	5093	4	1
EP0559	No	32	DP1	24	4	Life Sciences	1	4	Married	1	5309	3	10
EP0560	No	38	DP1	2	5	Medical	4	3	Married	6	3057	1	1
EP0561	No	34	DP1	8	5	Life Sciences	2	1	Divorced	3	5121	3	0
EP0562	No	52	DP2	3	4	Marketing	3	1	Married	1	16856	4	34
EP0564	No	25	DP2	26	1	Medical	3	4	Single	1	6180	2	6
EP0565	No	45	DP2	2	2	Technical Degree	2	3	Single	0	6632	3	8
EP0566	No	23	DP1	10	1	Medical	1	3	Single	1	3505	3	2
EP0568	No	34	DP2	2	3	Other	4	4	Single	1	6274	3	6
EP0570	No	36	DP2	8	4	Life Sciences	1	1	Single	1	7587	3	10
EP0571	No	52	DP1	19	4	Medical	4	4	Married	0	4258	3	4
EP0572	No	26	DP1	1	2	Life Sciences	1	4	Divorced	3	4364	3	2
EP0573	No	29	DP1	27	3	Medical	2	3	Married	4	4335	2	8
EP0575	No	34	DP1	1	4	Life Sciences	2	4	Single	2	3280	3	4
EP0576	No	54	DP1	19	4	Medical	4	1	Divorced	9	5485	3	5
EP0577	No	27	DP2	8	1	Marketing	3	4	Married	0	4342	3	4
EP0578	No	37	DP1	10	1	Life Sciences	4	1	Divorced	0	2782	2	5
EP0579	No	38	DP1	2	4	Life Sciences	1	1	Single	6	5980	3	15
EP0580	No	34	DP1	2	4	Medical	3	1	Single	1	4381	3	6
EP0581	No	35	DP2	8	4	Life Sciences	1	4	Married	1	2572	2	3
EP0582	No	30	DP1	1	3	Life Sciences	4	3	Married	3	3833	3	2
EP0583	No	40	DP1	2	2	Medical	3	2	Married	1	4244	3	8
EP0584	No	34	DP2	8	2	Life Sciences	3	1	Married	5	6500	3	3
EP0585	No	42	DP1	8	3	Life Sciences	2	4	Divorced	1	18430	2	24
EP0587	No	24	DP1	9	3	Life Sciences	3	2	Divorced	1	2694	3	1
EP0588	No	52	DP1	11	4	Life Sciences	4	3	Married	8	3149	3	5
EP0589	No	50	DP1	2	3	Medical	3	3	Married	5	17639	3	4
EP0591	No	33	DP1	7	3	Medical	3	3	Married	0	11691	4	13
EP0593	No	47	DP1	2	2	Other	3	4	Married	1	16752	2	26
EP0594	No	36	DP1	1	3	Other	3	2	Married	0	5228	3	9
EP0595	No	29	DP1	23	2	Life Sciences	3	3	Married	1	2700	3	10
EP0597	No	35	DP1	1	4	Life Sciences	4	3	Single	3	2506	3	2
EP0598	No	42	DP1	1	2	Life Sciences	4	4	Married	9	6062	3	4
EP0600	No	36	DP3	13	3	Human Resources	3	2	Married	4	2143	3	5
EP0601	No	32	DP1	4	3	Life Sciences	3	3	Married	1	6162	3	14
EP0602	No	40	DP1	16	4	Medical	1	3	Single	6	5094	3	1
EP0603	No	30	DP1	2	3	Medical	3	4	Single	5	6877	2	0
EP0604	No	45	DP1	2	3	Life Sciences	2	3	Single	1	2274	3	1
EP0605	No	42	DP1	29	3	Life Sciences	2	2	Married	1	4434	2	9
EP0606	No	38	DP1	12	3	Life Sciences	1	1	Divorced	2	6288	2	4
EP0607	No	34	DP1	16	4	Life Sciences	3	4	Single	1	2553	3	5
EP0610	No	43	DP1	14	2	Life Sciences	2	1	Married	6	17159	3	4
EP0611	No	27	DP1	5	1	Technical Degree	3	4	Divorced	1	12808	3	9
EP0612	No	35	DP1	7	3	Other	3	3	Single	3	10221	4	8
EP0613	No	28	DP2	2	4	Marketing	2	2	Married	1	4779	3	8
EP0614	No	34	DP3	3	2	Human Resources	3	4	Married	0	3737	1	3
EP0616	No	27	DP1	3	3	Medical	4	4	Married	1	1706	2	0
EP0617	No	51	DP2	26	4	Marketing	1	3	Married	2	16307	2	20
EP0618	No	44	DP1	4	3	Medical	4	2	Single	9	5933	2	5
EP0619	No	25	DP1	2	1	Medical	1	1	Single	7	3424	2	4
EP0620	No	33	DP2	1	3	Medical	1	1	Divorced	1	4037	3	9
EP0621	No	35	DP1	27	1	Medical	3	1	Single	1	2559	2	6
EP0622	No	36	DP2	1	2	Life Sciences	2	4	Married	1	6201	2	18
EP0623	No	32	DP2	13	4	Life Sciences	2	4	Divorced	2	4403	2	5
EP0624	No	30	DP1	5	4	Life Sciences	2	4	Divorced	9	3761	2	5
EP0625	No	53	DP2	7	2	Marketing	1	4	Married	7	10934	3	5
EP0626	No	45	DP2	9	3	Marketing	4	1	Divorced	4	10761	3	5
EP0627	No	32	DP1	8	2	Medical	3	3	Married	5	5175	2	5
EP0628	No	52	DP1	25	4	Medical	3	4	Married	3	13826	3	9
EP0629	No	37	DP2	16	4	Marketing	4	3	Divorced	4	6334	3	1
EP0630	No	28	DP3	8	2	Medical	2	4	Divorced	1	4936	3	5
EP0631	No	22	DP1	1	2	Life Sciences	4	4	Married	6	4775	1	2
EP0632	No	44	DP1	8	4	Life Sciences	1	4	Married	2	2818	2	3
EP0633	No	42	DP1	2	1	Medical	2	4	Single	5	2515	3	2
EP0634	No	36	DP3	8	3	Life Sciences	1	1	Married	0	2342	3	5
EP0635	No	25	DP2	3	1	Other	3	1	Married	1	4194	3	5
EP0636	No	35	DP1	9	3	Life Sciences	4	3	Married	1	10685	3	17
EP0638	No	32	DP1	1	3	Life Sciences	4	4	Divorced	0	2314	3	3
EP0639	No	25	DP2	4	1	Marketing	3	1	Married	1	4256	4	5
EP0640	No	49	DP1	1	3	Technical Degree	3	1	Married	2	3580	3	4
EP0641	No	24	DP1	4	1	Life Sciences	1	4	Married	0	3162	2	5
EP0642	No	32	DP2	5	2	Life Sciences	2	2	Married	1	6524	3	10
EP0643	No	38	DP2	9	3	Marketing	2	2	Married	0	2899	3	2
EP0644	No	42	DP1	3	3	Life Sciences	3	4	Married	2	5231	2	5
EP0645	No	31	DP1	11	4	Life Sciences	4	4	Married	3	2356	3	6
EP0647	No	53	DP2	8	3	Marketing	1	4	Married	5	11836	3	2
EP0648	No	35	DP1	25	3	Technical Degree	4	2	Married	3	10903	3	13
EP0649	No	37	DP2	21	2	Medical	3	4	Married	5	2973	3	5
EP0650	No	53	DP1	23	4	Life Sciences	4	4	Single	6	14275	3	12
EP0651	No	43	DP1	1	3	Life Sciences	4	4	Married	4	5562	2	5
EP0652	No	47	DP2	2	2	Marketing	3	4	Married	0	4537	3	7
EP0653	No	37	DP2	19	2	Medical	1	2	Single	1	7642	3	10
EP0654	No	50	DP1	2	4	Life Sciences	1	1	Divorced	1	17924	3	31
EP0655	No	39	DP3	2	3	Life Sciences	4	4	Married	8	5204	3	5
EP0656	No	33	DP3	3	2	Human Resources	4	2	Divorced	3	2277	4	4
EP0658	No	29	DP1	7	1	Medical	1	4	Divorced	6	2532	3	4
EP0659	No	44	DP1	9	2	Life Sciences	2	1	Married	1	2559	3	8
EP0660	No	28	DP2	5	4	Medical	1	4	Single	1	4908	3	4
EP0662	No	43	DP1	8	3	Life Sciences	1	2	Divorced	4	4765	4	1
EP0665	No	36	DP1	14	1	Life Sciences	3	4	Married	0	6586	2	16
EP0666	No	47	DP2	2	4	Life Sciences	4	4	Single	1	3294	2	3
EP0669	No	28	DP1	9	3	Medical	3	3	Divorced	5	2377	3	2
EP0671	No	27	DP1	4	3	Life Sciences	2	3	Single	1	2318	3	1
EP0672	No	34	DP1	10	3	Life Sciences	2	2	Divorced	1	2008	3	1
EP0673	No	42	DP2	14	2	Medical	3	3	Single	7	6244	3	5
EP0674	No	33	DP1	1	4	Other	3	1	Single	3	2799	3	3
EP0675	No	58	DP1	5	3	Technical Degree	3	2	Divorced	2	10552	3	6
EP0676	No	31	DP2	7	4	Life Sciences	2	3	Married	3	2329	4	7
EP0677	No	35	DP1	21	1	Life Sciences	4	4	Married	1	4014	1	10
EP0678	No	49	DP1	8	2	Other	1	2	Married	4	7403	2	26
EP0679	No	48	DP1	20	4	Medical	4	3	Married	4	2259	2	0
EP0680	No	31	DP2	20	2	Marketing	4	3	Married	1	6932	2	9
EP0681	No	36	DP1	7	4	Other	2	4	Single	2	4678	3	6
EP0682	No	38	DP1	1	3	Technical Degree	4	1	Married	1	13582	3	15
EP0683	No	32	DP1	1	3	Life Sciences	3	2	Married	6	2332	3	3
EP0685	No	40	DP2	10	4	Marketing	1	2	Divorced	2	9705	2	1
EP0686	No	26	DP2	1	3	Medical	3	1	Single	1	4294	3	7
EP0687	No	41	DP1	6	3	Medical	4	1	Single	2	4721	3	18
EP0688	No	36	DP1	2	4	Medical	3	3	Single	4	2519	3	11
EP0691	No	31	DP1	12	3	Medical	4	4	Married	0	5855	1	9
EP0692	No	40	DP1	9	4	Medical	4	2	Divorced	8	3617	3	1
EP0693	No	32	DP1	3	4	Medical	3	1	Married	1	6725	4	8
EP0695	No	33	DP1	1	3	Life Sciences	2	4	Single	0	6949	3	5
EP0697	No	45	DP1	4	2	Life Sciences	3	2	Married	1	4447	2	9
EP0698	No	29	DP2	20	3	Technical Degree	3	4	Married	1	2157	3	3
EP0699	No	35	DP2	18	3	Medical	3	3	Married	1	4601	3	5
EP0700	No	52	DP1	1	2	Life Sciences	4	4	Married	2	17099	2	9
EP0702	No	53	DP2	2	2	Medical	3	3	Divorced	6	14852	4	17
EP0703	No	30	DP2	8	2	Other	3	3	Divorced	5	7264	4	8
EP0704	No	38	DP2	10	3	Technical Degree	3	4	Single	1	5666	3	5
EP0705	No	35	DP2	3	4	Life Sciences	4	4	Divorced	6	7823	3	10
EP0706	No	39	DP2	2	5	Life Sciences	1	3	Single	0	7880	3	8
EP0708	No	47	DP1	16	4	Medical	3	3	Divorced	1	5067	4	19
EP0709	No	36	DP2	8	4	Technical Degree	1	4	Divorced	4	5079	3	7
EP0711	No	33	DP2	17	3	Life Sciences	4	3	Single	1	17444	3	10
EP0713	No	33	DP1	13	1	Life Sciences	2	4	Single	3	3452	3	3
EP0714	No	45	DP1	1	4	Medical	4	4	Divorced	3	2270	3	5
EP0715	No	50	DP1	1	2	Medical	4	4	Divorced	9	17399	2	5
EP0716	No	33	DP1	1	4	Other	3	2	Married	1	5488	3	6
EP0717	No	41	DP1	9	3	Medical	1	3	Divorced	2	19419	4	18
EP0718	No	27	DP1	16	4	Technical Degree	3	2	Married	9	2811	3	2
EP0719	No	45	DP1	23	2	Life Sciences	4	1	Married	1	3633	3	9
EP0720	No	47	DP2	4	2	Life Sciences	4	4	Single	1	4163	3	9
EP0722	No	50	DP1	24	3	Life Sciences	4	3	Married	3	13973	3	12
EP0723	No	38	DP1	10	1	Medical	3	3	Married	0	2684	2	2
EP0724	No	46	DP1	7	2	Medical	4	3	Divorced	6	10845	3	8
EP0725	No	24	DP1	17	1	Medical	4	3	Divorced	1	4377	3	4
EP0727	No	31	DP1	1	1	Life Sciences	3	1	Married	1	4148	3	4
EP0728	No	18	DP1	5	2	Life Sciences	2	4	Single	1	1051	3	0
EP0729	No	54	DP1	17	3	Technical Degree	3	3	Married	8	10739	3	10
EP0730	No	35	DP1	25	4	Medical	3	3	Divorced	1	10388	2	16
EP0731	No	30	DP1	8	2	Life Sciences	2	1	Married	0	11416	2	8
EP0734	No	26	DP1	2	2	Medical	4	4	Married	1	5472	3	8
EP0735	No	22	DP1	8	1	Life Sciences	2	1	Married	1	2451	2	4
EP0736	No	48	DP1	6	3	Life Sciences	1	3	Single	2	4240	3	2
EP0737	No	48	DP1	4	4	Life Sciences	3	3	Single	7	10999	3	15
EP0738	No	41	DP1	7	2	Medical	4	3	Single	6	5003	3	2
EP0739	No	39	DP1	1	1	Life Sciences	4	4	Married	1	12742	3	21
EP0740	No	27	DP1	2	4	Life Sciences	1	4	Married	0	4227	3	3
EP0741	No	35	DP1	10	3	Other	2	4	Divorced	1	3917	2	3
EP0742	No	42	DP2	5	2	Marketing	4	3	Married	6	18303	4	1
EP0743	No	50	DP1	9	3	Life Sciences	1	4	Married	4	2380	3	1
EP0744	No	59	DP1	2	3	Life Sciences	3	4	Single	3	13726	3	5
EP0746	No	55	DP1	18	4	Medical	3	2	Married	3	6385	3	8
EP0747	No	41	DP1	7	1	Life Sciences	2	3	Divorced	1	19973	3	21
EP0748	No	38	DP2	3	4	Life Sciences	2	4	Single	8	6861	3	1
EP0751	No	44	DP2	28	3	Medical	4	4	Married	3	13320	3	12
EP0752	No	50	DP2	1	3	Life Sciences	4	3	Married	0	6347	3	18
EP0754	No	39	DP1	22	3	Medical	4	1	Single	1	10880	3	21
EP0755	No	33	DP2	8	1	Life Sciences	2	4	Single	0	2342	2	2
EP0756	No	45	DP2	11	2	Life Sciences	4	4	Married	3	17650	4	9
EP0757	No	32	DP1	29	4	Medical	4	3	Single	9	4025	3	8
EP0758	No	34	DP2	1	4	Marketing	2	4	Divorced	0	9725	2	15
EP0759	No	59	DP2	1	2	Technical Degree	2	4	Married	3	11904	1	6
EP0760	No	45	DP3	24	4	Medical	2	2	Single	1	2177	3	6
EP0761	No	53	DP2	2	3	Marketing	3	2	Married	2	7525	3	15
EP0764	No	34	DP2	10	4	Life Sciences	3	3	Married	1	2220	3	1
EP0765	No	28	DP2	10	1	Medical	4	2	Married	1	1052	3	1
EP0766	No	38	DP1	3	4	Other	3	3	Married	3	2821	3	2
EP0767	No	50	DP1	2	4	Medical	2	3	Married	2	19237	2	8
EP0768	No	37	DP1	3	3	Other	4	2	Single	3	4107	2	4
EP0769	No	40	DP2	26	3	Marketing	3	1	Married	1	8396	2	7
EP0770	No	26	DP1	1	1	Medical	1	3	Divorced	1	2007	3	5
EP0771	No	46	DP1	1	4	Medical	4	4	Divorced	9	19627	3	2
EP0772	No	54	DP2	2	4	Life Sciences	3	3	Married	6	10686	3	9
EP0773	No	56	DP1	9	3	Medical	1	3	Married	2	2942	3	5
EP0774	No	36	DP1	12	5	Medical	4	4	Single	0	8858	2	14
EP0775	No	55	DP1	2	1	Medical	3	1	Single	7	16756	4	9
EP0776	No	43	DP2	25	3	Medical	3	4	Divorced	5	10798	3	1
EP0779	No	46	DP1	8	4	Life Sciences	4	1	Divorced	8	4615	3	16
EP0782	No	26	DP1	1	2	Medical	1	1	Married	1	3955	3	5
EP0783	No	30	DP1	20	3	Other	3	1	Married	0	9957	2	6
EP0784	No	41	DP1	7	2	Technical Degree	2	3	Married	1	3376	3	10
EP0785	No	38	DP1	17	1	Life Sciences	3	3	Married	0	8823	2	19
EP0786	No	40	DP1	20	4	Technical Degree	1	4	Married	4	10322	3	11
EP0787	No	27	DP1	8	5	Life Sciences	1	3	Married	1	4621	3	3
EP0788	No	55	DP1	2	1	Life Sciences	4	2	Married	3	10976	3	3
EP0789	No	28	DP1	10	3	Other	3	3	Single	3	3660	4	8
EP0791	No	33	DP1	5	3	Life Sciences	4	4	Divorced	4	7119	3	3
EP0794	No	28	DP1	15	2	Life Sciences	1	3	Divorced	1	2207	2	4
EP0795	No	34	DP1	3	1	Life Sciences	1	4	Single	0	7756	2	6
EP0796	No	37	DP2	10	4	Life Sciences	4	4	Divorced	2	6694	3	1
EP0800	No	42	DP1	2	2	Medical	4	1	Married	0	17665	3	22
EP0803	No	33	DP2	7	3	Life Sciences	4	2	Married	0	4302	3	3
EP0804	No	34	DP1	3	4	Life Sciences	3	4	Married	3	2979	3	0
EP0805	No	48	DP1	1	4	Medical	1	4	Single	2	16885	2	5
EP0806	No	45	DP2	9	4	Life Sciences	2	3	Married	1	5593	3	15
EP0807	No	52	DP1	7	4	Life Sciences	2	2	Single	7	10445	3	8
EP0808	No	38	DP2	10	4	Marketing	3	3	Divorced	0	8740	3	8
EP0809	No	29	DP1	28	4	Life Sciences	3	4	Divorced	4	2514	3	7
EP0810	No	28	DP1	3	3	Medical	4	2	Divorced	0	7655	2	9
EP0811	No	46	DP2	3	1	Marketing	1	3	Married	3	17465	3	12
EP0812	No	38	DP2	2	2	Marketing	4	2	Single	7	7351	3	1
EP0813	No	43	DP1	27	3	Life Sciences	3	1	Married	8	10820	3	8
EP0815	No	40	DP1	14	3	Medical	3	3	Single	1	19626	4	20
EP0816	No	21	DP1	1	1	Technical Degree	4	2	Single	1	2070	4	2
EP0817	No	39	DP1	9	3	Life Sciences	3	2	Single	9	6782	2	5
EP0818	No	36	DP1	18	4	Life Sciences	1	4	Single	2	7779	3	11
EP0819	No	31	DP2	20	3	Life Sciences	3	4	Married	0	2791	3	2
EP0820	No	28	DP1	2	1	Life Sciences	1	2	Married	0	3201	1	5
EP0821	No	35	DP2	11	2	Marketing	4	4	Divorced	1	4968	3	5
EP0822	No	49	DP2	8	4	Technical Degree	4	2	Married	6	13120	3	9
EP0823	No	34	DP1	2	2	Life Sciences	4	3	Single	2	4033	2	3
EP0824	No	29	DP1	10	3	Life Sciences	4	2	Divorced	0	3291	2	7
EP0825	No	42	DP1	29	3	Medical	2	4	Single	4	4272	3	1
EP0826	No	29	DP1	8	1	Medical	2	4	Married	1	5056	2	10
EP0827	No	38	DP3	1	3	Human Resources	3	3	Married	1	2844	4	7
EP0828	No	28	DP1	6	3	Life Sciences	3	3	Divorced	1	2703	3	3
EP0831	No	41	DP1	12	4	Life Sciences	2	4	Married	3	4766	3	1
EP0833	No	37	DP1	25	2	Medical	3	4	Divorced	7	5731	3	6
EP0834	No	27	DP1	6	3	Life Sciences	4	3	Married	1	2539	3	4
EP0835	No	34	DP2	9	1	Life Sciences	2	3	Married	1	5714	2	6
EP0836	No	35	DP3	8	4	Technical Degree	3	3	Single	1	4323	1	5
EP0838	No	40	DP1	9	4	Medical	2	3	Single	9	13499	2	18
EP0840	No	42	DP2	4	4	Marketing	2	1	Single	7	5155	4	6
EP0841	No	35	DP1	1	4	Medical	4	3	Married	6	2258	3	8
EP0842	No	24	DP1	24	3	Medical	4	2	Single	8	3597	3	4
EP0844	No	26	DP1	3	4	Medical	1	4	Married	1	4420	3	8
EP0845	No	30	DP2	10	3	Marketing	3	3	Married	1	6578	3	10
EP0846	No	40	DP1	26	2	Medical	3	4	Married	3	4422	1	1
EP0847	No	35	DP1	2	3	Life Sciences	3	2	Divorced	2	10274	4	7
EP0848	No	34	DP1	1	3	Medical	4	1	Single	0	5343	3	13
EP0849	No	35	DP1	4	4	Other	4	4	Married	1	2376	4	2
EP0851	No	32	DP2	2	1	Life Sciences	3	1	Divorced	1	2827	3	1
EP0852	No	56	DP1	4	4	Technical Degree	4	1	Divorced	4	19943	3	5
EP0853	No	29	DP1	6	1	Medical	2	4	Married	1	3131	3	10
EP0854	No	19	DP1	9	2	Life Sciences	3	1	Single	1	2552	3	1
EP0855	No	45	DP1	7	3	Medical	1	3	Married	4	4477	2	3
EP0856	No	37	DP1	1	3	Life Sciences	4	4	Married	1	6474	2	14
EP0857	No	20	DP1	3	3	Life Sciences	1	3	Single	1	3033	2	2
EP0859	No	53	DP1	7	2	Medical	4	3	Divorced	3	18606	3	7
EP0860	No	29	DP1	15	1	Life Sciences	2	4	Married	0	2168	2	5
EP0862	No	46	DP2	2	3	Marketing	3	1	Married	8	17048	3	26
EP0863	No	44	DP1	17	3	Life Sciences	4	3	Single	2	2290	3	0
EP0864	No	33	DP3	2	3	Human Resources	2	3	Married	1	3600	3	5
EP0866	No	30	DP2	29	4	Life Sciences	3	1	Divorced	8	4115	3	4
EP0867	No	40	DP2	2	4	Medical	2	2	Married	5	4327	3	0
EP0868	No	50	DP1	2	3	Medical	4	1	Married	2	17856	3	2
EP0869	No	28	DP1	19	4	Medical	4	1	Married	1	3196	3	6
EP0870	No	46	DP1	15	2	Life Sciences	4	2	Married	5	19081	3	4
EP0871	No	35	DP2	17	4	Life Sciences	3	1	Married	3	8966	3	7
EP0873	No	33	DP2	25	3	Medical	2	3	Married	1	4539	2	10
EP0874	No	36	DP1	6	4	Life Sciences	3	3	Divorced	1	2741	3	7
EP0875	No	30	DP1	7	4	Life Sciences	3	3	Divorced	1	3491	2	10
EP0876	No	44	DP1	29	4	Other	4	4	Single	1	4541	3	20
EP0877	No	20	DP2	21	3	Marketing	3	4	Single	1	2678	3	2
EP0878	No	46	DP1	2	4	Technical Degree	4	4	Divorced	2	7379	2	6
EP0879	No	42	DP3	2	5	Medical	4	1	Married	7	6272	4	4
EP0880	No	60	DP2	7	4	Marketing	2	4	Divorced	0	5220	3	11
EP0881	No	32	DP1	13	3	Other	3	2	Married	1	2743	3	2
EP0882	No	32	DP1	2	2	Life Sciences	4	3	Single	4	4998	3	8
EP0883	No	36	DP1	1	3	Technical Degree	3	1	Divorced	2	10252	3	7
EP0884	No	33	DP1	9	3	Medical	1	4	Married	0	2781	3	14
EP0885	No	40	DP2	10	3	Technical Degree	2	2	Divorced	7	6852	4	5
EP0886	No	25	DP2	10	4	Life Sciences	3	4	Single	0	4950	3	4
EP0887	No	30	DP1	1	3	Medical	4	2	Married	0	3579	3	11
EP0888	No	42	DP1	26	5	Medical	1	1	Married	3	13191	3	1
EP0889	No	35	DP2	8	2	Marketing	3	4	Married	4	10377	2	13
EP0890	No	27	DP1	14	3	Life Sciences	1	1	Married	1	2235	2	9
EP0891	No	54	DP1	1	4	Life Sciences	4	3	Divorced	7	10502	1	5
EP0892	No	44	DP1	2	1	Life Sciences	1	4	Married	1	2011	3	10
EP0894	No	29	DP1	1	3	Life Sciences	1	4	Divorced	1	3760	3	3
EP0895	No	54	DP1	3	3	Life Sciences	4	4	Married	3	17779	3	10
EP0896	No	31	DP1	11	2	Medical	3	1	Married	1	6833	2	6
EP0897	No	31	DP1	24	3	Medical	3	1	Single	1	6812	3	10
EP0898	No	59	DP2	3	3	Life Sciences	3	4	Single	5	5171	3	6
EP0899	No	43	DP1	3	3	Life Sciences	3	4	Married	3	19740	3	8
EP0900	No	49	DP1	4	2	Medical	1	3	Married	2	18711	4	1
EP0901	No	36	DP1	3	3	Technical Degree	3	2	Married	1	3692	2	11
EP0902	No	48	DP1	2	2	Technical Degree	4	2	Single	5	2559	2	1
EP0903	No	27	DP1	4	2	Life Sciences	1	3	Divorced	1	2517	3	5
EP0904	No	29	DP1	7	3	Life Sciences	3	4	Divorced	1	6623	3	6
EP0905	No	48	DP1	1	3	Life Sciences	4	4	Single	6	18265	4	1
EP0906	No	29	DP1	1	3	Life Sciences	4	4	Divorced	3	16124	2	7
EP0907	No	34	DP1	20	3	Technical Degree	3	3	Married	0	2585	2	1
EP0908	No	44	DP2	5	3	Marketing	2	2	Married	7	18213	3	22
EP0909	No	33	DP2	10	5	Marketing	4	3	Divorced	0	8380	3	9
EP0910	No	19	DP1	25	3	Life Sciences	2	4	Single	1	2994	3	1
EP0911	No	23	DP1	1	2	Life Sciences	4	3	Married	1	1223	3	1
EP0913	No	26	DP1	4	2	Life Sciences	3	4	Single	1	2875	2	8
EP0915	No	55	DP1	8	1	Medical	4	2	Divorced	1	13577	3	33
EP0917	No	46	DP2	4	2	Marketing	4	2	Married	2	18789	3	11
EP0918	No	34	DP2	2	3	Marketing	3	1	Single	0	4538	3	3
EP0919	No	51	DP2	9	3	Life Sciences	4	2	Divorced	4	19847	2	29
EP0920	No	59	DP1	18	4	Medical	4	4	Single	6	10512	2	9
EP0921	No	34	DP1	19	3	Medical	3	2	Divorced	4	4444	4	11
EP0922	No	28	DP1	1	4	Medical	4	3	Single	0	2154	2	4
EP0923	No	44	DP1	4	2	Life Sciences	3	1	Divorced	1	19190	2	25
EP0924	No	34	DP3	11	3	Life Sciences	3	2	Married	4	4490	4	10
EP0925	No	35	DP1	6	1	Life Sciences	3	3	Married	0	3506	3	3
EP0926	No	42	DP1	7	4	Medical	2	2	Married	6	2372	3	1
EP0927	No	43	DP2	4	4	Marketing	4	4	Single	3	10231	4	21
EP0928	No	36	DP1	2	4	Life Sciences	3	2	Single	9	5410	3	16
EP0930	No	28	DP1	2	3	Life Sciences	4	4	Married	1	3867	3	2
EP0931	No	51	DP1	6	2	Medical	2	3	Single	0	2838	2	7
EP0932	No	30	DP1	9	2	Medical	3	3	Single	7	4695	3	8
EP0934	No	28	DP1	1	3	Technical Degree	4	1	Single	2	2080	2	3
EP0935	No	25	DP1	1	3	Medical	4	2	Single	1	2096	2	2
EP0936	No	32	DP2	8	3	Medical	3	4	Married	1	6209	4	10
EP0937	No	45	DP1	25	3	Medical	2	2	Single	3	18061	3	0
EP0938	No	39	DP1	13	4	Medical	3	2	Divorced	6	17123	3	19
EP0939	No	58	DP1	23	4	Life Sciences	1	3	Divorced	1	2372	3	2
EP0942	No	30	DP1	6	3	Technical Degree	1	4	Married	0	4627	3	9
EP0943	No	36	DP1	10	4	Technical Degree	4	3	Married	3	7094	3	7
EP0944	No	46	DP3	1	2	Life Sciences	4	1	Single	6	3423	4	7
EP0945	No	28	DP1	1	3	Life Sciences	3	4	Married	0	6674	3	9
EP0946	No	50	DP1	28	3	Life Sciences	4	1	Married	4	16880	3	3
EP0949	No	30	DP1	17	4	Medical	2	1	Married	1	11916	3	9
EP0950	No	39	DP1	18	2	Life Sciences	1	3	Single	0	4534	3	8
EP0951	No	31	DP2	2	4	Life Sciences	4	3	Divorced	1	9852	2	10
EP0952	No	41	DP2	10	2	Medical	3	2	Single	1	6151	3	19
EP0955	No	42	DP1	2	1	Life Sciences	3	3	Married	0	17861	2	20
EP0956	No	55	DP1	2	2	Medical	4	3	Married	4	19187	3	19
EP0957	No	56	DP3	8	4	Life Sciences	4	2	Single	6	19717	3	7
EP0958	No	40	DP1	16	2	Life Sciences	3	3	Divorced	9	3544	3	4
EP0959	No	34	DP1	9	3	Life Sciences	4	4	Divorced	0	8500	2	9
EP0960	No	40	DP1	2	3	Life Sciences	3	4	Single	1	4661	3	9
EP0961	No	41	DP2	1	3	Marketing	3	1	Divorced	0	4103	3	9
EP0962	No	35	DP1	4	4	Life Sciences	3	3	Single	1	4249	3	9
EP0963	No	51	DP3	5	3	Life Sciences	3	2	Divorced	1	14026	3	33
EP0964	No	38	DP2	2	2	Life Sciences	2	1	Divorced	3	6893	3	7
EP0965	No	34	DP2	15	2	Medical	3	1	Single	1	6125	4	10
EP0966	No	25	DP1	19	1	Medical	4	4	Married	3	3669	2	3
EP0968	No	40	DP1	1	4	Life Sciences	2	2	Married	3	2387	3	4
EP0969	No	36	DP2	7	3	Marketing	1	1	Married	2	4639	2	15
EP0970	No	48	DP1	4	3	Life Sciences	4	4	Single	1	7898	3	10
EP0971	No	27	DP2	11	3	Medical	3	4	Married	8	2534	3	1
EP0972	No	51	DP1	11	2	Technical Degree	4	2	Single	3	13142	2	5
EP0973	No	18	DP1	1	3	Life Sciences	4	4	Single	1	1611	4	0
EP0974	No	35	DP1	1	3	Medical	4	4	Married	0	5363	3	9
EP0975	No	27	DP2	2	1	Life Sciences	4	4	Single	3	5071	3	6
EP0977	No	56	DP1	23	3	Life Sciences	4	2	Married	4	13402	3	19
EP0978	No	34	DP1	26	1	Technical Degree	1	3	Divorced	1	2029	3	5
EP0979	No	40	DP1	2	1	Medical	2	3	Divorced	5	6377	3	12
EP0980	No	34	DP1	29	3	Medical	2	3	Married	4	5429	3	8
EP0983	No	38	DP1	7	3	Life Sciences	4	3	Divorced	1	2610	3	4
EP0984	No	34	DP1	2	4	Technical Degree	3	4	Single	1	6687	4	14
EP0985	No	28	DP2	26	3	Life Sciences	3	1	Married	1	4724	3	5
EP0987	No	39	DP2	21	4	Life Sciences	1	4	Married	3	6120	4	5
EP0988	No	51	DP2	2	3	Marketing	2	2	Married	2	10596	3	4
EP0989	No	41	DP1	22	3	Life Sciences	4	4	Divorced	3	5467	2	6
EP0990	No	37	DP1	4	1	Life Sciences	3	3	Married	7	2996	3	6
EP0991	No	33	DP2	5	1	Life Sciences	2	4	Married	6	9998	4	5
EP0992	No	32	DP2	2	1	Marketing	3	2	Married	0	4078	2	3
EP0993	No	39	DP1	25	2	Life Sciences	3	3	Married	3	10920	3	6
EP0994	No	25	DP2	18	1	Life Sciences	1	3	Married	2	6232	2	3
EP0995	No	52	DP1	28	2	Medical	4	3	Married	2	13247	2	5
EP0996	No	43	DP1	6	3	Medical	1	3	Single	1	4081	1	20
EP0997	No	27	DP2	10	3	Marketing	4	4	Married	1	5769	3	6
EP0999	No	26	DP1	2	1	Medical	1	4	Single	0	3904	3	4
EP1000	No	42	DP3	10	3	Human Resources	3	1	Married	0	16799	3	20
EP1001	No	52	DP1	8	4	Other	3	1	Married	9	2950	1	5
EP1002	No	37	DP1	11	3	Medical	1	3	Single	4	3629	3	3
EP1003	No	35	DP1	18	2	Life Sciences	3	4	Single	2	9362	3	2
EP1004	No	25	DP1	1	3	Technical Degree	1	4	Married	4	3229	2	3
EP1005	No	26	DP1	7	3	Other	3	1	Single	0	3578	3	7
EP1006	No	29	DP3	17	3	Other	2	1	Single	1	7988	2	10
EP1009	No	54	DP1	1	3	Medical	4	4	Single	6	17328	2	20
EP1010	No	58	DP1	1	3	Medical	4	1	Married	3	19701	3	9
EP1011	No	55	DP1	1	4	Medical	2	4	Divorced	2	14732	4	7
EP1012	No	36	DP2	3	4	Marketing	1	2	Single	3	9278	3	5
EP1014	No	30	DP2	7	4	Marketing	4	1	Divorced	7	4779	3	3
EP1015	No	31	DP1	8	5	Life Sciences	1	2	Single	3	16422	4	3
EP1016	No	34	DP1	1	4	Other	4	1	Divorced	5	2996	3	4
EP1018	No	27	DP1	11	1	Life Sciences	2	1	Married	0	2099	4	5
EP1019	No	36	DP1	4	4	Life Sciences	1	4	Single	1	5810	2	10
EP1020	No	36	DP2	16	4	Marketing	3	1	Married	4	5647	2	3
EP1021	No	47	DP1	1	3	Technical Degree	1	4	Married	7	3420	2	6
EP1023	No	37	DP1	5	2	Technical Degree	3	3	Single	0	3500	1	6
EP1024	No	56	DP1	1	2	Life Sciences	1	1	Married	2	2066	4	3
EP1025	No	47	DP1	2	4	Medical	1	3	Married	3	17169	4	20
EP1026	No	24	DP2	4	1	Medical	4	3	Married	1	4162	3	5
EP1027	No	32	DP2	7	5	Marketing	4	4	Married	4	9204	2	4
EP1028	No	34	DP1	1	3	Life Sciences	4	2	Married	5	3294	2	5
EP1029	No	41	DP1	5	5	Medical	2	3	Married	2	2127	2	4
EP1030	No	40	DP1	9	4	Other	3	3	Divorced	3	3975	4	8
EP1031	No	31	DP2	8	2	Life Sciences	1	4	Divorced	1	10793	3	13
EP1035	No	45	DP1	20	3	Medical	2	1	Divorced	2	10851	3	7
EP1036	No	31	DP3	8	2	Medical	4	2	Single	9	2109	3	3
EP1038	No	45	DP1	29	3	Technical Degree	2	4	Married	4	9380	4	3
EP1039	No	48	DP2	7	3	Marketing	3	1	Divorced	4	5486	3	2
EP1041	No	40	DP1	8	1	Medical	4	2	Divorced	2	13757	3	9
EP1042	No	28	DP2	5	3	Medical	4	1	Single	0	8463	3	5
EP1043	No	44	DP1	5	3	Life Sciences	3	3	Single	3	3162	3	5
EP1044	No	53	DP1	2	3	Medical	4	2	Single	4	16598	2	9
EP1045	No	49	DP1	5	4	Technical Degree	1	3	Married	2	6651	2	3
EP1046	No	40	DP1	2	3	Medical	3	3	Divorced	2	2345	4	3
EP1047	No	44	DP1	20	3	Life Sciences	4	2	Single	1	3420	2	5
EP1048	No	33	DP2	7	3	Medical	4	1	Married	0	4373	3	4
EP1049	No	34	DP2	3	3	Other	4	1	Single	3	4759	3	13
EP1050	No	30	DP2	16	1	Life Sciences	4	3	Married	8	5301	2	2
EP1051	No	42	DP1	9	2	Medical	1	4	Single	1	3673	3	12
EP1052	No	44	DP2	1	5	Marketing	1	3	Married	7	4768	2	1
EP1053	No	30	DP1	7	3	Technical Degree	3	3	Divorced	1	1274	2	1
EP1054	No	57	DP1	1	2	Life Sciences	2	3	Married	0	4900	2	12
EP1055	No	49	DP1	7	4	Life Sciences	3	2	Divorced	3	10466	3	8
EP1056	No	34	DP1	15	3	Medical	2	1	Divorced	7	17007	2	14
EP1060	No	35	DP2	7	1	Life Sciences	4	3	Married	1	2404	3	1
EP1062	No	24	DP2	13	2	Life Sciences	4	2	Married	1	2033	3	1
EP1063	No	44	DP1	2	1	Medical	2	3	Single	5	10209	2	2
EP1064	No	29	DP2	19	3	Life Sciences	3	3	Divorced	1	8620	3	10
EP1065	No	30	DP3	1	3	Life Sciences	3	3	Divorced	0	2064	4	5
EP1066	No	55	DP1	4	4	Life Sciences	4	3	Married	0	4035	3	3
EP1067	No	33	DP1	4	4	Medical	1	2	Married	8	3838	3	5
EP1068	No	47	DP2	14	3	Medical	3	3	Married	3	4591	2	5
EP1070	No	28	DP1	1	3	Life Sciences	1	3	Divorced	1	1563	1	1
EP1071	No	28	DP2	7	3	Life Sciences	3	1	Single	0	4898	3	4
EP1072	No	49	DP1	3	2	Medical	3	1	Married	4	4789	3	3
EP1073	No	29	DP1	2	1	Life Sciences	4	2	Married	0	3180	3	3
EP1074	No	28	DP1	29	1	Life Sciences	3	2	Married	1	6549	2	8
EP1075	No	33	DP1	8	5	Life Sciences	4	3	Single	2	6388	3	0
EP1076	No	32	DP1	10	3	Medical	3	4	Single	2	11244	4	5
EP1077	No	54	DP1	11	4	Medical	2	4	Divorced	3	16032	3	14
EP1079	No	44	DP1	28	3	Life Sciences	4	1	Married	3	16328	4	20
EP1080	No	39	DP1	6	3	Life Sciences	2	2	Single	4	8376	3	2
EP1081	No	46	DP2	3	3	Life Sciences	3	2	Married	8	16606	4	13
EP1082	No	35	DP1	16	3	Life Sciences	4	2	Single	1	8606	1	11
EP1083	No	23	DP1	20	1	Life Sciences	1	3	Single	0	2272	3	4
EP1085	No	34	DP2	1	3	Technical Degree	4	3	Married	1	7083	3	10
EP1087	No	50	DP1	22	5	Medical	3	4	Single	1	14411	3	32
EP1088	No	34	DP2	7	2	Technical Degree	2	3	Married	0	2308	3	11
EP1089	No	42	DP1	2	3	Medical	3	2	Married	4	4841	3	1
EP1090	No	37	DP1	13	3	Medical	1	4	Married	1	4285	3	10
EP1091	No	29	DP1	8	1	Other	3	1	Married	3	9715	3	7
EP1092	No	33	DP1	25	3	Life Sciences	4	2	Single	1	4320	3	5
EP1093	No	45	DP1	28	3	Technical Degree	4	4	Married	4	2132	3	5
EP1094	No	42	DP1	2	3	Life Sciences	4	4	Married	2	10124	1	20
EP1095	No	40	DP2	9	2	Medical	1	1	Married	0	5473	4	8
EP1096	No	33	DP1	28	4	Life Sciences	2	3	Married	1	5207	3	15
EP1097	No	40	DP3	6	2	Medical	3	4	Single	1	16437	3	21
EP1098	No	24	DP1	21	2	Technical Degree	3	1	Divorced	0	2296	3	1
EP1099	No	40	DP1	8	2	Life Sciences	4	4	Divorced	3	4069	3	2
EP1100	No	45	DP1	1	4	Technical Degree	1	2	Divorced	1	7441	3	10
EP1101	No	35	DP2	28	4	Life Sciences	2	3	Married	0	2430	3	5
EP1102	No	32	DP1	5	2	Life Sciences	4	2	Married	3	5878	3	7
EP1103	No	36	DP2	2	4	Life Sciences	3	4	Single	3	2644	2	3
EP1104	No	48	DP2	16	4	Life Sciences	3	3	Divorced	8	6439	3	8
EP1105	No	29	DP1	9	3	Life Sciences	3	3	Married	6	2451	2	1
EP1106	No	33	DP2	8	4	Life Sciences	1	1	Married	2	6392	1	2
EP1108	No	38	DP3	10	4	Human Resources	3	3	Married	3	6077	3	6
EP1109	No	35	DP1	1	3	Medical	4	1	Single	1	2450	3	3
EP1110	No	30	DP2	29	4	Technical Degree	3	2	Married	3	9250	3	4
EP1114	No	32	DP1	1	4	Technical Degree	4	1	Married	4	4087	2	6
EP1115	No	48	DP1	15	4	Other	3	1	Married	8	2367	2	8
EP1116	No	34	DP1	7	4	Medical	1	4	Single	1	2972	1	1
EP1117	No	55	DP2	26	5	Marketing	3	4	Married	1	19586	3	36
EP1118	No	34	DP1	1	4	Life Sciences	2	4	Married	9	5484	2	2
EP1119	No	26	DP1	3	3	Life Sciences	1	4	Married	1	2061	3	1
EP1120	No	38	DP2	14	3	Life Sciences	3	2	Married	0	9924	3	9
EP1121	No	38	DP2	16	3	Life Sciences	2	2	Single	2	4198	4	3
EP1122	No	36	DP2	1	4	Life Sciences	2	3	Single	6	6815	3	1
EP1123	No	29	DP1	3	1	Medical	2	1	Single	1	4723	3	10
EP1124	No	35	DP1	10	4	Medical	1	3	Single	3	6142	3	5
EP1125	No	39	DP2	6	3	Medical	4	3	Married	2	8237	3	7
EP1126	No	29	DP1	2	1	Life Sciences	1	4	Divorced	1	8853	4	6
EP1127	No	50	DP2	9	3	Marketing	3	3	Married	4	19331	3	1
EP1128	No	23	DP1	10	3	Technical Degree	4	3	Married	2	2073	3	2
EP1129	No	36	DP1	6	4	Life Sciences	1	1	Married	3	5562	3	3
EP1130	No	42	DP1	9	2	Other	4	4	Single	8	19613	3	1
EP1131	No	35	DP1	28	3	Life Sciences	2	3	Married	1	3407	2	10
EP1132	No	34	DP1	10	4	Technical Degree	4	3	Married	1	5063	2	8
EP1133	No	40	DP2	14	2	Life Sciences	4	1	Married	1	4639	3	5
EP1134	No	43	DP1	27	3	Technical Degree	4	2	Divorced	5	4876	3	6
EP1135	No	35	DP1	7	2	Life Sciences	3	4	Married	1	2690	2	1
EP1136	No	46	DP2	1	4	Life Sciences	4	1	Single	1	17567	1	26
EP1138	No	22	DP1	26	2	Other	2	3	Married	1	2814	2	4
EP1139	No	50	DP1	20	5	Medical	2	3	Married	2	11245	3	30
EP1140	No	32	DP1	5	4	Other	2	4	Married	3	3312	3	3
EP1141	No	44	DP1	7	3	Medical	2	4	Divorced	0	19049	2	22
EP1142	No	30	DP1	7	3	Medical	2	2	Married	1	2141	2	6
EP1143	No	45	DP1	5	5	Medical	3	1	Single	1	5769	3	10
EP1144	No	45	DP2	26	3	Marketing	1	1	Married	1	4385	3	10
EP1145	No	31	DP2	2	4	Other	4	1	Single	7	5332	3	5
EP1146	No	36	DP1	12	4	Life Sciences	3	3	Married	9	4663	3	3
EP1147	No	34	DP1	10	4	Life Sciences	3	4	Divorced	1	4724	3	9
EP1148	No	49	DP1	25	4	Life Sciences	3	1	Married	1	3211	2	9
EP1149	No	39	DP1	10	5	Medical	2	1	Married	2	5377	3	7
EP1150	No	27	DP1	19	3	Other	4	1	Divorced	1	4066	3	7
EP1151	No	35	DP1	18	5	Life Sciences	2	1	Married	1	5208	3	16
EP1152	No	28	DP1	27	3	Medical	2	1	Divorced	0	4877	2	5
EP1153	No	21	DP1	5	1	Medical	3	4	Single	1	3117	3	2
EP1155	No	47	DP3	26	4	Life Sciences	4	3	Married	3	19658	3	5
EP1156	No	39	DP1	3	2	Medical	3	3	Divorced	0	3069	3	10
EP1157	No	40	DP1	15	3	Life Sciences	1	3	Married	1	10435	3	18
EP1158	No	35	DP1	8	4	Life Sciences	3	3	Married	1	4148	3	14
EP1159	No	37	DP1	19	3	Life Sciences	3	3	Married	3	5768	2	4
EP1160	No	39	DP1	4	3	Medical	1	3	Single	0	5042	1	9
EP1161	No	45	DP1	2	2	Other	4	4	Divorced	1	5770	3	10
EP1162	No	38	DP1	2	2	Medical	4	3	Married	3	7756	4	5
EP1164	No	37	DP1	10	3	Medical	2	2	Married	1	3936	1	8
EP1165	No	40	DP1	16	3	Life Sciences	3	4	Single	6	7945	2	4
EP1166	No	44	DP3	1	5	Human Resources	1	4	Married	4	5743	3	10
EP1167	No	48	DP1	4	5	Medical	3	4	Married	2	15202	3	2
EP1169	No	24	DP1	2	1	Technical Degree	1	4	Single	1	3760	3	6
EP1170	No	27	DP1	8	3	Medical	2	3	Married	7	3517	3	3
EP1171	No	27	DP1	2	3	Medical	4	4	Single	2	2580	2	4
EP1173	No	29	DP2	10	3	Medical	3	3	Single	9	5869	3	5
EP1174	No	36	DP1	5	4	Life Sciences	2	1	Married	4	8008	3	3
EP1175	No	25	DP1	2	1	Life Sciences	4	3	Divorced	1	5206	3	7
EP1176	No	39	DP1	12	3	Medical	4	2	Married	4	5295	3	5
EP1177	No	49	DP1	22	4	Other	1	2	Married	3	16413	3	4
EP1178	No	50	DP1	17	5	Life Sciences	4	1	Divorced	5	13269	3	14
EP1179	No	20	DP2	2	3	Medical	3	3	Single	1	2783	3	2
EP1180	No	34	DP1	3	3	Life Sciences	4	2	Divorced	1	5433	3	11
EP1181	No	36	DP1	7	3	Life Sciences	1	2	Single	2	2013	3	4
EP1182	No	49	DP1	6	1	Life Sciences	3	3	Married	2	13966	3	15
EP1183	No	36	DP1	1	4	Medical	4	3	Married	0	4374	3	3
EP1184	No	36	DP1	3	2	Life Sciences	4	1	Divorced	6	6842	3	5
EP1185	No	54	DP1	22	5	Medical	2	3	Married	3	17426	3	10
EP1186	No	43	DP1	15	2	Life Sciences	3	3	Married	1	17603	3	14
EP1188	No	38	DP1	1	3	Life Sciences	4	4	Married	7	4735	4	13
EP1189	No	29	DP2	5	3	Medical	1	2	Divorced	1	4187	2	10
EP1190	No	33	DP2	2	4	Medical	4	4	Divorced	1	5505	3	6
EP1191	No	32	DP1	2	3	Medical	4	2	Divorced	0	5470	2	9
EP1192	No	31	DP2	5	4	Life Sciences	1	4	Married	1	5476	3	10
EP1193	No	49	DP1	16	3	Medical	4	1	Divorced	4	2587	2	2
EP1194	No	38	DP1	2	3	Medical	4	2	Single	1	2440	3	4
EP1195	No	47	DP2	2	4	Life Sciences	2	2	Divorced	6	15972	3	3
EP1196	No	49	DP1	1	3	Life Sciences	3	3	Single	4	15379	3	8
EP1197	No	41	DP2	23	2	Life Sciences	4	3	Single	3	7082	3	2
EP1198	No	20	DP2	9	1	Life Sciences	4	1	Single	1	2728	3	2
EP1199	No	33	DP2	16	3	Life Sciences	3	4	Divorced	1	5368	3	6
EP1200	No	36	DP1	26	4	Life Sciences	1	3	Married	6	5347	2	3
EP1201	No	44	DP3	1	3	Life Sciences	3	4	Divorced	4	3195	3	2
EP1203	No	38	DP1	4	2	Medical	4	3	Married	7	3306	2	0
EP1204	No	53	DP1	24	4	Medical	2	4	Married	3	7005	3	4
EP1207	No	26	DP1	7	3	Medical	4	4	Single	1	2570	3	7
EP1208	No	55	DP1	22	3	Technical Degree	1	2	Divorced	5	3537	3	4
EP1209	No	34	DP1	5	2	Medical	2	4	Married	1	3986	4	15
EP1210	No	60	DP1	1	4	Medical	3	4	Divorced	3	10883	4	1
EP1211	No	33	DP1	21	3	Medical	2	2	Married	1	2028	3	14
EP1212	No	37	DP2	1	4	Medical	3	4	Divorced	1	9525	2	6
EP1213	No	34	DP1	19	3	Life Sciences	2	4	Married	1	2929	3	10
EP1215	No	44	DP1	2	3	Life Sciences	3	4	Married	1	7879	3	8
EP1216	No	35	DP1	2	4	Medical	1	4	Single	0	4930	4	5
EP1217	No	43	DP2	2	3	Medical	4	4	Married	1	7847	3	10
EP1218	No	24	DP1	9	3	Medical	3	3	Married	1	4401	3	5
EP1219	No	41	DP2	6	3	Marketing	4	3	Single	1	9241	3	10
EP1220	No	29	DP1	9	4	Medical	4	3	Married	9	2974	3	5
EP1221	No	36	DP2	2	4	Life Sciences	3	4	Single	3	4502	2	13
EP1222	No	45	DP1	1	1	Life Sciences	3	3	Married	3	10748	2	23
EP1225	No	26	DP1	17	4	Medical	4	3	Married	1	2305	4	3
EP1226	No	45	DP1	28	2	Technical Degree	4	2	Single	1	16704	3	21
EP1227	No	32	DP1	10	3	Life Sciences	1	3	Married	6	3433	2	5
EP1228	No	31	DP1	2	4	Life Sciences	2	3	Married	1	3477	4	5
EP1229	No	41	DP3	4	3	Human Resources	3	2	Married	6	6430	3	3
EP1230	No	40	DP1	8	2	Life Sciences	2	1	Married	2	6516	3	1
EP1231	No	24	DP1	29	1	Medical	2	1	Divorced	1	3907	4	6
EP1232	No	46	DP1	13	4	Life Sciences	3	2	Single	6	5562	3	10
EP1233	No	35	DP1	27	4	Life Sciences	4	3	Married	2	6883	3	7
EP1234	No	30	DP1	16	1	Life Sciences	2	4	Married	1	2862	2	10
EP1235	No	47	DP2	2	4	Marketing	3	2	Married	7	4978	1	1
EP1236	No	46	DP2	2	3	Life Sciences	3	4	Divorced	4	10368	2	10
EP1239	No	23	DP1	4	1	Medical	3	2	Single	1	3295	1	3
EP1240	No	31	DP1	24	1	Technical Degree	4	4	Single	2	5238	2	5
EP1241	No	39	DP1	1	3	Life Sciences	4	4	Married	1	6472	3	9
EP1242	No	32	DP2	19	3	Life Sciences	4	3	Married	3	9610	1	4
EP1243	No	40	DP2	7	4	Medical	2	2	Single	1	19833	2	21
EP1244	No	45	DP3	4	3	Life Sciences	3	3	Married	4	9756	4	5
EP1245	No	30	DP1	2	4	Technical Degree	4	1	Single	0	4968	3	9
EP1246	No	24	DP3	10	3	Medical	1	4	Married	0	2145	3	2
EP1248	No	31	DP2	5	3	Technical Degree	1	3	Married	1	8346	3	5
EP1249	No	27	DP1	8	3	Medical	3	4	Single	1	3445	2	6
EP1251	No	29	DP1	1	3	Life Sciences	4	3	Single	8	6294	4	3
EP1252	No	30	DP2	15	2	Marketing	3	1	Divorced	2	7140	3	7
EP1253	No	34	DP1	2	4	Medical	4	4	Married	0	2932	3	5
EP1254	No	33	DP2	2	3	Marketing	4	2	Single	8	5147	2	11
EP1255	No	49	DP2	11	4	Marketing	4	4	Single	3	4507	4	5
EP1257	No	38	DP1	2	2	Medical	3	2	Married	4	2468	2	6
EP1259	No	29	DP1	4	3	Technical Degree	4	1	Divorced	1	2109	3	1
EP1260	No	30	DP1	16	3	Life Sciences	3	3	Married	3	5294	3	7
EP1261	No	32	DP1	5	4	Technical Degree	2	2	Single	2	2718	3	7
EP1262	No	38	DP1	18	3	Medical	2	4	Married	3	5811	3	1
EP1264	No	42	DP1	12	3	Medical	2	2	Divorced	8	2766	2	5
EP1265	No	55	DP1	2	3	Medical	3	1	Married	8	19038	3	1
EP1266	No	33	DP1	4	3	Technical Degree	4	2	Divorced	5	3055	2	9
EP1267	No	41	DP1	9	4	Life Sciences	3	1	Divorced	1	2289	3	5
EP1268	No	34	DP2	10	3	Life Sciences	4	3	Divorced	1	4001	3	15
EP1269	No	53	DP1	1	4	Medical	1	3	Married	4	12965	2	3
EP1270	No	43	DP3	2	3	Life Sciences	2	4	Single	0	3539	3	9
EP1271	No	34	DP2	3	2	Life Sciences	4	4	Single	5	6029	3	2
EP1273	No	38	DP1	6	2	Other	4	3	Married	1	3702	3	5
EP1275	No	31	DP2	29	4	Marketing	1	4	Married	1	5468	3	12
EP1276	No	51	DP1	3	3	Technical Degree	1	3	Married	2	13116	3	2
EP1277	No	37	DP2	9	2	Marketing	2	2	Married	1	4189	3	5
EP1278	No	46	DP1	2	4	Medical	3	4	Divorced	7	19328	3	2
EP1279	No	36	DP1	10	3	Life Sciences	4	1	Married	7	8321	3	12
EP1281	No	37	DP3	8	2	Other	3	2	Divorced	2	4071	2	10
EP1283	No	33	DP1	8	4	Life Sciences	4	1	Married	6	3143	3	10
EP1284	No	28	DP1	1	3	Life Sciences	3	4	Married	1	2044	4	5
EP1285	No	39	DP1	10	1	Medical	3	3	Single	7	13464	3	4
EP1286	No	46	DP2	26	2	Life Sciences	2	2	Single	8	7991	3	2
EP1287	No	40	DP1	2	2	Life Sciences	3	1	Married	4	3377	2	4
EP1288	No	42	DP1	13	3	Medical	2	1	Married	5	5538	2	0
EP1289	No	35	DP1	2	2	Medical	2	4	Divorced	2	5762	3	7
EP1290	No	38	DP3	2	3	Human Resources	1	2	Divorced	5	2592	3	11
EP1293	No	39	DP2	20	3	Life Sciences	3	4	Divorced	2	4127	3	2
EP1294	No	43	DP1	9	3	Life Sciences	1	3	Single	4	2438	2	3
EP1295	No	41	DP1	5	3	Life Sciences	2	2	Single	3	6870	1	3
EP1296	No	41	DP2	4	1	Marketing	3	3	Divorced	0	10447	4	22
EP1297	No	30	DP1	10	3	Medical	1	3	Single	9	9667	3	7
EP1300	No	40	DP1	1	3	Life Sciences	3	4	Divorced	4	6513	3	5
EP1301	No	34	DP2	8	2	Technical Degree	2	3	Married	1	6799	3	10
EP1302	No	58	DP2	2	3	Medical	2	2	Divorced	4	16291	2	16
EP1303	No	35	DP1	23	4	Medical	2	3	Married	0	2705	4	5
EP1304	No	47	DP1	4	3	Life Sciences	3	2	Divorced	8	10333	3	22
EP1305	No	40	DP1	12	3	Life Sciences	2	1	Divorced	2	4448	3	7
EP1306	No	54	DP1	7	4	Medical	4	4	Married	4	6854	2	7
EP1307	No	31	DP2	7	4	Marketing	1	1	Married	2	9637	3	3
EP1308	No	28	DP1	1	3	Medical	3	1	Married	1	3591	3	3
EP1309	No	38	DP2	2	4	Marketing	2	4	Married	2	5405	2	4
EP1310	No	26	DP2	10	3	Medical	3	4	Single	1	4684	3	5
EP1311	No	58	DP1	15	4	Life Sciences	1	3	Married	2	15787	3	2
EP1312	No	18	DP1	14	3	Medical	2	3	Single	1	1514	1	0
EP1315	No	45	DP2	2	4	Life Sciences	3	3	Married	4	5154	4	8
EP1316	No	36	DP1	2	4	Other	4	2	Married	4	6962	3	1
EP1317	No	43	DP2	2	4	Life Sciences	1	4	Married	1	5675	3	7
EP1318	No	27	DP1	5	2	Life Sciences	4	4	Single	0	2379	2	5
EP1319	No	29	DP1	20	1	Medical	4	4	Married	1	3812	4	11
EP1320	No	32	DP2	10	4	Marketing	4	4	Single	8	4648	4	0
EP1321	No	42	DP1	10	4	Technical Degree	3	3	Married	3	2936	2	6
EP1322	No	47	DP1	9	4	Life Sciences	2	3	Single	4	2105	3	2
EP1323	No	46	DP1	2	2	Life Sciences	4	4	Divorced	3	8578	2	9
EP1324	No	28	DP3	1	2	Life Sciences	3	4	Divorced	1	2706	3	3
EP1325	No	29	DP1	29	1	Life Sciences	4	3	Divorced	8	6384	3	7
EP1326	No	42	DP1	8	3	Life Sciences	4	3	Single	4	3968	3	0
EP1328	No	46	DP2	3	3	Technical Degree	1	1	Divorced	2	13225	3	19
EP1329	No	27	DP2	23	1	Medical	2	3	Married	1	3540	3	9
EP1330	No	29	DP3	6	1	Medical	4	2	Married	1	2804	3	1
EP1331	No	43	DP1	6	3	Medical	1	3	Married	7	19392	3	16
EP1332	No	48	DP1	10	3	Life Sciences	4	2	Married	4	19665	3	22
EP1335	No	27	DP1	15	3	Life Sciences	4	1	Married	0	4774	2	7
EP1336	No	39	DP1	19	4	Other	4	4	Divorced	8	3902	3	2
EP1337	No	55	DP1	2	4	Technical Degree	2	4	Married	8	2662	4	5
EP1338	No	28	DP2	3	3	Medical	2	2	Married	1	2856	3	1
EP1341	No	36	DP2	10	4	Technical Degree	2	3	Married	1	5673	3	10
EP1342	No	31	DP1	20	3	Life Sciences	2	3	Divorced	1	4197	3	10
EP1343	No	34	DP2	4	3	Life Sciences	3	4	Married	2	9713	3	5
EP1344	No	29	DP1	7	3	Life Sciences	4	1	Single	3	2062	3	3
EP1345	No	37	DP1	7	4	Medical	4	1	Married	5	4284	3	5
EP1346	No	35	DP1	16	2	Other	4	2	Married	0	4788	3	3
EP1347	No	45	DP1	25	2	Life Sciences	2	4	Married	0	5906	2	9
EP1348	No	36	DP3	2	1	Human Resources	2	4	Single	1	3886	2	10
EP1349	No	40	DP1	1	4	Life Sciences	1	1	Divorced	2	16823	3	19
EP1350	No	26	DP1	1	2	Life Sciences	2	3	Married	1	2933	2	1
EP1351	No	27	DP2	2	2	Medical	1	3	Single	0	6500	2	8
EP1352	No	48	DP1	22	3	Medical	4	4	Divorced	3	17174	3	22
EP1353	No	44	DP1	1	4	Life Sciences	2	1	Married	2	5033	3	2
EP1356	No	36	DP2	17	2	Marketing	3	2	Married	2	5507	1	4
EP1357	No	41	DP2	8	3	Marketing	3	2	Married	5	4393	3	5
EP1358	No	42	DP1	6	3	Medical	3	1	Married	9	13348	4	13
EP1359	No	31	DP2	10	2	Medical	3	4	Divorced	2	6583	3	5
EP1360	No	34	DP2	3	1	Medical	4	4	Married	3	8103	2	4
EP1361	No	31	DP1	4	3	Medical	1	3	Divorced	8	3978	2	2
EP1362	No	26	DP1	6	3	Other	3	4	Married	0	2544	3	7
EP1363	No	45	DP1	1	4	Medical	2	3	Single	4	5399	3	4
EP1364	No	33	DP2	10	4	Marketing	2	3	Single	1	5487	2	10
EP1365	No	28	DP2	1	2	Life Sciences	3	4	Married	1	6834	3	7
EP1367	No	39	DP2	21	4	Life Sciences	1	3	Married	6	5736	3	3
EP1368	No	27	DP1	2	4	Technical Degree	2	2	Married	1	2226	2	5
EP1369	No	34	DP1	22	4	Other	3	4	Married	1	5747	3	15
EP1371	No	47	DP1	14	4	Technical Degree	3	2	Married	8	5467	4	8
EP1372	No	56	DP2	11	5	Marketing	4	1	Married	4	5380	3	0
EP1373	No	39	DP1	9	2	Medical	1	1	Married	1	5151	3	10
EP1374	No	38	DP1	8	3	Medical	4	2	Divorced	1	2133	3	20
EP1375	No	58	DP2	21	3	Life Sciences	4	4	Married	4	17875	2	1
EP1377	No	38	DP1	9	2	Life Sciences	2	4	Divorced	2	4771	4	5
EP1378	No	49	DP1	2	1	Life Sciences	2	4	Married	3	19161	3	5
EP1379	No	42	DP2	12	4	Marketing	2	4	Divorced	3	5087	3	0
EP1381	No	35	DP2	18	4	Medical	2	1	Married	0	5561	1	5
EP1382	No	28	DP1	16	3	Medical	3	3	Single	1	2144	2	5
EP1383	No	31	DP1	3	2	Medical	3	1	Divorced	1	3065	4	4
EP1384	No	36	DP1	9	4	Life Sciences	1	2	Married	1	2810	3	5
EP1385	No	34	DP2	1	3	Marketing	1	4	Single	1	9888	2	14
EP1386	No	34	DP2	13	4	Medical	4	3	Divorced	1	8628	2	8
EP1387	No	26	DP1	1	3	Medical	3	1	Single	0	2867	2	7
EP1388	No	29	DP1	1	3	Life Sciences	1	1	Married	0	5373	2	5
EP1389	No	32	DP1	15	4	Medical	3	4	Divorced	5	6667	3	5
EP1390	No	31	DP1	1	3	Life Sciences	4	1	Married	1	5003	3	10
EP1392	No	38	DP2	1	3	Life Sciences	1	1	Single	4	2858	2	1
EP1393	No	35	DP2	7	4	Life Sciences	3	4	Married	1	5204	3	10
EP1394	No	27	DP2	9	3	Marketing	4	4	Single	1	4105	3	7
EP1395	No	32	DP1	5	4	Life Sciences	4	4	Single	8	9679	3	1
EP1398	No	54	DP1	9	2	Life Sciences	1	3	Married	3	2897	2	4
EP1399	No	33	DP1	7	2	Life Sciences	4	3	Divorced	1	5968	3	9
EP1400	No	43	DP1	11	3	Life Sciences	1	3	Married	1	7510	3	10
EP1401	No	38	DP3	1	4	Other	4	2	Married	0	2991	3	6
EP1402	No	55	DP3	26	4	Human Resources	3	2	Married	4	19636	3	10
EP1403	No	31	DP1	2	1	Medical	4	4	Divorced	1	1129	3	1
EP1404	No	39	DP2	15	4	Marketing	2	1	Single	0	13341	3	20
EP1405	No	42	DP1	23	2	Life Sciences	4	3	Single	1	4332	3	20
EP1406	No	31	DP1	10	3	Medical	3	3	Married	4	11031	4	11
EP1407	No	54	DP1	10	3	Medical	3	1	Single	6	4440	3	5
EP1408	No	24	DP1	1	2	Life Sciences	2	3	Single	1	4617	2	4
EP1409	No	23	DP1	12	2	Other	4	4	Single	1	2647	4	5
EP1410	No	40	DP1	11	3	Technical Degree	4	3	Married	1	6323	4	10
EP1411	No	40	DP2	2	2	Marketing	2	2	Married	3	5677	3	11
EP1412	No	25	DP3	2	3	Human Resources	3	2	Married	4	2187	3	2
EP1413	No	30	DP1	1	2	Medical	4	2	Married	1	3748	2	12
EP1414	No	25	DP1	2	1	Other	4	3	Divorced	6	3977	2	2
EP1415	No	47	DP1	25	3	Medical	1	3	Single	2	8633	3	17
EP1416	No	33	DP1	1	2	Medical	2	3	Divorced	1	2008	2	1
EP1417	No	38	DP2	1	4	Life Sciences	4	2	Married	0	4440	3	15
EP1418	No	31	DP2	2	2	Life Sciences	1	3	Married	0	3067	3	2
EP1419	No	38	DP1	6	4	Life Sciences	1	3	Married	2	5321	3	8
EP1420	No	42	DP1	18	4	Life Sciences	4	1	Divorced	6	5410	2	4
EP1421	No	41	DP1	1	3	Life Sciences	4	4	Married	3	2782	3	5
EP1422	No	47	DP1	1	1	Medical	3	2	Married	0	11957	1	13
EP1423	No	35	DP1	11	4	Medical	4	3	Married	7	2660	3	2
EP1424	No	22	DP1	1	2	Life Sciences	4	3	Single	0	3375	4	3
EP1425	No	35	DP1	9	4	Medical	2	3	Single	1	5098	3	10
EP1426	No	33	DP1	15	2	Medical	2	4	Married	0	4878	3	9
EP1427	No	32	DP1	29	4	Life Sciences	3	2	Single	1	2837	3	6
EP1428	No	40	DP1	1	4	Life Sciences	1	4	Married	8	2406	2	1
EP1429	No	32	DP2	1	4	Medical	2	2	Married	0	2269	3	2
EP1430	No	39	DP1	24	1	Life Sciences	1	4	Single	7	4108	3	7
EP1431	No	38	DP1	10	3	Medical	2	3	Married	3	13206	3	18
EP1432	No	32	DP2	1	4	Marketing	3	4	Married	1	10422	3	14
EP1433	No	37	DP1	10	3	Life Sciences	3	4	Married	1	13744	3	16
EP1434	No	25	DP2	8	2	Other	1	3	Divorced	0	4907	2	5
EP1435	No	52	DP2	29	4	Life Sciences	1	4	Divorced	2	3482	2	9
EP1436	No	44	DP1	1	3	Medical	2	4	Single	6	2436	3	4
EP1437	No	21	DP2	5	1	Medical	3	1	Single	1	2380	3	2
EP1438	No	39	DP1	9	3	Life Sciences	4	4	Single	2	19431	2	6
EP1440	No	36	DP2	3	3	Medical	1	4	Married	0	7644	3	9
EP1441	No	36	DP1	4	2	Life Sciences	4	2	Divorced	7	5131	3	4
EP1442	No	56	DP1	1	4	Life Sciences	3	3	Divorced	1	6306	2	13
EP1444	No	42	DP1	2	3	Life Sciences	1	3	Married	5	18880	2	22
EP1446	No	41	DP1	28	4	Life Sciences	1	2	Married	0	13570	3	20
EP1447	No	34	DP2	28	3	Marketing	4	3	Married	1	6712	3	8
EP1448	No	36	DP2	15	4	Marketing	4	4	Divorced	1	5406	2	15
EP1449	No	41	DP2	3	3	Life Sciences	3	2	Divorced	2	8938	3	5
EP1450	No	32	DP1	2	3	Technical Degree	4	1	Single	1	2439	3	4
EP1451	No	35	DP3	26	4	Life Sciences	3	4	Single	1	8837	3	9
EP1452	No	38	DP2	10	2	Life Sciences	1	4	Married	1	5343	3	10
EP1454	No	36	DP2	11	4	Marketing	2	4	Married	4	6652	2	6
EP1455	No	45	DP2	20	3	Life Sciences	4	3	Single	8	4850	3	5
EP1456	No	40	DP1	2	4	Life Sciences	3	3	Single	2	2809	3	2
EP1457	No	35	DP1	18	4	Life Sciences	3	3	Married	1	5689	4	10
EP1458	No	40	DP1	2	4	Medical	3	3	Married	2	2001	3	5
EP1459	No	35	DP1	1	4	Life Sciences	3	4	Married	1	2977	3	4
EP1460	No	29	DP1	13	2	Other	4	2	Married	4	4025	3	4
EP1461	No	29	DP1	28	4	Medical	4	1	Single	1	3785	1	5
EP1463	No	39	DP2	24	1	Marketing	2	4	Married	0	12031	2	20
EP1464	No	31	DP1	5	3	Medical	2	1	Single	0	9936	3	9
EP1465	No	26	DP2	5	3	Other	4	3	Single	0	2966	3	4
EP1466	No	36	DP1	23	2	Medical	3	4	Married	4	2571	3	5
EP1467	No	39	DP1	6	1	Medical	4	1	Married	4	9991	3	7
EP1468	No	27	DP1	4	3	Life Sciences	2	2	Married	1	6142	3	6
EP1469	No	49	DP2	2	3	Medical	4	2	Married	2	5390	2	9
EP1470	No	34	DP1	8	3	Medical	2	3	Married	2	4404	4	4
\.


--
-- Data for Name: employee_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_history (employee_id, mod_action, mod_date, attrition, age, department_id, dist_from_home, edu, edu_field, env_sat, job_sat, marital_sts, num_comp_worked, salary, wlb, years_at_comp) FROM stdin;
EP0001	delete	2022-12-06	Yes	41	DP2	1	2	Life Sciences	2	4	Single	8	5993	1	6
EP0002	update	2023-01-03	No	49	DP1	8	1	Life Sciences	3	2	Married	1	5130	3	10
EP0003	delete	2022-12-06	Yes	37	DP1	2	2	Other	4	3	Single	6	2090	3	0
EP0015	delete	2022-12-06	Yes	28	DP1	24	3	Life Sciences	3	3	Single	5	2028	3	4
EP0022	delete	2022-12-06	Yes	36	DP2	9	4	Life Sciences	3	1	Single	7	3407	3	5
EP0025	delete	2022-12-06	Yes	34	DP1	6	1	Medical	2	1	Single	2	2960	3	4
EP0027	delete	2022-12-06	Yes	32	DP1	16	1	Life Sciences	2	1	Single	1	3919	3	10
EP0034	delete	2022-12-06	Yes	39	DP2	5	3	Technical Degree	4	4	Married	3	2086	4	1
EP0035	delete	2022-12-06	Yes	24	DP1	1	3	Medical	2	4	Married	2	2293	2	2
EP0037	delete	2022-12-06	Yes	50	DP2	3	2	Marketing	1	3	Married	1	2683	3	3
EP0043	delete	2022-12-06	Yes	26	DP1	25	3	Life Sciences	1	3	Single	1	2293	2	1
EP0046	delete	2022-12-06	Yes	41	DP1	12	3	Technical Degree	2	3	Married	1	19545	3	22
EP0051	delete	2022-12-06	Yes	48	DP1	1	2	Life Sciences	1	3	Single	9	5381	3	1
EP0052	delete	2022-12-06	Yes	28	DP1	5	4	Technical Degree	3	3	Single	1	3441	2	2
EP0070	delete	2022-12-06	Yes	36	DP1	9	3	Medical	4	3	Married	0	3388	2	1
EP0090	delete	2022-12-06	Yes	46	DP2	9	2	Medical	3	4	Single	1	9619	3	9
EP0101	delete	2022-12-06	Yes	37	DP3	6	4	Human Resources	3	1	Divorced	4	2073	3	3
EP0103	delete	2022-12-06	Yes	20	DP1	6	3	Life Sciences	4	4	Single	1	2926	3	1
EP0108	delete	2022-12-06	Yes	25	DP2	5	3	Marketing	3	3	Single	1	5744	3	6
EP0112	delete	2022-12-06	Yes	34	DP1	7	3	Life Sciences	1	3	Single	1	6074	3	9
EP0123	delete	2022-12-06	Yes	56	DP1	14	4	Life Sciences	2	2	Married	9	4963	3	5
EP0125	delete	2022-12-06	Yes	31	DP2	6	4	Life Sciences	2	3	Married	4	6172	2	7
EP0127	delete	2022-12-06	Yes	58	DP1	23	4	Medical	4	4	Married	1	10312	2	40
EP0128	delete	2022-12-06	Yes	19	DP2	22	1	Marketing	4	3	Single	1	1675	2	0
EP0133	delete	2022-12-06	Yes	31	DP2	20	3	Life Sciences	2	3	Married	3	4559	3	2
EP0137	delete	2022-12-06	Yes	51	DP1	8	4	Life Sciences	1	4	Single	2	10650	3	4
EP0141	delete	2022-12-06	Yes	32	DP1	9	3	Medical	1	1	Single	7	4200	4	5
EP0172	delete	2022-12-06	Yes	19	DP2	1	1	Technical Degree	3	1	Single	0	2325	4	0
EP0178	delete	2022-12-06	Yes	19	DP1	2	3	Life Sciences	2	4	Single	1	1102	2	1
EP0183	delete	2022-12-06	Yes	41	DP2	20	2	Marketing	2	2	Single	1	3140	2	4
EP0193	delete	2022-12-06	Yes	35	DP1	23	2	Life Sciences	2	3	Married	3	5916	3	1
EP0205	delete	2022-12-06	Yes	38	DP1	29	1	Medical	2	1	Married	7	6673	3	1
EP0206	delete	2022-12-06	Yes	29	DP2	27	3	Marketing	2	4	Married	1	7639	2	10
EP0211	delete	2022-12-06	Yes	32	DP2	4	4	Medical	4	4	Married	1	10400	2	14
EP0215	delete	2022-12-06	Yes	30	DP1	3	3	Technical Degree	4	1	Single	5	2657	3	5
EP0217	delete	2022-12-06	Yes	30	DP2	26	4	Marketing	3	1	Single	5	6696	2	6
EP0218	delete	2022-12-06	Yes	29	DP1	1	3	Technical Degree	3	3	Single	0	2058	2	6
EP0230	delete	2022-12-06	Yes	29	DP1	18	1	Medical	3	4	Single	1	2389	2	4
EP0235	delete	2022-12-06	Yes	33	DP1	14	3	Medical	3	4	Married	5	2436	1	5
EP0237	delete	2022-12-06	Yes	33	DP1	2	2	Life Sciences	1	1	Married	7	2707	4	9
EP0240	delete	2022-12-06	Yes	32	DP1	1	3	Life Sciences	4	3	Single	0	3730	1	3
EP0251	delete	2022-12-06	Yes	37	DP1	10	3	Medical	1	3	Divorced	6	10048	3	1
EP0260	delete	2022-12-06	Yes	31	DP1	29	2	Medical	3	2	Single	0	3479	4	5
EP0265	delete	2022-12-06	Yes	28	DP1	2	4	Life Sciences	1	3	Single	2	3485	1	0
EP0272	delete	2022-12-06	Yes	47	DP1	29	4	Life Sciences	1	2	Married	1	11849	2	10
EP0287	delete	2022-12-06	Yes	44	DP1	24	3	Life Sciences	4	3	Divorced	3	3161	1	1
EP0289	delete	2022-12-06	Yes	26	DP1	16	4	Medical	1	2	Divorced	2	2373	3	3
EP0294	delete	2022-12-06	Yes	26	DP2	4	4	Marketing	4	4	Single	1	5828	3	8
EP0297	delete	2022-12-06	Yes	18	DP1	3	3	Life Sciences	3	3	Single	1	1420	3	0
EP0318	delete	2022-12-06	Yes	52	DP1	8	4	Medical	3	2	Married	2	4941	2	8
EP0324	delete	2022-12-06	Yes	28	DP1	2	4	Medical	1	4	Married	5	3464	2	3
EP0328	delete	2022-12-06	Yes	39	DP2	3	2	Medical	4	3	Married	4	5238	2	1
EP0337	delete	2022-12-06	Yes	29	DP1	8	4	Other	2	1	Married	1	2119	2	7
EP0358	delete	2022-12-06	Yes	21	DP2	1	1	Technical Degree	1	2	Single	1	2174	3	3
EP0364	delete	2022-12-06	Yes	33	DP2	5	3	Marketing	4	3	Single	1	2851	3	1
EP0367	delete	2022-12-06	Yes	41	DP2	4	3	Marketing	1	2	Single	1	9355	3	8
EP0369	delete	2022-12-06	Yes	40	DP2	22	2	Marketing	3	3	Married	2	6380	3	6
EP0371	delete	2022-12-06	Yes	21	DP2	12	3	Life Sciences	3	2	Single	1	2716	3	1
EP0379	delete	2022-12-06	Yes	34	DP2	19	3	Marketing	1	4	Single	8	5304	2	5
EP0383	delete	2022-12-06	Yes	26	DP1	3	1	Technical Degree	3	1	Single	0	3102	3	6
EP0386	delete	2022-12-06	Yes	30	DP1	4	3	Technical Degree	3	4	Single	9	2285	3	1
EP0406	delete	2022-12-06	Yes	25	DP1	3	3	Medical	1	1	Married	5	4031	3	2
EP0415	delete	2022-12-06	Yes	24	DP2	1	1	Technical Degree	1	2	Single	1	3202	3	5
EP0416	delete	2022-12-06	Yes	34	DP2	6	2	Marketing	4	3	Divorced	0	2351	2	2
EP0422	delete	2022-12-06	Yes	29	DP1	25	5	Technical Degree	3	2	Married	5	2546	4	2
EP0423	delete	2022-12-06	Yes	19	DP3	2	2	Technical Degree	1	4	Single	1	2564	4	1
EP0436	delete	2022-12-06	Yes	33	DP1	15	1	Medical	2	3	Married	7	13610	4	7
EP0437	delete	2022-12-06	Yes	33	DP1	10	1	Medical	1	4	Divorced	7	3408	3	4
EP0440	delete	2022-12-06	Yes	31	DP1	20	3	Life Sciences	1	3	Married	3	9824	3	1
EP0441	delete	2022-12-06	Yes	34	DP3	23	3	Human Resources	2	1	Divorced	9	9950	3	3
EP0444	delete	2022-12-06	Yes	22	DP1	4	1	Technical Degree	3	3	Single	5	3894	3	2
EP0454	delete	2022-12-06	Yes	26	DP3	17	4	Life Sciences	2	3	Divorced	0	2741	2	7
EP0458	delete	2022-12-06	Yes	18	DP2	5	3	Marketing	2	2	Single	1	1878	3	0
EP0464	delete	2022-12-06	Yes	26	DP1	24	3	Technical Degree	3	4	Single	1	2340	1	1
EP0470	delete	2022-12-06	Yes	32	DP2	11	4	Other	4	3	Married	8	4707	3	4
EP0480	delete	2022-12-06	Yes	24	DP1	7	3	Life Sciences	1	3	Married	1	2886	3	6
EP0481	delete	2022-12-06	Yes	30	DP2	12	4	Life Sciences	2	1	Married	1	2033	4	1
EP0483	delete	2022-12-06	Yes	31	DP2	13	4	Medical	2	1	Divorced	2	4233	1	3
EP0496	delete	2022-12-06	Yes	27	DP2	2	1	Marketing	3	1	Divorced	0	3041	3	4
EP0505	delete	2022-12-06	Yes	45	DP2	26	4	Life Sciences	1	1	Married	2	4286	3	1
EP0514	delete	2022-12-06	Yes	20	DP1	10	1	Medical	4	3	Single	1	1009	3	1
EP0515	delete	2022-12-06	Yes	33	DP1	3	3	Life Sciences	1	1	Single	1	3348	3	10
EP0526	delete	2022-12-06	Yes	24	DP2	3	2	Life Sciences	1	3	Single	9	4577	3	2
EP0529	delete	2022-12-06	Yes	50	DP2	8	2	Technical Degree	2	3	Married	3	6796	3	4
EP0541	delete	2022-12-06	Yes	28	DP1	1	2	Life Sciences	1	2	Single	7	2216	3	7
EP0548	delete	2022-12-06	Yes	42	DP1	19	3	Medical	3	3	Divorced	6	2759	3	2
EP0563	delete	2022-12-06	Yes	33	DP1	1	4	Other	4	4	Single	1	2686	2	10
EP0567	delete	2022-12-06	Yes	47	DP2	27	2	Life Sciences	2	3	Single	4	6397	3	5
EP0569	delete	2022-12-06	Yes	55	DP1	2	3	Medical	4	1	Married	5	19859	3	5
EP0574	delete	2022-12-06	Yes	26	DP2	8	3	Technical Degree	4	1	Single	6	5326	2	4
EP0586	delete	2022-12-06	Yes	23	DP1	6	3	Life Sciences	3	1	Married	1	1601	3	0
EP0590	delete	2022-12-06	Yes	29	DP1	1	2	Life Sciences	2	1	Married	1	2319	3	1
EP0592	delete	2022-12-06	Yes	33	DP2	16	3	Marketing	1	1	Single	5	5324	3	3
EP0596	delete	2022-12-06	Yes	58	DP1	2	4	Life Sciences	4	2	Single	7	19246	3	31
EP0599	delete	2022-12-06	Yes	28	DP1	2	4	Medical	3	3	Single	6	4382	2	2
EP0608	delete	2022-12-06	Yes	49	DP2	11	3	Marketing	3	4	Married	1	7654	4	9
EP0609	delete	2022-12-06	Yes	55	DP2	2	1	Medical	3	4	Single	4	5160	2	9
EP0615	delete	2022-12-06	Yes	26	DP1	5	2	Medical	3	3	Married	1	2366	3	8
EP0637	delete	2022-12-06	Yes	35	DP1	25	4	Life Sciences	4	2	Divorced	1	2022	2	10
EP0646	delete	2022-12-06	Yes	29	DP2	1	3	Medical	2	3	Divorced	6	2800	3	3
EP0657	delete	2022-12-06	Yes	32	DP1	25	4	Life Sciences	1	4	Single	1	2795	1	1
EP0661	delete	2022-12-06	Yes	58	DP1	2	1	Life Sciences	4	4	Divorced	9	2380	2	1
EP0663	delete	2022-12-06	Yes	20	DP2	2	3	Medical	3	3	Single	1	2044	2	2
EP0664	delete	2022-12-06	Yes	21	DP1	18	1	Other	4	4	Single	1	2693	2	1
EP0667	delete	2022-12-06	Yes	22	DP1	3	1	Life Sciences	2	3	Married	0	4171	4	3
EP0668	delete	2022-12-06	Yes	41	DP1	2	4	Life Sciences	2	4	Divorced	4	2778	2	7
EP0670	delete	2022-12-06	Yes	39	DP1	6	3	Medical	4	1	Married	7	2404	1	2
EP0684	delete	2022-12-06	Yes	25	DP2	19	2	Marketing	3	2	Married	1	2413	3	1
EP0689	delete	2022-12-06	Yes	19	DP2	21	3	Other	4	2	Single	1	2121	4	1
EP0690	delete	2022-12-06	Yes	20	DP1	4	3	Technical Degree	1	1	Single	1	2973	3	1
EP0694	delete	2022-12-06	Yes	36	DP2	3	1	Life Sciences	3	4	Married	1	10325	3	16
EP0696	delete	2022-12-06	Yes	37	DP2	1	4	Life Sciences	1	3	Married	5	10609	1	14
EP0701	delete	2022-12-06	Yes	58	DP1	2	3	Technical Degree	4	3	Single	4	2479	3	1
EP0707	delete	2022-12-06	Yes	40	DP2	24	3	Life Sciences	2	2	Single	4	13194	2	1
EP0710	delete	2022-12-06	Yes	31	DP1	9	2	Medical	3	1	Single	0	2321	3	3
EP0712	delete	2022-12-06	Yes	29	DP1	10	3	Life Sciences	4	1	Single	6	2404	3	0
EP0721	delete	2022-12-06	Yes	30	DP1	22	3	Life Sciences	1	3	Married	4	2132	3	5
EP0726	delete	2022-12-06	Yes	35	DP1	14	4	Other	3	2	Divorced	1	3743	1	4
EP0732	delete	2022-12-06	Yes	20	DP1	11	3	Medical	4	1	Single	1	2600	3	1
EP0733	delete	2022-12-06	Yes	30	DP1	5	3	Medical	2	2	Single	0	2422	3	3
EP0745	delete	2022-12-06	Yes	37	DP1	11	2	Medical	1	2	Married	5	4777	1	1
EP0749	delete	2022-12-06	Yes	26	DP2	29	2	Medical	2	1	Single	8	4969	3	2
EP0750	delete	2022-12-06	Yes	52	DP2	2	1	Marketing	1	4	Married	1	19845	3	32
EP0753	delete	2022-12-06	Yes	36	DP1	16	4	Life Sciences	3	1	Single	1	2743	3	17
EP0762	delete	2022-12-06	Yes	36	DP1	15	3	Other	1	3	Divorced	7	4834	2	1
EP0763	delete	2022-12-06	Yes	26	DP1	2	3	Life Sciences	1	1	Married	6	2042	3	3
EP0777	delete	2022-12-06	Yes	20	DP2	9	3	Marketing	4	4	Single	1	2323	3	2
EP0778	delete	2022-12-06	Yes	21	DP1	10	3	Life Sciences	3	1	Single	1	1416	2	1
EP0780	delete	2022-12-06	Yes	51	DP1	4	4	Life Sciences	1	3	Married	9	2461	4	10
EP0781	delete	2022-12-06	Yes	28	DP1	24	2	Technical Degree	2	1	Single	1	8722	2	10
EP0790	delete	2022-12-06	Yes	44	DP3	1	2	Medical	2	1	Married	9	10482	3	20
EP0792	delete	2022-12-06	Yes	35	DP2	4	3	Technical Degree	4	1	Single	0	9582	3	8
EP0793	delete	2022-12-06	Yes	33	DP1	29	4	Medical	1	3	Single	1	4508	3	13
EP0797	delete	2022-12-06	Yes	25	DP1	4	1	Technical Degree	4	4	Married	1	3691	4	7
EP0798	delete	2022-12-06	Yes	26	DP1	21	3	Medical	1	3	Divorced	1	2377	2	1
EP0799	delete	2022-12-06	Yes	33	DP1	25	3	Medical	1	2	Single	4	2313	3	2
EP0801	delete	2022-12-06	Yes	28	DP1	1	3	Medical	1	2	Divorced	1	2596	3	1
EP0802	delete	2022-12-06	Yes	50	DP2	1	4	Other	4	3	Single	3	4728	3	0
EP0814	delete	2022-12-06	Yes	39	DP1	2	3	Life Sciences	1	4	Divorced	7	12169	3	18
EP0829	delete	2022-12-06	Yes	18	DP1	8	1	Medical	3	3	Single	1	1904	3	0
EP0830	delete	2022-12-06	Yes	33	DP2	9	4	Marketing	1	1	Single	0	8224	3	5
EP0832	delete	2022-12-06	Yes	31	DP1	15	3	Medical	3	3	Married	1	2610	2	2
EP0837	delete	2022-12-06	Yes	29	DP2	23	1	Life Sciences	4	1	Married	1	7336	1	11
EP0839	delete	2022-12-06	Yes	42	DP2	12	3	Life Sciences	3	1	Single	0	13758	2	21
EP0843	delete	2022-12-06	Yes	28	DP1	12	1	Life Sciences	3	4	Married	1	2515	2	1
EP0850	delete	2022-12-06	Yes	43	DP2	9	3	Marketing	1	3	Single	8	5346	2	4
EP0858	delete	2022-12-06	Yes	44	DP1	10	4	Life Sciences	3	3	Single	1	2936	3	6
EP0861	delete	2022-12-06	Yes	22	DP1	3	4	Life Sciences	3	4	Married	0	2853	3	0
EP0865	delete	2022-12-06	Yes	41	DP1	5	2	Life Sciences	1	1	Divorced	6	2107	1	1
EP0872	delete	2022-12-06	Yes	24	DP1	17	2	Life Sciences	4	2	Married	1	2210	1	1
EP0893	delete	2022-12-06	Yes	19	DP1	10	3	Medical	1	2	Single	1	1859	4	1
EP0912	delete	2022-12-06	Yes	25	DP2	24	1	Life Sciences	3	4	Single	1	1118	3	1
EP0914	delete	2022-12-06	Yes	45	DP2	2	3	Marketing	1	2	Single	2	18824	3	24
EP0916	delete	2022-12-06	Yes	21	DP1	10	2	Life Sciences	1	3	Single	1	2625	1	2
EP0929	delete	2022-12-06	Yes	44	DP1	15	3	Medical	1	4	Married	1	7978	3	10
EP0933	delete	2022-12-06	Yes	29	DP1	7	3	Technical Degree	2	3	Divorced	3	3339	3	7
EP0940	delete	2022-12-06	Yes	32	DP1	7	2	Life Sciences	4	3	Married	1	4883	3	10
EP0941	delete	2022-12-06	Yes	39	DP1	23	3	Medical	3	1	Single	0	3904	3	5
EP0947	delete	2022-12-06	Yes	40	DP2	25	4	Marketing	4	2	Single	2	9094	3	5
EP0948	delete	2022-12-06	Yes	52	DP2	5	3	Life Sciences	2	2	Single	9	8446	2	8
EP0953	delete	2022-12-06	Yes	31	DP2	1	3	Life Sciences	4	2	Single	1	2302	4	3
EP0954	delete	2022-12-06	Yes	44	DP1	3	3	Life Sciences	1	1	Married	4	2362	4	3
EP0967	delete	2022-12-06	Yes	58	DP1	7	4	Medical	3	1	Married	7	10008	2	10
EP0976	delete	2022-12-06	Yes	55	DP2	13	4	Marketing	1	3	Single	6	13695	2	19
EP0981	delete	2022-12-06	Yes	31	DP2	2	3	Life Sciences	3	4	Single	7	2785	4	1
EP0982	delete	2022-12-06	Yes	35	DP2	18	4	Marketing	4	3	Married	0	4614	2	4
EP0986	delete	2022-12-06	Yes	31	DP1	22	4	Medical	4	3	Married	1	6179	2	10
EP0998	delete	2022-12-06	Yes	27	DP1	17	4	Life Sciences	4	3	Single	1	2394	3	8
EP1007	delete	2022-12-06	Yes	49	DP1	28	2	Life Sciences	1	1	Single	3	4284	3	4
EP1008	delete	2022-12-06	Yes	29	DP1	14	1	Other	3	4	Single	0	7553	3	8
EP1013	delete	2022-12-06	Yes	31	DP2	1	4	Life Sciences	2	3	Single	1	1359	3	1
EP1017	delete	2022-12-06	Yes	31	DP1	8	3	Life Sciences	1	2	Single	1	1261	4	1
EP1022	delete	2022-12-06	Yes	25	DP2	9	2	Life Sciences	1	1	Married	3	4400	3	3
EP1032	delete	2022-12-06	Yes	46	DP2	9	3	Marketing	1	4	Divorced	4	10096	4	7
EP1033	delete	2022-12-06	Yes	39	DP1	2	3	Life Sciences	1	1	Single	2	3646	4	1
EP1034	delete	2022-12-06	Yes	31	DP1	1	5	Life Sciences	3	2	Single	1	7446	3	10
EP1037	delete	2022-12-06	Yes	31	DP1	2	3	Life Sciences	2	4	Married	6	3722	1	2
EP1040	delete	2022-12-06	Yes	34	DP3	9	4	Technical Degree	1	3	Married	1	2742	3	2
EP1057	delete	2022-12-06	Yes	28	DP2	1	3	Technical Degree	1	3	Married	3	2909	4	3
EP1058	delete	2022-12-06	Yes	29	DP2	13	3	Technical Degree	1	2	Single	5	5765	1	5
EP1059	delete	2022-12-06	Yes	34	DP2	24	4	Medical	1	2	Single	0	4599	4	15
EP1061	delete	2022-12-06	Yes	24	DP1	9	3	Medical	2	1	Single	2	3172	2	0
EP1069	delete	2022-12-06	Yes	28	DP1	2	2	Medical	3	1	Single	7	2561	2	0
EP1078	delete	2022-12-06	Yes	29	DP1	1	4	Technical Degree	1	1	Single	6	2362	1	9
EP1084	delete	2022-12-06	Yes	40	DP1	9	4	Life Sciences	4	1	Single	3	2018	1	5
EP1086	delete	2022-12-06	Yes	31	DP1	3	3	Life Sciences	4	3	Single	1	4084	1	7
EP1107	delete	2022-12-06	Yes	30	DP2	1	3	Life Sciences	2	1	Married	1	9714	3	10
EP1111	delete	2022-12-06	Yes	35	DP1	2	3	Life Sciences	1	1	Divorced	1	2074	3	1
EP1112	delete	2022-12-06	Yes	53	DP1	2	5	Technical Degree	3	4	Married	0	10169	3	33
EP1113	delete	2022-12-06	Yes	38	DP1	2	3	Medical	3	2	Married	4	4855	3	5
EP1137	delete	2022-12-06	Yes	28	DP1	24	3	Medical	3	2	Married	1	2408	3	1
EP1154	delete	2022-12-06	Yes	18	DP2	3	2	Medical	2	4	Single	1	1569	4	0
EP1163	delete	2022-12-06	Yes	35	DP2	10	3	Medical	4	1	Married	9	10306	3	13
EP1168	delete	2022-12-06	Yes	35	DP2	15	2	Medical	1	4	Divorced	6	5440	2	2
EP1172	delete	2022-12-06	Yes	40	DP1	7	3	Life Sciences	1	1	Single	3	2166	1	4
EP1187	delete	2022-12-06	Yes	35	DP2	12	4	Other	4	4	Single	3	4581	4	11
EP1202	delete	2022-12-06	Yes	23	DP1	8	1	Medical	4	3	Single	1	3989	3	5
EP1205	delete	2022-12-06	Yes	48	DP2	7	2	Medical	4	3	Married	2	2655	3	9
EP1206	delete	2022-12-06	Yes	32	DP1	2	4	Life Sciences	4	2	Single	1	1393	3	1
EP1214	delete	2022-12-06	Yes	23	DP2	7	3	Life Sciences	3	4	Divorced	1	2275	3	3
EP1223	delete	2022-12-06	Yes	24	DP3	22	1	Human Resources	4	3	Married	1	1555	3	1
EP1224	delete	2022-12-06	Yes	47	DP2	9	3	Life Sciences	3	3	Married	7	12936	1	23
EP1237	delete	2022-12-06	Yes	36	DP2	13	5	Marketing	2	1	Divorced	5	6134	3	2
EP1238	delete	2022-12-06	Yes	32	DP2	1	2	Life Sciences	1	2	Single	6	6735	3	0
EP1247	delete	2022-12-06	Yes	30	DP3	8	3	Human Resources	3	4	Divorced	6	2180	2	4
EP1250	delete	2022-12-06	Yes	29	DP2	9	3	Marketing	2	2	Single	1	2760	3	2
EP1256	delete	2022-12-06	Yes	33	DP2	16	3	Life Sciences	1	1	Single	2	8564	2	0
EP1258	delete	2022-12-06	Yes	31	DP2	16	4	Marketing	1	3	Married	2	8161	3	1
EP1263	delete	2022-12-06	Yes	43	DP1	17	3	Technical Degree	3	3	Married	9	2437	3	1
EP1272	delete	2022-12-06	Yes	21	DP2	7	1	Marketing	2	2	Single	1	2679	3	1
EP1274	delete	2022-12-06	Yes	22	DP1	8	1	Medical	3	1	Married	1	2398	3	1
EP1280	delete	2022-12-06	Yes	44	DP1	1	2	Medical	3	2	Divorced	1	2342	2	5
EP1282	delete	2022-12-06	Yes	35	DP2	27	3	Life Sciences	3	4	Single	1	5813	3	10
EP1291	delete	2022-12-06	Yes	34	DP1	9	4	Life Sciences	4	1	Married	4	5346	2	7
EP1292	delete	2022-12-06	Yes	37	DP1	10	4	Medical	4	1	Single	1	4213	1	10
EP1298	delete	2022-12-06	Yes	26	DP3	20	2	Medical	4	2	Married	0	2148	3	5
EP1299	delete	2022-12-06	Yes	46	DP1	21	2	Medical	4	2	Married	4	8926	4	9
EP1313	delete	2022-12-06	Yes	31	DP3	18	5	Human Resources	4	1	Married	0	2956	3	1
EP1314	delete	2022-12-06	Yes	29	DP3	13	3	Human Resources	1	1	Divorced	4	2335	3	2
EP1327	delete	2022-12-06	Yes	32	DP2	2	4	Marketing	3	2	Single	7	9907	2	2
EP1333	delete	2022-12-06	Yes	29	DP1	24	2	Life Sciences	4	4	Single	1	2439	2	1
EP1334	delete	2022-12-06	Yes	46	DP2	10	3	Life Sciences	3	2	Married	5	7314	3	8
EP1339	delete	2022-12-06	Yes	30	DP2	9	3	Medical	2	4	Single	1	1081	2	1
EP1340	delete	2022-12-06	Yes	22	DP1	7	1	Life Sciences	4	2	Single	1	2472	3	1
EP1354	delete	2022-12-06	Yes	34	DP1	16	4	Technical Degree	4	1	Married	1	2307	3	5
EP1355	delete	2022-12-06	Yes	56	DP1	24	2	Life Sciences	1	4	Single	1	2587	3	4
EP1366	delete	2022-12-06	Yes	29	DP2	24	3	Technical Degree	3	1	Single	1	1091	3	1
EP1370	delete	2022-12-06	Yes	28	DP2	13	2	Marketing	4	3	Single	3	9854	3	2
EP1376	delete	2022-12-06	Yes	32	DP1	5	2	Life Sciences	1	3	Single	3	2432	3	4
EP1380	delete	2022-12-06	Yes	27	DP3	22	3	Human Resources	1	2	Married	1	2863	3	1
EP1391	delete	2022-12-06	Yes	28	DP1	17	3	Technical Degree	3	4	Divorced	5	2367	2	4
EP1396	delete	2022-12-06	Yes	31	DP2	26	4	Marketing	1	4	Married	1	5617	3	10
EP1397	delete	2022-12-06	Yes	53	DP2	24	4	Life Sciences	1	1	Single	6	10448	2	2
EP1439	delete	2022-12-06	Yes	23	DP2	9	3	Marketing	4	1	Married	1	1790	2	1
EP1443	delete	2022-12-06	Yes	29	DP1	1	4	Medical	1	4	Married	9	4787	4	2
EP1445	delete	2022-12-06	Yes	56	DP1	7	2	Technical Degree	4	3	Married	8	2339	1	10
EP1453	delete	2022-12-06	Yes	50	DP2	1	4	Life Sciences	2	3	Divorced	7	6728	3	6
EP1462	delete	2022-12-06	Yes	50	DP2	28	3	Marketing	4	1	Divorced	4	10854	3	3
\.


--
-- Data for Name: sys_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_user (id, name, type, username, password) FROM stdin;
US1	Fajar Waskito	admin	fwaskito	fwaskito123
US2	-	-	anon	anon123
\.


--
-- Name: department idx_16640_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT idx_16640_primary PRIMARY KEY (id);


--
-- Name: employee idx_16643_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT idx_16643_primary PRIMARY KEY (id);


--
-- Name: employee_history idx_16646_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_history
    ADD CONSTRAINT idx_16646_primary PRIMARY KEY (employee_id, mod_action);


--
-- Name: sys_user idx_16650_primary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT idx_16650_primary PRIMARY KEY (id);


--
-- Name: idx_16643_fk_employee_department_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_16643_fk_employee_department_id ON public.employee USING btree (department_id);


--
-- Name: idx_16646_fk_employee_history_department_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_16646_fk_employee_history_department_id ON public.employee_history USING btree (department_id);


--
-- Name: employee employee_bd; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER employee_bd BEFORE DELETE ON public.employee FOR EACH ROW EXECUTE FUNCTION public.act_employee_bd();


--
-- Name: employee employee_bu; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER employee_bu BEFORE UPDATE ON public.employee FOR EACH ROW EXECUTE FUNCTION public.act_employee_bu();


--
-- Name: employee fk_employee_department_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT fk_employee_department_id FOREIGN KEY (department_id) REFERENCES public.department(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employee_history fk_employee_history_department_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_history
    ADD CONSTRAINT fk_employee_history_department_id FOREIGN KEY (department_id) REFERENCES public.department(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

