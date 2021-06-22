open Js.Array2

type styles = {
  container: string,
  selected: string,
  input: string,
}

@module external s: styles = "./MonthSelect.scss"

@react.component
let make = React.memo((
  ~options: MonthSelectTypes.options,
  ~selected: MonthSelectTypes.option,
  ~onSelect: (MonthSelectTypes.option) => ()
) => {
  let items = options
    -> map(({ title, value }) => {
      <option key={title} value>
        {React.string(title)}
      </option>
    })
    -> React.array

  let onChange = (event) => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    let selectedMonth = options -> find((item) => item.value === value)

    switch selectedMonth {
      | None => ()
      | Some(month) => onSelect(month)
    }
  }

  <div className={s.container}>
    <div className={s.selected}>
      {React.string("Selected month:")}
    </div>
    <select
      className={s.input}
      name="month"
      value={selected.value}
      onChange
    >
      {items}
    </select>
  </div>
})
