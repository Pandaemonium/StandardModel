import Mathlib

/-!
# Collision entropy <= Shannon entropy (finite Renyi hierarchy)

Draft module. Links the Shannon-entropy line (`VonNeumannEntropyBound`,
`ClassicalStrongSubadditivity`) to the purity/collision line (`PurityBounds`).
For a finite probability vector `p`, the collision (Renyi-2) entropy
`H_2(p) = -log (sum_i p_i^2)` is at most the Shannon entropy
`H(p) = sum_i negMulLog (p_i)`. Since `sum_i p_i^2` is the classical purity, this
is exactly `H(p) >= -log(purity)`, the order-monotonicity `H_1 >= H_2` of Renyi
entropies -- the classical shadow of the operator bound in `VNEntropyPurity`.
CFC-free, pure `Real`/`Finset`.

## Trust status

Draft-trust by kernel: `collision_le_shannon` is `sorry`-free and depends only on
`[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12). Proof search by Aristotle
(project `7ea3de59-bb75-4d6a-b545-1176b2b5e7db`), then independently re-checked in
this repo (`lake env lean`; axiom footprint confirmed kernel-only). Route: Jensen
for the convex `-log` restricted to the support, with weights `p_i` and points
`p_i` (`sum_i p_i * p_i = purity`, `sum_i p_i * (-log p_i) = H`). Clean-room
formalization from the mathematical statement.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CollisionShannon

open scoped BigOperators

variable {n : Type*} [Fintype n]

/-- Shannon entropy `∑ i, negMulLog (p i)` (`negMulLog x = -x log x`). -/
def shannonEntropy (p : n → ℝ) : ℝ :=
  ∑ i, Real.negMulLog (p i)

/-- Collision (Renyi-2) entropy `-log (∑ i, (p i)^2)`; the argument
`∑ i, (p i)^2` is the classical purity. -/
def collisionEntropy (p : n → ℝ) : ℝ :=
  - Real.log (∑ i, (p i) ^ 2)

/-- **TARGET (the hole): collision entropy <= Shannon entropy.**  For a finite
probability vector, the Renyi-2 (collision) entropy is at most the Shannon
entropy. -/
theorem collision_le_shannon [Nonempty n] (p : n → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hps : ∑ i, p i = 1) :
    collisionEntropy p ≤ shannonEntropy p := by
  set S : Finset n := Finset.univ.filter (fun i => p i ≠ 0) with hS
  have hconv : ConvexOn ℝ (Set.Ioi 0) (-Real.log) :=
    strictConcaveOn_log_Ioi.concaveOn.neg
  have hwnn : ∀ i ∈ S, 0 ≤ p i := fun i _ => hp i
  have hsumw : ∑ i ∈ S, p i = 1 := by
    rw [hS, Finset.sum_filter_ne_zero, hps]
  have hmem : ∀ i ∈ S, p i ∈ Set.Ioi 0 := by
    intro i hi
    simp only [hS, Finset.mem_filter] at hi
    exact lt_of_le_of_ne (hp i) (Ne.symm hi.2)
  have jensen := hconv.map_sum_le hwnn hsumw hmem
  simp only [smul_eq_mul, Pi.neg_apply] at jensen
  have hlhs : ∑ i ∈ S, p i * p i = ∑ i, (p i) ^ 2 := by
    rw [Finset.sum_subset (Finset.filter_subset _ _)]
    · exact Finset.sum_congr rfl (fun i _ => (sq (p i)).symm)
    · intro i _ hi
      simp only [Finset.mem_filter, not_and, not_not] at hi
      rw [hi (Finset.mem_univ i), mul_zero]
  have hrhs : ∑ i ∈ S, p i * -Real.log (p i) = ∑ i, Real.negMulLog (p i) := by
    rw [Finset.sum_subset (Finset.filter_subset _ _)]
    · exact Finset.sum_congr rfl (fun i _ => by rw [Real.negMulLog]; ring)
    · intro i _ hi
      simp only [Finset.mem_filter, not_and, not_not] at hi
      rw [hi (Finset.mem_univ i), zero_mul]
  rw [collisionEntropy, shannonEntropy, ← hlhs, ← hrhs]
  exact jensen

end PhysicsSM.Draft.NullEdge.CollisionShannon

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.CollisionShannon.collision_le_shannon' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CollisionShannon.collision_le_shannon
