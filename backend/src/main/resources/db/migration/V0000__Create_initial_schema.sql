CREATE TABLE departments (
	department_id uuid NOT NULL,
	created timestamp NULL,
	created_by uuid NULL,
	last_modified timestamp NULL,
	last_modified_by uuid NULL,
	name varchar(255) NULL,
	email varchar(255) NULL,
	phone_number varchar(255) NULL,
	CONSTRAINT departments_pkey PRIMARY KEY (department_id),
	CONSTRAINT uk_qyf2ekbfpnddm6f3rkgt39i9o UNIQUE (name)
);

CREATE TABLE accounts (
	account_id uuid NOT NULL,
	created timestamp NULL,
	created_by uuid NULL,
	last_modified timestamp NULL,
	last_modified_by uuid NULL,
	username varchar(255) NULL,
	firstname varchar(255) NULL,
	lastname varchar(255) NULL,
	department_id uuid NULL,
	email varchar(255) NULL,
	password varchar(255) NULL,
	CONSTRAINT accounts_pkey PRIMARY KEY (account_id),
	CONSTRAINT accounts_department_fk FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE roles (
	role_id uuid NOT NULL,
	role_name varchar(255) NULL,
	CONSTRAINT roles_pkey PRIMARY KEY (role_id)
);

CREATE TABLE accounts_roles (
	account_account_id uuid NOT NULL,
	roles_role_id uuid NOT NULL,
	CONSTRAINT accounts_roles_account_fk FOREIGN KEY (roles_role_id) REFERENCES roles(role_id),
	CONSTRAINT accounts_roles_role_fk FOREIGN KEY (account_account_id) REFERENCES accounts(account_id)
);

CREATE TABLE symptoms (
	symptom_id uuid NOT NULL,
	is_characteristic bool NOT NULL,
	name varchar(255) NULL,
	CONSTRAINT symptoms_pkey PRIMARY KEY (symptom_id)
);

CREATE TABLE tracked_people (
	tracked_person_id uuid NOT NULL,
	created timestamp NULL,
	created_by uuid NULL,
	last_modified timestamp NULL,
	last_modified_by uuid NULL,
	city varchar(255) NULL,
	house_number varchar(255) NULL,
	street varchar(255) NULL,
	zipcode varchar(255) NULL,
	date_of_birth date NULL,
	email varchar(255) NULL,
	first_name varchar(255) NULL,
	last_name varchar(255) NULL,
	mobile_phone_number varchar(255) NULL,
	phone_number varchar(255) NULL,
	account_id uuid NULL,
	CONSTRAINT tracked_people_pkey PRIMARY KEY (tracked_person_id),
	CONSTRAINT tracked_people_account_id_role_fk FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE diary_entries (
	diary_entry_id uuid NOT NULL,
	created timestamp NULL,
	created_by uuid NULL,
	last_modified timestamp NULL,
	last_modified_by uuid NULL,
	temperature numeric(5,3) null,
	note varchar(255) NULL,
	reported_at timestamp NULL,
	date_of_slot date NULL,
	time_of_day integer NULL,
	tracked_person_id uuid NULL,
	CONSTRAINT diary_entries_pkey PRIMARY KEY (diary_entry_id),
	CONSTRAINT diary_entries_tracked_person_fk FOREIGN KEY (tracked_person_id) REFERENCES tracked_people(tracked_person_id)
);

CREATE TABLE initial_reports (
	initial_report_id uuid NOT NULL,
	belong_to_laboratory_staff bool NULL,
	belong_to_medical_staff bool NULL,
	belong_to_nursing_staff bool NULL,
	day_of_first_symptoms date NULL,
	direct_contact_with_liquids_ofc19pat bool NULL,
	family_member bool NULL,
	flight_crew_member_withc19pat bool NULL,
	flight_passenger_close_rowc19pat bool NULL,
	has_symptoms bool NULL,
	min15minutes_contact_withc19pat bool NULL,
	nursing_action_onc19pat bool NULL,
	other_contact_type varchar(255) NULL,
	CONSTRAINT initial_reports_pkey PRIMARY KEY (initial_report_id)
);

CREATE TABLE tracked_cases (
	tracked_case_id uuid NOT NULL,
	created timestamp NULL,
	created_by uuid NULL,
	last_modified timestamp NULL,
	last_modified_by uuid NULL,
	completed_contact_retro bool NOT NULL,
	completed_personal_data bool NOT NULL,
	completed_questionnaire bool NOT NULL,
	infected bool NOT NULL,
	quarantine_from date NULL,
	quarantine_to date NULL,
	test_date date NULL,
	case_type integer NULL,
	department_id uuid NULL,
	initial_report_id uuid NULL,
	tracked_person_id uuid NULL,
	status integer NOT NULL,
	CONSTRAINT tracked_cases_pkey PRIMARY KEY (tracked_case_id),
	CONSTRAINT tracked_cases_department_fk FOREIGN KEY (department_id) REFERENCES departments(department_id),
	CONSTRAINT tracked_cases_initial_report_fk FOREIGN KEY (initial_report_id) REFERENCES initial_reports(initial_report_id),
	CONSTRAINT tracked_cases_tracked_person_fk FOREIGN KEY (tracked_person_id) REFERENCES tracked_people(tracked_person_id)
);

CREATE TABLE contact_people (
	contact_person_id uuid NOT NULL,
	created timestamp NULL,
	created_by uuid NULL,
	last_modified timestamp NULL,
	last_modified_by uuid NULL,
	city varchar(255) NULL,
	house_number varchar(255) NULL,
	street varchar(255) NULL,
	zipcode varchar(255) NULL,
	email varchar(255) NULL,
	first_name varchar(255) NULL,
	has_pre_existing_conditions bool NULL,
	identification_hint varchar(255) NULL,
	is_health_staff bool NULL,
	is_senior bool NULL,
	last_name varchar(255) NULL,
	mobile_phone_number varchar(255) NULL,
	tracked_person_id uuid NULL,
	phone_number varchar(255) NULL,
	remark varchar(255) NULL,
	type_of_contract integer NULL,
	CONSTRAINT contact_people_pkey PRIMARY KEY (contact_person_id),
	CONSTRAINT contact_people_tracked_person_fk FOREIGN KEY (tracked_person_id) REFERENCES tracked_people(tracked_person_id)
);

CREATE TABLE comments (
	comment_id uuid NOT NULL,
	author varchar(255) NULL,
	text varchar(255) NULL,
	date timestamp NULL,
	tracked_case_id uuid NULL,
	CONSTRAINT comments_pkey PRIMARY KEY (comment_id),
	CONSTRAINT comments_tracked_case_fk FOREIGN KEY (tracked_case_id) REFERENCES tracked_cases(tracked_case_id)
);

CREATE TABLE diary_entries_contacts (
	diary_entry_diary_entry_id uuid NOT NULL,
	contacts_contact_person_id uuid NOT NULL,
	CONSTRAINT diary_entries_contacts_contact_person_fk FOREIGN KEY (contacts_contact_person_id) REFERENCES contact_people(contact_person_id),
	CONSTRAINT diary_entries_contacts_diary_entry_fk FOREIGN KEY (diary_entry_diary_entry_id) REFERENCES diary_entries(diary_entry_id)
);

CREATE TABLE diary_entries_symptoms (
	diary_entry_diary_entry_id uuid NOT NULL,
	symptoms_symptom_id uuid NOT NULL,
	CONSTRAINT diary_entries_symptoms_diary_entries_fk FOREIGN KEY (diary_entry_diary_entry_id) REFERENCES diary_entries(diary_entry_id),
	CONSTRAINT diary_entries_symptoms_symptons_fk FOREIGN KEY (symptoms_symptom_id) REFERENCES symptoms(symptom_id)
);

CREATE TABLE encounters (
	encounter_id uuid NOT NULL,
	encounter_date date NULL,
	contact_person_id uuid NULL,
	tracked_person_id uuid NULL,
	CONSTRAINT encounters_pkey PRIMARY KEY (encounter_id),
	CONSTRAINT encounters_contact_person_fk FOREIGN KEY (contact_person_id) REFERENCES contact_people(contact_person_id),
	CONSTRAINT encounters_tracked_person_fk FOREIGN KEY (tracked_person_id) REFERENCES tracked_people(tracked_person_id)
);

CREATE TABLE tracked_cases_origin_contacts (
	tracked_case_tracked_case_id uuid NOT NULL,
	origin_contacts_contact_person_id uuid NOT NULL,
	CONSTRAINT uk_5w3qfxyw7sumuhsejtngstp6u UNIQUE (origin_contacts_contact_person_id),
	CONSTRAINT tracked_cases_origin_contacts_contact_person_fk FOREIGN KEY (origin_contacts_contact_person_id) REFERENCES contact_people(contact_person_id),
	CONSTRAINT tracked_cases_origin_contacts_tracked_case_fk FOREIGN KEY (tracked_case_tracked_case_id) REFERENCES tracked_cases(tracked_case_id)
);

CREATE TABLE activation_codes (
	activation_code_id uuid NOT NULL,
	created timestamp NULL,
	created_by uuid NULL,
	last_modified timestamp NULL,
	last_modified_by uuid NULL,
	activation_tries integer NOT NULL,
	department_id uuid NULL,
	expiration_time timestamp NULL,
	status integer NULL,
	tracked_person_id uuid NULL,
	CONSTRAINT activation_codes_pkey PRIMARY KEY (activation_code_id),
	CONSTRAINT activation_codes_tracked_person_fk FOREIGN KEY (tracked_person_id) REFERENCES tracked_people(tracked_person_id),
	CONSTRAINT activation_codes_department_fk FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE action_items (
	action_item_id uuid NULL,
	dtype varchar(31) NOT NULL,
	created timestamp NULL,
	created_by uuid NULL,
	last_modified timestamp NULL,
	last_modified_by uuid NULL,
	arguments varchar(255) NULL,
	code integer NULL,
	tracked_person_id uuid NULL,
	tracked_case_id uuid NULL,
	resolved bool NOT NULL,
	item_type integer NULL,
	date_of_slot date NULL,
	time_of_day integer NULL,
	entry_diary_entry_id uuid NULL,
	CONSTRAINT action_items_pkey PRIMARY KEY (action_item_id),
	CONSTRAINT action_items_tracked_cases_fk FOREIGN KEY (tracked_case_id) REFERENCES tracked_cases(tracked_case_id),
	CONSTRAINT action_items_tracked_people_fk FOREIGN KEY (tracked_person_id) REFERENCES tracked_people(tracked_person_id),
	CONSTRAINT action_items_diary_entries_fk FOREIGN KEY (entry_diary_entry_id) REFERENCES diary_entries(diary_entry_id)
);
