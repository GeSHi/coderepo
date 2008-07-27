"======================================================================
|
|   Smalltalk in Smalltalk compiler - code to enable the compiler
|
|   $Revision: 1.8.5$
|   $Date: 2000/12/27 10:45:49$
|   $Author: pb$
|
 ======================================================================"


"======================================================================
|
| Copyright 1988-92, 1994-95, 1999, 2000 Free Software Foundation, Inc.
| Written by Paolo Bonzini.
|
| This file is part of GNU Smalltalk.
|
| GNU Smalltalk is free software; you can redistribute it and/or modify it
| under the terms of the GNU General Public License as published by the Free
| Software Foundation; either version 2, or (at your option) any later version.
|
| GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
| ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
| FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
| details.
|
| You should have received a copy of the GNU General Public License along with
| GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
| Foundation, 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
|
 ======================================================================"



"Final definitions to start the compiler..."

!FileStream methodsFor: 'file-in'!

fileIn
    STSymbolTable nowInsideFileIn.
    (STFileInParser onStream: self) parseSmalltalk.
    STSymbolTable nowOutsideFileIn.
! !

!Behavior methodsFor: 'compiling'!

evalString: aString to: anObject
    ^(STFileInParser onStream: (ReadStream on: aString))
	evalFor: anObject;
	parseSmalltalk;
	lastResult
!

evalString: aString to: anObject ifError: aBlock
    | parser |
    ^(parser := STFileInParser onStream: (ReadStream on: aString))
	evalFor: anObject;
	parseErrorBlock: [ :f :l :m |
	    parser close.
	    ^aBlock value: f value: l value: m.
	];
	parseSmalltalk;
	lastResult
!

compileString: aString

    | codeWithHeader |
    codeWithHeader := '!%1 methodsFor: nil!%2! !'
	bindWith: self printString
	with: aString.

    ^(STFileInParser onStream: (ReadStream on: codeWithHeader)) parseSmalltalk
!

compileString: aString ifError: aBlock
    | parser codeWithHeader |
    codeWithHeader := '!%1 methodsFor: nil!
%2! !'
	bindWith: self name
	with: aString.

    ^(parser := STFileInParser onStream: (ReadStream on: codeWithHeader))
	parseErrorBlock: [ :f :l :m |
	    parser close.
	    ^aBlock value: f value: l - 1 value: m.
	];
	parseSmalltalk
!

basicMethodsFor: category ifTrue: condition
    "Compile the following code inside the receiver, with the given category,
     if condition is true; else ignore it - included just to be sure"
    <primitive: 151>
    ^self primitiveFailed
!

methodsFor: aString
    STFileInParser methodsFor: aString ifTrue: true class: self
!

methodsFor: aString ifTrue: realCompile
    STFileInParser methodsFor: aString ifTrue: realCompile class: self
! !

