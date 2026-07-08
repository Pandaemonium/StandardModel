# Strategy + proof: does the Krein flow preserve the J-positive sector?

## Context (you are blind to the wider repo)

`src/` has two verbatim Lean files from a finite mathematical-physics program
("mass = obstruction to null transport" on a finite Krein–Dirac carrier). They
compile in the project (their imports reference project modules you may not have;
treat the definitions/statements as given and reason about them — you do NOT need
to build the whole project, only to produce a correct, kernel-checkable proof of
the target, ideally as a small self-contained addition).

Key objects (in `SectorGroundMassWitness.lean`), all explicit finite complex
matrices:
- `HAC : Matrix (Fin 6) (Fin 6) ℂ` — the hand-typed carrier form (Hermitian; the
  physical sector form `M6 = Pisoᴴ * HAC * Piso`).
- `Jmet : Matrix (Fin 6) (Fin 6) ℂ` — the Krein metric (`Jmet.IsHermitian`,
  `Jmet * Jmet = 1`).
- `Piso : Matrix (Fin 6) (Fin 4) ℂ` — the isometry onto the `J`-positive sector
  (`Pisoᴴ * Piso = 1`, `Pisoᴴ * Jmet * Piso = 1` = `sector_krein_form_eq_one`).

In `CarrierUnitaryFlow.lean` the flow `exp(-i t H)` of a Hermitian `H` is proved
Euclidean-unitary (`∈ Matrix.unitaryGroup`) and a norm-preserving isometry.

## The gap this job targets (from an over-claim audit)

An audit flagged a LOAD-BEARING static-vs-dynamical confusion:
`sector_krein_form_eq_one` proves only the **static** identity `J|_sector =
Euclidean` (`Pisoᴴ Jmet Piso = 1`). The **dynamical** claim needed to identify the
Euclidean norm-unitary flow with the *physical* Krein evolution — namely **the
Krein flow preserves the `J`-positive sector** — is currently unproved (grade C).

## Your target (the prize)

Close the dynamical half on this concrete witness. Concretely, prove BOTH:

1. **`HAC` is Krein- (`Jmet`-) self-adjoint:** `Jmet * HAC = HACᴴ * Jmet`
   (equivalently `HAC` is `Jmet`-symmetric). This is a finite matrix identity —
   decidable / `by decide`-style on the explicit entries, or by the structure. If
   it is FALSE as stated, report that (it would itself be an important finding),
   and check the sign/adjoint convention (`HAC^‡ := Jmet⁻¹ HACᴴ Jmet`).
2. **The `J`-positive sector `range Piso` is `HAC`-invariant:** `HAC * Piso =
   Piso * M6` (since `M6 = Pisoᴴ HAC Piso` and `Piso Pisoᴴ` is the sector
   projector when `Pisoᴴ Piso = 1`), i.e. `HAC` maps `range Piso` into itself.
   Prove the finite identity `HAC * Piso = Piso * (Pisoᴴ * HAC * Piso)` (or find
   the correct invariance relation).

Then assemble the consequence:
3. **The flow `exp(-i t HAC)` is `Jmet`-unitary** (`Uᴴ Jmet U = Jmet`) — follows
   from (1) by a general "J-self-adjoint generator ⇒ J-unitary flow" lemma (prove
   this general lemma too, in the `Matrix n n ℂ` setting: if `Jmet² = 1`,
   `Jmet` Hermitian, and `Jmet H = Hᴴ Jmet`, then `(exp(-i t H))ᴴ Jmet exp(-i t H)
   = Jmet`); AND **preserves `range Piso`** — from (2) (invariance of a subspace
   under `H` lifts to `exp(tH)`). Together these upgrade "the sector orbit
   conserves the Euclidean norm" to "…conserves the physical **Krein** form and
   stays on the physical sector", closing the audited gap.

## Deliverable

- Kernel-checked proofs (no `sorry`/`admit`/`native_decide`/new `axiom`; footprint
  `[propext, Classical.choice, Quot.sound]`) of as much of (1)–(3) as lands,
  ideally all. The general `J`-self-adjoint ⇒ `J`-unitary-flow lemma is reusable
  and probably the cleanest first win.
- If (1) or (2) is FALSE on this witness, say so precisely with the failing entry
  — that is a genuine finding (the Euclidean flow would then NOT be the Krein
  evolution, and the manuscript must say the sector is not Krein-flow-invariant).
- `ARISTOTLE_SUMMARY.md`: final statements, which of (1)/(2)/(3) are proved, the
  general lemma, and an honest note on what the result does and does not establish
  about the physical Krein evolution.

## Constraints

Use the pinned Lean 4 + Mathlib toolchain you scaffold. Do not weaken any existing
statement. If exponential-of-matrix reasoning is heavy, the general lemma via
`Matrix.exp_conjTranspose` + `exp` conjugation identities (as `CarrierUnitaryFlow`
already uses for the Euclidean case) is the intended route.
