# Strengthening roadmap: from honest caveats to stronger kernel claims

**Date:** 2026-07-08 (all-mass overnight run). **Purpose:** the user asked to
*strengthen* the paper's claims, not only weaken them. This document turns every
honest caveat the two strengthening reviews (Fable call-04, Aristotle 4bf9899f)
surfaced into a **pre-registered positive target**, ordered so each one
discharges a caveat and *promotes a claim's grade*.

## The principle

A caveat and a strengthening target are the same object seen from two sides.
"`M^2` is only a functional, not a mass" is a weakness; "prove
`sector_ground_mass`" is its strengthening — and it is now **done (M)**. The
roadmap is the rest of that list. Each item below names: the claim it
strengthens, the **grade promotion** it buys, the concrete statement, the
method, effort/risk, and dependencies.

## The dependency spine (what rests on what)

```text
   S3  mass = det P                      [M, solid]  ── the anchor
        |
   S4  4 D^#D = Q_A^# + Q_C^# + 4Q_T + 4E_#   [M, solid]
        |                                    \
   KEY sector_ground_mass                     \--> [T7 rigidity: "natural" -> "forced"]
        (functional -> positive eigenvalue)  [M, DONE, conditional]
        |
        +-- needs a positive sector to EXIST -----> T1 compression + T2 multi-edge carrier
        |
        +-- eigenvalue = det P ? -----------------> T3 the S3<->S4 bridge   (THE headline)
        |
   NAMES  channel = force analogies   [C] --------> T4 g=2 Pauli test, T5 gauge covariance
        |
   CONTINUUM  none claimed            ------------> T6 checkerboard finite-equality (+ import)
```

The **critical path to the single strongest claim** is `T2 -> T3`: a concrete
finite model in which the bound-state mass *is* `det P` *and* decomposes into
four channels. Everything else adds breadth (names earned, continuum anchor,
forced unification) around that spine.

---

## Phase 1 - Instantiate the keystone (turn conditional-M into a witnessed mass)

### T1. Sector-compression lemma  `[new M; low effort; Aristotle-ripe]`
- **Strengthens:** makes `sector_ground_mass` usable on a *subspace* `P` of an
  ambient carrier `E`, not just on an abstract `H`. Unblocks T2-T4.
- **Statement:** for `P : Submodule C E` and ordinary-self-adjoint `S`, the
  compression `T_P := orthogonalProjection P . S|_P` is symmetric on `P` and
  `rayleighQuotient T_P = rayleighQuotient S` on `P \ {0}`.
- **Method:** Mathlib `Analysis.InnerProductSpace.Projection`,
  `orthogonalProjection`. Aristotle already sketched it. **Risk: low.**

### T2. Multi-edge carrier with a genuine J-positive sector  `[new M; the LINCHPIN]`
- **Strengthens:** discharges crux **0a**. Converts "no positive sector exists
  (on the single-doublet toy)" into "here is a carrier with a genuine
  `J`-positive physical sector on which the total Krein form is positive." This
  turns the whole S4/S6 positivity story from *obstructed-on-witness* into
  *instantiated*, and makes `sector_ground_mass` fire on a real object. Both
  reviews rank a fully-instantiated Krein model their #1 move.
- **The design constraint (from the aperture-grading kill):** the closure
  bivector `b` and the chirality `Gamma` must be **distinct** gradings, so that
  "the grading that balances closure" does not also balance the aperture. On
  the single-doublet toy they coincide (`b = Gamma = sigma_z`), which is *why*
  the aperture was balanced. A **two-edge** carrier has a 4-dim Clifford factor
  where `b = [gamma_1, gamma_2]` and `Gamma = gamma_1 gamma_2 gamma_3 gamma_4`
  are different elements - the room the rescue needs.
- **Method:** **probe first** (`Scripts/oracle/`): build a 2-edge carrier,
  search for `J` and a physical sector `P` with `J|_P > 0` and the total Krein
  form `J(Q_A+Q_C+4Q_T)|_P > 0` with a gap `c > 0`. **Then** transcribe to Lean
  (`Matrix.PosDef`, `decide`/`norm_num`), feed T1 + `sector_ground_mass`.
- **Effort: medium-high. Risk: medium** - the obstruction may persist (then
  that is itself a deeper, publishable structural theorem). Either outcome is a
  strengthening: a positive-sector witness, or a no-go with a proof.

---

## Phase 2 - Tie operator-mass to kinematic-mass (the honest "mass" theorem)

### T3. The S3<->S4 bridge  `[C -> M (special case first); THE headline claim]`
- **Strengthens:** the single biggest positive claim available - "the budget
  decomposes *the* mass `det P`," not merely *an* eigenvalue. This is the
  sentence the whole paper wants to earn.
- **Statement:** for the ground vector `x0` of `sector_ground_mass`,
  `min spec(D^#D | P) = det P(x0)`, where `P(x0) = sum_i psi_i psi_i^dagger` is
  the momentum bundle read off `x0`.
- **Method:** attack a **special case first** (single-edge, then the T2 2-edge
  witness) where it is checkable; probe the equality numerically on the T2
  model *before* formalizing. Project `Spinor/PluckerMass` + linear algebra.
- **Effort: high. Risk: high - may be false as stated** (Aristotle's warning).
  **Kill condition:** a carrier + ground vector whose least `D^#D`-eigenvalue
  differs from `det P` of its momentum bundle. Even a *special-case* proof (the
  eigenvalue equals `det P` on one honest model) is a major strengthening.
- **Depends on:** T2.

---

## Phase 3 - Earn the channel names (promote grade-C analogies to correspondences)

### T4. The g = 2 / Pauli-term test  `[C -> checked finite correspondence]`
- **Strengthens:** *earns* the "chromomagnetic / QCD" name for `Q_C` - the
  sharpest finite correspondence available, needing **no continuum limit**.
- **Statement/method:** put an **abelian** background on the T2 carrier; check
  `Q_C`'s expectation reproduces the Lichnerowicz `sigma.F` (Dirac `g = 2`)
  coefficient relative to `Q_A`. If it matches, the name is earned at the
  strongest level a finite model permits; if not, the name is retired (a kill).
  Probe first, then Lean. **Effort: low-medium. Risk: real (it can fail).**
- **Depends on:** T2.

### T5. Gauge covariance of the four blocks  `[new M; low effort; Aristotle-ripe]`
- **Strengthens:** makes "these are physical channels" a theorem, removing the
  first structural objection a referee raises ("is your decomposition
  gauge-invariant?").
- **Statement:** each block transforms by conjugation under a finite gauge
  transformation on the transports; block expectations in covariantly-paired
  states are gauge-invariant.
- **Method:** same difficulty class as `signed_budget_sum_one`. **Risk: low.**
  Can be done now, independent of T2.

---

## Phase 4 - A genuine continuum anchor (the strongest T-grade asset)

### T6. Checkerboard finite-equality  `[upgrades an [import] into a live reduction]`
- **Strengthens:** converts S9/S10's "no continuum claimed" into "a genuine
  continuum reduction for the 1+1 null chain" - the single biggest **T-grade**
  strengthening, because it imports an *established* theorem onto *our* operator.
- **Statement:** the carrier restricted to the single null chain **equals** the
  Feynman-checkerboard transfer operator (a finite identity, not an analogy).
  Then the Gersch / Jacobson-Schulman continuum limit `[import]` applies to `D`
  itself, discharging the aperture+turn continuum gap for the simplest chain.
- **Method:** finite linear algebra (`Matrix`) for the equality; the limit is
  the cited import. **Effort: medium. Risk: low-medium** (the equality is
  checkable). Independent of T2, but clearest once the carrier is pinned.

---

## Phase 5 - Make unification forced (the structural capstone)

### T7. Carrier rigidity  `[C -> M/T; research-level]`
- **Strengthens:** promotes "unification is decomposition" from *natural* to
  **forced** - the strongest form of the central thesis. Also *defeats the
  telescoping objection* structurally (the blocks are not just independently
  defined but the *only* canonical ones).
- **Statement:** the axioms (null soldering on a finite 2-complex, Krein
  structure, chiral grading, covariantly constant turn) determine the carrier
  and its four-block split uniquely up to the S6 representation gauge.
- **Method:** hard, open-ended; an Aristotle strategy job. **Kill:** two
  axiom-satisfying carriers with inequivalent splits, or a fifth forced block -
  itself publishable. **Depends on:** benefits from T2 (models to test against).

---

## Already in flight (part of the roadmap, not new)

- **S1-CC balanced-inertia Lean capstone** (MEMO -> M): the charpoly_neg +
  `card_pos_eq_card_neg` route (Fable call-01 Part A); Codex converging.
- **Equivariant graded index L3/L4** (MEMO -> M): the organizing theorem that
  makes McKean-Singer, C4, and S1-CC literal corollaries - unifies SS4/6/8.
- **18-dim S6 color-singlet witness** (oracle -> M): makes `b_C != 0` a kernel
  witness (Kronecker/`decide` route), strengthening the closure channel's
  non-triviality beyond the trivial `(1/2,0,1/2)` single-edge case.

---

## Priority ordering (the "most significant" per unit effort x probability)

1. **T2 multi-edge carrier witness** - the linchpin; unblocks T3/T4 and
   instantiates the keystone. *Probe first, this run.*
2. **T1 compression** + **T5 gauge covariance** - low-hanging, Aristotle-ripe,
   run in parallel while T2 is explored.
3. **T3 bridge (special case)** - the headline claim; on the T2 witness.
4. **T4 g=2 test** - earns a channel name; on the T2 witness.
5. **T6 checkerboard** - the continuum anchor; independent high-value.
6. **T7 rigidity** + the in-flight capstones - structural / longer-term.

**The one-sentence version:** build one honest multi-edge carrier (T2), prove on
it that its ground mass *is* `det P` (T3) and that its closure block *is* the
Pauli term (T4), import a continuum limit through the checkerboard (T6), and the
paper stops being "kernel-checked algebra shaped like physics" and becomes "a
finite, rigorous, and in one case continuum-anchored theory of mass as null
disagreement."
