$ErrorActionPreference = 'Stop'

$comfyRoot = 'E:\ComfiUI\ComfyUI_windows_portable_nvidia_cu126\ComfyUI_windows_portable\ComfyUI'
$projectRoot = Split-Path -Parent $PSScriptRoot
$artifactRoot = Join-Path $projectRoot 'outputs'

$sourceDirs = @{
  references = Join-Path $comfyRoot 'output\story_pipeline_ct_references'
  keyframes = Join-Path $comfyRoot 'output\story_pipeline_ct_keyframes'
  videos = Join-Path $comfyRoot 'output\story_pipeline_ct_wan22_videos'
  videos_stable = Join-Path $comfyRoot 'output\story_pipeline_ct_wan22_stable_videos'
}

$targetDirs = @{
  references = Join-Path $artifactRoot 'references'
  keyframes = Join-Path $artifactRoot 'keyframes'
  videos = Join-Path $artifactRoot 'videos'
  videos_stable = Join-Path $artifactRoot 'videos_stable'
}

foreach ($dir in $targetDirs.Values) {
  New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

function Copy-LatestArtifact {
  param(
    [string]$Group,
    [string]$Id,
    [string]$SourceDir,
    [string]$Filter,
    [string]$TargetDir,
    [string]$TargetName
  )

  $result = [ordered]@{
    group = $Group
    id = $Id
    filter = $Filter
    found = $false
    source = $null
    target = Join-Path $TargetDir $TargetName
    bytes = 0
    last_write_time = $null
  }

  if (-not (Test-Path -LiteralPath $SourceDir)) {
    $result.missing_reason = 'source_dir_missing'
    return [pscustomobject]$result
  }

  $latest = Get-ChildItem -LiteralPath $SourceDir -Filter $Filter -File |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

  if (-not $latest) {
    $result.missing_reason = 'file_missing'
    return [pscustomobject]$result
  }

  Copy-Item -LiteralPath $latest.FullName -Destination $result.target -Force
  $copied = Get-Item -LiteralPath $result.target

  $result.found = $true
  $result.source = $latest.FullName
  $result.bytes = $copied.Length
  $result.last_write_time = $latest.LastWriteTime.ToString('s')

  return [pscustomobject]$result
}

$items = @()

$referenceIds = @(
  'CHAR-NURSE',
  'CHAR-PATIENT',
  'SCN-RAD-DEPT',
  'SCN-CT-ROOM',
  'PROP-CT'
)

foreach ($id in $referenceIds) {
  $items += Copy-LatestArtifact `
    -Group 'references' `
    -Id $id `
    -SourceDir $sourceDirs.references `
    -Filter ($id + '_reference*.png') `
    -TargetDir $targetDirs.references `
    -TargetName ($id + '_reference.png')
}

1..12 | ForEach-Object {
  $id = 'CT{0:D3}' -f $_
  $items += Copy-LatestArtifact `
    -Group 'keyframes' `
    -Id $id `
    -SourceDir $sourceDirs.keyframes `
    -Filter ($id + '_keyframe*.png') `
    -TargetDir $targetDirs.keyframes `
    -TargetName ($id + '_keyframe_00001_.png')
}

$videoSegments = @(
  'V001_CT001_CT002',
  'V002_CT002_CT003',
  'V003_CT003_CT004',
  'V004_CT004_CT005',
  'V005_CT005_CT006',
  'V006_CT006_CT007',
  'V007_CT007_CT008',
  'V008_CT008_CT009',
  'V009_CT009_CT010',
  'V010_CT010_CT011',
  'V011_CT011_CT012'
)

foreach ($id in $videoSegments) {
  $items += Copy-LatestArtifact `
    -Group 'videos' `
    -Id $id `
    -SourceDir $sourceDirs.videos `
    -Filter ($id + '*.*') `
    -TargetDir $targetDirs.videos `
    -TargetName ($id + '.mp4')
}

1..12 | ForEach-Object {
  $shot = 'CT{0:D3}' -f $_
  $id = ('V{0:D3}_{1}_stable' -f $_, $shot)
  $items += Copy-LatestArtifact `
    -Group 'videos_stable' `
    -Id $id `
    -SourceDir $sourceDirs.videos_stable `
    -Filter ($id + '*.*') `
    -TargetDir $targetDirs.videos_stable `
    -TargetName ($id + '.mp4')
}

$summary = [ordered]@{
  synced_at = (Get-Date).ToString('s')
  project_root = $projectRoot
  artifact_root = $artifactRoot
  comfy_root = $comfyRoot
  source_dirs = $sourceDirs
  target_dirs = $targetDirs
  expected = [ordered]@{
    references = 5
    keyframes = 12
    videos = 11
    videos_stable = 12
  }
  copied = [ordered]@{
    references = @($items | Where-Object { $_.group -eq 'references' -and $_.found }).Count
    keyframes = @($items | Where-Object { $_.group -eq 'keyframes' -and $_.found }).Count
    videos = @($items | Where-Object { $_.group -eq 'videos' -and $_.found }).Count
    videos_stable = @($items | Where-Object { $_.group -eq 'videos_stable' -and $_.found }).Count
  }
  missing = @($items | Where-Object { -not $_.found })
  items = $items
}

$manifestPath = Join-Path $artifactRoot 'manifest_outputs.json'
$manifestJson = $summary | ConvertTo-Json -Depth 6
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($manifestPath, $manifestJson, $utf8NoBom)

Write-Output "Synced outputs to: $artifactRoot"
Write-Output "References: $($summary.copied.references)/$($summary.expected.references)"
Write-Output "Keyframes: $($summary.copied.keyframes)/$($summary.expected.keyframes)"
Write-Output "Videos: $($summary.copied.videos)/$($summary.expected.videos)"
Write-Output "Stable videos: $($summary.copied.videos_stable)/$($summary.expected.videos_stable)"
Write-Output "Manifest: $manifestPath"
