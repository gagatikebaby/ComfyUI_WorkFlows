$comfyRoot = 'E:\ComfiUI\ComfyUI_windows_portable_nvidia_cu126\ComfyUI_windows_portable\ComfyUI'
$sourceDir = Join-Path $comfyRoot 'output\story_pipeline_ct_references'
$targetDir = Join-Path $comfyRoot 'input'
$items = @('CHAR-NURSE','CHAR-PATIENT','SCN-RAD-DEPT','SCN-CT-ROOM','PROP-CT')
foreach ($id in $items) {
  $pattern = $id + '_reference*.png'
  $latest = Get-ChildItem -LiteralPath $sourceDir -Filter $pattern -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($latest) {
    $target = Join-Path $targetDir ($id + '_reference.png')
    Copy-Item -LiteralPath $latest.FullName -Destination $target -Force
    Write-Output "Copied $($latest.Name) -> $target"
  } else {
    Write-Warning "Missing reference image for $id"
  }
}
