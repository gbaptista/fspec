(local fennel (require :fennel))

(local logic/presenter (require :fspec.logic.presenter))

(local patch {})

(fn patch.apply! [luaunit]
  (tset luaunit :prettystr patch.data->string))

(fn patch.data->string [value]
  (.. logic/presenter.clue (fennel.view value) logic/presenter.clue))

; TODO
; prettystr prettystr_sub prettystrPairs
; (tset debug :traceback fennel.traceback)

patch
