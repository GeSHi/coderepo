<?php
/**
 * check how many languages are covered by coderepo testcases
 *
 *   This file is part of GeSHi.
 *
 *  GeSHi is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  GeSHi is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with GeSHi; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * @package    geshi
 * @subpackage tests
 * @author     Milian Wolff <mail@milianw.de>
 * @copyright  (C) 2008 Milian Wolff
 * @license    http://gnu.org/copyleft/gpl.html GNU GPL
 *
 */

if (!defined('STDIN')) {
  header('Content-Type: text/plain; charset=utf-8', true);
}

require '../profiling/lib.php';

chdir(dirname(__FILE__));

$dir = opendir('.');


echo "covered languages:\n"
    ."------------------\n\n";

$covered_languages = array();
while ($file = readdir($dir)) {
    if ( $file[0] == '.' || !is_dir($file)) {
        continue;
    }
    $covered_languages[] = $file;
}

sort($covered_languages);
echo implode ("\n", $covered_languages);

echo "\n\n-- covered total: ". count($covered_languages) . "\n\n";

closedir($dir);

echo "not covered languages:\n"
    ."----------------------\n\n";

$not_covered = array_diff($languages, $covered_languages);

foreach($not_covered as $lang) {
    echo $lang . "\n";
}

echo "\n-- not covered total: ". count($not_covered) . "\n";