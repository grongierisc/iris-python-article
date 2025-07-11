Class Article.Introduction2 Extends %RegisteredObject
{

ClassMethod Run(
	foo = "dsfdd",
	myot...) [ Language = python ]
{
    import os

    def my_function():
        print("Hello, gfdWorld!")

    my_function()

    print("Running Introduction2 with foo:", foo, myot)

    if not hasattr(os, 'foo'):
        os.foo = "bar"
    else:
        print("os.foo already exists:", os.foo)
}

}
