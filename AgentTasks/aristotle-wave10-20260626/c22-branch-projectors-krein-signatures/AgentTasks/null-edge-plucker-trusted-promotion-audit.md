# I7 - Trusted Plucker convention banner and P1 crosswalk cleanup

Date: 2026-06-26. Type: Audit/Patch (semantic trust; no new mathematics).

Scope: add machine-checkable convention/provenance banners to the two newly
trusted Spinor modules, and correct the P1 manuscript/crosswalk claim labels so
that absent twistor modules are no longer marked `trusted` and the
now-trusted SL(2,C) covariance is no longer marked `draft`.

Primary files touched:

- `PhysicsSM/Spinor/PluckerObstruction.lean` (banner added to module docstring).
- `PhysicsSM/Spinor/PluckerMassCovariance.lean` (banner added to module docstring).
- `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` (anchors, provenance
  note, Sections 7, 8, 11, 12 crosswalk).
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` (P1 "Banked Lean"
  paragraph).

No theorem statements were altered. All Lean edits are inside the existing
`/-! ... -/` module docstrings, so they cannot affect elaboration.

Note on build: this is a focused snapshot (see `FOCUSED_PACKAGE_NOTE.md`); the
trusted base module `PhysicsSM.Spinor.PluckerMass` is not vendored here, so the
two Spinor files do not build in isolation. The banner edits are documentation
only and are intended for integration into the full repository, where the
modules already build kernel-clean per the Wave 8 integration note.

---

## 1. Convention banner content (both files)

Each banner records, tied to concrete declarations:

- Metric / signature: mostly-minus Lorentzian `(+,-,-,-)`; `p^2 = 0` null,
  `p^2 = m^2` massive (matches `docs/CONVENTIONS.md`, Locked).
- Spinor convention: `CSpinor = (Fin 2 -> C)`; null bispinor
  `rankOneHermitian psi = vecMulVec psi (star psi) = psi psi^dagger`.
- Determinant / mass normalization: determinant convention;
  `B_Pl = Re (det (finBundleMomentum psi))` (unnormalized). Trace-pairing
  variant (`2 * det`) and observer-normalized `rho = P / Tr P` are separate and
  unused.
- Plucker bracket / squared modulus:
  `spinorWedge psi phi = psi 0 * phi 1 - psi 1 * phi 0`;
  `complexAbsSq z = z * conj z = (Complex.normSq z : C)`.
- SL(2,C) action convention (covariance file): left `mulVec`,
  `actSpinor A psi = A.mulVec psi`; bispinor congruence `P |-> A P A^dagger`;
  wedge relative invariant of weight `det A`; `B_Pl` and det-mass scale by
  `normSq (det A)`; invariant on `det A = 1`. Only gap: the
  `SL(2,C) -> SO^+(1,3)` covering map (not constructed).
- Relation to older/draft files: the obstruction module is the trusted
  promotion of `PhysicsSM.Spinor.PluckerMass`; the covariance module supersedes
  the kernel-clean draft `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets` (which
  named the action `spinorAction`); the twistor-chart module
  `PhysicsSM.Spinor.TwistorPluckerMass` is a separate, absent module and is not
  imported or relied upon.

---

## 2. P1 crosswalk corrections (Section 12 table + prose)

`T -> A` means the status label changes from `T` (old) to `A` (corrected).

| Crosswalk row | Lean declaration | Old label | Corrected | Reason |
| --- | --- | --- | --- | --- |
| two-twistor mass = wedge | `two_twistor_mass_invariant_eq_plucker` | trusted | **absent (***)** | Module `PhysicsSM.Spinor.TwistorPluckerMass` not present (planned `TwistorPluckerMatch`, backlog B10). M10 audit confirms. |
| multi-twistor mass = pairwise | `multi_twistor_momentum_det_eq_pairwiseMass` | trusted | **absent (***)** | Same absent module. |
| SL(2,C) invariance of det mass | `finBundleMomentum_det_sl2_invariant` | draft (\*\*) | **trusted (dagger)** | Now proven kernel-clean in trusted `PhysicsSM.Spinor.PluckerMassCovariance`; action is `actSpinor`, not the draft `spinorAction`. |
| wedge rel. invariant (weight det A) | `spinorWedge_actSpinor` | (absent from table) | **trusted (dagger)** | Added; trusted covariance module. |
| SL(2,C) invariance of B_Pl | `bundleObstruction_sl2_invariant` | (absent from table) | **trusted (dagger)** | Added; trusted covariance module. |
| SL(2,C) invariance of massless locus | `pairwiseWedgeZero_sl2_iff` | (absent from table) | **trusted (dagger)** | Added; trusted covariance module. |
| canonical obstruction B_Pl = Re(det) | `bundleObstruction_eq_det_re` / `bPlBundle` | (absent from table) | **trusted (dagger)** | Added; trusted obstruction module (B6 packaging). |
| Dirac slash squares to mass | `chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass` | draft (\*\*) | draft (\*\*) (unchanged) | Still a kernel-clean draft in `PhysicsSM.Draft.*`. |
| single null edge / two-edge / bundle / reality / collinearity rows | (`PhysicsSM.Spinor.PluckerMass`) | trusted | trusted (unchanged) | Correctly labeled. |

Footnote legend after correction:

- `*`   kernel-clean standalone Aristotle package (celestial-moment artifacts).
- `**`  kernel-clean draft in `PhysicsSM.Draft.*`; needs convention review.
- `***` ABSENT: `PhysicsSM.Spinor.TwistorPluckerMass` not in repo; re-vendor and
  kernel-check before citing, or keep as future work.
- `dagger` trusted on `PhysicsSM.Spinor` surface with machine-checkable
  convention banner.

Prose corrections applied in the manuscript:

- Header "Lean anchors" list: removed `TwistorPluckerMass` and the
  `NullEdgeSpinorGeometryTargets` draft from the trusted line; added the two new
  trusted modules; added an explicit absent/future note for twistor.
- Provenance check: the 2026-06-25 note over-claimed that `TwistorPluckerMass`
  was re-verified to kernel-check. Revised to state the module is absent and the
  twistor rows are unverified here.
- Section 7: status upgraded draft -> trusted; action corrected
  `spinorAction` -> `actSpinor`; module corrected
  `NullEdgeSpinorGeometryTargets` (draft) -> `PluckerMassCovariance` (trusted).
- Section 8: "From the trusted module ..." -> "Status: absent/future, not
  trusted", statements marked as TARGET (module absent).
- Section 11 claim boundary: SL(2,C) covariance moved into the established list
  as trusted; twistor-chart matching moved into the "separate work required"
  list as absent.

Publication plan (`Null_Edge_Causal_Graph_Publication_Plan.md`) "Banked Lean"
paragraph: removed "Trusted twistor-chart matching ... (promoted, no proof
holes)"; added the two trusted modules; recorded the absent-twistor correction.
The later line "the trusted `SL(2,C)` invariance of the determinant mass" (P9
footing) is now accurate and was left unchanged.

---

## 3. Semantic-alignment note and acceptance criteria

- The banners assert nothing beyond what the kernel-checked declarations already
  prove; they are a provenance/convention record, not new claims. Each bullet is
  cross-checkable against a named declaration or against `docs/CONVENTIONS.md`.
- Direction of corrections is bidirectional: two twistor rows were **downgraded**
  (absent), and four covariance/obstruction rows were **upgraded** (trusted) to
  match the actual trusted-surface modules added in Wave 8.
- The one residual gap on the trusted covariance surface is the explicit
  `SL(2,C) -> SO^+(1,3)` covering map; the banner and Section 7 both state this
  so no Lorentz-representation overclaim is made.

Acceptance criteria:

1. Both trusted Spinor files carry a convention banner stating metric,
   spinor, determinant/mass normalization, SL(2,C) action, and relation to
   older/draft files. (Done.)
2. No P1 crosswalk row marks an absent module `trusted`. (Done: twistor rows ->
   absent.)
3. No P1 crosswalk row understates a now-trusted result as draft. (Done: SL(2,C)
   rows -> trusted.)
4. No theorem statement changed. (Done.)

Next Lean target (out of scope here): vendor/prove
`PhysicsSM.Spinor.TwistorPluckerMass` (backlog B10) to restore the twistor rows
to trusted, or keep them as future work.
