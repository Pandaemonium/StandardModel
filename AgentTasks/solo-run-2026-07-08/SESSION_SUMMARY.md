# Solo run 2026-07-08 — session summary (top-level)

Detailed cycle-by-cycle notes are in `LEDGER.md`; lit passes in `LIT_LOG.md`;
external reviews under `AgentTasks/model-calls/claude/`. This is the overview.

## The two focuses — both met and verified

- **Focus 1 (manuscript): finished.** `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`
  is a self-contained Markdown draft with complete + verified references, a §9a
  dynamics layer, and grade discipline held across ~40 edits (checked by three
  Fable reviews + three over-claim audits). Fable's standing verdict:
  publication-ready.
- **Focus 2 (dynamics for sims): done.** Five Lean-anchored Python simulators
  (`Scripts/oracle/carrier_{spectrum,evolution,rgflow,scattering,fock}_sim.py`),
  all passing, each validated against a landed kernel identity.

## Kernel core landed this session (all M, guard-pinned unless noted)

Every result below was proved by Aristotle and/or the reviewing agent, reviewed for
semantic alignment, integrated into the repo, guard-pinned, and full-build-verified.

- **Mass-gap spectral theory** (`MassGapWitness`): `B_posDef_iff` (massive iff
  |κ|<λ), `B_least_eigenvalue` (gap = λ−κ = aperture−closure), `B_spectrum`
  (`{λ−κ,λ,λ+κ}`), `B_massless_iff_of_pos`.
- **Carrier bridge** (`MassGapWitness`): `M6 = B(2,1) ⊕ B(2,-1)` — ties the block
  to the actual carrier at (2,1).
- **T2 Clifford provenance** (`CliffordAssembly`): the hand-typed carrier IS the
  Cl(4) Kronecker assembly (recipe match; canonicity not claimed).
- **D2 unitary flow** (`CarrierUnitaryFlow`): `exp(-itH)` unitary + isometry; the
  carrier orbit conserves norm/energy. (Generator-as-Hamiltonian is a C posit;
  Euclidean=Krein-on-sector is `sector_krein_form_eq_one`.)
- **Binding defect** (`BindingDefect`): `Δ_block = −κ` (negative, closure-controlled,
  off-diagonal) — the T3b interacting-bridge crux, block level.
- **S1-CC central-crux witness** (`S1CCPhysicalSectorWitness`): the §6 closure form
  is balanced `(2,2,0)` on the physical sector `V'/N`, with the full Gauss-sector
  construction (`QG_ker_eq`/`QG_range_eq`/`QG_ker_reps_basis`) kernel-checked —
  the program's former #1 crux, MEMO→kernel on the witness.
- **S1-CC witness→general reduction** (`S1CCGeneralReduction`, `S1CCWitnessAsInstance`):
  the balance *mechanism* is general M — `compression_balanced` (any coset reps,
  any ±1 grading, Q_G-blind), `compression_balanced_eigbasis` (any b-eigenvector
  family P, coordinate-alignment dropped — proved in-repo, not Aristotle),
  `compression_has_neg_eigenvalue`, and `witness_balanced_via_general` (the 6×6
  witness re-derived as a literal instance). Guard-pinned inline + in SlabAxiomGuard.
- **Organizing theorem, provable half** (`EquivariantGradedIndex`):
  `graded_budget_decomposition` ("unification is decomposition" as a graded
  supertrace identity; NOT a topological index; budget still enters as a hypothesis
  — the carrier instantiation is the running job `gradedfire`).
- **Full-sector gap** (`SectorMassGap`): `Msec` gap = λ−|κ| (honest scope: isospectral
  mirror pair, carrier-tied via the (2,1) block only).
- **Within-carrier prediction** (`MassSpacingPrediction`): the three levels are
  equally spaced (P-spacing, scale-invariant, with a kill condition).
- **Free 2nd-quantized gap** (`FockMassGap`): `dΓ(B)` gap = one-particle gap.
- **Interacting bound state** (`InteractingTwoBody`): a genuine two-body state
  strictly below the constituent threshold (M; the physical *hadron* identification
  stays C — V's form modelled, not derived).
- **Continuum-limit finite facts** (`ContinuumLimit`): mass shell `E²=k²+m²`, the
  transfer-generator ↔ Dirac-Hamiltonian symbol match (continuum *theorem* stays
  [import]/open).

## Program-level crux upgrades

1. §6 S1-CC closure-positivity: MEMO → **kernel on the explicit witness**
   (`balanced_on_physical_sector`), THEN the witness→general **balance mechanism**
   → **general kernel** (`compression_balanced`, `compression_balanced_eigbasis`,
   `witness_balanced_via_general`, all M). What stays MEMO is now only the
   *existence of a b-adapted presentation of the actual sector V'/N* (dimension-
   pinned, complementary to range Q_G, form descending) — a formalization gap, not
   a mathematical risk (two adversarial reviews confirm the balance survives the
   quotient). The presentation-existence proof is the live Aristotle frontier.
2. T2 Clifford provenance: oracle → **kernel** (recipe match).
3. T3b binding defect: conjecture → **block-level theorem** (Δ = −κ).
4. §9 interacting hadron mass: "open" → **below-threshold bound state is a theorem**;
   the interaction is a genuine 2nd-quantized closure operator, binding
   **conditionally** (iff among excited modes, `derived_wrongPlane_no_binding`) —
   the unconditional "carrier's own K binds" and the mass-value stay C (batch-4
   audit corrected an over-claim here from "first-principles" to conditional).

## Reviews actioned

- Fable call-05/06/07/08 (manuscript + semantic-alignment) — all items fixed,
  incl. a §6 crux-box self-contradiction, a docstring-outruns-kernel on the mass-gap
  carrier tie, the D2 generator posit grade, and the Clifford-canonicity over-claim.
- Fable call-09 (S1-CC general reduction) — caught a LOAD-BEARING vacuity: the
  submitted existence lemma was trivially satisfiable (κ=Empty), so "once existence
  is transcribed the crux closes to general M" over-stated the gap size. Fixed
  (mechanism is general M; the *presentation of V'/N* stays MEMO); corrected the
  running Aristotle job to the non-vacuous target.
- Aristotle over-claim audits (batch 1/2/3/4/5) — every load-bearing finding fixed.
  Batch-4: DerivedInteraction "first-principles" → conditional. Batch-5:
  independent confirm of Fable call-09 + the reassuring ruling that the balance
  genuinely survives the quotient (range Q_G is b-invariant ⇒ ± pairs cancel).

## Provenance strengthened (lit)

- §6 balanced-signature mechanism grounded in the Krein / indefinite-spectral-triple
  literature (van den Dungen 1505.01939, Bizi 1812.00038) — [import] setting,
  [orig] anticonjugation-forces-balance argument.
- §6 physical-subspace/quotient analogy: verified + cited Gupta 1950, Bleuler 1950,
  Kugo–Ojima 1979. All five VERIFIED in `Null_Edge_References.md`.

## In flight (Aristotle) + honest open items

- Running: `s1ccpres` (the S1-CC presentation-existence proof — corrected to the
  non-vacuous dimension-pinned/range-complement/descent target; the last MEMO piece
  of the central crux); `audit-batch6` (dynamics/spectral flagship over-claim
  audit).
- Genuinely open (honest boundaries, not pending calcs): the neutrino mass ratio
  (category error — needs a generation index + cross-carrier scale); the Cl(4)
  continuum theorem (Trotter–Kato, outside the finite kernel); tying the carrier's
  own K to the hadron binding plane (conditional binding is M); the b-adapted
  V'/N-presentation existence (in-flight); the aperture-rescue larger-Clifford route
  for *surviving* positivity (§6 route 1 / §10 crux 0).

Verification: the default `lake build` (**trusted** `PhysicsSM` lib) is green at
**8298 jobs** — but that target does NOT include the NullEdge draft flagships (they
live in `PhysicsSMDraft`, per the root docstring). Each NullEdge module this session
was verified by explicit `lake build PhysicsSM.Draft.…` (green, guard pins passing);
that per-module build is the verification of record. `PhysicsSMDraft` (the draft
enforcement lib) currently fails repo-wide on an unrelated pre-existing E8 module
(`E8ThetaDim8MF` / `SpherePacking`), so draft-lib CI enforcement is down independent
of this work. Guard-pin axiom prints
pass). ~50 `solo-202607:` commits.
