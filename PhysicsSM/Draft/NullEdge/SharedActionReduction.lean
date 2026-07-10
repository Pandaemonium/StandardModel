import Mathlib

/-!
# The shared-action bridge: spinor walk components obey the scalar
# variational recurrence

Bridge (ii) of the manuscript's open-bridge list: a shared field-valued
action whose reductions yield BOTH the scalar variational recurrence and the
spinor walk.  The finite core is a Cayley-Hamilton reduction: for ANY
unimodular one-step matrix `M` (`det M = 1`), every scalar component of a
two-component orbit `psi_{n+1} = M psi_n` satisfies the SAME second-order
scalar recurrence

  `x_{n+2} = (tr M) x_{n+1} - x_n`,

which for `tr M = 2 - mu` is exactly the landed kinetic-minus-Pluecker
Euler-Lagrange recurrence.  So the scalar variational flow and the spinor
walk are two reductions of one discrete dynamics: the first-order
two-component form IS the walk; its component elimination IS the variational
recurrence — the discrete shadow of "Dirac squares to Klein-Gordon".

## Targets

1. `cayley_hamilton_two` — for a 2x2 matrix over a commutative ring,
   `M^2 = (tr M) • M - (det M) • 1` (instantiate Mathlib's Cayley-Hamilton
   or prove directly by entries).
2. `component_recurrence` — for `det M = 1` and any orbit
   `psi (n+1) = M.mulVec (psi n)`, every component satisfies
   `psi (n+2) i = (tr M) * psi (n+1) i - psi n i`.
3. `variational_form` — with `tr M = 2 - mu` the recurrence is exactly
   `x_{n+2} = (2 - mu) x_{n+1} - x_n`, the kinetic-minus-Pluecker
   Euler-Lagrange shape (statement-level identification, both sides
   displayed).
4. `first_integral_transfer` — the scalar conserved quadratic
   `Q(x, y) = x^2 - (2 - mu) * x * y + y^2` is invariant along every
   component pair: `Q(psi (n+2) i, psi (n+1) i) = Q(psi (n+1) i, psi n i)`
   (given targets 2-3).
5. `witness_mu` — the explicit rotation-type unimodular step
   `M = !![2 - mu, -1; 1, 0]` (companion form) with `mu = 4/25`: trace
   `46/25`, determinant `1`, and the orbit from `psi 0 = ![1, 0]` reproduces
   the landed scalar trajectory values `x_1 = 46/25` in its first component
   (the `(0,1) -> (1, 46/25)` step of the landed flow, read through the
   companion convention).
6. `nonunimodular_control` — for `det M = d /= 1` the clean recurrence
   fails: the correct identity is
   `psi (n+2) i = (tr M) * psi (n+1) i - d * psi n i`, and an explicit
   `d = 2` fixture violates the `d = 1` recurrence.  Unimodularity is
   load-bearing: the shared action exists exactly for measure-preserving
   steps.

Honest scope: this proves the two landed dynamics are reductions of one
first-order system and share the conserved quadratic; the FIELD-VALUED
action functional itself (a Lagrangian whose stationarity gives the
two-component step directly) is the remaining half of bridge (ii), named,
not claimed.  Do not weaken the statements.  Helper lemmas welcome.  Run
`lake env lean SharedActionReduction/CayleyHamiltonBridge.lean` first.
Recovered from Aristotle project `82624587-24e3-4b68-b052-5eb1dc6b0536`; statements audited unchanged
and proof bodies verified locally under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.SharedActionReduction

open Matrix

/-
Target 1: Cayley-Hamilton for 2x2 matrices over a commutative ring.
-/
theorem cayley_hamilton_two (M : Matrix (Fin 2) (Fin 2) ℚ) :
    M * M = M.trace • M - M.det • (1 : Matrix (Fin 2) (Fin 2) ℚ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.trace_fin_two, Matrix.det_fin_two,
      Fin.sum_univ_two] <;> ring

/-
Target 2: unimodular orbits satisfy the scalar trace recurrence in every
component.
-/
theorem component_recurrence (M : Matrix (Fin 2) (Fin 2) ℚ)
    (hdet : M.det = 1) (psi : ℕ → Fin 2 → ℚ)
    (horbit : ∀ n, psi (n + 1) = M.mulVec (psi n)) (n : ℕ) (i : Fin 2) :
    psi (n + 2) i = M.trace * psi (n + 1) i - psi n i := by
  rw [Matrix.det_fin_two] at hdet
  rw [show n + 2 = (n + 1) + 1 from rfl, horbit (n + 1), horbit n]
  fin_cases i <;>
    simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two, Matrix.trace_fin_two]
  · linear_combination (-psi n 0) * hdet
  · linear_combination (-psi n 1) * hdet

/-
Target 3: with `tr M = 2 - mu` this is exactly the kinetic-minus-Pluecker
Euler-Lagrange recurrence.
-/
theorem variational_form (M : Matrix (Fin 2) (Fin 2) ℚ) (mu : ℚ)
    (hdet : M.det = 1) (htr : M.trace = 2 - mu) (psi : ℕ → Fin 2 → ℚ)
    (horbit : ∀ n, psi (n + 1) = M.mulVec (psi n)) (n : ℕ) (i : Fin 2) :
    psi (n + 2) i = (2 - mu) * psi (n + 1) i - psi n i := by
  rw [ ← htr, component_recurrence M hdet psi horbit n i ]

/-- The conserved quadratic of the scalar flow. -/
def Qform (mu x y : ℚ) : ℚ := x ^ 2 - (2 - mu) * x * y + y ^ 2

/-
Target 4: the scalar first integral transfers to every spinor
component.
-/
theorem first_integral_transfer (M : Matrix (Fin 2) (Fin 2) ℚ) (mu : ℚ)
    (hdet : M.det = 1) (htr : M.trace = 2 - mu) (psi : ℕ → Fin 2 → ℚ)
    (horbit : ∀ n, psi (n + 1) = M.mulVec (psi n)) (n : ℕ) (i : Fin 2) :
    Qform mu (psi (n + 2) i) (psi (n + 1) i) =
      Qform mu (psi (n + 1) i) (psi n i) := by
  have h := variational_form M mu hdet htr psi horbit n i;
  unfold Qform; rw [ h ] ; ring;

/-
Target 5: the companion witness at `mu = 4/25`.
-/
theorem witness_mu :
    (!![2 - 4 / 25, -1; 1, 0] : Matrix (Fin 2) (Fin 2) ℚ).det = 1 ∧
    (!![2 - 4 / 25, -1; 1, 0] : Matrix (Fin 2) (Fin 2) ℚ).trace = 46 / 25 ∧
    (!![2 - 4 / 25, -1; 1, 0] : Matrix (Fin 2) (Fin 2) ℚ).mulVec ![1, 0]
      = ![46 / 25, 1] := by
  refine ⟨?_, ?_, ?_⟩
  · simp [Matrix.det_fin_two]
  · simp [Matrix.trace_fin_two]; norm_num
  · funext i
    fin_cases i <;> norm_num [Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-
Target 6 (negative control): non-unimodular steps break the clean
recurrence — the determinant reappears as the coefficient of the delayed
term, and an explicit `det = 2` fixture violates the unimodular
recurrence.
-/
theorem nonunimodular_control :
    (∀ (M : Matrix (Fin 2) (Fin 2) ℚ) (psi : ℕ → Fin 2 → ℚ),
      (∀ n, psi (n + 1) = M.mulVec (psi n)) → ∀ n i,
        psi (n + 2) i = M.trace * psi (n + 1) i - M.det * psi n i) ∧
    (∃ (M : Matrix (Fin 2) (Fin 2) ℚ) (psi : ℕ → Fin 2 → ℚ) (n : ℕ) (i : Fin 2),
      (∀ m, psi (m + 1) = M.mulVec (psi m)) ∧ M.det = 2 ∧
        psi (n + 2) i ≠ M.trace * psi (n + 1) i - psi n i) := by
  refine ⟨?_, ?_⟩
  · intro M psi horbit n i
    rw [show n + 2 = (n + 1) + 1 from rfl, horbit (n + 1), horbit n]
    fin_cases i <;>
      simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two, Matrix.trace_fin_two,
        Matrix.det_fin_two] <;> ring
  · refine ⟨!![2, 0; 0, 1], fun m => ![2 ^ m, 1], 0, 0, ?_, ?_, ?_⟩
    · intro m
      funext j
      fin_cases j <;>
        simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two, pow_succ, mul_comm]
    · simp [Matrix.det_fin_two]
    · simp [Matrix.trace_fin_two]; norm_num

end PhysicsSM.Draft.NullEdge.SharedActionReduction

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SharedActionReduction.component_recurrence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SharedActionReduction.component_recurrence

/-- info: 'PhysicsSM.Draft.NullEdge.SharedActionReduction.first_integral_transfer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SharedActionReduction.first_integral_transfer

/-- info: 'PhysicsSM.Draft.NullEdge.SharedActionReduction.nonunimodular_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SharedActionReduction.nonunimodular_control
