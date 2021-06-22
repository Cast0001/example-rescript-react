open Cx

type styles = {
  container: string,
  number: string,
  nonWorking: string,
  today: string,
}

@module external s: styles = "./CalendarActiveItem.scss"

@react.component
let make = React.memo((~number, ~isNonWorkingDay, ~isToday) => {
  let className = cx([
    s.container,
    isNonWorkingDay ? s.nonWorking : "",
    isToday ? s.today : "",
  ])

  <div className={className}>
    <div className={s.number}>
      {
        number
          -> Belt.Int.toString
          -> React.string
      }
    </div>
  </div>
})
