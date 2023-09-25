## Loop

### While loop</h4>
A while loop performs a set of statements until a condition becomes false. These kind of loops are best used when the number of iterations is not known before the first iteration begins.
```ruby
  i = 0;

  while i < 50000 do
    i += 1;
  end
```

### For loop</h4>
You can access an element from a list by calling the subscript operator [] on it with the index of the element you want. As in most languages, indices start at zero:
```ruby
  count = 0;
  for i in 0..40
    count += i;
  end
```
The for in loop can be used over any object that supports iteration, such as [Lists](list.md), Strings or [Maps](map.md).

### Times method</h4>
Times look like
```ruby
  4.times(function() print("Hello World") end);
  # Output:
  # Hello World
  # Hello World
  # Hello World
  # Hello World
```

If we need to access the current index of the times we can just rewrite the closure:
```ruby
  target = 5;
  target.times(function(value) print("Hello World $value") end);

  # Output:
  # Hello World 0
  # Hello World 1
  # Hello World 2
  # Hello World 3
  # Hello World 4
```
