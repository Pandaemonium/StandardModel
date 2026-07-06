Extend the QMF1-RP compact-Haar substrate from the SINGLE link to a MULTI-LINK
product-Haar configuration space - the audited "pending next rung" toward
reflection positivity for a lattice gauge ensemble
(`AgentTasks/fourday-ym-run-2026-07-05/QMF_RP_LOAD_BEARING_AUDIT.md`).

Existing single-link substrate (reuse, do not redefine):
`PhysicsSM/Draft/NullEdge/QMF/CompactHaarInvariance.lean`,
`SpecialUnitaryCompact.lean`, `GaugeHaarInvariance.lean` -
`specialUnitaryGroup_isCompact`, `_isTopologicalGroup`,
`compactGroup_haar_isMulRightInvariant` (unimodularity),
`specialUnitaryGroup_haar_gauge_invariant`, `_reflection_invariant`,
`specialUnitaryGroup_exists_isHaarMeasure`.

Create a NEW module `PhysicsSM/Draft/NullEdge/QMF/ProductHaarConfig.lean`.
Check with `lake env lean`. If broader `lake build` stalls, SKIP and return
source.

## Deliverable

Over a FINITE edge set `E` (`[Fintype E]`), the gauge-field configuration space
is `Config := E -> SU(N)` (equivalently `Pi_e SU(N)`). Build:

1. **Product Haar measure** `mu_E := Measure.pi (fun _ => haar)` on `Config`,
   with a proof it is a Haar measure / is invariant under the pointwise group
   action - i.e. `compactSpace`/`isProbabilityMeasure` as available, reusing the
   single-link `specialUnitaryGroup_exists_isHaarMeasure` and Mathlib's
   `Measure.pi` + `isCompact_univ_pi` / product-of-compact facts.
2. **Per-link gauge invariance** of the product-Haar expectation: for a gauge
   transformation acting on link `e0` by conjugation (or the lattice gauge
   action `U_e -> g_{s(e)} U_e g_{t(e)}^{-1}` at the two endpoints), the
   integral of an observable over `Config` is unchanged. Derive it from the
   single-link `specialUnitaryGroup_haar_gauge_invariant` via
   `MeasureTheory.integral_pi` / Fubini on the product measure (integrate the
   `e0` factor first).
3. **The link-reflection involution on configurations.** Define an involution
   `theta : Config -> Config` implementing a reflection across a cut that maps
   positive-side links to their mirror images with link inversion
   `U_e -> U_{theta e}^{-1}`, prove it is measure-preserving for `mu_E` (reuse
   single-link `_reflection_invariant` / inversion-invariance of Haar).
4. **The RP bilinear-form STATEMENT** on the doubled configuration space: state
   (statement-freeze, proof optional) the reflection form
   `<F, G> := integral over Config of (theta*F) * G` and the target
   `IsReflectionPositive`-style nonnegativity `0 <= <F, F>` for functionals `F`
   supported on the positive side. You need NOT prove positivity (that needs the
   Wilson slab / character expansion); DEFINE the form and freeze the theorem
   statement with a documented `s o r r y` handoff if unproved, clearly labeled.

## Constraints

- Peter-Weyl / character orthogonality is OUT OF SCOPE - do not assume it.
- Parts 1-3 should be genuinely PROVED (`s o r r y`-free); part 4 may be a
  statement-freeze with a documented handoff `s o r r y` if you cannot close
  positivity from the product structure alone. Mark clearly which is which.
- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening.
- Claim-label honestly: "multi-link product-Haar gauge/reflection substrate;
  RP positivity is the pending rung." Draft-trust. This is a LINK-symmetry /
  OS-ingredient result, NOT RP itself and NOT a transfer operator.
- If `lake build` stalls, SKIP; return source + a note on proved vs frozen.
