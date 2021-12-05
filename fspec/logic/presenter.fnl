(local sn (require :supernova))

(local helper/list (require :fspec.helpers.list))
(local helper/string (require :fspec.helpers.string))

(local logic { :clue "@#@" :clue-pattern "@#@"})

(fn logic.error [raw verbose ?target]
  (let [parts (helper/string.split logic.clue-pattern raw)]
    (if (. parts 4)
      (do
        (tset parts 2 (sn.blue (. parts 2)))
        (tset parts 4 (sn.red (. parts 4))))
      (if (. parts 2)
        (do (tset parts 2 (sn.red (. parts 2))))))

    (local result (helper/list.join "" parts))

    (if (string.match result "stack traceback:")
       (logic.traceback result verbose ?target)
       result)))

(fn logic.traceback [raw verbose ?target]
  (let [parts (helper/string.split "\n" raw)]
    (var traceback? false)
    (var some-fnl? false)
    (each [i line (pairs parts)]
      (if (and traceback?
               (string.match line "%.fnl")
               (not (string.match line "fspec/")))
        (do
          (set some-fnl? true)
          (tset parts i (sn.yellow line)))
        (if (and traceback? ?target (not verbose))
          (tset parts i "")))
      (when (string.match line "stack traceback%:")
        (set traceback? true)))

    (when (and (not some-fnl?) ?target)
      (table.insert parts (.. "  " (sn.yellow ?target))))

    (->>
      parts
      (helper/list.filter #(not= $1 ""))
      (helper/list.join "\n"))))

logic
