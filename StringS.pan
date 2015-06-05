;--------------------------------------------------------------
StringS 1.0 (a translated version of SiL-La-BaH 2.0 by PanToufLe)

Launch mIRC.
To load the script: /load -rs StringS.pan
To make the game work as intended, make sure the dictionary is
contained inside the Dictionary folder

WARNING: launching the game in a channel where colors are enabled 
is STRONGLY suggested. The game may get confusing if colors are 
disabled.
;--------------------------------------------------------------


on 1:NICK:{ 
  if (%gamesillaba_stato != OFF) && ( $nick != $newnick ) {
    sillaba_search $newnick
    if (%trovato == 1) {
      %sillaba_tmpp = %sillaba_ptsquery
      write -dl %pos sillclass.txt 
    }
    sillaba_search $nick
    if (%trovato == 1) {
      %sillaba_chnickline = $read -l %pos sillclass.txt
      %sillaba_ptsquery = $calc(%sillaba_ptsquery + %sillaba_tmpp)
      %sillaba_chnickline = $puttok(%sillaba_chnickline,%sillaba_ptsquery,2,46)
      %sillaba_chnickline = $puttok(%sillaba_chnickline,$newnick,1,46)
      write -l %pos sillclass.txt %sillaba_chnickline
    }
    sillaba_manchesearch $nick
    if (%trovato == 1) {
      %sillaba_chnickline = $read -l %pos sillabamanche.txt
      %sillaba_chnickline = $puttok(%sillaba_chnickline,$newnick,1,46)
      write -l %pos sillabamanche.txt %sillaba_chnickline
    }  
  }
  unset %sillaba_tmpp
}
on 1:JOIN:%sillaba_canale:{ if (%gamesillaba_stato != OFF) { .msg $nick 11,2  ©º°¨¨°º©'4,2 StringS running on %sillaba_canale 11,2   '©º°¨¨°º© 8,2 Type !help for game rules } }
on 1:TEXT:!points:%sillaba_canale:{ 
  if (%gamesillaba_stato != OFF) {
    sillaba_search $nick
    if (%trovato == 1) {
      .msg $nick your score is %sillaba_ptsquery 
    }
  }
}
on 1:TEXT:!string:%sillaba_canale: {
  if (%gamesillaba_stato != OFF) {
    if (%sillaba_manche == ON ) { msg %sillaba_canale  11,2 Current string8,2 %Sillaba_current 11,2 . Limit set to8,2 %sillaba_lenmax 11,2characters. }
    else { msg %sillaba_canale 11,2 No round is currently playing. Wait for the next. }
  }
} 
on 1:TEXT:!values:%sillaba_canale:{
  if (%gamesillaba_stato != OFF) {
    if (%sillaba_mad != 1) msg %sillaba_canale 8,2 Values:11,2 a=1 b=5 c=4 d=3 e=1 f=4 g=5 h=2 i=1 j=8 k=6 l=3 m=4 n=2 o=1 p=5 q=8 r=2 s=2 t=1 u=4 v=6 w=4 x=8 y=5 z=8 
    else msg %sillaba_canale 8,2 Valori:11,2 %sillaba_madvaluesline
  } 
}
on 1:TEXT:!help:%sillaba_canale: sillaba_help $nick

on 1:TEXT:*:?:{
  if (%gamesillaba_stato == ON) && (%sillaba_manche == OFF) && ($1 != $null) && ($nick != $me) { .msg $nick Time's over. I can't accept your request. }
  if (%gamesillaba_stato == ON) && (%sillaba_manche == ON) && ($1 != $null) && ($nick != $me) {
    sillaba_manchesearch $nick 
    if ($1 == -delete) {
      if (%trovato == 1) {
        write -dl %pos sillabamanche.txt
        .msg $nick I deleted your entry. Type a new one
      } 
    }
    else { 
      set %sillaba_string $1
      if (%trovato == 1) { .msg $nick You already entered a word %sillaba_wentry . -Delete to remove it | halt }
      if ($len(%sillaba_string) > %sillaba_lenmax) { .msg $nick Limit for this round is %sillaba_lenmax  characters | halt }
      if (%Sillaba_current !isin %sillaba_string ) { .msg $nick We're playing for the string %sillaba_current  . Your word doesn't contain it | halt }
      else {
        set %sillaba_starlet $left(%sillaba_string,1)
        set %sillaba_trovato $read($scriptdirdictionary\ $+ english. [ $+ [ %sillaba_starlet ] ],w,%sillaba_string,1)
        if ( %sillaba_trovato == %sillaba_string ) { 
          .msg $nick Word accepted
          set %sillaba_linez $nick
          set %sillaba_linez $addtok(%sillaba_linez,%sillaba_string,46)
          write sillabamanche.txt %sillaba_linez
        }
        else .msg $nick That word is not in my dictionary, sorry
      }
    }
    close -m $nick
  }
}

alias sillaba_start {
  if ( %gamesillaba_stato == ON ) || ( %gamesillaba_stato == PAUSE ) { if ( $?!="Do you really want to start the game? Could be already running or paused " == $true ) { set %gamesillaba_stato OFF  } }
  if (%gamesillaba_stato == OFF) || (%gamesillaba_stato == $null) {
    unset %sillaba*
    set %sillaba_canale $?="On which channel would you like to start the game?"
    if ( %sillaba_canale !ischan ) { echo -a Channel not valid | halt }
    set %sillaba_target $?="Choose the number of points for the winner:"
    if (%sillaba_target !isnum) { echo -a You didn't choose a valid score. Restart the game | halt }
    set %gamesillaba_stato ON
    set %sillaba_manche OFF
    set %sillaba_durata 50
    set %sillaba_pausetime 10
    set %sillaba_manchenum 0
    set %sillaba_mad 0
    if ($exists(stringsrecords.txt) == $false) sillaba_generahs 
    set %sillaba_record $read -l 11 stringsrecords.txt
    set %sillaba_reckeeper $gettok(%sillaba_record,1,35)
    set %sillaba_record $gettok(%sillaba_record,2,35)
    if $exists(sillclass.txt) { .remove sillclass.txt }
    if $exists(sillabamanche.txt) { .remove sillabamanche.txt }
    msg %sillaba_canale 9,2 '©º°¨¨°º©11,2 ©º°¨ 4,2 St8rin11gS0,2 by Anoneemo8,2 StArTeD !!11,2 ¨°º©9,2 ©º°¨¨°º©'
    msg %sillaba_canale 9,2 '©º°¨¨°º©11,2 ©º°¨¨¨°º© 0,29,2 %sillaba_target 0,2 points needed to WIN! 11,2 ©º°¨¨¨°º©9,2 ©º°¨¨°º©'
    msg %sillaba_canale 9,2 '©º°¨¨°º© 0,2 Don't know how to play? Type 8,2!help 0,2and the bot will tell you in private! 9,2 ©º°¨¨°º©'
    echo -a 8,2 Start the first round whenever you're ready by clicking the START GAME button on the game control panel
    dialog -m sillabagame sillabagame
  }
}

on 1:notice:stringson*:?:{ 
  if ($3 == %game_password) {
    if (%gamesillaba_stato == OFF) || (%gamesillaba_stato == $null) {
      unset %sillaba*
      set %sillaba_canale %game_channel
      if ( %sillaba_canale !ischan ) { .msg $nick I'm not on %sillaba_canale, sorry | halt }
      set %sillaba_target $2
      if (%sillaba_target !isnum) { .msg $nick You didn't choose a valid value. Restart the game | halt }
      set %gamesillaba_stato ON
      set %sillaba_manche OFF
      set %sillaba_durata 70
      set %sillaba_pausetime 15
      set %sillaba_manchenum 0
      set %sillaba_mad 0
      if ($4 == MAD) set %sillaba_mad 1
      if ($exists(stringsrecords.txt) == $false) sillaba_generahs 
      set %sillaba_record $read -l 11 stringsrecords.txt
      set %sillaba_reckeeper $gettok(%sillaba_record,1,35)
      set %sillaba_record $gettok(%sillaba_record,2,35)
      if $exists(sillclass.txt) { .remove sillclass.txt }
      if $exists(sillabamanche.txt) { .remove sillabamanche.txt }
      msg %sillaba_canale 9,2 '©º°¨¨°º©11,2 ©º°¨ 4,2 St-8rin-11gS0,2 by Anoneemo8,2 StArTeD by $nick 11,2¨°º©9,2 ©º°¨¨°º©'
      msg %sillaba_canale 9,2 '©º°¨¨°º©11,2 ©º°¨¨¨°º©0,2 9,2 %sillaba_target 0,2 points needed to WIN! 11,2 ©º°¨¨¨°º©9,2 ©º°¨¨°º©'
      .timerhub 1 20 sillaba_hub
    }
  }
}

alias sillaba_generahs {
  %x = 1
  while ( %x <= 11 ) {
    write stringsrecords.txt none#0
    inc %x
  }
}

alias sillaba_endofgame {
  if ($lines(sillclass.txt) > 4) && (%sillaba_target > 199) && (%sillaba_mad == 0) {
    set %x 1
    while (%x <= $lines(sillclass.txt)) {
      set %sillaba_line $read -l %x sillclass.txt
      set %sillaba_nick $gettok(%sillaba_line,1,46)
      set %sillaba_pts $gettok(%sillaba_line,2,46)
      set %sillaba_media $calc(%sillaba_pts / %sillaba_manchenum)
      set %y 1
      if (%sillaba_nick == `computer`) goto stophere
      sillaba_gcs %sillaba_nick
      if (%trovato == 0) {
        while (%y <= 10) {
          set %sillaba_procline $read -l %y stringsrecords.txt
          set %sillaba_ptsentry $gettok(%sillaba_procline,2,35)
          if (%sillaba_media > %sillaba_ptsentry) {
            set %z %y
            set %sillaba_inline %sillaba_nick $+ $chr(35) $+ %sillaba_media
            msg %sillaba_canale 8,2 %sillaba_nick 11,2conquers position 8,2# %y 11,2with an average score of9,2 %sillaba_media 11,2points.
            while (%z <= 10) {
              set %sillaba_temp $read -l %z stringsrecords.txt
              write -l %z stringsrecords.txt %sillaba_inline
              set %sillaba_inline %sillaba_temp    
              inc %z          
            } 
            goto stophere 
          }
          inc %y
        }
      }
      if (%trovato == 1) {
        if (%sillaba_media <= %sillaba_ptsquery) goto stophere
        write -dl %pos stringsrecords.txt
        while (%y <= %pos) {
          set %sillaba_procline $read -l %y stringsrecords.txt
          set %sillaba_ptsentry $gettok(%sillaba_procline,2,35)
          if (%sillaba_media > %sillaba_ptsentry) {
            set %sillaba_inline %sillaba_nick $+ $chr(35) $+ %sillaba_media
            msg %sillaba_canale 8,2 %sillaba_nick 11,2 reaches position 8,2# %y 11,2with an average score of9,2 %sillaba_media 11,2points.
            write -il %y stringsrecords.txt %sillaba_inline
            goto stophere 
          }
          inc %y
        }
      }
      :stophere
      inc %x
    }
  }
  if $exists(sillclass.txt) { .remove sillclass.txt }
  if $exists(sillabamanche.txt) { .remove sillabamanche.txt }
  msg %sillaba_canale 9,2 '©º°¨¨°º©11,2 ©º°¨¨¨°º© 4,2 StringS Ended 11,2 ©º°¨¨¨°º©9,2 ©º°¨¨°º©'
  msg %sillaba_canale 9,2 '©º°¨¨°º©11,2 ©º°¨ 0,2 With8,2 %sillaba_1pts 0,2points, the WINNER is8,2 %sillaba_1nick 0,2!11,2  ¨¨°º©9,2 ©º°¨¨°º©'
  msg %sillaba_canale 9,2 '©º°¨¨°º©11,2 ©º°¨ 0,2 Get the Game! - https://goo.gl/9hKKh10,211,2  ¨¨°º©9,2 ©º°¨¨°º©'
  set %gamesillaba_stato OFF
  unset %sillaba*
}

alias sillaba_gcs { 
  set %i 1
  set %trovato 0
  while ( ( %i <= 10 ) && ( %trovato == 0 ) ) {
    %riga = $read -l %i stringsrecords.txt    
    %nome = $gettok(%riga,1,35)
    %sillaba_ptsquery = $gettok(%riga,2,35)
    if ( %nome == $1 ) {
      set %trovato 1 
      set %pos %i
    }
    inc %i 1 
  }
}

on 1:notice:stringsoff*:?:{
  if ($2 == %game_password) && (%gamesillaba_stato == ON) {
    if $exists(sillclass.txt) { .remove sillclass.txt }
    if $exists(sillabamanche.txt) { .remove sillabamanche.txt }
    .timer* off
    msg %sillaba_canale 9,2 '©º°¨¨°º©11,2 ©º°¨¨¨°º© 4,2 StringS Ended 11,2 ©º°¨¨¨°º©9,2 ©º°¨¨°º©'
    msg %sillaba_canale 9,2 '©º°¨¨°º©11,2 ©º°¨ 0,2 With8,2 %sillaba_1pts 0,2points, the WINNER is8,2 %sillaba_1nick 11,2 ! ¨¨°º©9,2 ©º°¨¨°º©'
msg %sillaba_canale 9,2 '©º°¨¨°º©11,2 ©º°¨ 0,2 Get the Game! - https://goo.gl/9hKKh111,2  ¨¨°º©9,2 ©º°¨¨°º©'
    set %gamesillaba_stato OFF
    unset %sillaba*
  }
}


alias sillaba_end_query { 
  if (%gamesillaba_stato == ON) || (%gamesillaba_stato == PAUSE) {
    if ( $?!="Do you want to stop the game? It will be stopped at the end of the next or current round " == $true ) { set %sillaba_target -1 }
  }
}

alias sillaba_pause {
  if (%gamesillaba_stato == ON) || (%gamesillaba_stato == PAUSE) {
    if (%sillaba_manche == ON) { echo -a 8,2 Wait for this round to end } 
    if (%sillaba_manche == OFF) {
      if (%gamesillaba_stato == PAUSE) { set %gamesillaba_stato ON | msg %sillaba_canale 11,2 ©º°¨¨¨°º© 4,2 Warning: StringS is RESUMING now! 11,2 ©º°¨¨¨°º© | .timernext 1 %sillaba_pausetime sillaba_start_manche | halt } 
      if (%gamesillaba_stato == ON) { set %gamesillaba_stato PAUSE | msg %sillaba_canale 11,2 ©º°¨¨¨°º© 8,2 StringS is paused. Just a moment... 11,2 ©º°¨¨¨°º© }
    }
  }
}

on 1:notice:stringspause*:?:{
  if ($2 == %game_password) {
    if (%gamesillaba_stato == ON) || (%gamesillaba_stato == PAUSE) {
      if (%sillaba_manche == ON) { .msg $nick Wait for this round to end } 
      if (%sillaba_manche == OFF) {
        if (%gamesillaba_stato == PAUSE) { set %gamesillaba_stato ON | msg %sillaba_canale 11,2 ©º°¨¨¨°º© 4,2 Warning: StringS is RESUMING now! 11,2 ©º°¨¨¨°º© | .timernext 1 %sillaba_pausetime sillaba_start_manche | halt } 
        if (%gamesillaba_stato == ON) { set %gamesillaba_stato PAUSE | msg %sillaba_canale 11,2 ©º°¨¨¨°º© 8,2 StringS is paused. Just a moment... 11,2 ©º°¨¨¨°º© }
      }
    }
  }
}

alias sillaba_help {
  if ( %gamesillaba_stato != OFF) && (%sillaba_antiflood != ON) {
    set %sillaba_antiflood ON
    .timer1 1 1 .msg $1  4,2 ©©© StringS ©©© - GAME RULES:
    .timer2 1 2 .msg $1  8,2 “““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““
    .timer3 1 3 .msg $1  11,2 Each round a random string gets chosen. Compose a word that contains it without       
    .timer4 1 4 .msg $1  11,2 exceeding the character limit and tell it to $me only, in a private query (this window).
    .timer5 1 5 .msg $1  11,2 0,2!string 11,2to know what's the current string. 0,2!values 11,2to know how many points each letter is worth.
    .timer6 1 6 .msg $1  11,2 0,2!points 11,2to see your score.
    .timer7 1 7 .msg $1  11,2 You can only choose 1 word! To delete your word, type 0,2-delete 11,2(in this window).
    .timer8 1 8 .msg $1  8,2 ““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““
    .timer9 1 9 .msg $1  11,2 Have Fun! 
    .timer10 1 10 set %sillaba_antiflood OFF
  }
}

alias sillaba_instr {
  if ( %gamesillaba_stato != OFF ) && (%sillaba_antiflood != ON) {
    set %sillaba_antiflood ON
    .timer11 1 1 msg %sillaba_canale 4,2 ©©© StringS ©©© - GAME RULES :
    .timer12 1 2 msg %sillaba_canale 8,2 “““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““
    .timer13 1 3 msg %sillaba_canale 11,2 Each round a random string gets chosen. Compose a word that contains it without        
    .timer14 1 4 msg %sillaba_canale 11,2 exceeding the character limit and reveal it, in a private query, to0,2 $me 11,2.
    .timer15 1 5 msg %sillaba_canale 11,2 0,2!string11,2 to know what's the current string.0,2 !values 11,2to know how many points  
    .timer16 1 6 msg %sillaba_canale 11,2 each letter is worth.0,2 !points11,2 to see your score.
    .timer17 1 7 msg %sillaba_canale 11,2 You can only choose 1 word! To delete your word, type0,2 -delete11,2 (in query to $me ).
    .timer18 1 8 msg %sillaba_canale 8,2 ““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““““
    .timer19 1 9 msg %sillaba_canale 11,2 Have Fun! 
    .timer20 1 10 set %sillaba_antiflood OFF
  }
}

on 1:notice:stringshelp*:?:{ if ($2 == %game_password) && (%gamesillaba_stato == ON) sillaba_instr }

alias sillaba_search { 
  %lineefile = $lines(sillclass.txt)
  set %i 1
  set %trovato 0
  while ( ( %i <= %lineefile ) && ( %trovato == 0 ) ) {
    %riga = $read -l %i sillclass.txt    
    %nome = $gettok(%riga,1,46)
    %sillaba_ptsquery = $gettok(%riga,2,46)
    if ( %nome == $1 ) {
      set %trovato 1 
      set %pos %i
    }
    inc %i 1 
  }
}

alias sillaba_manchesearch { 
  %lineefile = $lines(sillabamanche.txt)
  set %i 1
  set %trovato 0
  while ( ( %i <= %lineefile ) && ( %trovato == 0 ) ) {
    %riga = $read -l %i sillabamanche.txt    
    %nome = $gettok(%riga,1,46)
    if ( %nome == $1 ) {
      set %trovato 1 
      set %pos %i
    }
    inc %i 1 
  }
}

alias sillaba_ordina { 
  set %sillaba_nltxt $lines(sillclass.txt)
  set %p 1
  while (%p < %sillaba_nltxt) {
    set %x 1
    while (%x < %sillaba_nltxt) {
      set %y $calc(%x + 1 )
      set %sillaba_upper $read -l %x sillclass.txt
      set %sillaba_lower $read -l %y sillclass.txt
      set %sillaba_uppt  $gettok(%sillaba_upper,2,46)
      set %sillaba_lowpt $gettok(%sillaba_lower,2,46)
      if (%sillaba_uppt < %sillaba_lowpt) {
        write -l %x sillclass.txt %sillaba_lower
        write -l %y sillclass.txt %sillaba_upper
      }
      inc %x
    } 
    inc %p
  }
  sillaba_ordina_rovescio
}

alias sillaba_ordina_rovescio { 
  set %sillaba_nltxt $lines(sillabamanche.txt)
  set %p 1
  while (%p < %sillaba_nltxt) { 
    set %x 1
    while (%x < %sillaba_nltxt) {
      set %y $calc(%x + 1 )
      set %sillaba_upper $read -l %x sillabamanche.txt
      set %sillaba_lower $read -l %y sillabamanche.txt
      set %sillaba_uppt  $gettok(%sillaba_upper,3,46)
      set %sillaba_lowpt $gettok(%sillaba_lower,3,46)
      if (%sillaba_uppt > %sillaba_lowpt) {
        write -l %x sillabamanche.txt %sillaba_lower
        write -l %y sillabamanche.txt %sillaba_upper
      }
      inc %x
    }
    inc %p
  }
}

alias Sillaba_start_manche { if (%gamesillaba_stato == ON) {
    inc %sillaba_manchenum
    set %sillaba_hub OFF
    set %sillaba_lunghezza $rand(2,4)  
    set %sillaba_lettera $rand(a,z)
    :again
    set %sillaba_llf $lines($scriptdirdictionary\ $+ english. [ $+ [ %sillaba_lettera ] ] )
    set %sillaba_rdln $rand(1,%sillaba_llf)
    set %sillaba_extr $read($scriptdirdictionary\ $+ english. [ $+ [ %sillaba_lettera ] ] , %sillaba_rdln )
    if ($len(%sillaba_extr) < 6) { goto again }
    set %sillaba_rdst $rand(1,$calc($len(%sillaba_extr) - %sillaba_lunghezza + 1))
    set %sillaba_current $mid(%sillaba_extr,%sillaba_rdst,%sillaba_lunghezza)
    set %sillaba_current $upper(%sillaba_current)
    set %sillaba_lenmax $rand(6,15)
    if (%sillaba_mad == 1) sillaba_makevalues
    set %sillaba_bonustype $rand(1,5)
    if (%sillaba_bonustype == 1) {
      set %sillaba_bmult $rand(2,5)
      set %sillaba_bpos $rand(1,%sillaba_lenmax)
      set %sillaba_blet $rand(a,z)
      set %sillaba_bonusbanner 11,2 Bonus8,2 [Random x $+ %sillaba_bmult $+ ] 11,2Position 8,2# %sillaba_bpos $+
    }
    if (%sillaba_bonustype == 2) {
      set %sillaba_bmult $rand(2,5)
      set %sillaba_bpos $rand(1,%sillaba_lenmax)
      set %sillaba_blet $rand(a,z)
      set %sillaba_bonusbanner 11,2 Bonus8,2 [Random x $+ %sillaba_bmult $+ ] 11,2Letter8,2 $upper(%sillaba_blet) 
    }
    if (%sillaba_bonustype == 3) { set %sillaba_bonusbanner 11,2 Bonus8,2 [Vowels x2] }
    if (%sillaba_bonustype == 4) {
      set %sillaba_bmult 2
      set %sillaba_blet $rand(a,z)
      set %sillaba_bonusbanner 11,2 Bonus8,2 [x2] 11,2for each letter8,2 $upper(%sillaba_blet) 
    }
    if (%sillaba_bonustype == 5) {
      set %sillaba_bpoints $rand(2,7)
      set %sillaba_blet $rand(a,z)
      set %sillaba_bonusbanner 8,2 + $+ %sillaba_bpoints points 11if the word begins in8,2 $upper(%sillaba_blet)
    }
    .timer21 1 1 msg %sillaba_canale 9,2 ©º°¨8,2 StringS round # $+ %sillaba_manchenum $+ 9,2 ¨°º©
    .timer22 1 2 msg %sillaba_canale 11,2 The string is:8,2 %sillaba_current 
    .timer23 1 3 msg %sillaba_canale 11,2 Limit set to8,2 %sillaba_lenmax 11,2characters 
    .timer24 1 4 msg %sillaba_canale %Sillaba_bonusbanner 
    .timer25 1 5 msg %sillaba_canale 11,2 Type your word in query to8,2 $me 11,2! 
    if (%sillaba_mad == 1) {
      .timer26 1 6 msg %sillaba_canale 8,2 %sillaba_oklets
      .timer27 1 6 msg %sillaba_canale 8,2 %sillaba_badlets
    }
    .timer28 1 7 msg %sillaba_canale 8,2 You have9,2 %sillaba_durata $+ 8,2 seconds starting by now! 
    set %sillaba_manche ON
    .timeralert 1 $calc(%sillaba_durata + 2) { sillaba_alert }
  }
}

alias sillaba_makevalues {
  %sillaba_madvalues = $calc($rand(0,8)-3)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),2,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),3,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),4,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,8)-3),5,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),6,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),7,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),8,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,8)-3),9,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),10,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),11,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),12,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),13,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),14,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,8)-3),15,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),16,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),17,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),18,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),19,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),20,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,8)-3),21,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),22,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),23,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),24,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),25,32)
  %sillaba_madvalues = $instok(%sillaba_madvalues,$calc($rand(0,15)-5),26,32)
  unset %sillaba_madvaluesline 
  unset %sillaba_oklets
  unset %sillaba_badlets
  %i = 1
  while (%i <= 26) {
    if ($gettok(%sillaba_madvalues,%i,32) < 0) set %sillaba_temp 4 $+ $chr($calc(64 + %i)) $+ = $+ $gettok(%sillaba_madvalues,%i,32) 
    else set %sillaba_temp 8 $+ $chr($calc(64 + %i)) $+ = $+ $gettok(%sillaba_madvalues,%i,32)
    %sillaba_madvaluesline = $instok(%sillaba_madvaluesline,%sillaba_temp,%i,32)
    if ($gettok(%sillaba_madvalues,%i,32) < 0) set %sillaba_badlets $addtok(%sillaba_badlets,%sillaba_temp,32)
    else set %sillaba_oklets $addtok(%sillaba_oklets,%sillaba_temp,32)
    inc %i
  }
}

alias sillaba_alert {
  msg %sillaba_canale 9,2 ©º°¨8,2 10 seconds 'til the round ends. Hurry up!9,2 ¨°º©
  set %sillaba_comline `Computer` 
  set %sillaba_comline $addtok(%sillaba_comline,%sillaba_extr,46)
  if ($len(%sillaba_extr) <= %sillaba_lenmax) write sillabamanche.txt %sillaba_comline
  .timerend 1 10 sillaba_endofmanche
}

alias sillaba_endofmanche {
  set %sillaba_manche OFF
  msg %sillaba_canale 9,2 ©º°¨8,2 Time's Over!9,2 ¨°º© The string was8,2 %sillaba_current 
  if (%sillaba_bonustype == 1) msg %sillaba_canale 9,2 Bonus letter8,2 x $+ %sillaba_bmult $+ 9,2 in position 8,2# %sillaba_bpos 9,2 was 8,2 $upper(%sillaba_blet) $+ 9,2 . Results for the 8,2# %sillaba_manchenum $+ 9,2 round:
  if (%sillaba_bonustype == 2) msg %sillaba_canale 9,2 Letter8,2 $upper(%sillaba_blet) 9,2bonus8,2 x $+ %sillaba_bmult $+ 9,2 was in position 8,2# %sillaba_bpos $+ 9,2 . Results for the 8,2# %sillaba_manchenum $+ 9,2 round:
  if (%sillaba_bonustype == 3) msg %sillaba_canale 9,2 Each vowel is worth 8,2double 9,2in this round. Results for the 8,2# %sillaba_manchenum $+ 9,2 round:
  if (%sillaba_bonustype == 4) msg %sillaba_canale 9,2 All the letters8,2 $upper(%sillaba_blet) 9,2in this round are worth8,2 double9,2 . Results for the 8,2# %sillaba_manchenum $+ 9,2 round:
  if (%sillaba_bonustype == 5) msg %sillaba_canale 9,2 All the words starting in8,2 $upper(%sillaba_blet) 9,2 are worth8,2 + $+ %sillaba_bpoints points 9,2more9,2 . Results for the 8,2# %sillaba_manchenum $+ 9,2 round:
  sillaba_elabora
  close -m
  set %sillaba_timercount 1
  set %sillaba_fatto 0
  set %sillaba_ntim $calc($lines(sillabamanche.txt) + 1)
  .timermsg %sillaba_ntim 2 sillaba_resmsg
}

alias sillaba_elabora {
  set %z 1
  while ( %z <= $lines(sillabamanche.txt) ) {
    set %sillaba_finale 0
    set %sillaba_elline $read -l %z sillabamanche.txt
    set %sillaba_remains $gettok(%sillaba_elline,2,46) 
    set %sillaba_elline $instok(%sillaba_elline,-,3,46) 
    set %sillaba_elline $instok(%sillaba_elline,-,3,46) 
    if (%z == 1) { set %sillaba_elline $puttok(%sillaba_elline,Quickness[2],4,46) } 
    set %sillaba_letpos 1
    while ($len(%sillaba_remains) > 0) {
      set %sillaba_leflet $calc($len(%sillaba_remains) - 1 )
      set %sillaba_proclet $left(%sillaba_remains,1)
      set %sillaba_remains $right(%sillaba_remains,%sillaba_leflet) 
      set %sillaba_let_pts $sillaba_ptsxlet(%sillaba_proclet)
      if (%sillaba_bonustype <= 2) {
        if ( %sillaba_blet == %sillaba_proclet ) && ( %sillaba_bpos == %sillaba_letpos ) { 
          set %sillaba_let_pts $calc(%sillaba_let_pts * %sillaba_bmult) 
          set %sillaba_elbonuses $gettok(%sillaba_elline,4,46)
          if (%sillaba_elbonuses == -) { set %sillaba_elline $puttok(%sillaba_elline,Bonus[ $+ x $+ %sillaba_bmult $+ ],4,46) }
          else { 
            set %sillaba_elbonuses $addtok(%sillaba_elbonuses,Bonus[ $+ x $+ %sillaba_bmult $+ ],43) 
            set %sillaba_elline $puttok(%sillaba_elline,%sillaba_elbonuses,4,46)
          }
        }
      }
      if (%sillaba_bonustype == 4) && (%sillaba_proclet == %sillaba_blet) { set %sillaba_let_pts $calc(%sillaba_let_pts * 2) }
      if (%sillaba_bonustype == 5) && (%sillaba_proclet = %sillaba_blet) && (%sillaba_letpos == 1) { 
        set %sillaba_elbonuses $gettok(%sillaba_elline,4,46)
        if (%sillaba_elbonuses == -) { set %sillaba_elline $puttok(%sillaba_elline,FirstLetter,4,46) }
        else { 
          set %sillaba_elbonuses $addtok(%sillaba_elbonuses,FirstLetter,43) 
          set %sillaba_elline $puttok(%sillaba_elline,%sillaba_elbonuses,4,46)
        }
      }
      inc %sillaba_finale %sillaba_let_pts
      inc %sillaba_letpos 
    }
    set %sillaba_elline $puttok(%sillaba_elline,%sillaba_finale,3,46)
    write -l %z sillabamanche.txt %sillaba_elline 
    inc %z
  }
  sillaba_bonusleng
}

alias sillaba_ptsxlet {
  if (%sillaba_mad == 0) {
    if ($1 == a) && (%sillaba_bonustype != 3) return 1
    if ($1 == a) && (%sillaba_bonustype == 3) return 2
    if ($1 == b) return 5
    if ($1 == c) return 4
    if ($1 == d) return 3
    if ($1 == e) && (%sillaba_bonustype != 3) return 1
    if ($1 == e) && (%sillaba_bonustype == 3) return 2
    if ($1 == f) return 4
    if ($1 == g) return 5
    if ($1 == h) return 2
    if ($1 == i) && (%sillaba_bonustype != 3) return 1
    if ($1 == i) && (%sillaba_bonustype == 3) return 2
    if ($1 == j) return 8
    if ($1 == k) return 6
    if ($1 == l) return 3
    if ($1 == m) return 4
    if ($1 == n) return 2
    if ($1 == o) && (%sillaba_bonustype != 3) return 1
    if ($1 == o) && (%sillaba_bonustype == 3) return 2
    if ($1 == p) return 5
    if ($1 == q) return 8
    if ($1 == r) return 2
    if ($1 == s) return 2
    if ($1 == t) return 1
    if ($1 == u) && (%sillaba_bonustype != 3) return 4
    if ($1 == u) && (%sillaba_bonustype == 3) return 8
    if ($1 == v) return 6
    if ($1 == w) return 4
    if ($1 == x) return 8
    if ($1 == y) return 5
    if ($1 == z) return 8
    if ($1 == -) return 0
    if ($1 == `) return 0
  }
  if (%sillaba_mad == 1) {
    if ($1 == a) && (%sillaba_bonustype != 3) return $gettok(%sillaba_madvalues,1,32)
    if ($1 == a) && (%sillaba_bonustype == 3) return $calc(2 * $gettok(%sillaba_madvalues,1,32))
    if ($1 == b) return $gettok(%sillaba_madvalues,2,32)
    if ($1 == c) return $gettok(%sillaba_madvalues,3,32)
    if ($1 == d) return $gettok(%sillaba_madvalues,4,32)
    if ($1 == e) && (%sillaba_bonustype != 3) return $gettok(%sillaba_madvalues,5,32)
    if ($1 == e) && (%sillaba_bonustype == 3) return $calc(2 * $gettok(%sillaba_madvalues,5,32))
    if ($1 == f) return $gettok(%sillaba_madvalues,6,32)
    if ($1 == g) return $gettok(%sillaba_madvalues,7,32)
    if ($1 == h) return $gettok(%sillaba_madvalues,8,32)
    if ($1 == i) && (%sillaba_bonustype != 3) return $gettok(%sillaba_madvalues,9,32)
    if ($1 == i) && (%sillaba_bonustype == 3) return $calc(2 * $gettok(%sillaba_madvalues,9,32))
    if ($1 == j) return $gettok(%sillaba_madvalues,10,32)
    if ($1 == k) return $gettok(%sillaba_madvalues,11,32)
    if ($1 == l) return $gettok(%sillaba_madvalues,12,32)
    if ($1 == m) return $gettok(%sillaba_madvalues,13,32)
    if ($1 == n) return $gettok(%sillaba_madvalues,14,32)
    if ($1 == o) && (%sillaba_bonustype != 3) return $gettok(%sillaba_madvalues,15,32)
    if ($1 == o) && (%sillaba_bonustype == 3) return $calc(2 * $gettok(%sillaba_madvalues,15,32))
    if ($1 == p) return $gettok(%sillaba_madvalues,16,32)
    if ($1 == q) return $gettok(%sillaba_madvalues,17,32)
    if ($1 == r) return $gettok(%sillaba_madvalues,18,32)
    if ($1 == s) return $gettok(%sillaba_madvalues,19,32)
    if ($1 == t) return $gettok(%sillaba_madvalues,20,32)
    if ($1 == u) && (%sillaba_bonustype != 3) return $gettok(%sillaba_madvalues,21,32)
    if ($1 == u) && (%sillaba_bonustype == 3) return $calc(2 * $gettok(%sillaba_madvalues,21,32))
    if ($1 == v) return $gettok(%sillaba_madvalues,22,32)
    if ($1 == w) return $gettok(%sillaba_madvalues,23,32)
    if ($1 == x) return $gettok(%sillaba_madvalues,24,32)
    if ($1 == y) return $gettok(%sillaba_madvalues,25,32)
    if ($1 == z) return $gettok(%sillaba_madvalues,26,32)
    if ($1 == -) return 0
    if ($1 == `) return 0
  }
}

alias sillaba_bonusleng {
  set %z 1
  set %sillaba_blmax 0
  while (%z <= $lines(sillabamanche.txt)) {
    set %sillaba_blline $read -l %z sillabamanche.txt
    set %sillaba_blword $gettok(%sillaba_blline,2,46)
    if ($len(%sillaba_blword) > %sillaba_blmax) { set %sillaba_blmax $len(%sillaba_blword) }
    inc %z
  }
  set %z 1
  while (%z <= $lines(sillabamanche.txt)) {
    set %sillaba_blline $read -l %z sillabamanche.txt
    set %sillaba_blword $gettok(%sillaba_blline,2,46)
    if ($len(%sillaba_blword) == %sillaba_blmax) { 
      set %sillaba_bonuses $gettok(%sillaba_blline,4,46)
      if (%sillaba_bonuses == -) { set %sillaba_blline $puttok(%sillaba_blline,Length[4],4,46) | write -l %z sillabamanche.txt %sillaba_blline }
      else {      
        set %sillaba_bonuses $addtok(%sillaba_bonuses,Length[4],43)
        set %sillaba_blline $puttok(%sillaba_blline,%sillaba_bonuses,4,46)
        write -l %z sillabamanche.txt %sillaba_blline 
      }
    }
    inc %z
  }
  sillaba_bonusorig
} 

alias sillaba_bonusorig {
  set %z 1
  while (%z <= $lines(sillabamanche.txt)) {
    set %sillaba_rfwf 0    
    set %q 1
    set %sillaba_borefline $read -l %z sillabamanche.txt
    set %sillaba_borefword $gettok(%sillaba_borefline,2,46)
    while (%q <= $lines(sillabamanche.txt)) && (%sillaba_rfwf == 0) {
      set %sillaba_boline $read -l %q sillabamanche.txt
      set %sillaba_boword $gettok(%sillaba_boline,2,46)  
      if (%sillaba_borefword == %sillaba_boword) && (%z != %q) { set %sillaba_rfwf 1 }
      inc %q
    }
    if (%sillaba_rfwf == 0) {
      set %sillaba_bonuses $gettok(%sillaba_borefline,4,46)
      if (%sillaba_bonuses == -) { set %sillaba_borefline $puttok(%sillaba_borefline,Smartness[3],4,46) | write -l %z sillabamanche.txt %sillaba_borefline }
      else { 
        set %sillaba_bonuses $addtok(%sillaba_bonuses,Smartness[3],43)
        set %sillaba_borefline $puttok(%sillaba_borefline,%sillaba_bonuses,4,46)
        write -l %z sillabamanche.txt %sillaba_borefline
      }
    }
    inc %z
  }
  sillaba_attrbonus
}

alias sillaba_attrbonus {
  set %z 1
  while (%z <= $lines(sillabamanche.txt)) {
    set %sillaba_baline $read -l %z sillabamanche.txt
    set %sillaba_bapts  $gettok(%sillaba_baline,3,46)
    set %sillaba_babonu $gettok(%sillaba_baline,4,46)  
    if ( $istok(%sillaba_babonu,Quickness[2],43) == $true ) { inc %sillaba_bapts 2 }
    if ( $istok(%sillaba_babonu,Length[4],43) == $true ) { inc %sillaba_bapts 4 }
    if ( $istok(%sillaba_babonu,Smartness[3],43) == $true ) { inc %sillaba_bapts 3 }
    if ( $istok(%sillaba_babonu,FirstLetter,43) == $true ) { inc %sillaba_bapts %sillaba_bpoints }
    set %sillaba_baline $puttok(%sillaba_baline,%sillaba_bapts,3,46)
    write -l %z sillabamanche.txt %sillaba_baline
    inc %z
  }
  sillaba_agg_class
}

alias sillaba_agg_class {
  set %z 1
  while (%z <= $lines(sillabamanche.txt)) {
    set %sillaba_clline $read -l %z sillabamanche.txt
    set %sillaba_clnick $gettok(%sillaba_clline,1,46)  
    set %sillaba_manchepts $gettok(%sillaba_clline,3,46)  
    sillaba_search %sillaba_clnick
    if (%trovato == 0) {
      set %sillaba_input %sillaba_clnick
      set %sillaba_input $addtok(%sillaba_clnick,%sillaba_manchepts,46)
      write sillclass.txt %sillaba_input
    }  
    if (%trovato == 1) {
      set %sillaba_input $read -l %pos sillclass.txt
      set %sillaba_oldpts $gettok(%sillaba_input,2,46)  
      inc %sillaba_oldpts %sillaba_manchepts
      set %sillaba_input $puttok(%sillaba_input,%sillaba_oldpts,2,46)  
      write -l %pos sillclass.txt %sillaba_input
    }
    inc %z
  }
  sillaba_ordina
}

alias sillaba_resmsg {
  if ($lines(sillabamanche.txt) == $null ) || ($lines(sillabamanche.txt) == 0) && (%sillaba_fatto == 0) { msg %sillaba_canale 11,2 <- no word has been found -> A word that contains the string is 8,2 %sillaba_extr | set %sillaba_fatto 1 }
  if (%sillaba_timercount <= $lines(sillabamanche.txt)) {
    set %linez $read -l %sillaba_timercount sillabamanche.txt    
    set %nick $gettok(%linez,1,46)
    set %word $gettok(%linez,2,46)
    set %wscore $gettok(%linez,3,46)
    set %bonuses $gettok(%linez,4,46)
    msg %sillaba_canale 8,2 %nick 11,2with the word8,2 %word 11,2scores8,2 %wscore 11,2points8,2 %bonuses
  }
  if (%sillaba_timercount == $calc($lines(sillabamanche.txt) + 1)) { .timerpreclass 1 5 sillaba_prepreclass }
  inc %sillaba_timercount
}

alias sillaba_prepreclass {
  if $exists(sillabamanche.txt) { 
    set %sillaba_pnrline $read -l $lines(sillabamanche.txt) sillabamanche.txt
    set %sillaba_pnrecord $gettok(%sillaba_pnrline,3,46)
    set %sillaba_pnrkeeper $gettok(%sillaba_pnrline,1,46)
    if (%sillaba_pnrecord > %sillaba_record) && (%sillaba_mad == 0) {
      msg %sillaba_canale 11,2 New Record:8,2 ( $+ %sillaba_pnrecord $+ ) 11,2 points in a single round! Previous record was9,2 ( $+ %sillaba_record $+ ) 11,2by 9,2 %sillaba_reckeeper
      set %sillaba_record %sillaba_pnrecord 
      set %sillaba_reckeeper %sillaba_pnrkeeper
      set %sillaba_pnrline %sillaba_reckeeper $+ $chr(35) $+ %sillaba_record
      write -l 11 stringsrecords.txt %sillaba_pnrline
    }
    .remove sillabamanche.txt
  }
  .timerclass 1 5 sillaba_preclass
}

alias sillaba_preclass {
  set %timercounter 1
  .timerclass 7 2 sillaba_msgclass
}

alias sillaba_msgclass {
  if (%timercounter == 1) { msg %sillaba_canale 9,2 ©º°¨8,2 Rankings:9,2 ¨°º© }
  if (%timercounter == 2) { 
    set %sillaba_1line $read -l1 sillclass.txt
    set %sillaba_1nick $gettok(%sillaba_1line,1,46)
    set %sillaba_1pts  $gettok(%sillaba_1line,2,46)
    if (%sillaba_1pts == $null) { set %sillaba_1pts - }
    msg %sillaba_canale 8,2 1st: ( $+ 9,2 %sillaba_1pts $+ 8,2 ) %sillaba_1nick 
  }
  if (%timercounter == 3) {
    set %sillaba_2line $read -l2 sillclass.txt
    set %sillaba_2nick $gettok(%sillaba_2line,1,46)
    set %sillaba_2pts  $gettok(%sillaba_2line,2,46)
    if (%sillaba_2pts == $null) { set %sillaba_2pts - }
    msg %sillaba_canale 8,2 2nd: ( $+ 9,2 %sillaba_2pts $+ 8,2 ) %sillaba_2nick 
  }
  if (%timercounter == 4) {
    set %sillaba_3line $read -l3 sillclass.txt
    set %sillaba_3nick $gettok(%sillaba_3line,1,46)
    set %sillaba_3pts  $gettok(%sillaba_3line,2,46)
    if (%sillaba_3pts == $null) { set %sillaba_3pts - }
    msg %sillaba_canale 8,2 3rd: ( $+ 9,2 %sillaba_3pts $+ 8,2 ) %sillaba_3nick 
  }
  if (%timercounter == 5) {
    set %sillaba_4line $read -l4 sillclass.txt
    set %sillaba_4nick $gettok(%sillaba_4line,1,46)
    set %sillaba_4pts  $gettok(%sillaba_4line,2,46)
    if (%sillaba_4pts == $null) { set %sillaba_4pts - }
    msg %sillaba_canale 8,2 4th: ( $+ 9,2 %sillaba_4pts $+ 8,2 ) %sillaba_4nick 
  }
  if (%timercounter == 6) {
    set %sillaba_5line $read -l5 sillclass.txt
    set %sillaba_5nick $gettok(%sillaba_5line,1,46)
    set %sillaba_5pts  $gettok(%sillaba_5line,2,46)
    if (%sillaba_5pts == $null) { set %sillaba_5pts - }
    msg %sillaba_canale 8,2 5th: ( $+ 9,2 %sillaba_5pts $+ 8,2 ) %sillaba_5nick 
  }
  if (%timercounter == 7) { .timerhub 1 %sillaba_pausetime sillaba_hub }
  inc %timercounter
}

alias sillaba_hub {
  if ( (( %sillaba_1pts > %sillaba_2pts ) && ( %sillaba_1pts >= %sillaba_target )) || (!($exists(sillclass.txt)) && (%sillaba_target == -1)) ) { sillaba_endofgame }
  else { if (%gamesillaba_stato == ON) { msg %sillaba_canale 9,2 ©º°¨8,2 Be Ready! Next round is about to start!9,2 ¨°º© | .timernew 1 5 sillaba_start_manche | set %sillaba_hub ON } }
}

menu channel {
  Games
  .StringS
  ..Start:sillaba_start
  ..Dialog ON:dialog -m SillabaGame SillabaGame
  ..Dialog OFF:dialog -x SillabaGame SIllabaGame
  ..Pause/Resume:sillaba_pause
  ..End of game:sillaba_end_query
  ..Rules:sillaba_instr
  -
}

dialog SillabaGame {
  title "StringS Game by Anoneemo"
  size -1 -1 240 288
  box "StringS Game Commands Console", 500, 1 1 240 135, autohs
  button "Start Game", 501, 1 16 240 30, autohs
  button "Pause/Resume", 502, 1 46 240 30, autohs
  button "Show Rules", 503, 1  76 240 30, autohs
  button "End-Of-Game", 504, 1 106 240 30, autohs
  box "Adjust game timetable", 510, 1 136 240 120, autohs 
  text "Increase/Decrease round duration by 10 seconds", 511, 65 160 105 40, autohs
  button "+10", 512, 5  160 50 30, autohs
  button "-10", 513, 186 160 50 30, autohs
  text "Increase/Decrease spacing between rounds by 5 seconds", 514, 65 210 105 40, autohs
  button "+5", 515, 5  210 50 30, autohs
  button "-5", 516, 186 210 50 30, autohs
  button "Close this window", 517, 1 255 240 30, ok
} 

on 1:dialog:SillabaGame:sclick:501: { if (%sillaba_manchenum == 0) && (%sillaba_hub != ON) { sillaba_hub } }

on 1:dialog:SillabaGame:sclick:502: { sillaba_pause }

on 1:dialog:SillabaGame:sclick:503: { sillaba_instr }

on 1:dialog:SillabaGame:sclick:504: { sillaba_end_query }

on 1:dialog:SillabaGame:sclick:513: {
  if (%gamesillaba_stato != OFF) {
    if (%sillaba_durata < 50) { echo -a 4,2 You can't go lower than 40 seconds }
    else {
      dec %sillaba_durata 10
      msg %sillaba_canale 8,2 Each round now lasts 4,2 %sillaba_durata 8,2 seconds
    }
  }
}

on 1:dialog:SillabaGame:sclick:512: {
  if (%gamesillaba_stato != OFF) {
    inc %sillaba_durata 10
    msg %sillaba_canale 8,2 Each round now lasts 4,2 %sillaba_durata 8,2 seconds
  }
}


on 1:dialog:SillabaGame:sclick:516: {
  if (%gamesillaba_stato != OFF) {
    if (%sillaba_pausetime < 15) { echo -a 4,2 You can't go lower than 10 seconds }
    else {
      dec %sillaba_pausetime 5
      msg %sillaba_canale 8,2 Time between rounds has been set to 4,2 %sillaba_pausetime 8,2 seconds
    }
  }
}

on 1:dialog:SillabaGame:sclick:515: {
  if (%gamesillaba_stato != OFF) {
    inc %sillaba_pausetime 5
    msg %sillaba_canale 8,2 Time between rounds has been set to 4,2 %sillaba_pausetime 8,2 seconds
  }
}

on 1:notice:stringsm-10*:?: {
  if (%gamesillaba_stato != OFF) && ($2 == %game_password) && (%sillaba_target < 500) {
    if (%sillaba_durata < 40) { .msg $nick You can't go lower than 40 seconds }
    else {
      dec %sillaba_durata 10
      msg %sillaba_canale Each round now lasts %sillaba_durata seconds
    }
  }
}

on 1:notice:strings+10*:?: {
  if (%gamesillaba_stato != OFF) && ($2 == %game_password) && (%sillaba_target < 500) {
    inc %sillaba_durata 10
    msg %sillaba_canale Each round now lasts %sillaba_durata seconds
  }
}

on 1:notice:stringsp-5*:?:{
  if (%gamesillaba_stato != OFF) && ($2 == %game_password) {
    if (%sillaba_pausetime < 15) { .msg $nick You can't go lower than 10 seconds }
    else {
      dec %sillaba_pausetime 5
      msg %sillaba_canale Time between rounds has been set to %sillaba_pausetime seconds
    }
  }
}

on 1:notice:stringsp+5*:?:{
  if (%gamesillaba_stato != OFF)  && ($2 == %game_password) {
    inc %sillaba_pausetime 5
    msg %sillaba_canale Time between rounds has been set to %sillaba_pausetime seconds
  }
}

on 1:notice:stringstarget*:?:{
  if (%gamesillaba_stato != OFF)  && ($3 == %game_password) && ($2 > 0) {
    set %sillaba_target $2
    msg %sillaba_canale 8,2 Winning score now set to:11,2 %sillaba_target
  }
}

on 1:text:!stringshs:%game_channel:{
  set %i 1
  unset %hs
  while (%i <= 10) {
    set %line $read -l %i stringsrecords.txt
    set %nick $gettok(%line,1,35)
    set %pts $gettok(%line,2,35)
    if $calc(%i % 2) { set %line 8,2 %Pts $+ 8,2 %nick }  
    else { set %line 11,2 %Pts $+ 11,2 %nick }
    set %hs %hs $+ 4,2 •·• $+ %line
    inc %i
  }
  set %line $read -l 11 stringsrecords.txt
  set %nick $gettok(%line,1,35)
  set %pts $gettok(%line,2,35)
  msg %game_channel 9,2 ©º°¨8,2 StringS High Scores9,2 ¨°º©
  msg %game_channel 4,2 Record for a single round:8,2 %nick 4,2 $+ (8,2 %pts  4,2)
  msg %game_channel 4,2 Top Ten (average points): %hs
}
