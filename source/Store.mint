type TodoItem {
  name : String,
  done : Bool,
  id : Number
}

store Todos {
  state items : Array(TodoItem) =
    [
      { name: "Showcase Mint!", done: true, id: 0 },
      { name: "Try Mint!", done: false, id: 1 }
    ]

  fun add (name : String) : Promise(Void) {
    let nextId =
      if Array.isEmpty(items) {
        0
      } else {
        items
        |> Array.map((todo : TodoItem) : Number { todo.id })
        |> Array.max()
        |> Maybe.withDefault(0)
      }

    let item =
      { id: nextId + 1, done: false, name: name }

    await next { items: Array.push(items, item) }
    save()
  }

  fun remove (item : TodoItem) : Promise(Void) {
    let updatedItems =
      Array.reject(items, (todo : TodoItem) : Bool { todo == item })

    await next { items: updatedItems }
    save()
  }

  fun toggle (item : TodoItem) : Promise(Void) {
    let updatedItems =
      Array.map(items,
        (todo : TodoItem) : TodoItem {
          if todo.id == item.id {
            { item | done: !item.done }
          } else {
            todo
          }
        })

    await next { items: updatedItems }
    save()
  }

  fun load : Promise(Void) {
    if let Ok(json) = Storage.Local.get("items") {
      if let Ok(object) = Json.parse(json) {
        if let Ok(items) = decode object as Array(TodoItem) {
          next { items: items }
        }
      }
    }
  }

  fun save : Promise(Void) {
    let object =
      encode items

    let json =
      Json.stringify(object)

    Storage.Local.set("items", json)
    await void
  }
}
