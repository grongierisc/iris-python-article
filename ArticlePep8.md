# Introduction to PEP 8

This will be a short article about PEP 8, the Python style guide.

## What is PEP 8?

In a nutshell, PEP 8 provides guidelines and best practices on how to write Python code.

- variable names should be in `snake_case`
- class names should be in `CamelCase`
- function names should be in `snake_case`
- constants should be in `UPPER_CASE`
- indentation should be 4 spaces (no tabs)
- private variables/functions should start with an underscore (`_`)
  - because in Python private variables and fonctions doesn't exist, it's just a convention
- your script should not run when imported
  - remember that when you import a script, the code is executed see first article
- ...

No need to say them all, but keep it in mind that will help you to understand other's code and help others to understand your code ^^.

Also, you may have heard about the words `pythonic`. Following PEP 8 is a way to write Python code that is considered "pythonic" (it's not only that but it's part of it).

## Why PEP 8 is important and relevant to IRIS Python developers?

In IRIS and especially in ObjectScript, we also have a style guide, which is mainly based on camelCase for variable names and PascalCase for class names.

Unfortunately, PEP 8 recommends using snake_case for variable names and functions.

And you already know it, in ObjectScript underscore (`_`) is for concatenation and it obviously doesn't suit us well.

How to overcome this issue ? Use double quotes to call an variable/function names in Python in ObjectScript code.

Example:

```objectscript
Class Article.PEP8Example Extends %RegisteredObject
{

ClassMethod Run()
{
    Set sys = ##class(%SYS.Python).Import("sys")
    do sys.path.append("/irisdev/app/src/python/article")
    set pep8Example = ##class(%SYS.Python).Import("pep8_example")
    do pep8Example."my_function"() // Notice the double quotes around the function name
}

}
```

This will call the `my_function` function in the `pep8_example.py` file, which is defined as follows:

```python
# src/python/article/pep8_example.py
def my_function():
    print("Hello, World!")
```

When you run the `Run` method of the `Article.PEP8Example` class, it will output:

```bash
iris session iris -U IRISAPP '##class(Article.PEP8Example).Run()'
Hello, World!
```

That's it! 