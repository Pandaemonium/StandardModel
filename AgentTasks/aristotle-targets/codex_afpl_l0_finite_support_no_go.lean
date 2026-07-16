import PhysicsSM.Draft.NullEdge.Goal3BoostCovRational

/-!
# AFPL L0 finite-support boost no-go target

The rational 3-4-5 Lorentz boost preserves the Minkowski form, but the selected
future timelike vector `(1,0)` has an infinite forward orbit. Consequently no
finite set containing that vector can be forward-invariant under the boost.

This is a fixed-support obstruction. It does not disprove Lorentz invariance in
distribution for a random causal set or construct such an invariant measure.
-/

namespace PhysicsSM.Draft.NullEdge.L0FiniteSupportBoostNoGo

open Goal3BoostCovRational

abbrev Vec := Fin 2 -> ℚ

/-- Action of the exact rational 3-4-5 boost on a momentum vector. -/
def boostVec (v : Vec) : Vec := Matrix.mulVec Lam v

/-- The selected nonzero future timelike vector. -/
def restVec : Vec := ![1, 0]

/-- The expanding null coordinate `t+x`. -/
def nullPlus (v : Vec) : ℚ := v 0 + v 1

/-- The forward boost orbit of the selected vector. -/
def orbit : Nat -> Vec
  | 0 => restVec
  | n + 1 => boostVec (orbit n)

/-- The rational boost triples the `t+x` null coordinate. -/
lemma nullPlus_boostVec (v : Vec) :
    nullPlus (boostVec v) = 3 * nullPlus v := by
  simp [nullPlus, boostVec, Lam, Boost, Matrix.mulVec, dotProduct,
    Fin.sum_univ_two]
  ring

/-- Along the selected orbit, the expanding null coordinate is exactly `3^n`. -/
lemma nullPlus_orbit (n : Nat) : nullPlus (orbit n) = (3 : ℚ) ^ n := by
  induction n with
  | zero => simp [orbit, nullPlus, restVec]
  | succ n ih =>
      rw [orbit, nullPlus_boostVec, ih, pow_succ]
      ring

/-- Powers of three are strictly increasing over the natural exponent. -/
lemma pow_three_strictMono : StrictMono (fun n : Nat => (3 : ℚ) ^ n) := by
  apply strictMono_nat_of_lt_succ
  intro n
  rw [pow_succ]
  have hpos : 0 < (3 : ℚ) ^ n := by positivity
  nlinarith

/-- The selected boost orbit has no repetitions. -/
theorem orbit_injective : Function.Injective orbit := by
  intro m n hmn
  have hplus := congrArg nullPlus hmn
  rw [nullPlus_orbit, nullPlus_orbit] at hplus
  exact pow_three_strictMono.injective hplus

/-- Forward invariance of a finite support under the selected boost. -/
def ForwardInvariant (S : Finset Vec) : Prop :=
  forall v, v ∈ S -> boostVec v ∈ S

/-- Every forward iterate remains in a forward-invariant support containing
the selected vector. -/
lemma orbit_mem_of_forwardInvariant (S : Finset Vec)
    (hrest : restVec ∈ S) (hinv : ForwardInvariant S) :
    forall n, orbit n ∈ S := by
  intro n
  induction n with
  | zero => simpa [orbit] using hrest
  | succ n ih =>
      simpa [orbit] using hinv (orbit n) ih

/-- **Finite-support boost no-go.** No finite support containing the selected
nonzero future vector can be forward-invariant under the noncompact rational
boost. -/
theorem no_finite_forward_invariant_support :
    ¬ ∃ S : Finset Vec, restVec ∈ S ∧ ForwardInvariant S := by
  rintro ⟨S, hrest, hinv⟩
  have hsubset : Set.range orbit ⊆ (S : Set Vec) := by
    rintro v ⟨n, rfl⟩
    exact orbit_mem_of_forwardInvariant S hrest hinv n
  have hrange_finite : (Set.range orbit).Finite := S.finite_toSet.subset hsubset
  exact (Set.infinite_range_of_injective orbit_injective) hrange_finite

/-! ## Nondegeneracy and boundary controls -/

/-- The selected vector is nonzero, future-directed, and unit timelike. -/
theorem restVec_control :
    restVec ≠ 0 ∧ 0 < restVec 0 ∧ Q restVec = 1 := by
  constructor
  · intro h
    have := congrFun h 0
    norm_num [restVec] at this
  constructor <;> norm_num [restVec, Q]

/-- The zero vector is fixed; excluding it from the no-go would be essential. -/
theorem zero_fixed : boostVec 0 = 0 := by
  ext i
  fin_cases i <;>
    simp [boostVec, Lam, Boost, Matrix.mulVec, dotProduct]

/-- The singleton zero support is a genuine finite invariant boundary case. -/
theorem zero_singleton_forwardInvariant : ForwardInvariant {0} := by
  intro v hv
  simp only [Finset.mem_singleton] at hv ⊢
  subst v
  exact zero_fixed

/-- The identity transformation preserves every finite support, so
noncompactness of the selected boost is load-bearing in the no-go. -/
theorem identity_preserves_every_finite_support (S : Finset Vec) :
    forall v, v ∈ S -> Matrix.mulVec (1 : Matrix (Fin 2) (Fin 2) ℚ) v ∈ S := by
  intro v hv
  simpa using hv

end PhysicsSM.Draft.NullEdge.L0FiniteSupportBoostNoGo
