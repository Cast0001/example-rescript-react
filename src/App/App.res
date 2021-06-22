type styles = {
  container: string,
  calendar: string,
  controlls: string,
}

@module external s: styles = "./App.scss"

@react.component
let make = () => {
  let options = AppLogic.getMonthsOptions()
  let (selectedMonth, setSelectedMonth) = React.useState(_ => options[0]);

  let onSelect = (month: MonthSelectTypes.option) => {
    setSelectedMonth(_ => month)
  }

  let date = Js.Date.fromString(selectedMonth.value)
  let days = AppLogic.getMonthDays(date)
  let daysNames = AppLogic.daysNames

  <div className={s.container}>
    <div className={s.controlls}>
      <MonthSelect options selected={selectedMonth} onSelect />
    </div>
    <div className={s.calendar}>
      <Calendar items={days} daysNames />
    </div>
  </div>
}
