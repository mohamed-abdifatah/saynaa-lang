# path Module
path is a builtin Module.

```ruby
import path
```

### getcwd
Returns the current working directory.

```ruby
path.getcwd() -> String
```

### abspath
Returns the absolute path of the [path].

```ruby
path.abspath(path:String) -> String
```

### relpath
Returns the relative path of the [path] argument from the [from] directory.

```ruby
path.relpath(path:String, from:String) -> String
```

### join
Joins path with path seperator and return it. The maximum count of paths which can be joined for a call is MAX_JOIN_PATHS.

```ruby
path.join(...) -> String
```

### normpath
Returns the normalized path of the [path].

```ruby
path.normpath(path:String) -> String
```

### basename
Returns the final component for the path

```ruby
path.basename(path:String) -> String
```

### dirname
Returns the directory of the path.

```ruby
path.dirname(path:String) -> String
```

### isabspath
Returns true if the path is absolute otherwise false.

```ruby
path.isabspath(path:String) -> Bool
```

### getext
Returns the file extension of the path.

```ruby
path.getext(path:String) -> String
```

### exists
Returns true if the file exists.

```ruby
path.exists(path:String) -> String
```

### isfile
Returns true if the path is a file.

```ruby
path.isfile(path:String) -> Bool
```

### isdir
Returns true if the path is a directory.

```ruby
path.isdir(path:String) -> Bool
```

### listdir
Returns all the entries in the directory at the [path].

```ruby
path.listdir(path:String='.') -> List
```
