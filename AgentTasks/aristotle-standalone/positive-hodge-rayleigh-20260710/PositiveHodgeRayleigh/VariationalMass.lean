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
-/

namespace PositiveHodgeRayleigh

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
  sorry

/-- Target 2: exact cost split.  With `S` commuting with `Q`, an eigen-
harmonic representative `S h = μ2 • h`, and the radical property, the cost
of any representative splits into the harmonic cost plus the exact cost. -/
theorem cost_eq_harmonic_add_exact (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (Q S : V →ₗ[ℝ] V) (hrad : RadicalProperty B Q)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S) (h : V) (hclosed : Q h = 0) (μ2 : ℝ)
    (heig : S h = μ2 • h) (hnorm : B h h = 1) (χ : V) :
    B (h + Q χ) (S (h + Q χ)) = μ2 + B (Q χ) (S (Q χ)) := by
  sorry

/-- Target 3: the variational mass theorem.  With ghost-positivity of the
cost on exact directions, `μ2` is the least cost over the class, attained at
the harmonic representative. -/
theorem variational_mass_isLeast (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (Q S : V →ₗ[ℝ] V) (hrad : RadicalProperty B Q)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S) (h : V) (hclosed : Q h = 0) (μ2 : ℝ)
    (heig : S h = μ2 • h) (hnorm : B h h = 1)
    (hghost : ∀ χ : V, 0 ≤ B (Q χ) (S (Q χ))) :
    IsLeast {c : ℝ | ∃ χ : V, c = B (h + Q χ) (S (h + Q χ))} μ2 := by
  sorry

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
  sorry

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
  sorry

end PositiveHodgeRayleigh
