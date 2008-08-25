I love PHP.net examples ...
<?php
$format = "There are %d monkeys in the %s";
printf($format, $num, $location);
?>
A bit more advanced ...
<?php
$format = "The %2\$s contains %1\$d monkeys";
printf($format, $num, $location);
?>
And a few more games at the docs ...
<?php
$format = "The %2\$s contains %1\$d monkeys.
           That's a nice %2\$s full of %1\$d monkeys.";
printf($format, $num, $location);
?>

k, now on to some more serious examples and tests ...
<?php
$n =  43951789;
$u = -43951789;
$c = 65; // ASCII 65 is 'A'

// Beachten Sie das doppelte %%, dies gibt ein '%'-Zeichen aus
printf("%%b = '%b'\n", $n); // Binärdarstellung
printf("%%c = '%c'\n", $c); // print the ascii character, same as chr() function
printf("%%d = '%d'\n", $n); // Standard-Integerdarstellung
printf("%%e = '%e'\n", $n); // Wissenschaftliche Notation
printf("%%u = '%u'\n", $n); // vorzeichenlose Integerdarstellung einer positiven Zahl
printf("%%u = '%u'\n", $u); // vorzeichenlose Integerdarstellung einer negativen Zahl
printf("%%f = '%f'\n", $n); // Fließkommazahldarstellung
printf("%%o = '%o'\n", $n); // Oktaldarstellung
printf("%%s = '%s'\n", $n); // Stringdarstellung
printf("%%x = '%x'\n", $n); // Hexadezimaldarstellung (Kleinbuchstaben)
printf("%%X = '%X'\n", $n); // Hexadezimaldarstellung (Großbuchstaben)

printf("%%+d = '%+d'\n", $n); // Vorzeichenangabe für positive Integerzahlen
printf("%%+d = '%+d'\n", $u); // Vorzeichenangabe für negative Integerzahlen
?>

And some string formatting ...
<?php
$s = 'monkey';
$t = 'many monkeys';

printf("[%s]\n",      $s); // normale rechtsbündige Ausgabe
printf("[%10s]\n",    $s); // rechtsbündige Ausgabe, mit Leerzeichen aufgefüllt
printf("[%-10s]\n",   $s); // linksbündige Ausgabe, mit Leerzeichen aufgefüllt
printf("[%010s]\n",   $s); // auffüllen mit Nullen funktioniert auch bei Strings
printf("[%'#10s]\n",  $s); // Verwendung des benutzerdefinierten Auffüllzeichens '#'
printf("[%10.10s]\n", $t); // linksbündige Ausgabe mit abschneiden überflüssiger
                           // Buchstaben nach der zehnten Stelle
?>

