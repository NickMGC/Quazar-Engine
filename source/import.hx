#if !macro
import sys.*;
import sys.io.*;

#if flxanimate import flxanimate.*; #end


//Backend
import backend.Path;
import backend.Util;

import backend.Settings;


//Core
import core.Controls as Key;
import core.Conductor;

import core.ui.Transition;

import core.ui.MenuState;
import core.ui.MenuSubstate;
import core.ui.BeatState;
import core.ui.BeatSubstate;

import core.Song;


//Objects
import objects.Alphabet;
import objects.QuazarSpr;
import objects.core.Sustain;

//Flixel
import flixel.sound.*;
import flixel.*;
import flixel.math.*;
import flixel.util.*;

import flixel.text.*;
import flixel.text.FlxText;

import flixel.tweens.*;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.group.*;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

using flixel.util.FlxStringUtil;

import flixel.addons.transition.FlxTransitionableState;
#end

using StringTools;