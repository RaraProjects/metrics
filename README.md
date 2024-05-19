## Introduction
Metrics is a DPS parsing tool at it's core, but it can take you much deeper into the data than the typical parser. There are views to keep things simple if that's all you want, but for those hungry for the most specific of data I try to provide that in the most aesthetically pleasing and usable way possible.

I have two branches you can download from 1) Release and 2) Testing. The Testing branch is where I push my changes the most frequently. The TL;DR is that if you want more frequent changes or the newest content that are tested or mostly tested then you should try downloading from the Testing branch. If you want slower / larger changes that have more field testing then you should use the Release branch. I test the changes myself to the best of my ability and I work a couple others who also do some testing for things like alliance content. Once I feel sufficient testing has been completed I will push the changes on the Testing branch to the Release branch. My number one priority is to prevent crashes because if you crash you lose your data and that's a bad feeling.

## Table of Contents<br>
2. [Parse](#parse)
3. [Focus](#focus)
4. [Battle Log](#battle-log)
5. [Report](#report)
6. [Settings](#settings)

## Parse
This screen resembles your typical parser. It shows things like DPS, total damage, accuracy, and various damage breakdown column. There are three different modes to view the parser depending on how much detail you want to see at the time (and how much screen space you are willing to commit to that data).

### Full Mode
![image](https://github.com/RaraProjects/metrics/assets/72292212/0a4cc710-89b7-436c-aa21-f1fb269c649f)<br>
_Sample data for the Parse tab (with extra damage breakdown columns expanded)._<br>

This gives you access to the full suite of parse data and takes up the most screen space. Here are some of the more prominent features:
1. Members are ranked and displayed in decending order. You will always be shown even if you aren't in the visible ranks.
2. The parser can be configured to show up to 18 members.
3. Track your total and running accuracy. Running accuracy is your accuracy as of the last {X} amount of hits. It's beneficial to know this because you will be able to see sudden dips in accuracy (blind, food loss, etc.) much faster with the smaller lookback window. This amount of hits to look back, {X}, is configurable. The running accuracy column is called **A-{X}**.
4. Various columns can be toggled in and out to show a breakdown of where your damage is coming from.
   * This includes pet damage, healing, and deaths.
5. There is a column to show you your DPS.
   * Your DPS window is comprised of {Y} amount of buckets.
   * Every {X} amount of seconds a snapshot is taken of the damage you've done in that time and stored in a bucket.
   * The damage from each bucket is summed and averaged over the total DPS window (X * Y seconds).
   * Example:
     * Snapshot taken every X = 3 seconds.
     * A DPS window with Y = 3 buckets.
     * Total DPS window = 9 seconds.
     * The damage you do (or don't do) will affect your DPS every 3 seconds. If you do nothing your DPS will drop to zero in 9 seconds.
6. The duration timer tracks how long actions have been actively taking place. If 5 seconds pass with no one affiliated with you taking an action then the duration timer will pause and restart automatically upon the next action. Data collection is not affected by this timer.
7. A mob filter allows you to pick a mob and only see the damage that everyone did to that specific mob. The filter acts on mob name and not individual mobs. So, if you set it to "Pugil" you will see the damage that all players in the parse did to any mob named "Pugil" even if that was several individual mobs.
    
### Mini Mode
![image](https://github.com/RaraProjects/metrics/assets/72292212/aad2da70-68cb-4b31-80db-e1bcca50b4c2)<br>
_Sample data for the Parse Mini Mode (with pet data expanded)._<br>

Mini mode is just like the full mode, but it's designed to be small. You can't really add any columns here with the exception of a couple pet columns. This is the mode to use if you want to just cruise in parse mode without a large investment in screen space.

### Nano Mode
![image](https://github.com/RaraProjects/metrics/assets/72292212/b3df7378-5e75-4d6b-83ee-800599531f3a)<br>
_Sample data for the Parse Nano Mode._<br>

Nano mode is as concise as it gets. If you really only care about what you're doing then this is the mode for you. Other players will not show up here.

### DPS Graph
![image](https://github.com/RaraProjects/metrics/assets/72292212/c7e8fdad-b2d7-43f7-a5bd-52a3265dd5d0)<br>
_Sample DPS Graph data._<br>

I'm not sure how useful this is. It's off by default, but if you want to try it out you can turn it on. It doesn't take up a lot of space and it can be a nice way to visualize DPS spikes and dips. It shows up in a second window so it won't interfere with the primary Metrics window.

## Focus
Set your attention to a specific player in the parser--including yourself--and then drill down into the various aspects of your actions such as Melee, Weaponskills, Skillchains, Magic, Abilities, Pets, Defense, etc.

### Melee
![image](https://github.com/RaraProjects/metrics/assets/72292212/6466de0c-ffd9-47b1-a5e7-9fbc9f9e5dba)<br>
_Sample data for the Melee tab._
* _Multi-Attack largely from WAR/NIN Kraken Club/Ridill_
* _Enspell largely from RDM_
* _Endrain and Enaspir from DNC_
* _Count and Kick Attacks from MNK_
* _Shadows were attacks absorbed by Blink (Damage isn't the best name for the column.)_

This tab should show you most of the melee information you would be interested in. Note how you can get a main-hand and off-hand breakdown. Information only populates as it is performed so this screen usually won't be as busy as it is in the sample data pictured above. Not pictured in the image above is melee damage that heals the mob. That is tracked too.

### Ranged
![image](https://github.com/RaraProjects/metrics/assets/72292212/16a1d64f-105a-422f-bb93-09aa11513228)<br>
_Sample data for the Ranged tab._

Pretty much the same deal as melee though there are less ranged stats to pull that I'm aware of. Ninja's Daken trait is included in this tab.

### Weaponskills and Skillchains
![image](https://github.com/RaraProjects/metrics/assets/72292212/ff99b6d6-6cf2-4e74-98d8-e19cc0ee2568)<br>
_Sample data for the Weaponskills tab._

This tab breaks down your weaponskill and skillchain damage both in total and by individual weaponskill and skillchain.

### Magic
![image](https://github.com/RaraProjects/metrics/assets/72292212/aa7c164d-db8f-4269-b2ed-372787e0d52f)<br>
_Sample data for the Magic tab._

The Magic tab works about as you would expect after reading through the other tabs. It gives an overall breakdown of not only damage, but also MP spent for various categories of spells and then provides the same stats for each individual spell. There are a few additional points to note:

1. **Efficacy:** Capturing the damage and MP spent on a spell allows for the calculation of damage per MP. I call this Efficacy. This stat allows you gauge how much damage you're getting for your MP. Higher efficiancy isn't _always_ better though. For example, lower tier spells may give you higher efficacy, but come at the cost of needing to cast multiple times in order to achieve the same damage (which takes up time that you could be casting other more damaging spells).
2. **Overcure:** This stat attempts to gauge how often you are using healing spells that are of higher tier than necessary. If another player is missing 100 HP and you cast a healing spell that can heal up to 400 HP then you overcured by 300 HP. Maybe it would have been better to cast a lower tier spell. The way this is calculated isn't straightforward as it can't be measured directly. The gist is that Metrics will keep track of the max amount of HP you have healed for using any given spell. If you heal over that amount with the same spell then the overcure will be (Max Heal Registered - HP Healed). Divine Seal cures can really boost your max so I have some limits in place to try and make sure that Divine Seal doesn't ruin the calculation.
4. **Magic Bursts:** If you magic burst you will be shown how much MB damage you have done, what percent of your total damage is MB damage, and what percent of your magic damage is MB damage. Additionally, a count of magic bursts is recorded for each nuking spell.
5. **Resist Rates:** Each enfeeble spell has a "Land Rate" column. This is essentially the resist rate. If your land rate is 82% then your resist rate will be 18%.
6. **Enspell:** Enspell has a column called "Hits." That is how many times you struck the mob with your enspell i.e. how many times your enspell procced.
7. **MP Drain:** This isn't counted toward total damage. Instead, this is a measure of how much MP you've drained from mobs using spells like Aspir.
8. **Spikes:** This is how much damage you've caused by a mob hitting you and proccing a spike effect.

### Abilities
![image](https://github.com/RaraProjects/metrics/assets/72292212/0e03e2a5-3823-4e4c-bea7-d72f5137b3dd)<br>
_Sample data for the Abilities tab._

Shows how much damage you've done through the use of offensive abilities as well how many times you've used non-offensive abilities.

### Pets
![image](https://github.com/RaraProjects/metrics/assets/72292212/8caee9c4-9019-4362-9a20-f93f6b03be16)<br>
_Sample data for the Pets tab._

Similar to other tabs. Here are some interesting points:
1. Captures actions taken BST pets, avatars, and wyverns.
2. Provides a breakdown of each ability used by the pet.
3. Handles wyvern breaths including healing breaths (which are counted toward player healing).

### Defense
![image](https://github.com/RaraProjects/metrics/assets/72292212/3c067a44-c4a2-466b-967e-fcf8e94be994)<br>
_Sample data for the Defense tab._

This tab is going show how much damage you and/or your pet has taken with a breakdown of what types of damage that total damage is comprised of. Additionally, it can show you how often mobs are hitting you with critical strikes and how often you are mitigating their attacks with evasion, parry, shield, etc. A list of the mobs TP moves performed against you is shown at the bottom along with relevant stats.

**Note:** I had to manually go through a couple thousand mob TP moves and pick out which ones deal damage. I used a wiki to help with this, but sometimes the wiki isn't great. If you find that there is a mob TP move that should do damage--but isn't--or a mob that shouldn't do damage--that is--then please let me know and I can update my filter list.

## Battle Log
![xiloader_d4z50wIayI](https://github.com/RaraProjects/metrics/assets/72292212/11e6d5ef-ea25-4914-bb8e-079e8541beb7)<br>
_Sample data for the Battle Log. This is an older screenshot._

Maintain line of sight on the more important pieces of the battle without dealing with the game chat. Some neat features here are that you can see the TP at which a player used a weaponskill or see how many mobs were hit by an AOE spell.

## Report
![image](https://github.com/RaraProjects/metrics/assets/72292212/d296058f-2a69-4fb4-8e7a-eda1f121f825)<br>
_Sample data for the Report tab._

You can use the chat report quick buttons to output some reports to the chat. You can pick the chat mode. Please be courteous to your neighbors when you use anything other than party. You can also output the database and Battle Log to a CSV for your own analysis. Currently I just output a the raw data, but I'm thinking about creating a Google doc or Excel template that can be used to build higher level summaries like in the Focus tab. The CSV will contain only the data nodes that have non-zero values keep creating files as quick as possible. A note about the Battle Log is that it only keeps about 100 of the last events you've chosen to log, so if your CSV seems short that's why. I'm not quite sure how much data an addon session can handle so I'm trying to be frugal with the amount of memory I use.

The Monsters Defeated is just something I wanted to try and didn't really have a better spot for it. Sometimes it's nice to see how many crabs you've killed after grinding them out for a couple hours.

## Settings
![image](https://github.com/RaraProjects/metrics/assets/72292212/92b72c43-5824-4cd5-8a9b-ebc645f73c5d)<br>
_Example of the Settings tab._

There are a few settings that need their own spot. One of the biggest is controlling how the window looks. The Help tab contains some chat commands and the current version number. I tend to update frequently so it's always good to know which version you're on compared to the latest version.
