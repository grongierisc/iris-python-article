import intersystems_iris.dbapi._DBAPI as dbapi

config = {
    "hostname": "localhost",
    "port": 1972,
    "namespace": "USER",
    "username": "_SYSTEM",
    "password": "SYS",
}

with dbapi.connect(**config) as conn:
    with conn.cursor() as cursor:
        cursor.execute("select ? as one, 2 as two", 1)   # second arg is parameter value
        for row in cursor:
            one, two = row
            print(f"one: {one}")
            print(f"two: {two}")