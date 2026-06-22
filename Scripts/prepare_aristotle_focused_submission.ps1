<#
.SYNOPSIS
Create a tiny standalone Aristotle submission project for proof-only targets.

.DESCRIPTION
This helper is for targets that can be isolated to Mathlib plus a few copied
Lean files. It avoids submitting the full PhysicsSM tree, which can consume an
Aristotle budget on project builds before proof search starts.

Use the full prepare_aristotle_submission.ps1 helper when the target genuinely
depends on many repository modules. Use this helper when you have copied the
small definitions and theorem statements into a standalone source root.

.EXAMPLE
pwsh Scripts/prepare_aristotle_focused_submission.ps1 `
  -JobName null-edge-gram-cauchy-binet-core-20260621 `
  -RootModule NullEdgeGramCore `
  -SourceRoot AgentTasks/aristotle-standalone/null-edge-gram-cauchy-binet-core-20260621 `
  -LeanPath NullEdgeGramCore/WeightedCauchyBinet.lean `
  -TaskNote AgentTasks/null-edge-gram-weighted-cauchy-binet-core-aristotle-2026-06-21.md
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidatePattern('^[A-Za-z0-9._-]+$')]
  [string] $JobName,

  [Parameter(Mandatory = $true)]
  [ValidatePattern('^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)*$')]
  [string] $RootModule,

  [Parameter(Mandatory = $true)]
  [Alias('LeanPaths', 'TargetPath', 'TargetPaths')]
  [string[]] $LeanPath,

  [string] $SourceRoot = '.',

  [Alias('TaskNotes', 'Note', 'Notes')]
  [string[]] $TaskNote = @(),

  [Alias('ExtraPaths')]
  [string[]] $ExtraPath = @(),

  [string] $MathlibRev = 'v4.28.0',

  [switch] $KeepExisting,

  [switch] $CheckOnly
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

function Expand-ListArgument([string[]] $Items) {
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
        throw "Could not remove '$Path'. Stop any process using it, then rerun."
      }
      Start-Sleep -Seconds $attempt
    }
  }
}

function Copy-FileOrDirectory([string] $Source, [string] $Target) {
  if (-not (Test-Path -LiteralPath $Source)) {
    throw "Requested path does not exist: $Source"
  }
  if (Test-Path -LiteralPath $Source -PathType Container) {
    Copy-Item -LiteralPath $Source -Destination $Target -Recurse -Force
  } else {
    $targetDir = Split-Path -Parent $Target
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Target -Force
  }
}

function Convert-LeanPathToModule([string] $PathText) {
  $normalized = $PathText.Replace('\', '/').TrimStart('.', '/')
  if (-not $normalized.EndsWith('.lean', [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Lean path must end in .lean: $PathText"
  }
  $withoutExtension = $normalized.Substring(0, $normalized.Length - 5)
  return $withoutExtension.Replace('/', '.')
}

$scriptDir = Split-Path -Parent $PSCommandPath
$repoRoot = Get-FullPath (Join-Path $scriptDir '..')
$submitRoot = Join-Path $repoRoot 'AgentTasks/aristotle-submit'
$projectName = if ($JobName.EndsWith('-project')) { $JobName } else { "$JobName-project" }
$projectDir = Join-Path $submitRoot $projectName
$sourceRootFull = if ([System.IO.Path]::IsPathRooted($SourceRoot)) {
  Get-FullPath $SourceRoot
} else {
  Get-FullPath (Join-Path $repoRoot $SourceRoot)
}
$relativeProjectDir = Get-RelativePath $repoRoot $projectDir

$leanPaths = Expand-ListArgument $LeanPath
$taskNotes = Expand-ListArgument $TaskNote
$extraPaths = Expand-ListArgument $ExtraPath

Assert-UnderDirectory $projectDir $submitRoot
Assert-UnderDirectory $sourceRootFull $repoRoot

if (-not $CheckOnly) {
  New-Item -ItemType Directory -Force -Path $submitRoot | Out-Null

  if ((Test-Path -LiteralPath $projectDir) -and -not $KeepExisting) {
    Remove-DirectoryWithRetry $projectDir
  }
  New-Item -ItemType Directory -Force -Path $projectDir | Out-Null

  Write-Utf8NoBom (Join-Path $projectDir 'lean-toolchain') "leanprover/lean4:v4.28.0`n"

  $lakefile = @"
name = "$RootModule"
version = "0.1.0"
keywords = ["math"]
defaultTargets = ["$RootModule"]

[leanOptions]
relaxedAutoImplicit = false
weak.linter.mathlibStandardSet = true
maxSynthPendingDepth = 3

[[require]]
name = "mathlib"
scope = "leanprover-community"
rev = "$MathlibRev"

[[lean_lib]]
name = "$RootModule"
moreLeanArgs = ["-s65536"]

"@
  Write-Utf8NoBom (Join-Path $projectDir 'lakefile.toml') $lakefile

  $manifestPath = Join-Path $repoRoot 'lake-manifest.json'
  if (Test-Path -LiteralPath $manifestPath -PathType Leaf) {
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    $manifest.name = $RootModule
    $filtered = @()
    foreach ($package in $manifest.packages) {
      if ($package.type -ne 'path') {
        $filtered += $package
      }
    }
    $manifest.packages = $filtered
    Write-Utf8NoBom (Join-Path $projectDir 'lake-manifest.json') ($manifest | ConvertTo-Json -Depth 16)
  }

  foreach ($pathText in $leanPaths) {
    $source = Get-FullPath (Join-Path $sourceRootFull $pathText)
    Assert-UnderDirectory $source $sourceRootFull
    $relative = Get-RelativePath $sourceRootFull $source
    Copy-FileOrDirectory $source (Join-Path $projectDir $relative)
  }

  foreach ($pathText in $taskNotes + $extraPaths) {
    $source = if ([System.IO.Path]::IsPathRooted($pathText)) {
      Get-FullPath $pathText
    } else {
      Get-FullPath (Join-Path $repoRoot $pathText)
    }
    Assert-UnderDirectory $source $repoRoot
    $relative = Get-RelativePath $repoRoot $source
    Copy-FileOrDirectory $source (Join-Path $projectDir $relative)
  }

  $imports = New-Object System.Collections.Generic.List[string]
  foreach ($pathText in $leanPaths) {
    $moduleName = Convert-LeanPathToModule $pathText
    if ($moduleName -ne $RootModule) {
      $imports.Add("import $moduleName")
    }
  }
  if ($imports.Count -gt 0) {
    Write-Utf8NoBom (Join-Path $projectDir "$RootModule.lean") (($imports.ToArray() -join "`n") + "`n")
  }

  $summaryPath = Join-Path $projectDir 'AgentTasks/ARISTOTLE_FOCUSED_PACKAGE.md'
  $summary = @(
    '# Focused Aristotle submission package',
    '',
    "Job name: $JobName",
    "Root module: $RootModule",
    "Source root: $SourceRoot",
    '',
    'Included Lean paths:',
    '',
    '```text',
    ($leanPaths -join "`n"),
    '```',
    '',
    'Submit with:',
    '',
    '```text',
    "aristotle submit --project-dir $relativeProjectDir ""<prompt>""",
    '```',
    ''
  ) -join "`n"
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $summaryPath) | Out-Null
  Write-Utf8NoBom $summaryPath $summary

  Write-Host "Prepared focused Aristotle submission package:"
  Write-Host "  $relativeProjectDir"
} else {
  Write-Host "Checking focused Aristotle submission package:"
  Write-Host "  $relativeProjectDir"
}

$failures = New-Object System.Collections.Generic.List[string]
foreach ($required in @('lean-toolchain', 'lakefile.toml', "$RootModule.lean")) {
  if (-not (Test-Path -LiteralPath (Join-Path $projectDir $required))) {
    $failures.Add("Missing required package item: $required")
  }
}
foreach ($pathText in $leanPaths) {
  $target = Join-Path $projectDir $pathText
  if (-not (Test-Path -LiteralPath $target -PathType Leaf)) {
    $failures.Add("Missing Lean target: $pathText")
    continue
  }
  $contents = [System.IO.File]::ReadAllText($target)
  $proofSorryLineCount = [System.Text.RegularExpressions.Regex]::Matches($contents, '(?m)^\s*sorry\b').Count
  $proofAdmitLineCount = [System.Text.RegularExpressions.Regex]::Matches($contents, '(?m)^\s*admit\b').Count
  $axiomCount = [System.Text.RegularExpressions.Regex]::Matches($contents, '\baxiom\b').Count
  $unsafeCount = [System.Text.RegularExpressions.Regex]::Matches($contents, '\bunsafe\b').Count
  Write-Host "  ${pathText}: proof-sorry-lines=$proofSorryLineCount proof-admit-lines=$proofAdmitLineCount axiom-tokens=$axiomCount unsafe-tokens=$unsafeCount"
}

if ($failures.Count -gt 0) {
  $message = "Focused submission package check failed:`n  - " + (($failures.ToArray()) -join "`n  - ")
  throw $message
}

Write-Host ''
Write-Host 'Submit with:'
Write-Host "  aristotle submit --project-dir $relativeProjectDir `"<prompt>`""
