param(
    [ValidateSet(
        "SetupHostOllama",
        "ChatHostOllama",
        "PullPrivateModel",
        "SetupPrivateOllama",
        "ChatPrivateOllama",
        "StopAll",
        "Status"
    )]
    [string]$Mode = "ChatHostOllama",

    [string]$Model = "mannix/hermes-3-llama-3.1-8b:Q4_K_M"
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSCommandPath
Set-Location -LiteralPath $Root

function Require-Docker {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        throw "Docker was not found on PATH. Install Docker Desktop, start it, then rerun this script."
    }

    & docker version *> $null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker is installed but not responding. Start Docker Desktop, then rerun this script."
    }
}

function Ensure-Dirs {
    New-Item -ItemType Directory -Force -Path "$Root\data" | Out-Null
    New-Item -ItemType Directory -Force -Path "$Root\workspace" | Out-Null
}

function Wait-PrivateOllama {
    for ($i = 0; $i -lt 60; $i++) {
        & docker compose -f compose.private-ollama.yml -f compose.private-pull.yml exec -T ollama ollama list *> $null
        if ($LASTEXITCODE -eq 0) {
            return
        }

        Start-Sleep -Seconds 2
    }

    throw "Private Ollama did not become ready within 120 seconds."
}

Require-Docker
Ensure-Dirs

switch ($Mode) {
    "SetupHostOllama" {
        & docker compose -f compose.host-ollama.yml run --rm hermes setup
        break
    }
    "ChatHostOllama" {
        & docker compose -f compose.host-ollama.yml run --rm hermes chat
        break
    }
    "PullPrivateModel" {
        $env:HERMES_MODEL = $Model
        & docker compose -f compose.private-ollama.yml -f compose.private-pull.yml up -d ollama
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        Wait-PrivateOllama
        & docker compose -f compose.private-ollama.yml -f compose.private-pull.yml run --rm model-pull
        $pullExit = $LASTEXITCODE
        & docker compose -f compose.private-ollama.yml -f compose.private-pull.yml down
        exit $pullExit
    }
    "SetupPrivateOllama" {
        & docker compose -f compose.private-ollama.yml run --rm hermes setup
        break
    }
    "ChatPrivateOllama" {
        & docker compose -f compose.private-ollama.yml run --rm hermes chat
        break
    }
    "StopAll" {
        & docker compose -f compose.host-ollama.yml down
        & docker compose -f compose.private-ollama.yml down
        break
    }
    "Status" {
        & docker compose -f compose.host-ollama.yml ps
        & docker compose -f compose.private-ollama.yml ps
        break
    }
}
