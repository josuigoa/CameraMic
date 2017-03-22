#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "CustomCamera.h"
//#include <stdio.h>
// #include <hx/CFFI.h>
// #import "CameraMic.h"
// #import <AudioToolbox/AudioToolbox.h>

extern "C" void cameramic_filename_callback(const char *filename);

@interface CameraMic:NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
	CustomCamera* _customCamera;
	NSString* _audioPath;
	AVAudioRecorder* _audioRecorder;
	AVAudioPlayer* _audioPlayer;
}
@end

@implementation CameraMic

static NSString* _appFilesDirectory;
+(const char*)setAppFilesDirectory:(NSString*)subdir
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	_appFilesDirectory = [[paths objectAtIndex:0] stringByAppendingString:subdir];
    const char *ptr = [_appFilesDirectory cStringUsingEncoding:NSUTF8StringEncoding];
    return ptr;
}

+(const char*)getAppDirectory
{
	if(_appFilesDirectory == nil)
		[CameraMic setAppFilesDirectory:@""];
	
    const char *ptr = [_appFilesDirectory cStringUsingEncoding:NSUTF8StringEncoding];
    return ptr;
}

-(id)initCamera
{
	if (self = [super init])
	{
		_customCamera = [[CustomCamera alloc] init];

		_customCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
	    _customCamera.delegate = self;
	    
	    _customCamera.showsCameraControls = NO;
	    _customCamera.navigationBarHidden = YES;
	    _customCamera.toolbarHidden = YES;
	    
	    // overlay on top of camera lens view
	    //UIImageView *cameraOverlayView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_overlay.png"]];
	    //cameraOverlayView.alpha = 0.0f;
	    //_customCamera.cameraOverlayView = cameraOverlayView;
	    //CGRect screenRect = [[UIScreen mainScreen] bounds];
	    //CGRect berezkoFrame = cameraOverlayView.frame;
	 
	    //[cameraOverlayView setFrame:CGRectMake((screenRect.size.width - berezkoFrame.size.width) / 2, (screenRect.size.height - berezkoFrame.size.height) / 2, berezkoFrame.size.width, berezkoFrame.size.height)];
	    
	    // animate the fade in after the shutter opens
	    //[UIView beginAnimations:nil context:NULL];
	    //[UIView setAnimationDelay:2.2f];
	    //cameraOverlayView.alpha = 1.0f;
	    //[UIView commitAnimations];
	    
	    //[cameraOverlayView release];

	    [[[[UIApplication sharedApplication] keyWindow] rootViewController]  presentViewController:_customCamera animated:YES completion:nil];
	    NSLog(@"initCamera funtzioan, CameraMic.mm fitxategian");
	}

	return self;
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	UIImage* image = [info objectForKey: UIImagePickerControllerOriginalImage];

	//obtaining saving path
    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    NSString *filename = [NSString stringWithFormat:@"%d.jpg", [myDoubleNumber integerValue]];
	NSString *path = [[[NSString alloc] initWithUTF8String:[CameraMic getAppDirectory]] autorelease];
    NSString *imagePath = [path stringByAppendingPathComponent:filename];

    NSLog(@"image path argazki hartu buelta: %@", imagePath);
    /*
    //extracting image from the picker and saving it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];   
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData *webData = UIImagePNGRepresentation(editedImage);
        [webData writeToFile:imagePath atomically:YES];
    }
    */

	[UIImageJPEGRepresentation(image, 1.0) writeToFile:imagePath atomically:YES];

    [_customCamera dismissModalViewControllerAnimated:YES];
    [_customCamera.view removeFromSuperview];
    [_customCamera.view.superview removeFromSuperview];
    [_customCamera release];

    NSLog(@"imagePath: %@", imagePath);
    const char *ptr = [imagePath cStringUsingEncoding:NSUTF8StringEncoding];
	cameramic_filename_callback(ptr);
}

-(id)initMicAndStartRecording:(int)removeLastRecording
{
	if (self = [super init])
	{
		if (removeLastRecording == 1 && [_audioPath length] != 0)
		{
			NSFileManager *fileManager = [NSFileManager defaultManager];

			if ([fileManager fileExistsAtPath:_audioPath])
			{ 
				BOOL success = [fileManager removeItemAtPath:path error:&error];
        		if (!success) NSLog(@"Error: %@", [error localizedDescription]);
			}
		}

		//obtaining saving path
	    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
	    NSString *filename = [NSString stringWithFormat:@"%d.caf", [myDoubleNumber integerValue]];
	    NSString *path = [[[NSString alloc] initWithUTF8String:[CameraMic getAppDirectory]] autorelease];
	    _audioPath = [[path stringByAppendingPathComponent:filename] retain];
	    NSURL *soundFileURL = [NSURL fileURLWithPath:_audioPath];

		NSDictionary *recordSettings = [NSMutableDictionary dictionary];
		// NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:AVAudioQualityMin], AVEncoderAudioQualityKey, [NSNumber numberWithInt:16], AVEncoderBitRateKey, [NSNumber numberWithInt: 2], AVNumberOfChannelsKey, [NSNumber numberWithFloat:44100.0], AVSampleRateKey, nil];

		[recordSettings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
		[recordSettings setValue: [NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
		[recordSettings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey]; 
		[recordSettings setValue: [NSNumber numberWithInt:16] forKey:AVEncoderBitRateKey];
		// [recordSettings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
		[recordSettings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
		[recordSettings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
		[recordSettings setValue:  [NSNumber numberWithInt: AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];

		NSError *error = nil;

		_audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:recordSettings error:&error];

		if (error)
		{
			NSLog(@"error: %@", [error localizedDescription]);
		}
		else
		{
			[_audioRecorder prepareToRecord];
			[_audioRecorder record];
		}

	    // [[[[UIApplication sharedApplication] keyWindow] rootViewController]  presentViewController:_customCamera animated:YES completion:nil];
	    NSLog(@"initMic funtzioan, CameraMic.mm fitxategian");
	}

	return self;
}

-(void)stopRecordingAudio
{
	[_audioRecorder stop];
	[_audioRecorder release];

	NSLog(@"_audioPath: %@", _audioPath);
    // const char *ptr = [[_audioRecorder.url absoluteString] cStringUsingEncoding:NSUTF8StringEncoding];
    const char *ptr = [_audioPath cStringUsingEncoding:NSUTF8StringEncoding];
	cameramic_filename_callback(ptr);
	// CameraMic.eventHaxeHandler.call1("recordAudioCallback", mFileName);
}

-(void)playAudio:(NSString*)filename
{
	NSLog(@"playAudio Objective c barrenian: %@", filename);
    if (!_audioRecorder.recording)
    {
		NSError *error;

		NSLog(@"File Exists:%d",[[NSFileManager defaultManager] fileExistsAtPath:filename]);

		// NSURL *url = [[NSURL alloc] initWithString:filename];
		// NSData *audioDATA = [NSData dataWithContentsOfURL:url];
		// _audioPlayer=[[AVAudioPlayer alloc] initWithData:audioDATA error:&error];

		_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filename] error:&error];
		// _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_audioRecorder.url error:&error];

		_audioPlayer.delegate = self;

		if (error)
		      NSLog(@"Errorea gertatu da: %@", [error localizedDescription]);
		else
		      [_audioPlayer play];
   }
}

-(void)stopAudio
{
	[_audioPlayer stop];
	[_audioPlayer release];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_audioPlayer release];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
	NSLog(@"Encode Error occurred");
}


// DB sortzeko kodea
/*

NSString *docsDir;
NSArray *dirPaths;

// Get the documents directory
dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

docsDir = [dirPaths objectAtIndex:0];

// Build the path to the database file
databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contacts.db"]];

NSFileManager *filemgr = [NSFileManager defaultManager];

if ([filemgr fileExistsAtPath: databasePath ] == NO)
{
	const char *dbpath = [databasePath UTF8String];

	if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
	{
	    char *errMsg;
	    const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";

	    if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
	    {
	            status.text = @"Failed to create table";
	    }

	    sqlite3_close(contactDB);

	} else {
	    status.text = @"Failed to open/create database";
	}
}

[filemgr release];
[super viewDidLoad];

*/

@end

namespace cameramic
{
	CameraMic *_cameraMic;

	const char* SetAppFilesDirectory(const char* subdir)
	{
		return [CameraMic setAppFilesDirectory:[NSString stringWithUTF8String:subdir]];
	}

	void TakePhoto()
	{
		_cameraMic = [[CameraMic alloc] initCamera];
	}

	void StartRecordingAudio(int removeLastRecording)
	{
		_cameraMic = [[CameraMic alloc] initMicAndStartRecording:removeLastRecording];
	}

	void StopRecordingAudio()
	{
		[_cameraMic stopRecordingAudio];
	}

	void PlayAudio(const char* audioPath)
	{
		printf("%s\n", audioPath);
		if (_cameraMic)
		{
			[_cameraMic playAudio:[NSString stringWithUTF8String:audioPath]];
		}
	}

	void StopAudio()
	{
		if (_cameraMic)
		{
			[_cameraMic stopAudio];
		}
	}
}