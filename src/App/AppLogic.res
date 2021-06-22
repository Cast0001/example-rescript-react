open Js.Array2

let daysNames: array<string> = [ "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" ]

%%private(let getDateFormat = (date: Js.Date.t): string => {
  let currentMonth = Js.Date.getMonth(date) +. 1.0

  let currentYear = date
    -> Js.Date.getFullYear
    -> Belt.Float.toString

  let formattedMonth = currentMonth < 10.0
    ? "0" ++ Belt.Float.toString(currentMonth)
    : Belt.Float.toString(currentMonth)
  
  formattedMonth ++ "/" ++ currentYear
})

%%private(let getCurrentDateValues = (date): (float, float, float) => {
  let month = Js.Date.getMonth(date)
  let year = Js.Date.getFullYear(date)
  let day = Js.Date.getDate(date)

  (day, month, year)
})

%%private(let formatDayOfWeek = (dayOfWeek: float): int => {
  dayOfWeek
    -> Belt.Int.fromFloat
    -> (value) => switch value {
      | 0 => 7
      | _ => value - 1
    }
})

%%private(let getMaxDayCount = (date): int => {
  let (_, month, year) = getCurrentDateValues(date)

  Js.Date.makeWithYMD(~year, ~month=month +. 1.0, ~date=0.0, ())
    -> Js.Date.getDate
    -> Belt.Int.fromFloat
})

%%private(let getFirstDayOfWeekInMonth = (date): int => {
  let (_, month, year) = getCurrentDateValues(date)

  Js.Date.makeWithYMD(~year, ~month, ~date=1.0, ())
    -> Js.Date.getDay
    -> formatDayOfWeek
})

%%private(let getIsCurrentMonth = (date): bool => {
  let initDateMonth = Js.Date.getMonth(date)
  let currentDateMonth = Js.Date.now()
    -> Js.Date.fromFloat
    -> Js.Date.getMonth

  initDateMonth === currentDateMonth
})

%%private(let rec getRemainder = (value: int): int => {
  let daysNamesLength = length(daysNames)

  if value >= daysNamesLength {
    getRemainder(value - daysNamesLength)
  }
  else {
    value
  }
})

%%private(let getIsNonWorkingDay = (value: int): bool => {
  let day = getRemainder(value)
  let dayOfWeek = daysNames[day]

  switch dayOfWeek {
    | "Sat" | "Sun" => true
    | _ => false
  }
})

let getMonthDays = (date: Js.Date.t): CalendarTypes.items => {
  let isCurrentMonth = getIsCurrentMonth(date)
  let (day, _, _) = getCurrentDateValues(date)
  let currentDayIndex = day -> Belt.Int.fromFloat - 1
  let firstDay = getFirstDayOfWeekInMonth(date)
  let maxDays = getMaxDayCount(date)

  let result: CalendarTypes.items = []

  for i in 0 to 41 {
    let dayOfMonthIndex = i - firstDay
    let dayOfMonthNumber = dayOfMonthIndex + 1

    let item: ref<CalendarTypes.item> = ref(CalendarTypes.Empty)

    let isEmpty = i < firstDay || dayOfMonthIndex >= maxDays 

    if !isEmpty && dayOfMonthIndex <= currentDayIndex {
      item := CalendarTypes.Active({
        number: dayOfMonthNumber,
        isToday: isCurrentMonth && dayOfMonthIndex === currentDayIndex,
        isNonWorkingDay: (dayOfMonthNumber + firstDay - 1)
          -> getRemainder
          -> getIsNonWorkingDay,
      })
    }
    else if !isEmpty && dayOfMonthIndex > currentDayIndex {
      item := CalendarTypes.Disabled({
        number: dayOfMonthNumber,
        isNonWorkingDay: dayOfMonthNumber
          -> getRemainder
          -> getIsNonWorkingDay,
      })
    }

    let _ = push(result, item.contents)
  }

  result
}

let getMonthsOptions = (): MonthSelectTypes.options => {
  let currentDate: ref<Js.Date.t> = Js.Date.now()
    -> Js.Date.fromFloat
    -> ref

  let months: MonthSelectTypes.options = []

  let realDate = Js.Date.now() -> Js.Date.fromFloat
  let (_, _, year) = getCurrentDateValues(realDate)

  let startStep = getDateFormat(currentDate.contents)
  let lastStep = realDate
    -> Js.Date.setFullYear(year -. 1.0)
    -> Js.Date.fromFloat
    -> getDateFormat
  
  let currentStep = ref(startStep)

  while currentStep.contents !== lastStep {
    let title = getDateFormat(currentDate.contents)

    let _ = push(months, {
      title,
      value: Js.Date.toDateString(currentDate.contents),
    })  

    let currentMonth = Js.Date.getMonth(currentDate.contents)

    currentStep := title
    currentDate := currentDate.contents
      -> Js.Date.setMonth(currentMonth)
      -> Js.Date.fromFloat
      -> Js.Date.setDate(0.0)
      -> Js.Date.fromFloat
  }

  months
}
