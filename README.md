# HideMyThings
 
HideMyThings is a lightweight UI automation addon for World of Warcraft 12.0 (Midnight). It cleans up your screen by hiding the HUD when it's not needed and showing it only during interaction or combat.

There is no config outside the LUA file, everyhing is hardcoded. 


Features

    Smart Fading: Most UI elements stay at 0% opacity during exploration.

    Combat & Target Awareness: Frames like the Player Frame and Action Bars automatically fade in when you enter combat or select a target.

    Micro Menu & Bag Bar: The Micro Menu (including the Housing Dashboard) and Bags are completely hidden and only appear when you hover your mouse over their positions.

    Low-Visibility Tracker: The Objective Tracker stays at 5% opacity while idle, providing a "ghost" view of your quests without being a distraction.

    Smooth Transitions: Adjustable fade-out timers prevent the UI from flickering during brief pauses.

Controlled Elements

    Player Frame

    Main Action Bar & Multi-Bars (1-6)

    Stance & Pet Bars

    Micro Menu & Bag Bar

    Objective Tracker

Technical Specifications

    Idle Delay: 1.5 seconds (The time the UI stays visible after you stop interacting).

    Fade Out Speed: 1.5 (Gradual fade for a clean transition).

    Manifest Speed: 5.0 (Near-instant appearance when combat starts or a mouseover occurs).

