* Include contenant classe LCL_DATE
* DATE_2_DAY_NUMBER : le 15 mai 2007 correspond au jour numéro 732812
* DAY_NUMBER_2_DATE : le jour numéro 732813 correspond au 16 mai 2007
* ADD : ajout de jours
* SUBTRACT : soustraction de jours
*
* Routines inspirées de
*   httpwww.codeproject.comcppLeap_Year_Macros.asp
*
*-----------------
* IS_LEAP_YEAR
*-----------------
*     #define IS_LEAP_YEAR(Y)
*     ( ((Y)0) && !((Y)%4) && ( ((Y)%100)  !((Y)%400) ) )
*
*-----------------
* COUNT_LEAPS
*-----------------
*     #define COUNT_LEAPS(Y)   ( ((Y)-1)4 - ((Y)-1)100 +
*    ((Y)-1)400 )
*     COUNT_LEAPS(4) = 0 because 0 is calculated at date 00040101,
*                        and the leap day is 00040229
*     COUNT_LEAPS(5) = 1 because it takes into account 00040229
*
*-----------------
* COUNT_DAYS
*-----------------
*     #define COUNT_DAYS(Y)  ( ((Y)-1)365 + COUNT_LEAPS(Y) )
*
*-----------------
* DAYS_BETWEEN_YEARS
*-----------------
*     #define DAYS_BETWEEN_YEARS(A,B)  (COUNT_DAYS(B) - COUNT_DAYS(A))
*
*-----------------
* get_year_from_day_number
*-----------------
*     #define COUNT_YEARS(D) ( 1 + ( (D) - COUNT_LEAPS((D)365) )365 )
*     BE CAREFUL this algorithm of COUNT_YEARS stops working well with
*     a big number of days (approximatively 2520000 days, i.e. year
*     6888), because of the approximative division by 365.
*
*-----------------
* YEAR_PLUS_DAYS
*-----------------
*     #define YEAR_PLUS_DAYS(Y,D)  COUNT_YEARS(  D + COUNT_DAYS(Y) )
*     BE CAREFUL algorithm of COUNT_YEARS stops working well with a
*     big number of days (see above).
*
*---------------------------------------------------------------------


TYPE-POOLS abap.
*---------------------------------------------------------------------
*       CLASS lcl_date DEFINITION
*---------------------------------------------------------------------
CLASS lcl_date DEFINITION.

  PUBLIC SECTION.

    CLASS-DATA modulo_result TYPE i.
    CLASS-DATA no_of_days_this_month TYPE TABLE OF int1
          INITIAL SIZE 12 READ-ONLY.
    CLASS-DATA no_of_days_since_jan_1st TYPE TABLE OF int2
          INITIAL SIZE 12 READ-ONLY.
    TYPES type_date(8) TYPE n.
    TYPES type_year(4) TYPE n.
    DATA date TYPE type_date.
    CLASS-DATA sap_algo TYPE abap_bool VALUE abap_true READ-ONLY.

    CLASS-METHODS class_constructor.

    CLASS-METHODS class_is_valid_year
      IMPORTING year TYPE gjahr
      RETURNING value(is_valid_year) TYPE flag.

    CLASS-METHODS class_is_leap_year
      IMPORTING year TYPE gjahr
      RETURNING value(is_leap_year) TYPE flag.

    CLASS-METHODS class_count_leaps_til_yyyy0101
      IMPORTING year TYPE gjahr
      RETURNING value(count_leaps) TYPE i.

    CLASS-METHODS class_count_days_til_yyyy0101
      IMPORTING year TYPE gjahr
      RETURNING value(count_days) TYPE i.

    CLASS-METHODS class_date_2_day_number
      IMPORTING date TYPE type_date
      RETURNING value(day_number) TYPE i.

    CLASS-METHODS class_day_number_2_date
      IMPORTING day_number TYPE i
      RETURNING value(date) TYPE type_date.

    CLASS-METHODS class_get_year_from_day_number
      IMPORTING no_of_days TYPE i
      RETURNING value(get_year_from_day_number) TYPE type_year.

    CLASS-METHODS class_days_since_jan_1st
      IMPORTING date TYPE type_date
      RETURNING value(days_since_jan_1st) TYPE i.

    CLASS-METHODS class_add
      IMPORTING date TYPE type_date
                no_of_days_to_add TYPE i
      RETURNING value(date2) TYPE type_date.

    CLASS-METHODS get_date_for_computation
      IMPORTING date TYPE type_date
      RETURNING value(r_date) TYPE type_date.

    CLASS-METHODS class_subtract
      IMPORTING date TYPE type_date
                no_of_days_to_subtract TYPE i
      RETURNING value(date2) TYPE type_date.

    CLASS-METHODS class_is_valid
      IMPORTING date TYPE type_date
      RETURNING value(is_valid) TYPE abap_bool.

    CLASS-METHODS class_is_gregorian_black_hole
      IMPORTING date TYPE type_date
      RETURNING value(is_gregorian_black_hole) TYPE abap_bool.

    CLASS-METHODS class_primitive_write_to
      IMPORTING date   type type_date
                outlen TYPE i
                datfmt TYPE usr01-datfm
      returning value(date_output) type string.

    CLASS-METHODS class_write_to
      IMPORTING date TYPE any
      returning value(date_output) type string.


    METHODS constructor
      IMPORTING date TYPE type_date.
    METHODS add
      IMPORTING no_of_days_to_add TYPE i.
    METHODS subtract
      IMPORTING no_of_days_to_subtract TYPE i.
    METHODS write.



ENDCLASS.                    "lcl_date DEFINITION













*---------------------------------------------------------------------
*       CLASS lcl_date IMPLEMENTATION
*---------------------------------------------------------------------
CLASS lcl_date IMPLEMENTATION.



*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD class_constructor.
    DATA l_no_of_days_since_jan_1st TYPE i.
    DATA l_no_of_days_this_month TYPE i.

    l_no_of_days_since_jan_1st = 0.
    DO 12 TIMES.
      APPEND l_no_of_days_since_jan_1st TO no_of_days_since_jan_1st.
      CASE sy-index.
        WHEN 2.
          l_no_of_days_this_month = 28.
        WHEN 4 OR 6 OR 9 OR 11.
          l_no_of_days_this_month = 30.
        WHEN 1 OR 3 OR 5 OR 7 OR 8 OR 10 OR 12.
          l_no_of_days_this_month = 31.
      ENDCASE.
      APPEND l_no_of_days_this_month TO no_of_days_this_month.
      ADD l_no_of_days_this_month TO l_no_of_days_since_jan_1st.
    ENDDO.
  ENDMETHOD.                    "class_CONSTRUCTOR



*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD class_is_valid_year.
    IF year = 0.
      is_valid_year = abap_false.
    ELSE.
      is_valid_year = abap_true.
    ENDIF.
  ENDMETHOD.                    "is_valid_year


*---------------------------------------------------------------------
  METHOD class_is_leap_year.

* 0004 - true  (it means does 00040229 exist Yes)
* 0005 - false (it means does 00050229 exist No)
* 0100 - false (it means does 01000229 exist No)
* 0400 - false (it means does 04000229 exist Yes)
* 2000 - false (it means does 20000229 exist Yes)
* 2100 - true  (it means does 21000229 exist No)
    is_leap_year = abap_false.
    modulo_result = year MOD 4.

    IF modulo_result EQ 0.
      IF year LE 1582.
        is_leap_year = abap_true.
      ELSE.
* 1582/10/15 = Start of the gregorian calendar
        modulo_result = year MOD 100.
        IF modulo_result NE 0.
          is_leap_year = abap_true.
        ELSE.
          modulo_result = year MOD 400.
          IF modulo_result EQ 0.
            is_leap_year = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.                    "is_leap_year


*---------------------------------------------------------------------
* Year (January 1st) - Number of leap days since Jesus Christ
* BE CAREFUL year 4 returns 0 (there is a shift of 1 year)
*---------------------------------------------------------------------
* 0001...0004 - 0
* 0005...0008 - 1 (means there is 1 leap year, i.e. leap day is
*                    00040229)
* 0097...0104 - 24 (means there are 24 leap years
*                       24 from 00010101 to 00961231
*                    or 24 from 00010101 to 00971231
*                    or 24 from 00010101 to 01001231
*                        because 01000229 does not exist
*                    or 24 from 00010101 to 01031231)
* 0105...0108 - 25
*---------------------------------------------------------------------
  METHOD class_count_leaps_til_yyyy0101.

*     #define COUNT_LEAPS(Y)   ( ((Y)-1)4 - ((Y)-1)100 +
*    ((Y)-1)400 )
    DATA l_year_minus_1 TYPE type_year.

    count_leaps = 0.
    l_year_minus_1 = year - 1.

* 0 à 3 donne 0
* 4 à 7 donne 1
* etc.
    modulo_result = floor( l_year_minus_1 / '4.0' ).
    ADD modulo_result TO count_leaps.


* Day number 577736 = 15821004 (day before start of gregorian calendar)
* Day number 577737 = 15821015 (start of gregorian calendar)
    IF l_year_minus_1 GE 1700.
      SUBTRACT 1600 FROM l_year_minus_1.

* 0 à 99 donne 0
* 100 à 199 donne 1
* etc.
      modulo_result = floor( l_year_minus_1 / '100.0' ).
      SUBTRACT modulo_result FROM count_leaps.

* 0 à 399 donne 0
* 400 à 799 donne 1
* etc.
      modulo_result = floor( l_year_minus_1 / '400.0' ).
      ADD modulo_result TO count_leaps.

    ENDIF.


  ENDMETHOD.                    "count_leaps



*---------------------------------------------------------------------
* Year (January 1st) - Day number from Jesus Christ
*---------------------------------------------------------------------
* Examples
* 0001 (0101) -    0 (le 00010101 est le jour numéro 0)
* 0004 (0101) - 1095 (le 00040101 est le jour numéro 1095)
* 0005 (0101) - 1461 (le 00050101 est le jour numéro 1461)
*---------------------------------------------------------------------
  METHOD class_count_days_til_yyyy0101.
*     #define COUNT_DAYS(Y)  ( ((Y)-1)365 + COUNT_LEAPS(Y) )
*
* BE CAREFUL COUNT_LEAPS_til_yyyy0101 has a shift of 1 year,
*             for example
*             COUNT_LEAPS_til_yyyy0101( year 4 ) returns 0,
*             COUNT_LEAPS_til_yyyy0101( year 5 ) returns 1
    count_days = ( ( year - 1 ) * 365 )
              + class_count_leaps_til_yyyy0101( year ).
*
* Start of gregorian calendar in 15821015. 10 days were removed from
* this year (passing directly from 15821004 to 15821015).
    IF year GT 1582.
      SUBTRACT 10 FROM count_days.
    ENDIF.

    count_days = count_days .
  ENDMETHOD.                    "count_days



*---------------------------------------------------------------------
* Day number from Jesus Christ - Year
* (Day number and year start from 1)
*---------------------------------------------------------------------
* Examples
*    0... 364 - 0001
*  365... 729 - 0002
*  730...1094 - 0002
* 1095...1459 - 0004
* 1460...1824 - 0005
* etc.
*---------------------------------------------------------------------
  METHOD class_get_year_from_day_number.
* THIS ALGORITHM IS WRONG FOR D = 1101205.
*     #define COUNT_YEARS(D) ( 1 + ( (D) - COUNT_LEAPS((D)365) )365 )

* IT'S WHY I MADE THIS NEW ONE USING THE FOLLOWING PROPERTIES
* BEFORE 15821015
*       4 years =   1461 days (3654 + 1 leap day)
* STARTING FROM 15821015
*       4 years =   1461 days (3654 + 1 leap day)
*     100 years =  36524 days (146125 - 1 leap day)
*     400 years = 146097 days (365244 + 1 leap day)
    DATA i TYPE i.
    DATA l_no_of_days2 TYPE i.

    l_no_of_days2 = no_of_days.
    get_year_from_day_number = 1.

* Day number 577736 = 1582/10/04 (day before start of gregorian calendar)
* Day number 577737 = 1582/10/15 (start of gregorian calendar)
    IF l_no_of_days2 GE 577737.


* Day number for 111585 is
*   - real  day # 578546
*   - with gregorian algorithm applied to all days since christ till
*       111585  day # 578544 (3146097 + 336524 + 211461)
*   So we need to subtract 2 from day number before applying the
*   following algorithm.
*   Note with before gregorian algorithm applied to all days since
*         christ till 111585  day # 578556 (396  1461) (it's
*         why there was a loss of 10 days with the start of
*         gregorian calendar - the day following 15821004 is
*         15821015; days 15821005-15821014 do not exist!)

      SUBTRACT 2 FROM l_no_of_days2.

* 400 years = 146097 days
      i = floor( l_no_of_days2 / '146097.0' ).
      get_year_from_day_number = get_year_from_day_number + ( i * 400 ).
      l_no_of_days2 = l_no_of_days2 - ( i * 146097 ).

* 100 years = 36524 days
*   be careful, 16001231 is day # 584389. This method
*   should return 1600. At this point of code, we have
*     - get_year_from_day_number = 1201
*     - l_no_of_days2 = 146096
*   Here we should get 3 but 146096 / 36524 = 4
*   (this code is also for 20001231, and all subsequent
*   400 years)
      IF l_no_of_days2 = 146096.
        i = 3.
      ELSE.
        i = floor( l_no_of_days2 / '36524.0' ).
      ENDIF.
      get_year_from_day_number = get_year_from_day_number + ( i * 100 ).
      l_no_of_days2 = l_no_of_days2 - ( i * 36524 ).

    ENDIF.

* 4 years = 1461 days
    i = floor( l_no_of_days2 / '1461.0' ).
    get_year_from_day_number = get_year_from_day_number + ( i * 4 ).
    l_no_of_days2 = l_no_of_days2 - ( i * 1461 ).

* Remaining years (add 0 to 3)
    IF l_no_of_days2 = 1460.
      ADD 3 TO get_year_from_day_number. "(last day of the leap year)
    ELSE.
      get_year_from_day_number = get_year_from_day_number
                                + FLOOR( l_no_of_days2 / '365.0' ).
    ENDIF.

  ENDMETHOD.                    "class_get_year_from_day_number



*---------------------------------------------------------------------
* Date - Number of days since January 1st
*---------------------------------------------------------------------
* Examples
* 20070101 - 0
* 20070201 - 31
*---------------------------------------------------------------------
  METHOD class_days_since_jan_1st.

* Get number of days up to start of month
*   Month 01 - 0
*   Month 02 - 31
*   Month 03 - 59 or 60
    READ TABLE no_of_days_since_jan_1st INDEX date+4(2)
          INTO days_since_jan_1st.
    IF class_is_leap_year( date(4) ) = abap_true AND date+4(2) >= '03'.
      ADD 1 TO days_since_jan_1st.
    ENDIF.
* Day number 577736 = 15821004 (day before start of gregorian calendar)
* Day number 577737 = 15821015 (start of gregorian calendar)
    IF date(4) = '1582' AND date+4 GE '1015'.
      SUBTRACT 10 FROM days_since_jan_1st.
    ENDIF.
    days_since_jan_1st = days_since_jan_1st + date+6(2) - 1.

  ENDMETHOD.                    "class_days_since_jan_1st



*---------------------------------------------------------------------
* date 00010101 is equivalent to day number 0
*---------------------------------------------------------------------
  METHOD class_date_2_day_number.

* Note Count_days_til_yyyy0101
*   0001 (0101) -    0 (le 00010101 est le jour numéro 0)
*   0004 (0101) - 1095 (le 00040101 est le jour numéro 1095)
*   0005 (0101) - 1461 (le 00050101 est le jour numéro 1461)
* Note days_since_jan_1st
*   20070101 - 0
*   20070201 - 31
    day_number = class_count_days_til_yyyy0101( date(4) )
                  + class_days_since_jan_1st( date ).

  ENDMETHOD.                    "date_2_day_number



*---------------------------------------------------------------------
* Day number 1 = 0001/01/01
*---------------------------------------------------------------------
  METHOD class_day_number_2_date.

    DATA year TYPE type_year.
    DATA days_since_jan_1st TYPE i.
    DATA days_since_jan_1st_bis TYPE i.
    DATA month(2) TYPE n.
    DATA day(2) TYPE n.
    DATA leapday TYPE i.

*    if day_number = 0.
*      date = '00000000'.
*    else.

* Examples
*    0... 364 - 0001
*  365... 729 - 0002
    year = class_get_year_from_day_number( day_number ).

* day number 1 (00010101) - 0 (days from january 1st)
* day number 3 (00010103) - 2 (days from january 1st)
* day number 34 (00010203) - 33 (days from january 1st)
* Note Count_days_til_yyyy0101
*   0001 (0101) -    0 (le 00010101 est le jour numéro 0)
*   0004 (0101) - 1095 (le 00040101 est le jour numéro 1095)
*   0005 (0101) - 1461 (le 00050101 est le jour numéro 1461)
    days_since_jan_1st = day_number
                        - class_count_days_til_yyyy0101( year ).

* Day number 577736 = 1582/10/04 (day before start of gregorian calendar)
* Day number 577737 = 1582/10/15 (start of gregorian calendar)
    IF year = '1582' AND day_number GE 577737.
      ADD 10 TO days_since_jan_1st.
    ENDIF.

* Calcul MONTH.
* Example for non-leap year (365 days)
*   January    0-30 => 2  [ 31]
*   February  31-58 => 3  [ 59]
*   March     59-61 => 3  [ 59],  62-89  => 4 [ 90]
*   April     90-92 => 4  [ 90],  93-119 => 5 [120]
*   ...
*   December 335-340 => 12 [341], 341-365 => 13
    month = floor( days_since_jan_1st / '31.0' ) + 2.

    leapday = 0.
    IF class_is_leap_year( year ) = abap_true
        AND days_since_jan_1st >= 59.
* février d'une année bissextile
      leapday = 1.
    ENDIF.
* Voir s'il faut ajuster au mois inférieur
    IF month EQ 13.
      month = 12.
    ELSE.
* [1]=0, [2]=31, [3]=58 (ou 59 si bissextile), ...
      READ TABLE no_of_days_since_jan_1st INDEX month
                INTO days_since_jan_1st_bis.
      ADD leapday TO days_since_jan_1st_bis.
      IF days_since_jan_1st < days_since_jan_1st_bis.
        SUBTRACT 1 FROM month.
      ENDIF.
      IF leapday = 1 AND days_since_jan_1st = 59.
        leapday = 0.
      ENDIF.
    ENDIF.

    READ TABLE no_of_days_since_jan_1st INDEX month
              INTO days_since_jan_1st_bis.
    ADD leapday TO days_since_jan_1st_bis.
    day = days_since_jan_1st - days_since_jan_1st_bis + 1.
    CONCATENATE year month day INTO date.

*    endif.

  ENDMETHOD.                    "day_number_2_date



*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD get_date_for_computation.

    IF class_is_valid( date ) = abap_false.
      r_date = '00010101'.
    ELSEIF class_is_gregorian_black_hole( date ) = abap_true.
* Dates 15821005 to 15821014 do not exist because of the
* Gregorian calendar reform. SAP does not consider these inexistent
* days as invalid, but instead consider that 15821005 is equivalent
* to 15821015, 15821006 to 15821016, etc.
* For example, when SAP has to add 1 to 15821008 (which is
* an invalid date), it converts first 15821008 into 15821018, and
* then adds 1.
      r_date = date + 10.
    ELSE.
      r_date = date.
    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD class_add.

    DATA i TYPE i.

    date2 = get_date_for_computation( date ).
    i = class_date_2_day_number( date2 ) + no_of_days_to_add.
    date2 = class_day_number_2_date( i ).

* If result is 00010101, SAP converts it into 0000000, do not ask
* me why.
    IF date2 = '00010101'.
      date2 = '00000000'.
    ENDIF.

  ENDMETHOD.                    "add



*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD class_subtract.

    DATA no_of_days_to_add TYPE i.

    no_of_days_to_add = no_of_days_to_subtract / -1.

    date2 = class_add(
                date              = date
                no_of_days_to_add = no_of_days_to_add ).

  ENDMETHOD.                    "class_subtract



*---------------------------------------------------------------------
*---------------------------------------------------------------------
* Note this method considers that dates 15821005 to 15821014 are valid.
* If you want to check these, use method is_gregorian_black_hole.

  METHOD class_is_valid.

    DATA l_no_of_days_this_month TYPE i.

    is_valid = abap_true.
    IF date(4) = '0000'
          OR NOT date+4(2) BETWEEN '01' AND '12'
          OR NOT date+6(2) BETWEEN '01' AND '31'.
      is_valid = abap_false.
    ELSEIF date+4(2) = '02'.
      IF class_is_leap_year( date(4) ) = abap_true.
        IF date+6(2) GT '29'.
          is_valid = abap_false.
        ENDIF.
      ELSEIF date+6(2) GT '28'.
        is_valid = abap_false.
      ENDIF.
    ELSE.
      READ TABLE no_of_days_this_month INDEX date+4(2)
            INTO l_no_of_days_this_month.
      IF date+6(2) GT l_no_of_days_this_month.
        is_valid = abap_false.
      ENDIF.
    ENDIF.

  ENDMETHOD.                    "is_valid



*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD class_is_gregorian_black_hole.

    is_gregorian_black_hole = abap_false.

    IF date BETWEEN '15821005' AND '15821014'.
      is_gregorian_black_hole = abap_true.
    ENDIF.

  ENDMETHOD.                    "class_is_gregorian_black_hole



*---------------------------------------------------------------------
* DATFMT possible values are
*       1 = DD.MM.YYYY
*       2 = MMDDYYYY
*       3 = MM-DD-YYYY
*       4 = YYYY.MM.DD
*       5 = YYYYMMDD
*       6 = YYYY-MM-DD
* OUTLEN possible values are
*       8 = date defined internally DATA X TYPE D.
*      10 = date defined like DDIC date DATA X TYPE SYDATUM.
*---------------------------------------------------------------------
  METHOD class_primitive_write_to.

    DATA separator(1) TYPE c.

    IF outlen = 8.
      separator = space.
    ELSEIF outlen = 10.
      CASE datfmt.
        WHEN '1' OR '4'.
*       1 = DD.MM.YYYY
*       4 = YYYY.MM.DD
          separator = '.'.
        WHEN '2' OR '5'.
*       2 = MMDDYYYY
*       5 = YYYYMMDD
          separator = ''.
        WHEN '3' OR '6'.
*       3 = MM-DD-YYYY
*       6 = YYYY-MM-DD
          separator = '-'.
        WHEN others.
* This case is said to be impossible
      ENDCASE.
    ELSE.
* This case is said to be impossible (output length can only be 8 or 10)
    ENDIF.

    CASE datfmt.
      WHEN '1'.
*       1 = DD.MM.YYYY
        CONCATENATE date+6(2) separator date+4(2) separator date(4)
              INTO date_output.
      WHEN '2' OR '3'.
*       2 = MMDDYYYY
*       3 = MM-DD-YYYY
        CONCATENATE date+4(2) separator date+6(2) separator date(4)
              INTO date_output.
      WHEN '4' OR '5' OR '6'.
*       4 = YYYY.MM.DD
*       5 = YYYYMMDD
*       6 = YYYY-MM-DD
        CONCATENATE date(4) separator date+4(2) separator date+6(2)
              INTO date_output.
      WHEN others.
* This case is said to be impossible
    ENDCASE.

  ENDMETHOD.                    "class_write



*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD class_write_to.

    DATA len TYPE i.
    DATA datfmt TYPE usr01-datfm.

    DESCRIBE FIELD date OUTPUT-LENGTH len.

    SELECT SINGLE datfm FROM usr01 INTO datfmt
          WHERE Bname = sy-uname.
    IF sy-subrc NE 0.
* This case is said to be impossible
    endif.
    date_output = class_primitive_write_to(
          date   = date
          datfmt = datfmt
          outlen = len ).

  ENDMETHOD.                    "class_write



*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD constructor.
    me->date = date.
  ENDMETHOD.                    "constructor



*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD add.
    date = class_add(
              date              = date
              no_of_days_to_add = no_of_days_to_add ).
  ENDMETHOD.                    "add



*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD subtract.
    date = class_subtract(
              date                   = date
              no_of_days_to_subtract = no_of_days_to_subtract ).
  ENDMETHOD.                    "subtract



*---------------------------------------------------------------------
*---------------------------------------------------------------------
  METHOD write.
    data date_string type string.
    date_string = class_write_to( date ).
    write date_string.
  ENDMETHOD.                    "write



ENDCLASS.                    "date IMPLEMENTATION









*---------------------------------------------------------------------
*---------------------------------------------------------------------
class lcl_date_test definition for testing "#AU Risk_Level Harmless
      inheriting from Cl_Aunit_Assert.  "#AU Duration Short
  public section.
    METHODS class_tests1 for testing.
    METHODS class_tests2 for testing.
    METHODS class_tests3 for testing.
endclass.                    "lcl_date_test DEFINITION



*---------------------------------------------------------------------
*---------------------------------------------------------------------
class lcl_date_test implementation.

  DEFINE assert2.
    case &2.
      when '='.
        cl_aunit_assert=>assert_equals( act = &1 exp = &3 ).
*      if not &1 = &3.
*        write : / 'ERROR' color 6, 'IN' color 6,
*              '. The test', &1, &2, &3, 'is false'.
*      endif.
    endcase.
  END-OF-DEFINITION.

*---------------------------------------------------------------------
* Cette méthode teste les valeurs sensées être retournées par les
* opérations sur les dates SAP (tests du standard sap)
*---------------------------------------------------------------------
  METHOD class_tests1.

    DATA date TYPE d.
    DATA increment(20) TYPE n.
    data i type i.

*    WRITE / 'Test 1 simple addition'.
    date = '00010101'.
    ADD 1000 TO date.
    assert2 date '=' '00030928'.

*    WRITE / 'Test 2 huge incrementation, result above year 9999'.
    date = '00010101'.
    ADD 2000000000 TO date.
    assert2 date '=' '00000000'.

*    WRITE / 'Test 3 increment  4 bytes-signed-integer '
*          & '( 2,5 billions)'.
    date = '00010101'.
    TRY.
        ADD 2500000000 TO date.
      CATCH cx_sy_arithmetic_overflow.
        sy-subrc = 1.
    ENDTRY.
    cl_aunit_assert=>assert_subrc( act = sy-subrc exp = 1 ).
*    assert2 sy-subrc '=' 1.
    assert2 date '=' '00010101'.

*    WRITE / 'Test 4 same as test 3 but using variable as increment'.
    date = '00010101'.
    increment = 2500000000.
    TRY.
        ADD increment TO date.
      CATCH cx_sy_arithmetic_overflow.
        sy-subrc = 1.
    ENDTRY.
    cl_aunit_assert=>assert_subrc( act = sy-subrc exp = 1 ).
*    assert2 sy-subrc '=' 1.
    assert2 date '=' '00010101'.

*    WRITE / 'Test 5 add number expressed as character string'.
    date = '00010101'.
    ADD '5' TO date.
    assert2 date '=' '00010106'.

*    WRITE / 'Test 6 add 5 to date zero'.
    CLEAR date.
    ADD '5' TO date.
    assert2 date '=' '00010106'.

*    WRITE / 'Test 7 add 5 to date 00000505'.
    date = '00000505'.
    ADD '5' TO date.
    assert2 date '=' '00010106'.

*    WRITE / 'Test 8 add 5 to date 20070535'.
    date = '20070535'.
    ADD '5' TO date.
    assert2 date '=' '00010106'.

* This test shows that in SAP system, 00010101 corresponds to
* day number zero (not one).
* 00010131 is day #30
* 00010302 is day #60
*    WRITE / 'Test 9 multiply by 2'.
    date = '00010131'.
    MULTIPLY date BY 2.
    assert2 date '=' '00010302'.

*    WRITE / 'Test 10 00010101 + zero - zero!!!'.
    date = '00010101'.
    ADD 0 TO date.
    assert2 date '=' '00000000'.

*    WRITE / 'Test 11 00010101'.
    date = '00010101'.
    date = date.
    assert2 date '=' '00010101'.

*    WRITE / 'Test 12 00010102 - 1 - zero!!!'.
    date = '00010102'.
    SUBTRACT 1 FROM date.
    assert2 date '=' '00000000'.

*    WRITE / 'Test 13 00010101 + 36524 - 01001231'.
    date = '00010101'.
    ADD 36524 TO date.
    assert2 date '=' '01001231'.

*    WRITE / 'Test 14 00010101 + 36525 - 01010101'.
    date = '00010101'.
    ADD 36525 TO date.
    assert2 date '=' '01010101'.

* Gregorian tests
*    WRITE / 'Test 15 15821004 + 1 - 15821015'.
    date = '15821004'.
    ADD 1 TO date.
    assert2 date '=' '15821015'.

*    WRITE / 'Test 16 15821004 + 0 - 577736'.
    date = '15821004'.
    i = date + 0.
    assert2 i '=' 577736.

*    WRITE / 'Test 17 15821015 + 0 - 577737'.
    date = '15821015'.
    i = date + 0.
    assert2 i '=' 577737.

  ENDMETHOD.                                                "tests1



*---------------------------------------------------------------------
* Cette méthode teste les valeurs sensées être retournées par les
* méthodes de la classe DATE
*---------------------------------------------------------------------
  METHOD class_tests2.

    DATA x TYPE REF TO lcl_date.
    DATA i TYPE i.
    DATA i2 TYPE i.
    DATA j TYPE i.
    DATA l_diff_tolerance TYPE i.
    DATA l_date TYPE lcl_date=>type_date.
    DATA l_date2 TYPE lcl_date=>type_date.
    DATA l_year TYPE lcl_date=>type_year.
    DATA l_year2 TYPE lcl_date=>type_year.
    DATA date TYPE d.
    DATA date2 TYPE d.
    DATA l_day_number TYPE i.
    data string type string.

************************
* Tests de la méthode get_year_from_day_number

    l_year = lcl_date=>class_get_year_from_day_number( 0 ).
    assert2 l_year '=' 1.
    l_year = lcl_date=>class_get_year_from_day_number( 364 ).
    assert2 l_year '=' 1.
    l_year = lcl_date=>class_get_year_from_day_number( 365 ).
    assert2 l_year '=' 2.
    l_year = lcl_date=>class_get_year_from_day_number( 1460 ).
    assert2 l_year '=' 4.
    l_year = lcl_date=>class_get_year_from_day_number( 1461 ).
    assert2 l_year '=' 5.
* 1825 = 0005/12/31
    l_year = lcl_date=>class_get_year_from_day_number( 1825 ).
    assert2 l_year '=' 5.
* 1826 = 0006/01/01
    l_year = lcl_date=>class_get_year_from_day_number( 1826 ).
    assert2 l_year '=' 6.


************************
* Tests de la méthode DATE_2_DAY_NUMBER

    l_day_number = lcl_date=>class_date_2_day_number( '00040401' ).
    assert2 l_day_number '=' 1186.
    l_day_number = lcl_date=>class_DATE_2_DAY_NUMBER( '15821004' ).
    assert2 l_day_number '=' 577736.
    l_day_number = lcl_date=>class_DATE_2_DAY_NUMBER( '15821015' ).
    assert2 l_day_number '=' 577737.


************************
* Tests de la méthode DAY_NUMBER_2_DATE
    l_date = lcl_date=>class_day_number_2_date( 0 ).
    assert2 l_date '=' '00010101'.
    l_date = lcl_date=>class_day_number_2_date( 364 ).
    assert2 l_date '=' '00011231'.
    l_date = lcl_date=>class_day_number_2_date( 365 ).
    assert2 l_date '=' '00020101'.


************************
* Tests de la méthode class_primitive_write_to

    STRING = lcl_date=>class_primitive_write_to(
          date   = '20070515'
          datfmt = '1'
          outlen = 10 ).
    assert2 string '=' '15.05.2007'.




  ENDMETHOD.                                                "tests2



*---------------------------------------------------------------------
* Cette méthode compare les valeurs retournées par les dates sap et
* les valeurs retournées par la classe DATE, pour s'assurer qu'elles
* sont identiques
*---------------------------------------------------------------------
  METHOD class_tests3.

    DATA x TYPE REF TO lcl_date.
    DATA i TYPE i.
    DATA i2 TYPE i.
    DATA j TYPE i.
    DATA l_diff_tolerance TYPE i.
    DATA l_date TYPE lcl_date=>type_date.
    DATA l_date2 TYPE lcl_date=>type_date.
    DATA l_year TYPE lcl_date=>type_year.
    DATA l_year2 TYPE lcl_date=>type_year.
    DATA date TYPE d.
    DATA date2 TYPE d.
    data l_count type i.


****************************
* Tests des méthodes DAY_NUMBER_2_DATE et DATE_2_DAY_NUMBER par
* rapport au traitement des dates SAP

* ici c'est un peu long
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        TEXT               = 'Test méthodes DAY_NUMBER_2_DATE et '
        &
        'DATE_2_DAY_NUMBER'.

    i = lcl_date=>class_date_2_day_number( '00010102' ).
    j = lcl_date=>class_date_2_day_number( '20091231' ).
    date = '00010102'.
    l_count = 0.
    WHILE i LT j.
      l_date = lcl_date=>class_day_number_2_date( i ).
      date2 = date + i - 1.
      assert2 l_date '=' date2.
      i2 = lcl_date=>class_date_2_day_number( l_date ).
      assert2 i '=' i2.

      add 1 to l_count.
      if l_count = 10000.
        CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
          EXPORTING
            TEXT = l_date.
        l_count = 0.
      endif.

      ADD 1 TO i.
    ENDWHILE.


****************************
* Tests des méthodes COUNT_DAYS_til_yyyy0101 et get_year_from_day_number

    l_year = 1.
    DO.
      i = lcl_date=>class_count_days_til_yyyy0101( l_year ).
      l_year2 = lcl_date=>class_get_year_from_day_number( i ).
      assert2 l_year2 '=' l_year.
      IF l_year = '9999'.
        EXIT.
      ENDIF.
      ADD 1 TO l_year.
    ENDDO.

  ENDMETHOD.                                                "tests2

endclass.                    "lcl_date_test IMPLEMENTATION