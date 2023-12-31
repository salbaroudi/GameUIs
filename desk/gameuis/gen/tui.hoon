|=  [a=@ud b=@ud]  
    ^-  @ud
    |^
        (printboard (printheader a b))
        +$  row  [c1=@t c2=@t c3=@t]
        +$  board  (list row) ::[r1=row r2=row r3=row]
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
            =/  tttboard  ^-  board  ~[[c1='X' c2='_' c3='_'] [c1='X' c2='_' c3='O'] [c1='X' c2='_' c3='0']]
            |-
                ?~  tttboard  ~&  '-----------END----------'  0
                    ~&  i.tttboard
                    %=  $  tttboard  t.tttboard  ==

    --
