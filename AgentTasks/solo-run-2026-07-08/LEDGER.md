# Solo run ledger — 2026-07-08

Goal: execute SOLO_RUN_PLAN until 6pm. Focus 1: finish the manuscript
(`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`, Markdown, verified
refs). Focus 2: flesh out the dynamics layer so Lean informs Python sims.
Cadence: Aristotle liberal; Fable ~2h; frequent lit reviews; borrow from
PhysLean/public Lean repos with attribution.

## Cycle A (~09:00-10:xx) — Fable call-05 action + manuscript finish

Harvested Fable call-05 (manuscript ~90% publication-ready; main gap: dynamics
goal invisible). Closed EVERY call-05 item:

- **§9a "A finite dynamics layer"** written — D1-D5 M scaffolds + the three
  Lean-anchored simulators, with the honest semantic-alignment framing
  (conservation is a generic sector-isometry fact; the carrier-step
  instantiation is open; Krein-unitary != norm-unitary).
- **References**: added Ji (hep-ph/9410274), K. Wilson (PRD 10 2445),
  Ginsparg-Wilson (PRD 25 2649), Mlodinow-Brun (1802.03910); + source map rows.
- **§11 anchor table**: D2/D4/D5 rows with correct theorem names +
  `two_edge_mass_zero_iff_wedge_zero`.
- **§4 mass phase-diagram paragraph**: gap = aperture - closure across the
  whole (lam,kappa) plane; PosDef iff |kappa|<lam; massless critical line
  kappa=lam. Grade M-sim pending the `MassGapWitness` kernel pin.
- **Appendix A**: named the three simulator scripts + validation targets.
- **§2a**: added Mlodinow-Brun mass-side QW comparator (4D coin -> Dirac gammas,
  coin-flip operator = mass term, massless when off); fixed stale HepLean hedge;
  harmonized the Pereira citation to the listed Aldrovandi-Pereira textbook.
- **Abstract**: de-staled the title-discipline note (functional now proved a
  positive mass on a concrete carrier, M; physical identification remains C).

Lit pass: neo4j chunk search surfaced Mlodinow-Brun as the closest mass-side
prior art (logged in LIT_LOG). Verified all three dynamics simulators run with
ZERO failures (spectrum/evolution/rgflow) — the §9a/Appendix A claims are true.

Commits (this cycle): 7 `solo-202607:` commits (S9a+refs+S11; phase diagram;
Mlodinow-Brun; Pereira harmonize; abstract de-stale).

## Cycle A.2 (~10:xx) — direction-B deepening + novelty check

Per the Stop-hook ("run until 6pm"), kept advancing after the manuscript finish:

- **`carrier_scattering_sim.py`** — a 4th dynamics simulator: a finite S-matrix
  (1+1D Dirac QW with a mass barrier). Unitary + reciprocal, transmission
  monotone-down in barrier mass, massless region transparent (critical line as a
  scattering statement). Debugged 3 real physics/measurement issues honestly
  (measure-before-clearance, ring wrap-around, coin-angle wrapping past pi/2);
  faithful sweep capped in the small-angle Mlodinow-Brun regime. ALL checks pass.
  Wired into §9a + Appendix A (three -> four sims). Directions A+B+C now covered.
- **Core-thesis novelty check** (chunk search): NO prior art frames mass as
  null-direction disagreement / null-transport obstruction; substantiates §2a.
- Verified all four simulators run with zero failures.

## Cycle A.3 (~10:xx) — landed 3/4 mass-gap lemmas myself (Lean)

Rather than idle on the external Aristotle job, prepared
`PhysicsSM/Draft/NullEdge/Carrier/MassGapWitness.lean` and proved the elementary
targets myself, staging the hard one:
- **B_isHermitian, B_det, B_massless_iff** — all M, KERNEL-CLEAN (axiom audit
  `[propext, Classical.choice, Quot.sound]`, no native_decide). det = lam(lam^2-
  kappa^2); massless line kappa=+-lam for lam>0. Generalizes T2 across the plane.
- **B_posDef_iff** — documented `s o r r y` handoff to Aristotle; the elementary
  quadratic-form route (Re x^H B x = lam||x||^2 - 2 kappa Im(conj x0 x1) >=
  (lam-|kappa|)||x||^2) is written in the docstring as the semantic-alignment
  reference for reviewing Aristotle's proof.
Manuscript §4 grade split honestly: massless line = M (theorem); massive-side gap
= M-sim pending PosDef. Two §11 rows added. Draft handoff (1 sorry), not pinned.
Debugging notes: det needed det_fin_three + of_apply/cons_val extraction then
linear_combination on Complex.I_sq (coeff lam*kappa^2); PosDef statement needs
`open scoped ComplexOrder` for PartialOrder C.

## Cycle A.4 (~10:50) — MASS-GAP FLAGSHIP LANDED + guard-pinned

The Aristotle mass-gap job COMPLETED. Harvested, reviewed for semantic alignment
(all statements match intended math; Aristotle independently caught the same
lam=0 subtlety I did - strong corroboration), and integrated into
`MassGapWitness.lean`. It proved MORE than the 3 lemmas I'd staged:
- **B_posDef_iff** (the hard one): `B.PosDef <-> |kappa|<lam`, via exactly the
  quadratic-form route I documented - massive iff aperture dominates closure;
- **B_least_eigenvalue**: `IsLeast (range eigenvalues) (lam-kappa)` - the squared
  mass gap = aperture - closure AS AN EIGENVALUE THEOREM (the sharpest form);
- plus B_massless_iff (+ _of_pos), B_shift_posSemidef/det, B_posDef_iff_of_nonneg.
Cleaned Aristotle's leftover `exact?` -> concrete lemma. Axiom audit: all
[propext, Classical.choice, Quot.sound] (+decide is kernel decide, not native).
GUARD-PINNED in CarrierAxiomGuard (3 new blocks); `lake build CarrierAxiomGuard`
GREEN (8086 jobs). Manuscript §4 upgraded M-sim -> full M; §11 rows updated.
=> Fable call-05 bottom-line #3 (parametrized T2 mass-gap, critical line as M)
   is now fully DONE and kernel-pinned.

## Cycle A.5 (~11:0x) — Fable call-06: fix the mass-gap over-claim

Fable call-06 (semantic-alignment audit of MassGapWitness + manuscript finish)
delivered ONE sharp load-bearing catch: **docstring-outruns-kernel**. The kernel
proved the spectral theory of the *asserted* block B(λ,κ), but the tie of B to
the actual carrier M6 was by-inspection only (no lemma), yet the docstring/§4
claimed "the compressed sector form IS B(λ,κ)... fully kernel-checked" and
"generalizes T2 to the whole plane". Fable confirmed the spectral theorems
themselves are the intended math (B = λI+iκK, entrywise = M6's upper block at
(2,1); PosDef right; IsLeast genuine; λ=0 split creditable). Fixed ALL items:
1. **Landed the carrier bridge in the kernel**: `M6_topBlock_eq_B`,
   `M6_botBlock_eq_B`, `M6_offBlock_eq_zero` (M, guard-pinned) — M6 = B(2,1) (+)
   B(2,-1) exactly, via submatrix castAdd/natAdd. So the (2,1) tie is now a
   THEOREM, not by inspection. Build green (8086 jobs).
2. **Regraded §4 + module docstring**: split "B's spectral theory is M for all
   (λ,κ)" from "B IS the carrier's sector form — M at (2,1), oracle-grade off it".
   Removed "fully kernel-checked ... generalizes to the whole plane" over-claim.
3. **Fixed the massless qualifier**: "(for κ≥0)" -> "(for λ>0, κ≥0)".
4. **Named the mirror block** B(λ,-κ): sector form = B(λ,κ) (+) B(λ,-κ).
Also refined the §9a spectrum-sim bullet + §11 rows to the same honest split.

## In flight (external, not harness-tracked)

- **Aristotle D2-on-T2 job** — project `9af87ff3-da85-456e-acda-acbc4809ee93`
  (`allmass-d2-on-t2-20260708`). Target: `hermitian_flow_mem_unitaryGroup` —
  for Hermitian H, `exp(-i t H)` is unitary (a genuine norm-preserving sector
  isometry), instantiating `FiniteUnitaryEvolution` on the concrete carrier and
  closing the one open §9a dynamics link. On completion: harvest into a draft
  module, note in §9a that the D2 instantiation is now kernel-checked (not just
  the generic scaffold), guard-pin.
  - **INTEL (my bounded attempt, reverted):** exact Mathlib lemma is
    `NormedSpace.exp_mem_unitary_of_mem_skewAdjoint` (skew-adjoint => exp unitary);
    `NormedSpace.exp` takes ONE arg (no field) in v4.28.0; skew-adjoint of
    `-i t H` closes by `simp [star_smul, Matrix.star_eq_conjTranspose, hH.eq,
    Complex.conj_I, Complex.conj_ofReal] ; module`. BUT `exact ... ∈ unitary
    (Matrix (Fin n) (Fin n) ℂ)` TIMES OUT at whnf (200k heartbeats) on the
    `unitary` monoid-instance diamond. Fix Aristotle should prefer: state the
    conclusion as the plain matrix eqn `(exp A)ᴴ * exp A = 1` to dodge the
    `unitary` submonoid diamond, or bump maxHeartbeats. Review its formulation
    against this at harvest.

## Status: BOTH FOCUSES COMPLETE + VERIFIED (as of ~11:1x)

- **Focus 1 (manuscript): FINISHED.** Two Fable reviews (call-05, call-06) fully
  actioned; Fable call-06 bottom line: "nothing else stands between this draft and
  'done' at its own declared standard." Grades honest, references complete +
  verified, over-claims removed.
- **Focus 2 (dynamics): COMPLETE.** 4 Lean-anchored simulators (A spectrum, B
  evolution + scattering, C RG/thermo), all passing; the mass-gap flagship
  (spectral theory + carrier bridge at (2,1)) landed and guard-pinned.
- **Full `lake build` GREEN — 8298 jobs** (final verification, whole tree).

## Next (optional; both focuses already met)

- Next Fable ~2h check (call-06 ~10:19; ~2h mark ~12:20).
- Possible on-focus dynamics deepening: the ONE named open link in §9a — "fire D2
  on the T2 witness" (the T2 sector step IS a sector isometry, instantiating
  FiniteUnitaryEvolution on the concrete carrier). Candidate Aristotle job.
- Deep §10 open cruxes (T3b binding invariant, 2nd quantization -> hadron mass,
  neutrino ratio, continuum reduction) are genuine new research, honestly open.
