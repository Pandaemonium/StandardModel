import Mathlib

/-!
# D4 added-step causal classification

This draft module records the exact causal obstruction to replacing the active
tetrahedral null translation lattice by the full `D4` root lattice.

The active Hadamard generators are

```text
h0 = (1,  1,  1,  1)    h1 = (1,  1, -1, -1)
h2 = (1, -1,  1, -1)    h3 = (1, -1, -1,  1).
```

For the physical Lorentz form

```text
q(x) = -x0^2 + (x1^2 + x2^2 + x3^2) / 3,
```

the four generators are null.  The additional `D4` root-neighbor steps
represented by half-sums and half-differences of distinct generators are not:
half-sums are timelike and half-differences are spacelike.

This is a finite guardrail theorem, not a continuum, Lorentz-invariance, or
Gate C1 release claim.  It was recovered from Aristotle project
`df5b5326-e065-4109-916b-d472c86f614d` and verified under the pinned toolchain.
-/

namespace PhysicsSM.Draft.NullEdge.GateC1.D4AddedStepCausalClassification

/-- The four Hadamard body diagonals generating the active lattice `L_H`.
Coordinate zero is time; coordinates one through three are spatial. -/
def h : Fin 4 → (Fin 4 → ℚ) :=
  ![![1, 1, 1, 1],
    ![1, 1, -1, -1],
    ![1, -1, 1, -1],
    ![1, -1, -1, 1]]

/-- The physical Lorentz quadratic form in the integer-rescaled coordinates. -/
def q (x : Fin 4 → ℚ) : ℚ :=
  -(x 0) ^ 2 + (1 / 3) * ((x 1) ^ 2 + (x 2) ^ 2 + (x 3) ^ 2)

/-- Every active Hadamard step is null. -/
theorem q_h_null : ∀ A : Fin 4, q (h A) = 0 := by
  intro A
  fin_cases A <;> simp [q, h] <;> norm_num

/-- Half-sums of distinct Hadamard steps are timelike. -/
theorem q_halfSum :
    ∀ A B : Fin 4, A ≠ B →
      q (fun i => (h A i + h B i) / 2) = -2 / 3 := by
  intro A B hAB
  fin_cases A <;> fin_cases B <;>
    first
      | exact absurd rfl hAB
      | simp [q, h] <;> norm_num

/-- Half-differences of distinct Hadamard steps are spacelike. -/
theorem q_halfDiff :
    ∀ A B : Fin 4, A ≠ B →
      q (fun i => (h A i - h B i) / 2) = 2 / 3 := by
  intro A B hAB
  fin_cases A <;> fin_cases B <;>
    first
      | exact absurd rfl hAB
      | simp [q, h] <;> norm_num

/-- Compact causal verdict for the `D4` envelope. -/
theorem d4_added_step_causal_verdict :
    (∀ A : Fin 4, q (h A) = 0) ∧
    (∀ A B : Fin 4, A ≠ B →
      q (fun i => (h A i + h B i) / 2) < 0) ∧
    (∀ A B : Fin 4, A ≠ B →
      0 < q (fun i => (h A i - h B i) / 2)) := by
  refine ⟨q_h_null, ?_, ?_⟩
  · intro A B hAB
    rw [q_halfSum A B hAB]
    norm_num
  · intro A B hAB
    rw [q_halfDiff A B hAB]
    norm_num

/-- info: 'PhysicsSM.Draft.NullEdge.GateC1.D4AddedStepCausalClassification.q_h_null' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateC1.D4AddedStepCausalClassification.q_h_null

/-- info: 'PhysicsSM.Draft.NullEdge.GateC1.D4AddedStepCausalClassification.d4_added_step_causal_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateC1.D4AddedStepCausalClassification.d4_added_step_causal_verdict

end PhysicsSM.Draft.NullEdge.GateC1.D4AddedStepCausalClassification
