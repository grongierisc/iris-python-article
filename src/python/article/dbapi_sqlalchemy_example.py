# src/python/article/dbapi_sqlalchemy_example.py
from sqlalchemy import create_engine, text

COMMUNITY_DRIVER_URL = "iris://_SYSTEM:SYS@localhost:1972/USER"
OFFICIAL_DRIVER_URL = "iris+intersystems://_SYSTEM:SYS@localhost:1972/USER"
EMBEDDED_PYTHON_DRIVER_URL = "iris+emb:///USER"

def run(driver):
    # Create an engine using the official driver
    engine = create_engine(driver)

    with engine.connect() as connection:
        # Execute a query
        result = connection.execute(text("SELECT 1 AS one, 2 AS two"))

        for row in result:
            print(f"one: {row.one}, two: {row.two}")

if __name__ == "__main__":
    run(OFFICIAL_DRIVER_URL)
    run(COMMUNITY_DRIVER_URL)
    run(EMBEDDED_PYTHON_DRIVER_URL)
    