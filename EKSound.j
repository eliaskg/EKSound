/*
 * CPSound.j
 *
 * Created by Elias Klughammer on December 21, 2009.
 * 
 * The MIT License
 * 
 * Copyright (c) 2009 Elias Klughammer
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */

EKSoundDidFinishPlayingNotification = @"EKSoundDidFinishPlayingNotification";

@implementation EKSound : CPObject
{
	id			_delegate;
	DOMElement	_sound;
	BOOL		_isPlaying;
	BOOL		_isPaused;
	BOOL		_loops;
	BOOL		_isFlash;
	float		_volume;
	float		_duration;
	float		_currentTime;
}

+ (EKSound)playSoundWithContentsOfFile:(CPString)aFilename
{
	var sound = [[self alloc] initWithContentsOfFile:aFilename autoBuffer:YES];
	[sound play];
	
	return sound;
}

- (id)initWithContentsOfFile:(CPString)aFilename autoBuffer:(BOOL)autobuffer
{
	self = [super init];
	
	if (self) {
		
		function filenameWithoutExtension(aFilename) {
			var filename = aFilename.match(/(.*[\/\\][^\/\\]+)\.\w+$/);
			return filename[1];
		}

		var filename = filenameWithoutExtension(aFilename);
		
		_sound = document.createElement("audio");
		
		function onEnded() {
			[self stop];

			if (!_loops)
				[self _postNotificationDidFinishPlaying];
			else
				[self play];
		}
		
		// Check for audio tag support
		if (!!(_sound.canPlayType)) {
			_isFlash = NO;
			
			if (autobuffer)
				_sound.autobuffer = "autobuffer";

			// Checks what type of files the current browser can play in the audio tag
			if (_sound.canPlayType) {
				canPlayOgg = ("no" != _sound.canPlayType("audio/ogg")) && ("" != _sound.canPlayType("audio/ogg"));
				canPlayMp3 = ("no" != _sound.canPlayType("audio/mpeg")) && ("" != _sound.canPlayType("audio/mpeg"));
				canPlayWav = ("no" != _sound.canPlayType("audio/wave")) && ("" != _sound.canPlayType("audio/wave"));
			}

			if (canPlayOgg)
				_sound.src = filename + ".ogg";
			else if (canPlayMp3)
				_sound.src = filename + ".mp3";
			else if (canPlayWav)
				_sound.src = filename + ".wav";

			document.body.appendChild(_sound);
			
			_duration = _sound.duration;
			
			_sound.addEventListener("ended", onEnded, false);
		}
		else {
			_isFlash = YES;
			// To-do: implement flash fallback
		}

		[self setVolume:1.0];

		_loops = NO;

		var timer = [CPTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
	}
	
	
	return self;
}

- (BOOL)play
{
	if ((!_isPlaying) && (!_isPaused)) {
		_sound.play();
		_isPlaying = YES;
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)pause
{
	if (_isPlaying) {
		_sound.pause();
		_isPlaying = NO;
		_isPaused = YES;
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)stop
{
	if ((_isPlaying)||(_isPaused)) {
		_sound.pause();
		[self setCurrentTime:0.0];
		_isPlaying = NO;
		_isPaused = NO;
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)resume
{
	if (_isPaused) {
		[self play];
		_isPaused = NO;
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)isPlaying
{
	return _isPlaying;
}

- (BOOL)isPaused
{
	return _isPaused;
}

- (void)setLoops:(BOOL)loops
{
	_loops = loops;
}

- (BOOL)loops
{
	return _loops;
}

- (void)setVolume:(float)aVolume
{
	_volume = aVolume;
	
	if (_isFlash)
		_sound.set("volume", aVolume);
	else
		_sound.volume = aVolume;
}

- (int)volume
{
	return _volume;
}

- (void)updateCurrentTime
{
	if (_isFlash)
		_currentTime = _sound.get("currentTime");
	else
		_currentTime = _sound.currentTime;
}

- (void)setCurrentTime:(float)currentTime
{
	_currentTime = currentTime
	if (_isFlash)
		_sound.set("currentTime", currentTime);
	else
		_sound.currentTime = currentTime;
}

- (float)currentTime
{
	return _currentTime;
}

- (float)duration
{
	return _duration;
}

- (BOOL)isFlash
{
	return _isFlash;
}

- (void)setDelegate:(id)delegate
{
    if ([_delegate respondsToSelector:@selector(soundDidFinishPlaying:)])
        [[CPNotificationCenter defaultCenter] removeObserver:_delegate name:EKSoundDidFinishPlayingNotification object:self];
    
   _delegate = delegate;
 
   if ([_delegate respondsToSelector:@selector(soundDidFinishPlaying:)])
       [[CPNotificationCenter defaultCenter] addObserver:_delegate
                                                selector:@selector(soundDidFinishPlaying:)
                                                    name:EKSoundDidFinishPlayingNotification
                                                  object:self];
}

- (id)delegate
{
	return _delegate;
}

- (void)_postNotificationDidFinishPlaying
{
    [[CPNotificationCenter defaultCenter] postNotificationName:EKSoundDidFinishPlayingNotification object:self];
}



@end

