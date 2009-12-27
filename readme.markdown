EKSound
==========

This is port of NSSound for the [Cappuccino](http://www.cappuccino.org) framework.

It works with the HTML5 "audio" tag. Please have in mind that this technique is only supported by modern browsers like Safari 4, Google Chrome or Firefox 3.5.


## Installation

Simply import the file in your application's AppController or any other class:

	@import "EKSound.j"


## Usage

Because of the varying file support of the main browsers you have to ensure that there are three different versions of your audio files, namely *.mp3, *.ogg and *.wav.
EKSound will check which audio file is supported in the current browser and choose it. It doesn't matter what file type you use in the `initWithContentsOfFile` method. In the example below I chose the mp3 format but I could also choose the ogg or wav format.

The `autoBuffer` method provides when the audio file should be loaded. `YES` would buffer the file immediately, `NO` would buffer it when initiating the playback.

This is an example for using a sound in your application:

	var sound = [[EKSound alloc] initWithContentsOfFile:@"Resources/sound.mp3" autoBuffer:YES];
	[sound play];

For adding a sound to your application and instantly playing it you can use the method `playSoundWithContentsOfFile:`

	var sound = [EKSound playSoundWithContentsOfFile:@"Resources/sound.mp3"];

The class can be controlled by the following methods:

	[sound play];

	[sound pause];

	[sound resume];

	[sound stop];

	[sound setLoops:YES];
	
	[sound setVolume:1.0];
	
	[sound setCurrentTime:87];
	
For a full class reference you can take a look at the [NSSound class reference](http://developer.apple.com/mac/library/documentation/cocoa/Reference/ApplicationKit/Classes/NSSound_Class/Reference/Reference.html).


