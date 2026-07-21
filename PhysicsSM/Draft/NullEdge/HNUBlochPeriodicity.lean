import Mathlib

/-!
# Bloch periodicity and the fractional-translation obstruction

This module isolates a precise obstruction to contracting an integer lattice
translation by linearly shrinking its displacement.  The interpolation is
continuous on the covering momentum line, but its intermediate characters do
not descend to the Brillouin circle unless the displacement is integral.

The result applies directly to scalar and rank-one conditioned Bloch shifts.
It does not rule out every local-unitary homotopy, classify a full HNU
micromotion loop, or identify a Floquet bulk invariant.  Those require a
specified protocol and, for periodized-loop invariants, a quasienergy gap and
effective-Hamiltonian branch.

Convention: `character s k = exp (-i s k)` and the reciprocal period is
`2 * pi`.

Provenance: the target statements were prepared in the AFPL 3+1 lane and the
proofs were returned by Aristotle project
`4fb1a1d7-b4dc-40fd-966f-d7465e492f81` (task
`c567e4f7-3db4-40d3-8472-11405782dcac`), then replayed locally under Lean 4.28,
July 20, 2026.
-/

open Complex

namespace PhysicsSM.Draft.NullEdge.HNUBlochPeriodicity

noncomputable section

/-- Bloch character of a displacement `s` on the covering momentum line. -/
def character (s k : Real) : Complex :=
  Complex.exp (-(Complex.I * (s * k)))

/-- The character descends to the Brillouin circle exactly when it is
`2 * pi` periodic. -/
def DescendsToCircle (s : Real) : Prop :=
  Function.Periodic (character s) (2 * Real.pi)

/-- Exact reciprocal-period shift law before imposing periodicity. -/
theorem character_add_two_pi (s k : Real) :
    character s (k + 2 * Real.pi) =
      character s k * character s (2 * Real.pi) := by
  unfold character
  rw [← Complex.exp_add]
  ring
  push_cast
  ring

/-- Integer displacements define honest characters of the Brillouin circle. -/
theorem integer_character_descends (n : Int) :
    DescendsToCircle (n : Real) := by
  intro k
  exact Complex.exp_eq_exp_iff_exists_int.mpr
    ⟨-n, by push_cast; ring⟩

/-- **Classification theorem.** A real displacement character is `2 * pi`
periodic if and only if its displacement is integral. -/
theorem character_descends_iff_integer (s : Real) :
    DescendsToCircle s ↔ ∃ n : Int, s = n := by
  constructor
  · intro h
    specialize h 0
    norm_num [character] at h
    rw [Complex.exp_eq_one_iff] at h
    obtain ⟨n, hn⟩ := h
    use -n
    norm_num [Complex.ext_iff] at *
    nlinarith [Real.pi_pos]
  · rintro ⟨n, rfl⟩
    exact integer_character_descends n

/-- The half-translation character changes sign under one reciprocal period. -/
theorem half_character_antiperiodic (k : Real) :
    character (1 / 2) (k + 2 * Real.pi) = -character (1 / 2) k := by
  unfold character
  rw [← Complex.exp_antiperiodic]
  push_cast
  ring
  exact Complex.exp_eq_exp_iff_exists_int.mpr
    ⟨-1, by push_cast; ring⟩

/-- A half translation does not descend to the Brillouin circle. -/
theorem half_character_does_not_descend :
    ¬ DescendsToCircle (1 / 2) := by
  have hInt : ∀ s : Real, DescendsToCircle s → ∃ n : Int, s = n :=
    fun s hs => (character_descends_iff_integer s).1 hs
  exact fun h => by
    obtain ⟨n, hn⟩ := hInt _ h
    rcases n with ⟨_ | _ | n⟩ <;> norm_num at hn <;> linarith

/-- Two half-translation phases compose to one full translation phase. -/
theorem paired_half_characters (k : Real) :
    character (1 / 2) k * character (1 / 2) k = character 1 k := by
  unfold character
  rw [← Complex.exp_add]
  ring
  push_cast
  ring

/-- The paired endpoint is periodic even though either half factor is not. -/
theorem paired_half_endpoint_descends :
    Function.Periodic
      (fun k => character (1 / 2) k * character (1 / 2) k)
      (2 * Real.pi) := by
  norm_num [← sq, character]
  intro x
  rw [← Complex.exp_nat_mul, ← Complex.exp_nat_mul]
  ring
  exact Complex.exp_eq_exp_iff_exists_int.mpr
    ⟨-1, by push_cast; ring⟩

/-- No strictly intermediate *linear displacement* interpolation is periodic.
This is deliberately not a no-go for all local-unitary homotopies. -/
theorem no_fractional_linear_homotopy
    {t : Real} (ht0 : 0 < t) (ht1 : t < 1) :
    ¬ DescendsToCircle t := by
  intro h
  convert (character_descends_iff_integer t).1 h using 1
  exact iff_of_false
    (by aesop)
    (by
      rintro ⟨n, rfl⟩
      rcases n with ⟨_ | _ | n⟩ <;> norm_num at * <;> linarith)

/-! ## Explicit conditioned-shift control -/

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

/-- Nonzero rank-one projector selecting the first internal component. -/
def selected : M2 := !![1, 0; 0, 0]

/-- A selected component moves while its complement stays. -/
def conditionedSymbol (s k : Real) : M2 :=
  character s k • selected + (1 - selected)

/-- The conditioned half-shift is not a periodic Bloch symbol. -/
theorem conditioned_half_shift_does_not_descend :
    ¬ Function.Periodic (conditionedSymbol (1 / 2)) (2 * Real.pi) := by
  convert half_character_does_not_descend using 1
  unfold Function.Periodic DescendsToCircle
  norm_num [conditionedSymbol, selected]

/-- At integral displacement the same conditioned shift is periodic. -/
theorem conditioned_integer_shift_descends (n : Int) :
    Function.Periodic (conditionedSymbol (n : Real)) (2 * Real.pi) := by
  simp +decide [Function.Periodic, conditionedSymbol]
  unfold character selected
  norm_num [Complex.ext_iff, Complex.exp_re, Complex.exp_im]
  exact fun x =>
    ⟨by convert Real.cos_periodic.int_mul n _ using 2 <;> ring,
      by convert Real.sin_periodic.int_mul n _ using 2 <;> ring⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUBlochPeriodicity.character_descends_iff_integer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms character_descends_iff_integer

/-- info: 'PhysicsSM.Draft.NullEdge.HNUBlochPeriodicity.no_fractional_linear_homotopy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_fractional_linear_homotopy

/-- info: 'PhysicsSM.Draft.NullEdge.HNUBlochPeriodicity.conditioned_half_shift_does_not_descend' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conditioned_half_shift_does_not_descend

end

end PhysicsSM.Draft.NullEdge.HNUBlochPeriodicity
