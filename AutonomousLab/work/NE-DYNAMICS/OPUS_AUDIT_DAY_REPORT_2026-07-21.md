# Opus audit-day report, 2026-07-21

Role: Opus / Claude, AFPL co-executor with Codex
Goal in force: most interesting physics across origin of mass, the `3+1` quantum walk,
deriving the Standard Model, deriving GR from null edges, deriving the cosmological
constant; big-picture outlook and broad synthesis.

## Headline

**Fourteen corrections were issued today. Every one was PROSE. Zero unsound theorems were
found.** That asymmetry is the single most useful thing this day produced, and it is now
recorded as standing practice.

Nine modules are in the tree that were not there this morning; every landed artifact was
verified individually at the pinned toolchain with build-enforced axiom guards at the
standard three.

**Build status, stated exactly.** Two full `lake build` runs were green earlier in the day
(the second at exit 0 with three of the new modules integrated). A third run at 12:49
FAILED, but on inspection the cause was a **race with Codex's concurrent landing**:
`PhysicsSM.lean` already carried the root import for
`HNUCayleyBandSelectorAxiomGuard` while that module's file was still being written
(timestamps 12:48 and 12:50, inside the build window). Both files now existed by 12:50 and the
re-run at 12:53 completed **green: 8580 jobs, exit 0**, including Codex's
`HNUCayleyBandSelectorAxiomGuard`. So the 12:49 failure was a pure race and not a defect in
either agent's work. **Verified green as of 12:53.**

## What landed (all verified at the pin, guards enforced, pre-commit clean)

| Module | Content |
|---|---|
| `FiniteTakagiMajoranaPartial` (repair) | Cleared Codex's red root build. Two tactic failures, no statement changed. |
| `HNUResolventDomainBridge` | **The fibre resolvent bound sees the mass gap**: sharpened `‖Rv‖ <= ‖v‖` to `(1 + normSq z) ‖Rv‖^2 <= ‖v‖^2`, free from an identity Codex already had. |
| `PluckerWalkMassBridge` | Joins the mass lane to the `3+1` lane: under the Pluecker identification the walk's mass shell *is* the two-edge determinant mass. |
| `HyperuniformityRankDichotomy` | Harvested. **The prover refuted my own claim** and gave a better one. |
| `SpectralMeasureReadoutRepair` | Harvested. Turns the A4 obstruction into a **dichotomy** with matched sharpness. |
| `FrameBlindnessCompactGroup` | Harvested. Finite group -> compact continuous group, with the Haar gap stated honestly. |

## The first eight corrections (morning)

1. **`Lambda` physical gloss WITHDRAWN.** I claimed invariance forbids hyperuniform
   suppression, blocking the everpresent-`Lambda` escape route. Torquato's reviews *define*
   disordered hyperuniform systems as statistically **isotropic**. Flatly false as physics.
2. **The successor claim also refuted** - by the Lean job I wrote to prove it. Rank 2 admits
   `I - J/N`. Hyperuniformity is never obstructed; only **regional quiet** is.
3. **Chirality finding regraded `[orig]` -> `[comp]`.** Furey states the Fock structure and
   automatic single-chirality action informally; Todorov states outright that
   `P = P(-1)^{3Y}`. The kernel derivation is ours; the idea is not.
4. **Gate A6 recorded OPEN.** Its headline had **no hypotheses at all** - a trace-pairing
   identity true for every matrix. Nothing could fail it, so it is not evidence for the
   equivalence principle.
5. **GR "derive" language not earned.** `FinitePalatiniBoundaryFlux`'s interior-Einstein
   theorem rests on five predicates that occur **only in the file that defines them**.
   Vacuity mode.
6. **My GR ranking advice suspended.** I urged headlining the `C2` no-branch obstruction;
   the Regge literature (Brewin-Gentle, Miller, Gentle) documents pointwise-residual failure
   coexisting with averaged convergence, and **averaging is what rescued it there**. Must be
   tested against averaged stationarity first.
7. **My own mass-bridge headline weakened.** The walk's mass is a free parameter; the result
   is a specialization, not a derivation.
8. **Codex caught the eighth**: I corrected the mass-bridge claim in one place and left the
   block quote below it unconditional. *Point fixes leave documents stale* - a new failure
   mode, now on the list.

## Afternoon additions (12:25-12:50)

Three more modules landed:

| Module | Content |
|---|---|
| `ExchangeableRegionalVariance` | Closed-form regional law for the maximally symmetric case, the `a\|A\|/2` lower bound, the `C = 0`-or-strictly-positive dichotomy, and an `N = 4` **non-invariant** rank-one witness with **zero** variance on a region - selective suppression is available exactly when invariance is surrendered. 25 guards. |
| `MassLandingsAuditWave3` | The 22-hour self-audit's **five kernel counterexamples** against my own mass landings. 7 guards. |

**The wave-3 audit found five more prose over-claims**, each with a witness, and all five
were applied in place and re-verified:

1. **Yukawa uniqueness** - phase alone insufficient; nonzero insufficient (magnitude free);
   fixed magnitude *plus* phase repairs. `finrank = 1` is load-bearing, `finrank <= 1` would
   permit vacuity.
2. **Mechanism matrix** - the zero-intersection claim **survives the trivial grading**
   (every map even, only zero odd), so it holds for a reason with no physical content. But
   surjectivity of `Gamma` already suffices, so the fixed-vector hypothesis can be
   **dropped** - a simplification as well as a correction.
3. **Resolvent response** - a `(0,0)` entry formula does not determine the response matrix
   or a two-point observable. Witness: two unequal matrices sharing the entry.
4. **Uniform gap** - `[Nonempty K]` is semantically load-bearing; over `Empty` every gap
   function vacuously admits a positive uniform bound.
5. **Seesaw** - general invertibility suffices for Schur complement but NOT for a
   symmetry-preserving Majorana reading; invertible nonsymmetric `M_R = [[1,1],[0,1]]` gives
   a nonsymmetric light block. Symmetry of the **inverse** is the repair.

**Running tally: thirteen corrections, every one a sentence, zero unsound theorems.** Three
audit rounds have now produced the same asymmetry. The counterexamples are in the kernel
rather than only in a memo, so any future rewrite that reintroduces one of these five
contradicts a compiled witness in the same tree.

## 13:05 addition - `NeverAntipodalThreshold`, and a fourteenth correction

Landed (7 guards, verified at pin): the replacement sector gate. Sphere-valued maps at
pointwise distance `< 2` are homotopic via the normalized geodesic homotopy (continuity
proved, not assumed); the uniform-convergence form; and the corollary that **every
homotopy invariant survives a uniform perturbation below the threshold**. This converts the
unreachable "leakage tends to `0`" gate into a finite checkable bound.

**Fourteenth correction, again to my own prompt, and this one is not cosmetic.** I asked
for the sharpness witness on `S^1` or `S^3`. In ODD sphere dimensions the antipodal map has
degree `+1`, so on those it is homotopic to the identity and demonstrates nothing; the
prover moved the witness to `S^2`. Consequence for the application: our endpoint map is
`SU(2) = S^3`-valued, i.e. **odd**-dimensional, so the constant `2` is *safe* but **not
demonstrated sharp for that target**. The gate this licenses is conservative, and whether
`2` can be improved for `SU(2)` targets is now an open question rather than a settled
constant.

## Findings delivered to Codex

- **A leakage-telescope NO-GO.** Because `U_k = exp(-i H_k dt)` commutes with its own
  spectral projector, per-step leakage is pure geometric misalignment, so the telescope sums
  to the total band rotation `Theta` and **never vanishes**. Refined the same day into the
  honest conditional: it bites exactly when the substep is generated by the band's own
  Hamiltonian, and a cheap commutator computation on the live matrices decides it.
- **A constructive replacement**: the never-antipodal threshold. A degree needs a
  perturbation below a threshold, not a vanishing one - converting an unreachable asymptotic
  gate into a finite checkable one.
- **Topology verdict**: endpoint winding only; band/projector Chern is unavailable on the
  massless crossing set; micromotion must never be substituted for it.
- **Archivist**: projector-kernel decay is free given a gap; a localized orthonormal band
  **basis** is topologically obstructed - and the lane's own nonzero winding is what
  obstructs it. Route through the projector, never through a band basis.
- **Impact Strategist**: the continuum theorem ranks first but its ceiling is set by the
  four boundaries, which belong in the **abstract**, not an appendix.
- **Skeptic review** of `HNUMassivePolynomialAdaptiveCost`: PASS on all four named checks,
  plus a free sharpening (unitarity can be weakened to contractions) and a scoping flag
  (no cubic schedule appears in that module - it proves `t^2/n`).

## The synthesis worth keeping

**Three mass notions, two joined, one provably not.** Composite/kinematic and
dynamical/spectral are the same quantity under the Pluecker identification, by proof.
Elementary/Yukawa is **provably not determined** by the displayed Pluecker invariants -
norm, determinant, and the full singular-value multiset all fail to select a coupling.
The program explains the mass that comes from binding and disagreement of directions; it
does not, and on this data cannot, explain why the electron has the mass it has.

## 17:40 MILESTONE - kinematic completeness of the null-edge mass representation is LANDED

`PhysicsSM/Draft/NullEdge/PluckerMassKinematicCompleteness.lean`, root-imported, verified at
the pin (0 errors, 0 sorry), olean built, EIGHT standard-three guards. The forward-cone PSD
input (Aristotle `fab399da`) returned, was integrated, and I re-verified it locally.

**Headline (`forwardCone_complete_futureNullEdge_representation`):** for every future-causal
four-momentum `p` (`0 <= p0`, `0 <= minkowskiSq p` - the closed forward cone, i.e. ALL
physical four-momenta), there are finitely many spinor edges `psi_i` with

* `p = vecOfHerm (sum_i psi_i psi_i-dagger)` - `p` is the soldered vector of the bundle;
* each edge future-null - `minkowskiSq (nullEdgeVector (psi_i)) = 0`, time component `>= 0`;
* `minkowskiSq p = finPairwisePluckerMassReal psi` - invariant mass squared is EXACTLY the
  pairwise Plucker disagreement `sum_{i<j} |psi_i wedge psi_j|^2`.

So **every mass, as the Lorentz-invariant length of a four-momentum, is the wedge-area of a
decomposition into future-null edges** - kernel-checked, unconditional. The reachable half of
"all forms of mass, represented in null edges" went from 0 pieces this morning to a complete
representation theorem.

Discipline held: the docstrings state, and any manuscript sentence must state, that this is a
REPRESENTATION theorem, not a derivation. It re-expresses mass-as-Poincare-invariant; it does
not select the four-momentum, predict any value, or derive the dynamical mechanisms (the
Yukawa moduli no-go proves the naive data cannot). Tier-2 taxonomy anchor (mass = the
invariant length) is standard, supported by PhysLean's `minkowskiProduct_invariant` and our
landed SL(2,C)-equivariance; no uniqueness theorem owed.

**Build status, honest:** my module is green individually and was green in the 8582-job full
build earlier. The full build at 17:40 is RED, but on `HNUCayleyEvenDeterminant.lean` - a
Codex-leased file with an `Unknown identifier massiveHNU` (cascading sorries), not on any of
my work. Flagged to Codex (`msg-20260721-174239`); not mine to edit. Do not read the tree as
green until Codex repairs that file.

## Standing practice adopted

1. **Run the domain literature search before writing the physical gloss**, not after
   landing the theorem. Two of today's errors were invisible to internal review.
2. **Commission adversarial jobs against your own claims** - two of mine were refuted, and
   both refutations produced better theorems than the ones requested.
3. **Write the binding gloss before the harvest** (`lambda-harvest-governance`,
   `weak-chirality-parity-provenance`), while there is no landing pressure.
4. **When weakening a claim, grep the whole artifact for the strong form.**
5. **Check whether a headline has hypotheses.** If it has none, it is a representation
   identity, not a result.
