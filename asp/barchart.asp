<%
' Tom Kwasniewski can be reached at: tkwasnie@dreamscape.com

Sub ShowStackedBarChart(ByRef aValues, ByRef aLabels, ByRef strTitle, _
	ByRef strXAxisLabel, ByRef strYAxisLabel, ByRef aColors, ByRef aToolTip, ByRef aBars)

	' Some user changable graph defining constants
	' All units are in screen pixels
	Const GRAPH_WIDTH  = 400  ' The width of the body of the graph
	Const GRAPH_HEIGHT = 300  ' The heigth of the body of the graph
	Const GRAPH_BORDER = 4    ' The size of the black border
	Const GRAPH_SPACER = 2    ' The size of the space between the bars

	Const TABLE_BORDER = 0
	'Const TABLE_BORDER = 10

	' Declare our variables
	Dim i, ii, iTmp, aTmp()
	Dim iMaxValue
	Dim iBarWidth
	Dim iBarHeight
	Dim strColumnColor

	' Get the maximum value in the data set
	iMaxValue = 0
	For I = 0 To UBound(aValues)
		If iMaxValue < aValues(I) Then iMaxValue = aValues(I)
	Next 'I

	If iMaxValue  = 0 Then Exit Sub
	'Response.Write iMaxValue & "&nbsp;&nbsp;" ' Debugging line

	ReDim Preserve aTmp(UBound(aColors))

	' Calculate the width of the bars
	' Take the overall width and divide by number of items and round down.
	' I then reduce it by the size of the spacer so the end result
	' should be GRAPH_WIDTH or less!
	iBarWidth = (GRAPH_WIDTH \ (UBound(aValues) + 1)) - GRAPH_SPACER
	'Response.Write iBarWidth ' Debugging line

	' Start drawing the graph
	%>
	<TABLE BORDER="<%= TABLE_BORDER %>" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD COLSPAN="3" ALIGN="center"><H2><%= strTitle %></H2></TD>
		</TR>
		<TR>
			<TD VALIGN="center"><B><%= strYAxisLabel %></B></TD>
			<TD VALIGN="top">
				<TABLE BORDER="<%= TABLE_BORDER %>" CELLSPACING="0" CELLPADDING="0">
					<TR>
						<TD ROWSPAN="2">
							<IMG SRC="./images/spacer.gif" BORDER="0"
								WIDTH="1" HEIGHT="<%= GRAPH_HEIGHT %>">
						</TD>
						<TD VALIGN="top" ALIGN="right"><%= iMaxValue %>&nbsp;</TD>
					</TR>
					<TR>
						<TD VALIGN="bottom" ALIGN="right">0&nbsp;</TD>
					</TR>
				</TABLE>
			</TD>
			<TD>
				<TABLE BORDER="<%= TABLE_BORDER %>" CELLSPACING="0" CELLPADDING="0">
					<TR>
						<TD VALIGN="bottom"><IMG SRC="./images/spacer_black.gif"
							BORDER="0"
							WIDTH="<%= GRAPH_BORDER %>"
							HEIGHT="<%= GRAPH_HEIGHT %>"></TD>
						<%
						' We're now in the body of the chart.
						' Loop through the data showing the bars!
						For I = 0 To UBound(aValues)
							iBarHeight = Int((aValues(I) / iMaxValue) * GRAPH_HEIGHT)

							' This is a hack since browsers ignore a 0 as an image dimension!
							If iBarHeight = 0 Then iBarHeight = 1
							%>
							<TD VALIGN="bottom"><IMG SRC="./images/spacer.gif"
								BORDER="0"
								WIDTH="<%= GRAPH_SPACER %>"
								HEIGHT="1"></TD>
							<TD VALIGN="bottom"><%
								For ii = UBound(aColors) - 1 To 0 Step - 1
									aTmp(ii) = Int((aBars(ii+1,I) / iMaxValue) * GRAPH_HEIGHT)
									%><IMG SRC="./images/spacer_<%= aColors(ii) %>.gif"
									BORDER="0" WIDTH="<%= iBarWidth %>"
									HEIGHT="<%= aTmp(ii) %>"
									ALT="<%= aBars(ii + 1, I) & vbTab & aToolTip(ii) %>"><br /><%
								Next 'ii
							%></TD><%
						Next 'I
						%>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
					<!-- I was using GRAPH_BORDER + GRAPH_WIDTH but it was
					moving the last x axis label -->
					<TR>
						<TD COLSPAN="<%= (UBound(aValues) + 1) %>"><IMG SRC="./images/spacer_black.gif"
							WIDTH="<%= GRAPH_BORDER + ((UBound(aValues) + 1) * (iBarWidth + GRAPH_SPACER)) %>"
							HEIGHT="<%= GRAPH_BORDER %>" BORDER="0"></TD>
					</TR>
						<%
						' The label array is optional and is really only useful
						' for small data sets with very short labels!
						%>
						<% If IsArray(aLabels) Then %>
							<TR>
							<% For I = 0 To UBound(aValues)
								iTmp = (GRAPH_BORDER + ((UBound(aValues) + 1) * _
									(iBarWidth + GRAPH_SPACER))) / (UBound(aValues) +1)
								iTmp = Int(Round(iTmp))
								%>
								<TD WIDTH="<%= iTmp %>" ALIGN="center"><FONT SIZE="2"><%= aLabels(I) %></FONT></TD>
							<% Next 'I %>;
							</TR>
						<% End If %>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<%
End Sub

' Here is example code from a real application,
' we will use static data for our sample.
' ========================================================================
' Webmaster's Note: I've removed this to keep the script short and simple.
' It's available in the zip file version along with all the image files
' if you're interested in seeing the data access code.
' http://www.asp101.com/samples/download/bar_chart_stacked.zip
' ========================================================================

' Make up some fake data:

' For this example our chart will be five sensors (columns)
' with four states (stacks).
Dim i, ii, iNumSensors, iNumStates
Dim aValues(), aLabels(), aTooltip(), aColors(), aBars()

iNumSensors = 5
iNumStates = 4
ReDim Preserve aValues(iNumSensors)
ReDim Preserve aLabels(iNumSensors)
ReDim Preserve aTooltip(iNumStates)
ReDim Preserve aColors(iNumStates)

' Create the bar array one row per sensor
ReDim Preserve abars(iNumStates,iNumSensors)
For i = 0 to Ubound(abars,1)
   For ii = 0 to Ubound(abars,2)
      abars(i,ii) = 0
   Next 'ii
Next 'i

' set the total height of each column
aValues(0) = 5
aValues(1) = 171
aValues(2) = 62
aValues(3) = 66
aValues(4) = 87
aValues(5) = 391

' set the data for the stacked bars
aBars(0,0) = 1
aBars(0,1) = 1
aBars(0,2) = 1
aBars(0,3) = 1
aBars(0,4) = 1
aBars(0,5) = 5

aBars(1,0) = 32
aBars(1,1) = 112
aBars(1,2) = 6
aBars(1,3) = 11
aBars(1,4) = 10
aBars(1,5) = 171

aBars(2,0) = 6
aBars(2,1) = 18
aBars(2,2) = 4
aBars(2,3) = 14
aBars(2,4) = 20
aBars(2,5) = 62

aBars(3,0) = 13
aBars(3,1) = 0
aBars(3,2) = 10
aBars(3,3) = 13
aBars(3,4) = 30
aBars(3,5) = 66

aBars(4,0) = 10
aBars(4,1) = 7
aBars(4,2) = 30
aBars(4,3) = 0
aBars(4,4) = 40
aBars(4,5) = 87

' set the labels for the chart
aLabels(0) = "S1"
aLabels(1) = "S2"
aLabels(2) = "S3"
aLabels(3) = "S4"
aLabels(4) = "S5"
aLabels(5) = "Total"

' set the colors for the chart
aColors(0) = "red"
aColors(1) = "blue"
aColors(2) = "yellow"
aColors(3) = "lime"

' set the Tool Tips for the chart
aTooltip(0) = "Critical"
aTooltip(1) = "Serious"
aTooltip(2) = "Routine"
aTooltip(3) = "Cleared"

' This is the line that calls the function to display the chart
ShowStackedBarChart aValues, aLabels, "Sensor Summary", "Sensor ID", "N", aColors, aTooltip, aBars
%>
