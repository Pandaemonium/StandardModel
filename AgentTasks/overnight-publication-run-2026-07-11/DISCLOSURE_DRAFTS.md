# Paper A submission disclosure drafts

These are drafting aids, not final legal or journal-policy determinations.
Adapt them to the selected venue's required headings and wording before
submission.

## Code and data availability

All Lean definitions, theorem statements, kernel-checked proofs, numerical
validation scripts, and figure-generation scripts used in this article will be
available in a versioned archive of the StandardModel repository at
`https://github.com/Pandaemonium/StandardModel`. The archival commit and DOI
will be inserted after the claims freeze. The Lean toolchain and Mathlib
revision are pinned in `lean-toolchain` and `lake-manifest.json`. A single
verification command, `python Scripts/publication/verify_null_edge_paper_a.py
--full-build`, records the environment, builds the complete repository and the
publication guard, reruns deterministic numerical checks, and emits hashed logs
and JSON results. The article uses no external experimental dataset.

## Formal-verification responsibility

Lean's kernel checks the formal theorem statements and proofs under the axiom
footprints reported in the artifact. It does not certify that the formal
definitions model nature or that the manuscript's interpretations follow from
experiment. The authors take responsibility for theorem selection, semantic
alignment, conventions, literature claims, physical interpretation, and every
statement in the article.

## AI-assisted research disclosure

OpenAI Codex, Anthropic Claude (used in the project under the name Fable), and
the Aristotle proof service were used during research for proof search, code
generation, literature triage, theorem-design suggestions, adversarial review,
and editorial drafting. Generated formal proofs were independently inspected
for statement preservation and checked by the pinned Lean kernel; generated
scientific and editorial text was reviewed and revised by the human authors.
The AI systems are not authors and bear no responsibility for the work. The
human authors are accountable for the final mathematics, physics claims,
citations, code, data, and manuscript.

## Contributor roles

Use the venue's CRediT form. Provisional fields requiring human confirmation:

- Conceptualization: Mark Schwab; additional named human contributors: TBD.
- Methodology: Mark Schwab; additional named human contributors: TBD.
- Software: Mark Schwab; additional named human contributors: TBD.
- Formal analysis: Mark Schwab; additional named human contributors: TBD.
- Investigation: Mark Schwab; additional named human contributors: TBD.
- Writing - original draft: Mark Schwab; additional named human contributors: TBD.
- Writing - review and editing: Mark Schwab; additional named human contributors: TBD.
- Visualization: Mark Schwab; additional named human contributors: TBD.
- Supervision, funding acquisition, project administration: TBD.

Do not infer affiliations, ORCIDs, funding, or additional authors from the
repository. The corresponding author must supply and approve them.

## License inventory and blocker

- This repository currently has **no root license file**. Public archival
  release is blocked until the copyright holder chooses and adds a license.
- Mathlib revision `8f9d9cff...` is Apache-2.0 licensed.
- ProofWidgets revision `be3b2e63...` is Apache-2.0 licensed.
- NumPy `2.4.3`, used only as an external numerical oracle, reports the SPDX
  expression `BSD-3-Clause AND 0BSD AND MIT AND Zlib AND CC0-1.0` for its
  bundled distribution.
- PhysLean and other public Lean packages were consulted as clean-room
  references only; they are not imported by the Paper A build. Source-specific
  mathematical provenance remains recorded in module docstrings and the
  manuscript bibliography.
- Aristotle, Codex, and Claude outputs are integrated only after human semantic
  review and kernel/build verification; the release license must cover the
  resulting repository source.
