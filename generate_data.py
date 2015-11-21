from faker import Faker

fake = Faker()

for x in range(30):
  first = fake.first_name()
  last = fake.last_name()
  name_string = "{}, {} X.".format(last, first)
  email = "{}.{}@arl.org".format(first, last)
  print("INSERT INTO F15A4_emp(employee_name, email, phone, status_effective_date, active, is_sys_admin, is_lab_dir, is_chair, is_exec_dir, F15A4_lab_lab_id, F15A4_auth_auth_id) VALUES(\'{}\', \'{}\', \'{}\', TO_DATE(\'{}\','YYYY-MM-DD HH24:MI:SS'));".format(name_string, email, fake.random_number(digits=10),fake.date_time_this_year(before_now=True, after_now=False)))