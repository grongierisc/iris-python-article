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
