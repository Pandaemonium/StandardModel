param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $PreCommitArgs
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$repoLocalCache = Join-Path $repoRoot ".cache\pre-commit-store"

New-Item -ItemType Directory -Force $repoLocalCache | Out-Null
$env:PRE_COMMIT_HOME = $repoLocalCache

if ($PreCommitArgs.Count -eq 0) {
  $PreCommitArgs = @("run", "--all-files")
}

& pre-commit @PreCommitArgs
exit $LASTEXITCODE
