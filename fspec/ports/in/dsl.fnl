(local fork/luaunit (require :fspec.forks.luaunit))
(local patch/luaunit (require :fspec.patches.luaunit))

(local logic/dsl (require :fspec.logic.dsl))
(local controller/dsl (require :fspec.controllers.dsl))

(patch/luaunit.apply! fork/luaunit)

(local port {})

(fn port.handle! [method]
  (if (. logic/dsl.luaunit-aliases method)
    (port.handle-luaunit! method)
    (match method
      :run!     controller/dsl.run!
      :run-all! controller/dsl.run-all!)))

(fn port.handle-luaunit! [method]
  (let [alias-for (. logic/dsl.luaunit-aliases method)]
    #(controller/dsl.exec-luaunit!
       method alias-for (. fork/luaunit alias-for) [$...])))

(setmetatable port {:__index #(port.handle! $2)})

port
