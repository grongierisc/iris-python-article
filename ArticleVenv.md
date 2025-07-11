# Introduction to Virtual Environments in Python

This article will introduce you to the concept of virtual environments in Python, which are essential for managing dependencies and isolating project from the OS.

## What is a Virtual Environment?

A virtual environment is a folder that contains :
- A specific version of Python
- At start an empty site-packages directory

Virtual environments will help you to isolate your project from the OS Python installation and from other projects.

## How to use it?

To use virtual environments, you can follow these steps:

1. **Create a virtual environment**: You can create a virtual environment using the `venv` module that comes with Python. Open your terminal and run:

    ```bash
    python -m venv .venv
    ```
    Replace `.venv` with your desired environment name.

2. **Activate the virtual environment**: After creating the virtual environment, you need to activate it. The command varies depending on your operating system:

   - On Windows:
    ```ps1
    .venv\Scripts\Activate.ps1
    ```

    If you encounter an error, you may need to run the following command in your terminal:

    ```bash
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; .venv\Scripts\Activate.ps1
    ```

   - On macOS and Linux:
   ```bash
   source .venv/bin/activate
   ```

Once activated, your terminal prompt will change to indicate that you are now working within the virtual environment.

Example:
```bash
(.venv) user@machine:~/project$
```

Notice the `(.venv)` prefix in the terminal prompt, which indicates that the virtual environment is active.

Now then you can install packages using `pip`, and they will be installed in the virtual environment rather than the global Python installation.

## Can I use Virtual Environments in IRIS?

Humm, good question!

The answer is simple : Yes and No.

- No, because IRIS do not officially support virtual environments.
- Yes, because going through all those articles, now we understand how Python works, how Iris works and what is a virtual environment, maybe we can simulate a virtual environment within IRIS by using the right configurations and setups.

### How to simulate a virtual environment in IRIS?

A virtual environment is two things:
- A specific version of Python
- An site-packages directory

We have in IRIS what we call `Flexible Python Runtime`, which allows us to 
- use a specific version of Python.
- update the `sys.path` to include a specific directory.

So, we can simulate a virtual environment in IRIS by using the `Flexible Python Runtime` and configuring the `sys.path` to include a specific directory and a specific version of Python. 🥳

Setup a `Flexible Python Runtime` in IRIS is easy, you can follow the steps in the [IRIS documentation](https://docs.intersystems.com/iris20251/csp/docbook/Doc.View.cls?KEY=GEPYTHON_flexible#GEPYTHON_flexible_overview).

In a nutshell, you need to:

1. Configure the `PythonRuntimeLibrary` to point to the lib python file of the specific Python version you want to use.
    
    Example:
    - Windows : C:\Program Files\Python311\python3.dll (Python 3.11 on Windows)
    - Linux : /usr/lib/x86_64-linux-gnu/libpython3.11.so.1.0 (Python 3.11 on Ubuntu 22.04 on the x86 architecture)

2. Configure the `PythonPath` to point to the site-packages directory of the specific Python version you want to use.

    Example:
    - Use your virtual environment site-packages directory, which is usually located in the `.venv/lib/python3.x/site-packages` directory.

⚠️ This will setup your whole IRIS instance to use a specific version of Python and a specific site-packages directory.

🩼 Limitation :
- You will not end up with exactly the same `sys.path` as a virtual environment, because IRIS will add some directories to the `sys.path` automatically, like `<installation_directory>/lib/python` an others we have seen in the module article.

🤫 If you want to make it automatic, you can use this awsome package: [iris-embedded-python-wrapper](https://grongierisc.github.io/iris-embedded-python-wrapper/)

To use it, you need to:

Be in your venv environment, then install the package:

```bash
(.venv) user@machine:~/project$
pip install iris-embedded-python-wrapper
```

Then, simply bind this venv to IRIS with the following command:

```bash
(.venv) user@machine:~/project$
bind_iris
```

You will see the following message:

```
INFO:iris_utils._find_libpyton:Created backup at /opt/intersystems/iris/iris.cpf.0f4a1bebbcd4b436a7e2c83cfa44f515
INFO:iris_utils._find_libpyton:Created merge file at /opt/intersystems/iris/iris.cpf.python_merge

IRIS Merge of /opt/intersystems/iris/iris.cpf.python_merge into /opt/intersystems/iris/iris.cpf
IRIS Merge failed
INFO:iris_utils._find_libpyton:PythonRuntimeLibrary path set to /usr/local/Cellar/python@3.11/3.11.13/Frameworks/Python.framework/Versions/3.11/Python
INFO:iris_utils._find_libpyton:PythonPath set to /xxxx/.venv/lib/python3.11/site-packages
INFO:iris_utils._find_libpyton:PythonRuntimeLibraryVersion set to 3.11
```

To unbind the venv from IRIS, you can use the following command:

```bash
(.venv) user@machine:~/project$
unbind_iris
```

## Conclusion

We have seen what are the benefits of using virtual environments in Python, how to create and use them, and how to simulate a virtual environment in IRIS using the `Flexible Python Runtime`.