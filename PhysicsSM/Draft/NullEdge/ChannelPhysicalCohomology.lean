import Mathlib

/-!
# Physical channel operators from finite contraction data

For a finite constraint complex with differential `Q`, inclusion `i`,
projection `p`, and contracting homotopy `s`, this module proves that a chain
map has zero induced action `p * X * i` exactly when it is null-homotopic.
Every endomorphism of the physical space also has the explicit lift
`i * f * p`.

The proposed homotopy `s * X + (i * p) * X * s` is correct.  A rational
three-dimensional fixture supplies a nonzero null-homotopic map, a map with
nonzero physical compression, and a zero-compression non-chain-map control.

This is finite matrix algebra.  It does not construct a physical constraint
for the live carrier, impose locality on homotopies, or define the full
carrier-automorphism quotient.

Provenance: theorem shape and explicit homotopy supplied in Pro's 2026-07-11
blocker response.  Proofs and controls returned by Aristotle project
`82b10567-ac62-4c3a-b083-401b85885588`, then compiled independently against
the pinned project.  Lean 4.28.0.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelPhysicalCohomology

variable {K I H : Type*} [Field K]
variable [Fintype I] [DecidableEq I] [Fintype H] [DecidableEq H]

/-- Every null-homotopic operator is a chain map. -/
theorem nullHomotopic_imp_chainMap
    (Q X : Matrix I I K) (hQ2 : Q * Q = 0)
    (h : Exists fun homotopy : Matrix I I K =>
        X = Q * homotopy + homotopy * Q) :
    X * Q = Q * X := by
  obtain ⟨homotopy, rfl⟩ := h
  rw [Matrix.add_mul, Matrix.mul_add, Matrix.mul_assoc homotopy Q Q, hQ2,
    Matrix.mul_zero, ← Matrix.mul_assoc Q Q homotopy, hQ2, Matrix.zero_mul,
    add_zero, zero_add, Matrix.mul_assoc]

/-- The explicit homotopy supplied by finite contraction data. -/
theorem explicit_nullHomotopy
    (Q X s : Matrix I I K) (i : Matrix I H K) (p : Matrix H I K)
    (_hQ2 : Q * Q = 0)
    (hQi : Q * i = 0)
    (hpQ : p * Q = 0)
    (hContract : Q * s + s * Q = 1 - i * p)
    (hChain : X * Q = Q * X)
    (hPhysicalZero : p * X * i = 0) :
    X = Q * (s * X + (i * p) * X * s) +
      (s * X + (i * p) * X * s) * Q := by
  simp_all +decide [mul_add, add_mul, ← Matrix.mul_assoc]
  simp_all +decide [mul_assoc, ← eq_sub_iff_add_eq']
  simp_all +decide [← Matrix.mul_assoc, Matrix.mul_sub]
  simp_all +decide [Matrix.mul_assoc, Matrix.sub_mul]
  abel1

/-- A chain map has zero induced physical action exactly when it is
null-homotopic. -/
theorem induced_eq_zero_iff_nullHomotopic
    (Q X s : Matrix I I K) (i : Matrix I H K) (p : Matrix H I K)
    (hQ2 : Q * Q = 0)
    (_hpi : p * i = 1)
    (hQi : Q * i = 0)
    (hpQ : p * Q = 0)
    (hContract : Q * s + s * Q = 1 - i * p)
    (hChain : X * Q = Q * X) :
    p * X * i = 0 <->
      Exists fun homotopy : Matrix I I K =>
        X = Q * homotopy + homotopy * Q := by
  constructor
  · intro hPhysicalZero
    exact ⟨_, explicit_nullHomotopy Q X s i p hQ2 hQi hpQ hContract hChain
      hPhysicalZero⟩
  · rintro ⟨homotopy, rfl⟩
    have hexp : p * (Q * homotopy + homotopy * Q) * i =
        (p * Q) * homotopy * i + p * homotopy * (Q * i) := by
      simp [Matrix.mul_add, Matrix.add_mul, Matrix.mul_assoc]
    rw [hexp, hpQ, hQi]
    simp

/-- Every physical endomorphism has an explicit chain-map lift. -/
theorem physical_lift_induces
    (Q : Matrix I I K) (i : Matrix I H K) (p : Matrix H I K)
    (f : Matrix H H K)
    (hpi : p * i = 1)
    (hQi : Q * i = 0)
    (hpQ : p * Q = 0) :
    p * (i * f * p) * i = f /\
      (i * f * p) * Q = Q * (i * f * p) := by
  constructor
  · have : p * (i * f * p) * i = (p * i) * f * (p * i) := by
      simp [Matrix.mul_assoc]
    rw [this, hpi, Matrix.mul_one, Matrix.one_mul]
  · have hL : (i * f * p) * Q = 0 := by
      rw [Matrix.mul_assoc, hpQ, Matrix.mul_zero]
    have hR : Q * (i * f * p) = 0 := by
      rw [← Matrix.mul_assoc, ← Matrix.mul_assoc, hQi, Matrix.zero_mul,
        Matrix.zero_mul]
    rw [hL, hR]

/-! ## Rational witness/control triple -/

/-- Rank-one differential: `Q e2 = e1`, with the physical line at `e0`. -/
def Qm : Matrix (Fin 3) (Fin 3) Rat := !![0,0,0; 0,0,1; 0,0,0]

/-- Contracting homotopy for `Qm`. -/
def sm : Matrix (Fin 3) (Fin 3) Rat := !![0,0,0; 0,0,0; 0,1,0]

/-- Inclusion of the physical line. -/
def im : Matrix (Fin 3) (Fin 1) Rat := !![1;0;0]

/-- Projection onto the physical line. -/
def pm : Matrix (Fin 1) (Fin 3) Rat := !![1,0,0]

/-- The concrete matrices satisfy every contraction hypothesis. -/
theorem witness_data_valid :
    Qm * Qm = 0 ∧ pm * im = 1 ∧ Qm * im = 0 ∧ pm * Qm = 0 ∧
      Qm * sm + sm * Qm = 1 - im * pm := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;>
    · ext a b
      fin_cases a <;> fin_cases b <;>
        simp [Qm, sm, im, pm, Matrix.mul_apply, Fin.sum_univ_three]

/-- A nonzero null-homotopic chain map with zero physical compression. -/
theorem witness_nullHomotopic_zero_compression :
    let X : Matrix (Fin 3) (Fin 3) Rat := Qm * sm + sm * Qm
    X ≠ 0 ∧ X * Qm = Qm * X ∧ pm * X * im = 0 ∧
      (Exists fun homotopy : Matrix (Fin 3) (Fin 3) Rat =>
        X = Qm * homotopy + homotopy * Qm) := by
  refine ⟨?_, ?_, ?_, ⟨sm, rfl⟩⟩
  · intro hX
    have hentry := congrArg (fun M => M 1 1) hX
    simp [Qm, sm, Matrix.mul_apply, Fin.sum_univ_three] at hentry
  · ext a b
    fin_cases a <;> fin_cases b <;>
      simp [Qm, sm, Matrix.mul_apply, Fin.sum_univ_three]
  · ext a b
    fin_cases a <;> fin_cases b <;>
      simp [Qm, sm, im, pm, Matrix.mul_apply, Fin.sum_univ_three]

/-- A chain map with nonzero physical compression. -/
theorem witness_nonzero_compression :
    let X : Matrix (Fin 3) (Fin 3) Rat := im * pm
    X * Qm = Qm * X ∧ pm * X * im ≠ 0 := by
  refine ⟨?_, ?_⟩
  · ext a b
    fin_cases a <;> fin_cases b <;>
      simp [Qm, im, pm, Matrix.mul_apply, Fin.sum_univ_three]
  · intro hX
    have hentry := congrArg (fun M => M 0 0) hX
    simp [im, pm, Matrix.mul_apply, Fin.sum_univ_three] at hentry

/-- The chain-map hypothesis is load-bearing: `sm` has zero physical
compression but is neither a chain map nor null-homotopic. -/
theorem control_chainMap_load_bearing :
    pm * sm * im = 0 ∧ sm * Qm ≠ Qm * sm ∧
      ¬ (Exists fun homotopy : Matrix (Fin 3) (Fin 3) Rat =>
        sm = Qm * homotopy + homotopy * Qm) := by
  have hne : sm * Qm ≠ Qm * sm := by
    intro hX
    have hentry := congrArg (fun M => M 1 1) hX
    simp [Qm, sm, Matrix.mul_apply, Fin.sum_univ_three] at hentry
  refine ⟨?_, hne, ?_⟩
  · ext a b
    fin_cases a <;> fin_cases b <;>
      simp [Qm, sm, im, pm, Matrix.mul_apply, Fin.sum_univ_three]
  · intro h
    have hQ2 : Qm * Qm = 0 := by
      ext a b
      fin_cases a <;> fin_cases b <;>
        simp [Qm, Matrix.mul_apply, Fin.sum_univ_three]
    exact hne (nullHomotopic_imp_chainMap Qm sm hQ2 h)

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPhysicalCohomology.induced_eq_zero_iff_nullHomotopic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms induced_eq_zero_iff_nullHomotopic

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPhysicalCohomology.physical_lift_induces' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physical_lift_induces

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPhysicalCohomology.witness_nullHomotopic_zero_compression' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_nullHomotopic_zero_compression

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPhysicalCohomology.witness_nonzero_compression' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_nonzero_compression

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPhysicalCohomology.control_chainMap_load_bearing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms control_chainMap_load_bearing

end PhysicsSM.Draft.NullEdge.ChannelPhysicalCohomology
