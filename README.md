# fspec

A wrapper that tweaks [LuaUnit](https://luaunit.readthedocs.io) for a more pleasant test writing experience with [Fennel](https://fennel-lang.org/).

![fspec results example](https://raw.githubusercontent.com/gbaptista/assets/main/fspec/readme.png)

- [Installing](#installing)
- [Usage](#usage)
  - [Run All](#run-all)
- [Verbose Stack Trace](#verbose-stack-trace)
- [Assertions](#assertions)
- [LuaUnit vs fspec](#luaunit-vs-fspec)

## Installing

To install through [fnx](https://github.com/gbaptista/fnx), add to your `.fnx.fnl`:

```fnl
:fspec {:fennel/fnx {:git/github "gbaptista/fspec"}}

; Example:

{:name    "my-project"
 :version "0.0.1"

 :dependencies
   :fspec {:fennel/fnx {:git/github "gbaptista/fspec"}}}
```

And install:
```
fnx dep install
```

## Usage

Create a `some_test.fnl` file:

```fennel
(local t (require :fspec))

(t.eq "actual" "expected")

(t.is-number "1.2")

(t.run!)
```

Run with:

```sh
fnx some_test.fnl
```

### Run All

To run all `_test.fnl` tests, create a `test.fnl` file with:

```fennel
(local t (require :fspec))

(t.run-all! "./")
```

And run:
```sh
fnx test.fnl
```

To use a different pattern, like `_spec`, use:
```fennel
(t.run-all! "./" "_spec")
```

## Verbose Stack Trace

To get a complete stack trace, use the `--verbose` option:
```sh
fnx test.fnl --verbose
```

## Assertions

Check the [dsl.fnl](https://github.com/gbaptista/fspec/blob/main/fspec/logic/dsl.fnl) file for a list of all assertions available.

## LuaUnit vs fspec

With **LuaUnit** you would write a test in Fennel like this:

```fennel
(local luaunit (require :luaunit))

(fn testSomething []
  (luaunit.assertEquals
    {:title "actual" :value 17.89 }
    
    {:title "expected" :value 12.0
     :items [
       "a" "b" "c" "d" "e"
       "f" "g" "h" "i" "j"]}))

(os.exit (luaunit.LuaUnit.run))
```
Which would result in:
![LuaUnit results example](https://raw.githubusercontent.com/gbaptista/assets/main/fspec/readme-luaunit.png)


With **fspec** you would write the same test as:

```fennel
(local t (require :fspec))

(t.eq
  {:title "actual" :value 17.89 }
  
  {:title "expected" :value 12.0
   :items [
     "a" "b" "c" "d" "e"
     "f" "g" "h" "i" "j"]})

(t.run!)
```

Which would result in:

![fspec results example](https://raw.githubusercontent.com/gbaptista/assets/main/fspec/readme.png)
