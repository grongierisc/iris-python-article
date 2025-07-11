Class Article.Introduction Extends %RegisteredObject
{

ClassMethod Run()
{
        Set sys = ##class(%SYS.Python).Import("sys")
        do sys.path.append("/irisdev/app/src/python/article")

        do ##class(%SYS.Python).Import("introduction")
}

}
