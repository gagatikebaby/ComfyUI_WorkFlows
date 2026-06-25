$ErrorActionPreference = 'Stop'

$comfy = 'E:\ComfiUI\ComfyUI_windows_portable_nvidia_cu126\ComfyUI_windows_portable\ComfyUI'
$audioDir = Join-Path $comfy 'models\audio_encoders'
$patchDir = Join-Path $comfy 'models\model_patches'

New-Item -ItemType Directory -Path $audioDir -Force | Out-Null
New-Item -ItemType Directory -Path $patchDir -Force | Out-Null

$downloads = @(
  @{
    Name = 'chinese-wav2vec2-base.safetensors'
    Url = 'https://huggingface.co/TencentGameMate/chinese-wav2vec2-base/resolve/refs%2Fpr%2F1/model.safetensors'
    Destination = Join-Path $audioDir 'chinese-wav2vec2-base.safetensors'
  },
  @{
    Name = 'infinitetalk_single.safetensors'
    Url = 'https://huggingface.co/MeiGen-AI/InfiniteTalk/resolve/main/comfyui/infinitetalk_single.safetensors'
    Destination = Join-Path $patchDir 'infinitetalk_single.safetensors'
  }
)

foreach ($item in $downloads) {
  Write-Output "`n=== $($item.Name) ==="
  if (Test-Path -Path $item.Destination) {
    $existing = Get-Item -Path $item.Destination
    if ($existing.Length -gt 1048576) {
      Write-Output "Already exists: $($existing.FullName) ($($existing.Length) bytes)"
      continue
    }

    Write-Output "Removing incomplete file: $($existing.FullName) ($($existing.Length) bytes)"
    Remove-Item -Path $existing.FullName -Force
  }

  Write-Output "Downloading from: $($item.Url)"
  Write-Output "Saving to: $($item.Destination)"
  Invoke-WebRequest -Uri $item.Url -OutFile $item.Destination -UseBasicParsing
  $downloaded = Get-Item -Path $item.Destination
  Write-Output "Downloaded: $($downloaded.FullName) ($($downloaded.Length) bytes)"
}

Write-Output "`nDone. Restart ComfyUI, then select these files in AudioEncoderLoader and ModelPatchLoader."
