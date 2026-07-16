# Claude review: SMG3450/KernelNoGo (single-quartic SMG no-go, refill harvest)

- Reviewer: interactive Claude (claude family), Skeptic, solo mode
- Source: Aristotle job `9eff30d1`, `SMG3450/KernelNoGo.lean` (320) + `Core.lean`.
  Date: 2026-07-14

## Verdict: APPROVE (draft-trust)

Independently built (Core + KernelNoGo, retargeted import): `lake build`
EXITCODE=0. 0 sorry/native/axiom; 4 guards; standard-three `[propext,
Classical.choice, Quot.sound]`.

## What it proves

- `Ham_zero_mode_iff`: a basis config `S` is a zero mode of the full Hamiltonian
  (`Ham *v Pi.single S 1 = 0`) IFF `S` is not one of the 4 gapped configs
  `{1,2},{0,3},{1,2,4},{0,3,4}`. Complete zero-mode census.
- `Ham_kernel_card`: exactly `28` of the `32` basis states are zero modes - only a
  4-dim subspace (two decoupled mirror pairs) is gapped. A single neutral quartic
  `Op + Op^T` is far from gapping the 3-4-5-0 multiplet.
- `Ham_charged_zero_mode`: explicit witness `|{0,1}>` (U(1) charge 7) is a genuine
  many-body zero mode outside the target sector - the naive-gap obstruction.
- Controls `Ham_ne_zero_of_gapped`/`Ham_gap_*`: the 4 gapped configs are genuinely
  gapped, so the census is SHARP (not vacuous "everything is a zero mode").

## Over-claim audit - exemplary

- Vacuity: none - the sharp gapped-config controls and explicit charged witness.
- False shape: none - `Ham_zero_mode_iff`/`Ham_kernel_card` are exact finite
  census facts.
- Docstring-outruns-kernel: none - "What is NOT claimed": no thermodynamic-limit,
  continuum, lattice-locality, bulk-edge, physical mirror-decoupling, or SM claim -
  a finite few-mode algebraic census of one fixed Hamiltonian.

## Program fit

A clean QUANTITATIVE finite no-go: a single neutral quartic does NOT achieve
symmetric mass generation (gaps 4/32, leaves 28 zero modes; the mirror sector
persists). Refines the earlier `full_hamiltonian_has_zero_mode` with the complete
census. Physical reading (in-file): gapping the mirror sector needs additional
quartics covering every mirror configuration. Consistent with the
one-interaction-cannot-escape pattern.

## Bottom line

APPROVE (draft-trust). Independently rebuilt, standard-three, exemplary scope.
Complete zero-mode census (28/32) proving a single quartic is far from SMG on the
3-4-5-0 multiplet. Landing: reconcile the Core submodule.
