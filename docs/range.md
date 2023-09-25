### Range

A range is an object that represents a consecutive range of numbers.
```ruby
  # a represents a range with values 1,2
  a = 1..3

  # b represents a range with values 1,2, 3
  b = Range(1, 3+1)

  # Ranges have also a conveniente count property
  n1 = a.length;  # n1 is now 2
  n2 = b.length;  # n2 is now 3
```

A range is expecially useful in for loops:
```ruby
  for i in 0..10
    # repeat for 10 times (with i from 0 to 9)
  end
```
