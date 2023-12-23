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