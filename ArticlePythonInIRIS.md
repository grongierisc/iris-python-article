# Article Python in IRIS

Now that we have a good understanding of Python and its features, let's explore how we can leverage Python within IRIS.

We will start with the beginning, the language tag, we will see the pros and cons of using it, next we will see how to import Python modules and how to use them in ObjectScript, then we will finish with the Python first approach in IRIS.

- [Article Python in IRIS](#article-python-in-iris)
- [Language Tag](#language-tag)
  - [How to use it?](#how-to-use-it)
  - [Pros](#pros)
  - [Cons](#cons)
  - [Conclusion](#conclusion)
- [Importing Python Modules (pypi modules)](#importing-python-modules-pypi-modules)
  - [How to use it](#how-to-use-it-1)
  - [Pros](#pros-1)
  - [Cons](#cons-1)
  - [Conclusion](#conclusion-1)
- [Importing Python Modules (custom modules)](#importing-python-modules-custom-modules)
  - [How to use it](#how-to-use-it-2)
  - [Pros](#pros-2)
  - [Cons](#cons-2)
  - [Conclusion](#conclusion-2)
- [Python First Approach](#python-first-approach)
  - [How to use it (irispython)](#how-to-use-it-irispython)
    - [What is irispython?](#what-is-irispython)
    - [Example of using irispython](#example-of-using-irispython)
    - [Pros](#pros-3)
    - [Cons](#cons-3)
    - [Conclusion](#conclusion-3)
  - [Using WSGI](#using-wsgi)
    - [How to use it](#how-to-use-it-3)
    - [Example of using WSGI](#example-of-using-wsgi)
    - [Pros](#pros-4)
    - [Cons](#cons-4)
    - [Conclusion](#conclusion-4)
  - [DB-API](#db-api)
    - [How to use it](#how-to-use-it-4)
    - [Example of using DB-API](#example-of-using-db-api)
    - [Pros](#pros-5)
    - [Cons](#cons-5)
    - [Alternatives](#alternatives)
    - [Conclusion](#conclusion-5)
  - [Notebook](#notebook)
    - [How to use it](#how-to-use-it-5)
    - [Example of using Notebook](#example-of-using-notebook)
    - [Pros](#pros-6)
    - [Cons](#cons-6)
    - [Conclusion](#conclusion-6)
- [Bonus Section](#bonus-section)
  - [Using a native interpreter (no `irispython`)](#using-a-native-interpreter-no-irispython)
    - [How to use it](#how-to-use-it-6)
    - [Pros](#pros-7)
    - [Cons](#cons-7)
  - [DB-API Community Edition](#db-api-community-edition)
    - [How to use it](#how-to-use-it-7)
    - [Example of using DB-API](#example-of-using-db-api-1)
    - [Pros](#pros-8)
    - [Cons](#cons-8)
  - [Debugging Python Code in IRIS](#debugging-python-code-in-iris)
    - [How to use it](#how-to-use-it-8)


# Language Tag

The language tag is a feature of IRIS that allows you to write Python code directly in your ObjectScript classes.

This is useful for quick prototyping or when you want to use Python's features without creating a separate Python script.

## How to use it?

To use the language tag, you need to define a class method with the `Language = python` attribute. Here's an example:

```objectscript
Class Article.LanguageTagExample Extends %RegisteredObject
{

ClassMethod Run() [ Language = python ]
{
        import requests

        response = requests.get("https://2eb86668f7ab407989787c97ec6b24ba.api.mockbin.io/")

        my_dict = response.json()

        for key, value in my_dict.items():
            print(f"{key}: {value}") # print message: Hello World
}

}
```

So what are the pros and cons of using the language tag?

## Pros

- **Simplicity**: You can write Python code directly in your ObjectScript classes without needing to create separate Python files.
- **Quick Prototyping**: It's great for quick prototyping or testing small pieces of Python code.
- **Integration**: You can easily integrate Python code with your ObjectScript code

## Cons

- **Mixed Code**: Mixing Python and ObjectScript code can make your code harder to read and maintain.
- **Debugging**: You can't remotely debug Python code written in the language tag, which can be a limitation for complex applications.
- **Tracebacks**: Python tracebacks are not displayed, you only see an ObjectScript error message, which can make debugging more difficult.

## Conclusion

The language tag is a powerful feature that allows you to write Python code directly in your ObjectScript classes. However, it has its limitations, and it's important to use it wisely. For larger projects or when you need to debug your Python code, it's better to create separate Python scripts and import them into your ObjectScript classes.

# Importing Python Modules (pypi modules)

Now that we have a good understanding of the language tag, let's explore how to import Python modules and use them in ObjectScript.

First, we will do it only with the built-in third-party modules that come from PyPI, like `requests`, `numpy`, etc.

## How to use it 

So here, we will do the same thing, but using only the requests module from PyPI.

```objectscript
Class Article.RequestsExample Extends %RegisteredObject
{

ClassMethod Run() As %Status
{
    set builtins = ##class(%SYS.Python).Import("builtins")
    Set requests = ##class(%SYS.Python).Import("requests")

    Set response = requests.get("https://2eb86668f7ab407989787c97ec6b24ba.api.mockbin.io/")
    Set myDict = response.json()

    for i=0:1:builtins.len(myDict)-1 {
        set key = builtins.list(myDict.keys())."__getitem__"(i)
        set value = builtins.list(myDict.values())."__getitem__"(i)
        write key, ": ", value, !
    }
}

}
```

Let's run it:

```bash
iris session iris -U IRISAPP '##class(Article.RequestsExample).Run()'
```

You will see the output:

```
message: Hello World
```

## Pros

- **Access to Python Libraries**: You can use any Python library available on PyPI, which gives you access to a vast ecosystem of libraries and tools.
- **One type of code**: You are only writing ObjectScript code, which makes it easier to read and maintain.
- **Debugging**: You can debug your ObjectScript as it was only ObjectScript code, which it is :)

## Cons

- **Good knowledge of Python**: You need to have a good understanding of Python to use its libraries effectively.
  - See the articles about dunder methods for example.
- **Not writing Python code**: You are not writing Python code, but ObjectScript code that calls Python code, which avoids the sugar syntax of Python.

## Conclusion

In conclusion, importing Python modules into ObjectScript can greatly enhance your application's capabilities by leveraging the vast ecosystem of Python libraries. However, it's essential to understand the trade-offs involved, such as the need for a solid grasp of Python.

# Importing Python Modules (custom modules)

Let's keep going with the same example, but this time we will create a custom Python module and import it into ObjectScript.

This time, we will be using python as much as possible, and we will only use ObjectScript to call the Python code.

## How to use it

Let's create a custom Python module named `my_script.py` with the following content:

```python
import requests

def run():
    response = requests.get("https://2eb86668f7ab407989787c97ec6b24ba.api.mockbin.io/")

    my_dict = response.json()

    for key, value in my_dict.items():
        print(f"{key}: {value}") # print message: Hello World
```

Now, we will create an ObjectScript class to import and run this Python module:

```objectscript
Class Article.MyScriptExample Extends %RegisteredObject
{
    ClassMethod Run() As %Status
    {
        set sys = ##class(%SYS.Python).Import("sys")
        do sys.path.append("/irisdev/app/src/python/article")  // Adjust the path to your module

        Set myScript = ##class(%SYS.Python).Import("my_script")

        Do myScript.run()

        Quit $$$OK
    }
}
```

Now, let's run it:

```bash
iris session iris -U IRISAPP '##class(Article.MyScriptExample).Run()'
```

⚠️ Don't forget to change your iris session to make sure you are on the last version of the code, see the first article for more details.

You will see the output:

```
message: Hello World
```

This demonstrates how to import a custom Python module into ObjectScript and execute its code.

## Pros

- **Modularity**: You can organize your Python code into modules, making it easier to manage and maintain.
- **Python Syntax**: You can write Python code with its syntax and features
- **Debugging**: Not of the box today, but in the [bonus section](#bonus-section), we will see how to debug Python code in IRIS.

## Cons

- **Path Management**: You need to manage the path to your Python module, see the article about `sys.path` for more details.
- **Python Knowledge**: You still need to have a good understanding of Python to write and maintain your modules.
- **ObjectScript Knowledge**: You need to know how to use ObjectScript to import and call your Python modules.

## Conclusion

In conclusion, importing Python modules into ObjectScript can greatly enhance your application's capabilities by leveraging the vast ecosystem of Python libraries. However, it's essential to understand the trade-offs involved, such as the need for a solid grasp of Python.

# Python First Approach

In this section, we will explore how to use Python as the primary language in IRIS, allowing you to write your application logic in Python while still leveraging the power of IRIS.

This is a big topic, so we will only scratch the surface here, but I will provide you with the necessary resources to dive deeper into this topic. And maybe we will have a dedicated article about it in the future.

## How to use it (irispython)

First, let's start by the official way of doing things, which is using the `irispython` interpreter.

You can use the `irispython` interpreter to run Python code directly in IRIS. This allows you to write Python code and execute it in the context of your IRIS application.

### What is irispython?

`irispython` is a Python interpreter that is located in the IRIS installation directory (`<installation_directory>/bin/irispython`), and it is used to run Python code in the context of IRIS.

It will for you:
- Set up the `sys.path` to include the IRIS Python libraries and modules.
    - This is done by the `site.py` file, which is located in `<installation_directory>/lib/python/iris_site.py`.
- Allow you to import `iris` modules which is a special module that provides access to IRIS features and functionality like bridging any ObjectScript class to Python, and vice versa.
- Fix permissions issues and dynamic loading of iris kernel libraries.

### Example of using irispython

You can run the `irispython` interpreter from the command line:

```bash
<installation_directory>/bin/irispython
```

Let's run a simple example:

```python
# src/python/article/irispython_example.py
import requests
import iris

def run():
    response = requests.get("https://2eb86668f7ab407989787c97ec6b24ba.api.mockbin.io/")

    my_dict = response.json()

    for key, value in my_dict.items():
        print(f"{key}: {value}")  # print message: Hello World

    return my_dict

if __name__ == "__main__":
    print(f"Iris version: {iris.cls('%SYSTEM.Version').GetVersion()}")
    run()
```

You can run this script using the `irispython` interpreter:

```bash
<installation_directory>/bin/irispython src/python/article/irispython_example.py
```

You will see the output:

```
Iris version: IRIS for UNIX (Ubuntu Server LTS for x86-64 Containers) 2025.1 (Build 223U) Tue Mar 11 2025 18:23:31 EDT
message: Hello World
```

This demonstrates how to use the `irispython` interpreter to run Python code in the context of IRIS.

### Pros

- **Python First**: You can write your application logic in Python, which allows you to leverage Python's features and libraries.
- **IRIS Integration**: You can easily integrate your Python code with IRIS features and functionality.

### Cons
- **Limited Debugging**: Debugging Python code in `irispython` is not as straightforward as in a dedicated Python environment.
  - Don't mean it is not possible, but it is not as easy as in a dedicated Python environment.
  - See the [bonus section](#bonus-section) for more details.
- **Virtual Environment**: It's difficult to set up a virtual environment for your Python code in `irispython`.
  - Doesn't mean it is not possible, but it's difficult to do it due to virtual environment look by default to an interpreter called `python` or `python3`, which is not the case in IRIS.
  - See the [bonus section](#bonus-section) for more details.

### Conclusion

In conclusion, using `irispython` allows you to write your application logic in Python while still leveraging the power of IRIS. However, it has its limitations with debugging and virtual environment setup.

## Using WSGI

In this section, we will explore how to use WSGI (Web Server Gateway Interface) to run Python web applications in IRIS.

WSGI is a standard interface between web servers and Python web applications or frameworks. It allows you to run Python web applications in a web server environment.

IRIS supports WSGI, which means you can run Python web applications in IRIS using the built-in WSGI server.

### How to use it

To use WSGI in IRIS, you need to create a WSGI application and register it with the IRIS web server.

See the [official documentation](https://docs.intersystems.com/iris20251/csp/docbook/Doc.View.cls?KEY=AWSGI) for more details.

### Example of using WSGI

You can find a full template here [iris-flask-example](https://github.com/grongierisc/iris-flask-template).

### Pros

- **Python Web Frameworks**: You can use popular Python web frameworks like Flask or Django to build your web applications.
- **IRIS Integration**: You can easily integrate your Python web applications with IRIS features and functionality.

### Cons

- **Complexity**: Setting up a WSGI application can be more complex than just using `uvicorn` or `gunicorn` with a Python web framework.

### Conclusion

In conclusion, using WSGI in IRIS allows you to build powerful web applications using Python while still leveraging the features and functionality of IRIS.

## DB-API

In this section, we will explore how to use the Python DB-API to interact with IRIS databases.

The Python DB-API is a standard interface for connecting to databases in Python. It allows you to execute SQL queries and retrieve results from the database.

### How to use it

You can install it using pip:

```bash
pip install intersystems-irispython
```

Then, you can use the DB-API to connect to an IRIS database and execute SQL queries.

### Example of using DB-API

You use it like any other Python DB-API, here is an example:

```python
# src/python/article/dbapi_example.py
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
```

You can run this script using any Python interpreter:

```bash
python3 /irisdev/app/src/python/article/dbapi_example.py
```

You will see the output:

```
(1,)
```

### Pros

- **Standard Interface**: The DB-API provides a standard interface for connecting to databases, making it easy to switch between different databases.
- **SQL Queries**: You can execute SQL queries and retrieve results from the database using Python.
- **Remote access**: You can connect to remote IRIS databases using the DB-API.

### Cons

- **Limited Features**: The DB-API only provides SQL access to the database, so you won't be able to use advanced IRIS features like ObjectScript or Python code execution.

### Alternatives

It also exists a community edition of the DB-API, available here : [intersystems-irispython-community](https://github.com/intersystems-community/intersystems-irispython).

It has better support of SQLAlchemy, Django, langchain, and other Python libraries that use the DB-API.

See [bonus section](#bonus-section) for more details.

### Conclusion

In conclusion, using the Python DB-API with IRIS allows you to build powerful applications that can interact with your database seamlessly.

## Notebook

Now that we have seen how to use Python in IRIS, let's explore how to use Jupyter Notebooks with IRIS.

Jupyter Notebooks are a great way to write and execute Python code interactively, and they can be used with IRIS to leverage its features.

### How to use it

To use Jupyter Notebooks with IRIS, you need to install the `notebook` and `ipykernel` packages:

```bash
pip install notebook ipykernel
```

Then, you can create a new Jupyter Notebook and select the `Python 3` kernel.

### Example of using Notebook

You can create a new Jupyter Notebook and write the following code:

```python
# src/python/article/my_notebook.ipynb
# Import the necessary modules
import iris
# Do the magic
iris.system.Version.GetVersion()
```

You can run this notebook using Jupyter Notebook:

```bash
jupyter notebook src/python/article/my_notebook.ipynb
```

### Pros

- **Interactive Development**: Jupyter Notebooks allow you to write and execute Python code interactively, which is great for data analysis and exploration.
- **Rich Output**: You can display rich output, such as charts and tables, directly in the notebook.
- **Documentation**: You can add documentation and explanations alongside your code, making

### Cons

- **Tricky Setup**: Setting up Jupyter Notebooks with IRIS can be tricky, especially with the kernel configuration.

### Conclusion

In conclusion, using Jupyter Notebooks with IRIS allows you to write and execute Python code interactively while leveraging the features of IRIS. However, it can be tricky to set up, especially with the kernel configuration.

# Bonus Section

Starting from this section, we will explore some advanced topics related to Python in IRIS, such as debugging Python code, using virtual environments, and more.

Most of these topics are not officially supported by InterSystems, but they are useful to know if you want to use Python in IRIS.

## Using a native interpreter (no `irispython`)

In this section, we will explore how to use a native Python interpreter instead of the `irispython` interpreter.

This allows you to use virtual environments out of the box, and to use the Python interpreter you are used to.

### How to use it

To use a native Python interpreter, you to have IRIS install locally on your machine, and you need to have the `iris-embedded-python-wrapper` package installed.

You can install it using pip:

```bash
pip install iris-embedded-python-wrapper
```

Next, you need to setup some environment variables to point to your IRIS installation:

```bash
export IRISINSTALLDIR=<installation_directory>
export IRISUSERNAME=<username>
export IRISPASSWORD=<password>
export IRISNAMESPACE=<namespace>
```

Then, you can run your Python code using your native Python interpreter:

```bash
python3 -m src/python/article/irispython_example.py
```

For more details, see the [iris-embedded-python-wrapper documentation](https://github.com/grongierisc/iris-embedded-python-wrapper).

### Pros

- **Virtual Environments**: You can use virtual environments with your native Python interpreter, allowing you to manage dependencies more easily.
- **Familiar Workflow**: You can use the Python interpreter you are used to, making it easier to integrate with your existing workflows.
- **Debugging**: You can use your favorite Python debugging tools, such as `pdb` or `ipdb`, to debug your Python code in IRIS.
 
### Cons

- **Setup Complexity**: Setting up the environment variables and the `iris-embedded-python-wrapper` package can be complex, especially for beginners.
- **Not Officially Supported**: This approach is not officially supported by InterSystems, so you may encounter issues that are not documented or supported.

## DB-API Community Edition

In this section, we will explore the community edition of the DB-API, which is available on GitHub.

### How to use it

You can install it using pip:

```bash
pip install sqlalchemy-iris
```

Which will install the community edition of the DB-API.

Or with a specific version:

```bash
pip install https://github.com/intersystems-community/intersystems-irispython/releases/download/3.9.3/intersystems_iris-3.9.3-py3-none-any.whl
```

Then, you can use the DB-API to connect to an IRIS database and execute SQL queries or any other Python code that uses the DB-API, like SQLAlchemy, Django, langchain, pandas, etc.

### Example of using DB-API

You can use it like any other Python DB-API, here is an example:

```python
# src/python/article/dbapi_community_example.py
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
```

You can run this script using any Python interpreter:

```bash
python3 /irisdev/app/src/python/article/dbapi_community_example.py
```

Or with sqlalchemy:

```python
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
```

You can run this script using any Python interpreter:

```bash
python3 /irisdev/app/src/python/article/dbapi_sqlalchemy_example.py
```

You will see the output:

```
one: 1, two: 2
one: 1, two: 2
one: 1, two: 2
```

### Pros

- **Better Support**: It has better support of SQLAlchemy, Django, langchain, and other Python libraries that use the DB-API.
- **Community Driven**: It is maintained by the community, which means it is more likely to be updated and improved over time.
- **Compatibility**: It is compatible with the official InterSystems DB-API, so you can switch between the official and community editions easily.

### Cons

- **Speed**: The community edition may not be as optimized as the official version, potentially leading to slower performance in some scenarios.

## Debugging Python Code in IRIS

In this section, we will explore how to debug Python code in IRIS.

By default, debugging Python code in IRIS (in objectscript with the language tag or `%SYS.Python`) is not possible, but a community solution exists to allow you to debug Python code in IRIS.

### How to use it

