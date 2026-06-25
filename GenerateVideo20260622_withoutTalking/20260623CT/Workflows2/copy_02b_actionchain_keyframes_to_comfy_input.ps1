$ErrorActionPreference = 'Stop'
$comfyRoot = 'E:\ComfiUI\ComfyUI_windows_portable_nvidia_cu126\ComfyUI_windows_portable\ComfyUI'
$sourceDir = Join-Path $comfyRoot 'output\story_pipeline_ct_actionchain_keyframes'
$targetDir = Join-Path $comfyRoot 'input'
$ids = @('CTA01', 'CTA02', 'CTA03', 'CTA04', 'CTA05', 'CTA06', 'CTB01', 'CTB02', 'CTB03', 'CTC01', 'CTC02', 'CTC03', 'CTC04', 'CTC05', 'CTC06', 'CTC07', 'CTC08', 'CTC09', 'CTC10', 'CTC11', 'CTD01', 'CTD02', 'CTD03', 'CTD04', 'CTD05', 'CTD06')
foreach ($id in $ids) {
  $pattern = $id + '_keyframe*.png'
  $latest = Get-ChildItem -LiteralPath $sourceDir -Filter $pattern -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($latest) {
    $target = Join-Path $targetDir ($id + '_keyframe_00001_.png')
    Copy-Item -LiteralPath $latest.FullName -Destination $target -Force
    Write-Output "Copied $($latest.Name) -> $target"
  } else {
    Write-Warning "Missing keyframe for $id"
  }
}
