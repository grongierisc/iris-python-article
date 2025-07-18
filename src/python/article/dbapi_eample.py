import iris

def run():
    # Connect to the IRIS database
# Open a connection to the server
    args = {
        'hostname':'127.0.0.1', 
        'port': 1972,
        'namespace':'USER', 
        'username':'SuperUser', 
        'password':'SYS'
    }
    conn = iris.connect(**args)

    # Create a cursor
    cursor = conn.cursor()

    # Execute a query
    cursor.execute("SELECT 1")

    # Fetch all results
    results = cursor.fetchall()

    for row in results:
        print(row)

    # Close the cursor and connection
    cursor.close()
    conn.close()
if __name__ == "__main__":
    run()