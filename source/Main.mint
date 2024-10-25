component Main {
  connect Todos exposing { items, add, load }

  state value : String = ""

  style wrapper {
    background: #E55934;
    height: 100vh;
  }

  style base {
    font-family: Open Sans;
    padding-top: 60px;
    margin: 0 auto;
    width: 600px;
  }

  style title {
    font-family: Faster One;
    text-align: center;
    font-size: 60px;
    color: #FFF;
  }

  style input {
    font-family: inherit;
    padding: 5px 15px;
    font-size: 20px;
    border: 0;
    flex: 1;
  }

  style button {
    background: rgba(0,0,0,0.5);
    font-family: inherit;
    margin-left: 10px;
    font-weight: 600;
    font-size: 20px;
    padding: 0 10px;
    color: #FFF;
    border: 0;
  }

  style box {
    background: rgba(255, 255, 255, 0.15);
    margin-top: 20px;
    padding: 20px;
  }

  style form {
    margin-top: 20px;
    display: flex;
  }

  style empty {
    text-align: center;
    padding: 50px 0;
    font-size: 30px;
    color: #FFF;

    svg {
      fill: currentColor;
      margin-top: 20px;
      height: 100px;
      width: 100px;
    }
  }

  style subtitle {
    font-family: Faster One;
    margin: 10px 0;
    font-size: 24px;
    color: #FFF;
  }

  get empty : Html {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      height="24"
      width="24"
    >
      <path
        d={
          "M22 2v22h-20v-22h3c1.23 0 2.181-1.084 3-2h8c.82.916 1.771 2 3 " \
          "2h3zm-11 1c0 .552.448 1 1 1 .553 0 1-.448 1-1s-.447-1-1-1c-.552 " \
          "0-1 .448-1 1zm9 1h-4l-2 2h-3.897l-2.103-2h-4v18h16v-18zm-13 " \
          "9.729l.855-.791c1 .484 1.635.852 2.76 1.654 2.113-2.399 " \
          "3.511-3.616 6.106-5.231l.279.64c-2.141 1.869-3.709 3.949-5.967 " \
          "7.999-1.393-1.64-2.322-2.686-4.033-4.271z"
        }
      />
    </svg>
  }

  fun componentDidMount : Promise(Void) {
    load()
  }

  fun handleInput (event : Html.Event) : Promise(Void) {
    next { value: Dom.getValue(event.target) }
  }

  fun addTodo (event : Html.Event) : Promise(Void) {
    Html.Event.preventDefault(event)
    await add(value)
    next { value: "" }
  }

  fun render : Html {
    <div::wrapper>
      <div::base>
        <div::title>"Todos!"</div>

        <div::box>
          <div::subtitle>"To do:"</div>

          <div>
            {
              let todoItems =
                Array.reject(items, (todo : TodoItem) : Bool { todo.done })

              if Array.isEmpty(todoItems) {
                [
                  <div::empty>
                    <div>"All done!"</div>
                    empty
                  </div>
                ]
              } else {
                for todo of todoItems {
                  <Todo todo={todo}/>
                }
              }
            }
          </div>

          <div::subtitle>"Done:"</div>

          <div>
            for todo of items {
              <Todo todo={todo}/>
            } when {
              todo.done
            }
          </div>

          <form::form onSubmit={addTodo}>
            <input::input onInput={handleInput} value={value}/>

            <button::button disabled={String.isEmpty(value)}>"Add"</button>
          </form>
        </div>
      </div>
    </div>
  }
}
