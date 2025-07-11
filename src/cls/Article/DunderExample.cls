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
