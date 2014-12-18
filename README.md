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
```

Convert Tempo to string, with specific format:
All the basics format work with Tempo.

```Swift
Tempo().formatDate() // "2014 12 12 00:00:00"
Tempo().formatDate("yyyy MM dd") // "2014 12 12"
Tempo().formatDate("dd EE / MMMM / yyyy") // "12 Fri / December / 2014"
```

With Tempo, it's more easy to chain basic operation:

```Swift
var currentTime = Tempo()
        
println("Before operation: \(currentTime.formatDate())") // "2014 12 18 15:28:12"
currentTime.add(.Years, value: 1).add(.Months, value: 3).subtract(.Hours, value: 3).subtract(.Minutes, value: 80)
println("After operation: \(currentTime.formatDate())") // "2016 03 18 11:08:12"
```

You can also make simple comparaison between two Tempo or with NSDate:

```Swift
var newDate = Tempo { (newTemp) -> () in
  newTemp.years = 2014
  newTemp.months = 10
  newTemp.days = 12
  newTemp.minutes = 2
}

println("newDate: \(newDate.formatDate())")          // "2014 10 12 00:02:00"
println("current time : \(Tempo().formatDate())")    // "2014 12 18 15:40:11"

Tempo().isAfter(newDate) // "True"
Tempo().isBefore(newDate) // "False"
Tempo().isAfter(newDate, .Months) // "False"
Tempo().isSame(newDate) // "False"
Tempo().isSame(newDate, .Years) // "True"
```

Know difference between two date component:

```Swift
var newDate = Tempo { (newTemp) -> () in
  newTemp.years = 2014
  newTemp.months = 10
  newTemp.days = 12
  newTemp.minutes = 2
}

Tempo().diff(.Years, date: newDate) // "0"
Tempo().diff(.Months, date: newDate) // "-2"
newDate.diff(.Secondes, date: Tempo()) // "5849274"
```

Get time ago from date or current time:
Return literal string with the difference between two Tempo. Can be usefull in for display in message or feeds.

```Swift
var date = Tempo { (newTemp) -> () in
    newTemp.years = 2014
    newTemp.months = 10
    newTemp.days = 25
}
        
println(date.timeAgoFromNow()) // "1 months ago"

newTemp.months = 12
newTemp.days = 18
newTemp.hours = 12

println(date.timeAgoFromNow()) // "3 hours ago"
println(Tempo().timeAgoFromNow()) // "seconds ago"
date.timeAgoFrom(otherTempo)
```
