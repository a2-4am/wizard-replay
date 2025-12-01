a = new ActiveXObject("scripting.filesystemobject")
b = a.opentextfile(WScript.Arguments(0))
c = Number(WScript.Arguments(2))*256
d = b.read(c)+a.opentextfile(WScript.Arguments(1)).read(0x200)
b.skip(0x200)
e = b.read(a.getfile(WScript.Arguments(0)).size-c-0x200)
b.close()
a.createtextfile(WScript.Arguments(0), 1).write(d+e)
