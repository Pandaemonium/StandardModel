#!/usr/bin/env python3
"""Send a prepared packet to Gemini Pro and log the full prompt/response.

Default target: Gemini 3.1 Pro Preview (`gemini-3.1-pro-preview`), the current
Pro model documented by Google AI for Developers as of 2026-06-27.

The script uses the Gemini REST API directly with `GEMINI_API_KEY` or
`GOOGLE_API_KEY`. Every real call writes exactly one Markdown log under
`AgentTasks/model-calls/gemini/` containing the prompt, request metadata,
extracted response text, raw JSON response, and errors. Dry runs also create a
log unless `--no-log` is passed.
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
LOG_DIR = ROOT / "AgentTasks" / "model-calls" / "gemini"
DEFAULT_MODEL = "gemini-3.1-pro-preview"
API_BASE = "https://generativelanguage.googleapis.com/v1beta"


def slugify(text: str) -> str:
    text = text.strip().lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = text.strip("-")
    return text or "gemini-call"


def read_prompt(args: argparse.Namespace) -> str:
    pieces: list[str] = []
    if args.packet:
        pieces.append(Path(args.packet).read_text(encoding="utf-8"))
    if args.prompt:
        pieces.append(args.prompt)
    if not pieces:
        raise SystemExit("Provide --packet and/or --prompt.")
    return "\n\n".join(pieces)


def make_log_path(slug: str) -> Path:
    stamp = dt.datetime.now().strftime("%Y-%m-%d-%H%M%S")
    return LOG_DIR / f"{stamp}-{slugify(slug)}.md"


def extract_text(payload: dict[str, Any]) -> str:
    chunks: list[str] = []
    for candidate in payload.get("candidates", []) or []:
        content = candidate.get("content", {}) or {}
        for part in content.get("parts", []) or []:
            text = part.get("text")
            if isinstance(text, str):
                chunks.append(text)
    return "\n".join(chunks)


def write_log(
    *,
    path: Path,
    provider: str,
    model: str,
    status: str,
    endpoint: str,
    started: str,
    finished: str,
    prompt: str,
    response_text: str,
    raw_response: str,
    error_text: str,
    dry_run: bool,
    timeout_seconds: int,
    max_output_tokens: int,
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    body = f"""# Gemini model call log

## Metadata

- Provider: `{provider}`
- Model: `{model}`
- Status: `{status}`
- Dry run: `{dry_run}`
- Started: `{started}`
- Finished: `{finished}`
- Timeout seconds: `{timeout_seconds}`
- Max output tokens: `{max_output_tokens}`

## Endpoint

```text
{endpoint}
```

The API key is intentionally not logged.

## Prompt

```text
{prompt}
```

## Extracted response text

```text
{response_text}
```

## Raw response JSON

```json
{raw_response}
```

## Error

```text
{error_text}
```
"""
    path.write_text(body, encoding="utf-8", newline="\n")


def main() -> None:
    parser = argparse.ArgumentParser(description="Send a packet to Gemini Pro and log prompt/response.")
    parser.add_argument("--packet", help="Markdown packet path to send.")
    parser.add_argument("--prompt", help="Additional or standalone prompt text.")
    parser.add_argument("--slug", default="gemini-review", help="Slug for the log filename.")
    parser.add_argument("--model", default=DEFAULT_MODEL, help=f"Gemini model. Default: {DEFAULT_MODEL}.")
    parser.add_argument("--timeout-seconds", type=int, default=600)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--no-log", action="store_true")
    parser.add_argument("--temperature", type=float, default=0.2)
    parser.add_argument("--max-output-tokens", type=int, default=8192)
    args = parser.parse_args()

    prompt = read_prompt(args)
    endpoint = f"{API_BASE}/models/{args.model}:generateContent"
    started = dt.datetime.now().isoformat(timespec="seconds")
    status = "dry-run"
    response_text = ""
    raw_response = ""
    error_text = ""

    if args.dry_run:
        response_text = "Dry run only. No Gemini call was made."
    else:
        api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
        if not api_key:
            status = "missing-api-key"
            error_text = "Set GEMINI_API_KEY or GOOGLE_API_KEY."
        else:
            body = {
                "contents": [
                    {
                        "role": "user",
                        "parts": [{"text": prompt}],
                    }
                ],
                "generationConfig": {
                    "temperature": args.temperature,
                    "maxOutputTokens": args.max_output_tokens,
                },
            }
            data = json.dumps(body).encode("utf-8")
            request = urllib.request.Request(
                f"{endpoint}?key={api_key}",
                data=data,
                headers={"Content-Type": "application/json"},
                method="POST",
            )
            try:
                with urllib.request.urlopen(request, timeout=args.timeout_seconds) as response:
                    raw_bytes = response.read()
                payload = json.loads(raw_bytes.decode("utf-8"))
                raw_response = json.dumps(payload, indent=2)
                response_text = extract_text(payload)
                status = "completed"
            except urllib.error.HTTPError as exc:
                status = "failed"
                error_text = f"HTTP {exc.code}: {exc.read().decode('utf-8', errors='replace')}"
            except Exception as exc:  # noqa: BLE001 - log unexpected call failures.
                status = "failed"
                error_text = repr(exc)

    finished = dt.datetime.now().isoformat(timespec="seconds")
    if not args.no_log:
        log_path = make_log_path(args.slug)
        write_log(
            path=log_path,
            provider="Gemini REST API",
            model=args.model,
            status=status,
            endpoint=endpoint,
            started=started,
            finished=finished,
            prompt=prompt,
            response_text=response_text,
            raw_response=raw_response,
            error_text=error_text,
            dry_run=args.dry_run,
            timeout_seconds=args.timeout_seconds,
            max_output_tokens=args.max_output_tokens,
        )
        print(log_path)
    else:
        print(status)

    if status not in {"completed", "dry-run"}:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
