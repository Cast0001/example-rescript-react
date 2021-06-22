open Js.Array2

type styles = {
  container: string,
}

@module external s: styles = "./Calendar.scss"

@react.component
let make = (~items, ~daysNames) => {
  let daysOfMonth = daysNames
    -> mapi((title, i) => {
      let index = Belt.Int.toString(i)
      let isNonWorkingDay = title === "Sat" || title === "Sun"

      <CalendarDayItem key={index} title isNonWorkingDay />
    })
    -> React.array

  let days = items
    -> mapi((item, i) => {
      let index = Belt.Int.toString(i)

      switch item {
        | CalendarTypes.Empty => <CalendarEmptyItem key={index} />
        | CalendarTypes.Disabled({ number, isNonWorkingDay }) => {
          <CalendarDisabledItem
            key={index}
            number
            isNonWorkingDay
          />
        }
        | CalendarTypes.Active({ number, isNonWorkingDay, isToday }) => {
          <CalendarActiveItem
            key={index}
            number
            isToday
            isNonWorkingDay
          />
        }
      }
    })
    -> React.array

  <div className={s.container}>
    {daysOfMonth}
    {days}
  </div>
}
