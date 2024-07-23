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
-- Name: act_employee_bd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.act_employee_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO employee_history
		SELECT 	e.id, 'delete',
				current_date, 'Yes',
				e.age, e.department_id,
				e.dist_from_home, e.education,
				e.education_field, e.env_satisfaction,
				e.job_satisfaction, e.marital_status,
				e.num_comp_worked, e.monthly_income,
				e.work_life_balance, e.years_at_company
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
		AND modif_action='update'
		AND EXISTS (SELECT r_count
					FROM (SELECT count(*) r_count
						  FROM employee_history
						  WHERE employee_id = old.id
						  	  AND modif_action='update')
					AS t);

    INSERT INTO employee_history
		SELECT 	e.id, 'update',
				current_date, 'No',
				e.age, e.department_id,
				e.dist_from_home, e.education,
				e.education_field, e.env_satisfaction,
				e.job_satisfaction, e.marital_status,
				e.num_comp_worked, e.monthly_income,
				e.work_life_balance, e.years_at_company
		FROM employee AS e
        WHERE e.id = old.id;

	RETURN new;
END;
$$;


ALTER FUNCTION public.act_employee_bu() OWNER TO postgres;

--
-- Name: add_employee(character varying, character varying, integer, character varying, integer, integer, character varying, integer, integer, character varying, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_employee(p_id character varying, p_attrition character varying, p_age integer, p_department_id character varying, p_dist_from_home integer, p_education integer, p_education_field character varying, p_env_satisfaction integer, p_job_satisfaction integer, p_marital_status character varying, p_num_comp_worked integer, p_monthly_income integer, p_work_life_balance integer, p_years_at_company integer) RETURNS void
    LANGUAGE sql
    AS $$
	INSERT INTO employee
	VALUES (p_id, p_attrition,
			p_age, p_department_id,
			p_dist_from_home, p_education,
			p_education_field, p_env_satisfaction,
			p_job_satisfaction, p_marital_status,
			p_num_comp_worked, p_monthly_income,
			p_work_life_balance, p_years_at_company);
$$;


ALTER FUNCTION public.add_employee(p_id character varying, p_attrition character varying, p_age integer, p_department_id character varying, p_dist_from_home integer, p_education integer, p_education_field character varying, p_env_satisfaction integer, p_job_satisfaction integer, p_marital_status character varying, p_num_comp_worked integer, p_monthly_income integer, p_work_life_balance integer, p_years_at_company integer) OWNER TO postgres;

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
-- Name: get_employee_histories(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_employee_histories() RETURNS TABLE(id character varying, attrition character varying, modif_action character varying, modif_date date, age integer, department character varying, dist_from_home integer, education integer, education_field character varying, env_satisfaction integer, job_satisfaction integer, marital_status character varying, num_comp_worked integer, monthly_income integer, work_life_balance integer, years_at_company integer)
    LANGUAGE sql
    AS $$
	SELECT 	employee_id, attrition, modif_action, modif_date,
			age, name AS department, dist_from_home, education,
			education_field, env_satisfaction, job_satisfaction, marital_status,
			num_comp_worked, monthly_income, work_life_balance, years_at_company
	FROM employee_history t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	ORDER BY employee_id;
$$;


ALTER FUNCTION public.get_employee_histories() OWNER TO postgres;

--
-- Name: get_employees(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_employees() RETURNS TABLE(id character varying, attrition character varying, age integer, department character varying, dist_from_home integer, education integer, education_field character varying, env_satisfaction integer, job_satisfaction integer, marital_status character varying, num_comp_worked integer, monthly_income integer, work_life_balance integer, years_at_company integer)
    LANGUAGE sql
    AS $$
	SELECT 	t1.id, attrition, age, name AS department,
			dist_from_home, education, education_field, env_satisfaction,
			job_satisfaction, marital_status, num_comp_worked, monthly_income,
			work_life_balance, years_at_company
	FROM employee t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	ORDER BY t1.id
$$;


ALTER FUNCTION public.get_employees() OWNER TO postgres;

--
-- Name: get_sys_user(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_sys_user(p_username character varying) RETURNS TABLE(id character varying, name character varying, role character varying, username character varying, password character varying)
    LANGUAGE sql
    AS $$
	SELECT *
	FROM sys_user
	WHERE username = p_username;
$$;


ALTER FUNCTION public.get_sys_user(p_username character varying) OWNER TO postgres;

--
-- Name: get_test_data(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_test_data() RETURNS TABLE(id character varying, attrition character varying, age integer, department character varying, dist_from_home integer, education integer, education_field character varying, env_satisfaction integer, job_satisfaction integer, marital_status character varying, num_comp_worked integer, monthly_income integer, work_life_balance integer, years_at_company integer)
    LANGUAGE sql
    AS $$
	SELECT 	t1.id, attrition, age, name AS department,
			dist_from_home, education, education_field, env_satisfaction,
			job_satisfaction, marital_status, num_comp_worked, monthly_income,
			work_life_balance, years_at_company
	FROM employee t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	WHERE attrition IS NULL
	ORDER BY t1.id;
$$;


ALTER FUNCTION public.get_test_data() OWNER TO postgres;

--
-- Name: get_train_class_distribution(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_train_class_distribution() RETURNS TABLE(e_attrition_no integer, eh_attrition_no integer, eh_attrition_yes integer)
    LANGUAGE sql
    AS $$
	WITH
	t1 AS
	(
		SELECT 	sum(case when attrition = 'No' then 1 end) AS e_attrition_no
		FROM employee
		WHERE attrition IS NOT NULL
	),
	t2 AS
	(
		SELECT	sum(case when attrition = 'No' then 1 end) AS eh_attrition_no,
				sum(case when attrition = 'Yes' then 1 end) AS eh_attrition_yes
		FROM employee_history
	)
	SELECT	e_attrition_no,
			eh_attrition_no,
			eh_attrition_yes
	FROM t1, t2;
$$;


ALTER FUNCTION public.get_train_class_distribution() OWNER TO postgres;

--
-- Name: get_train_data(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_train_data() RETURNS TABLE(id character varying, attrition character varying, age integer, department character varying, dist_from_home integer, education integer, education_field character varying, env_satisfaction integer, job_satisfaction integer, marital_status character varying, num_comp_worked integer, monthly_income integer, work_life_balance integer, years_at_company integer)
    LANGUAGE sql
    AS $$
	SELECT 	t1.id, attrition, age, name AS department,
			dist_from_home, education, education_field, env_satisfaction,
			job_satisfaction, marital_status, num_comp_worked, monthly_income,
			work_life_balance, years_at_company
	FROM employee t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	WHERE attrition IS NOT NULL
	UNION
	SELECT 	employee_id AS id, attrition, age, name AS department,
			dist_from_home, education, education_field, env_satisfaction,
			job_satisfaction, marital_status, num_comp_worked, monthly_income,
			work_life_balance, years_at_company
	FROM employee_history t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	ORDER BY id;
$$;


ALTER FUNCTION public.get_train_data() OWNER TO postgres;

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
-- Name: update_employee(character varying, integer, character varying, integer, integer, character varying, integer, integer, character varying, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_employee(p_id character varying, p_age integer, p_department_id character varying, p_dist_from_home integer, p_education integer, p_education_field character varying, p_env_satisfaction integer, p_job_satisfaction integer, p_marital_status character varying, p_num_comp_worked integer, p_monthly_income integer, p_work_life_balance integer, p_years_at_company integer) RETURNS void
    LANGUAGE sql
    AS $$
	UPDATE employee
    SET attrition = NULL
    WHERE id = p_id;

	UPDATE employee
	SET age = p_age, department_id = p_department_id,
		dist_from_home = p_dist_from_home, education = p_education,
		education_field = p_education_field, env_satisfaction = p_env_satisfaction,
		job_satisfaction = p_job_satisfaction, marital_status = p_marital_status,
		num_comp_worked = p_num_comp_worked, monthly_income = p_monthly_income,
		work_life_balance = p_work_life_balance, years_at_company = p_years_at_company
	WHERE id = p_id;
$$;


ALTER FUNCTION public.update_employee(p_id character varying, p_age integer, p_department_id character varying, p_dist_from_home integer, p_education integer, p_education_field character varying, p_env_satisfaction integer, p_job_satisfaction integer, p_marital_status character varying, p_num_comp_worked integer, p_monthly_income integer, p_work_life_balance integer, p_years_at_company integer) OWNER TO postgres;

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
    education integer NOT NULL,
    education_field character varying(50) NOT NULL,
    env_satisfaction integer NOT NULL,
    job_satisfaction integer NOT NULL,
    marital_status character varying(10) NOT NULL,
    num_comp_worked integer NOT NULL,
    monthly_income integer NOT NULL,
    work_life_balance integer NOT NULL,
    years_at_company integer NOT NULL
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: employee_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_history (
    employee_id character varying(10) NOT NULL,
    modif_action character varying(8) DEFAULT 'update'::character varying NOT NULL,
    modif_date date NOT NULL,
    attrition character varying(5) NOT NULL,
    age integer NOT NULL,
    department_id character varying(10) NOT NULL,
    dist_from_home integer NOT NULL,
    education integer NOT NULL,
    education_field character varying(50) NOT NULL,
    env_satisfaction integer NOT NULL,
    job_satisfaction integer NOT NULL,
    marital_status character varying(10) NOT NULL,
    num_comp_worked integer NOT NULL,
    monthly_income integer NOT NULL,
    work_life_balance integer NOT NULL,
    years_at_company integer NOT NULL
);


ALTER TABLE public.employee_history OWNER TO postgres;

--
-- Name: sys_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_user (
    id character varying(10) NOT NULL,
    name character varying(50) NOT NULL,
    role character varying(10) NOT NULL,
    username character varying(15) NOT NULL,
    password character varying(25) NOT NULL
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

COPY public.employee (id, attrition, age, department_id, dist_from_home, education, education_field, env_satisfaction, job_satisfaction, marital_status, num_comp_worked, monthly_income, work_life_balance, years_at_company) FROM stdin;
EP006	No	35	DP1	16	3	Life Sciences	4	3	Married	4	7632	3	8
EP005	\N	45	DP2	22	2	Technical	1	1	Single	0	4632	1	8
EP001	\N	37	DP1	21	3	Life Sciences	1	2	Single	1	5499	2	7
EP009	No	38	DP2	7	4	Marketing	4	4	Single	0	4028	3	7
EP010	No	38	DP1	3	5	Technical	4	3	Single	3	4317	3	3
EP011	No	47	DP2	2	2	Marketing	3	4	Married	0	4537	3	7
EP012	No	40	DP2	2	4	Life Sciences	3	3	Married	0	18041	3	20
EP013	No	34	DP2	23	4	Marketing	2	3	Single	0	4568	3	9
EP014	No	55	DP1	1	4	Medical	2	4	Divorced	2	14732	4	7
EP016	No	59	DP3	6	2	Medical	2	3	Married	8	2267	2	2
EP017	No	45	DP1	4	2	Life Sciences	3	2	Married	1	4447	2	9
EP018	No	39	DP2	24	1	Marketing	2	4	Married	0	12031	2	20
EP019	No	37	DP2	9	4	Medical	1	2	Divorced	1	8834	3	9
EP020	No	28	DP1	17	2	Medical	3	1	Divorced	1	4558	3	10
EP021	No	32	DP2	1	4	Marketing	3	4	Married	1	10422	3	14
EP022	No	22	DP1	11	3	Medical	1	2	Married	1	2244	3	2
EP023	No	35	DP1	23	4	Medical	2	3	Married	0	2705	4	5
EP002	\N	59	DP2	21	4	Life Sciences	2	2	Divorced	4	12875	3	1
EP025	No	31	DP2	6	4	Medical	1	4	Divorced	4	5460	4	7
EP026	No	51	DP2	14	2	Life Sciences	3	4	Married	4	4936	2	7
EP003	\N	25	DP1	7	3	Life Sciences	2	3	Divorced	1	4400	2	6
EP029	No	29	DP2	19	3	Life Sciences	3	3	Divorced	1	8620	3	10
EP030	No	34	DP2	10	3	Life Sciences	4	3	Divorced	1	4001	3	15
EP031	No	29	DP1	28	4	Medical	4	1	Single	1	3785	1	5
EP032	No	33	DP1	2	3	Life Sciences	3	4	Single	0	2500	4	3
EP033	No	38	DP1	1	3	Life Sciences	4	4	Married	7	4735	4	13
EP034	No	22	DP1	5	3	Life Sciences	4	2	Divorced	1	2328	2	4
EP035	No	26	DP1	3	4	Medical	1	4	Married	1	4420	3	8
EP036	No	32	DP1	9	4	Life Sciences	1	4	Married	1	6322	2	6
EP004	\N	47	DP2	2	4	Marketing	2	1	Married	3	11947	2	3
EP039	No	46	DP1	18	1	Medical	1	3	Married	5	10527	2	2
EP040	No	39	DP1	7	2	Medical	3	4	Married	1	19272	3	21
EP041	No	26	DP1	1	3	Life Sciences	3	2	Divorced	1	6397	1	6
EP042	No	44	DP1	24	3	Medical	1	3	Single	2	3708	3	5
EP043	No	36	DP1	4	2	Life Sciences	4	2	Divorced	7	5131	3	4
EP045	No	30	DP1	9	2	Medical	4	3	Single	1	2206	3	10
EP047	No	42	DP1	2	4	Other	1	4	Single	3	6781	3	1
EP050	No	59	DP2	1	2	Technical	2	4	Married	3	11904	1	6
EP051	No	36	DP1	24	4	Life Sciences	2	2	Married	7	5674	3	9
EP052	No	43	DP2	25	3	Medical	3	4	Divorced	5	10798	3	1
EP053	No	41	DP3	10	4	Human Resources	2	4	Divorced	3	19141	2	21
EP054	No	51	DP2	21	4	Marketing	3	4	Single	0	5441	1	10
EP055	No	35	DP1	2	3	Medical	2	2	Single	5	4425	3	6
EP056	No	42	DP1	13	3	Medical	2	1	Married	5	5538	2	0
EP057	No	51	DP1	9	4	Life Sciences	4	4	Married	3	2075	3	4
EP059	No	46	DP1	7	2	Medical	4	3	Divorced	6	10845	3	8
EP060	No	31	DP1	2	4	Life Sciences	2	3	Married	1	3477	4	5
EP061	No	38	DP1	12	3	Life Sciences	1	1	Divorced	2	6288	2	4
EP062	No	38	DP1	18	3	Medical	2	4	Married	3	5811	3	1
EP063	No	45	DP1	1	4	Medical	2	3	Single	4	5399	3	4
EP064	No	28	DP1	1	3	Life Sciences	1	3	Divorced	1	1563	1	1
EP065	No	32	DP1	10	3	Life Sciences	1	3	Married	6	3433	2	5
EP066	No	36	DP1	6	3	Life Sciences	4	4	Married	0	3210	3	15
EP067	No	24	DP3	10	3	Medical	1	4	Married	0	2145	3	2
EP069	No	27	DP1	8	3	Medical	2	3	Married	7	3517	3	3
EP071	No	19	DP1	3	1	Medical	2	2	Single	1	1483	3	1
EP074	No	33	DP2	2	3	Marketing	4	2	Single	8	5147	2	11
EP075	No	36	DP2	8	4	Technical	1	4	Divorced	4	5079	3	7
EP076	No	26	DP2	5	3	Other	4	3	Single	0	2966	3	4
EP077	No	50	DP2	1	4	Medical	4	4	Divorced	3	19517	2	7
EP078	No	29	DP2	20	2	Marketing	4	4	Divorced	2	6931	3	3
EP079	No	34	DP2	23	4	Marketing	2	3	Single	0	4568	3	9
EP080	No	38	DP1	6	2	Other	4	3	Married	1	3702	3	5
EP081	No	39	DP1	18	2	Life Sciences	1	3	Single	0	4534	3	8
EP082	No	43	DP1	6	3	Medical	1	3	Single	1	4081	1	20
EP083	No	40	DP1	8	2	Life Sciences	4	4	Divorced	3	4069	3	2
EP084	No	27	DP1	4	3	Life Sciences	2	2	Married	1	6142	3	6
EP085	No	28	DP1	1	3	Technical	4	1	Single	2	2080	2	3
EP086	No	42	DP1	28	4	Technical	4	4	Married	0	4523	4	6
EP087	No	32	DP1	5	4	Life Sciences	4	4	Single	8	9679	3	1
EP088	No	48	DP1	15	4	Other	3	1	Married	8	2367	2	8
EP089	No	37	DP2	2	3	Marketing	4	3	Married	4	9602	2	3
EP090	No	35	DP1	3	3	Life Sciences	3	3	Married	1	1281	3	1
EP091	No	33	DP1	1	2	Life Sciences	1	4	Single	1	13458	3	15
EP092	No	40	DP1	2	4	Life Sciences	3	3	Single	2	2809	3	2
EP093	No	51	DP2	2	3	Marketing	2	2	Married	2	10596	3	4
EP095	No	29	DP1	10	3	Life Sciences	4	2	Divorced	0	3291	2	7
EP096	No	34	DP1	19	2	Medical	2	4	Divorced	0	2661	3	2
EP097	No	34	DP2	15	2	Medical	3	1	Single	1	6125	4	10
EP098	No	27	DP1	4	3	Life Sciences	2	2	Married	1	6142	3	6
EP099	No	37	DP1	1	3	Technical	2	4	Single	4	7491	4	6
EP100	No	45	DP1	1	4	Medical	2	3	Single	4	5399	3	4
EP101	No	34	DP1	9	3	Medical	4	2	Single	1	8621	4	8
EP102	No	31	DP2	2	1	Life Sciences	2	4	Single	4	6582	4	6
EP103	No	46	DP2	2	3	Life Sciences	3	4	Divorced	4	10368	2	10
EP104	No	33	DP2	5	1	Life Sciences	2	4	Married	6	9998	4	5
EP105	No	35	DP1	18	4	Life Sciences	3	3	Married	1	5689	4	10
EP106	No	37	DP1	1	3	Life Sciences	4	4	Married	1	6474	2	14
EP107	No	21	DP1	15	2	Life Sciences	3	4	Single	1	1232	3	0
EP108	No	24	DP2	10	4	Marketing	4	3	Divorced	1	4260	4	5
EP109	No	39	DP2	24	1	Marketing	2	4	Married	0	12031	2	20
EP110	No	28	DP2	26	3	Life Sciences	3	1	Married	1	4724	3	5
EP111	No	29	DP3	17	3	Other	2	1	Single	1	7988	2	10
EP112	No	29	DP1	10	3	Life Sciences	4	2	Divorced	0	3291	2	7
EP113	No	33	DP2	10	4	Marketing	2	3	Single	1	5487	2	10
EP114	No	37	DP2	10	4	Life Sciences	4	4	Divorced	2	6694	3	1
EP115	No	37	DP2	9	2	Marketing	2	2	Married	1	4189	3	5
EP116	No	35	DP1	10	3	Other	2	4	Divorced	1	3917	2	3
EP119	No	31	DP1	3	2	Medical	3	1	Divorced	1	3065	4	4
EP121	No	53	DP1	13	2	Medical	4	1	Divorced	1	4450	3	4
EP122	No	30	DP2	7	1	Marketing	4	2	Single	0	2983	3	3
EP123	No	18	DP2	10	3	Medical	4	3	Single	1	1200	3	0
EP124	No	38	DP1	10	3	Medical	2	3	Married	3	13206	3	18
EP125	No	32	DP1	29	4	Life Sciences	3	2	Single	1	2837	3	6
EP126	No	43	DP1	3	3	Life Sciences	3	4	Married	3	19740	3	8
EP127	No	47	DP1	25	3	Medical	1	3	Single	2	8633	3	17
EP128	No	60	DP2	7	4	Marketing	2	4	Divorced	0	5220	3	11
EP129	No	44	DP3	1	4	Life Sciences	1	3	Single	4	5985	4	2
EP130	No	52	DP1	1	4	Life Sciences	3	3	Married	0	19999	3	33
EP131	No	45	DP1	20	3	Medical	2	1	Divorced	2	10851	3	7
EP132	No	38	DP2	16	3	Life Sciences	2	2	Single	2	4198	4	3
EP133	No	48	DP1	15	4	Other	3	1	Married	8	2367	2	8
EP134	No	40	DP1	8	2	Life Sciences	2	1	Married	2	6516	3	1
EP136	No	36	DP2	10	4	Technical	2	3	Married	1	5673	3	10
EP137	No	34	DP1	10	4	Medical	4	3	Divorced	1	3815	4	5
EP139	No	43	DP1	27	3	Life Sciences	3	1	Married	8	10820	3	8
EP140	No	28	DP1	1	3	Life Sciences	1	3	Divorced	1	1563	1	1
EP141	No	37	DP1	25	2	Medical	3	4	Divorced	7	5731	3	6
EP142	No	51	DP1	6	3	Life Sciences	1	3	Single	7	19537	3	20
EP143	No	35	DP1	1	4	Life Sciences	3	4	Married	1	2977	3	4
EP144	No	36	DP2	1	2	Life Sciences	2	4	Married	1	6201	2	18
EP145	No	26	DP1	2	2	Medical	4	4	Married	1	5472	3	8
EP146	No	33	DP1	28	4	Life Sciences	2	3	Married	1	5207	3	15
EP147	No	58	DP2	21	3	Life Sciences	4	4	Married	4	17875	2	1
EP148	No	24	DP1	23	3	Medical	2	4	Married	1	2725	3	6
EP149	No	30	DP2	5	3	Marketing	4	3	Divorced	1	6118	3	10
EP150	No	31	DP1	20	3	Life Sciences	2	3	Divorced	1	4197	3	10
EP151	No	30	DP1	3	3	Life Sciences	3	4	Married	4	2097	1	5
EP152	No	40	DP1	9	4	Medical	2	3	Single	9	13499	2	18
EP154	No	42	DP2	26	3	Marketing	3	2	Married	5	13525	4	20
EP155	No	32	DP1	3	4	Medical	3	1	Married	1	6725	4	8
EP156	No	36	DP1	10	3	Life Sciences	4	1	Married	7	8321	3	12
EP157	No	25	DP2	4	1	Marketing	3	1	Married	1	4256	4	5
EP158	No	29	DP3	17	3	Other	2	1	Single	1	7988	2	10
EP159	No	36	DP2	1	2	Life Sciences	2	4	Married	1	6201	2	18
EP160	No	21	DP1	15	2	Life Sciences	3	4	Single	1	1232	3	0
EP162	No	42	DP2	8	4	Marketing	3	2	Married	0	6825	3	9
EP163	No	59	DP3	2	4	Human Resources	3	4	Married	9	18844	3	3
EP164	No	41	DP2	23	2	Life Sciences	4	3	Single	3	7082	3	2
EP165	No	36	DP1	6	3	Life Sciences	2	4	Married	3	3038	3	1
EP166	No	34	DP1	8	2	Medical	2	3	Single	3	6142	3	5
EP167	No	33	DP1	8	4	Life Sciences	4	1	Married	6	3143	3	10
EP168	No	34	DP1	19	3	Life Sciences	2	4	Married	1	2929	3	10
EP169	No	39	DP2	21	4	Life Sciences	1	4	Married	3	6120	4	5
EP170	No	30	DP1	1	1	Life Sciences	4	4	Married	1	5126	2	10
EP171	No	18	DP1	5	2	Life Sciences	2	4	Single	1	1051	3	0
EP172	No	37	DP1	1	4	Life Sciences	2	2	Married	6	6447	2	6
EP173	No	27	DP1	9	3	Medical	4	2	Single	1	2279	2	7
EP174	No	38	DP3	10	4	Human Resources	3	3	Married	3	6077	3	6
EP175	No	27	DP1	17	3	Technical	3	2	Married	0	3058	2	5
EP176	No	50	DP1	11	3	Life Sciences	3	2	Single	3	19926	3	5
EP177	No	52	DP1	2	3	Life Sciences	3	4	Single	7	3212	2	2
EP178	No	29	DP3	6	1	Medical	4	2	Married	1	2804	3	1
EP179	No	36	DP1	27	3	Medical	3	3	Married	6	5237	2	7
EP181	No	56	DP1	9	3	Medical	1	3	Married	2	2942	3	5
EP182	No	59	DP3	2	4	Human Resources	3	4	Married	9	18844	3	3
EP183	No	34	DP1	1	3	Life Sciences	4	2	Married	5	3294	2	5
EP185	No	53	DP2	2	3	Marketing	3	2	Married	2	7525	3	15
EP186	No	44	DP1	7	3	Medical	2	4	Divorced	0	19049	2	22
EP187	No	38	DP2	7	2	Medical	1	1	Divorced	1	5605	3	8
EP188	No	31	DP2	7	3	Marketing	4	4	Divorced	4	7547	3	7
EP190	No	35	DP2	1	3	Medical	1	3	Single	1	4859	3	5
EP192	No	29	DP1	3	1	Medical	2	1	Single	1	4723	3	10
EP193	No	37	DP1	10	4	Life Sciences	3	2	Single	2	4197	2	1
EP195	No	23	DP1	10	3	Technical	4	3	Married	2	2073	3	2
EP196	No	27	DP1	9	3	Medical	4	2	Single	1	2279	2	7
EP197	No	28	DP1	1	4	Medical	4	3	Single	0	2154	2	4
EP198	No	52	DP1	8	4	Other	3	1	Married	9	2950	1	5
EP199	No	37	DP2	19	2	Medical	1	2	Single	1	7642	3	10
EP200	No	46	DP3	1	2	Life Sciences	4	1	Single	6	3423	4	7
EP201	No	38	DP1	2	2	Medical	4	3	Married	3	7756	4	5
EP202	No	33	DP2	16	3	Life Sciences	3	4	Divorced	1	5368	3	6
EP203	No	40	DP1	14	3	Medical	3	3	Single	1	19626	4	20
EP204	No	40	DP1	9	5	Life Sciences	4	4	Married	9	4876	1	3
EP205	No	34	DP2	4	4	Marketing	3	3	Married	9	6538	3	3
EP206	No	31	DP2	2	1	Life Sciences	2	4	Single	4	6582	4	6
EP207	No	27	DP1	1	2	Medical	4	2	Divorced	1	3816	3	5
EP208	No	41	DP1	22	3	Life Sciences	4	4	Divorced	3	5467	2	6
EP209	No	21	DP1	3	2	Medical	4	3	Single	1	3230	4	3
EP212	No	26	DP1	1	1	Medical	1	3	Divorced	1	2007	3	5
EP213	No	27	DP1	9	3	Medical	4	2	Single	1	2279	2	7
EP214	No	36	DP1	4	4	Life Sciences	1	4	Single	1	5810	2	10
EP215	No	46	DP2	1	4	Life Sciences	4	1	Single	1	17567	1	26
EP216	No	36	DP1	12	5	Medical	4	4	Single	0	8858	2	14
EP217	No	30	DP2	4	2	Medical	3	2	Divorced	1	5209	2	11
EP218	No	41	DP1	5	3	Life Sciences	2	2	Single	3	6870	1	3
EP219	No	35	DP2	17	4	Life Sciences	3	1	Married	3	8966	3	7
EP220	No	32	DP1	1	3	Life Sciences	2	2	Married	1	6220	3	10
EP221	No	25	DP1	7	1	Medical	4	4	Married	1	2889	3	2
EP222	No	24	DP1	9	3	Medical	3	3	Married	1	4401	3	5
EP223	No	37	DP1	2	2	Life Sciences	3	4	Divorced	5	5163	4	1
EP224	No	41	DP2	8	3	Marketing	3	2	Married	5	4393	3	5
EP225	No	36	DP1	1	4	Medical	4	3	Married	0	4374	3	3
EP229	No	35	DP1	16	3	Medical	1	2	Married	0	2426	3	5
EP230	No	33	DP1	5	3	Life Sciences	4	4	Divorced	4	7119	3	3
EP231	No	55	DP1	4	4	Life Sciences	4	3	Married	0	4035	3	3
EP232	No	40	DP1	16	4	Medical	1	3	Single	6	5094	3	1
EP233	No	34	DP1	22	4	Other	3	4	Married	1	5747	3	15
EP234	No	33	DP1	1	2	Life Sciences	1	4	Single	1	13458	3	15
EP236	No	29	DP1	21	4	Life Sciences	2	1	Divorced	1	9980	3	10
EP237	No	38	DP3	1	4	Other	4	2	Married	0	2991	3	6
EP238	No	31	DP2	20	3	Life Sciences	3	4	Married	0	2791	3	2
EP239	No	31	DP1	7	2	Medical	2	1	Married	1	4306	1	13
EP240	No	37	DP1	11	3	Other	2	4	Divorced	1	12185	3	10
EP241	No	42	DP1	2	3	Medical	3	2	Married	4	4841	3	1
EP242	No	43	DP1	3	3	Life Sciences	3	4	Married	3	19740	3	8
EP243	No	40	DP1	11	3	Technical	4	3	Married	1	6323	4	10
EP245	No	40	DP1	16	3	Life Sciences	3	4	Single	6	7945	2	4
EP246	No	50	DP1	24	3	Life Sciences	4	3	Married	3	13973	3	12
EP247	No	44	DP1	3	4	Other	4	4	Married	4	19513	4	2
EP248	No	38	DP2	2	2	Life Sciences	4	4	Married	3	5249	3	8
EP250	No	24	DP1	29	1	Medical	2	1	Divorced	1	3907	4	6
EP251	No	28	DP2	1	2	Life Sciences	3	4	Married	1	6834	3	7
EP252	No	52	DP1	19	4	Medical	4	4	Married	0	4258	3	4
EP253	No	42	DP3	10	3	Human Resources	3	1	Married	0	16799	3	20
EP254	No	36	DP2	15	4	Marketing	4	4	Divorced	1	5406	2	15
EP255	No	22	DP1	11	3	Medical	1	2	Married	1	2244	3	2
EP256	No	28	DP2	4	3	Medical	2	3	Married	1	4221	4	5
EP257	No	29	DP2	1	1	Medical	2	4	Married	1	7918	3	11
EP258	No	42	DP1	2	3	Life Sciences	4	4	Married	2	10124	1	20
EP259	No	36	DP2	10	4	Medical	2	4	Single	1	9980	2	10
EP260	No	54	DP3	26	3	Human Resources	4	4	Single	2	17328	3	5
EP261	No	30	DP1	10	3	Medical	1	3	Single	9	9667	3	7
EP262	No	34	DP1	16	4	Life Sciences	3	4	Single	1	2553	3	5
EP263	No	29	DP1	1	3	Life Sciences	4	4	Divorced	3	16124	2	7
EP264	No	48	DP2	2	1	Marketing	2	2	Married	3	8120	3	2
EP265	No	36	DP1	3	2	Life Sciences	1	4	Divorced	5	2835	3	1
EP266	No	40	DP1	2	4	Life Sciences	3	3	Single	2	2809	3	2
EP267	No	33	DP1	5	4	Life Sciences	4	2	Married	6	11878	3	10
EP268	No	41	DP2	1	3	Marketing	3	1	Divorced	0	4103	3	9
EP269	No	50	DP2	1	4	Medical	4	4	Divorced	3	19517	2	7
EP270	No	38	DP1	10	3	Medical	3	3	Married	3	9824	3	1
EP271	No	33	DP1	9	3	Medical	1	4	Married	0	2781	3	14
EP272	No	55	DP2	26	5	Marketing	3	4	Married	1	19586	3	36
EP273	No	31	DP1	8	4	Life Sciences	3	4	Single	1	4424	3	11
EP274	No	49	DP1	1	2	Technical	3	3	Single	7	13964	3	7
EP275	No	28	DP2	5	3	Medical	4	1	Single	0	8463	3	5
EP277	No	49	DP1	20	4	Medical	3	1	Married	1	6567	2	15
EP278	No	25	DP1	2	1	Other	4	3	Divorced	6	3977	2	2
EP279	No	42	DP2	12	4	Marketing	2	4	Divorced	3	5087	3	0
EP280	No	23	DP1	12	2	Other	4	4	Single	1	2647	4	5
EP281	No	28	DP2	3	3	Medical	2	2	Married	1	2856	3	1
EP282	No	35	DP2	17	4	Life Sciences	3	1	Married	3	8966	3	7
EP285	No	38	DP1	4	2	Medical	4	3	Married	7	3306	2	0
EP286	No	31	DP3	8	2	Medical	4	2	Single	9	2109	3	3
EP287	No	33	DP3	2	3	Human Resources	2	3	Married	1	3600	3	5
EP288	No	37	DP1	2	2	Life Sciences	3	4	Divorced	5	5163	4	1
EP289	No	49	DP1	6	1	Life Sciences	3	3	Married	2	13966	3	15
EP290	No	46	DP2	2	3	Marketing	3	1	Married	8	17048	3	26
EP291	No	35	DP1	1	4	Life Sciences	4	3	Single	3	2506	3	2
EP292	No	37	DP2	19	2	Medical	1	2	Single	1	7642	3	10
EP294	No	54	DP1	17	3	Technical	3	3	Married	8	10739	3	10
EP295	No	40	DP1	26	2	Medical	3	4	Married	3	4422	1	1
EP296	No	37	DP1	11	3	Medical	1	3	Single	4	3629	3	3
EP297	No	40	DP1	1	3	Life Sciences	3	4	Divorced	4	6513	3	5
EP298	No	30	DP2	12	3	Technical	2	3	Single	0	6577	3	5
EP299	No	39	DP1	1	1	Life Sciences	2	3	Divorced	1	19197	3	21
EP300	No	30	DP1	2	3	Life Sciences	3	4	Married	1	4152	3	11
EP301	No	46	DP1	13	4	Life Sciences	3	2	Single	6	5562	3	10
EP302	No	36	DP1	7	3	Life Sciences	1	2	Single	2	2013	3	4
EP303	No	29	DP1	1	3	Life Sciences	4	3	Single	8	6294	4	3
EP304	No	48	DP2	16	4	Life Sciences	3	3	Divorced	8	6439	3	8
EP305	No	37	DP1	3	3	Other	4	2	Single	3	4107	2	4
\.


--
-- Data for Name: employee_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_history (employee_id, modif_action, modif_date, attrition, age, department_id, dist_from_home, education, education_field, env_satisfaction, job_satisfaction, marital_status, num_comp_worked, monthly_income, work_life_balance, years_at_company) FROM stdin;
EP007	delete	2024-07-19	Yes	37	DP1	10	4	Medical	4	1	Single	1	4213	1	10
EP008	delete	2024-07-19	Yes	36	DP1	16	4	Life Sciences	3	1	Single	1	2743	3	17
EP015	delete	2024-07-19	Yes	19	DP1	2	3	Life Sciences	2	4	Single	1	1102	2	1
EP024	delete	2024-07-19	Yes	23	DP1	6	3	Life Sciences	3	1	Married	1	1601	3	0
EP027	delete	2024-07-19	Yes	31	DP1	20	3	Life Sciences	1	3	Married	3	9824	3	1
EP028	delete	2024-07-19	Yes	34	DP2	6	2	Marketing	4	3	Divorced	0	2351	2	2
EP037	delete	2024-07-19	Yes	41	DP1	5	2	Life Sciences	1	1	Divorced	6	2107	1	1
EP038	delete	2024-07-19	Yes	26	DP1	5	2	Medical	3	3	Married	1	2366	3	8
EP044	delete	2024-07-19	Yes	29	DP1	1	4	Technical	1	1	Single	6	2362	1	9
EP046	delete	2024-07-19	Yes	29	DP2	23	1	Life Sciences	4	1	Married	1	7336	1	11
EP048	delete	2024-07-19	Yes	24	DP1	1	3	Medical	2	4	Married	2	2293	2	2
EP049	delete	2024-07-19	Yes	19	DP3	2	2	Technical	1	4	Single	1	2564	4	1
EP058	delete	2024-07-19	Yes	46	DP1	21	2	Medical	4	2	Married	4	8926	4	9
EP068	delete	2024-07-19	Yes	22	DP1	8	1	Medical	3	1	Married	1	2398	3	1
EP070	delete	2024-07-19	Yes	20	DP1	11	3	Medical	4	1	Single	1	2600	3	1
EP072	delete	2024-07-19	Yes	50	DP2	8	2	Technical	2	3	Married	3	6796	3	4
EP073	delete	2024-07-19	Yes	53	DP1	2	5	Technical	3	4	Married	0	10169	3	33
EP094	delete	2024-07-19	Yes	41	DP2	20	2	Marketing	2	2	Single	1	3140	2	4
EP117	delete	2024-07-19	Yes	19	DP1	10	3	Medical	1	2	Single	1	1859	4	1
EP118	delete	2024-07-19	Yes	24	DP2	3	2	Life Sciences	1	3	Single	9	4577	3	2
EP120	delete	2024-07-19	Yes	58	DP1	2	3	Technical	4	3	Single	4	2479	3	1
EP135	delete	2024-07-19	Yes	29	DP2	9	3	Marketing	2	2	Single	1	2760	3	2
EP138	delete	2024-07-19	Yes	50	DP2	1	4	Other	4	3	Single	3	4728	3	0
EP153	delete	2024-07-19	Yes	33	DP2	16	3	Life Sciences	1	1	Single	2	8564	2	0
EP161	delete	2024-07-19	Yes	21	DP2	1	1	Technical	1	2	Single	1	2174	3	3
EP180	delete	2024-07-19	Yes	31	DP1	2	3	Life Sciences	2	4	Married	6	3722	1	2
EP184	delete	2024-07-19	Yes	26	DP1	5	2	Medical	3	3	Married	1	2366	3	8
EP189	delete	2024-07-19	Yes	28	DP1	17	3	Technical	3	4	Divorced	5	2367	2	4
EP191	delete	2024-07-19	Yes	22	DP1	3	1	Life Sciences	2	3	Married	0	4171	4	3
EP194	delete	2024-07-19	Yes	32	DP2	1	2	Life Sciences	1	2	Single	6	6735	3	0
EP210	delete	2024-07-19	Yes	58	DP1	2	3	Technical	4	3	Single	4	2479	3	1
EP211	delete	2024-07-19	Yes	28	DP1	2	4	Life Sciences	1	3	Single	2	3485	1	0
EP226	delete	2024-07-19	Yes	28	DP1	2	4	Life Sciences	1	3	Single	2	3485	1	0
EP227	delete	2024-07-19	Yes	32	DP2	4	4	Medical	4	4	Married	1	10400	2	14
EP228	delete	2024-07-19	Yes	53	DP1	2	5	Technical	3	4	Married	0	10169	3	33
EP235	delete	2024-07-19	Yes	19	DP1	10	3	Medical	1	2	Single	1	1859	4	1
EP244	delete	2024-07-19	Yes	35	DP1	25	4	Life Sciences	4	2	Divorced	1	2022	2	10
EP249	delete	2024-07-19	Yes	35	DP2	12	4	Other	4	4	Single	3	4581	4	11
EP276	delete	2024-07-19	Yes	31	DP1	1	5	Life Sciences	3	2	Single	1	7446	3	10
EP283	delete	2024-07-19	Yes	28	DP2	13	2	Marketing	4	3	Single	3	9854	3	2
EP284	delete	2024-07-19	Yes	35	DP2	4	3	Technical	4	1	Single	0	9582	3	8
EP293	delete	2024-07-19	Yes	34	DP3	23	3	Human Resources	2	1	Divorced	9	9950	3	3
EP306	delete	2024-07-19	Yes	37	DP1	2	2	Other	4	3	Single	6	2090	3	0
EP307	delete	2024-07-19	Yes	30	DP2	9	3	Medical	2	4	Single	1	1081	2	1
EP308	delete	2024-07-19	Yes	30	DP2	1	3	Life Sciences	2	1	Married	1	9714	3	10
EP309	delete	2024-07-19	Yes	44	DP1	1	2	Medical	3	2	Divorced	1	2342	2	5
EP310	delete	2024-07-19	Yes	24	DP1	1	3	Medical	2	4	Married	2	2293	2	2
EP311	delete	2024-07-19	Yes	44	DP3	1	2	Medical	2	1	Married	9	10482	3	20
EP312	delete	2024-07-19	Yes	34	DP2	19	3	Marketing	1	4	Single	8	5304	2	5
EP313	delete	2024-07-19	Yes	52	DP1	8	4	Medical	3	2	Married	2	4941	2	8
EP314	delete	2024-07-19	Yes	25	DP2	24	1	Life Sciences	3	4	Single	1	1118	3	1
EP315	delete	2024-07-19	Yes	46	DP2	9	3	Marketing	1	4	Divorced	4	10096	4	7
EP316	delete	2024-07-19	Yes	33	DP2	16	3	Life Sciences	1	1	Single	2	8564	2	0
EP317	delete	2024-07-19	Yes	48	DP1	1	2	Life Sciences	1	3	Single	9	5381	3	1
EP318	delete	2024-07-19	Yes	28	DP1	1	3	Medical	1	2	Divorced	1	2596	3	1
EP319	delete	2024-07-19	Yes	32	DP2	2	4	Marketing	3	2	Single	7	9907	2	2
EP320	delete	2024-07-19	Yes	24	DP1	7	3	Life Sciences	1	3	Married	1	2886	3	6
EP321	delete	2024-07-19	Yes	32	DP1	2	4	Life Sciences	4	2	Single	1	1393	3	1
EP322	delete	2024-07-19	Yes	40	DP1	9	4	Life Sciences	4	1	Single	3	2018	1	5
EP323	delete	2024-07-19	Yes	53	DP1	2	5	Technical	3	4	Married	0	10169	3	33
EP324	delete	2024-07-19	Yes	36	DP2	13	5	Marketing	2	1	Divorced	5	6134	3	2
EP325	delete	2024-07-19	Yes	40	DP2	22	2	Marketing	3	3	Married	2	6380	3	6
EP326	delete	2024-07-19	Yes	38	DP1	2	3	Medical	3	2	Married	4	4855	3	5
EP327	delete	2024-07-19	Yes	27	DP3	22	3	Human Resources	1	2	Married	1	2863	3	1
EP328	delete	2024-07-19	Yes	31	DP1	15	3	Medical	3	3	Married	1	2610	2	2
EP329	delete	2024-07-19	Yes	19	DP1	10	3	Medical	1	2	Single	1	1859	4	1
EP330	delete	2024-07-19	Yes	23	DP1	6	3	Life Sciences	3	1	Married	1	1601	3	0
EP331	delete	2024-07-19	Yes	31	DP2	26	4	Marketing	1	4	Married	1	5617	3	10
EP332	delete	2024-07-19	Yes	39	DP2	5	3	Technical	4	4	Married	3	2086	4	1
EP333	delete	2024-07-19	Yes	29	DP2	23	1	Life Sciences	4	1	Married	1	7336	1	11
EP334	delete	2024-07-19	Yes	31	DP2	16	4	Marketing	1	3	Married	2	8161	3	1
EP335	delete	2024-07-19	Yes	43	DP1	17	3	Technical	3	3	Married	9	2437	3	1
EP336	delete	2024-07-19	Yes	56	DP1	7	2	Technical	4	3	Married	8	2339	1	10
EP337	delete	2024-07-19	Yes	29	DP1	8	4	Other	2	1	Married	1	2119	2	7
EP338	delete	2024-07-19	Yes	34	DP3	9	4	Technical	1	3	Married	1	2742	3	2
EP339	delete	2024-07-19	Yes	31	DP2	26	4	Marketing	1	4	Married	1	5617	3	10
EP340	delete	2024-07-19	Yes	26	DP2	8	3	Technical	4	1	Single	6	5326	2	4
EP341	delete	2024-07-19	Yes	40	DP1	9	4	Life Sciences	4	1	Single	3	2018	1	5
EP342	delete	2024-07-19	Yes	35	DP1	25	4	Life Sciences	4	2	Divorced	1	2022	2	10
EP343	delete	2024-07-19	Yes	29	DP1	1	2	Life Sciences	2	1	Married	1	2319	3	1
EP344	delete	2024-07-19	Yes	34	DP1	6	1	Medical	2	1	Single	2	2960	3	4
EP345	delete	2024-07-19	Yes	24	DP2	3	2	Life Sciences	1	3	Single	9	4577	3	2
EP346	delete	2024-07-19	Yes	42	DP2	12	3	Life Sciences	3	1	Single	0	13758	2	21
EP347	delete	2024-07-19	Yes	33	DP1	2	2	Life Sciences	1	1	Married	7	2707	4	9
EP348	delete	2024-07-19	Yes	30	DP1	4	3	Technical	3	4	Single	9	2285	3	1
EP349	delete	2024-07-19	Yes	18	DP2	3	2	Medical	2	4	Single	1	1569	4	0
EP350	delete	2024-07-19	Yes	35	DP2	18	4	Marketing	4	3	Married	0	4614	2	4
EP351	delete	2024-07-19	Yes	31	DP2	6	4	Life Sciences	2	3	Married	4	6172	2	7
EP352	delete	2024-07-19	Yes	28	DP2	13	2	Marketing	4	3	Single	3	9854	3	2
EP353	delete	2024-07-19	Yes	41	DP2	20	2	Marketing	2	2	Single	1	3140	2	4
EP354	delete	2024-07-19	Yes	39	DP2	3	2	Medical	4	3	Married	4	5238	2	1
EP355	delete	2024-07-19	Yes	24	DP1	1	3	Medical	2	4	Married	2	2293	2	2
EP356	delete	2024-07-19	Yes	53	DP1	2	5	Technical	3	4	Married	0	10169	3	33
EP357	delete	2024-07-19	Yes	32	DP1	9	3	Medical	1	1	Single	7	4200	4	5
EP358	delete	2024-07-19	Yes	39	DP1	6	3	Medical	4	1	Married	7	2404	1	2
EP359	delete	2024-07-19	Yes	29	DP1	18	1	Medical	3	4	Single	1	2389	2	4
EP360	delete	2024-07-19	Yes	24	DP2	3	2	Life Sciences	1	3	Single	9	4577	3	2
EP361	delete	2024-07-19	Yes	40	DP2	25	4	Marketing	4	2	Single	2	9094	3	5
EP362	delete	2024-07-19	Yes	29	DP2	24	3	Technical	3	1	Single	1	1091	3	1
EP363	delete	2024-07-19	Yes	36	DP2	3	1	Life Sciences	3	4	Married	1	10325	3	16
EP364	delete	2024-07-19	Yes	31	DP2	2	3	Life Sciences	3	4	Single	7	2785	4	1
EP365	delete	2024-07-19	Yes	39	DP1	2	3	Life Sciences	1	4	Divorced	7	12169	3	18
EP366	delete	2024-07-19	Yes	20	DP2	2	3	Medical	3	3	Single	1	2044	2	2
EP367	delete	2024-07-19	Yes	29	DP1	24	2	Life Sciences	4	4	Single	1	2439	2	1
EP368	delete	2024-07-19	Yes	24	DP2	3	2	Life Sciences	1	3	Single	9	4577	3	2
EP369	delete	2024-07-19	Yes	45	DP2	26	4	Life Sciences	1	1	Married	2	4286	3	1
EP370	delete	2024-07-19	Yes	23	DP2	7	3	Life Sciences	3	4	Divorced	1	2275	3	3
EP371	delete	2024-07-19	Yes	58	DP1	23	4	Medical	4	4	Married	1	10312	2	40
EP372	delete	2024-07-19	Yes	21	DP2	7	1	Marketing	2	2	Single	1	2679	3	1
EP373	delete	2024-07-19	Yes	26	DP2	4	4	Marketing	4	4	Single	1	5828	3	8
EP374	delete	2024-07-19	Yes	53	DP1	2	5	Technical	3	4	Married	0	10169	3	33
EP375	delete	2024-07-19	Yes	24	DP3	22	1	Human Resources	4	3	Married	1	1555	3	1
EP376	delete	2024-07-19	Yes	28	DP1	24	3	Life Sciences	3	3	Single	5	2028	3	4
EP377	delete	2024-07-19	Yes	33	DP1	14	3	Medical	3	4	Married	5	2436	1	5
EP378	delete	2024-07-19	Yes	47	DP2	27	2	Life Sciences	2	3	Single	4	6397	3	5
EP379	delete	2024-07-19	Yes	27	DP3	22	3	Human Resources	1	2	Married	1	2863	3	1
EP380	delete	2024-07-19	Yes	40	DP1	7	3	Life Sciences	1	1	Single	3	2166	1	4
EP381	delete	2024-07-19	Yes	25	DP1	3	3	Medical	1	1	Married	5	4031	3	2
EP382	delete	2024-07-19	Yes	31	DP2	1	3	Life Sciences	4	2	Single	1	2302	4	3
EP383	delete	2024-07-19	Yes	46	DP2	10	3	Life Sciences	3	2	Married	5	7314	3	8
EP384	delete	2024-07-19	Yes	51	DP1	4	4	Life Sciences	1	3	Married	9	2461	4	10
EP385	delete	2024-07-19	Yes	31	DP2	6	4	Life Sciences	2	3	Married	4	6172	2	7
EP386	delete	2024-07-19	Yes	32	DP1	25	4	Life Sciences	1	4	Single	1	2795	1	1
EP387	delete	2024-07-19	Yes	29	DP1	7	3	Technical	2	3	Divorced	3	3339	3	7
EP388	delete	2024-07-19	Yes	58	DP1	2	3	Technical	4	3	Single	4	2479	3	1
EP389	delete	2024-07-19	Yes	36	DP1	15	3	Other	1	3	Divorced	7	4834	2	1
EP390	delete	2024-07-19	Yes	19	DP2	22	1	Marketing	4	3	Single	1	1675	2	0
EP391	delete	2024-07-19	Yes	21	DP2	12	3	Life Sciences	3	2	Single	1	2716	3	1
EP392	delete	2024-07-19	Yes	30	DP2	1	3	Life Sciences	2	1	Married	1	9714	3	10
EP393	delete	2024-07-19	Yes	32	DP2	11	4	Other	4	3	Married	8	4707	3	4
EP394	delete	2024-07-19	Yes	35	DP1	25	4	Life Sciences	4	2	Divorced	1	2022	2	10
EP395	delete	2024-07-19	Yes	25	DP2	9	2	Life Sciences	1	1	Married	3	4400	3	3
EP396	delete	2024-07-19	Yes	26	DP2	29	2	Medical	2	1	Single	8	4969	3	2
EP397	delete	2024-07-19	Yes	21	DP2	7	1	Marketing	2	2	Single	1	2679	3	1
EP398	delete	2024-07-19	Yes	37	DP1	10	4	Medical	4	1	Single	1	4213	1	10
EP399	delete	2024-07-19	Yes	38	DP1	29	1	Medical	2	1	Married	7	6673	3	1
EP400	delete	2024-07-19	Yes	25	DP1	3	3	Medical	1	1	Married	5	4031	3	2
EP401	delete	2024-07-19	Yes	45	DP2	2	3	Marketing	1	2	Single	2	18824	3	24
EP402	delete	2024-07-19	Yes	35	DP2	12	4	Other	4	4	Single	3	4581	4	11
EP403	delete	2024-07-19	Yes	36	DP1	16	4	Life Sciences	3	1	Single	1	2743	3	17
EP404	delete	2024-07-19	Yes	50	DP2	8	2	Technical	2	3	Married	3	6796	3	4
EP405	delete	2024-07-19	Yes	37	DP3	6	4	Human Resources	3	1	Divorced	4	2073	3	3
EP406	delete	2024-07-19	Yes	43	DP2	9	3	Marketing	1	3	Single	8	5346	2	4
EP407	delete	2024-07-19	Yes	56	DP1	7	2	Technical	4	3	Married	8	2339	1	10
EP408	delete	2024-07-19	Yes	18	DP2	3	2	Medical	2	4	Single	1	1569	4	0
EP409	delete	2024-07-19	Yes	31	DP2	2	3	Life Sciences	3	4	Single	7	2785	4	1
EP410	delete	2024-07-19	Yes	38	DP1	29	1	Medical	2	1	Married	7	6673	3	1
EP411	delete	2024-07-19	Yes	30	DP1	3	3	Technical	4	1	Single	5	2657	3	5
EP412	delete	2024-07-19	Yes	23	DP1	6	3	Life Sciences	3	1	Married	1	1601	3	0
EP413	delete	2024-07-19	Yes	55	DP2	2	1	Medical	3	4	Single	4	5160	2	9
EP414	delete	2024-07-19	Yes	47	DP2	27	2	Life Sciences	2	3	Single	4	6397	3	5
EP415	delete	2024-07-19	Yes	47	DP2	9	3	Life Sciences	3	3	Married	7	12936	1	23
EP416	delete	2024-07-19	Yes	37	DP1	11	2	Medical	1	2	Married	5	4777	1	1
EP417	delete	2024-07-19	Yes	33	DP1	15	1	Medical	2	3	Married	7	13610	4	7
EP418	delete	2024-07-19	Yes	35	DP2	12	4	Other	4	4	Single	3	4581	4	11
EP419	delete	2024-07-19	Yes	38	DP1	2	3	Medical	3	2	Married	4	4855	3	5
EP420	delete	2024-07-19	Yes	35	DP2	4	3	Technical	4	1	Single	0	9582	3	8
EP421	delete	2024-07-19	Yes	29	DP1	24	2	Life Sciences	4	4	Single	1	2439	2	1
EP422	delete	2024-07-19	Yes	29	DP1	24	2	Life Sciences	4	4	Single	1	2439	2	1
EP423	delete	2024-07-19	Yes	51	DP1	8	4	Life Sciences	1	4	Single	2	10650	3	4
EP424	delete	2024-07-19	Yes	31	DP3	18	5	Human Resources	4	1	Married	0	2956	3	1
EP425	delete	2024-07-19	Yes	44	DP1	3	3	Life Sciences	1	1	Married	4	2362	4	3
EP426	delete	2024-07-19	Yes	51	DP1	8	4	Life Sciences	1	4	Single	2	10650	3	4
EP427	delete	2024-07-19	Yes	30	DP1	5	3	Medical	2	2	Single	0	2422	3	3
EP428	delete	2024-07-19	Yes	18	DP2	3	2	Medical	2	4	Single	1	1569	4	0
EP429	delete	2024-07-19	Yes	56	DP1	7	2	Technical	4	3	Married	8	2339	1	10
EP430	delete	2024-07-19	Yes	33	DP1	14	3	Medical	3	4	Married	5	2436	1	5
EP431	delete	2024-07-19	Yes	30	DP2	1	3	Life Sciences	2	1	Married	1	9714	3	10
EP432	delete	2024-07-19	Yes	28	DP1	2	4	Medical	1	4	Married	5	3464	2	3
EP433	delete	2024-07-19	Yes	31	DP1	2	3	Life Sciences	2	4	Married	6	3722	1	2
EP434	delete	2024-07-19	Yes	35	DP2	10	3	Medical	4	1	Married	9	10306	3	13
EP435	delete	2024-07-19	Yes	36	DP1	16	4	Life Sciences	3	1	Single	1	2743	3	17
EP436	delete	2024-07-19	Yes	50	DP2	28	3	Marketing	4	1	Divorced	4	10854	3	3
EP437	delete	2024-07-19	Yes	58	DP1	2	4	Life Sciences	4	2	Single	7	19246	3	31
EP438	delete	2024-07-19	Yes	33	DP2	16	3	Life Sciences	1	1	Single	2	8564	2	0
EP439	delete	2024-07-19	Yes	18	DP1	3	3	Life Sciences	3	3	Single	1	1420	3	0
EP440	delete	2024-07-19	Yes	49	DP2	11	3	Marketing	3	4	Married	1	7654	4	9
EP441	delete	2024-07-19	Yes	25	DP1	3	3	Medical	1	1	Married	5	4031	3	2
EP442	delete	2024-07-19	Yes	41	DP2	20	2	Marketing	2	2	Single	1	3140	2	4
EP443	delete	2024-07-19	Yes	22	DP1	3	1	Life Sciences	2	3	Married	0	4171	4	3
EP444	delete	2024-07-19	Yes	47	DP2	27	2	Life Sciences	2	3	Single	4	6397	3	5
EP445	delete	2024-07-19	Yes	28	DP2	13	2	Marketing	4	3	Single	3	9854	3	2
EP446	delete	2024-07-19	Yes	40	DP1	7	3	Life Sciences	1	1	Single	3	2166	1	4
EP447	delete	2024-07-19	Yes	33	DP1	25	3	Medical	1	2	Single	4	2313	3	2
EP448	delete	2024-07-19	Yes	26	DP1	2	3	Life Sciences	1	1	Married	6	2042	3	3
EP449	delete	2024-07-19	Yes	32	DP1	5	2	Life Sciences	1	3	Single	3	2432	3	4
EP450	delete	2024-07-19	Yes	40	DP2	22	2	Marketing	3	3	Married	2	6380	3	6
EP451	delete	2024-07-19	Yes	41	DP2	1	2	Life Sciences	2	4	Single	8	5993	1	6
EP452	delete	2024-07-19	Yes	32	DP1	16	1	Life Sciences	2	1	Single	1	3919	3	10
EP453	delete	2024-07-19	Yes	32	DP1	25	4	Life Sciences	1	4	Single	1	2795	1	1
EP454	delete	2024-07-19	Yes	35	DP2	10	3	Medical	4	1	Married	9	10306	3	13
EP455	delete	2024-07-19	Yes	26	DP3	17	4	Life Sciences	2	3	Divorced	0	2741	2	7
EP456	delete	2024-07-19	Yes	46	DP1	21	2	Medical	4	2	Married	4	8926	4	9
EP457	delete	2024-07-19	Yes	33	DP1	3	3	Life Sciences	1	1	Single	1	3348	3	10
EP458	delete	2024-07-19	Yes	37	DP1	10	4	Medical	4	1	Single	1	4213	1	10
EP459	delete	2024-07-19	Yes	25	DP2	9	2	Life Sciences	1	1	Married	3	4400	3	3
EP460	delete	2024-07-19	Yes	43	DP2	9	3	Marketing	1	3	Single	8	5346	2	4
EP461	delete	2024-07-19	Yes	32	DP2	4	4	Medical	4	4	Married	1	10400	2	14
EP462	delete	2024-07-19	Yes	29	DP2	9	3	Marketing	2	2	Single	1	2760	3	2
EP463	delete	2024-07-19	Yes	26	DP2	29	2	Medical	2	1	Single	8	4969	3	2
EP464	delete	2024-07-19	Yes	37	DP1	11	2	Medical	1	2	Married	5	4777	1	1
EP465	delete	2024-07-19	Yes	35	DP2	10	3	Medical	4	1	Married	9	10306	3	13
EP466	delete	2024-07-19	Yes	53	DP1	2	5	Technical	3	4	Married	0	10169	3	33
EP467	delete	2024-07-19	Yes	18	DP1	3	3	Life Sciences	3	3	Single	1	1420	3	0
EP468	delete	2024-07-19	Yes	40	DP2	24	3	Life Sciences	2	2	Single	4	13194	2	1
EP469	delete	2024-07-19	Yes	34	DP1	7	3	Life Sciences	1	3	Single	1	6074	3	9
EP470	delete	2024-07-19	Yes	31	DP1	1	5	Life Sciences	3	2	Single	1	7446	3	10
EP471	delete	2024-07-19	Yes	35	DP1	25	4	Life Sciences	4	2	Divorced	1	2022	2	10
EP472	delete	2024-07-19	Yes	39	DP1	6	3	Medical	4	1	Married	7	2404	1	2
EP473	delete	2024-07-19	Yes	44	DP1	10	4	Life Sciences	3	3	Single	1	2936	3	6
EP474	delete	2024-07-19	Yes	29	DP1	1	4	Technical	1	1	Single	6	2362	1	9
EP475	delete	2024-07-19	Yes	38	DP1	2	3	Medical	3	2	Married	4	4855	3	5
EP476	delete	2024-07-19	Yes	42	DP2	12	3	Life Sciences	3	1	Single	0	13758	2	21
EP477	delete	2024-07-19	Yes	40	DP2	25	4	Marketing	4	2	Single	2	9094	3	5
EP478	delete	2024-07-19	Yes	31	DP2	1	4	Life Sciences	2	3	Single	1	1359	3	1
EP479	delete	2024-07-19	Yes	26	DP1	16	4	Medical	1	2	Divorced	2	2373	3	3
EP480	delete	2024-07-19	Yes	26	DP1	2	3	Life Sciences	1	1	Married	6	2042	3	3
EP481	delete	2024-07-19	Yes	30	DP1	22	3	Life Sciences	1	3	Married	4	2132	3	5
EP482	delete	2024-07-19	Yes	26	DP3	17	4	Life Sciences	2	3	Divorced	0	2741	2	7
EP483	delete	2024-07-19	Yes	41	DP2	1	2	Life Sciences	2	4	Single	8	5993	1	6
EP484	delete	2024-07-19	Yes	48	DP2	7	2	Medical	4	3	Married	2	2655	3	9
EP485	delete	2024-07-19	Yes	34	DP2	24	4	Medical	1	2	Single	0	4599	4	15
EP486	delete	2024-07-19	Yes	34	DP1	7	3	Life Sciences	1	3	Single	1	6074	3	9
EP487	delete	2024-07-19	Yes	44	DP1	15	3	Medical	1	4	Married	1	7978	3	10
EP488	delete	2024-07-19	Yes	34	DP1	16	4	Technical	4	1	Married	1	2307	3	5
EP489	delete	2024-07-19	Yes	37	DP1	2	2	Other	4	3	Single	6	2090	3	0
EP490	delete	2024-07-19	Yes	33	DP2	9	4	Marketing	1	1	Single	0	8224	3	5
EP491	delete	2024-07-19	Yes	33	DP1	3	3	Life Sciences	1	1	Single	1	3348	3	10
EP492	delete	2024-07-19	Yes	28	DP2	1	3	Technical	1	3	Married	3	2909	4	3
EP493	delete	2024-07-19	Yes	35	DP1	2	3	Life Sciences	1	1	Divorced	1	2074	3	1
EP494	delete	2024-07-19	Yes	26	DP2	4	4	Marketing	4	4	Single	1	5828	3	8
EP495	delete	2024-07-19	Yes	34	DP2	19	3	Marketing	1	4	Single	8	5304	2	5
EP496	delete	2024-07-19	Yes	49	DP1	28	2	Life Sciences	1	1	Single	3	4284	3	4
EP497	delete	2024-07-19	Yes	28	DP1	1	2	Life Sciences	1	2	Single	7	2216	3	7
EP498	delete	2024-07-19	Yes	44	DP1	3	3	Life Sciences	1	1	Married	4	2362	4	3
EP499	delete	2024-07-19	Yes	48	DP1	1	2	Life Sciences	1	3	Single	9	5381	3	1
EP500	delete	2024-07-19	Yes	29	DP2	23	1	Life Sciences	4	1	Married	1	7336	1	11
EP001	update	2024-07-19	No	36	DP1	11	3	Life Sciences	2	2	Single	1	6499	3	6
EP002	update	2024-07-19	No	58	DP2	21	3	Life Sciences	4	4	Married	4	17875	2	1
EP003	update	2024-07-19	No	25	DP1	5	2	Life Sciences	2	1	Divorced	1	4000	3	6
EP004	update	2024-07-19	No	46	DP2	2	4	Marketing	2	1	Single	3	18947	2	2
EP005	update	2024-07-19	No	45	DP2	2	2	Technical	2	3	Single	0	6632	3	8
\.


--
-- Data for Name: sys_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_user (id, name, role, username, password) FROM stdin;
US1	Fajar Waskito	admin	fwaskito	fwaskito123
\.


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- Name: employee_history employee_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_history
    ADD CONSTRAINT employee_history_pkey PRIMARY KEY (employee_id, modif_action);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- Name: sys_user sys_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT sys_user_pkey PRIMARY KEY (id);


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

