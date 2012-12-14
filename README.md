cc-scripts
==========

A collection of ComputerCraft scripts.

The goal of this project is to create and maintain a collection of well
assembled and thoughtfully documented Lua scripts for use within the excellent
[ComputerCraft](http://computercraft.info/wiki/Main_Page) mod for
[Minecraft](https://minecraft.net/).

Installation
============

0. Open the Lua interpreter on your in-game computer: `lua`

0. Ensure your server has the HTTP API enabled. You can test it with this code snippet:
   `assert(http, "No HTTP for you!")`  
   __If your server doesn't have the HTTP API enabled, have an admin check the ComputerCraft configuration files and enable it from there.__

0. Enter the following snippet to download the installation:
`loadstring(http.get("https://raw.github.com/damien/cc-scripts/master/bootstrap.lua").readAll())()`

0. Follow the instructions given by the installer and you should be good to go!

Issues
======

Report any and all problems at the the [cc-scripts Github Issues](https://github.com/damien/cc-scripts/issues) page: https://github.com/damien/cc-scripts/issues

Contributing
============

__For those savvy with Github:__ Fork this repo, add your script and/or
API and send me a pull request!

__For those of you who aren't familiar with Github__, you can do the following:

0. Take a look around the code on the cc-scripts GitHub page,
   make sure you're not submitting something we already have unless you feel
   it's a drastic improvement to what's there already!
0. Upload your Lua code as a [Gist](https://gist.github.com/)
0. [Create a new issue here](https://github.com/damien/cc-scripts/issues),
   be sure to include a link to the Gist you created!
0. That's it! Be prepared for some dialogue; you may be asked to make changes
   before your scripts are accepted!

__To all of our contributors__: We love you! You make cc-scripts more awesome
with every new submission!
