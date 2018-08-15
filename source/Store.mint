record TodoItem {
  name : String,
  done : Bool,
  id : Number
}

store Todos {
  state items : Array(TodoItem) = [
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
    do {
      next { items = Array.push(item, items) }
      save()
    }
  } where {
    nextId =
      if (Array.isEmpty(items)) {
        0
      } else {
        items
        |> Array.map((todo : TodoItem) : Number => { todo.id })
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
    do {
      next { items = updatedItems }
      save()
    }
  } where {
    updatedItems =
      items
      |> Array.reject((todo : TodoItem) : Bool => { todo == item })
  }

  fun toggle (item : TodoItem) : Void {
    do {
      next { items = updatedItems }
      save()
    }
  } where {
    updatedItems =
      items
      |> Array.map(
        (todo : TodoItem) : TodoItem => {
          if (todo.id == item.id) {
            { item | done = !item.done }
          } else {
            todo
          }
        })
  }

  fun load : Void {
    try {
      value =
        Storage.Local.get("items")

      object =
        Json.parse(value)
        |> Maybe.toResult("")

      items =
        decode object as Array(TodoItem)

      next { items = items }
    } catch Storage.Error => error {
      void
    } catch String => error {
      void
    } catch Object.Error => error {
      void
    }
  }

  fun save : Void {
    do {
      object =
        encode items

      json =
        Json.stringify(object)

      Storage.Local.set("items", json)
    } catch Storage.Error => error {
      void
    }
  }
}
