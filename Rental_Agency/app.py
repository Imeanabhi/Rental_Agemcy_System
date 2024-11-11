from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

# Database connection configuration
db_config = {
    'host': 'localhost',
    'user': 'Abhiram',        # replace with your MySQL username
    'password': 'Abhi@1910',    # replace with your MySQL password
    'database': 'RentalAgency'
}

# Function to get a database connection
def get_db_connection():
    return mysql.connector.connect(**db_config)

# Route for home page
@app.route('/')
def home():
    return render_template('index.html')

# Route to show tables
@app.route('/show_tables')
def show_tables():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SHOW TABLES;")
    tables = cursor.fetchall()
    conn.close()
    return render_template('tables.html', tables=tables)

# Route to display data from a selected table
@app.route('/show_data/<table_name>')
def show_data(table_name):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(f"SELECT * FROM {table_name};")
    data = cursor.fetchall()
    columns = cursor.column_names
    conn.close()
    return render_template('Results.html', columns=columns, data=data, table_name=table_name)

# Route to execute a custom query
@app.route('/Queries', methods=['GET', 'POST'])
def custom_query():
    if request.method == 'POST':
        query = request.form['query']
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query)
        result = cursor.fetchall()
        columns = cursor.column_names
        conn.close()
        return render_template('Results.html', columns=columns, data=result, query=query)
    return render_template('Queries.html')

if __name__ == "__main__":
    app.run(debug=True)
