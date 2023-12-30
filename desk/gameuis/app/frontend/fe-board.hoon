:: first we import our /sur/squad.hoon type definitions and expose them directly
::
/-  *gameuis
:: our front-end takes in the bowl from our agent and also our agent's state
::
|=  [bol=bowl:gall =page]
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
:: here begins the construction of our HTML structure. We use Sail, a domain-specific language built
:: into the hoon compiler for this purpose
::
;html
  ;head
    ;title: squad
    ;meta(charset "utf-8");
    ;link(href "https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Source+Code+Pro:wght@400;600&display=swap", rel "stylesheet");
    ;style
      ;+  ;/  style
    ==
  ==
  ;body
    ;h1: Our sample page!
    ;p 
        ;  Some Content in our p tag
        ;br;
        ;br;
        ;  Some more content, testing...
    ==  ::needed as we have a list of tags
  == ::body
== ::html
++  style
  ^~
  %-  trip
    '''
    body {
      display: flex;
      width: 100%;
      height: 100%;
      justify-content: center;
      align-items: center;
      font-family: "Inter", sans-serif;
      margin: 0;
      -webkit-font-smoothing: antialiased;
    }
    main {
      width: 100%;
      max-width: 500px;
      border: 1px solid #ccc;
      border-radius: 5px;
      padding: 1rem;
    }
    button {
      -webkit-appearance: none;
      border: none;
      outline: none;
      border-radius: 100px;
      font-weight: 500;
      font-size: 1rem;
      padding: 12px 24px;
      cursor: pointer;
    }
    button:hover {
      opacity: 0.8;
    }
    button.inactive {
      background-color: #F4F3F1;
      color: #626160;
    }
    button.active {
      background-color: #000000;
      color: white;
    }
    a {
      text-decoration: none;
      font-weight: 600;
      color: rgb(0,177,113);
    }
    a:hover {
      opacity: 0.8;
    }
    .none {
      display: none;
    }
    .block {
      display: block;
    }
    code, .code {
      font-family: "Source Code Pro", monospace;
    }
    .bg-green {
      background-color: #12AE22;
    }
    .bg-green-400 {
      background-color: #4eae75;
    }
    .bg-red {
      background-color: #ff4136;
    }
    .text-white {
      color: #fff;
    }
    h3 {
      font-weight: 600;
      font-size: 1rem;
      color: #626160;
    }
    form {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    form button, button[type="submit"] {
      border-radius: 10px;
    }
    input {
      border: 1px solid #ccc;
      border-radius: 6px;
      padding: 12px;
      font-size: 12px;
      font-weight: 600;
    }
    .flex {
      display: flex;
    }
    .col {
      flex-direction: column;
    }
    .align-center {
      align-items: center;
    }
    .justify-between {
      justify-content: space-between;
    }
    .grow {
      flex-grow: 1;
    }
    .inline {
      display: inline;
    }
    @media screen and (max-width: 480px) {
      main {
        padding: 1rem;
      }
    }
    '''
--
 
