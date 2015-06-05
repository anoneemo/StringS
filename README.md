--------------------------------------- StringS 1.0 -------------------------------------------

------ by Anoneemo (a translation of SiL-La-BaH by PanToufLe - pantoufle@Quizitalia.it ) ------

------------------------------------------ Guide ----------------------------------------------

WARNING: launching the game in a channel with colors enabled is STRONGLY suggested. The 
game may get confusing if colors are disabled.

Remember: you can open "Strings.pan" with NotePad or any other basic code/text editor. Do NOT
edit that file if you don't know what you're doing otherwise the game may not work as intended!

What is StringS?
----------------
StringS is an IRC game based on words that runs on mIRC and mIRC-based scripts. Scroll down for 
game rules.

It's easy to install and play and mIRC is not required to play it: you can leave it running in
background and use your favorite IRC client to chat and play.

ONLY the person who runs the game needs to have it installed, other players do not!


Installing the game
---------------------
1. Unzip the archive and copy the folder's content inside mIRC's folder (version 5.71 or above). 

    Default folder for Windows is
    
        %APPDATA%\Roaming\mIRC\ 
    
    The "StringS.pan" file has to be in mIRC's main folder, together with the "Dictionary" folder, that
    contains all the necessary dictionary files.
2. Launch mIRC and, in a window of your choice, type 

        /load -rs StringS.pan

3. If you plan to use remote managament commands, edit the "Gamebot.txt" file and fill the fields for the channel
    you want to the game to be played and the password to make it start (read below), then load the file by
    typing 

        /load -rs Gamebot.txt

Dictionary
----------
The game has its own integrated dictionary, contained in the "Dictionary" folder. It contains more than
100'000 english words. The game calculates points basing itself on the English letter frequency (the more rare
the letters in a word, the more points you get) so changing the Dictionary with another one (using the
same structure) is not enough; you need to change assignments for each letter in "StringS.pan" (there is
at least two parts of the code where assignments occurs) and do your assignments, basing yourself on the letters 
frequency of the new language.

Launching the game in normal mode
---------------------------------
The game can be launched by right-clicking a mIRC chat window. After clicking "Start", selecting the
channel where you want the game to start and the winning score, a window will appear. It lets you start 
the game, end it, show rules and do other commands. When a player reaches the winning score, the game 
ends. The game will also end after clicking the "End-Of-Game" button, when the round will be over.

Launching the game in bot mode
------------------------------
The game can be started and controlled remotely (from another client by using NOTICE commands). It will
start on the channel that has been set in the "Gamebot.txt" file, in which you also have to set the 
password required to use remote commands. Commands are the followings and all of them have to be given, 
using NOTICE, to the client (bot) that's running the game.


   To start the game:
   
     /notice botname stringson XXX password 

   (where XXX is the winning score)
 
   To end the game:
   
     /notice botname stringsoff password

   To pause/resume the game:
   
     /notice botname stringspause password

   To show game rules:
   
     /notice botname stringshelp password

   To increase/decrease round duration:
   
     /notice botname stringsm+10 password
     
     /notice botname stringsm-10 password

   To increase/decrease waiting time between rounds:
   
     /notice botname stringsp+5 password
     
     /notice botname stringsp-5 password
    
   To change winning score while the game's running:
   
     /notice botname stringstarget newscore password 

Game rules and commands
-----------------------
The game consists in composing one word, for each game round, that contains a string that's randomly chosen at
the start of the round, without exceeding the characters limit (all of these info are shown when the round starts). 
Each round also has random bonuses. Once you found a word that suits, open a private query with the user/bot 
(/query username) that is running the game and tell him (only type the word).
At the end of each round, points are assigned. The winner is the one who reaches the winning score.


If you need more information, you can publicly type these commands in the channel window:

    !points		To know your score

    !values		To see how many points each letter is worth

    !string		To know what's the current round's string

    !help		To have the bot tell you in private how to play


If you edited the "Gamebot.txt" file, you can see the High Scores using 

    !stringshs

(Remember: a game gets counted for the High Scores if there's more than 4 players and the winning score is 300 or more. )

Have Fun! :)

