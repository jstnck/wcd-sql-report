

from mysql.connector import connect, Error



conn = connect(host="localhost", user="root", password="admin")

##### 1. create the database ######
with open('sql-scripts/1-create-db.sql', 'r') as sqlfile:
    create_db_query = sqlfile

try:
    with conn.cursor() as cursor:
        cursor.execute(create_db_query)
except Error as e:
    print(e)


##### 2. create the tables and insert the data ######
with open('sql-scripts/2-create-tables-data.sql', 'r') as sqlfile:
    create_tables_query = sqlfile

try:
    with conn.cursor() as cursor:
        cursor.execute(create_tables_query)
except Error as e:
    print(e)

##### 3. modify the column names to be more clear ######
with open('sql-scripts/3-alter_table.sql', 'r') as sqlfile:
    alter_table_query = sqlfile

try:
    with conn.cursor() as cursor:
        cursor.execute(alter_tables_query)
except Error as e:
    print(e)


##### 4. generate helper views for analytics  ######
with open('sql-scripts/4b-customer-segment-views.sql', 'r') as sqlfile:
    customer_segment_query = sqlfile

try:
    with conn.cursor() as cursor:
        cursor.execute(customer_segment_query)
except Error as e:
    print(e)


##### 5. query to create a report output table  ######

with open('sql-scripts/5-generate-report-table.sql', 'r') as sqlfile:
    generate_report_query = sqlfile

try:
    with conn.cursor() as cursor:
        cursor.execute(generate_report_query)
except Error as e:
    print(e)



