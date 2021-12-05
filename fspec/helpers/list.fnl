(local helper {})

(fn helper.join [?glue list]
  (var result "")
  (let [glue (if (= ?glue nil) " " ?glue)]
    (each [index value (pairs list)]
      (if (> index 1)
        (set result (.. result glue value))
        (set result (.. result value)))))
  result)

(fn helper.reduce-iterator [f iterator ?acc]
  (let [
    acc (if (= ?acc nil) 0 ?acc)
    head (iterator)]
      (if (= head nil)
        acc
        (helper.reduce-iterator
          f iterator
          (f acc head)))))

(fn helper.filter [f list]
  (local result [])
  (each [_ item (pairs list)]
    (when (f item) (table.insert result item)))
  result)

helper
