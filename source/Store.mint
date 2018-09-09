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

  fun add (name : String) : Promise(Never, Void) {
    sequence {
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

  fun remove (item : TodoItem) : Promise(Never, Void) {
    sequence {
      next { items = updatedItems }
      save()
    }
  } where {
    updatedItems =
      items
      |> Array.reject((todo : TodoItem) : Bool => { todo == item })
  }

  fun toggle (item : TodoItem) : Promise(Never, Void) {
    sequence {
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

  fun load : Promise(Never, Void) {
    try {
      value =
        Storage.Local.get("items")

      object =
        Json.parse(value)
        |> Maybe.toResult("")

      decodedItems =
        decode object as Array(TodoItem)

      next { items = decodedItems }
    } catch {
      Promise.never()
    }
  }

  fun save : Promise(Never, Void) {
    sequence {
      object =
        encode items

      json =
        Json.stringify(object)

      Storage.Local.set("items", json)

      Promise.never()
    } catch Storage.Error => error {
      Promise.never()
    }
  }
}
