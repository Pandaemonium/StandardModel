import Mathlib
import PhysicsSM.Draft.NullEdge.KMPhaseCounting
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.IncidenceCorank

/-!
# Goal II flagship composition: finite Kobayashi-Maskawa CP phase count

This module is the Goal II flagship composition step. It ties together the three
landed finite Kobayashi-Maskawa modules:

* `PhysicsSM.Draft.NullEdge.KMPhaseCounting` - the arithmetic parameter split
  and the sharp threshold `0 < ckmPhysCP N ↔ 3 ≤ N`.
* `PhysicsSM.Draft.NullEdge.FiniteKMCP` - the concrete rephasing-invariant
  plaquette/Jarlskog package, the `N = 2` no-go (invariant and constructive),
  and the exact nonzero `N = 3` Jarlskog witness.
* `PhysicsSM.Draft.NullEdge.IncidenceCorank` - the general-`N`
  incidence/coboundary corank theorem identifying the physical phase count with
  the graph corank `(N - 1) * (N - 2) / 2`.

## Honest scope

This module closes the linearized incidence/corank phase-count theorem: the
arithmetic CP-phase count `FiniteKM.physicalPhases N` is identified, for every
field `K` and `1 ≤ N`, with the corank of the signed incidence (coboundary) map
of the complete graph `K_N`. It also composes the low-`N` no-go/witness data:
`N = 2` has no physical phase and every unitary `2 x 2` matrix is rephasable to
a real matrix; `N = 3` has exactly one physical phase realized by a genuinely
unitary Jarlskog witness with `J ≠ 0`.

It does not claim a full global unitary normal form for general `N`; that
remains future work. The composition here is purely the linear phase-count
identity plus the sharp low-`N` fixtures.
-/

open scoped BigOperators
open Module

namespace KMFlagship

/-! ## Identification of the arithmetic count with the incidence corank -/

/-- The arithmetic physical CP-phase count equals the incidence corank of the
complete graph `K_N`, over any field `K`, for `1 ≤ N`. -/
theorem physicalPhases_eq_incidence_corank
    (K : Type*) [Field K] (N : Nat) (hN : 1 ≤ N) :
    FiniteKM.physicalPhases N =
      Module.finrank K (IncidenceCorank.Edge N → K)
        - Module.finrank K (LinearMap.range (IncidenceCorank.coboundary K N)) := by
  rw [IncidenceCorank.coboundary_corank K N hN]
  rfl

/-- The incidence corank of the complete graph `K_N` equals the standard physical
CP-phase count, over any field `K`, for `1 ≤ N`. -/
theorem incidence_corank_eq_physical_count
    (K : Type*) [Field K] (N : Nat) (hN : 1 ≤ N) :
    Module.finrank K (IncidenceCorank.Edge N → K)
        - Module.finrank K (LinearMap.range (IncidenceCorank.coboundary K N))
      = FiniteKM.physicalPhases N :=
  (physicalPhases_eq_incidence_corank K N hN).symm

/-! ## Sharp low-`N` fixtures -/

/-- `N = 2`: no physical CP phase. -/
theorem no_physical_phase_two :
    FiniteKM.physicalPhases 2 = 0 :=
  FiniteKM.physicalPhases_two

/-- `N = 3`: exactly one physical CP phase. -/
theorem exactly_one_physical_phase_three :
    FiniteKM.physicalPhases 3 = 1 :=
  FiniteKM.physicalPhases_three

/-- `N = 2`: the incidence corank vanishes, matching the no-go. -/
theorem incidence_corank_two_zero (K : Type*) [Field K] :
    Module.finrank K (IncidenceCorank.Edge 2 → K)
        - Module.finrank K (LinearMap.range (IncidenceCorank.coboundary K 2)) = 0 :=
  IncidenceCorank.coboundary_corank_two K

/-- `N = 3`: the incidence corank is exactly one. -/
theorem incidence_corank_three_one (K : Type*) [Field K] :
    Module.finrank K (IncidenceCorank.Edge 3 → K)
        - Module.finrank K (LinearMap.range (IncidenceCorank.coboundary K 3)) = 1 :=
  IncidenceCorank.coboundary_corank_three K

/-! ## Goal II low-`N` compositional summary -/

/--
Compositional Goal II summary at low generation number.

* `N = 2` has no physical CP phase, and every unitary `2 x 2` matrix is
  rephasing-equivalent to a matrix with all entries real.
* `N = 3` has exactly one physical CP phase, and the concrete `3-4-5` witness is
  genuinely unitary with nonzero Jarlskog invariant.
-/
theorem goalII_lowN_summary :
    FiniteKM.physicalPhases 2 = 0
      ∧ (∀ V : Matrix (Fin 2) (Fin 2) Complex, V.conjTranspose * V = 1 →
            ∃ dL dR : Fin 2 → Complex,
              FiniteKM.IsPhase dL ∧ FiniteKM.IsPhase dR ∧
                ∀ i j, ((FiniteKM.rephase dL dR V) i j).im = 0)
      ∧ FiniteKM.physicalPhases 3 = 1
      ∧ FiniteKM.Vwitness.conjTranspose * FiniteKM.Vwitness = 1
      ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0 :=
  ⟨FiniteKM.physicalPhases_two,
    fun V hV => FiniteKM.exists_real_rephasing_two V hV,
    FiniteKM.physicalPhases_three,
    FiniteKM.Vwitness_unitary,
    FiniteKM.jarlskog_Vwitness_ne_zero⟩

end KMFlagship

/-! ## Kernel-footprint guard pins -/

/-- info: 'KMFlagship.physicalPhases_eq_incidence_corank' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMFlagship.physicalPhases_eq_incidence_corank

/-- info: 'KMFlagship.incidence_corank_eq_physical_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMFlagship.incidence_corank_eq_physical_count

/-- info: 'KMFlagship.incidence_corank_two_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMFlagship.incidence_corank_two_zero

/-- info: 'KMFlagship.incidence_corank_three_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMFlagship.incidence_corank_three_one

/-- info: 'KMFlagship.goalII_lowN_summary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMFlagship.goalII_lowN_summary
