# Overview
## What is is?
More or less a complete rewrite of the Medical System. Targetting not many changes to the basic procedures, but massive QoL improvements to surgery, and chemistry will likely have a number of changes as fallout.

## Why do we need it?
The code messed with the Honk, and it gets the Bonk.
Our code is really smelly, and a bug with the operating computer prompted me to rewrite surgery. Which, as honestly should be expected of me, snowballed into a huge refactor to support what I want to do.

## How does it work?
The basic proposal is that, instead of organs tracking all of their wounds internally, wounds are made into distinct objects with the Datum Component System. Each wound knows of certain surgical procedures that can be applied to it (With specific circumstances per-surgery). When you try to do surgery on a human, the organ that you target will take a couple starter surgeries and go around to all of its wounds, and collate a list of what surgeries you can actually perform on it, given what you've got in your hand. The organ will also be responsible for handling those basic operations like bandaging 15 wounds at once, and this should have precedence over actually trying to do surgery on Help intent. (New intent?)

Individual wounds can separately process or disable autohealing, so one really big, bleeding gash won't get better, but all those scrapes from rolling down the stairs will over time. Each wound can also handle other things separately, so your broken arm will interfere with picking things up (As it does presently), and a broken limb will slow you down or knock you over (More or less as it does presently).

Because multi-stage operations, like mending a broken bone, are a thing, certain wounds may be required to unlock other surgeries to fix 
