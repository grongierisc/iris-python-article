# Introduction to Python Programming in an IRIS context

This will be an introduction to Python programming in the context of IRIS.

Before anything I will cover an important topic: **How python works**, this will help you understand some issues and limitations you may encounter when working with Python in IRIS.

# How Python works

## Interpreted Language

Python is an interpreted language, which means that the code is **executed line by line** at runtime even when you import a script.

What does this mean ? Let's take a look at the following code:

```python
# introduction.py

def my_function():
    print("Hello, World!")

my_function()
```

When you run this script, the Python interpreter reads the code line by line. It first defines the function `my_function`, and then it calls that function, which prints "Hello, World!" to the console.

Example of running the script directly:

```bash
python3 /irisdev/app/src/python/article/introduction.py 
```

This will output:

```
Hello, World!
```

In an IRIS context, what will happen if we import this script ?

```objectscript
Class Article.Introduction Extends %RegisteredObject
{
    ClassMethod Run()
    {
        Set sys = ##class(%SYS.Python).Import("sys")
        do sys.path.append("/irisdev/app/src/python/article")

        do ##class(%SYS.Python).Import("introduction")
    }
}
```

Let's run it:

```bash
iris session iris -U IRISAPP '##class(Article.Introduction).Run()'
```

You will see the output:

```
Hello, World!
```

This is because the Python interpreter imports the code by interpreting it, first it defines the function and then **calls it**, just like it would if you ran the script directly **but you are not running you are importing it**.

⚠️ **Important Note**: If you import the script without calling the function, nothing will happen. The function is defined, but it won't execute until you explicitly call it.

Did you get it? The Python interpreter executes the code in the file, and if you don't call the function, it won't run. 

Example of importing without calling:

```python
# introduction1.py
def my_function():
    print("Hello, World!")
```

Let's run it in an python interpreter:

```bash
python3 /irisdev/app/src/python/article/introduction1.py 
```

Output:

```
# No output, because the function is defined but not called
```

In an IRIS context, if you import this script:

```objectscript
Class Article.Introduction1 Extends %RegisteredObject
{
    ClassMethod Run()
    {
        Set sys = ##class(%SYS.Python).Import("sys")
        do sys.path.append("/irisdev/app/src/python/article")
        do ##class(%SYS.Python).Import("introduction1")
    }
}
```

Let's run it:

```bash
iris session iris -U IRISAPP '##class(Article.Introduction1).Run()'
```

You will see no output, because the function is defined but not called.

🤯 Why this subtility is important ?

- When you import a Python script, it executes the code in that script.
  - You may don't want this to happen
- You can be confused by guessing importing a script it's like running it, but it's not.

## Import caching

When you import a Python script, **the Python interpreter caches the imported script**. 
This means that if you import the **same script again, it will not re-execute the code** in that script, but will use the cached version.

Demonstration by example:

Let's reuse the `introduction.py` script:

```python
# introduction.py
def my_function():
    print("Hello, World!")

my_function()
```

Now, same thing let's reuse the `Article.Introduction` class:

```objectscript
Class Article.Introduction Extends %RegisteredObject
{
    ClassMethod Run()
    {
        Set sys = ##class(%SYS.Python).Import("sys")
        do sys.path.append("/irisdev/app/src/python/article")
        do ##class(%SYS.Python).Import("introduction")
    }
}
```

But now, we will be running it twice in a row in the **same IRIS session**:

```bash
iris session iris -U IRISAPP 

IRISAPP>do ##class(Article.Introduction).Run()
Hello, World!

IRISAPP>do ##class(Article.Introduction).Run()

IRISAPP>
```

🤯 What the heck ?

Yes, `Hello, World!` is printed only once !

⚠️ Your imported script is cached. This means if you change the script after importing it, the changes will not be reflected **until you change the IRIS session**.

This is even true if you use the `language tag` python in IRIS:

```objectscript
Class Article.Introduction2 Extends %RegisteredObject
{

ClassMethod Run() [ Language = python ]
{
    import os

    if not hasattr(os, 'foo'):
        os.foo = "bar"
    else:
        print("os.foo already exists:", os.foo)
}

}
```

Let's run it:

```bash
iris session iris -U IRISAPP

IRISAPP>do ##class(Article.Introduction2).Run()

IRISAPP>do ##class(Article.Introduction2).Run()
os.foo already exists: bar
```

OMG, the `os` module is cached, and the `foo` attribute is not redefined to non existing.

# Conclusion

I hope this introduction helped you understand why when you work with Python in IRIS, you may encounter some unexpected behaviors, especially when it comes to importing scripts and caching.

Takeway, when working with Python in IRIS:
- Change everytime the IRIS session to see changes in your Python scripts.
  - This is not a bug, it's how Python works.
- Be aware that importing a script executes its code.

# Bonus

Wait ! It doesn't make sense, if you say that when you import a script, it's cached. Why when I work with the `language tag = python`, when I change the script, it works without changing the IRIS session?

Good question, this is because the `language tag` is built in a way that everytime you run it, it will read the script again and execute it line by line as it was new lines in an native Python interpreter, `language tag` doesn't import the script, it just executes it as if you were running it directly in a Python interpreter without restarting it.

Example:

```objectscript
Class Article.Introduction2 Extends %RegisteredObject
{
ClassMethod Run() [ Language = python ]
{
    import os

    if not hasattr(os, 'foo'):
        os.foo = "bar"
    else:
        print("os.foo already exists:", os.foo)
}
}
```
Let's run it:

```bash
iris session iris -U IRISAPP
IRISAPP>do ##class(Article.Introduction2).Run()

IRISAPP>do ##class(Article.Introduction2).Run()
os.foo already exists: bar  
```

In a python interpreter it will look like this:

```python
import os

if not hasattr(os, 'foo'):
    os.foo = "bar"
else:
    print("os.foo already exists:", os.foo)

import os
if not hasattr(os, 'foo'):
    os.foo = "bar"
else:
    print("os.foo already exists:", os.foo)
```

Output:

```
os.foo already exists: bar # only printed once
```

Make sense now?

# Next :

- Pep8
- Modules
- Dunder methods
- Working with Python in IRIS
- ...