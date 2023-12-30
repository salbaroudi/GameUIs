## GameUIs:

### Introduction:

This project folder serves as a proposal for terminal and browser board game displays (as needed for the upcoming App School 24' cohort).

### Requirements:

There are two support tools that are required: A terminal printer, and a web based front-end.  Both assume that students will be developing board game Gall apps.  Likewise, our terminal printing library and front end must scry the state of the student's apps, and print them out accordingly.

### General Assumptions (Shared by both tools):

Each tool must:

- scry the state of a student's boardgame.
- Will have two fixed sections to display information:
    - 1) A general (text field) information section,
        - Example: Displays player names, game name, non-board game information.
    - 2) A section that displays out the state of the board.
- Assumes the following for *any and all* boards it will encounter:
    - Board has a specific **Width** and **Height**. It has a rectangular shape, with no gaps.
    - A board is made up of squares.
    - There are N number of players.
    - There are M kinds of pieces (or objects).
    - There is a mapping of pieces to players.
    - There is a mapping of pieces to board positions.
    - Only one object can exist in any square (no clobbering or stacking).

Likewise, the printouts of both tools will mirror one another (for familiarity). This will also allow for some shared code (such as, with the scrying functionality and state mutation).

In order to implement both tools, the overall codebase must be implemented as a library -  a core with many arms, that is imported by a student's Gall App.  The app should appropriately be named "twui".


#### Board Game Renderer (in Terminal) "t-ui":

The board game terminal renderer will accessed via a gate call `(boardprint [parameter struct] )`.  

Practically, it will exist as a main gate call with a series of support arms.

Various parameters can be specified, or default values are used if a default structure is provided as input.

#### Renderer (in Web Browser) "w-ui":

The core of this is based on the minimum implementation of the Squad App - in which we handle page serving (via Get Request) using the ++on-poke arm, and bind a basic url to our app (using a direct Arvo call). 

Essentially, students will navigate to the bound url via Landscape (example: http:localhost:8080/wui, running out of a fakezod), and simply refresh the page.  This will result in a GET request handled by the ++on-poke arm, which will run a Sail page (which generates our board as a $manx XML structure), which is tranformed into HTML that is sent back to the browser.