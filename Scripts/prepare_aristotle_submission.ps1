<#
.SYNOPSIS
Create a slim Aristotle submission copy of this Lean project.

.DESCRIPTION
This script copies the files Aristotle normally needs into
AgentTasks/aristotle-submit/<job-name>-project, while avoiding heavyweight local
state such as .lake, old Aristotle output, local external checkouts, and
compiled Lean artifacts.

By default it patches the copied Lake configuration to use the remote
Windows-safe Sphere-Packing-Lean fork, so the submission archive does not need
to include AgentTasks/external.

.EXAMPLE
pwsh Scripts/prepare_aristotle_submission.ps1 `
  -JobName hamming-e8-theta-modular-form-20260516 `
  -TaskNote AgentTasks/hamming-e8-theta-modular-form-construction-aristotle-2026-05-16.md

.EXAMPLE
pwsh Scripts/prepare_aristotle_submission.ps1 `
  -JobName hamming-e8-theta-dim8mf-next-20260517 `
  -TaskNote @(
    'AgentTasks/hamming-e8-theta-dim8mf-next-aristotle-2026-05-17.md',
    'AgentTasks/hamming-e8-theta-modular-form-construction-aristotle-2026-05-16.md'
  ) `
  -CheckPath PhysicsSM/Draft/E8ThetaDim8MF.lean

.EXAMPLE
pwsh Scripts/prepare_aristotle_submission.ps1 `
  -JobName hamming-e8-paper-proof `
  -IncludeSources `
  -ExtraPath Sources/Hamming_ConstructionA_E8_Manuscript_Draft.md

.EXAMPLE
pwsh Scripts/prepare_aristotle_submission.ps1 `
  -JobName hamming-e8-theta-dim8mf-next-20260517 `
  -CheckOnly `
  -CheckPath PhysicsSM/Draft/E8ThetaDim8MF.lean
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidatePattern('^[A-Za-z0-9._-]+$')]
  [string] $JobName,

  [Alias('TaskNotes', 'Note', 'Notes')]
  [string[]] $TaskNote = @(),

  [string] $TaskNotesFile,

  [Alias('ExtraPaths')]
  [string[]] $ExtraPath = @(),

  [Alias('TargetPath', 'TargetPaths')]
  [string[]] $CheckPath = @(),

  [switch] $IncludeSources,

  [switch] $IncludeScripts,

  [switch] $IncludeIndex,

  [switch] $KeepExisting,

  [switch] $NoRemoteSpherePacking,

  [switch] $CheckOnly,

  [string] $SpherePackingGit = 'https://github.com/Pandaemonium/Sphere-Packing-Lean',

  [string] $SpherePackingRev = 'windows-safe-auxiliary-renames'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-FullPath([string] $Path) {
  return [System.IO.Path]::GetFullPath($Path)
}

function Get-RelativePath([string] $BasePath, [string] $Path) {
  $baseFull = Get-FullPath $BasePath
  $pathFull = Get-FullPath $Path
  $separator = [System.IO.Path]::DirectorySeparatorChar
  $baseWithSep = $baseFull.TrimEnd('\', '/') + $separator
  if (-not $pathFull.StartsWith($baseWithSep, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Path '$pathFull' is not under '$baseFull'."
  }
  return $pathFull.Substring($baseWithSep.Length)
}

function Assert-UnderDirectory([string] $ChildPath, [string] $ParentPath) {
  $parentFull = Get-FullPath $ParentPath
  $childFull = Get-FullPath $ChildPath
  $separator = [System.IO.Path]::DirectorySeparatorChar
  $parentWithSep = $parentFull.TrimEnd('\', '/') + $separator
  if ($childFull -ne $parentFull -and
      -not $childFull.StartsWith($parentWithSep, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to operate on path outside '$parentFull': $childFull"
  }
}

function Write-Utf8NoBom([string] $Path, [string] $Text) {
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($Path, $Text.Replace("`r`n", "`n"), $utf8NoBom)
}

function Expand-ListArgument([string[]] $Items, [string] $ListFile) {
  $expanded = New-Object System.Collections.Generic.List[string]
  foreach ($item in $Items) {
    if ([string]::IsNullOrWhiteSpace($item)) {
      continue
    }
    foreach ($part in ($item -split '[;,]')) {
      $trimmed = $part.Trim().Trim('"').Trim("'")
      if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
        $expanded.Add($trimmed)
      }
    }
  }
  if (-not [string]::IsNullOrWhiteSpace($ListFile)) {
    if (-not (Test-Path -LiteralPath $ListFile -PathType Leaf)) {
      throw "List file does not exist: $ListFile"
    }
    foreach ($line in [System.IO.File]::ReadAllLines($ListFile)) {
      $trimmedLine = $line.Trim()
      if ($trimmedLine -eq '' -or $trimmedLine.StartsWith('#')) {
        continue
      }
      foreach ($part in ($trimmedLine -split '[;,]')) {
        $trimmed = $part.Trim().Trim('"').Trim("'")
        if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
          $expanded.Add($trimmed)
        }
      }
    }
  }
  return @($expanded)
}

function Remove-DirectoryWithRetry([string] $Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    return
  }
  for ($attempt = 1; $attempt -le 3; $attempt++) {
    try {
      Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
      return
    } catch {
      if ($attempt -eq 3) {
        throw "Could not remove '$Path'. A previous local smoke-test may still have lake/lean/git processes using this package. Stop those processes or remove the directory manually, then rerun."
      }
      Start-Sleep -Seconds $attempt
    }
  }
}

function Test-SkippedPath([string] $RelativePath, [bool] $IsDirectory) {
  $normalized = $RelativePath.Replace('\', '/')
  $skipPrefixes = @(
    'AgentTasks/external',
    'AgentTasks/aristotle-output',
    'AgentTasks/aristotle-submit'
  )
  foreach ($prefix in $skipPrefixes) {
    if ($normalized -eq $prefix -or $normalized.StartsWith("$prefix/", [System.StringComparison]::OrdinalIgnoreCase)) {
      return $true
    }
  }
  $parts = $RelativePath -split '[\\/]'
  $skipDirs = @('.git', '.lake', '.cache', '__pycache__')
  foreach ($part in $parts) {
    if ($skipDirs -contains $part) {
      return $true
    }
  }
  if (-not $IsDirectory) {
    $name = [System.IO.Path]::GetFileName($RelativePath)
    if ($name.EndsWith('.olean') -or $name.EndsWith('.ilean') -or $name.EndsWith('.pyc')) {
      return $true
    }
  }
  return $false
}

function Copy-CleanDirectory([string] $SourceDir, [string] $DestinationDir) {
  if (-not (Test-Path -LiteralPath $SourceDir -PathType Container)) {
    return
  }
  New-Item -ItemType Directory -Force -Path $DestinationDir | Out-Null
  Get-ChildItem -LiteralPath $SourceDir -Recurse -Force | ForEach-Object {
    $relative = Get-RelativePath $SourceDir $_.FullName
    if (Test-SkippedPath $relative $_.PSIsContainer) {
      return
    }
    $target = Join-Path $DestinationDir $relative
    if ($_.PSIsContainer) {
      New-Item -ItemType Directory -Force -Path $target | Out-Null
    } else {
      $targetDir = Split-Path -Parent $target
      New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
      Copy-Item -LiteralPath $_.FullName -Destination $target -Force
    }
  }
}

function Copy-RepoPath([string] $RepoRoot, [string] $ProjectDir, [string] $PathText) {
  $source = if ([System.IO.Path]::IsPathRooted($PathText)) {
    Get-FullPath $PathText
  } else {
    Get-FullPath (Join-Path $RepoRoot $PathText)
  }
  if (-not (Test-Path -LiteralPath $source)) {
    throw "Requested path does not exist: $PathText"
  }
  Assert-UnderDirectory $source $RepoRoot
  $relative = Get-RelativePath $RepoRoot $source
  if (Test-SkippedPath $relative (Test-Path -LiteralPath $source -PathType Container)) {
    throw "Requested path is excluded from Aristotle packages: $relative"
  }
  $target = Join-Path $ProjectDir $relative
  if (Test-Path -LiteralPath $source -PathType Container) {
    Copy-CleanDirectory $source $target
  } else {
    $targetDir = Split-Path -Parent $target
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item -LiteralPath $source -Destination $target -Force
  }
}

function Resolve-GitCommit([string] $Repository, [string] $RefName) {
  $git = Get-Command git -ErrorAction SilentlyContinue
  if ($null -eq $git) {
    return $RefName
  }
  try {
    $output = & git ls-remote $Repository $RefName 2>$null
    if ($LASTEXITCODE -eq 0 -and $output) {
      $first = @($output)[0]
      return ($first -split '\s+')[0]
    }
  } catch {
    return $RefName
  }
  return $RefName
}

function Patch-SpherePackingDependency(
  [string] $ProjectDir,
  [string] $Repository,
  [string] $RefName
) {
  $lakefile = Join-Path $ProjectDir 'lakefile.toml'
  if (Test-Path -LiteralPath $lakefile) {
    $text = [System.IO.File]::ReadAllText($lakefile)
    $pattern = '(?ms)\[\[require\]\]\s*\r?\nname\s*=\s*"SpherePacking"\s*\r?\n(?:path\s*=\s*"[^"]+"\s*\r?\n|git\s*=\s*"[^"]+"\s*\r?\nrev\s*=\s*"[^"]+"\s*\r?\n)'
    $replacement = "[[require]]`nname = `"SpherePacking`"`ngit = `"$Repository`"`nrev = `"$RefName`"`n"
    $patched = [System.Text.RegularExpressions.Regex]::Replace($text, $pattern, $replacement, 1)
    if ($patched -eq $text) {
      Write-Warning "Did not find an active SpherePacking require block in lakefile.toml."
    } else {
      Write-Utf8NoBom $lakefile $patched
    }
  }

  $manifestPath = Join-Path $ProjectDir 'lake-manifest.json'
  if (Test-Path -LiteralPath $manifestPath) {
    $commit = Resolve-GitCommit $Repository $RefName
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    $found = $false
    foreach ($package in $manifest.packages) {
      if ($package.name -eq 'SpherePacking') {
        $found = $true
        $package.PSObject.Properties.Remove('dir')
        $package | Add-Member -NotePropertyName url -NotePropertyValue $Repository -Force
        $package | Add-Member -NotePropertyName type -NotePropertyValue 'git' -Force
        $package | Add-Member -NotePropertyName subDir -NotePropertyValue $null -Force
        $package | Add-Member -NotePropertyName scope -NotePropertyValue '' -Force
        $package | Add-Member -NotePropertyName rev -NotePropertyValue $commit -Force
        $package | Add-Member -NotePropertyName inputRev -NotePropertyValue $RefName -Force
        $package | Add-Member -NotePropertyName manifestFile -NotePropertyValue 'lake-manifest.json' -Force
        $package | Add-Member -NotePropertyName inherited -NotePropertyValue $false -Force
        $package | Add-Member -NotePropertyName configFile -NotePropertyValue 'lakefile.toml' -Force
      }
    }
    if (-not $found) {
      Write-Warning "Did not find SpherePacking in lake-manifest.json."
    } else {
      Write-Utf8NoBom $manifestPath ($manifest | ConvertTo-Json -Depth 16)
    }
  }
}

function Assert-SubmissionPackage(
  [string] $RepoRoot,
  [string] $ProjectDir,
  [string] $RelativeProjectDir,
  [string[]] $CheckPaths,
  [bool] $RemoteSpherePackingEnabled,
  [string] $Repository,
  [string] $RefName
) {
  $failures = New-Object System.Collections.Generic.List[string]

  function Add-Failure([string] $Message) {
    $failures.Add($Message)
  }

  if (-not (Test-Path -LiteralPath $ProjectDir -PathType Container)) {
    throw "Submission package does not exist: $ProjectDir"
  }

  foreach ($required in @('lakefile.toml', 'lake-manifest.json', 'lean-toolchain', 'PhysicsSM')) {
    $path = Join-Path $ProjectDir $required
    if (-not (Test-Path -LiteralPath $path)) {
      Add-Failure "Missing required package item: $required"
    }
  }

  foreach ($forbidden in @('.lake', '.git', 'AgentTasks/external', 'AgentTasks/aristotle-output', 'AgentTasks/aristotle-submit')) {
    $path = Join-Path $ProjectDir $forbidden
    if (Test-Path -LiteralPath $path) {
      Add-Failure "Forbidden generated/local state is present: $forbidden"
    }
  }

  $compiledArtifacts = Get-ChildItem -LiteralPath $ProjectDir -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.Name.EndsWith('.olean') -or $_.Name.EndsWith('.ilean') } |
    Select-Object -First 5
  if ($compiledArtifacts) {
    $names = ($compiledArtifacts | ForEach-Object { Get-RelativePath $ProjectDir $_.FullName }) -join ', '
    Add-Failure "Compiled Lean artifacts are present: $names"
  }

  $manifestPath = Join-Path $ProjectDir 'lake-manifest.json'
  if (Test-Path -LiteralPath $manifestPath -PathType Leaf) {
    try {
      $null = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    } catch {
      Add-Failure "lake-manifest.json is not valid JSON."
    }
  }

  $lakefile = Join-Path $ProjectDir 'lakefile.toml'
  if (Test-Path -LiteralPath $lakefile -PathType Leaf) {
    $text = [System.IO.File]::ReadAllText($lakefile)
    if ($RemoteSpherePackingEnabled) {
      if ($text -notmatch '(?ms)\[\[require\]\]\s*\r?\nname\s*=\s*"SpherePacking"\s*\r?\ngit\s*=\s*"([^"]+)"\s*\r?\nrev\s*=\s*"([^"]+)"') {
        Add-Failure "SpherePacking require block is not patched to a git dependency."
      } else {
        if ($Matches[1] -ne $Repository) {
          Add-Failure "SpherePacking git repository mismatch: $($Matches[1])"
        }
        if ($Matches[2] -ne $RefName) {
          Add-Failure "SpherePacking git revision mismatch: $($Matches[2])"
        }
      }
    }
  }

  Write-Host ''
  Write-Host 'Submission package checks:'
  Write-Host "  Project: $RelativeProjectDir"
  Write-Host "  No .lake/.git/local output state: checked"
  Write-Host "  No compiled .olean/.ilean artifacts: checked"
  if ($RemoteSpherePackingEnabled) {
    Write-Host "  SpherePacking remote: $Repository @ $RefName"
  } else {
    Write-Host '  SpherePacking remote patch: disabled'
  }

  foreach ($pathText in $CheckPaths) {
    $target = if ([System.IO.Path]::IsPathRooted($pathText)) {
      Get-FullPath $pathText
    } else {
      Get-FullPath (Join-Path $ProjectDir $pathText)
    }
    if (-not (Test-Path -LiteralPath $target -PathType Leaf)) {
      Add-Failure "CheckPath does not exist in package: $pathText"
      continue
    }
    Assert-UnderDirectory $target $ProjectDir
    $contents = [System.IO.File]::ReadAllText($target)
    $sorryTokenCount = [System.Text.RegularExpressions.Regex]::Matches($contents, '\bsorry\b').Count
    $proofSorryLineCount = [System.Text.RegularExpressions.Regex]::Matches($contents, '(?m)^\s*sorry\b').Count
    $admitTokenCount = [System.Text.RegularExpressions.Regex]::Matches($contents, '\badmit\b').Count
    $proofAdmitLineCount = [System.Text.RegularExpressions.Regex]::Matches($contents, '(?m)^\s*admit\b').Count
    $axiomCount = [System.Text.RegularExpressions.Regex]::Matches($contents, '\baxiom\b').Count
    $unsafeCount = [System.Text.RegularExpressions.Regex]::Matches($contents, '\bunsafe\b').Count
    $relative = Get-RelativePath $ProjectDir $target
    Write-Host "  ${relative}: proof-sorry-lines=$proofSorryLineCount sorry-tokens=$sorryTokenCount proof-admit-lines=$proofAdmitLineCount admit-tokens=$admitTokenCount axiom-tokens=$axiomCount unsafe-tokens=$unsafeCount"
  }

  if ($failures.Count -gt 0) {
    $message = "Submission package check failed:`n  - " + (($failures.ToArray()) -join "`n  - ")
    throw $message
  }
}

$scriptDir = Split-Path -Parent $PSCommandPath
$repoRoot = Get-FullPath (Join-Path $scriptDir '..')
$submitRoot = Join-Path $repoRoot 'AgentTasks/aristotle-submit'
$projectName = if ($JobName.EndsWith('-project')) { $JobName } else { "$JobName-project" }
$projectDir = Join-Path $submitRoot $projectName
$relativeProjectDir = Get-RelativePath $repoRoot $projectDir
$resolvedTaskNotesFile = if ([string]::IsNullOrWhiteSpace($TaskNotesFile)) {
  ''
} elseif ([System.IO.Path]::IsPathRooted($TaskNotesFile)) {
  Get-FullPath $TaskNotesFile
} else {
  Get-FullPath (Join-Path $repoRoot $TaskNotesFile)
}
$taskNotePaths = Expand-ListArgument $TaskNote $resolvedTaskNotesFile
$extraPaths = Expand-ListArgument $ExtraPath ''
$checkPaths = Expand-ListArgument $CheckPath ''

Assert-UnderDirectory $projectDir $submitRoot

if (-not $CheckOnly) {
  New-Item -ItemType Directory -Force -Path $submitRoot | Out-Null

  if ((Test-Path -LiteralPath $projectDir) -and -not $KeepExisting) {
    Remove-DirectoryWithRetry $projectDir
  }
  New-Item -ItemType Directory -Force -Path $projectDir | Out-Null

  $rootFiles = @(
    '.editorconfig',
    '.gitattributes',
    '.gitignore',
    'AGENTS.md',
    'README.md',
    'lakefile.toml',
    'lake-manifest.json',
    'lean-toolchain',
    'PhysicsSM.lean',
    'PhysicsSMDraft.lean',
    'PhysicsSMSPL.lean'
  )

  foreach ($file in $rootFiles) {
    $source = Join-Path $repoRoot $file
    if (Test-Path -LiteralPath $source -PathType Leaf) {
      Copy-Item -LiteralPath $source -Destination (Join-Path $projectDir $file) -Force
    }
  }

  Copy-CleanDirectory (Join-Path $repoRoot 'PhysicsSM') (Join-Path $projectDir 'PhysicsSM')

  if ($IncludeSources) {
    Copy-CleanDirectory (Join-Path $repoRoot 'Sources') (Join-Path $projectDir 'Sources')
  }

  if ($IncludeScripts) {
    Copy-CleanDirectory (Join-Path $repoRoot 'Scripts') (Join-Path $projectDir 'Scripts')
  }

  if ($IncludeIndex) {
    Copy-CleanDirectory (Join-Path $repoRoot 'Index') (Join-Path $projectDir 'Index')
  }

  foreach ($path in $taskNotePaths) {
    Copy-RepoPath $repoRoot $projectDir $path
  }

  foreach ($path in $extraPaths) {
    Copy-RepoPath $repoRoot $projectDir $path
  }

  if (-not $NoRemoteSpherePacking) {
    Patch-SpherePackingDependency $projectDir $SpherePackingGit $SpherePackingRev
  }

  $summaryPath = Join-Path $projectDir 'AgentTasks/ARISTOTLE_SUBMISSION_PACKAGE.md'
  $summaryDir = Split-Path -Parent $summaryPath
  New-Item -ItemType Directory -Force -Path $summaryDir | Out-Null
  $summaryLines = @(
    '# Aristotle submission package',
    '',
    "Job name: $JobName",
    '',
    'Project directory:',
    '',
    '```text',
    $relativeProjectDir,
    '```',
    '',
    'Generated by:',
    '',
    '```text',
    'Scripts/prepare_aristotle_submission.ps1',
    '```',
    '',
    'Included by default:',
    '',
    '```text',
    'PhysicsSM/',
    'root Lean configuration files',
    'selected AgentTasks notes and extra paths',
    '```',
    '',
    'Excluded by default:',
    '',
    '```text',
    '.git',
    '.lake',
    '.cache',
    'AgentTasks/external',
    'AgentTasks/aristotle-output',
    'AgentTasks/aristotle-submit',
    '*.olean',
    '*.ilean',
    '```',
    '',
    'SpherePacking dependency:',
    '',
    '```text',
    "Remote patch enabled: $(-not $NoRemoteSpherePacking)",
    "Repository: $SpherePackingGit",
    "Revision: $SpherePackingRev",
    '```',
    '',
    'Structural checks:',
    '',
    '```text',
    'Run this script again with -CheckOnly to validate this package without starting a Lake build.',
    '```',
    '',
    'Submit with:',
    '',
    '```text',
    "aristotle submit --project-dir $relativeProjectDir ""<prompt>""",
    '```',
    '',
    'Record the returned Aristotle project ID in the task note:',
    '',
    '```yaml',
    'aristotle:',
    '  project_id: 00000000-0000-0000-0000-000000000000',
    "  submission_project: $relativeProjectDir",
    '  output_dir: AgentTasks/aristotle-output/00000000-0000-0000-0000-000000000000',
    '  status: submitted',
    '```',
    ''
  )
  $summary = $summaryLines -join "`n"
  Write-Utf8NoBom $summaryPath $summary

  Write-Host "Prepared Aristotle submission package:"
  Write-Host "  $relativeProjectDir"
} else {
  Write-Host "Checking existing Aristotle submission package:"
  Write-Host "  $relativeProjectDir"
}

Assert-SubmissionPackage $repoRoot $projectDir $relativeProjectDir $checkPaths `
  (-not $NoRemoteSpherePacking) $SpherePackingGit $SpherePackingRev

Write-Host ''
Write-Host 'Submit with:'
Write-Host "  aristotle submit --project-dir $relativeProjectDir `"<prompt>`""
Write-Host ''
Write-Host 'Record the returned Aristotle project ID in the task note as project_id.'
