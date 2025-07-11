# Introduction to Python Modules

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

Wow, and can a folder be a module? Yes, it can!

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

### sys.path

When you import a module, Python looks for it in the directories listed in `sys.path`. This is a list of strings that specifies the search path for modules.

You can view the current `sys.path` by running the following code:

```python
import sys
print(sys.path)
```

By 
