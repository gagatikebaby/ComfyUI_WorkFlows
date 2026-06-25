$comfy = 'E:\ComfiUI\ComfyUI_windows_portable_nvidia_cu126\ComfyUI_windows_portable\ComfyUI'
$checks = @(
  @{Name='Audio encoder'; File=Join-Path $comfy 'models\audio_encoders\chinese-wav2vec2-base.safetensors'},
  @{Name='Model patch'; File=Join-Path $comfy 'models\model_patches\infinitetalk_single.safetensors'},
  @{Name='Dialogue audio'; File=Join-Path $comfy 'input\story_pipeline_dialogue\lc_line_01.wav'},
  @{Name='Start image'; File=Join-Path $comfy 'input\ST-03_keyframe_00001_.png'}
)
foreach ($check in $checks) {
  Write-Output "`n=== $($check.Name) ==="
  if (!(Test-Path -LiteralPath $check.File)) {
    Write-Output "Missing file: $($check.File)"
  } else {
    Get-Item -LiteralPath $check.File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize
  }
}