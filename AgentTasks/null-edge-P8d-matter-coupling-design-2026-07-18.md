# P8(d) design: sourcing the finite Einstein equation with the soldered Dirac action

Date: 2026-07-18. Plan: P8(d)
(`Sources/Null_Edge_Ten_Priorities_Research_Plan_2026-07-18.md`). Status:
DESIGN / scoping - no theorem claimed. Lane protocol: this is Claude's
COMPLEMENT to codex's (a)-(c); new module names only
(`PhysicsSM/Draft/NullEdge/PalatiniDiracSource*.lean`), no edits to codex's
Palatini files.

## Target theorem (stage 2 endpoint)

`joint stationarity of S_grav[e, U] + S_Dirac[e, psi] in (connection, coframe)
<-> link Euler equation AND mixed Einstein coefficient = fermion stress tensor
coefficient` - the finite sourced Einstein equation, extending codex's landed
vacuum `nonlinearCoframePlaquetteJointStationary_iff_linkEuler_and_mixedEinstein`.

## Coupling interfaces (verified present in the current tree)

- Gravity side: `NonlinearLorentzPalatiniAction.nonlinearCoframePlaquetteAction`
  with coframe response `nonlinearCoframePlaquetteCoframeFirstResponse` and the
  Euler functional `nonlinearCoframeLocalEulerFunctional`
  (`NonlinearLorentzPalatiniCoframeVariation`); the Einstein normalization
  bridge (`palatiniDensityFirstVariation_eq_det_mul_mixedEinstein`).
- Matter side: the soldering capstone architecture
  `sum_a c(alpha^a) nabla_ell_a` (dual covector soldering in `alpha^a`,
  primitive null support in `ell_a` - per `docs/NULLSTRAND.md`, NOT the
  diagonal null operator) and P2's `DixonDiracGamma` Clifford layer
  (`eta = diag(-1,+1,+1,+1)` - the mostly-plus bridge to the Palatini
  conventions MUST be pinned in stage 0).

## Stages

- **Stage 0 (convention gate, small):** pin the signature/orientation bridge
  between the gamma layer (mostly-plus) and codex's Krein/Hodge conventions
  (their Einstein bridge fixes `PalatiniDensity(1,F) = -ScalarCurvature(1,F)`).
  One doc section + one Lean lemma relating the two eta's. No physics yet.
- **Stage 1 (free Dirac action on the lattice):** define
  `S_Dirac[e, psi] = sum_sites psi-dag (gamma-contract (e) . finite-difference)
  psi` with the coframe entering ONLY through the soldered contraction
  (`c(alpha^a)` coefficients linear in the inverse coframe). Kernel targets:
  reality of the action, gauge behavior under the landed
  `coframeGaugeTransform`, and LINEARITY of `S_Dirac` in each coframe entry
  (the property that makes its first response a stress tensor).
- **Stage 2 (the source theorem):** compute the coframe first response of
  `S_Dirac` (finite, exact - same calculus as codex's
  `coframeFaceWeightFirstVariation`), package it as
  `fermionStressCoefficient`, and prove the sourced stationarity iff. Claim
  label: finite identity; no continuum limit claimed.
- **Stage 3 (audit hooks):** vacuity guard (a nonzero psi witness on a small
  lattice with nonzero stress coefficient); the zero-fermion limit must
  reproduce codex's vacuum theorem EXACTLY (regression gate).

## Kill conditions

- If the mostly-plus/mostly-minus bridge forces sign changes inside codex's
  landed modules, STOP - the bridge lemma must absorb the difference; their
  files are frozen interfaces for this lane.
- If the soldered contraction cannot be written linearly in the inverse
  coframe without importing a metric (circularity with the Malament-split
  discipline), record and re-scope to a decorated-tetrad hypothesis
  (per AGENTS.md: a bare graph does not canonically supply a tetrad).

## Non-goals (stated to keep the claim honest)

No continuum Dirac equation, no back-reaction dynamics, no interacting
fermions, no positivity/stability claims (Krein caution per NULLSTRAND). The
deliverable is the exact finite sourced-stationarity identity.
