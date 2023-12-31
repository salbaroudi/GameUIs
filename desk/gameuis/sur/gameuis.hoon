|%
+$  action
  $%  [%push target=@p value=@]
      [%pop target=@p]
      [%teststate target=@p]
      [%clearstate target=@p]
  ==
+$  update
  $%  [%init values=(list @)]
  ==
+$  page  [sect=@t success=?]
::Rudimentary board structures...
+$  bdim  [rows=@ud cols=@ud]
:: Just map 1=red, 2=green 3=blue for now...
+$  player  [name=@p pnum=@ud spectrum=@ud]
+$  playerinfo  (map @ud player)
+$  playerorder  (map @p @ud)
::For now just branch on @uds, I had issues with type unions...
+$  boardenv  (list @ud)
+$  boardpieces  (list @ud)
--