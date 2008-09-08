function difficultHighlight( arg )
% this is a comment % with a nested comment

str1 = '% this is not a comment, but a string' ;
% 'this is not a string, but a comment'
str1 = str1'; % this is not a string, but the comment after a tranpose ' operator
str1 = str1(:)'+str1' ; % this is a comment after some transposed vars
str1 = [str1]'-str1' ; % this is a comment after some transposed vars
cel1 = {str1'}'; % ' this is a comment after a transposed cell
str2 = '   this is a spaced string   '   ;
str3 = '   str4 = ''this string can be evaluated'';  ' ;

eval( str3 );

str5 = [ 'some long text may be required, but if this text'  ...
'is really verbose, you should split it!'...
'And maybe you can include ''another inner string' ...
'''''containig another one'''' and so on''' ];