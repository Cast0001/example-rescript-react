switch ReactDOM.querySelector("#root") {
  | None => ()
  | Some(root) => ReactDOM.render(<App />, root)
}
