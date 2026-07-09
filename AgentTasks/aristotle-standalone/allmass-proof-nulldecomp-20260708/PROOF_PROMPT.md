# Proof: the universal null decomposition (every mass IS null-edge disagreement)

## What this earns (context; you are blind to the wider repo)

A finite mathematical-physics program formalizes the thesis that the invariant
**mass** of a bundle of light-like ("null", massless) degrees of freedom is their
geometric *disagreement*. The FORWARD direction is already proved: null edges *give*
mass (`two_null_sum_massSq`: `massSq(k₁+k₂) = 2 k₁·k₂` for null `k₁,k₂`; and, on the
matrix side, `det(M Mᴴ) = normSq(det M) = |wedge|²`, proved elsewhere).

This job proves the **CONVERSE** — the "**all mass**" direction: *every* massive
(timelike / positive-semidefinite) state *decomposes into* null edges realizing its
mass as disagreement. Proving it upgrades "null edges give mass" to "**all mass is
null-edge disagreement**," a kinematic *constitution* claim (NOT a derivation of
mass values). This is the single missing theorem for that universality.

## Targets (in `src/MassNullDecomposition.lean`, four documented `sorry`s)

**Level A — 4-momentum (physically transparent).**
- `massive_eq_two_null`: every future-timelike `p` (`0 < p 0`, `0 < massSq p`) is a
  sum of two future-null momenta (`massSq kᵢ = 0`, `0 < kᵢ 0`, `p = k₁ + k₂`).
  *Construction hint (not a constraint):* `r = √(spaceNormSq p)`,
  `k₁ = ((p 0 + r)/2)·(1, p⃗/r)`, `k₂ = ((p 0 − r)/2)·(1, −p⃗/r)`; for `p⃗ = 0`
  pick any spatial unit direction (e.g. `(0,0,1)`). Timelike ⇒ `p 0 > r ≥ 0` so both
  energies are positive. Expect a case split on `spaceNormSq p = 0` and some
  `Real.sqrt` algebra (`Real.sq_sqrt`, `Real.sqrt_pos`).
- `massSq_eq_two_null_disagreement`: chain the above with `two_null_sum_massSq` to
  get `massSq p = 2·(k₁·k₂)` — mass = disagreement of the two null constituents.

**Level B — momentum matrix (the paper's `det P` mass; the central one).**
- `posSemidef_eq_null_edge_sum`: every PSD Hermitian `P : Matrix (Fin n) (Fin n) ℂ`
  factors as `P = M Mᴴ` (columns of `M` = the null spinors, so `P = Σ ψᵢ ψᵢᴴ`).
  This should be a short wrapper around Mathlib's PSD structure — search for the
  positive-semidefinite square root / factorization (`Matrix.PosSemidef.sqrt`,
  `Matrix.PosSemidef` conjugate-transpose factorization, `posSemidef_iff_...`).
- `det_eq_null_edge_disagreement`: combine the factorization with
  `det(M Mᴴ) = normSq(det M)` (a `det_mul` + `det_conjTranspose` + `mul_conj`
  identity — prove it inline) to get `det P = normSq(det M)` — the Plücker mass is
  the disagreement of the null-edge decomposition.

The physical reading: `det_eq_null_edge_disagreement` + `posSemidef_eq_null_edge_sum`
say *every* momentum matrix — hence every massive state's invariant mass (its total
timelike momentum) — is a null-edge sum with its mass = the decomposition's
disagreement. Universal, by construction.

## Constraints (hard)

- Kernel-checked only: **no `sorry`/`admit`/`native_decide`/new `axiom`** in the
  final proofs. Target axiom footprint `[propext, Classical.choice, Quot.sound]`,
  enforced with in-file `#guard_msgs … #print axioms` for each landed theorem.
- Self-contained: **Mathlib only** (the file already restates the `Four`/`mink`/
  `massSq` conventions and the forward `two_null_sum_massSq`). Use the pinned Lean 4
  + Mathlib toolchain you scaffold.
- Do not weaken the stated targets (e.g. keep the future-pointing `0 < kᵢ 0` clauses
  in Level A; keep `P = M Mᴴ` — full factorization, not just `∃` a rank bound).

## Deliverable

The completed file with as many of the four targets discharged as cleanly hold
(Level B is likely quickest; Level A is the genuinely constructive one), the
`#print axioms` output, and an `ARISTOTLE_SUMMARY.md` stating the final statements,
the constructions/Mathlib lemmas used, and — honestly — any target that resisted
and why. If a target is only provable under an extra hypothesis, state it precisely.
