-- My Profile (Page 3)

-- Generates Employee data report
select EMPLOYEE_NAME,l.LAB_NAME,EMAIL,PHONE 
from F15A4_EMP e 
LEFT OUTER JOIN F15A4_LAB l 
  ON e.F15A4_LAB_LAB_ID = l.LAB_ID 
  where employee_id = :P2_EMP;

-- Page 4: My RFE's

-- Generates Report on all RFE's created by logged in user
select r.RFE_ID, STATUS_TYPE 
AS "Status",EXPLANATION,ALT_PROTECTIONS as "Alt Protections" 
from F15A4_rfe r, F15A4_status s 
where r.F15A4_STATUS_STATUS_ID = s.STATUS_ID 
  and r.F15A4_EMP_EMPLOYEE_ID = :P2_EMP;

-- Page 5: My FYI RFE's

-- Generates Report on all RFE's user has been added as a contact to
select r.RFE_ID,STATUS_TYPE AS "Status",e.EMPLOYEE_NAME,EXPLANATION,ALT_PROTECTIONS as "Alt Protections" 
from F15A4_RFE r, F15A4_status s, F15A4_emp e 
where e.employee_id = r.f15a4_emp_employee_id 
  and r.F15A4_STATUS_STATUS_ID = s.STATUS_ID 
  and r.RFE_ID in (select F15A4_rfe_rfe_id 
                   from F15A4_CONTACT c 
                   WHERE c.F15A4_EMP_EMPLOYEE_ID = :P2_EMP);

-- Generates Report on all RFE's user is in position to review
-- Must be System Admin and above to access
select r.RFE_ID,STATUS_TYPE AS "Status",e.EMPLOYEE_NAME,EXPLANATION,ALT_PROTECTIONS as "Alt Protections" 
from F15A4_RFE r, F15A4_status s, F15A4_emp e 
where e.employee_id = r.f15a4_emp_employee_id 
  and r.F15A4_STATUS_STATUS_ID = s.STATUS_ID 
  and ((((select is_chair from F15A4_emp where employee_id = :P2_EMP) = 'Y') 
  and r.F15A4_status_status_id = 106) 
  or  (((select is_exec_dir from F15A4_emp where employee_id = :P2_EMP) = 'Y') and r.F15A4_status_status_id = 107) 
  or (((select is_sys_admin from F15A4_emp where employee_id = :P2_EMP) = 'Y') and r.F15A4_status_status_id = 101) 
  or  (((select is_lab_dir from F15A4_emp where employee_id = :P2_EMP) = 'Y') and r.F15A4_status_status_id = 105));

-- Page 8: Admin Panel / RFE's
-- Admins can see all RFE's and go to edit page
select r.RFE_ID,STATUS_TYPE AS "Status",e.EMPLOYEE_NAME,EXPLANATION,ALT_PROTECTIONS as "Alt Protections" 
from F15A4_RFE r, F15A4_status s, F15A4_emp e 
where e.employee_id = r.f15a4_emp_employee_id 
  and r.F15A4_STATUS_STATUS_ID = s.STATUS_ID 
  and (select F15A4_AUTH_AUTH_ID from F15A4_emp where employee_id = :P2_EMP) = 101;

-- Page 9: Admin Panel / Employees
-- Admins can view/modify metadata of employees
select EMPLOYEE_ID,EMPLOYEE_NAME,EMAIL,PHONE,STATUS_EFFECTIVE_DATE,ACTIVE,IS_SYS_ADMIN,IS_LAB_DIR,IS_CHAIR,IS_EXEC_DIR,LAB_NAME,AUTHORIZATION 
from F15A4_emp e, F15A4_lab l, F15A4_auth a 
where e.f15a4_lab_lab_id = l.lab_id 
  and e.F15A4_AUTH_AUTH_ID = a.auth_id 
  and (select F15A4_AUTH_AUTH_ID from F15A4_emp where employee_id = :P2_EMP) = 101;

-- Page 10: Admin Panel / Labs
-- Admins can view/modify/add labs
select lab_id,lab_code,lab_name  
from F15A4_lab 
where 
  (select F15A4_AUTH_AUTH_ID from F15A4_emp where employee_id = :P2_EMP) = 101;

-- Page 11: Create RFE Modal
-- Page pops up modal to store explanation and alt protections

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

-- Page 12: Individual RFE view
-- view of the RFE data again
select r.RFE_ID,STATUS_TYPE AS "Status",e.EMPLOYEE_NAME,EXPLANATION,ALT_PROTECTIONS as "Alt Protections" 
from F15A4_RFE r, F15A4_status s, F15A4_emp e 
where e.employee_id = r.f15a4_emp_employee_id 
  and r.F15A4_STATUS_STATUS_ID = s.STATUS_ID 
  and r.RFE_ID = :SELECTED_RFE;

-- view of the history of the RFE
select * 
from f15a4_history 
where f15a4_rfe_rfe_id = :SELECTED_RFE;

-- view of the contacts of RFE
select employee_name 
from f15a4_emp e 
join f15a4_contact c 
  on c.f15a4_emp_employee_id=e.employee_id 
where f15a4_rfe_rfe_id = :SELECTED_RFE;

-- view of documents of RFE
select * 
from f15a4_document 
where f15a4_rfe_rfe_id = :SELECTED_RFE;

-- view of comments on RFE
select e.employee_name,c.comment_body as "Comment" 
from f15a4_comment c 
join f15a4_emp e 
  on c.f15a4_emp_employee_id = e.employee_id 
where f15a4_rfe_rfe_id = :SELECTED_RFE;

-- actions on button clicks in RFE view:
-- Add Contact
INSERT INTO f15a4_contact VALUES
(V('SELECTED_RFE'), V('P12_ADD_CONTACT'));
COMMIT;

-- Submit RFE
UPDATE f15a4_rfe
SET f15a4_status_status_id = 101
WHERE RFE_ID = :SELECTED_RFE;

COMMIT;

-- Approve RFE
UPDATE f15a4_rfe
SET f15a4_status_status_id = CASE f15a4_status_status_id 
        WHEN 101 THEN 105
        WHEN 105 THEN 106
        WHEN 106 THEN 107
        WHEN 107 THEN 108
      END
WHERE rfe_id = :SELECTED_RFE;

INSERT INTO f15a4_comment(comment_body,F15A4_rfe_rfe_id,F15A4_emp_employee_id)
VALUES ('Approved by ' || (select employee_name from f15a4_emp where employee_id = :P2_EMP), :SELECTED_RFE, :P2_EMP);

COMMIT;

INSERT INTO f15a4_history(EFFECTIVE_DATE,F15A4_RFE_RFE_ID,F15A4_STATUS_STATUS_ID,F15A4_EMP_EMPLOYEE_ID)
VALUES (SYSDATE(), :SELECTED_RFE, (SELECT F15A4_STATUS_STATUS_ID from f15a4_rfe where RFE_ID = :SELECTED_RFE), :P2_EMP);

COMMIT;

-- Return RFE
UPDATE f15a4_rfe
SET f15a4_status_status_id = 102
WHERE RFE_ID = :SELECTED_RFE;

COMMIT;

-- Reject RFE
UPDATE f15a4_rfe
SET f15a4_status_status_id = 104
WHERE RFE_ID = :SELECTED_RFE;

COMMIT;

INSERT INTO f15a4_comment(comment_body,F15A4_rfe_rfe_id,F15A4_emp_employee_id)
VALUES ('Rejected by ' || (select employee_name from f15a4_emp where employee_id = :P2_EMP), :SELECTED_RFE, :P2_EMP);

COMMIT;

-- Recall RFE
UPDATE f15a4_rfe
SET f15a4_status_status_id = 103
WHERE RFE_ID = :SELECTED_RFE;

COMMIT;

-- Add Comment
INSERT INTO f15a4_comment(comment_body,F15A4_rfe_rfe_id,F15A4_emp_employee_id)
VALUES (V('P12_COMMENT'),V('SELECTED_RFE'), V('P2_EMP'));

COMMIT;

-- Duplicate RFE
INSERT INTO f15a4_rfe(explanation,alt_protections)
    SELECT explanation, alt_protections FROM f15a4_rfe WHERE rfe_id = :SELECTED_RFE;
COMMIT;

-- Page 13: Edit RFE
UPDATE f15a4_rfe
SET explanation = :P13_explanation
WHERE RFE_ID = :SELECTED_RFE;

UPDATE f15a4_rfe
SET alt_protections = :P13_alt_protections
WHERE RFE_ID = :SELECTED_RFE;

COMMIT;