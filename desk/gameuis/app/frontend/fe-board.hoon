:: first we import our /sur/squad.hoon type definitions and expose them directly
::
/-  *gameuis
:: our front-end takes in the bowl from our agent and also our agent's state
::
|=  [bol=bowl:gall =page gameboard=board playmap=playerinfo]
:: 5. we return an $octs, which is the encoded body of the HTTP response and its byte-length
::
|^  ^-  octs
:: 4. we convert the cord (atom string) to an octs
::
%-  as-octs:mimes:html
:: 3. we convert the tape (character list string) to a cord (atom string) for the octs conversion
::
%-  crip
:: 2. the XML data structure is serialized into a tape (character list string)
::
%-  en-xml:html
:: 1. we return a $manx, which is urbit's datatype to represent an XML structure
::
^-  manx
::Our actual rendering and XML generation starts, below...
~&  'gameboard struct:'  ~&  gameboard
~&  'player struct:'  ~&  playmap
=/  nums=(list @ud)  (gulf 1 9)
:: here begins the construction of our HTML structure. We use Sail, a domain-specific language built
:: into the hoon compiler for this purpose
::
;html
  ;head
    ;title: gameui
    ;meta(charset "utf-8");
    ;style
      ;+  ;/  style
    ==
  ==
  ;body
    ;h1: Our Sample Tic-Tac-Toe Board:
    ;h2: This page uses the ~nodsup-halnux default color scheme.
    ;h3:  
    ;br;
    ;br;
    ;div.board
      ;*  %+  turn  gameboard
          |=  gbr=boardrow
              ?~  gbr  !!
                ?:  =(-.i.gbr %black)
                  ;div.blacksquare: {<+.i.gbr>}                
                  ;div.whitesquare: {<+.i.gbr>}
                    
    == ::div.board
  == ::body
== ::html
++  style
  ^~
  %-  trip
    ::Board CSS generated by chatGPT 3.5.
    '''
    body {background-color:black; color: orange;}
    h1 {font-size: 36pt; text-align: center;}
    h2 {font-size: 24pt; text-align: center;}
    div {font-size: 16pt;}

    .board {
      display: grid;
      grid-template-columns: repeat(3, 500px);
      grid-template-rows: repeat(3, 250px);
      gap: 5px;
    }

    .square {
      width: 250px;
      height: 250px;
      background-color: orange;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 48px;
      font-weight: bold;
      color: black;
      cursor: pointer;
    }

    .blacksquare {
      width: 500px;
      height: 250px;
      background-color: black;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 48px;
      font-weight: bold;
      color: white;
      cursor: pointer;
    }

    .whitesquare {
      width: 500px;
      height: 250px;
      background-color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 48px;
      font-weight: bold;
      color: black;
      cursor: pointer;
    }


    '''
--
 
