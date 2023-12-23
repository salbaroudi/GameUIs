## GameUIs Demo:

### December 23rd:

- setup project.  Just copy %base to my earth folder. Delete all files except tui.hoon.
- Will do the first prototype using a generator: tui.hoon in /gen
- Reminders about generators...
- Recall that to run gates as deferred computations in Dojo, we take one of two approaches:

1)  Paste the gate code and pin it to a face manually: `=genname  |= * ... <code...>`, and then call `(genname <args>)`

2) Make a generator file, place it in /gen, and just call it by using the file name.
    => Note, the default === and % file addressing notation assumes you are in the %base desk. If you have your own desk, 
    you will need to use clay's --build-file and use spatio-temporal addressing like so:

    ```=tui -build-file /=/gameuis/=/gen/tui/hoon```

Since a generator can only store a gate, to have more arms, we can use the |=  [input]  |^  pattern, templated like so:

```
|=  [a=s1 b=s2...]  
    ^-  <return type>
    |^        
    (startcall input)
    ++  startcall  
        |=  path=(list @ta)
            ...
    ++   othercall
        |=  path=(list @ta)
            ...
    --
```

- I seem to have an issue, passing more than one arg to a gate...Why?

```
|=  [a=@ud b=@ud c=@ud]  
(mul (add a b) c)
```

The above code *does* work. So that's not the issue.
```

- It turns out that this works now as well. Must have been a typo somewhere...?

```
|=  [a=@ud b=@ud]
    ^-  @ud
    |^
    (call1 (call2 a b))
    ++  call2  
        |=  [a=@ud b=@ud]
            (add a b)
    ++  call1
        |=  c=@ud
            (mul c c)
    --
```

Q:  If barket compiles the core, and runs the $ arm immediately...how does it not run on compilation?
    => A: Recall cores-in-arms: The outer core is compiled to battery payload, but the battery stores nock for compiling the inner core.
    => So only when we do the gate call, the inner core is compiled, and the buck arm is run immediately.




