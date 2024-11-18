from flask import Flask, render_template, request
from flask import Flask, request, render_template, flash, redirect, url_for
import mysql.connector
import os

app = Flask(__name__)

# Secure secret key
app.secret_key = os.getenv('FLASK_SECRET_KEY', 'fallback_secret_key')


# Database connection configuration
db_config = {
    'host': '127.0.0.1',
    'user': 'Abhiram',
    'password': 'Abhi@1910',
    'database': 'RentalAgency'
}

@app.route('/test_connection')
def test_connection():
    try:
        conn = mysql.connector.connect(**db_config)
        if conn.is_connected():
            return "Database connection is successful!"
        else:
            return "Database connection failed!"
    except mysql.connector.Error as err:
        return f"Error: {err}"
    finally:
        if conn.is_connected():
            conn.close()

# Function to get a database connection
def get_db_connection():
    return mysql.connector.connect(**db_config)

# Route for the home page
@app.route('/')
def home():
    return render_template('index.html')


# Route to display tables in the database
@app.route('/show_tables')
def show_tables():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SHOW TABLES;")
    tables = cursor.fetchall()
    conn.close()
    return render_template('tables.html', tables=tables)

# Route to display data from a specific table
@app.route('/show_data/<table_name>')
def show_data(table_name):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(f"SELECT * FROM {table_name};")
    data = cursor.fetchall()
    columns = cursor.column_names
    conn.close()
    return render_template('Results.html', columns=columns, data=data, table_name=table_name)

# Route to execute custom SQL queries
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

@app.route('/Phone', methods=['GET', 'POST'])
def phone_details():
    phone_details = None
    if request.method == 'POST':
        adhar_id = request.form['adhar_id']
        
        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Call your stored procedure or run a query
        cursor.callproc('GetPhoneDetailsByAdhar', [adhar_id])

        # Fetch the results
        phone_details = []
        for result in cursor.stored_results():
            phone_details = result.fetchall()

        cursor.close()
        conn.close()

    return render_template('phone_details.html', phone_details=phone_details)

@app.route('/Properties', methods=['GET', 'POST'])
def properties_by_manager():
    property_details = None
    if request.method == 'POST':
        manager_id = request.form['manager_id']
        
        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Call the stored procedure
        cursor.callproc('GetPropertiesByManagers', [manager_id])

        # Fetch the results
        property_details = []
        for result in cursor.stored_results():
            property_details = result.fetchall()

        cursor.close()
        conn.close()

    return render_template('properties_details.html', property_details=property_details)


@app.route('/No_Brokers', methods=['GET', 'POST'])
def users_without_brokers():
    users = None
    if request.method == 'POST':
        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Call the stored procedure
        cursor.callproc('GetUsersWithoutBrokers')

        # Fetch the results
        users = []
        for result in cursor.stored_results():
            users = result.fetchall()

        cursor.close()
        conn.close()

    return render_template('users_without_brokers.html', users=users)


@app.route('/add_payment', methods=['GET', 'POST'])
def add_payment():
    if request.method == 'POST':
        adhar_id = request.form.get('adhar_id')
        prop_id = request.form.get('prop_id')
        payment_date = request.form.get('payment_date')
        amount = request.form.get('amount')
        method = request.form.get('method')

        try:
            connection = get_db_connection()
            cursor = connection.cursor()
            # Call the stored procedure
            cursor.callproc('AddPayment', [adhar_id, prop_id, payment_date, amount, method])
            connection.commit()
            flash('Payment record added successfully!', 'success')
        except mysql.connector.Error as err:
            flash(f"Error: {err.msg}", 'danger')
        finally:
            cursor.close()
            connection.close()
        
        return redirect(url_for('add_payment'))

    return render_template('add_payment.html')

if __name__ == "__main__":
    app.run(debug=True)
