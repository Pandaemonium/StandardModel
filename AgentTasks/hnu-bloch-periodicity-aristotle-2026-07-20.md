# Aristotle task: Bloch periodicity and the HNU homotopy obstruction

Date: 2026-07-20
Owner: Codex
Work item: `QCA-3PLUS1-001`

## Scientific target

Prove the theorem ladder in
`HNUBlochPeriodicity/Core.lean` without weakening any statement.  The key
result is that `exp (-i s k)` descends from the covering momentum line to the
Brillouin circle exactly for integral `s`.  Therefore the naive interpolation
from the identity to one lattice translation by scaling the displacement is
not a periodic Bloch homotopy at intermediate times.

This is intended to distinguish a genuinely discrete-time/QCA endpoint from a
Hamiltonian Floquet evolution that comes with a periodic intermediate-time
homotopy.  It does not by itself prove an HNU winding number.

## Requirements

- Keep the exact `2*pi` convention.
- Prove both directions of the integral classification.
- Retain the nonzero rank-one conditioned-shift control.
- Do not replace periodicity with equality at one sampled momentum.
- Do not add assumptions, compiler-trust proofs, or placeholder declarations.
- Run `lake env lean HNUBlochPeriodicity/Core.lean` first.
- End with a concise report listing solved theorems and any statement change.

## Literature consequence

The target separates endpoint topology of a lattice QCA from a contractible
continuous-time Floquet drive.  It was prompted by comparing the HNU schedule
with Higashikawa--Nakagawa--Ueda (arXiv:1806.06868), Sun et al.
(arXiv:1806.09296), Bessho--Sato (arXiv:2006.04204), and Xu--Zheng--Zhai
(arXiv:2106.14628).  The papers are theorem-shape references only; no external
code is to be copied.

aristotle:
  project_id: 4fb1a1d7-b4dc-40fd-966f-d7465e492f81
  target_file: HNUBlochPeriodicity/Core.lean
  expected_module: HNUBlochPeriodicity.Core
  submission_project: AgentTasks/aristotle-submit/hnu-bloch-periodicity-20260720-project
  output_dir: AgentTasks/aristotle-output/4fb1a1d7-b4dc-40fd-966f-d7465e492f81
  status: submitted
