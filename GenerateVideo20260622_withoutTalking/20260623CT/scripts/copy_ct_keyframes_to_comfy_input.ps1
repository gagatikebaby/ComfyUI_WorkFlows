$comfyRoot = 'E:\ComfiUI\ComfyUI_windows_portable_nvidia_cu126\ComfyUI_windows_portable\ComfyUI'
$sourceDir = Join-Path $comfyRoot 'output\story_pipeline_ct_keyframes'
$targetDir = Join-Path $comfyRoot 'input'
1..12 | ForEach-Object {
  $shot = 'CT{0:D3}' -f $_
  $pattern = $shot + '_keyframe*.png'
  $latest = Get-ChildItem -LiteralPath $sourceDir -Filter $pattern -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($latest) {
    $target = Join-Path $targetDir ($shot + '_keyframe_00001_.png')
    Copy-Item -LiteralPath $latest.FullName -Destination $target -Force
    Write-Output "Copied $($latest.Name) -> $target"
  } else {
    Write-Warning "Missing keyframe for $shot"
  }
}
