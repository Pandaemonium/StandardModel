import Mathlib
import PhysicsSM.Draft.NullEdge.KMPhaseCounting
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.IncidenceCorank
import PhysicsSM.Draft.NullEdge.FamilyRankNoGo

/-!
# Goal II CP phase count and family-rank no-go bridge

This module connects the Goal II finite Kobayashi-Maskawa CP phase count
(`FiniteKM.physicalPhases`, `KMPhaseCounting`, `IncidenceCorank`) to the
already-landed family-rank no-go (`FamilyRankNoGo`).

## Claim discipline

Nothing here says CP dynamics derives three generations physically. All
statements are about the finite arithmetic / corank model only:

* `physicalPhases N = (N - 1) * (N - 2) / 2` counts physical Dirac CP phases;
* `FamilyRankNoGo.completionCount n = n + 1` counts positive-sector completions.

The bridge theorems below show that, inside this arithmetic model, the
predicate "exactly one physical CP phase" is logically equivalent to the
rank-fixing datum that `FamilyRankNoGo` demanded: `n = 2` (strand rank two),
equivalently three completions, equivalently three generations `N = 3`. In
`FamilyRankNoGo` language (`forcing_iff_rankfixing`), "one physical CP phase"
is therefore exactly the kind of explicit rank-fixing input `n = 2`; it does not
manufacture the number three from nothing, it is that datum.

## Results

* `physicalPhases_eq_one_iff` : `physicalPhases N = 1 ↔ N = 3` (no hypothesis
  needed: the count is `0` for `N <= 2` and `>= 3` for `N >= 4`, so `1` pins
  `N = 3`).
* `cp_one_iff_three_completions` : with the generation/rank indexing
  `N = n + 1`, `physicalPhases (n + 1) = 1 ↔
  FamilyRankNoGo.completionCount n = 3`.
* `cp_one_supplies_rankfixing` : `∀ n, physicalPhases (n + 1) = 1 ↔ n = 2`,
  i.e. "one physical CP phase" is precisely the rank-fixing datum `n = 2`.
* `cp_one_is_rankfixing_datum` : packaged via
  `FamilyRankNoGo.forcing_iff_rankfixing`, the CP-phase predicate
  `fun n => physicalPhases (n + 1) = 1` forces `n = 2` and is realizable there:
  it is logically equivalent to `n = 2`.
-/

namespace KMFamilyRankBridge

open FiniteKM

/-- **Exactly one physical Dirac CP phase selects three generations.**
The physical CP-phase count `(N - 1) * (N - 2) / 2` equals `1` iff `N = 3`.
No hypothesis is needed: the count is `0` for `N <= 2` and at least `3` for
`N >= 4`, so the value `1` is attained only at `N = 3`. -/
theorem physicalPhases_eq_one_iff (N : Nat) :
    FiniteKM.physicalPhases N = 1 ↔ N = 3 := by
  unfold FiniteKM.physicalPhases
  rcases N with _ | _ | _ | _ | n
  · decide
  · decide
  · decide
  · decide
  · have e1 : n + 1 + 1 + 1 + 1 - 1 = n + 3 := by omega
    have e2 : n + 1 + 1 + 1 + 1 - 2 = n + 2 := by omega
    rw [e1, e2]
    have hge : 3 ≤ (n + 3) * (n + 2) / 2 := by
      have : 6 ≤ (n + 3) * (n + 2) := by nlinarith
      omega
    omega

/-- **CP-phase count and completion count**, under the generation/rank indexing
`N = n + 1` (strand rank `n` corresponds to `N = n + 1` generations). Exactly
one physical CP phase occurs iff there are exactly three positive-sector
completions. -/
theorem cp_one_iff_three_completions (n : Nat) :
    FiniteKM.physicalPhases (n + 1) = 1 ↔
      FamilyRankNoGo.completionCount n = 3 := by
  rw [physicalPhases_eq_one_iff, FamilyRankNoGo.completionCount_eq]

/-- **One physical CP phase is exactly the rank-fixing datum `n = 2`.**
Inside the finite arithmetic model, the predicate "one physical CP phase"
(at `N = n + 1` generations) is equivalent to strand rank `n = 2`, the explicit
rank-fixing input `FamilyRankNoGo` demanded. -/
theorem cp_one_supplies_rankfixing :
    (∀ n, FiniteKM.physicalPhases (n + 1) = 1 ↔ n = 2) := by
  intro n
  rw [physicalPhases_eq_one_iff]; omega

/-- **Packaged bridge.** Via `FamilyRankNoGo.forcing_iff_rankfixing`, the
CP-phase predicate `fun n => physicalPhases (n + 1) = 1` both forces `n = 2`
and is realizable there; equivalently it is logically equivalent to the
rank-fixing datum `n = 2`. This is precisely the explicit input the family-rank
no-go said was otherwise missing. -/
theorem cp_one_is_rankfixing_datum :
    (FamilyRankNoGo.Forces (fun n => FiniteKM.physicalPhases (n + 1) = 1) ∧
        FiniteKM.physicalPhases (2 + 1) = 1) ∧
      (∀ n, FiniteKM.physicalPhases (n + 1) = 1 ↔ n = 2) := by
  refine ⟨⟨fun n hn => (cp_one_supplies_rankfixing n).1 hn, by decide⟩,
    cp_one_supplies_rankfixing⟩

end KMFamilyRankBridge

/-! ## Kernel-footprint guard pins -/

/-- info: 'KMFamilyRankBridge.physicalPhases_eq_one_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMFamilyRankBridge.physicalPhases_eq_one_iff

/-- info: 'KMFamilyRankBridge.cp_one_iff_three_completions' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMFamilyRankBridge.cp_one_iff_three_completions

/-- info: 'KMFamilyRankBridge.cp_one_supplies_rankfixing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMFamilyRankBridge.cp_one_supplies_rankfixing

/-- info: 'KMFamilyRankBridge.cp_one_is_rankfixing_datum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMFamilyRankBridge.cp_one_is_rankfixing_datum
