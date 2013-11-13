#CocoaRaffle
##Overview
**CocoaRaffle** is an extremely Quick & Dirty™ app I built when I couldn't find an easy way to give out prizes at CocoaHeadsMTL the day of my presentation.
Within 3 hours, I created this app, talking out loud to myself as I was coding, to keep my thoughts clear. Yes, I know, a sign of losing one's mind, but that's my way of not getting distracted.

In the end, the result did the job. But it sure needs polish if others wish to use it! I was asked to open-source it, so I'm releasing it as-is on github in the Public Domain. Mention me if you think it's cool.

The app displays a window containing an animated marquee at the top (in Comic Sans, to irritate @samvermette and other designers, but with abutton to switch the font and remove the text bubble. All part of the joke of the moment.)

A button reads the current roster from the Desktop and displays how many there are.

Another displays the icon of the prize and how many prizes are left.

Clicking on @samvermette's wobbling head (NSView CABasicAnimation here) starts the raffle and displays all the registered names (using an NSTimer and clunky coding just to get it to work). Then the winner.

Note: adding sounds here would be fun, but I had no time.


###How it works
I started out pretty cleanly, creating two classes of objects, LSPerson and LSPrize, each with two properties to store name, email or name and icon.

Then things became messy. Don't judge my coding by this example :-) well, ok, judge my coding by this example, but I strive to improve my style all the time.

####Participants
It imports a list of participants from a .csv file located on the Desktop, with a very specific name at this time. You will have to change it to suit your needs, or add a way to select a file.

Loading the file is done by clicking on a button... duh. 

The window displays a marquee with some text at the top. The animation for the marquee lights is really crude. The fastest way I though of doing it was simply to create three images and flip through them using an NSTimer. Obviously, there are much better ways to do this. For example, creating a custom class which would draw the lights or stars around itself and for which one could choose colors. This way it could adapt to the size of the title itself.

####Prizes
The prize list is currently a hard-coded array of names and paths to the image to use to display the prize.

It would be nice to have a UI to display the complete list and edit it... hint, hint...

####Winners
Every time a winner is declared, the name is added to a Winners.plist file stored in the current user's **Documents folder**

###Caveats
If a prize is unclaimed, you are stuck. Wait until the end to do an additional draw... a new name will be drawn (a participant cannot win twice).
**IMPORTANT** If you draw a name after all prizes are won, **that name is NOT saved in the winners.plist file!

**I REPEAT** Participants drawn after all prizes are won are NOT saved!!! Note them down! That would be the first thing to fix I think... and adding a "Draw again" button.

##Acknowledgements
I want to thanks @samvermette for pushing me into presenting at CocoaHeadsMtl. It was fun and I'll try to do it again soon. Asking me to be funny pushed me even further (yeah I know, he wasn't serious, but it makes this conversation fun). And I got to make fun of him!

Sam Vermette appears courtesy of Sam Vermette Inc. Kidding aside, you can find out all about him at www.samvermette.com and do download the amazing transitapp (http://thetransitapp.com). visit the site, it has blur. Use the app, it has style! He works with other people, including Guillaume Campagna (@gcamp on Twitter) who unknowingly allowed me to find a funny picture of Sam for the presentation. The SamVermette™ face picture is from a TV interview of Sam on the CBC (search for Sam Vermette on the Googles, you'll find it).

Sam Vermette's body was supplied by a Google Search which led to DeviantArt and this image from @silverioo: http://silverioo.deviantart.com/art/My-cartoon-full-body-346256104

No rights have been negociated yet to use this in the project... I trust you will replace it with something else, or I'll update this when he responds to my request. But it actually looks like Sam's body. Pencil included.

I also use nfarina's neat SMModelObject (https://github.com/nfarina/modelobject) to make archiving and unarchiving objects easier. Although at this time, the app doesn't actually archive the objects but recreates them on the fly. But just in case.
I prefer creating objects than dealing with NSDictionaries and keys... 

Hope you find this fun and care to update it! If you change it, please post it back, it will become handy! I'll try to put some time on this. 

Hey, this is my first Open Sourced code!

- Renaud

@rboisjoly on Twitter
rboisjoly@lagente.ca for more than 140 character nags.


