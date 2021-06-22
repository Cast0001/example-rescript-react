type styles = {
  container: string,
}

@module external s: styles = "./CalendarEmptyItem.scss"

@react.component
let make = React.memo(() => {
  <div className={s.container} />
})
