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

1. §6 S1-CC closure-positivity: MEMO → **kernel on the explicit witness**.
2. T2 Clifford provenance: oracle → **kernel** (recipe match).
3. T3b binding defect: conjecture → **block-level theorem** (Δ = −κ).
4. §9 interacting hadron mass: "open" → **below-threshold bound state is a theorem**
   (only deriving V from closure geometry stays open).

## Reviews actioned

- Fable call-05/06/07/08 (manuscript + semantic-alignment) — all items fixed,
  incl. a §6 crux-box self-contradiction, a docstring-outruns-kernel on the mass-gap
  carrier tie, the D2 generator posit grade, and the Clifford-canonicity over-claim.
- Aristotle over-claim audits (batch 1/2/3) — every load-bearing finding fixed.

## In flight (Aristotle) + honest open items

- Running: `gradedfire` (fire graded-budget on the real carrier), `hadronV`
  (derive the hadron interaction V from closure geometry — the C→M step).
- Genuinely open (honest boundaries, not pending calcs): the neutrino mass ratio
  (category error — needs a generation index + cross-carrier scale); the Cl(4)
  continuum theorem (Trotter–Kato, outside the finite kernel); deriving V for a
  first-principles hadron mass; the general-representative S1-CC reduction.

Full build: green (~8092 jobs incl. all new modules). ~40 `solo-202607:` commits.
