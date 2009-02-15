REBOL [
    title: "Days Between"
    date: 9-feb-2009
    file: %days-between.r
    author:  Nick Antonaccio
    purpose: {
        Compute the number of days between any two dates - super simple GUI example.
    }
]

sd: ed: now/date

view layout [
    btn "Select Start Date" [
        sd: request-date 
        db/text: (ed - sd)
        sdt/text: sd 
        show sdt 
        show db
    ]
    sdt: field to-string sd [
        db/text: ((to-date edt/text) - (to-date sdt/text))
        show db
    ]
    btn "Select End Date" [
        ed: request-date
        edt/text: ed  
        db/text: (ed - sd) 
        show edt 
        show db
    ]
    edt: field to-string ed [
        db/text: ((to-date edt/text) - (to-date sdt/text))
        show db
    ]
    h1 "Days Between:"
    db: field to-string ((to-date edt/text) - (to-date sdt/text))
]
