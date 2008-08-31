//////////////////////////////////////////////////////////////////////////////
//
//                 DECIDE for Scilab (version 2008/08/07)
//                  Copyright (C) 2008 Christophe DAVID
//        http://www.christophedavid.org/w/c/w.php/Files/DecisionAid
//       http://www.christophedavid.org/w/c/w.php/DECIDE/Introduction
//
//  This program is free software; you  can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 2 as published
//  by the Free Software Foundation (http://www.gnu.org/licenses/gpl.html).
//
//////////////////////////////////////////////////////////////////////////////


//                This program was last tested with Scilab 4.1.2
//                            http://www.scilab.org

//////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////

errclear();      // clear all errors
clear();         // kill variables
clearglobal();   // kill global variables
clc();           // clear command window
clear_pixmap();  // erase the pixmap buffer
clf();           // clear or reset the current graphic window to default values

///////////////////////////////////////////////////////////////////////////////

function [OutputMatrix] = D_Borda(InputMatrix)
   // rank each column
   OutputMatrix = D_RankMatrix(InputMatrix);
   // sum all rows
   OutputMatrix = sum(InputMatrix,'c') ;
   // rank resulting sums
   OutputMatrix = D_RankMatrix(OutputMatrix);
endfunction

///////////////////////////////////////////////////////////////////////////////

function [OutputMatrix] =  D_CorrelationMatrix(InputMatrix)
    [_rows, _cols] = size(InputMatrix);
    for i = 1:_cols
        mu  = mean(InputMatrix(:, i));
        sgi = 1.0 / (sqrt(_rows - 1) * stdev(InputMatrix(:, i)));
        InputMatrix(:, i) = (InputMatrix(:, i) - mu) * sgi;
    end
    OutputMatrix = InputMatrix' * InputMatrix;
endfunction

///////////////////////////////////////////////////////////////////////////////

function [D_Menu_Actions] = D_Initialize()
   format('v', 7);
   delmenu('DECIDE');    
   addmenu('DECIDE', [
                      'Load Decision Matrix',
                      'Calculate de Borda ranking'
                      'Calculate Correlation Matrix'
                      'Quit'
                     ]);
   D_Menu_Actions = [
                     'D_LoadDecisionMatrix()',
                     'D_ShowBordaRanking()',
                     'D_ShowCorrelationMatrix()'
                     'D_Quit()'
                    ];
endfunction

///////////////////////////////////////////////////////////////////////////////

function [ReturnValue] = D_LoadDecisionMatrix()
   global DecisionMatrix;
   DecisionMatrixFilename = tk_getfile("*.sc?", Title="Select Decision Matrix file");
   if DecisionMatrixFilename <> ''
      exec(DecisionMatrixFilename, -1);
      clc
      disp(DecisionMatrix, "DecisionMatrix=");
   end
   ReturnValue = 1;
endfunction

///////////////////////////////////////////////////////////////////////////////

function [ReturnValue] = D_Quit()
   delmenu('DECIDE');
   ReturnValue = 1;
endfunction

///////////////////////////////////////////////////////////////////////////////

function [OutputMatrix] = D_RankMatrix(InputMatrix)
   OutputMatrix = zeros(InputMatrix);
   [s, k]             = gsort(InputMatrix, 'r', 'd');
   [_rows, _columns]  = size(InputMatrix);

   for col = 1 : _columns
      _exaequo = 0;
      _rank    = 1;
      for row = 1 : _rows;
         OutputMatrix(k(row, col), col) = _rank;
         if row < _rows
             if InputMatrix(k(row, col), col) == InputMatrix(k(row + 1, col), col)
                _exaequo = _exaequo + 1;
             else
               _rank = _rank + 1 + _exaequo;
               _exaequo = 0;              
             end
         end
      end
   end
endfunction

///////////////////////////////////////////////////////////////////////////////

function [ReturnValue] =  D_ShowBordaRanking()
   global DecisionMatrix;
   clc
   disp(DecisionMatrix, "DecisionMatrix=");
   DeBordaRanking = D_Borda(DecisionMatrix)
   disp(DeBordaRanking, "de Borda ranking=");   
   ReturnValue = 1;   
endfunction   

///////////////////////////////////////////////////////////////////////////////

function [ReturnValue] =  D_ShowCorrelationMatrix()
   global DecisionMatrix;
   clc
   disp(DecisionMatrix, "DecisionMatrix=");
   CorrelationMatrix = D_CorrelationMatrix(DecisionMatrix)
   disp(CorrelationMatrix, "CorrelationMatrix=");   
   ReturnValue = 1;   
endfunction   

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

DECIDE = D_Initialize();
printf("%s", 'Click on the DECIDE button.');

