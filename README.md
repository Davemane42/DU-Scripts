# DU-Scripts

## Player logger script

![PlayerLogger](https://github.com/Davemane42/DU-Scripts/blob/master/images/PlayerLogger.png?raw=true)

Log player activity to a DataBank and render to a screen<br />
Support about 175 entry before you need to clear the DataBank


<details close="close">
  <summary>Instalation:</summary>
  <ul>
    <details close="close">
      <summary>Elements needed:</summary>
      <ul>
        <li>1x Programming board</li>
        <li>1x Data Bank</li>
        <li>1x Screen</li>
	<li>1x Detection zone</li>
      </ul>
    </details>
    <li><p>Copy the content of this <a href="https://raw.githubusercontent.com/Davemane42/DU-Scripts/master/PlayerLogger/PlayerLogger2.0.json">link</a> and paste on a programming board</p></li>
    <li><p>Connnect the board to the screen.
    </br>Then do the same for the data bank.
    </br>Connect the detection zone to the Programming Board.</p></li>
    <li><p>Finnaly, hit ctrl+L while looking at the board and add your username in line 7 of unit->start() </p></li>
  </ul>
</details>
Activate the board manualy and type "help" in the lua chat for the command list
<details close="close">
  <summary>List of commands:</summary>
  <ul>
    <li>'clear' [clear the databank]</li>
    <li>'dump latest/unknown' [dump the table as JSON in the screen HTML so you can copy it]</li>
    <li>'remove latest/unknown indice' [remove an entry from one of the table]</li>
    <li>'exit' [exit debug mode]</li>
    <li>'help' display a list of commands</li>
  </ul>
</details>
<details close="close">
<summary>Known Issue:</summary>
  <ul>
    <li>Detection zone needs to be at least 3m away from the programing board for "ignoreKnown = false" to work</li>
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
