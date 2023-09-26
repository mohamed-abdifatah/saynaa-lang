<p align="center">
<img src="assets/icon.png" height="90px" alt="Saynaa Programming Language" title="Saynaa Programming Language">
</p>

**Saynaa** is a interpreted object-oriented, powerful, lightweight, embeddable scripting language written in C,
Its Simple Syntax, and standalone executable with zero external dependencies.

> Comments in the C code make it easy to read and understand.

## What Saynaa code looks like

```ruby
  function foo(n)
    if n < 2 then return n end
    return foo(n-1) + foo(n-2)
  end
  
  for i in 0..10
    print("foo($i) = ${foo(i)}")
  end
```

## Features

- No setup. Single binary and your're good to go.
- REPL
- Object oriented
- Dynamic typing
- Classes and inheritance
- Concurrency
- Garbage collection
- Operator overloading
- First class functions
- Lexical scoping
- Embeddable
- Direct interop with C
- Highly optimized loops
- Tail call optimization
