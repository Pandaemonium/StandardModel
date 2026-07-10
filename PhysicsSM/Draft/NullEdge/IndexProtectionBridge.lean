import Mathlib
import PhysicsSM.Draft.NullEdge.WindingLowModes
import PhysicsSM.Draft.NullEdge.IndexAnomalyInterface

open scoped BigOperators

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# C3 bridge: the winding anomaly protects finite kernel modes

## Scope and honest disclaimer

This file composes two already-landed finite results into a single, deliberately
modest bundle:

* the finite signed-index anomaly `toyIndex (Kw N w) - toyIndex (Kw N 0) = w`
  from `PhysicsSM.Draft.NullEdge.IndexAnomalyInterface`
  (`F4Winding.toy_index_anomaly`), and
* the finite protection fact `finrank (ker (Kw N w)) = w` from
  `PhysicsSM.Draft.NullEdge.WindingLowModes` (`F4Winding.windingDirac_kernel`).

There is no analytic content anywhere here. No Fredholm theory, no
Atiyah-Singer index theorem, no spectral flow, no heat kernel / eta invariant,
and no continuum-anomaly claim. Everything is finite-dimensional rank-nullity
bookkeeping over `ℂ`, and every "index" is `dim ker - dim coker` for a linear
map between finite-dimensional complex vector spaces. Any genuinely analytic
statement would require input isolated behind the
`F4Winding.AnalyticIndexReduction` interface in `IndexAnomalyInterface`, which
is untouched by this file.

The single headline theorem, `winding_anomaly_protects_modes`, states exactly
the conjunction the audit asks for: the relative signed finite index equals the
winding, and the same winding lower-bounds the number of protected kernel modes.
`winding_one_anomaly_and_mode` is the `w = 1` non-vacuity fixture.
-/

namespace F4Winding

open LinearMap Module Complex

/-! ## 1. The relative signed finite index equals the winding -/

/-- The relative signed finite index of the winding-`w` closure operator over the
winding-zero reference equals the winding `w`. This is a thin re-export of
`toy_index_anomaly`; it isolates the proved finite bookkeeping content. -/
theorem bridge_relative_index_eq_winding (N w : ℕ) :
    toyIndex (Kw N w) - toyIndex (Kw N 0) = (w : ℤ) :=
  toy_index_anomaly N w

/-! ## 2. The same winding gives at least `w` protected kernel modes -/

/-- The winding-`w` closure operator carries at least `w` protected kernel modes.
This is the protection direction, obtained from the exact count
`windingDirac_kernel` (which is in fact an equality `= w`). -/
theorem bridge_winding_protects_modes (N w : ℕ) :
    w ≤ Module.finrank ℂ (LinearMap.ker (Kw N w)) := by
  rw [windingDirac_kernel N w]

/-! ## 3. The bundled C3 statement -/

/-- **C3 bridge (headline).** For every lattice size `N` and winding `w`, the
relative signed finite index equals the winding, and the same winding is a lower
bound on the number of protected kernel modes.

This is the finite composition of the anomaly equality
(`bridge_relative_index_eq_winding`) with the protection bound
(`bridge_winding_protects_modes`). It is finite rank-nullity bookkeeping only:
no Fredholm theory, Atiyah-Singer, spectral flow, or continuum anomaly is
claimed. -/
theorem winding_anomaly_protects_modes (N w : Nat) :
    toyIndex (Kw N w)
      - toyIndex (Kw N 0) = (w : Int)
      ∧ w ≤ Module.finrank Complex (LinearMap.ker (Kw N w)) :=
  ⟨bridge_relative_index_eq_winding N w, bridge_winding_protects_modes N w⟩

/-! ## 4. Non-vacuity fixture at `w = 1` -/

/-- **Non-vacuity fixture.** At winding `w = 1` the relative signed index is `1`
and there is at least one protected kernel mode, so the bundle
`winding_anomaly_protects_modes` is genuinely non-vacuous. -/
theorem winding_one_anomaly_and_mode (N : Nat) :
    toyIndex (Kw N 1)
      - toyIndex (Kw N 0) = 1
      ∧ 1 ≤ Module.finrank Complex (LinearMap.ker (Kw N 1)) := by
  simpa using winding_anomaly_protects_modes N 1

end F4Winding

/-! ## Kernel-footprint guard pins -/

/-- info: 'F4Winding.winding_anomaly_protects_modes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms F4Winding.winding_anomaly_protects_modes

/-- info: 'F4Winding.winding_one_anomaly_and_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms F4Winding.winding_one_anomaly_and_mode
