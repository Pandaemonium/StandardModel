# B17 — Post-Gate-A finite dual-soldered Lichnerowicz square (report)

## Deliverable

New module `PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean`, kernel-clean
under the pinned toolchain (Lean 4.28.0). Axiom footprint of every main theorem:
`propext, Classical.choice, Quot.sound` only. No `axiom`, no `native_decide`,
no `@[implemented_by]`.

## What was proved

The finite, dual-soldered null-edge **generalized Lichnerowicz formula**,
assembled by gluing the two already-integrated finite-algebra layers rather than
restating them:

* `finite_lichnerowicz_square` — for the full null Dirac operator
  `D = i D_N + Γ_s Φ` over any associative `Ring A` with `Invertible (4 : A)`,
  under the clean Gate A sign hypotheses (H1)-(H5):
  ```text
  D² = -K_null - C_diamond - T_frame + Φ² - i Γ_s ∑_a C_a [∇_a, Φ].
  ```
* `finite_lichnerowicz_square_gateA` — the same identity taking the hypotheses
  bundled as `SuperDirac.CleanSquareHypotheses` (the downstream-facing form).
* `finite_lichnerowicz_sign_bridge` — the full square **and** the `±Φ²` sign
  dichotomy in one statement: with the spacetime chirality `Gs` (commuting,
  `[Gs,Φ]=0`) the mass block is `+Φ²`; with an internal chirality `Xe` under
  which `Φ` is odd (`{Xe,Φ}=0`) the same construction gives `-Φ²`.
* `finite_lichnerowicz_square_tetrad` — specialization under the finite tetrad
  postulate `[∇_a, C_b] = 0`, where `T_frame` vanishes:
  ```text
  D² = -K_null - C_diamond + Φ² - i Γ_s ∑_a C_a [∇_a, Φ].
  ```
* `dNsum_sq_decomp` — the single defeq glue lemma:
  `D_N² = K_null + C_diamond + T_frame`.

## Reused (not duplicated) definitions

| task symbol | existing Lean object reused |
| --- | --- |
| `D_N` | `SuperDirac.dNsum C nab` (defeq `PhysicsSM.Draft.DN C nab`, both `∑ a, C a * nab a`) |
| `K_null` | `PhysicsSM.Draft.Boxnull C nab` = `¼ ∑_{a,b} {C_a,C_b}{∇_a,∇_b}` |
| `C_diamond` | `PhysicsSM.Draft.Cdiamond C nab` |
| `T_frame` | `PhysicsSM.Draft.Tframe C nab` |
| Gate A square | `SuperDirac.super_dirac_square_sum` |
| `±Φ²` dichotomy | `SuperDirac.graded_square_comm` / `graded_square_anticomm` |
| clean hypotheses | `SuperDirac.CleanSquareHypotheses` |
| tetrad vanishing | `PhysicsSM.Draft.frame_term_vanishes` |

No parallel API was introduced. The only new naming is the readability alias
`Knull := Boxnull` (proved `rfl`-equal via `Knull_eq_Boxnull`).

## Convention map / alignment with `docs/CONVENTIONS.md`

The locked convention ("Super-Dirac square signs") states
```text
D_N² = K_h + C_diamond + T_frame
D    = i D_N + Γ_s Φ_H
D²   = -K_h - C_diamond - T_frame + Φ_H² - i Γ_s ∑_a C_a [∇_a, Φ_H]
(Γ_s Φ_H)² = +Φ_H²  iff  [Γ_s, Φ_H] = 0
(Γ_s Φ_H)² = -Φ_H²  iff  {Γ_s, Φ_H} = 0
```
The Lean `K_null` (`Boxnull`) is the `¼ {C,C}{∇,∇}` block, i.e. the `K_h` of the
doc. The proved square reproduces the doc sign-by-sign, with the kinetic part
`-D_N²` resolved into the three blocks. The `±Φ²` dichotomy is proved exactly
under the documented (anti)commutation conditions, keeping `Γ_s` (spacetime
chirality) strictly distinct from `χ_E` (internal chirality) — the M1/M2 sign
trap is the conflation `Γ_s := χ_E`, which flips `+Φ²` to `-Φ²`.

## Scope / guardrails

Finite associative-ring (matrix) algebra only: no continuum limit, no Stokes,
no small-mesh approximation. The `T_frame` removal is a genuine hypothesis
(`frameComm = 0`); if frame transport is not compatible, the defect must be
classified, not hidden (consistent with the T15 guardrails).

## Build / packaging note

This focused package omits two modules that `NullEdgeSuperDiracSignBridge.lean`
imports (`NullEdgeSuperDiracBlockCore`, `NullEdgeSuperDiracProductGradingKrein`),
so that file (and the project default target through it) does not build here.
The new module deliberately imports only the two building modules it needs
(`NullEdgeFiniteTetradPostulate`, `NullEdgeSuperDiracSignAudit`) and builds
cleanly in isolation:
`lake build PhysicsSM.Draft.NullEdgeFiniteLichnerowiczBridge`.

In the full repository, `finite_lichnerowicz_sign_bridge` can additionally be
cross-cited against the concrete `Deg × Chir` realisation
`SuperDiracSignBridge.productGrading_concrete_bridge` /
`super_dirac_square_sum_safe`; the abstract two-grading form proved here is the
matching finite-square face and needs no new assumptions.

## How this feeds P2

P2 should cite `finite_lichnerowicz_square_gateA` as the anchored finite square
and kinetic-normalization statement: it gives, in one named object, the operator
identity `D² = -K_null - C_diamond - T_frame + Φ² - (gradient)` with the mass
block sign fixed positive by the Gate A clean hypotheses. The
`finite_lichnerowicz_square_tetrad` corollary is the version P2 should use once
the tetrad-postulate (edge-transport compatibility) branch is assumed, removing
the `T_frame` defect. The `finite_lichnerowicz_sign_bridge` object is what P2
should reference whenever it needs to justify the `+Φ²` (non-tachyonic) mass
normalization while explicitly exhibiting the `-Φ²` failure mode it avoids.
"No double counting" (`K_null = Φ_H²`) remains an operator-matching convention
on top of this square, not a consequence of it.
