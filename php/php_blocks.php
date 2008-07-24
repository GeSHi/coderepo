//Already works ;-)
<?php
echo "test", "test?>";
echo 'test', 'test?>';
/*?>*/
//Single line comments are not filtered when looking for the end of an PHP block
//So lines with // and # before such enders are treated as normal enders.
?>

//This works too ;-)
<?
echo "test", "test?>";
echo 'test', 'test?>';
/*?>*/
?>

//This is not yet implemente, but isn't that hard to do ...
<%
echo "test", "test?>";
echo 'test', 'test?>';
/*?>*/
%>

//This are valid blocks too:
1#<?php//?>-<?php#?>#
2#<?//?>-<?#?>#
3#<%//%>-<%#%>#
4#<?= "-" ?>#
5#<?php echo "-"; //%>-?>#
