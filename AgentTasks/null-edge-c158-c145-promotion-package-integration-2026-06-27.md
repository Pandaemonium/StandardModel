# C158 — C145 finite-seed promotion package

Integration package for promoting the **C145 kernel-only branch × flavor × qutrit
finite seed** into the repo's draft/trusted Lean hierarchy. The ready-to-promote
artifact is
`RequestProject/PhysicsSM/Draft/NullEdgeGateC1FiniteSeed.lean`
(builds clean, no `s o r r y`; key theorem uses only `propext`, `Classical.choice`,
`Quot.sound`).

## 1. Smallest subset of C145 to import first

Import only the **algebraic core** of the seed, not the physics narrative. The
minimal load-bearing content is:

- two involution facts: `Gamma_K^2 = 1` and `T_br^2 = 1`;
- the overlap operator `D_ov,ne = ρ (1 + Gamma_K · T_br)`;
- the Ginsparg–Wilson relation `Gamma_K D + D Gamma_K = (1/ρ) D Gamma_K D`.

Everything else from the C145/C150 report (`W_branch` as a flavored Wilson term,
SM internality, domain-wall import, locality/summability) is **excluded** from
this first import. This is the smallest subset that makes the "kernel-only exact
symbolic" claim meaningful and is fully provable with no analytic hypotheses.

## 2. Module design

- **Namespace:** `PhysicsSM.Draft.NullEdgeGateC1FiniteSeed`, with sub-namespaces
  `Trusted`, `Seed`, `Draft`.
- **Imports:** `import Mathlib` (Kronecker products, `Matrix`, ring tactics).
  No project-internal imports, so the file is self-contained and safe to move
  into `PhysicsSM/Draft/`.
- **Docstring:** module header records the C145 dictionary, what is imported,
  and the trusted/draft separation.
- **Theorem names:**
  - `Trusted.overlapOp`, `Trusted.ginsparg_wilson`,
    `ginsparg_wilson_scaled`, `Trusted.kronecker_involution`;
  - `Seed.branchChirality(_involution)`, `Seed.branchTransfer(_involution)`,
    `Seed.Gamma_K(_involution)`, `Seed.T_br(_involution)`, `Seed.D_ov_ne`,
    `Seed.seed_ginsparg_wilson`;
  - `Draft.null_edge_seed_has_exact_chiral_symmetry` (re-export).
- **Provenance:** C145 (seed), C150 (Wilson-term reading), C153 (inverse-gap /
  no propagator-zero motivating `T_br^2 = 1`), standard overlap/GW algebra.

## 3. Trusted finite algebra vs. draft physical interpretation

- **Trusted (`Trusted`, `Seed`):** unconditional ring/matrix identities. The GW
  relation holds for *any* pair of involutions in *any* ring; the concrete seed
  is exact over `ℚ`. These can go straight into a trusted module.
- **Draft (`Draft`, module docstring):** the physical dictionary only —
  definitions and prose, no asserted physics. The single `Draft` theorem merely
  re-exports a proven algebra fact under a physics-facing name. Promoting the
  module therefore cannot promote any physics claim.

## 4. Dependency risks before integration

- **Low risk:** only Mathlib `Matrix`/`Kronecker` and `noncomm_ring` are used —
  stable API. Lemmas relied on: `Matrix.mul_kronecker_mul`,
  `Matrix.one_kronecker_one`, `Matrix.mul_apply`, `Fin.sum_univ_succ`.
- **Version note:** developed against Mathlib v4.28.0. If the repo pins a
  different Mathlib, re-check the two Kronecker lemma names (occasionally
  renamed) and the `smul` simp set in `ginsparg_wilson_scaled`.
- **Namespace hygiene:** everything lives under
  `PhysicsSM.Draft.NullEdgeGateC1FiniteSeed`; `Gamma_K`/`T_br`/`D_ov_ne` are
  namespaced to avoid collisions.
- **Scope risk (handled):** `sign(H_ne)` is *not* computed as a matrix sign
  function (which would drag in analytic machinery). Instead `T_br` is given
  symbolically as an explicit involution, which is the honest finite-seed
  content; the analytic step `sign(gapped Hermitian)² = 1` is recorded as
  interpretation only.

## 5. Status

Deliverable 5 (a clean self-contained Lean file under
`PhysicsSM/Draft/NullEdgeGateC1FiniteSeed...`) is provided and builds.
