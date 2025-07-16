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
