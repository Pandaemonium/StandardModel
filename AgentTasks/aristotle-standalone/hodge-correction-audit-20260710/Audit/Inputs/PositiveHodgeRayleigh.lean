import Mathlib

/-!
# Variational mass of a cohomology class: least positive Hodge cost

Finite core of the proposed master mass definition: the physical mass of a
constraint-cohomology class is the LEAST spectral cost over its positive
representatives.  The point of this package is that the definition is
well-posed exactly under the structures the program has already isolated:

* the Kugo-Ojima radical property (exact directions are Krein-orthogonal to
  every closed vector — in particular Krein-null), which makes the Krein
  normalization CONSTANT across a class; and
* ghost-positivity of the spectral cost on exact directions, which makes the
  harmonic representative the minimizer.

Without ghost-positivity the "infimum" can drop below the harmonic value —
the package includes that counterexample, so the hypothesis is provably
necessary, not decorative.

## Setting

`V` a real module, `B` the Krein form, `Q` the constraint differential
(`Q ∘ Q = 0` where needed), `S` the spectral cost operator (`D^#D` in the
program), `h` a harmonic representative of the class with `S h = μ2 • h` and
`B h h = 1`.  Representatives of the class are `h + Q χ`.

## Targets

1. `norm_const_on_class` — under the radical property, every representative
   has the same Krein norm as `h`: normalization is class-intrinsic.
2. `cost_eq_harmonic_add_exact` — the cost of `h + Q χ` splits exactly as
   `μ2 + B (Q χ) (S (Q χ))` when `S` commutes with `Q` and `S h = μ2 • h`
   (both cross terms die by the radical property).
3. `variational_mass_isLeast` — with ghost-positivity
   (`0 ≤ B (Q χ) (S (Q χ))` for all `χ`), the cost set over the class has
   least element `μ2`, attained at the harmonic representative: mass is the
   least positive Hodge cost, and the min is attained.
4. `ghost_positivity_necessary` — an explicit finite counterexample: radical
   property and commutation hold, but one exact direction has negative cost,
   and some representative's cost is strictly below `μ2`.
5. `witness` — an explicit rational instance of targets 1-3 with a
   nontrivial exact direction and `μ2 = 4/25`.

Do not weaken the statements.  Helper lemmas welcome.  Run the narrow check
`lake env lean PositiveHodgeRayleigh/VariationalMass.lean` first; avoid a
full lake build until the holes are closed.
Recovered from Aristotle project `be5c5929-b9ca-4763-a103-4e9c79cab5db`; proof bodies verified locally
under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.PositiveHodgeRayleigh

variable {V : Type*} [AddCommGroup V] [Module ℝ V]

/-- The Kugo-Ojima radical property: exact vectors are Krein-orthogonal to
every closed vector. -/
def RadicalProperty (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q : V →ₗ[ℝ] V) : Prop :=
  ∀ y χ : V, Q y = 0 → B y (Q χ) = 0 ∧ B (Q χ) y = 0

/-- Target 1: the Krein norm is constant across the class of a closed
representative. -/
theorem norm_const_on_class (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q : V →ₗ[ℝ] V)
    (hrad : RadicalProperty B Q) (h : V) (hclosed : Q h = 0)
    (hQQ : Q ∘ₗ Q = 0) (χ : V) :
    B (h + Q χ) (h + Q χ) = B h h := by
  have hQQχ : Q (Q χ) = 0 := by
    have := LinearMap.congr_fun hQQ χ
    simpa using this
  obtain ⟨h1, h2⟩ := hrad h χ hclosed
  obtain ⟨h3, _⟩ := hrad (Q χ) χ hQQχ
  simp only [map_add, LinearMap.add_apply, h1, h2, h3]
  ring

/-- Target 2: exact cost split.  With `S` commuting with `Q`, an eigen-
harmonic representative `S h = μ2 • h`, and the radical property, the cost
of any representative splits into the harmonic cost plus the exact cost. -/
theorem cost_eq_harmonic_add_exact (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (Q S : V →ₗ[ℝ] V) (hrad : RadicalProperty B Q)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S) (h : V) (hclosed : Q h = 0) (μ2 : ℝ)
    (heig : S h = μ2 • h) (hnorm : B h h = 1) (χ : V) :
    B (h + Q χ) (S (h + Q χ)) = μ2 + B (Q χ) (S (Q χ)) := by
  have hSQ : S (Q χ) = Q (S χ) := LinearMap.congr_fun hcomm χ
  obtain ⟨_, hr2⟩ := hrad h χ hclosed
  obtain ⟨hr3, _⟩ := hrad h (S χ) hclosed
  rw [map_add S, heig]
  simp only [map_add, map_smul, LinearMap.add_apply, smul_eq_mul, hnorm]
  rw [hSQ, hr3, hr2]
  ring

/-- Target 3: the variational mass theorem.  With ghost-positivity of the
cost on exact directions, `μ2` is the least cost over the class, attained at
the harmonic representative. -/
theorem variational_mass_isLeast (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (Q S : V →ₗ[ℝ] V) (hrad : RadicalProperty B Q)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S) (h : V) (hclosed : Q h = 0) (μ2 : ℝ)
    (heig : S h = μ2 • h) (hnorm : B h h = 1)
    (hghost : ∀ χ : V, 0 ≤ B (Q χ) (S (Q χ))) :
    IsLeast {c : ℝ | ∃ χ : V, c = B (h + Q χ) (S (h + Q χ))} μ2 := by
  constructor
  · refine ⟨0, ?_⟩
    rw [cost_eq_harmonic_add_exact B Q S hrad hcomm h hclosed μ2 heig hnorm 0]
    simp
  · rintro c ⟨χ, rfl⟩
    rw [cost_eq_harmonic_add_exact B Q S hrad hcomm h hclosed μ2 heig hnorm χ]
    linarith [hghost χ]

/-! ### Concrete instances for targets 4 and 5

Both use `V = Fin 3 → ℝ` with a block-diagonal Krein form, `Q` the rank-one
projection onto the first coordinate (so `range Q` is one-dimensional and is
NOT contained in `ker Q`, which is what allows a nonzero exact cost), and a
diagonal cost operator that commutes with `Q`.  The harmonic representative
is `e₁ = ![0,1,0]`. -/

open Matrix in
/-- Counterexample cost operator: `diag(-1, 0, 0)`; the first-coordinate
entry `-1` gives the exact direction a strictly negative cost. -/
noncomputable def cexS : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) :=
  Matrix.toLin' !![(-1 : ℝ), 0, 0; 0, 0, 0; 0, 0, 0]

open Matrix in
/-- Shared block-diagonal Krein form `diag(1, 1, 0)`. -/
noncomputable def cexB : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) →ₗ[ℝ] ℝ :=
  Matrix.toLinearMap₂' ℝ !![(1 : ℝ), 0, 0; 0, 1, 0; 0, 0, 0]

open Matrix in
/-- Shared constraint differential: projection onto the first coordinate. -/
noncomputable def cexQ : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) :=
  Matrix.toLin' !![(1 : ℝ), 0, 0; 0, 0, 0; 0, 0, 0]

open Matrix in
/-- Witness cost operator: `diag(4/25, 4/25, 0)`, eigenvalue `4/25` on the
harmonic vector and a nonnegative exact cost. -/
noncomputable def witS : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) :=
  Matrix.toLin' !![(4 / 25 : ℝ), 0, 0; 0, 4 / 25, 0; 0, 0, 0]

/-- Target 4: ghost-positivity is necessary.  There is an explicit finite
instance satisfying the radical property, commutation, eigen-harmonicity,
and normalization, in which some representative's cost is strictly below
the harmonic value. -/
theorem ghost_positivity_necessary :
    ∃ (B : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) →ₗ[ℝ] ℝ)
      (Q S : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ)) (h : Fin 3 → ℝ) (μ2 : ℝ),
        RadicalProperty B Q ∧ S ∘ₗ Q = Q ∘ₗ S ∧ Q h = 0 ∧
          S h = μ2 • h ∧ B h h = 1 ∧
            ∃ χ : Fin 3 → ℝ,
              B (h + Q χ) (S (h + Q χ)) < μ2 := by
  refine ⟨cexB, cexQ, cexS, ![0, 1, 0], 0, ?_, ?_, ?_, ?_, ?_, ⟨![1, 0, 0], ?_⟩⟩
  · intro y χ hy
    have h0 : y 0 = 0 := by
      have := congrFun hy 0
      simpa [cexQ, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
        Fin.sum_univ_three] using this
    constructor <;>
    · simp only [cexB, cexQ, Matrix.toLin'_apply, Matrix.toLinearMap₂'_apply]
      simp [Matrix.mulVec, dotProduct, Fin.sum_univ_three, h0]
  · ext x i
    simp only [LinearMap.comp_apply, cexS, cexQ, Matrix.toLin'_apply]
    fin_cases i <;> simp [Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  · ext i
    fin_cases i <;>
      simp [cexQ, Matrix.toLin'_apply, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  · ext i
    fin_cases i <;>
      simp [cexS, Matrix.toLin'_apply, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  · simp [cexB, Matrix.toLinearMap₂'_apply, Fin.sum_univ_three]
  · simp only [cexB, cexQ, cexS, Matrix.toLin'_apply, Matrix.toLinearMap₂'_apply]
    simp [Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-- Target 5: an explicit rational instance of the variational mass theorem
with a nontrivial exact direction and `μ2 = 4/25`. -/
theorem witness :
    ∃ (B : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) →ₗ[ℝ] ℝ)
      (Q S : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ)) (h : Fin 3 → ℝ),
        RadicalProperty B Q ∧ S ∘ₗ Q = Q ∘ₗ S ∧ Q h = 0 ∧
          S h = (4 / 25 : ℝ) • h ∧ B h h = 1 ∧ Q ≠ 0 ∧
            (∀ χ : Fin 3 → ℝ, 0 ≤ B (Q χ) (S (Q χ))) ∧
              IsLeast
                {c : ℝ | ∃ χ : Fin 3 → ℝ,
                  c = B (h + Q χ) (S (h + Q χ))} (4 / 25) := by
  refine ⟨cexB, cexQ, witS, ![0, 1, 0], ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro y χ hy
    have h0 : y 0 = 0 := by
      have := congrFun hy 0
      simpa [cexQ, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
        Fin.sum_univ_three] using this
    constructor <;>
    · simp only [cexB, cexQ, Matrix.toLin'_apply, Matrix.toLinearMap₂'_apply]
      simp [Matrix.mulVec, dotProduct, Fin.sum_univ_three, h0]
  · ext x i
    simp only [LinearMap.comp_apply, witS, cexQ, Matrix.toLin'_apply]
    fin_cases i <;> simp [Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  · ext i
    fin_cases i <;>
      simp [cexQ, Matrix.toLin'_apply, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  · ext i
    fin_cases i <;>
      simp [witS, Matrix.toLin'_apply, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  · simp [cexB, Matrix.toLinearMap₂'_apply, Fin.sum_univ_three]
  · intro hcon
    have h1 := DFunLike.congr_fun hcon ![1, 0, 0]
    have h2 := congrFun h1 0
    simp [cexQ, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
      Fin.sum_univ_three] at h2
  · intro χ
    simp only [cexB, cexQ, witS, Matrix.toLin'_apply, Matrix.toLinearMap₂'_apply]
    simp [Matrix.mulVec, dotProduct, Fin.sum_univ_three]
    nlinarith [sq_nonneg (χ 0)]
  · constructor
    · refine ⟨0, ?_⟩
      simp [cexB, witS, cexQ, Matrix.toLinearMap₂'_apply, Matrix.toLin'_apply,
        Fin.sum_univ_three]
    · rintro c ⟨χ, rfl⟩
      simp only [cexB, cexQ, witS, Matrix.toLin'_apply, Matrix.toLinearMap₂'_apply]
      simp [Matrix.mulVec, dotProduct, Fin.sum_univ_three]
      nlinarith [sq_nonneg (χ 0)]

end PhysicsSM.Draft.NullEdge.PositiveHodgeRayleigh

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveHodgeRayleigh.variational_mass_isLeast' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PositiveHodgeRayleigh.variational_mass_isLeast

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveHodgeRayleigh.ghost_positivity_necessary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PositiveHodgeRayleigh.ghost_positivity_necessary
