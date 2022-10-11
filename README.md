# Wow, Rude!
A crappy BLTHook mod for payday 2 that automatically complains whenever someone kills a surrendering/intimidated cop.

download [the release](https://github.com/11BelowStudio/wow-rude/releases/tag/refs%2Fheads%2Fmain) and stick it into your BLTHook `/mods/` folder.

**REQUIRES HOPLIB**

HopLib can be installed from https://modworkshop.net/mod/21431 or https://github.com/segabl/pd2-hoplib/archive/master.zip


[![forthebadge](https://forthebadge.com/images/badges/built-with-resentment.svg)](https://forthebadge.com) 


Uses Hugo's PD2 auto-update example thing https://github.com/HugoZink/PD2AutoUpdateExample

# Chainslog

### v6.1 - you can (hopefully) edit the responses without it complaining now
11 october 2022
* Attempted to finagle the release.yml thing to get meta.json to use a version identifier instead of a hash.
* Should allow you to edit the response files without angering the auto-updater (assuming that the git action actually runs successfully).

## v6 - you can (hopefully) disable the prefixing now
11 october 2022
* You can disable the `>:( ` that appears before the messages you put into chat (hopefully)
  * yeah it's untested (haven't touched Payday 2 since last April lol 😅)
* Copied the chainslog to the readme on git

## v5 - you can change the responses now
17 april 2022
* Made it easier to change the responses.
	* 'name and shame' responses are in `/responses/named.txt` (note: you *need* to include the `%s` if you edit these!)
	* the responses without name placeholders are in `/responses/unnamed.txt`
    * Yes, the SuperBLT autoupdate may complain and try to update the mod to reset the responses if you edit them. Known issue, idk how to fix it.
* More granular settings for enabling/disabling logging (it's still all off by default, and you still don't want to turn it on)
	* the logs are now in a submenu so you don't need to worry about seeing them 😤

### v4.2 - ohshit.png
15 april 2022
* Fixed a bug that caused mod options to completely break.

### v4.1 - log off
15 april 2022
* Allowed logging to be disabled

## v4 - named and shamed
15 april 2022
* The option to 'name and shame' the individual who killed the hostage works!
* an option to make the mod only complain from the 2nd stage of domination instead of the first has been added.
* an option to make the mod complain about civilians getting murdered has been added.
* now depends on hoplib
  * this mod's license has been changed to GPL v3

## v3 - not worth the wait
14 april 2022
* after over a year of procrastination, I finally released the mod
* added an 'off' button (and an 'off when im not hosting' button)
* added logging
* added a button to enable naming and shaming culprits (doesn't work though lol)
* got autoupdates working
* released it publicly

## v2 - a failed attempt at adding autoupdates
10 april 2021
* yes, 2021.
  * I spent over a year procrastinating on this mod between making v2 and finally releasing it, [commits don't lie (usually)](https://github.com/11BelowStudio/wow-rude/tree/0fc2644ab07961d6fdaf47aa601cdaba21dd2291)
* tried getting autoupdates working
  * kinda failed
* started procrastinating (only wanting to release the mod properly after the autoupdates were working)

## v1 - initial version
april 2021 (i forgor what day it was, probably was the 8th or 9th of April 2021 i guess? idk)
* bodged this mod together from code reverse-engineered from the unsynced version of intimidated outlines and from Bee Movie to Chat
  * yes, those mods.
* no options menu because I had no idea how to do that lol

## v0 - initial idea
29 march 2021 (maybe)
* at least thats when i first sent a message about having a stupid idea for a mod but having no idea how to make a mod on the MWS discord, I guess it was probably the idea for this mod, so I guess that this idea was present in the back of my mind back then. i forgor lol


# From the PD2 auto-update example

(this thing: https://github.com/HugoZink/PD2AutoUpdateExample)

## Setup
Download or clone this repo. Copy the entire .github folder to your own project's root folder, and modify the sample meta.json and releases.yml as you see fit.
For the simplest configuration, simply change `SampleMod` in release.yml to point to your mod's root folder, and change `pd2autoupdatexample.zip` to a more personal zip name that will be used for your mod's zip files.
Don't forget to change the `ident` field in meta.json to your own mod's ID!

This template needs your mod's main folder to be *under* your repository's root. If your mod.txt file is inside the root of the repository, the hash checks won't function properly anymore, so move the mod into a child folder.

After you modify meta.json and releases.yml to match your own mod's ID and zip names, you are ready to commit and push. On your first push *or* your first pull request towards master, Github should immediately start performing all actions.
This action will delete any existing releases and make a new one, where it will upload your mod's zip file and meta.json. **Remember that the default behavior is to haphazardly delete any other releases or tags in the Releases section.**

Copy the direct download link for your mod's zip, and put it inside `.github/meta.json`. Copy the direct download link for your release's meta.json file, and put it in the updates section of your mod.txt file.

Commit and push these changes again, and your mod should be ready to go! Any pushes to master will immediately be zipped and made available to users ingame. Github will zip your mod for you and calculate a new hash.

## Dealing with line endings
Line endings may or may not (probably not) negatively affect the way the hashing works, which might endlessly pester your users with non-existent updates.
If this happens to you, copy the provided `.gitattributes` file into your own repository to prevent Git from messing with your line endings.

## Misc Info
The included SuperBLT hash calculator was made by fragtrane: https://github.com/fragtrane/Python-SuperBLT-Hash-Calculator
7-Zip by Igor Pavlov: https://www.7-zip.org/

7-zip is included and has to be used because SuperBLT's unzipper is incompatible with Powershell's `Compress-Archive` or the `tar` command.
