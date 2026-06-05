# Marine Biology Android Voice Assistant

A Unity 2022.3+ Android voice assistant ("Marina") specializing in marine biology. This project utilizes native Android speech services and the Google Gemini API to create an interactive conversational voice experience.

Unlike systems that package bulky offline model binaries, this project is designed to be **lightweight** and **responsive** by leveraging Android's built-in platform speech services.

---

## Key Features

- **Native Android Speech-to-Text (`SpeechRecognizer`)**: Uses Android's speech service for low-latency recognition. Features customizable phrase biasing to improve accuracy for complex marine terms (e.g., *cephalopods*, *bioluminescence*, *cnidarians*).
- **Native Android Text-to-Speech (`TextToSpeech`)**: Leverages the system voice synthesis engine to read assistant answers aloud.
- **Smart Gemini Integration**: Connects to the Google Gemini API to generate conversational responses guided by a specialized marine biology expert system prompt.
- **Multi-language Support**: Fully supports voice interaction, response generation, and speech synthesis in both **English** and **German**.
- **Lightweight Footprint**: Excludes heavy neural network model binaries, keeping the build size minimal and installation fast.

---

## System Architecture

```
[User Speech] 
      │
      ▼ (Microphone Input)
[Native Android SpeechRecognizer Bridge]
      │
      ▼ (Transcribed Text)
[Gemini Chat Client] (Requires internet, System Prompt: Marina Marine Expert)
      │
      ▼ (Generated Answer Text)
[Native Android TextToSpeech Bridge]
      │
      ▼ (Synthesized Audio Output)
[Device Speakers]
```

---

## Setup & Configuration

### 1. Unity Project Setup
1. Open this repository root folder as a Unity project in **Unity 2022.3 LTS** or newer.
2. Ensure the following package dependencies are resolved in the Package Manager:
   - `UniTask` (`com.cysharp.unitask`)
   - TextMeshPro

### 2. Configure Gemini API Key
You can configure the Gemini API key in one of two ways:
- **Environment File (Recommended)**: Create a `.env` file in your project root directory and add:
  ```env
  GEMINI_API_KEY=your_gemini_api_key_here
  ```
- **Inspector Override**: Select the `MarineManager` object in the demo scene, locate the `MarineDemoManager` component in the Inspector, and input your API key under `Gemini > Api Key`.

> [!WARNING]
> Do not ship a production app with a hardcoded or raw API key in the client. For production releases, proxy your requests through a secure backend proxy.

### 3. Build & Run
1. Open the main scene: `Assets/Scenes/MarineDemo.unity`.
2. In **Build Settings**, switch the platform to **Android**.
3. Connect your Android device, then click **Build and Run**.

---

## Project Structure

- **[MarineDemoManager.cs](file:///d:/opensource/demo_MarineV4/Assets/Scripts/MarineDemoManager.cs)**: Coordinates the application lifecycle, UI interaction, permission handling, and bridges.
- **[AndroidSpeechRecognizerBridge.cs](file:///d:/opensource/demo_MarineV4/Assets/Scripts/AndroidSpeechRecognizerBridge.cs)**: C# side wrapper that calls into Java classes for Android's SpeechRecognizer API.
- **[AndroidTextToSpeechBridge.cs](file:///d:/opensource/demo_MarineV4/Assets/Scripts/AndroidTextToSpeechBridge.cs)**: C# wrapper for Android's TextToSpeech API.
- **[GeminiChatClient.cs](file:///d:/opensource/demo_MarineV4/Assets/Scripts/GeminiChatClient.cs)**: Manages communication and payloads with the Google Gemini API.
- **Plugins/MarineSpeech**: Contains the underlying Java implementation (`.java` files) that handles the actual Android OS API bindings.

---

## Native APIs Referenced

- [Android SpeechRecognizer API](https://developer.android.com/reference/android/speech/SpeechRecognizer)
- [Android TextToSpeech API](https://developer.android.com/reference/android/speech/tts/TextToSpeech)
