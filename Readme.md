# Table of Contents

1.  [Setup](#org2b55292)
2.  [Reverse an animation](#org00203ee)

<a id="org2b55292"></a>

# Setup

1.  Copy the `addons` folder into your project
2.  Go to Project Settings -> Plugins
3.  Enable the addons

<a id="org00203ee"></a>

# Reverse an animation

1.  Open your animation player
2.  Set the current animation (choose in inspector)

<img width="349" alt="Screenshot 2022-02-09 at 16 50 56" src="https://user-images.githubusercontent.com/100964/153214559-a321c298-fe8c-4a39-8c40-f08c159a3399.png">

4.  Click Project Settings -> Tools -> Reverse animation

<img width="525" alt="Screenshot 2022-02-09 at 16 49 51" src="https://user-images.githubusercontent.com/100964/153214328-5ac2b2d4-f383-4870-b032-65d4cbd61fd6.png">

4. The animation will then be duplicated, reversed and saved under "{original name}-reversed"

<img width="796" alt="Screenshot 2022-02-09 at 16 51 38" src="https://user-images.githubusercontent.com/100964/153214641-b3f814da-835d-4129-ba7a-0de84d8ed0f2.png">

<a href="https://www.buymeacoffee.com/tavurth" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

## Helper utilities

### Autonaming

If you have `backwards` or `forwards` in your animation name, they will be automatically reversed.

I.e. an animation name of `run-forwards` will be reversed and the new animation will be named `run-backwards`.
I.e. an animation name of `run-backwards` will be reversed and the new animation will be named `run-forwards`.

If neither of these are found in your animation name, `-reversed` will be appended to the original name.

### Calling from code

The code is pretty performant and can be called in your `_ready` function if you need to.

On my machine (Mac OSX) reversing an animation takes around `4 ms`

You can call the `static` function `helper.reverse(animation_player, anim_name: String, new_name: String)` to reverse any animation in your animation player

You can call the `static` function `helper.reverse_current(animation_player, new_name: String)` to reverse the current animation
