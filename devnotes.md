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


-  Need to review cords and text processing...
- many of the text manipulation functions are done with tapes.
- to convert a tape to a cord and back...
    - use crip (cord rip) to confirt from a tape to a cord (crip "hello")
    - use trip (tape rip) to convert from a cord to a tape (trip 'hello')
- use scot to cast atoms to a knot or cord, (for scrys and addressing)
    Note: ~.<whatever> is how knots are exprssed in Dojo. This is not a floating point.

- Some Useful List functions (use on tapes):
++ flop (flop a): reverse a list
++ into  (into <list> <index> <noun>): Insert noun into list at index 
++ lent (lent <list>) return list length
++ rear (rear <list>) return last item of list
++ scag (scag n <list>) return the first n items of the list
++ slag (slag n <list>) '' last n items
++ snoc (snoc <list> <noun>) append noun to end of list
++ weld (weld <list> <list>) append two lists together.

- Notes on Structures and Lists (because I always forget!):
- The following does not work in Dojo
```
=row  [@t @t @t]
=board  [row row row]
=myboard `board`[['a' 'a' 'a'] ['a' 'a' 'a'] ['a' 'a' 'a']]
```

Because it tries to use the mold (board) as a gate, and there is no $ arm.  To get it to work, we need the 
structure mode comma, and to pin faces to the cells:

```
=row  [@t @t @t]
=board  ,[r1=row r2=row r3=row]
=myboard `board`[['a' 'a' 'a'] ['a' 'a' 'a'] ['a' 'a' 'a']]
```
Note that if we don't pin faces, we end up with dangling inner cells, so something like [[1 2 3] 4 5 ....]. Hoon doesn't
apply the structure correctly, for some reason.

- On Equals notation.
    - when you see a=<expr>, it is sugar for two possible runes:
    - Structure Mode: buctis ($= face mold)
    - Value Mode:  kettis ($= face value)
    - and it will desugar, depending on the parsing mode you are in.
    - you can force structure mode (in ambiguous situations) with a comma, if you need to.
        - this is done when we use cell notation for a structure so ,[m1 m2 m3...], like with a tisfas definition.

- Notes on Lists:
    - the keyword list is actually a gate. A mold making gate.
    - so (list @ud) feeds @ud into the gate as one input.

### December 24th:

- for the mock up of the board printing, we start with a tic-tac-toe board. The following structures are proposed:
    +$  row  [@t @t @t]
    +$  board  (lest row) ::[r1=row r2=row r3=row]

- we can cast as follows: ``board`~[['a' 'b' 'c'] ['d' 'e' 'f'] ['g' 'h' 'i']]`
    - lest saves the day from our find-fork errors...






