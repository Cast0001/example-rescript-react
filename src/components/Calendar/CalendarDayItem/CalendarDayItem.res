open Cx

type styles = {
  container: string,
  title: string,
  nonWorking: string,
}

@module external s: styles = "./CalendarDayItem.scss"

@react.component
let make = React.memo((~title, ~isNonWorkingDay) => {
  let className = cx([
    s.container,
    isNonWorkingDay ? s.nonWorking : ""
  ])

  <div className={className}>
    <div className={s.title}>
      {React.string(title)}
    </div>
  </div>
})
