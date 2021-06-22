open Cx

type styles = {
  container: string,
  number: string,
  nonWorking: string,
}

@module external s: styles = "./CalendarDisabledItem.scss"

@react.component
let make = React.memo((~number, ~isNonWorkingDay) => {
  let className = cx([
    s.container,
    isNonWorkingDay ? s.nonWorking : ""
  ])

  <div className={className}>
    <div className={s.number}>
      {React.string(Belt.Int.toString(number))}
    </div>
  </div>
})
