Class Article.DebuggingExample Extends %RegisteredObject
{

ClassMethod Run() As %Status
{
    set myScript = ##class(IOP.Wrapper).Import("my_script", "/irisdev/app/src/python/article/", 55550) // Adjust the path to your module
    Do myScript.run()
    Quit $$$OK
}

}
