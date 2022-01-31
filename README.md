
# DU-Scripts

## Player logger script

![PlayerLogger](https://github.com/Davemane42/DU-Scripts/blob/master/images/PlayerLogger.png?raw=true)

Log player activity to a Databank(s) and render to a screen<br />
Tested with 1300 entries with 8 databanks


<details close="close">
  <summary>Instalation:</summary>
  <ul>
    <details close="close">
      <summary>Elements needed:</summary>
      <ul>
        <li>1x Programming board</li>
        <li>1x Manual Switch</li>
        <li>1x Screen</li>
	<li>1x Detection zone</li>
	<li>1 to 8 Databank(s)</li>
      </ul>
    </details>
    <li>Copy the content of this <a href="https://raw.githubusercontent.com/Davemane42/DU-Scripts/master/PlayerLogger/PlayerLogger3.2.json">link</a></li>
      <ul><li>Right click (on the programming board) -> Advanced -> Paste Lua configuration from clipboard</li></ul>
    <li>Connect Detection zone -> Manual Switch -> Programming Board -> Manual Switch (both way)</li>
    <ul><li>For multiple detection zone: add an "OR operator" between the Detection zones and the Manual Switch
      </br>(only 1 needed) in between the zones and switch</li></ul>
    <li>Then Programming Board -> databank(s) and screen</li>
    <li>Finnaly, hit ctrl+L while looking at the board
      </br>add your username in line 7 of unit.start()
      </br>rename the location to your liking</li>  
  </ul>
</details>
Activate the board manualy and type "help" in the lua chat for the command list
<details close="close">
  <summary>List of commands:</summary>
  <ul>
    <li>'clear' [clear the databank(s)]</li>
    <li>'dump' [dump the table as JSON in the screen HTML so you can copy it]</li>
    <li>'exit' [exit debug mode]</li>
    <li>'help' display a list of commands</li>
    <li>'remove (indices)' [remove an entry from one of the table]</li>
    <li>'update' [Update the screen code]</li>
  </ul>
</details>
<details close="close">
<summary>Known Issue:</summary>
  <ul>
    <li></li>
    <li></li>
    <li></li>
  </ul>
</details>

## Restricted Access Door script

![PlayerLogger](https://github.com/Davemane42/DU-Scripts/blob/master/images/RestrictedDoor.png?raw=true)

Restric access to certain zones via "locked door"

<details close="close">
  <summary>Instalation:</summary>
  <ul>
    <details close="close">
      <summary>Elements needed:</summary>
      <ul>
        <li>1x Programming board</li>
	<li>1x Detection zone</li>
	<li>1x Screen (minimum)</li>
	  <ul><li>Supports multiple screens</li></ul>
      </ul>
    </details>
    <li>Copy the content of this <a href="https://raw.githubusercontent.com/Davemane42/DU-Scripts/master/RestrictedAccessDoor/RestrictedAccessDoor1.0.json">link</a></li>
      <ul><li>Right click (on the programming board) -> Advanced -> Paste Lua configuration from clipboard</li></ul>
    <li>Connect Detection zone -> Programming Board</li>
    <li>Then Programming Board -> Door and Screen(s)</li>
    <li>Finnaly, edit the lua parameters (Right click -> Advanced -> Edit Lua Parameters)
      </br>Add your username between the quotes ""
	<ul><li>"Davemane42"</li></ul>
      For multiple user. add comma , between names and no spaces
	<ul><li>"Davemane42,User2,User3"</li></ul></li>
  </ul>
</details>

## Ore Display

![PlayerLogger](https://github.com/Davemane42/DU-Scripts/blob/master/images/Ore_Display.png?raw=true)

Display all ores in the connected container.
refreshes every 30 sec

<details close="close">
  <summary>Instalation:</summary>
  <ul>
    <details close="close">
      <summary>Elements needed:</summary>
      <ul>
        <li>1x Programming board</li>
        <li>1x Container / ContainerHub</li>
      </ul>
    </details>
    <li><p>Copy the content of this <a href="https://raw.githubusercontent.com/Davemane42/DU-Scripts/master/OreDisplay/OreDisplay.json">link</a> and paste on a programming board</p></li>
    <li><p>Connnect the board to the container / ContainerHub.
  </ul>
</details>