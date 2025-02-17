#if !macro
import sys.*;
import sys.io.*;

import flxanimate.*;


//Backend
import core.Path;
import core.Settings;


//Handlers
import tools.SpriteHandler.*;
using tools.SpriteHandler;

import tools.*;

//Core
import core.Chart;

import core.*;
import core.ui.*;

//Controls
import core.Controls;

import tools.Binds as Key;

import core.game.*;

//Objects
import objects.*;
import objects.core.*;

import objects.Option;
import objects.Option.OptionCategory;

import states.*;
import substates.*;


//Flixel
import flixel.sound.*;
import flixel.*;
import flixel.math.*;
import flixel.util.*;
import flixel.util.typeLimit.NextState;

import flixel.FlxG.switchState;
import flixel.FlxG.resetState;

import flixel.text.*;
import flixel.text.FlxText;

import flixel.tweens.*;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.effects.FlxFlicker;

import flixel.group.*;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

using flixel.util.FlxStringUtil;

using StringTools;

import flixel.addons.transition.FlxTransitionableState.skipNextTransIn;
import flixel.addons.transition.FlxTransitionableState.skipNextTransOut;

import flixel.addons.display.FlxBackdrop;

#end

//TODO: organize this mess