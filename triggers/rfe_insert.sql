-- For insert into RFE table in APEX
-- Trigger autofills 'Entered' status and P2_EMP Global variable
create or replace trigger F15A4_rfe_insert_trig 
before insert on F15A4_rfe
for each row 
begin 
  select V('P2_EMP') into :new.F15A4_emp_employee_id 
  from dual; 
  select status_id into :new.F15A4_status_status_id 
  from F15A4_status 
  where status_type = 'Entered';
end; 
/