EKSound
==========

This is port of NSSound for the [Cappuccino](http://www.cappuccino.org) framework.

It works with the HTML5 "audio" tag. Please have in mind that this technique is only supported by modern browsers like Safari 4, Google Chrome or Firefox 3.5.

Also have in mind that there are still format issues for playing files like *.mp3, *.wav and *.ogg which affect all browsers.

Therefore this class will be only really useful in the near future.


## Installation

Simply import the file in your application's AppController or any other class:

	@import "EKSound.j"


## Usage

This is an example for using a sound in your application:

	var sound = [[EKSound alloc] initWithContentsOfFile:@"Resources/sound.mp3"];
	[sound play];

For adding a sound to your application and instantly playing it you can use the method `playSoundWithContentsOfFile:`

	var sound = [EKSound playSoundWithContentsOfFile:@"Resources/sound.mp3"];

The class can be controlled by the following methods:

	[sound play];

	[sound pause];

	[sound resume];

	[sound stop];

	[sound setLoops:YES];
	
	[sound setVlume:1.0];
	
	[sound setCurrentTime:87];
	
For a full class reference you can take a look at the [NSSound class reference](http://developer.apple.com/mac/library/documentation/cocoa/Reference/ApplicationKit/Classes/NSSound_Class/Reference/Reference.html).


