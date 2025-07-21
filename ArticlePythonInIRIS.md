# Introduction to Python in IRIS

![img](https://raw.githubusercontent.com/grongierisc/iris-python-article/master/misc/img/image%20iris%20python.png)

Now that we have a good understanding of Python and its features, let's explore how we can leverage Python within IRIS.

We will start with the beginning, the language tag, we will see the pros and cons of using it, next we will see how to import Python modules and how to use them in ObjectScript, then we will finish with the Python first approach in IRIS.

- [Introduction to Python in IRIS](#introduction-to-python-in-iris)
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

First, we will do it only with the built-in and third-party modules that come from PyPI, like `requests`, `numpy`, etc.

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
  - See [the articles about dunder methods](https://community.intersystems.com/post/introduction-python-dunder-methods) for example.
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

⚠️ Don't forget to change your iris session to make sure you are on the last version of the code, see [the first article](https://community.intersystems.com/post/introduction-python-programming-iris-context) for more details.

You will see the output:

```
message: Hello World
```

This demonstrates how to import a custom Python module into ObjectScript and execute its code.

## Pros

- **Modularity**: You can organize your Python code into modules, making it easier to manage and maintain.
- **Python Syntax**: You can write Python code with its syntax and features
- **Debugging**: Not of the box today, but in the [next article](https://community.intersystems.com/post/debugging-python-code-iris), we will see how to debug Python code in IRIS.

## Cons

- **Path Management**: You need to manage the path to your Python module, see [the article](https://community.intersystems.com/post/introduction-python-modules) about `sys.path` for more details.
- **Python Knowledge**: You still need to have a good understanding of Python to write and maintain your modules.
- **ObjectScript Knowledge**: You need to know how to use ObjectScript to import and call your Python modules.

## Conclusion

In conclusion, importing Python modules into ObjectScript can greatly enhance your application's capabilities by leveraging the vast ecosystem of Python libraries. However, it's essential to understand the trade-offs involved, such as the need for a solid grasp of Python.
