type activeItem = {
  number: int,
  isToday: bool,
  isNonWorkingDay: bool,
}

type disabledItem = {
  number: int,
  isNonWorkingDay: bool,
}

type item =
  | Empty
  | Active(activeItem)
  | Disabled(disabledItem)

type items = array<item>
