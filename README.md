<h1 align="center"> Tempo </h1>

Tempo was designed to work both in OSX and in iOS (7.0+).
Work with the time or dates can be cumbersome, iOS development. Tempo allows you to deal easly with date and time.
Basics manipulations are already implemented in Tempo.

<h3 align="center"> How to use it </h3>

You can build a new Tempo, with severals way:

```Swift
var birthdayTempo = Tempo { (newTemp) -> () in
    newTemp.years = 2014
    newTemp.months = 12
    newTemp.days = 12
}
var currentTime = Tempo()
var tempoWithDate = Tempo(date: customNSDate)
var tempoWithString = Tempo(stringDate: "12/02/1992")
var tempoCustomFormat = Tempo(stringDate: "12/02/1992", "dd/MM/yyyy")
```

Convert Tempo to string, with specific format:
All the basics format work with Tempo.

```Swift
Tempo().format()                                // "2014 12 12 00:00:00"
Tempo().format("yyyy MM dd")                    // "2014 12 12"
Tempo().format("dd EE / MMMM / yyyy")           // "12 Fri / December / 2014"

let t1 = Tempo(stringDate: "2014 12 12")

//change the locale date
t1.locale = NSLocale(localeIdentifier: "fr_FR")
t1.format(format: "EEEE")                       // "mercredi"

t1.locale = NSLocale(localeIdentifier: "en_EN")
t1.format(format: "EEEE")                       // "Wednesday"

t1.locale = NSLocale(localeIdentifier: "es_ES")
t1.format(format: "EEEE")                       // "miércoles"
```

With Tempo you have access to the date components and the date itself:
The date components and the date are linked.

```Swift
let t = Tempo()

t.years! += 1
t.days! += 20

t.date = NSDate()
```

You can also make simple comparaison between two Tempo or with NSDate:

```Swift
var newDate = Tempo { (newTemp) -> () in
  newTemp.years = 2014
  newTemp.months = 10
  newTemp.days = 12
  newTemp.minutes = 2
}

println("newDate: \(newDate.formatDate())")             // "2014 10 12 00:02:00"
println("current time : \(Tempo().formatDate())")       // "2014 12 18 15:40:11"

Tempo().isAfter(newDate)                                // "True"
Tempo().isBefore(newDate)                               // "False"
Tempo().isSame(newDate)                                 // "False"
Tempo().isBetween(tempoLeft:newDate, tempoRight:d2)     // "True"

Tempo().isToday(newDate)                                // "False"
Tempo().isThisMonth(newDate)                            // "true"
Tempo().isThisYear(newDate)                             // "true"
```

Tempo also override operator the simple comparaison :

```Swift

// same as tempo1.isBefore(tempo2)
if tempo1 < tempo2 {
}

// same as tempo1.isAfter(tempo2)
if tempo1 > tempo2 {
}

// same as tempo1.isSame(tempo2)
if tempo1 == tempo2 {
}

// You can add two tempo together:
let result: Tempo = tempo1 + tempo2
let result: Tempo = tempo1 - tempo2
```

Know difference between two date component:

```Swift
var newDate = Tempo { (newTemp) -> () in
  newTemp.years = 2014
  newTemp.months = 10
  newTemp.days = 12
  newTemp.minutes = 2
}

Tempo().diffYear(newDate)                  // "0"
Tempo().diffMonth(newDate)                // "-4"
Tempo().diffWeek(newDate)                // "-18"
Tempo().diffDay(newDate)                // "-130"
```

Get time ago from date or current time:
Return literal string with the difference between two Tempo. Can be usefull in for display in message or feeds.
You have three diferent kind of display.

```Swift
var date = Tempo { (newTemp) -> () in
    newTemp.years = 2014
    newTemp.months = 10
    newTemp.days = 25
}

// Classic display
date.timeAgoNow()                       // "3 months ago"
date.timeAgo(Tempo())

// Short display
date.timeAgoSimpleNow()                 // "3mo"
date.timeAgoSimple(Tempo())

// More readable display
date.dateTimeUntilNow()                 // "This year"
date.dateTimeUntil(Tempo())
```
