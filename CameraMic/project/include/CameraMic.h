#ifndef CameraMic_H_
#define CameraMic_H_

namespace cameramic
{
	const char* SetAppFilesDirectory(const char* subdir);

	void TakePhoto();

	void StartRecordingAudio();

	void StopRecordingAudio();

	void PlayAudio(const char* audioPath);
}

#endif