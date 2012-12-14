cc-scripts
==========

A collection of ComputerCraft scripts.

Installation
============

0. Open the Lua interpreter on your in-game lua computer: `lua`
0. Ensure your server has the HTTP API enabled. You can test it with this code snippet:
   `assert(http, "No HTTP for you!")`  
   _If your server doesn't have the HTTP API enabled, have an admin check the ComputerCraft configuration files and enable it from there._
0. Enter the following snippet to download the installation:
   `loadstring(http.get("https://raw.github.com/damien/cc-scripts/master/bootstrap.lua").readAll())()`
0. Follow the instructions given by the installer and you should be good to go!

Issues
======

Report any and all problems at the the [cc-scripts Github Issues](https://github.com/damien/cc-scripts/issues) page: https://github.com/damien/cc-scripts/issues
