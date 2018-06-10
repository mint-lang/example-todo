record TodoItem {
  name : String,
  done : Bool,
  id : Number
}

store Todos {
  property items : Array(TodoItem) = [
    {
      name = "Showcase Mint!",
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
