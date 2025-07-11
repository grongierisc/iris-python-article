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
