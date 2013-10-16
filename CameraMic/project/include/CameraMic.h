#ifndef CameraMic_H_
#define CameraMic_H_

namespace cameramic
{
	const char* GetAppDirectoryPath();

	void GetPhoto();
	
	void StartRecordingAudio();

	void StopRecordingAudio();

	void PlayAudio(const char* audioPath);
}

#endif