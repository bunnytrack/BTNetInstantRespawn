# BTNetInstantRespawn

## Author
* Dizzy

## Description
A mod for Unreal Tournament (UT99) servers which makes players instantly respawn without any delay when they die. Useful for practice of BunnyTrack maps.

## Installation
1. Copy the file(s) inside the `compiled` folder to your server's `UT/System/` directory
2. Open your server's `UnrealTournament.ini`
3. Under `[Engine.GameEngine]` add: `ServerActors=BTNetInstantRespawn.InstantRespawn`
4. Restart your server

## Known Issues
* The mutator is prevented from working in BunnyTrack maps which use the *BTME* package by Bloeb (at least versions <= v4). This is because BTME searches for and unloads any mods which contain the string `Insta` in their class names. This results in `InstantRespawn` being unloaded unnecessarily. This is an issue with BTME and not with BTNetInstantRespawn. A workaround is changing the name of the `InstantRespawn` class to something else, e.g. `IR`.

## Licence
This mutator is released under the Creative Commons Attribution-NonCommercial-ShareAlike license. Visible, client-side attribution to BunnyTrack.net is required to use the mod and/or its code. This means you must display the following message to players when they enter your server: `[BTNet] This server uses the Instant Respawn mutator from BunnyTrack.net`.

## Version
2021-04-03

## Website
https://bunnytrack.net/

https://github.com/bunnytrack/
