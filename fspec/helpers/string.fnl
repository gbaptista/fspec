(local helper/list (require :fspec.helpers.list))

(local helper {})

(fn helper.split [delimiter content]
  (local fields [])
  (let [pattern (string.format "([^%s]+)" delimiter)]
    (string.gsub content pattern #(table.insert fields $1))
  fields))

helper
