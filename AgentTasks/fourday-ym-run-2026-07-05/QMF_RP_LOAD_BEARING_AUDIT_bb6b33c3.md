# Load-bearing audit — QMF compact/Haar reflection-positivity substrate

> Note: per the request, this audit was produced **without running `lake build`**.
> Findings below are from static reading of the sources; the code has **not** been
> re-kernel-checked in this session. Where a claim depends on the build, that is
> flagged explicitly.

Files audited:

- `PhysicsSM/Draft/NullEdge/QMF.lean` (aggregator)
- `PhysicsSM/Draft/NullEdge/QMF/CompactHaarInvariance.lean`
- `PhysicsSM/Draft/NullEdge/QMF/SpecialUnitaryCompact.lean`
- `PhysicsSM/Draft/NullEdge/QMF/GaugeHaarInvariance.lean`

No `sorry` or `axiom` declarations appear in any of the four files (grep-confirmed).

---

## Verdict

The substrate is **coherent and semantically aligned** with a compact `SU(N)`
single-link Haar model, and it genuinely closes the *single-link* gauge- and
reflection-invariance sublane (QMF1-RP) for the physical nonabelian gauge group.
The three advertised Mathlib gaps (compact ⇒ right/inv-invariance for nonabelian
groups; `U(n)`/`SU(n)` compactness; `SU(n)` topological-group structure) are
filled by real proofs, not restatements.

However, this is a **single-link substrate only**. It does *not* by itself
close a reflection-positivity rung: there is no lattice, no reflection operator
on a product/field configuration space, no positive-definiteness statement, and
no transfer operator. Calling it "QMF1-RP complete" is accurate only in the
narrow sense of "the link-integral symmetries RP will consume are in place." The
Peter–Weyl / character-expansion gap is correctly parked (it is nowhere assumed),
but it is not the only thing separating this substrate from an actual RP theorem.

Caveat: because the build was skipped this session, "kernel-checked / `sorry`-free"
is taken from the file headers and a source grep, not re-verified here.

## Statement alignment

- **Gauge invariance** (`haarExpectation_conj_invariant`,
  `compact_haarExpectation_conj_invariant`,
  `specialUnitaryGroup_haar_gauge_invariant`): `∫ f(g x g⁻¹) dμ = ∫ f dμ`. This
  is the correct single-link statement of gauge (conjugation) invariance and is
  derived honestly from right- then left-invariance. Aligned.
- **Reflection invariance** (`haarExpectation_inv_invariant`,
  `compact_haarExpectation_inv_invariant`,
  `specialUnitaryGroup_haar_reflection_invariant`): `∫ f(x⁻¹) dμ = ∫ f dμ`,
  a specialization of `integral_inv_eq_self`. This is the correct action of the
  OS reflection *on a single link variable*. Aligned as a symmetry; see caveat
  below — link-inversion invariance is a *necessary ingredient* of OS reflection
  positivity, not RP itself.
- **Compactness** (`unitaryGroup_isCompact`, `specialUnitaryGroup_isCompact`)
  and **topological-group** (`unitaryGroup_isTopologicalGroup`,
  `specialUnitaryGroup_isTopologicalGroup`, `specialUnitaryGroup_continuousInv`)
  are stated for `Matrix.unitaryGroup/specialUnitaryGroup (Fin n) ℂ`, i.e. the
  intended `U(n)`/`SU(n)`. Aligned with the physical color/isospin groups; the
  `SU(2)`/`SU(3)` named specializations are literal instances of the general
  `SU(n)` result.
- **Existence** (`specialUnitaryGroup_exists_isHaarMeasure`) records
  non-vacuousness via `Measure.haarMeasure` on the Borel σ-algebra. Aligned.

## Hidden-assumption audit

- **Haar existence is not silently assumed in the general lemmas.** The general
  invariance theorems take `[μ.IsHaarMeasure]` (or explicit invariance
  typeclasses) as hypotheses; existence is proved separately for `SU(N)`. Good.
- **Unimodularity is proved, not assumed.** `compactGroup_haar_isMulRightInvariant`
  and `compactGroup_haar_isInvInvariant` derive right- and inversion-invariance
  from `[CompactSpace G]` + `[IsHaarMeasure]` via
  `isMulInvariant_eq_smul_of_compactSpace` and a `μ univ` finite/nonzero scalar
  argument. This is the correct classical argument and is the load-bearing new
  content. No `CommGroup` sneaks in.
- **`MeasurableSpace`/`BorelSpace` are instance arguments**, not global
  instances, on the matrix subtype. This is a deliberate, honest choice
  (avoids asserting a canonical Borel structure). Consumers must supply matching
  `MeasurableSpace`/`BorelSpace`; the existence lemma shows a compatible choice
  exists.
- **The integral identities carry no integrability hypothesis** and hold for all
  `f : G → E` with `E` a real normed space, relying on Mathlib's
  `integral_mul_left/right_eq_self` / `integral_inv_eq_self`, which hold for the
  full Bochner integral (returning 0 for non-integrable `f`). Nothing is hidden
  here; just note the statements are about the (possibly junk-valued on the
  non-integrable set) Bochner integral.
- **No hidden lattice/RP assumption.** There is no configuration space, product
  measure, reflection map on fields, or positivity claim anywhere — so nothing
  RP-shaped is smuggled in. This is the flip side of the verdict: nothing is
  hidden, but also nothing RP-level is delivered.

## Axiom/dependency concerns

- Source grep finds **no `axiom` and no `sorry`** in the four files.
- **Not re-verified this session** (build skipped by request). The
  "`sorry`-free, kernel-checked" and `#print axioms`-clean status asserted in the
  headers was **not** reconfirmed here; a full `lake build PhysicsSM.Draft.NullEdge.QMF`
  plus `#print axioms` on the capstone lemmas is the remaining check before
  trusting the substrate.
- Dependencies are Mathlib-only (`import Mathlib`) plus the two sibling QMF
  modules for the capstone. The `SpherePacking` remote dependency noted in the
  submission package is unrelated to these files.
- The files live under `PhysicsSM/Draft/` and the aggregator states it is
  *not* on the default trusted build target ("draft-trust"). So even a green
  build here does not fold into the trusted target — appropriate for a frontier
  substrate.

## Next theorem target

Smallest frontier theorem connecting this substrate to existing finite-RP /
transfer scaffolding, in increasing order of ambition:

1. **Product-measure link average (multi-link).** Lift the single-link
   invariances to a finite product `∏_e SU(N)` with the product Haar measure:
   gauge invariance under a simultaneous conjugation and reflection invariance
   under link inversion on the reflected half. This is the first genuinely new
   statement (currently everything is one link) and is a direct `Measure.pi`
   application of the proved single-link facts.
2. **A reflection-positivity bilinear form.** Define the OS inner product
   `⟨f, g⟩ = ∫ (Θf)·g` for observables on the "positive-time" links (Θ = the
   reflection that inverts crossing links) and prove `⟨f, f⟩ ≥ 0` for a nearest-
   neighbour class of observables. This is the actual RP rung; the link
   symmetries here are exactly its ingredients.
3. **Bridge to existing finite RP scaffolding.** If the finite/transfer
   scaffolding is stated for `Measure.count` on finite groups, the
   `FiniteModel` section (`count_conj_invariant`, `count_inv_invariant`) is the
   natural hook — a single lemma identifying the finite-group counting
   expectation used there with the `haarExpectation_*` API would connect the two
   without any new analysis.

The **recommended immediate target** is (1): it is provable from what exists,
and it is the honest boundary between "single-link symmetries" (done) and
"RP on a lattice" (not started).

## Recommended claim language

Replace "closes the QMF1-RP rung" with a precise scoping:

> *"Establishes the single-link Haar-expectation gauge (conjugation) and
> reflection (inversion) invariances for the compact nonabelian gauge group
> `SU(N)`, including the supporting facts that `U(n)`/`SU(n)` are compact
> topological groups and that compact-group Haar measure is bi-invariant and
> inversion-invariant. These are the link-level symmetry ingredients that an
> Osterwalder–Seiler reflection-positivity argument consumes; the RP bilinear
> form, its positivity, and the lattice/transfer construction are not yet
> formalized. The Peter–Weyl / character-expansion sublane is correctly parked
> as a separate, currently-unformalized rung and is nowhere assumed."*

Avoid "QMF1-RP complete" unqualified; prefer "QMF1-RP link-symmetry substrate
complete (single link); RP form and lattice construction pending."
