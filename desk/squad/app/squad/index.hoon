:: first we import our /sur/squad.hoon type definitions and expose them directly
::
/-  *squad
:: our front-end takes in the bowl from our agent and also our agent's state
::
|=  [bol=bowl:gall =squads =acls =members =page]
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
    ;main
    :: Here we compose the overall body of the page, putting together the different
    :: components defined below
    ::
    ;+  ?.  =('generic' sect.page)
            ;/("")
          %+  success-component
            ?:(success.page "success" "failed")
          success.page
      ;h2: Join
      ;+  join-component
      ;h2: Create
      ;+  new-component
      ;+  ?~  squads
            ;/("")
          ;h2: Squads
      ;*  %+  turn
            %+  sort  ~(tap by squads)
            |=  [a=[* =title *] b=[* =title *]]
            (aor title.a title.b)
          squad-component
    ==
  ==
==
:: this little component just displays whether the previous request succeeded or failed
::
++  success-component
  |=  [txt=tape success=?]
  ^-  manx
  ;span(class ?:(success "success" "failure")): {txt}
:: this creates a form where you can enter the short-code of a squad and join it.
:: The form is POSTed to the /squad/join URL path and handled by the gall agent
::
++  join-component
  ^-  manx
  ;form(method "post", action "/squad/join")
    ;input
      =type         "text"
      =id           "join"
      =name         "target-squad"
      =class        "code"
      =size         "30"
      =required     ""
      =placeholder  "~sampel-palnet/squad-name"
      ;+  ;/("")
    ==
    ;button(type "submit", class "bg-green-400 text-white"): Join
    ;+  ?.  =('join' sect.page)
          ;/("")
        %+  success-component
          ?:(success.page "request sent" "failed")
        success.page
  ==
:: this creates a form where you can create a new Squad. You enter the
:: squad title, specify whether it's public or private, then it gets
:: POSTed to the /squad/new URL path and handled by our Gall agent.
::
++  new-component
  ^-  manx
  ;form(class "new-form", method "post", action "/squad/new")
    ;input
      =type         "text"
      =id           "new"
      =name         "title"
      =size         "30"
      =required     ""
      =placeholder  "My squad"
      ;+  ;/("")
    ==
    ;br;
    ;div
      ;input
        =type   "checkbox"
        =id     "new-pub-checkbox"
        =style  "margin-right: 0.5rem"
        =name   "public"
        =value  "true"
        ;+  ;/("")
      ==
      ;label(for "new-pub-checkbox"): Public
    ==
    ;br;
    ;button(type "submit", class "bg-green-400 text-white"): Create
    ;+  ?.  =('new' sect.page)
          ;/("")
        %+  success-component
          ?:(success.page "success" "failed")
        success.page
  ==
:: this displays all the information for an individual squad, such as
:: its title, its members, its whitelist or blacklist, etc. It also
:: has buttons to leave it, or if you're the host to do things like
:: change the title, whitelist/blacklist members, etc. These individual
:: components are defined separately below, this particular arm just
:: puts them all together
::
++  squad-component
  |=  [=gid =squad]
  ^-  manx
  =/  gid-str=tape  "{=>(<host.gid> ?>(?=(^ .) t))}_{(trip name.gid)}"
  =/  summary=manx
    ;summary
      ;h3(class "inline"): {(trip title.squad)}
    ==
  =/  content=manx
    ;div
      ;p
        ;span(style "margin-right: 2px;"): id:
        ;span(class "code"): {<host.gid>}/{(trip name.gid)}
      ==
      ;+  ?.  =(our.bol host.gid)
            ;/("")
          (squad-title-component gid squad)
      ;+  (squad-leave-component gid)
      ;+  ?.  =(our.bol host.gid)
            ;/("")
          (squad-public-component gid squad)
      ;+  (squad-acl-component gid squad)
      ;+  (squad-members-component gid squad)
    ==
  ?:  &(?=(^ gid.page) =(gid u.gid.page))
    ;details(id gid-str, open "open")
      ;+  summary
      ;+  content
    ==
  ;details(id gid-str)
    ;+  summary
    ;+  content
  ==
:: this component lets group hosts change the title of a squad. It has
:: a form that takes the new name and POSTs it to the /squad/title URL
:: path. Our gall agent then processes it.
::
++  squad-title-component
  |=  [=gid =squad]
  ^-  manx
  =/  gid-str=tape  "{=>(<host.gid> ?>(?=(^ .) t))}_{(trip name.gid)}"
  ;form(method "post", action "/squad/title")
    ;input(type "hidden", name "gid", value gid-str);
    ;label(for "title:{gid-str}"): title:
    ;input
      =type         "text"
      =id           "title:{gid-str}"
      =name         "title"
      =size         "30"
      =required     ""
      =placeholder  "My Squad"
      ;+  ;/("")
    ==
    ;button(type "submit"): Change
    ;+  ?.  &(=('title' sect.page) ?=(^ gid.page) =(gid u.gid.page))
          ;/("")
        %+  success-component
          ?:(success.page "success" "failed")
        success.page
  ==
:: This component lets a group host change whether a squad is private
:: or public. It's a form that POSTs the new state to either the /squad/private
:: or /squad/public URL path, and our Gall agent processes the request.
::
++  squad-public-component
  |=  [=gid =squad]
  ^-  manx
  =/  gid-str=tape  "{=>(<host.gid> ?>(?=(^ .) t))}_{(trip name.gid)}"
  ;form(method "post", action "/squad/{?:(pub.squad "private" "public")}")
    ;input(type "hidden", name "gid", value gid-str);
    ;button(type "submit"): {?:(pub.squad "Make Private" "Make Public")}
    ;+  ?.  &(=('public' sect.page) ?=(^ gid.page) =(gid u.gid.page))
          ;/("")
        %+  success-component
          ?:(success.page "Success!" "Failed!")
        success.page
  ==
:: This component lets a group host delete a squad, and other members leave it.
:: It's a form that POSTs either to the /squad/delete or /squad/leave URL path
:: depending on the case
::
++  squad-leave-component
  |=  =gid
  ^-  manx
  =/  gid-str=tape  "{=>(<host.gid> ?>(?=(^ .) t))}_{(trip name.gid)}"
  ;form
    =class     ?:(=(our.bol host.gid) "delete-form" "leave-form")
    =method    "post"
    =action    ?:(=(our.bol host.gid) "/squad/delete" "/squad/leave")
    =onsubmit  ?.(=(our.bol host.gid) "" "return confirm('Are you sure?');")
    ;input(type "hidden", name "gid", value gid-str);
    ;button(type "submit", class "bg-red text-white"): {?:(=(our.bol host.gid) "Delete" "Leave")}
  ==
:: This component displays the access control list. If it's public, it's the blacklist. If
:: it's private, it's the whitelist. It also lets group hosts manage these lists and has a form
:: that POSTs to the /squad/kick or /squad/allow URL paths as the case may be.
::
++  squad-acl-component
  |=  [=gid =squad]
  ^-  manx
  =/  acl=(list @p)  ~(tap in (~(get ju acls) gid))
  =/  gid-str=tape  "{=>(<host.gid> ?>(?=(^ .) t))}_{(trip name.gid)}"
  =/  summary=manx
    ;summary
      ;h4(class "inline"): {?:(pub.squad "Blacklist" "Whitelist")} ({(a-co:co (lent acl))})
    ==
  =/  kick-allow-form=manx
    ;form(method "post", action "/squad/{?:(pub.squad "kick" "allow")}")
      ;input(type "hidden", name "gid", value gid-str);
      ;input
        =type         "text"
        =id           "acl-diff:{gid-str}"
        =name         "ship"
        =size         "30"
        =required     ""
        =placeholder  "~sampel-palnet"
        ;+  ;/("")
      ==
      ;input(type "submit", value ?:(pub.squad "Blacklist" "Whitelist"));
      ;+  ?.  &(=('kick' sect.page) ?=(^ gid.page) =(gid u.gid.page))
            ;/("")
          %+  success-component
            ?:(success.page "success" "failed")
          success.page
    ==
  =/  ships=manx
    ;div(id "acl:{gid-str}")
      ;*  %+  turn
            %+  sort  acl
            |=([a=@p b=@p] (aor (cite:^title a) (cite:^title b)))
          |=(=ship (ship-acl-item-component gid ship pub.squad))
    ==
  ?.  &(=('kick' sect.page) ?=(^ gid.page) =(gid u.gid.page))
    ;details
      ;+  summary
      ;div
        ;+  ?.  =(our.bol host.gid)
              ;/("")
            kick-allow-form
        ;+  ships
      ==
    ==
  ;details(open "open")
    ;+  summary
    ;div
      ;+  ?.  =(our.bol host.gid)
            ;/("")
          kick-allow-form
      ;+  ships
    ==
  ==
:: this is a sub-component of the one above, it renders and individual ship
:: in the whitelist or blacklist and, if you're the host, lets you click
:: on the ship to remove it from the list. The form POSTs to /squad/allow
:: or /squad/kick as the case may be, and our Gall agent handles the request
::
++  ship-acl-item-component
  |=  [=gid =ship pub=?]
  ^-  manx
  ?.  =(our.bol host.gid)
    ;span(class "ship-acl-span"): {(cite:^title ship)}
  =/  gid-str=tape  "{=>(<host.gid> ?>(?=(^ .) t))}_{(trip name.gid)}"
  ;form
    =class   "ship-acl-form"
    =method  "post"
    =action  "/squad/{?:(pub "allow" "kick")}"
    ;input(type "hidden", name "gid", value gid-str);
    ;input(type "hidden", name "ship", value <ship>);
    ;input(type "submit", value "{(cite:^title ship)} ×");
  ==
:: this component lists all the current members of a squad
::
++  squad-members-component
  |=  [=gid =squad]
  ^-  manx
  =/  members=(list @p)  ~(tap in (~(get ju members) gid))
  ;details
    ;summary
      ;h4(class "inline"): Members ({(a-co:co (lent members))})
    ==
    ;div
      ;*  %+  turn
            %+  sort  members
            |=([a=@p b=@p] (aor (cite:^title a) (cite:^title b)))
          |=  =ship
          ^-  manx
          ;span(class "ship-members-span"): {(cite:^title ship)}
    ==
  ==
:: lastly we have the stylesheet, which is just
:: a big static block of text
::
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
 
