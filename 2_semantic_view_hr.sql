SET current_user_name = CURRENT_USER();
SET schema_name = 'DEMO.' || $current_user_name;

use schema IDENTIFIER($schema_name);

create or replace semantic view HR
	tables (
		DEMO.HR.EMPLOYEE primary key (EMPLOYEE_ID) comment='This table stores information about employees within an organization, including their unique identifier, personal details, job information, and employment history.',
		DEMO.HR.HR_EVENT primary key (EVENT_ID) comment='This table stores information about various events related to employees, such as training sessions, performance reviews, or disciplinary actions. Each event is uniquely identified by an EVENT_ID and is associated with a specific employee (EMPLOYEE_ID). The EVENT_TYPE column describes the nature of the event, EVENT_DATE records when the event occurred, and EVENT_RESULT captures the outcome or result of the event.'
	)
	relationships (
		EVENT_EMPLOYEE as HR_EVENT(EMPLOYEE_ID) references EMPLOYEE(EMPLOYEE_ID)
	)
	dimensions (
		EMPLOYEE.EMPLOYEE_ID as EMPLOYEE_ID comment='Unique identifier for each employee in the organization.',
		EMPLOYEE.FIRST_NAME as FIRST_NAME comment='The first name of the employee.',
		EMPLOYEE.GENDER as GENDER comment='The gender of the employee, either Male (M) or Female (F).',
		EMPLOYEE.HIRE_DATE as HIRE_DATE comment='Date on which the employee started working for the company.',
		EMPLOYEE.LAST_NAME as LAST_NAME comment='Employee''s last name.',
		EMPLOYEE.LOCATION as LOCATION comment='The city where the employee is based.',
		EMPLOYEE.POSITION as POSITION comment='The POSITION column represents the job title or role of an employee within the organization, indicating their specific function or responsibility.',
		HR_EVENT.EMPLOYEE_ID as EMPLOYEE_ID comment='Unique identifier for an employee in the organization.',
		HR_EVENT.EVENT_DATE as EVENT_DATE comment='Date on which the HR event occurred.',
		HR_EVENT.EVENT_ID as EVENT_ID comment='Unique identifier for a specific event in the HR system.',
		HR_EVENT.EVENT_RESULT as EVENT_RESULT comment='The outcome or status of an HR-related event, such as a performance review or job application, indicating whether the event resulted in the employee being returned to their current role, promoted to a new role, or if the outcome is still pending.',
		HR_EVENT.EVENT_TYPE as EVENT_TYPE comment='The type of event that occurred to an employee, such as being hired, promoted, or leaving the company.'
	)
	with extension (CA='{"tables":[{"name":"EMPLOYEE","dimensions":[{"name":"EMPLOYEE_ID","sample_values":["1","2","3"]},{"name":"FIRST_NAME","sample_values":["Anna","Olha","Dmytro"]},{"name":"GENDER","sample_values":["M","F"]},{"name":"LAST_NAME","sample_values":["Petrenko","Ivanenko","Shevchuk"]},{"name":"LOCATION","sample_values":["Lviv","Kyiv","Dnipro"]},{"name":"POSITION","sample_values":["HR Analyst","HR Manager","Recruiter"]}],"time_dimensions":[{"name":"HIRE_DATE","sample_values":["2021-03-10","2020-01-15","2019-06-24"]}]},{"name":"HR_EVENT","dimensions":[{"name":"EMPLOYEE_ID","sample_values":["1","2","3"]},{"name":"EVENT_ID","sample_values":["29","1","2"]},{"name":"EVENT_RESULT","sample_values":["Returned","Promoted","Pending"]},{"name":"EVENT_TYPE","sample_values":["Hire","Promotion","Leave"]}],"time_dimensions":[{"name":"EVENT_DATE","sample_values":["2021-03-10","2020-01-15","2019-06-24"]}]}],"relationships":[{"name":"EVENT_EMPLOYEE"}]}'
    );

SELECT 'https://app.snowflake.com/_deeplink/#/cortex/analyst/databases/DEMO/schemas/' || $current_user_name || '/semanticView/HR/edit' as go_to_url;