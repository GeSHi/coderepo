string nameOf ( string who )
{
    return llList2String( llParseString2List( who, [" "], [] ), 0 );
}

default
{
    touch_start ( integer total_number )
    {
        llSay( 0, "You touched me, " + nameOf( llDetectedName( 0 ) ) + "!" );
    }
}
