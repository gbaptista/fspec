(local sn (require :supernova))

(local logic/presenter (require :fspec.logic.presenter))

(local lfs (require :lfs))

(local fennel (require :fennel))

(local controller {:__queue {:successes [] :failures [] :files 0 :last nil}})

(fn controller.handle-result [result verbose target]
  (if result.success?
    (do
      (io.write (sn.green "."))
      (tset controller.__queue :last :success)
      (table.insert controller.__queue.successes (or result.output "")))
    (do
      (io.write (sn.red "F"))
      (tset controller.__queue :last :failure)
      (table.insert controller.__queue.failures  (or result.output ""))
      (print (.. "\n" (logic/presenter.error result.output verbose target) "\n")))))

(fn controller.exec-luaunit! [method target f parameters]
  (local (success? output) (xpcall f fennel.traceback (table.unpack parameters)))

  (var verbose false)

  (each [_ value (pairs arg)]
    (when (= value :--verbose) (set verbose true)))

  (let [result {:success? success? :output output}
        target
          (if (= (os.getenv :FSPEC_RUNNER) "true")
            (os.getenv :FSPEC_TARGET)
            (. arg 0))]
    (controller.handle-result result verbose target)))

(fn controller.pluralize [raw count]
  (if (= count 1) raw (.. raw "s")))

(fn controller.print-summary []
  (print ""))

(fn controller.run-all! [base-path ?pattern recursive?]
  (let [pattern (or ?pattern "_test")]
    (each [candidate-path (lfs.dir base-path)]
      (let [kind (. (lfs.attributes (.. base-path candidate-path)) :mode)]
        (if (and (= kind :directory) (not= candidate-path "..") (not= candidate-path "."))
          (controller.run-all! (.. base-path candidate-path "/") pattern true)
          (string.find candidate-path pattern)
          (controller.run-file! (.. base-path candidate-path)))))
    (when (not recursive?)
      (controller.print-summary))))

(fn controller.run! []
  (when (and
          (not= (os.getenv :FSPEC_RUNNER) "true")
          (= controller.__queue.last :success))
    (print "")))

(fn controller.run-file! [path]
  (var verbose false)
  (each [_ value (pairs arg)]
    (when (= value :--verbose) (set verbose true)))

  (tset controller.__queue :files (+ controller.__queue.files 1))

  (if verbose
    (os.execute (.. "FSPEC_RUNNER=true FSPEC_TARGET=" path " fnx " path " --verbose"))
    (os.execute (.. "FSPEC_RUNNER=true FSPEC_TARGET=" path " fnx " path))))

controller
