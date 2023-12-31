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

### Dec 25th and Dec 26th:

- Read the overview of sail. The %squad app has the simplest implementation of squad. Will investigate how it works
by tinkering with the app.

- it just seems to have a /squad/index.hoon page for the front end, and a docket-0 file for Landscape.
    - localhost:8080/squad


- Basic Idea:  .hoon file -> en-xml: converted via $manx -> Eyre, converts to HTML octets and sent to FE.
- How is the page served?
- what about the %squad app, how does it initiate the page serve for the FE?
    - done on ++on-watch arm??

Layout of the Code:

**Our index is structured as follows: **

|=  [bol=bowl:gall =squads =acls =members =page]
($)  |^  ^-  octs
::In rev order:  Convert to octets for HTML packet. Convert to a cord. Convert to a manx tape. Input: Raw Sail Markup.
        ($)  as-octs:mimes:html  %-  crip  %-  en-xml:html  manx  <our sail>

;html
  ;head
    ...
  ==
  ;body
    ...
  ==
==

- With the above modular structure fed into the first gate in the chain, like we would expect.
- Below the modular structure, is a series of ++ (luslus) arms, which flesh out the modular strucure
before it is sent off to the FE.

**But how is it served? Enter squad.hoon:

- Our index.hoon file is imported with a library rune:

/=  index  /app/squad/index


- On init:  Bind to localhost/squad URL using an ARVO call.

- unlike what i suspected, there isn't any http serving in the ++on-watch or ++on-agent arm...
- its all done in a sub-arm of the ++on-poke arm (!)
- and its quite complicated :S

- start-up:
    - init for the app binds our app to the */squad URL (doing an Arvo call)
    - when we navigate to /localhost/squad, a GET request for the squad page is made.
    - we go through the ++on-poke control flow, and end up at:

```
   |=  [rid=@ta req=inbound-request:eyre]
    ^-  (quip card _state)

    ::There is a large amount of code to check if we have a non-recognizable reuqest,
    :: or if we have access restriction. Assuming this passes, we move onto the GET request:

     ?+  method.request.req

        .

        %'GET'
      :: alter our state, with a modified page
      :: *^  is NOT a rune. What does it do, exactly?

      :_  state(page *^page)
      :: make=-200 is a gate call with two args pinned to sample. the RID and then our page data
      ::(index ...) is our page that can also be run and called (its just one big gate with lots of nested cores)
      ::recalla the input to index gate is [bol=bowl:gall =squads =acls =members =page]
      ::so we just regenerate our page XML to octs, using our app state, really.
      (make-200 rid (index bol squads acls members page))

    ::make-200 is just an arm with a gate:
      ++  make-200
    |=  [rid=@ta dat=octs]
    ^-  (list card)
    %^    give-http
        rid
      :-  200
      :~  ['Content-Type' 'text/html']
          ['Content-Length' (crip ((d-co:co 1) p.dat))]
      ==
    [~ dat]
```

- what is page?  It is a structure as follows (in sur):

```
:: this just keeps track of the target page and section
:: for the front-end, so we can use a post/redirect/get
:: pattern while remembering where to focus
::
+$  page  [sect=@t gid=(unit gid) success=?]
```

So a basic example on how Sail is served up has been reviewed. Really, we need a simple sail page that mimics our
tui: It has a header with infomration, and a footer with a generated board. That is the goal we are aiming for...

- Next steps:  Get a simple sail page served up in %gameuis - copy the index.hoon coding structure.

## December 27th:

With a basic understanding and a Sail template in hand, its time to implement an fe-board.hoon file, and serve up a page using our ++on-poke arm.

Steps to set up the project: 

1)- Template for the %echo app was copied. So mar, sur and app files were copied over, and names modified (echo -> gameuis)
- all docket support files were present already in /sup/gameuis (follow steps in https://developers.urbit.org/guides/quickstart/groups-guide#dependencies)
- at this point, Gall App is commited and booted. Change all the names as required, if any are missed.
- Quick note: fe-board.hoon is empty, Gall just ignores this fact. cool.

2)

- From squad, add the URL binding code (for Arvo) is placed in ++on-init
- very basic template for fe-board.hoon is created. Just a single <p>. index.hoon is significantly stripped down.
- in squad, state and this are custom defined (state is our 'this' that we would see in %delta and %echo). Needed to go around and change everything.
- alter the index.hoon: Cut out all the squad acl gid stuff. Also cut out all the support arms (because they all reference gids) 
- Rename bol -> bowl (no custom alias)
- finally, this all worked but we got an internal server error when loading localhost:8080/gameuis. Error lives in the on watch arm, so this needs to be copied over from squad
    => Need to investigate running squad app to figure this out. On watch doesn't appear to have any useful code (??)
- Peppering squad wiht ~&'s, we get the following order after installation (on-init bound has already occured) (and page refresh:)
1) On watch (so our FE Eyre made an initial subscription)
    specifically for on-watch, we get a non-ship HTTP request, and apparently do nothing. So what are we missing??
2) On Poke -> %Get request made

We do not see on-arvo called (this would only be seen once, after on-init has registered our URL with Arvo, as a respose).



### Dec 30th:

Fell into a subtle trap. Consider:

'''
+$  row  [c1=@t c2=@t c3=@t]
+$  board  (lest row) ::[r1=row r2=row r3=row]

|=  c=@ud
=/  tttboard  ^-  board  ~[[c1='X' c2='_' c3='_'] [c1='X' c2='_' c3='O'] [c1='X' c2='_' c3='0']]
|-
    ?~  tttboard  (add 1 2)
        ~&  i.tttboard
        %=  $  tttboard  t.tttboard  ==
'''

You get an endless mint-vain error, because::  your board is a lest (non-empty list) by definition.
    => Thus, the compiler thinks it will never get to the null case of ?~.









