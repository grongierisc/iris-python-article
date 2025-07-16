# Introduction to Python Dunder Methods

![img](https://raw.githubusercontent.com/grongierisc/iris-python-article/master/misc/img/image%20dunder.png)

This will be a short article about Python dunder methods, also known as magic methods.

## What are Dunder Methods?

Dunder methods are special methods in Python that start and end with double underscores (`__`). They allow you to define the behavior of your objects for built-in operations, such as addition, subtraction, string representation, and more.

Some common dunder methods include:

- `__init__(self, ...)`: Called when an object is created.
    - Like our `%OnNew` method in ObjectScript.
- `__str__(self)`: Called by the `str()` built-in function and `print` to represent the object as a string.
- `__repr__(self)`: Called by the `repr()` built-in function to represent the object for debugging.
- `__add__(self, other)`: Called when the `+` operator is used.
- `__len__(self)`: Called by the `len()` built-in function to return the length of the object.
- `__getitem__(self, key)`: Called to retrieve an item from a collection using the indexing syntax.
- `__setitem__(self, key, value)`: Called to set an item in a collection using the indexing syntax.
- ... and many more.

## Why are Dunder Methods Important and Relevant in an IRIS Context?

In ObjectScript, **we don't have the sugar syntax like in Python**, but we can achieve similar behavior using dunder methods.

Example, we have imported a Python module, it has a function that returns a python list, and we want to use it in ObjectScript. We must use the `__getitem__` dunder method to access the items in the list.

```python
# src/python/article/dunder_example.py
def get_list():
    return [1, 2, 3, 4, 5]
```

```objectscript
Class Article.DunderExample Extends %RegisteredObject
{

ClassMethod Run()
{
    Set sys = ##class(%SYS.Python).Import("sys")
    do sys.path.append("/irisdev/app/src/python/article")
    set dunderExample = ##class(%SYS.Python).Import("dunder_example")
    set myList = dunderExample."get_list"()
    for i=0:1:myList."__len__"()-1 {
        write myList."__getitem__"(i), !
    }
}

}
```

Let's run it:

```bash
iris session iris -U IRISAPP '##class(Article.DunderExample).Run()'
```

This will output:

```
1
2
3
4
5
```

This demonstrates how to use dunder methods to interact with Python objects in an IRIS context, allowing you to leverage Python's capabilities while working within the ObjectScript environment.

## Bonus

A good use of dunder is to put at the end of your python script a `if __name__ == "__main__":` block to prevent the code from being executed when the script is imported as a module.

Remember, the first article explained that when you import a script, the code is executed. This block allows you to define code that should only run when the script is executed directly, not when it's imported.

Example:

```python
# src/python/article/dunder_example.py
def get_list():
    return [1, 2, 3, 4, 5]

if __name__ == "__main__":
    print(get_list())
```

## Conclusion

What you can do in python even with it's sugar syntax, you can do it in ObjectScript with dunder methods.