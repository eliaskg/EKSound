EKSoundDidFinishPlayingNotification = @"EKSoundDidFinishPlayingNotification";

@implementation EKSound : CPObject
{
	id			_delegate;
	DOMElement	_sound;
	BOOL		_isPlaying;
	BOOL		_isPaused;
	BOOL		_loops;
	float		_volume;
	float		_duration;
	float		_currentTime;
}

+ (EKSound)playSoundWithContentsOfFile:(CPString)aFilename
{
	var sound = [[self alloc] initWithContentsOfFile:aFilename];
	[sound play];
	
	return sound;
}

- (id)initWithContentsOfFile:(CPString)aFilename
{
	self = [super init];
	
	if(self) {
		_sound = document.createElement("audio");
		_sound.src = aFilename;
		_sound.autobuffer = "autobuffer";
		document.body.appendChild(_sound);
		
		[self setVolume:1.0];
		
		_duration = _sound.duration;
		_loops = NO;
		
		var timer = [CPTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
		
		_sound.addEventListener("ended", function() {
			if (!_loops) {
				[self stop];
				[self _postNotificationDidFinishPlaying];
			} else {
				[self stop];
				[self play];
			}
		} );
	}
	
	return self;
}

- (BOOL)play
{
	if (!_isPlaying) {
		_sound.play();
		_isPlaying = YES;
		_isPaused = NO;
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
		[self pause];
		[self setCurrentTime:0];
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
	_sound.volume = _volume;
}

- (int)volume
{
	return _volume;
}

- (void)updateCurrentTime
{
	_currentTime = _sound.currentTime;
}

- (void)setCurrentTime:(float)currentTime
{
	_currentTime = currentTime
	_sound.currentTime = _currentTime;
}

- (float)currentTime
{
	return _currentTime;
}

- (float)duration
{
	return _duration;
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
