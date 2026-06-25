# Hermes Agent Sandbox

This directory is a local sandbox for trying Nous Research Hermes Agent without
giving it access to your normal Windows home directory, browser profile, email,
SSH keys, cloud config, or this repository.

Current local status checked on 2026-06-25:

- `ollama` is installed.
- Docker/Podman are not currently on `PATH`.
- WSL is not currently installed.
- The local Ollama model list includes `mannix/hermes-3-llama-3.1-8b:Q4_K_M`.

## Safety Shape

The default path runs Hermes itself inside Docker and mounts only:

- `./data` as `/opt/data`, for Hermes config, sessions, memory, and any tokens
  you intentionally add during setup.
- `./workspace` as `/workspace`, an empty scratch directory.

It does not mount:

- `C:\Users\Owner`
- browser profiles
- email stores
- `.ssh`
- cloud CLI config
- this repository root
- the Docker socket

The runner uses Docker Compose files in this directory. The `data/` directory is
git-ignored because Hermes may write credentials there if you add providers or
messaging integrations later.

## Install Container Runtime

Docker is missing, so install Docker Desktop first. From an elevated PowerShell:

```powershell
winget install --id Docker.DockerDesktop -e --accept-package-agreements --accept-source-agreements
```

Docker Desktop on Windows usually needs WSL2. If Docker asks for WSL, install it:

```powershell
wsl --install
```

Reboot if prompted, start Docker Desktop, then verify:

```powershell
docker version
docker compose version
```

## Convenience Mode: Host Ollama

This uses your existing Windows Ollama server and the model you already have.
It is the fastest path, but the Hermes container has normal Docker bridge
networking so it can theoretically reach the internet. It still has no host file
mounts beyond `./data` and `./workspace`, and no secrets are forwarded.

Start the setup wizard:

```powershell
cd C:\Projects\StandardModel\AgentTasks\hermes-sandbox
.\run-hermes-sandbox.ps1 -Mode SetupHostOllama
```

When prompted by Hermes:

- Choose quick setup.
- Choose a custom/OpenAI-compatible endpoint.
- Use `http://host.docker.internal:11434/v1` as the API base URL.
- Leave API key blank.
- Choose `mannix/hermes-3-llama-3.1-8b:Q4_K_M`, or another local model.
- Skip messaging integrations, especially Email, for the first run.
- Keep command approvals manual; do not enable YOLO mode.

Then launch chat:

```powershell
.\run-hermes-sandbox.ps1 -Mode ChatHostOllama
```

## More Isolated Mode: Private Ollama Container

This runs Hermes and Ollama on an internal Docker network. After the model has
been pulled, the normal private compose file has no egress network attached.
This is slower because it stores a separate Ollama model copy in a Docker volume.

Pull a model into the private Ollama volume:

```powershell
.\run-hermes-sandbox.ps1 -Mode PullPrivateModel -Model "mannix/hermes-3-llama-3.1-8b:Q4_K_M"
```

Set up Hermes against the private Ollama service:

```powershell
.\run-hermes-sandbox.ps1 -Mode SetupPrivateOllama
```

When prompted, use:

- API base URL: `http://ollama:11434/v1`
- API key: blank
- Model: the model you pulled
- Messaging: skip

Then launch chat:

```powershell
.\run-hermes-sandbox.ps1 -Mode ChatPrivateOllama
```

## Stop Containers

```powershell
.\run-hermes-sandbox.ps1 -Mode StopAll
```

## Operational Rules

- Keep email, calendar, Slack, Discord, Telegram, WhatsApp, and Signal disabled
  until you have watched the sandbox behave.
- Do not add API keys unless they are throwaway keys with tight spend limits.
- Do not mount `C:\Users\Owner` or the repository root.
- Do not mount the Docker socket.
- Keep `./workspace` as the only read-write host workspace.
- Review `./data/.env` and `./data/config.yaml` after setup if Hermes creates
  them.

## If You Later Want Repo Access

Create a narrow, separate export directory instead of mounting the whole repo.
For example:

```powershell
New-Item -ItemType Directory -Force C:\Projects\hermes-export
```

Then add only that directory as a volume after you are comfortable with the
agent. For Lean work, hand it copied task packs rather than direct write access
to `C:\Projects\StandardModel`.

## References

- Hermes Docker guide: https://hermes-agent.nousresearch.com/docs/user-guide/docker
- Hermes security guide: https://hermes-agent.nousresearch.com/docs/user-guide/security
- Hermes configuration guide: https://hermes-agent.nousresearch.com/docs/user-guide/configuration
- Ollama Hermes integration: https://docs.ollama.com/integrations/hermes
