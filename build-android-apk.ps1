$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$envFile = Join-Path $projectPath ".env"

if (-not (Test-Path $envFile)) {
    throw "Create $envFile first. Use .env.example and fill GROQ_API_KEY."
}

$unityPath = $env:UNITY_EDITOR_PATH
if ([string]::IsNullOrWhiteSpace($unityPath)) {
    $candidate = "C:\Program Files\Unity\Hub\Editor\2022.3.59f1\Editor\Unity.exe"
    if (Test-Path $candidate) {
        $unityPath = $candidate
    }
}

if ([string]::IsNullOrWhiteSpace($unityPath) -or -not (Test-Path $unityPath)) {
    throw "Set UNITY_EDITOR_PATH to your Unity.exe path."
}

& $unityPath `
    -batchmode `
    -quit `
    -projectPath $projectPath `
    -executeMethod AndroidApkBuilder.BuildAndroidApkFromCommandLine `
    -logFile -

if ($LASTEXITCODE -ne 0) {
    throw "Unity build failed with exit code $LASTEXITCODE."
}
