module App = {
  [@react.component]
  let make = () =>
    <h1>{React.string("Hello Melange!")}</h1>;
};

switch (ReactDOM.querySelector("#root")) {
| Some(root) => ReactDOM.render(<App />, root)
| None => Js.Console.error("No #root")
}
