record TodoItem {
  name : String,
  done : Bool,
  id : Number
}

store Todos {
  property items : Array(TodoItem) = [
    {
      name = "Showase Mint!",
      done = true,
      id = 0
    },
    {
      name = "Try Mint!",
      done = false,
      id = 1
    }
  ]

  fun add (name : String) : Void {
    next { state | items = Array.push(item, items) }
  } where {
    nextId =
      if (Array.isEmpty(items)) {
        0
      } else {
        items
        |> Array.map(\todo : TodoItem => todo.id)
        |> Array.max()
      }

    item =
      {
        id = nextId + 1,
        done = false,
        name = name
      }
  }

  fun remove (item : TodoItem) : Void {
    next { state | items = updatedItems }
  } where {
    updatedItems =
      items
      |> Array.reject(\todo : TodoItem => todo.id == item.id)
  }

  fun toggle (item : TodoItem) : Void {
    next { state | items = updatedItems }
  } where {
    updatedItems =
      items
      |> Array.map(
        \todo : TodoItem =>
          if (todo.id == item.id) {
            { item | done = Bool.not(item.done) }
          } else {
            todo
          })
  }
}

component Todo {
  connect Todos exposing { remove, toggle }

  property todo : TodoItem = {
    done = false,
    name = "",
    id = 0
  }

  style base {
    text-decoration: {textDecoration};
    align-items: center;
    padding: 10px 15px;
    opacity: {opacity};
    font-size: 24px;
    display: flex;
    color: #FFF;

    &:nth-child(odd) {
      background: rgba(0,0,0,0.1);
    }

    &:nth-child(even) {
      background: rgba(0,0,0,0.2);
    }
  }

  style span {
    text-overflow: ellipsis;
    white-space: nowrap;
    font-weight: 600;
    overflow: hidden;
    margin: 0 15px;
    flex: 1;
  }

  style icon {
    -webkit-appearance: none;
    appearance: none;
    background: none;
    cursor: pointer;
    color: inherit;
    padding: 0;
    border: 0;

    &:focus {
      outline: none;
    }

    & svg {
      fill: currentColor;
    }
  }

  get opacity : Number {
    if (todo.done) {
      0.5
    } else {
      1
    }
  }

  get textDecoration : String {
    if (todo.done) {
      "line-through"
    } else {
      ""
    }
  }

  get trashCan : Html {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      height="24"
      width="24">

      <path
        d={
          "M3 6v18h18v-18h-18zm5 14c0 .552-.448 1-1 1s-1-.448-1-1v-" \
          "10c0-.552.448-1 1-1s1 .448 1 1v10zm5 0c0 .552-.448 1-1 1" \
          "s-1-.448-1-1v-10c0-.552.448-1 1-1s1 .448 1 1v10zm5 0c0 ." \
          "552-.448 1-1 1s-1-.448-1-1v-10c0-.552.448-1 1-1s1 .448 1" \
          " 1v10zm4-18v2h-20v-2h5.711c.9 0 1.631-1.099 1.631-2h5.31" \
          "5c0 .901.73 2 1.631 2h5.712z"
        }/>

    </svg>
  }

  get checkMark : Html {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      height="24"
      width="24">

      <path
        d={
          "M12 0c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12" \
          "-12-5.373-12-12-12zm-1.25 17.292l-4.5-4.364 1.857-1.858 " \
          "2.643 2.506 5.643-5.784 1.857 1.857-7.5 7.643z"
        }/>

    </svg>
  }

  fun handleRemove (event : Html.Event) : Void {
    remove(todo)
  }

  fun handleToggle (event : Html.Event) : Void {
    toggle(todo)
  }

  fun render : Html {
    <div::base>
      <button::icon onClick={handleToggle}>
        <{ checkMark }>
      </button>

      <div::span>
        <{ todo.name }>
      </div>

      <button::icon onClick={handleRemove}>
        <{ trashCan }>
      </button>
    </div>
  }
}

record State {
  value : String
}

component Main {
  connect Todos exposing { items, add }

  state : State { value = "" }

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

    & svg {
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
      width="24">

      <path
        d={
          "M22 2v22h-20v-22h3c1.23 0 2.181-1.084 3-2h8c.82.916 1.77" \
          "1 2 3 2h3zm-11 1c0 .552.448 1 1 1 .553 0 1-.448 1-1s-.44" \
          "7-1-1-1c-.552 0-1 .448-1 1zm9 1h-4l-2 2h-3.897l-2.103-2h" \
          "-4v18h16v-18zm-13 9.729l.855-.791c1 .484 1.635.852 2.76 " \
          "1.654 2.113-2.399 3.511-3.616 6.106-5.231l.279.64c-2.141" \
          " 1.869-3.709 3.949-5.967 7.999-1.393-1.64-2.322-2.686-4." \
          "033-4.271z"
        }/>

    </svg>
  }

  fun handleInput (event : Html.Event) : Void {
    next { state | value = event.target.value }
  }

  fun addTodo (event : Html.Event) : Void {
    do {
      Html.Event.preventDefault(event)

      add(state.value)

      next { state | value = "" }
    }
  }

  fun render : Html {
    <div::wrapper>
      <div::base>
        <div::title>
          <{ "Todos!" }>
        </div>

        <div::box>
          <div::subtitle>
            <{ "To do:" }>
          </div>

          <{ todos }>

          <div::subtitle>
            <{ "Done:" }>
          </div>

          <{ done }>

          <form::form onSubmit={addTodo}>
            <input::input
              onInput={handleInput}
              value={state.value}/>

            <button::button disabled={String.isEmpty(state.value)}>
              <{ "Add" }>
            </button>
          </form>
        </div>
      </div>
    </div>
  } where {
    done =
      items
      |> Array.select(\todo : TodoItem => todo.done)
      |> Array.map(\todo : TodoItem => <Todo todo={todo}/>)

    todoItems =
      items
      |> Array.reject(\todo : TodoItem => todo.done)

    todos =
      if (Array.isEmpty(todoItems)) {
        [
          <div::empty>
            <div>
              <{ "All done!" }>
            </div>

            <{ empty }>
          </div>
        ]
      } else {
        Array.map(\todo : TodoItem => <Todo todo={todo}/>, todoItems)
      }
  }
}
