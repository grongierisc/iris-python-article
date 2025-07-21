# Introduction to Python Modules

![img](https://raw.githubusercontent.com/grongierisc/iris-python-article/master/misc/img/image%20module.png)

Modules what a topic! We don't have this notion in ObjectScript, but it's a fundamental concept in Python. Let's discover it together.

## What is a Module?

I see modules as an intermediate layer between classes and packages. Let see it by example.

A bad example :

```python
# MyClass.py
class MyClass:
    def my_method(self):
        print("Hello from MyClass!")
```

When you try to use this class in another script, you would do:

```python
# class_usage.py
from MyClass import MyClass # weird, right?

my_instance = MyClass()
my_instance.my_method()
```

Why this is a bad example?

First because file names should be in `snake_case` according to PEP 8, so it should be `my_class.py`.
Second, because you are importing a class from a file that has the same name as the class. This is not a good practice in Python.

I know this can be confusing, especially if you come from ObjectScript where classes are defined in files with the same name as the class.

## Advanced notions

### A Module is a Python File

So we just saw that modules can be a python file but without the `.py` extension.

But wait, does it mean that a python script is a module too? Yes, it is!

That's why you should be careful when importing a script, because it will execute the code in that script. See the [Introduction to Python](Article0.md) article for more details.

### A Module is a Folder with an `__init__.py` File

Wow, can a folder be a module? Yes, it can!

A folder can be a module if it contains an `__init__.py` file. This file can be empty or contain initialization code for the module.

Let's see an example:

```bash
src/python/article/
└── my_folder_module/
    ├── __init__.py
    ├── my_sub_module.py
    └── another_sub_module.py
```

```python
# my_folder_module/my_sub_module.py
class MySubModule:
    def my_method(self):
        print("Hello from MySubModule!")
```

```python
# my_folder_module/another_sub_module.py
class AnotherSubModule:
    def another_method(self):
        print("Hello from AnotherSubModule!")
```

```
# my_folder_module/__init__.py
# This file can be empty or contain initialization code for the module.
```

In this case, `my_folder_module` is a module, and you can import it like this:

```python
from my_folder_module import my_sub_module, another_sub_module
```

Or if you define an `__init__.py` file with the following content:

```python
# my_folder_module/__init__.py
from .my_sub_module import MySubModule
from .another_sub_module import AnotherSubModule
```

You can import it like this:

```python
from my_folder_module import MySubModule, AnotherSubModule
```

You see the subtility? You can import the classes directly from the module without specifying the sub-module, because the `__init__.py` file is executed when you import the module, and it can define what is available in the module's namespace.

## sys.path

When you import a module, Python looks for it in the directories listed in `sys.path`. This is a list of strings that specifies the search path for modules.

You can view the current `sys.path` by running the following code:

```python
import sys
print(sys.path)
```

By default, it includes the current directory and other various directories depending on your Python installation.

You can also add directories to `sys.path` at runtime, which is useful when you want to import modules from a specific location. For example:

```python
import sys
sys.path.append('/path/to/your/module')
from your_module import YourClass
```

This is why in the previous article, we added the path to the module before importing it:

```objectscript
Set sys = ##class(%SYS.Python).Import("sys")
do sys.path.append("/irisdev/app/src/python/article")
set my_module = ##class(%SYS.Python).Import("my_module")
```

### sys.path and the other directories

What are the other directories in `sys.path`? They are usually:

- The directory containing the input script (or the current directory if no script is specified).
- The standard library directories, which contain the built-in modules that come with Python.
- **site-packages** directories where third-party packages are installed.

#### site-packages

How site-packages works? When you install a package using pip, it is installed in the `site-packages` directory, which is automatically included in `sys.path`. This allows you to import the package without having to specify its location.

🤨🔍 But how and where the `site-packages` directory are set and by who?

The `site-packages` directory is created during the installation of Python and is typically located in the `lib` directory of your Python installation. The exact location depends on your operating system and how Python was installed.

For example, on a typical Linux installation, the `site-packages` directory might be located at:

```
/usr/local/lib/python3.x/site-packages
```

On Windows, it might be located at:

```
C:\Python3x\Lib\site-packages
```

When you install a package using `pip`, it is installed in the `site-packages` directory, which is automatically included in `sys.path`. This allows you to import the package without having to specify its location.

```python
import site
print(site.getsitepackages())
```

🤨🔍 When and where python interpreter reads the `site.py` file?

The `site.py` file (which is located in the standard library directory) is executed automatically when the Python interpreter starts. It is responsible for setting up the `site-packages` directory and adding it to `sys.path`. This file is located in the standard library directory of your Python installation.

### sys.path in IRIS

In IRIS, we also have a `site.py` file, which is located in `<installation_directory>/lib/python/iris_site.py`. This file is executed when you start or import aa script/module in IRIS, and it sets up the `sys.path` for you.

Roughly, the `iris_site.py` file does the following:
- it keeps the default `site-packages` directory
- it adds the `<installation_directory>/lib/python/` directory to `sys.path`
  - this is where the IRIS Python modules are located, plz don't put your modules here
- it adds the `<installation_directory>/mgr/python/` directory to `sys.path`
  - this is where you can put your custom Python modules
- it adds the config string PythonPath to `sys.path`
  - PythonPath can be configured in the IRIS Management Portal or in a merge/cfg file
  - https://docs.intersystems.com/iris20251/csp/docbook/Doc.View.cls?KEY=GEPYTHON_flexible#GEPYTHON_flexible_overview

## Conclusion

A module can be :
- a Python file (with or without the `.py` extension)
- a folder with an `__init__.py` file
- a Python script (which is also a module)
- if you can't import a module, check if it is in the `sys.path` list
