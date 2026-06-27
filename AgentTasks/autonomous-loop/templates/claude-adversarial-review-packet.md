# Claude adversarial review packet template

## Role

You are an adversarial reviewer for the null-edge / Furey / Standard Model
formalization program. Your job is to find semantic mismatches, overclaims,
missing hypotheses, and better theorem splits. Do not be polite at the expense
of accuracy.

The actual Lean source of every theorem and definition under review is appended
verbatim at the end of this packet (under "Verbatim source artifacts"). Base
every finding on the real statements there, not on the prose summaries in this
packet. If read-only tools are available to you, open any cited module and search
the literature index before asserting that a predicate is too weak or a result is
missing; do not assert from priors what you can verify.

## Current objective

...

## Current project state

Compact facts that bound the claim (gate status, prior no-go results, the
C0/C1 split, what is bare vs projected):

- ...

## Intended readings (claims to verify against the Lean)

For each theorem/definition under review, state what we BELIEVE it says and why
it matters. These are exactly the claims you must check against the appended
source - a kernel-checked proof of the wrong statement is the failure we fear.

- `<decl name>` (file): intended reading = ...; intended role = ...
- ...

## Theorems and definitions under review

List the declaration names and their files; the full source is appended below.

- ...

## Assumptions to attack

- ...

## Specific questions

1. ...
2. ...
3. ...

## Required output format

```text
Semantic alignment audit:
- decl name: matches intended reading? yes | no | uncertain; why; if no, what it
  actually proves

Findings:
- severity, issue, why it matters, suggested fix

Missed blockers:
- ...

Overclaim risks:
- ...

Recommended next Aristotle jobs:
- title, target, acceptance criteria

Publication language warnings:
- ...

Bottom-line verdict:
- continue | pivot | downgrade | kill route | ask Pro
```

## How this packet is sent

Send the source artifacts with `--source-file` so the reviewer sees the real
Lean, and budget for it:

```bash
python Scripts/autonomous_loop/send_claude_review.py \
    --packet <this packet>.md \
    --source-file PhysicsSM/Draft/<DeclUnderReview>.lean \
    --source-file PhysicsSM/Draft/<DependencyApi>.lean \
    --max-budget-usd 1.50 \
    --slug <short-review-slug>
```

Include every file the review's claims depend on - the theorem modules AND the
API/predicates they wrap (a wrapper cannot be judged without the thing it wraps).

By default the reviewer also gets read/search tools and read-only MCP (neo4j
read-only, scholarly, lean-explore), so it can verify cited modules, keyword- or
graph-search the paper full text, and run literature/Mathlib searches itself;
file/graph/Zotero writes are blocked. Add `--safe` to also block Bash, or
`--no-tools` for a prose-only call.
