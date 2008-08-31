<%
' Declare our variables... always good practice!
Dim cnnGetRows   ' ADO connection
Dim rstGetRows   ' ADO recordset
Dim strDBPath    ' Path to our Access DB (*.mdb) file
Dim arrDBData    ' Array that we dump all the data into

' Temp vars to speed up looping over the array
Dim I, J
Dim iRecFirst, iRecLast
Dim iFieldFirst, iFieldLast

' MapPath to our mdb file's physical path.
strDBPath = Server.MapPath("db_scratch.mdb")

' Create a Connection using OLE DB
Set cnnGetRows = Server.CreateObject("ADODB.Connection")

' This line is for the Access sample database:
'cnnGetRows.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDBPath & ";"

' We're actually using SQL Server so we use this line instead.
' Comment this line out and uncomment the Access one above to
' play with the script on your own server.
cnnGetRows.Open "Provider=SQLOLEDB;Data Source=10.2.2.133;" _
	& "Initial Catalog=samples;User Id=samples;Password=password;" _
	& "Connect Timeout=15;Network Library=dbmssocn;"

' Execute a simple query using the connection object.
' Store the resulting recordset in our variable.
Set rstGetRows = cnnGetRows.Execute("SELECT * FROM scratch")

' Now this is where it gets interesting... Normally we'd do
' a loop of some sort until we ran into the last record in
' in the recordset.  This time we're going to get all the data
' in one fell swoop and dump it into an array so we can
' disconnect from the DB as quickly as possible.
arrDBData = rstGetRows.GetRows()

' Some notes about .GetRows:
' The Method actually takes up to 3 optional arguments:
' 1. Rows   - A long integer indicating the number of rows to
'             retreive from the data source and put into the
'             array. Defaults to adGetRowsRest which
'             retreives all the remaining rows.
' 2. Start  - An ADO bookmark indicating which row we should
'             begin from.  It can also be one of the following
'             three ADO constants: adBookmarkCurrent,
'             adBookmarkFirst, adBookmarkLast.  Defaults to
'             the current row, so if you've been moving around
'             the RS it'll pick up wherever you left off.
' 3. Fields - A single field name or number or an array of
'             names or numbers indicating which fields to
'             retreive and place into the array.  Defaults to
'             all the columns.
'
' So a example using all the attributes would look like this:
'
'arrDBData = rstGetRows.GetRows(2, adBookmarkCurrent, Array("id", "text_field"))
'
' Which would get 2 rows starting from the current record and
' only returning data from the the id and text_field fields.
'
' FYI: the above line uses an ADO constant from adovbs.inc
' which I haven't included in this script:
' Const adBookmarkCurrent = 0


' Close our recordset and connection and dispose of the objects.
' Notice that I'm able to do this before we even worry about
' displaying any of the data!
rstGetRows.Close
Set rstGetRows = Nothing
cnnGetRows.Close
Set cnnGetRows = Nothing

' ADO sets up the array so that the elements of the first
' dimension correspond to the DB fields and the elements of
' the second dimension correspond to the records.  It might
' seem a little backward, but when you think about it, it
' makes sense because it's easy to modify the last dimension
' (to hold fewer or more records as needed), but modifying the
' first dimension is difficult so we use it to handle the
' fields which most likely wouldn't need to be modified.

' Here I get the upper and lower bounds of the field list
' and the records.  This gives me some information about the
' data before I start and also allows me to not have to query
' the array for its bounds on each loop.
iRecFirst   = LBound(arrDBData, 2)
iRecLast    = UBound(arrDBData, 2)
iFieldFirst = LBound(arrDBData, 1)
iFieldLast  = UBound(arrDBData, 1)

' Display a table of the data in the array.
' We loop through the array displaying the values.
%>
<table border="1">
<%
' Loop through the records (second dimension of the array)
For I = iRecFirst To iRecLast
	' A table row for each record
	Response.Write "<tr>" & vbCrLf

	' Loop through the fields (first dimension of the array)
	For J = iFieldFirst To iFieldLast
		' A table cell for each field
		Response.Write vbTab & "<td>" & arrDBData(J, I) & "</td>" & vbCrLf
	Next ' J

	Response.Write "</tr>" & vbCrLf
Next ' I
%>
</table>
<%
' That's all folks!
%>
