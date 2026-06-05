# Sherpa-ONNX Unity Android Demo

This is a Unity 2022.3+ Android demo scaffold for offline streaming speech-to-text and text-to-speech with the Ponyu-dev `Unity-Sherpa-ONNX` package.

The current Ponyu-dev package declares Unity 2022.3 as its minimum version. Use 2022.3 LTS or newer unless you deliberately pin an older plugin revision.

## Setup

1. Open this folder as a Unity project.
2. Let Package Manager resolve:
   - `com.ponyudev.sherpa-onnx` from GitHub
   - `com.cysharp.unitask`
   - TextMeshPro
3. Open `Tools > Sherpa-ONNX > Configure Android Build`.
4. Open `Edit > Project Settings > Sherpa ONNX` and install Android `arm64-v8a` native libraries.
5. Import or copy models into `Assets/StreamingAssets/SherpaOnnx/`:
   - ASR streaming default: `asr-models/zipformer-en/` and `asr-models/zipformer-de/`
   - TTS: `tts-models/tts-en/` and `tts-models/tts-de/`
6. Open `Tools > Sherpa-ONNX > Create Demo Scene`.
7. Open `Assets/Scenes/SherpaDemo.unity`, then build and run on Android.

## Gemini Voice Assistant Mode

The demo can run as:

`speech -> offline Sherpa STT -> Gemini text answer -> offline Sherpa TTS`

To enable it:

1. Select the `SherpaManager` object in `SherpaDemo.unity`.
2. In `SherpaDemoManager`, keep `Use Gemini` enabled.
3. Paste a Google AI Studio Gemini API key into `Gemini > Api Key`.
4. Build and run.

When Gemini is enabled and the key is set, the app sends the recognized transcript to Gemini and speaks the generated answer. If no key is set, it falls back to local echo/default response behavior.

This mode requires internet access on the device. The Android manifest includes both `RECORD_AUDIO` and `INTERNET`.

Do not ship a production app with a raw API key embedded in the client. For production, proxy Gemini through your own backend or use a short-lived token flow.

The demo manager uses the plugin's runtime services:

- `OnlineAsrService`
- `TtsService`
- `MicrophoneSource`

Android StreamingAssets extraction and native microphone fallback are handled by the plugin.

## Android SpeechRecognizer Test Mode

If you want to test Android's built-in speech recognizer on a phone, enable `Use Android Speech Recognizer` on the `SherpaManager` object before building the APK.

This path:

- Uses Android's `SpeechRecognizer` instead of streaming the raw mic audio to Groq
- Keeps the APK lightweight because it does not add new speech model files
- Requires the device to have a speech recognition service available, and offline behavior depends on the phone's installed on-device speech support

The manifest includes the `android.speech.RecognitionService` query so Android 11+ devices can see the service.

## Profiles

Runtime profile JSON lives in:

- `Assets/StreamingAssets/SherpaOnnx/online-asr-settings.json`
- `Assets/StreamingAssets/SherpaOnnx/tts-settings.json`
- `Assets/StreamingAssets/SherpaOnnx/microphone-settings.json`

Profile names must match folder names because the plugin resolves model paths as:

- `SherpaOnnx/asr-models/{profileName}`
- `SherpaOnnx/tts-models/{profileName}`

If your imported model filenames differ, update the JSON fields before building.

## Model Note

The requested NeMo Canary multilingual model is a non-streaming encoder/decoder model. It is suitable for final recognition after recording, but not for the live partial-result flow in this demo. The scaffold therefore defaults to two online Zipformer profiles for English and German. To use Canary, add an offline ASR flow with the plugin's `AsrService`, or replace the ASR profile with a streaming multilingual model supported by `OnlineAsrService`.
