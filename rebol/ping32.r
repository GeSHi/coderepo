REBOL [
    Title: "Ping using Win32 API"
    File: %ping32.r
    Date:   28-Dec-2008
    Purpose: {Real (ICMP) ping using Win32 APIs}
    Version: 1.0.0
    Author: "Semseddin Moldibi"
    Notes: {The code may not be perfect but it works.
        It tries to ping given IP or host 4 times, and return on of -1,0,1,2,3,4
        -1: if IP address can't be resolved from url,
        0: if ping failed (timeout etc.)
        1,2,3,4: number of successful pings
        examples:
        ping 127.0.0.1 ;should return 4
        ping 192.168.1.1
        ping "rebol.com"
        ping "www.google.com"
        ping "www.noneexistingsite.com" ;return 0
        ping-ctx/clean-up ;to free the libraries when you are done..
    }

    Library: [
        level: 'intermediate
        platform: 'windows
        type: [internet module]
        domain: [win-api other-net]
        tested-under: [view 2.7.6.3.1 on "WinXP Home"]
        support: "semseddin/at/gmail.com"
        license: 'public-domain
        see-also: none
    ]
]

ping-ctx: context [

    ;I took this function from %get-version-ex.r (Gregg Irwin)
    make-elements: func [name count type /local result][
        if not word? type [type: type?/word type]
        result: copy "^/"
        repeat i count [
            append result join name [i " [" type "]" newline]
        ]
        to block! result
    ]

    WSAData: make struct! WSAdata-def: compose/deep/only    [
        wVersion [short]
        wHighVersion [short]
        (make-elements 'Description 257 #"@")
        (make-elements 'szSystemStatus 129 #"@")
        iMaxSockets [short]
        iMaxUdpDg [short]
        pad [short]
        lpVendorInfo [long]
    ] none

    IP_OPTION_INFORMATION: make struct! IP_OPTION_INFORMATION-def: compose/deep [
        TTL [char!]
        Tos [char!]
        Flags [char!]
        OptionsSize [char!]
        OptionsData [long]
    ] none

    IP_ECHO_REPLY: make struct! IP_ECHO_REPLY-def: compose/deep/only [
        Address [long]
        Status [long]
        RoundTripTime [long]
        DataSize [short]
        Reserved [short]
        data [long]
        Options [struct! (IP_OPTION_INFORMATION-def)]
    ] none

    ;load libraries
    IcmpLib: load/library %icmp.dll
    wsock32Lib: load/library %wsock32.dll

    WSAStartup: make routine! compose/deep/only [
        wVersionRequired [long]
        lpWSAdata [struct! (WSAData-def)]
        return: [long]
    ] wsock32Lib "WSAStartup"

    WSACleanup: make routine! [
        return: [long]
    ] wsock32Lib "WSACleanup"

    IcmpCreateFile: make routine! [return: [long]] IcmpLib "IcmpCreateFile"
    IcmpCloseHandle: make routine! [Handle [integer!] return: [long]] IcmpLib "IcmpCloseHandle"
    IcmpSendEcho: make routine! IcmpSendEcho-def: compose/deep/only [
        IcmpHandle [long]
        DestAddress [long]
        RequestData [string!]
        RequestSize [short]
        RequestOptns [struct! (IP_OPTION_INFORMATION-def)]
        ReplyBuffer [struct! (IP_ECHO_REPLY-def)]
        ReplySize [long]
        TimeOut [long]
        return: [long]
    ] IcmpLib "IcmpSendEcho"

    clean-up: does [
        free wsock32Lib
        free IcmpLib
    ]

    hPing: reqsize: RepSize: 0

    set 'ping func [dst /local d] [
        if not tuple? dst [
            dst: read to-url join "dns://" dst
            if not found? dst [
                return -1   ;can't find IP address
            ]
        ]
        either 0 = WSAStartup 257 WSAData [
            IP_OPTION_INFORMATION/TTL: to-char 255
            reply: IP_ECHO_REPLY
            opt: IP_OPTION_INFORMATION
            reqdat: copy "12345678901234567890123456789012" ;32 bytes
            reqsize: length? reqdat
            RepSize: reqsize + 28   ;28 is the length of the IP_ECHO_REPLY structure
                                    ;but length? returns 24, I don't know why?
            hPing: IcmpCreateFile
            either 0 <> hPing [
                d: to-integer reverse to-binary dst
                r: 0
                loop 4 [
                    r: r + IcmpSendEcho hPing d reqdat reqsize opt reply RepSize 2000 ;2 seconds
                ]
                IcmpCloseHandle hPing
                WSACleanup
                r
            ][
                make error! "Ping failed."
            ]
        ] [
            make error! "Winsock initialization failed."
        ]
    ]
]
;uncomment the next line to test
;halt
