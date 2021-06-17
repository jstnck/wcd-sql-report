

from mysql.connector import connect, Error



conn = connect(host="localhost", user="root", password="admin")

with open('sql-scripts/1-create-db.sql', 'r') as sqlfile:
    create_db_query = sqlfile

with open('sql-scripts/2-create-tables-data.sql', 'r') as sqlfile:
    create_tables_query = sqlfile

with open('sql-scripts/3-alter_table.sql', 'r') as sqlfile:
    alter_table_query = sqlfile

with open('sql-scripts/4b-customer-segment-views.sql', 'r') as sqlfile:
    customer_segment_query = sqlfile

with open('sql-scripts/6-generate-report-table.sql', 'r') as sqlfile:
    generate_report_query = sqlfile


try:
    create_db_query = "CREATE DATABASE online_movie_rating"
    with conn.cursor() as cursor:
        cursor.execute(create_db_query)
except Error as e:
    print(e)


show_db_query = "SHOW DATABASES"
with conn.cursor() as cursor:
    cursor.execute(show_db_query)
    for db in cursor:
        print(db)



