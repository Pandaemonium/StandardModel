# P1 Plücker obstruction (B6) and SL(2,C) covariance (B9): deliverable

Job: package the P1 Plücker mass invariant as the first canonical
obstruction-map instance (B6) and add the strongest realistic covariance
wrapper (B9).

This note records (1) the strongest existing finite theorems, (2) the new
obstruction packaging and covariance theorems added, (3) a P1
theorem-to-Lean crosswalk, (4) the distinct mass normalizations kept apart,
and (5) the publishable-vs-draft boundary and exactly what novelty P1 may claim.

All new theorems are kernel-checked, `sorry`-free, and depend only on the
standard axioms `propext, Classical.choice, Quot.sound`.

---

## 1. Strongest existing finite theorems (inputs)

The trusted, no-`sorry` module `PhysicsSM.Spinor.PluckerMass`
(file `PhysicsSM__Spinor__PluckerMass.lean`) already proves:

- `two_edge_plucker_mass_identity` —
  `det (psi psi^† + phi phi^†) = |psi ∧ phi|^2`.
- `two_edge_mass_zero_iff_wedge_zero` — two-null masslessness iff zero wedge.
- `spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero` — zero wedge iff
  projective collinearity (no quotients).
- `fin_bundle_plucker_mass_identity` —
  `det (Σ_i psi_i psi_i^†) = Σ_{i<j} |psi_i ∧ psi_j|^2` (general finite bundle).
- `fin_bundle_det_eq_ofReal_nonneg`, `fin_bundle_det_re_nonneg`,
  `fin_bundle_det_im_eq_zero` — the determinant mass is a nonnegative real.
- `fin_bundle_mass_zero_iff_common_direction` — finite massless-collinearity
  criterion relative to a chosen nonzero base spinor.

The frame-audit lemma `sl2_congruence_det_invariant`
(file `PhysicsSM__Draft__NullEdgeP1SL2Frame.lean`) proves
`det (A P A^†) = det P` for `det A = 1` (the algebraic seed of B9).

These are the strongest finite statements; the new files promote them into a
canonical interface and prove the covariance behaviour explicitly.

---

## 2. New deliverables (Lean patch)

### B6 — canonical obstruction packaging
File `PhysicsSM__Spinor__PluckerObstruction.lean`, namespace
`PhysicsSM.Spinor.PluckerObstruction`.

- `MasslessObstruction (Config)` — a small, reusable interface: a nonnegative
  real obstruction `B` plus a `Massless` predicate, with the two defining
  facts `obstruction_nonneg` and `vanishes_iff_massless`.
- `bPlTwoEdge : MasslessObstruction (CSpinor × CSpinor)` — the two-edge
  Plücker obstruction `B_Pl = |psi ∧ phi|^2`, certifying two-null
  masslessness.
- `bPlBundle (n) : MasslessObstruction (Fin n → CSpinor)` — the finite-bundle
  Plücker obstruction `B_Pl = Σ_{i<j} |psi_i ∧ psi_j|^2`, certifying
  `PairwiseWedgeZero` (all visible directions collinear).
- Supporting bridges: `twoEdgeObstruction_eq_det_re`,
  `bundleObstruction_eq_det_re` (the obstruction is the real part of the
  determinant mass), and `bundleObstruction_eq_zero_iff_common_direction`
  (collinearity reading with a nonzero base spinor).

`B_Pl` is fixed to the **unnormalized determinant/spread invariant**.

### B9 — SL(2,C) covariance wrapper
File `PhysicsSM__Spinor__PluckerMassCovariance.lean`, namespace
`PhysicsSM.Spinor.PluckerMassCovariance`.

- `actSpinor A psi = A.mulVec psi` — the `GL(2,C)`/`SL(2,C)` action on visible
  Weyl spinors.
- `spinorWedge_actSpinor` — the wedge is a relative invariant of weight
  `det A`: `wedge (A·psi)(A·phi) = det A · wedge psi phi`.
- `spinorWedge_sl2_invariant` — on `SL(2,C)` (`det A = 1`) the wedge is invariant.
- `twoEdgeObstruction_actSpinor` / `twoEdgeObstruction_sl2_invariant` —
  `B_Pl` scales by `|det A|^2`, and is invariant on `SL(2,C)`.
- `rankOneHermitian_actSpinor`, `finBundleMomentum_actSpinor` — the bundle
  momentum transforms by congruence `A M A^†`.
- `finBundleMomentum_det_actSpinor` / `finBundleMomentum_det_sl2_invariant` —
  the determinant mass scales by `|det A|^2` and is `SL(2,C)`-invariant.
- `bundleObstruction_actSpinor` / `bundleObstruction_sl2_invariant` — same for
  the bundle `B_Pl`.
- `pairwiseWedgeZero_actSpinor`, `pairwiseWedgeZero_sl2_iff` — the massless
  locus is preserved by any linear action and is an `SL(2,C)`-invariant.

**Covariance strength and the one remaining gap.** `SL(2,C)` is the double
cover of the proper-orthochronous Lorentz group `SO⁺(1,3)`, so `SL(2,C)`
congruence-invariance of the determinant mass *is* proper-orthochronous
Lorentz invariance of the visible mass scalar. We prove the full algebraic
`SL(2,C)` statement here. The only piece **not** formalized is the explicit
covering homomorphism `SL(2,C) → SO⁺(1,3)`; supplying that map would upgrade
these theorems verbatim into a stated Lorentz-representation invariance.

---

## 3. P1 theorem-to-Lean crosswalk

| P1 statement | Lean theorem | File |
| --- | --- | --- |
| Two-null mass = wedge modulus | `two_edge_plucker_mass_identity` | `PhysicsSM__Spinor__PluckerMass` |
| Two-null massless ⇔ wedge = 0 | `two_edge_mass_zero_iff_wedge_zero` | `PhysicsSM__Spinor__PluckerMass` |
| Wedge = 0 ⇔ collinear directions | `spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero` | `PhysicsSM__Spinor__PluckerMass` |
| Finite bundle mass = Σ pairwise spread | `fin_bundle_plucker_mass_identity` | `PhysicsSM__Spinor__PluckerMass` |
| Determinant mass is a nonnegative real | `fin_bundle_det_eq_ofReal_nonneg` | `PhysicsSM__Spinor__PluckerMass` |
| Bundle massless ⇔ common direction | `fin_bundle_mass_zero_iff_common_direction` | `PhysicsSM__Spinor__PluckerMass` |
| `1+1` split: `m² = 4ab`, massless ⇔ `a=0 ∨ b=0` | `splitMassSq_eq_zero_iff_left_or_right_zero` | `PhysicsSM__Draft__NullEdgeP1TwoNullMasslessIff` |
| `1+1` split: mass product `4ab = m²` | `four_mul_split_energy_product_eq_massSq` | `PhysicsSM__Draft__NullEdgeP1TwoNullMassProduct` |
| Observer ratio `2√det ρ = m/E` | `two_sqrt_normalizedVisibleDet_eq_pluckerMass_over_energy` | `PhysicsSM__Draft__NullEdgeP1PluckerObserverScalarBridge` |
| `SL(2,C)` congruence preserves det | `sl2_congruence_det_invariant` | `PhysicsSM__Draft__NullEdgeP1SL2Frame` |
| **B6** canonical obstruction `B_Pl` (two-edge) | `bPlTwoEdge` | `PhysicsSM__Spinor__PluckerObstruction` (new) |
| **B6** canonical obstruction `B_Pl` (bundle) | `bPlBundle` | `PhysicsSM__Spinor__PluckerObstruction` (new) |
| **B6** `B_Pl` is the real part of det mass | `bundleObstruction_eq_det_re` | `PhysicsSM__Spinor__PluckerObstruction` (new) |
| **B9** wedge relative-invariant of weight `det A` | `spinorWedge_actSpinor` | `PhysicsSM__Spinor__PluckerMassCovariance` (new) |
| **B9** det mass scales by `|det A|²` | `finBundleMomentum_det_actSpinor` | `PhysicsSM__Spinor__PluckerMassCovariance` (new) |
| **B9** `B_Pl` invariant on `SL(2,C)` | `bundleObstruction_sl2_invariant` | `PhysicsSM__Spinor__PluckerMassCovariance` (new) |
| **B9** massless locus is `SL(2,C)`-invariant | `pairwiseWedgeZero_sl2_iff` | `PhysicsSM__Spinor__PluckerMassCovariance` (new) |

---

## 4. Distinct mass normalizations (kept separate, by design)

These are deliberately **not** identified; each has its own definition:

- **Determinant / spread invariant** `B_Pl` — `bundleObstruction` /
  `(finBundleMomentum psi).det`. The frame-independent, `SL(2,C)`-invariant
  scalar. This is the one promoted to the canonical obstruction.
- **Trace-pairing convention** — `twoTwistorMassSqTraceConvention` /
  `multiTwistorMassSqTraceConvention` (factor `2` kept explicit), in
  `PhysicsSM__Spinor__TwistorPluckerMass`.
- **Frame-relative / observer-normalized** — `normalizedVisibleDet`
  `= ab/(a+b)²` and the readout `2√det ρ = m/E`, in
  `PhysicsSM__Draft__NullEdgeP1PluckerObserverScalarBridge`. Observer-relative,
  **not** invariant.

The covariance theorems apply to the determinant/spread invariant; the
observer-normalized density is explicitly the frame-dependent quantity.

---

## 5. Publishable vs draft, and the safe novelty claim

**Publishable for P1 (trusted, promoted, kernel-clean):**
`PhysicsSM__Spinor__PluckerMass`, the new
`PhysicsSM__Spinor__PluckerObstruction` (B6) and
`PhysicsSM__Spinor__PluckerMassCovariance` (B9), and the trusted twistor
wrappers `PhysicsSM__Spinor__TwistorPluckerMass`.

**Remains draft infrastructure:** the `PhysicsSM__Draft__*` modules
(observer-scalar bridge, `1+1` split, SL(2,C) frame audit, twistor draft).
Two draft files — `PhysicsSM__Draft__NullEdgePluckerGeneralAristotle` and
`PhysicsSM__Draft__NullEdgeBundleDiracPluckerCore` — currently fail to build
because they import upstream source modules (`PhysicsSM.Draft.NullEdgeCoreAristotle`
and `PhysicsSM.Draft.NullEdgeDiracSlashCore`) that are **not present** in this
project. This breakage pre-exists this job and is outside the B6/B9 scope; the
former is in any case a superseded duplicate of the trusted
`PhysicsSM__Spinor__PluckerMass`. (Two other draft files,
`PhysicsSM__Draft__TwistorPluckerMass` and
`PhysicsSM__Spinor__TwistorPluckerMass`, had the same dotted-import typo and
were repaired to import `PhysicsSM__Spinor__PluckerMass`; they now build.)

**What P1 can safely claim (guardrail-respecting):**
P1 is a *finite kinematic theorem with a canonical, Lorentz-covariant
obstruction*, namely:

> For a finite family of visible null Weyl spinors, the unnormalized
> determinant mass equals the total pairwise squared Plücker spread `B_Pl`,
> a nonnegative `SL(2,C)`-invariant scalar that vanishes **exactly** when the
> null directions are collinear. Masslessness ⇔ collinearity; mass is the
> spread accounting, and it is invariant under proper-orthochronous Lorentz
> frame changes (`SL(2,C)` congruence).

P1 must **not** claim that all mass *is* Plücker spread, nor that this is a
dynamical or continuum mass-generation mechanism. The result is finite linear
algebra: an exact identity, a sharp massless ⇔ collinear criterion, and the
covariance that makes `B_Pl` frame-independent.
