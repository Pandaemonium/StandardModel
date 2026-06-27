# FUR-G2 true-gauge quotient descent for Phi_H -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 67470909-c75a-45ac-85cc-70ea3317d1d9
Full-repo package; deliverables preserved here from the returned summary (the
standalone report file was not shipped separately).

---

Wave 16 FUR-G2 — true-gauge quotient descent for `Φ_H` — completed.

## Solved targets
Created `PhysicsSM/Draft/NullEdgeFureyTrueGaugePhiH.lean` (module `PhysicsSM.Draft.NullEdgeFureyTrueGaugePhiH`), wiring the legal `Φ_H` interface (`GaugeCovariantPhiH`, parametric over an arbitrary `Monoid G`) to the *true* Standard Model gauge surface `SMCoveringQuotient` (the ℤ₆-quotient of the `U(1)×SU(2)×SU(3)` cover, proven equivalent to the `S(U(2)×U(3))` block units). All declarations are sorry-free and axiom-free; the file builds (verified by an explicit module build against the project's gauge island).

Delivered the full requested API layer:
1. **True gauge surface named**: `TrueGaugeGroup := SMCoveringQuotient`, plus `trueQuotientQubitQutritAction` re-exporting the existing genuine quotient representation `quotientActQubitPlusQutritHom`.
2. **Kernel-triviality / descent**: `CoverFactoringPhiH` (a cover-level datum over `SMCoveringTriple` whose chiral reps are constant on image-equivalence classes) with `CoverFactoringPhiH.descend : GaugeCovariantPhiH _ _ SMCoveringQuotient`, and `descend_kernel_trivial` showing every covering element of trivial image (in particular the six ℤ₆ kernel elements) acts as the identity class.
3. **Any quotient intertwiner is a proper null-edge Furey `Φ_H`**: `phiH_proper_trueQuotient` (χ_E-odd, Γ_s-even/`+Φ_H²` sign, gauge-covariant for **every** element of the true SM quotient group, squares to the checkerboard mass block), with `phiH_gauge_covariant_trueQuotient` and `descend_isProperPhiH` corollaries.
4. **Precise handoff** documented in-file.

## Changed statements
None weakened. No existing statement modified.

## Main blocker / exact missing theorem (adversarial finding)
As suspected in the prompt, the existing genuine quotient *representation* (`quotientActQubitPlusQutritHom`) acts only on the gauge carrier `QubitPlusQutrit = ℂ²⊕ℂ³` (fundamental qubit⊕qutrit) — it is **not** split into a chiral `L⊕R` Yukawa carrier and is **not** tied to the Furey minimal left ideal `J`/`J*` or the null-edge occupation lattice `Occ = Finset (Fin 3)`. No `NullEdge*` file imports any `Algebra/Furey/*` module, so the chiral-carrier identification does not exist as a Lean dependency. The remaining handoff (stated explicitly in the file's final docstring) is to supply finite-dimensional Hermitian chiral carriers `H_L,H_R` identified with the Furey/occupation data, chiral representations `ρ_L,ρ_R : SMCoveringTriple → End` that factor through `SMCoveringQuotient`, and a gauge-intertwining Yukawa block `M` — i.e. an actual `CoverFactoringPhiH` instance on the physical carrier. I deliberately did not encode this as a Prop goal, because a `GaugeCovariantPhiH` over the quotient exists trivially (e.g. `M = 0`); the genuine content is the physical charge-carrying identification, which is the precise open work. The descent and correctness machinery on this side is complete and waits only for that identification.

## Proof holes / handoff markers
No `sorry`/axioms. The single handoff is the documented missing representation bridge above.

## Files changed
- Added `PhysicsSM/Draft/NullEdgeFureyTrueGaugePhiH.lean` (new).
- `PhysicsSMDraft.lean`: added the import of the new module.
(The `lakefile.toml`/`lake-manifest.json` were temporarily adjusted only to build without the unrelated, unfetched optional `SpherePacking` dependency, then restored byte-for-byte to their original state.)
