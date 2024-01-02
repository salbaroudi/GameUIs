## GameUIs:

### Introduction:

This project folder serves as a proposal for terminal and browser board-game displays (as needed for the upcoming App School 24' cohort).

### Requirements:

There are two support tools that are required: A terminal printer, and a web based front-end.  Both assume that students will be developing board game Gall apps.  Likewise, our terminal printing library and front end must scry the state of the student's apps. Students should not have to pass long argument lists to our tools, to see the state of their apps.

### General Assumptions (Shared by both tools):

Each tool must:

- Scry the state of a student's board-game.
- Will have two fixed sections to display information:
    - 1) A Header Section, that displays general game information.
        - *Example:* Displays player names, game name, other board-game information.
    - 2) A Board Section that visualizes the current state of a game.

Structural Assumptions (for Generic Board Game Representation in Hoon)
- Assumes the following for *any and all* boards it will encounter:
    - Board has a specific **Width** and **Height**. It has a rectangular shape, with no gaps.
    - A board is made up of squares.
    - There are K types of squares.
    - There are N number of players.
    - There are M kinds of game pieces (or objects).
    - There is some kind of mapping of pieces to players.
    - There is some kind of mapping of pieces to board positions.

A simple /sur structure file for such requirements, is proposed below:

```
+$  bdim  [rows=@ud cols=@ud]
+$  player  [name=@p pnum=@ud spectrum=@ud]
+$  playerinfo  (map @ud player)
+$  playerorder  (map @p @ud)
+$  boardenv  (list @ud)
+$  boardpieces  (list @ud)
```

Likewise, the printouts of both tools will mirror one another (for familiarity). This will also allow for some shared code (such as, with the scrying functionality and data filtering).

In order to implement both tools, the overall codebase must be implemented as a library - that will be imported by a student's Gall App. 

Appropriately, I name the library **"TWUI" or "Terminal & Web User Interface"**.

#### Board Game Renderer (in Terminal) "t-ui":

The board game terminal renderer will accessed via a gate call `(boardprint ... )`.

Practically, it will exist as a main gate call with a series of support arms.

Various parameters can be specified, or default values are used if a default structure is provided as input.  No board inputs are given in the game call, as our scry functionality should handle this automatically.

See the `/desk/gameuis/gen/tui.hoon` file for a basic sample.

#### Renderer (in Web Browser) "w-ui":

The core of this is based on the minimum implementation of the Squad App - in which we handle page serving (via Get Request) using the ++on-poke arm, and bind a basic url to our app using an Arvo call:  `(~(arvo pass:agentio /bind) %e %connect /'gameuis %gameuis)`

Essentially, students will navigate to the bound url via Landscape (example: http:localhost:8080/wui, running out of a fakezod), and simply refresh the page.  This will result in a GET request handled by the ++on-poke arm, which will run a Sail page (which generates our board as a $manx XML structure), which is tranformed into HTML that is sent back to the browser.

See the `/frontend/fe-board.hoon` and `gameuis.hoon` files in `/desk/gameuis/app/` for a sample of this code.
