def testTurtle {
  val t = mock[Turtle]
 
  t expects 'penDown
  t expects 'turn withArgs (90.0)
  t expects 'forward withArgs (10.0)
  t expects 'getPosition returning (0.0, 10.0)
 
  drawLine(t)
}

'a' '\u0041' '\n' '\t'
'\u0020' '\u0009' '\u000D' '\u000A'
'A'..'Z', '_'
'0'..'9'
