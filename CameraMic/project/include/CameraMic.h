#ifndef CameraMic_H_
#define CameraMic_H_

namespace cameramic
{
	const char* GetAppDirectoryPath();

	void TakePhoto();
	
	void StartRecordingAudio();

	void StopRecordingAudio();

	void PlayAudio(const char* audioPath);
}

#endif