# Glossary architecture and workflow

Status: **[LIVE]**

The Physics and Math Glossary explains project jargon, physics, and mathematics
for a high school senior. Scope: physics terms, mathematics terms, and this
project's own coinages (null-edge, soldering, doublers, and similar). Lean or
formalization tooling jargon and lab-operations vocabulary are out of scope.
It is designed for two different readers:

- agents need small, exact, low-token reads and one-record writes;
- people need search, readable explanations, links, and automatic backlinks.

The editable JSONL is the source of truth. All indexes and the browser interface
are deterministic generated views of that source.

## Architecture

```text
Glossary/
  glossary.json              small collection-level configuration
  term.schema.json           editor-facing JSON Schema
  terms/*.jsonl              canonical, topic-sharded term records
  ui/                        static browser source
Scripts/glossary/
  common.py                  loader, validator, and index helpers
  validate.py                schema checks plus unwritten-target summary
  gaps.py                    dead-end link report: the writing backlog
  ingest.py                  batch intake: normalize, shard, validate, write
  query.py                   compact exact, alias, search, and graph reads
  build.py                   deterministic index and site generator
Index/glossary/              generated; never edit by hand
  terms.compact.jsonl        shortest complete agent-readable form
  aliases.json               normalized name -> one or more term ids
  graph.json                 outgoing typed links
  backlinks.json             generated incoming typed links
  missing.json               unwritten link targets and who cites them
  site/                      browser plus lazy-loaded term JSON
```

The source is sharded by broad topic to reduce merge conflicts. A shard is still
ordinary JSONL: one complete JSON object per physical line, with no comments or
multi-line records. A term that crosses domains stays in one shard and lists all
of its domains. Its `id` never changes merely because its shard changes.

For the current scale, use intuitive shard names such as `mathematics.jsonl`,
`physics.jsonl`, or `null-edge.jsonl`. Split a busy shard when concurrent edits
or review becomes awkward; the tools read every `*.jsonl` file, so sharding does
not affect lookup or the public interface.

## Canonical record

Required fields:

| Field | Meaning |
| --- | --- |
| `id` | Stable lowercase kebab-case identifier and link target. |
| `term` | Preferred display name. |
| `domains` | One or more broad subject labels. |
| `summary` | One sentence, at most 280 characters. |
| `explanation` | Standalone plain-language definition. |
| `why` | Why the idea matters or where it is used. |
| `status` | `draft`, `reviewed`, or `stable`. |

Optional content fields are `aliases`, `kind`, `notation`, `example`, and
`conventions`. Optional relationship fields are `prerequisites`, `related`, and
`contrasts`. Provenance and repository pointers use `source_refs`, `doc_refs`,
and `lean_refs`. Omit empty optional fields; this keeps the source and agent
responses smaller.

Use `conventions` whenever a sign, normalization, handedness, basis, metric, or
other choice changes the meaning. `doc_refs` accepts repository-relative paths
or HTTP(S) URLs and is checked during validation. The complete machine-readable
contract is [`../Glossary/term.schema.json`](../Glossary/term.schema.json).

The first example is in
[`../Glossary/terms/mathematics.jsonl`](../Glossary/terms/mathematics.jsonl).

## Link model

Every concept link stores another record's `id`, never its display name:

- `prerequisites`: concepts a reader should understand first;
- `related`: useful lateral connections;
- `contrasts`: concepts likely to be confused or productively compared.

Targets do not need to exist yet. Authors should link to the concept graph
they intend, using the id the target will have when written; an unwritten
target is a normal, expected state, not an error. `validate.py` counts these
dead-end links, `gaps.py` lists them ranked by how many written terms cite
them (that ranking is the writing backlog), and the build emits the same data
as `missing.json`. The browser shows an unwritten target as a dashed
"planned" chip instead of a link. Use `validate.py --strict` only when a
fully closed graph must be enforced.

The build reverses edges into `backlinks.json` for written records, so a term
page also shows which concepts depend on, relate to, or contrast with it. The
reverse links are generated and must not be authored manually.

Names and aliases are intentionally allowed to be ambiguous. The alias index
maps a normalized spelling to a list of ids. An exact id always resolves to one
record; an ambiguous name returns a short list so an agent or reader can choose
the intended concept. This is necessary for words such as "field," which have
different meanings in physics and abstract algebra.

## Agent reads

Do not load every glossary shard into context. Use exact lookup first:

```powershell
python Scripts/glossary/query.py clifford-algebra
python Scripts/glossary/query.py "Cl(p,q)"
python Scripts/glossary/query.py clifford-algebra --neighbors
python Scripts/glossary/query.py algebra --search --limit 10
```

Output is one minified JSON value unless `--pretty` is requested. Exact lookup
accepts an id, preferred term, or alias. `--neighbors` adds one-hop outgoing and
incoming context. Search returns summaries, not full explanations.

For the smallest possible direct read after a build, search the compact index:

```powershell
rg '"id":"clifford-algebra"' Index/glossary/terms.compact.jsonl
```

The compact index uses these short keys:

| Key | Canonical field | Key | Canonical field |
| --- | --- | --- | --- |
| `t` | `term` | `a` | `aliases` |
| `d` | `domains` | `k` | `kind` |
| `s` | `summary` | `x` | `explanation` |
| `w` | `why` | `n` | `notation` |
| `e` | `example` | `cv` | `conventions` |
| `p` | `prerequisites` | `r` | `related` |
| `ct` | `contrasts` | `lr` | `lean_refs` |
| `dr` | `doc_refs` | `sr` | `source_refs` |
| `z` | `status` | `id` | `id` |

Canonical JSONL keeps readable keys for review. Only the generated aggregate
uses abbreviations.

## Agent writes

1. Choose a stable, specific id and check for an existing term or alias.
2. Add or edit exactly one line in the appropriate topic shard.
3. Explain the term without assuming unexplained jargon; link each necessary
   concept through `prerequisites` instead of recursively defining it in
   place. Link even when the target is not written yet - unwritten targets
   feed the gap report, which is how the backlog grows.
4. Mark agent-authored content `draft`.
5. Validate, build, and query the result.

For more than a handful of records, do not hand-edit shards: write the
proposed records to a JSON file (array, or object with a `records` key) and
run `python Scripts/glossary/ingest.py batch.json`. It normalizes each record
(ASCII, de-duplication, link hygiene, draft status), assigns shards by first
domain, skips unusable records with warnings, and writes nothing unless the
combined glossary still validates. Use `--dry-run` first when unsure.

```powershell
python Scripts/glossary/query.py proposed-id
rg -n 'proposed name|proposed alias' Glossary/terms
python Scripts/glossary/validate.py
python Scripts/glossary/build.py
python Scripts/glossary/query.py proposed-id --neighbors --pretty
```

The validator rejects duplicate ids, malformed fields, self-links, duplicate
relationship types, missing local document references, and schema drift.
Dangling link targets are reported as backlog, not rejected. Git supplies
authorship and modification history, so timestamps and author names are not
repeated in every record.

Review status means:

- `draft`: structurally valid, but not yet checked closely for pedagogy and
  subject accuracy;
- `reviewed`: checked by a human; agents must not promote entries out of
  `draft` (project policy: promotion is a human decision);
- `stable`: reviewed and expected to change only when the project convention or
  underlying mathematics changes.

## Human interface

Build and serve the generated browser from the repository root:

```powershell
python Scripts/glossary/build.py
python -m http.server 8000
```

Open `http://localhost:8000/Index/glossary/site/`. The interface provides term
and definition search, domain and review-status filters, aliases, explanations,
examples, convention notes, typed links, backlinks, and repository references.
Its hash URL, such as `#clifford-algebra`, is a stable link to a concept.

At startup the browser loads only `manifest.json` and a compact search index.
It fetches a full term record only when that term is opened. This avoids sending
thousands of full explanations to every browser visit.

## Generated-output policy

`Index/glossary/` is ignored by Git and can always be reconstructed. Never fix a
generated file by hand; fix the canonical record, schema, UI source, or builder
and run the build again. The build is sorted and contains no timestamps, making
identical source produce identical output.

The older `PhysicsSM/Docs/Glossary.lean` remains the concise Lean-facing notation
and convention table. It is a useful `doc_ref`, but it is not the source for the
plain-language glossary and is not generated by this pipeline.

JSONL remains a suitable source well beyond thousands of terms. If the browser
eventually needs richer full-text ranking or the collection reaches hundreds of
thousands of records, add a generated SQLite/FTS or search-service view. Keep
JSONL as the reviewable source unless there is a concrete reason to migrate it.
