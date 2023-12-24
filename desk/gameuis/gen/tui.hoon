|=  [a=@ud b=@ud]  
    ^-  @ud
    |^
    (printboard (printheader a b))
    +$  row  [c1=@t c2=@t c3=@t]
    +$  board  (lest row) ::[r1=row r2=row r3=row]
    ++  printheader
        |=  [a=@ud b=@ud]
            =/  gamename  "Tic Tac Toe"
            =/  username  "~sample-palnet"
            =/  numplayers  "2"
            =/  currplayer  "~nec"
            ~&  '---------------------------------------'
            ~&  (weld "|" (weld " Game Name: " (weld gamename " |")))
            ~&  (weld "|" (weld " User Name: " (weld username " |")))
            ~&  (weld "|" (weld " # of Players: " (weld numplayers " |")))
            ~&  (weld "|" (weld " Current Players: " (weld currplayer " |")))
            ~&  '---------------------------------------'
            (add a b)
    ++  printboard
        |=  c=@ud
            =/  tttboard  ^-  board  ~[['X' '_' 'O'] ['X' '_' '_'] ['X' '_' 'O']]
            ~&  tttboard
            =/  cellholder  i.tttboard
            =/  tttboard  t.tttboard
            |-  
                ~&  (weld "| " (weld c1.cellholder (weld c2.cellholder c3.cellholder)))
                ?~  tttboard  0
                    %=  $  cellholder  i.tttboard  tttboard  t.tttboard  ==
            ::~&  '---------------------------------------'
            ::(mul c c)
    --