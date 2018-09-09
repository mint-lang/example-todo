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

  fun handleRemove (event : Html.Event) : Promise(Never, Void) {
    remove(todo)
  }

  fun handleToggle (event : Html.Event) : Promise(Never, Void) {
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
