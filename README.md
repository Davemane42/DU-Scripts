# DU-Scripts

## Player logger script

![PlayerLogger](https://github.com/Davemane42/DU-Scripts/blob/master/images/Player_Logger.png?raw=true)

Log player activity to a DataBank and display to a screen.
useful lua channel commands for user interaction

<details close="close">
  <summary>List of commands:</summary>
  <ul>
    <li>'clear' [clear the databank]</li>
    <li>'dump latest/unknown' [dump the table as JSON in the HTML so you can copy it]</li>
    <li>'remove latest/unknown indice' [remove an entry from one of the table]</li>
    <li>'exit' [exit debug mode]</li>
    <li>'help' display a list of commands</li>
  </ul>
</details>

<details close="close">
  <summary>Instalation:</summary>
  <ul>
    <details close="close">
      <summary>Elements needed:</summary>
      <ul>
        <li>1x Programming board</li>
        <li>1x Detection zone</li>
        <li>1x Data Bank</li>
        <li>1x Screen</li>
        <li>1x Manual Switch</li>
      </ul>
    </details>
    <li><p>Copy the content of this <a href="https://raw.githubusercontent.com/Davemane42/DU-Scripts/master/Player_Logger.json">link</a> and paste on a programming board</p></li>
    <li><p>Connnect the board to the screen.
    </br>Then do the same for the data bank.
    </br>Youll also need to connect the board and the switch both way."
    </br>Connect the detection zone to the switch. You can have more then one zone connected to cover more entrances</p></li>
    <li><p>Finnaly, hit ctrl+L while looking at the board and add your username in line 5 of unit->start() </p></li>
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
    <li><p>Copy the content of this <a href="https://raw.githubusercontent.com/Davemane42/DU-Scripts/master/OreDisplay.json">link</a> and paste on a programming board</p></li>
    <li><p>Connnect the board to the container / ContainerHub.
  </ul>
</details>
