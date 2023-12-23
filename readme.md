## GameUIs:

This project folder serves as a proposal/demo for terminal and browser board game displays (as needed for the upcoming App School 24' cohort).

### Requirements:

There are two support tools that are required.  Both assume that students will be developing board game Gall apps.

#### Board Game Renderer (in Terminal):

The board game terminal renderer `(boardprint <app/desk name> )` must...

- scry the state of a student's boardgame.
- be written as a generator, and should be stored in the /gen folder.
- Will have two fixed sections to display information:
    - 1) A general (text field) information section,
    - 2) A section that prints out the state of the board.
- Assumes the following for *any and all* boards it will encounter:
    - Board has a specific **Width** and **Height**. It has a rectangular shape, with no gaps.
    - A board is made up of squares.
    - There are N number of players.
    - There are M kinds of pieces (or objects).
    - There is a mapping of pieces to players
    - Only one object can exist in any square (no clobbering or stacking).



#### Renderer (in Browser):

