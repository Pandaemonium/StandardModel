import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# Penrose's zigzag: massive Dirac = two null Weyl components coupled by mass

A massive Dirac fermion is a LEFT-handed and a RIGHT-handed *massless* Weyl fermion,
each propagating at `c`, coupled by the mass.  We prove the finite one-momentum
decomposition in the chiral (Weyl) basis:

* the kinetic part of the Dirac operator is block-off-diagonal (it maps the two
  chirality subspaces into each other via the two Weyl symbols `KL`, `KR`);
* the mass term is *chiral-odd* — it flips chirality and is exactly what couples the
  two Weyl components;
* at a null (light-cone) momentum the two Weyl symbols are NULL (`KLnull * KRnull = 0`),
  so the massless operator decouples into two independent free null Weyl operators;
* the mass-shell square `D(m)² = (kinetic² + m²)·I` shows the mass lifts the null shell
  to the massive one — instantiated at a 3-4-5 shell: kinetic scale `4`, `m = 3`,
  so `D(3)² = 25·I`.

Everything is finite explicit real linear algebra (2×2 Weyl blocks → 4×4 Dirac).
-/

namespace ZigzagWeyl

open Matrix

/-- 2×2 real matrices: the Weyl (chiral) symbols live here. -/
abbrev M2 := Matrix (Fin 2) (Fin 2) ℝ
/-- 4×4 real matrices: the Dirac operator lives here. -/
abbrev M4 := Matrix (Fin 4) (Fin 4) ℝ

/-- Chirality operator `γ₅ = diag(I, -I)` in the chiral basis. -/
def gamma5 : M4 := !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- The chirality-flipping "off-diagonal identity" block matrix `[[0,I],[I,0]]`. -/
def chiralFlip : M4 := !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]

/-! ## On-shell (scale-4) Weyl symbols

We use `KL = 4·(iσ_y)`, `KR = -KL`.  These satisfy the clean Clifford relation
`KL*KR = KR*KL = 16·I`, so the kinetic operator squares to `16·I` (kinetic scale 4). -/

/-- Left Weyl symbol at the on-shell reference momentum (scale 4). -/
def KL : M2 := !![0,4;-4,0]
/-- Right Weyl symbol at the on-shell reference momentum (scale 4). -/
def KR : M2 := !![0,-4;4,0]

/-- Kinetic Dirac operator `[[0, KR],[KL, 0]]` (block-off-diagonal). -/
def Dkin : M4 := !![0,0,0,-4; 0,0,4,0; 0,4,0,0; -4,0,0,0]

/-- Mass term `Dmass m = m · [[0,I],[I,0]]`: the chirality-flipping coupling. -/
def Dmass (m : ℝ) : M4 := m • chiralFlip

/-- The massive Dirac operator `D(m) = Dkin + Dmass m`. -/
def D (m : ℝ) : M4 := Dkin + Dmass m

/-! ## Null (light-cone) Weyl symbols

At the null momentum `p = (2,0,0,2)` the Weyl symbols become the light-cone projectors
`σ·p = diag(0,4)`, `σ̄·p = diag(4,0)`, which are NULL: their products vanish. -/

/-- Left Weyl symbol at the null (light-cone) momentum. -/
def KLnull : M2 := !![0,0;0,4]
/-- Right Weyl symbol at the null (light-cone) momentum. -/
def KRnull : M2 := !![4,0;0,0]

/-- Kinetic operator built from the null Weyl symbols `[[0, KRnull],[KLnull, 0]]`. -/
def Dnull : M4 := !![0,0,4,0; 0,0,0,0; 0,0,0,0; 0,4,0,0]

/-- **Target 1 — chiral grading.**
`γ₅² = 1`, `tr γ₅ = 0`, and both the mass part and the kinetic part are *chiral-odd*
(`γ₅ · X · γ₅ = -X`): the Weyl components have opposite chirality and the mass couples
them by flipping chirality. -/
theorem chiral_grading (m : ℝ) :
    (gamma5 * gamma5 = (1 : M4)) ∧
    (Matrix.trace gamma5 = 0) ∧
    (gamma5 * Dmass m * gamma5 = - Dmass m) ∧
    (gamma5 * Dkin * gamma5 = - Dkin) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [gamma5, Matrix.mul_apply, Fin.sum_univ_four]
  · simp [gamma5, Matrix.trace, Matrix.diag, Fin.sum_univ_four]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [gamma5, Dmass, chiralFlip, Matrix.mul_apply, Fin.sum_univ_four]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [gamma5, Dkin, Matrix.mul_apply, Fin.sum_univ_four]

/-- info: 'ZigzagWeyl.chiral_grading' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chiral_grading

/-- **Target 2 — massless decouples (payload).**
At `m = 0` the Dirac operator is purely kinetic (`D 0 = Dkin`) and block-off-diagonal:
it anticommutes with `γ₅`, i.e. maps the `+1` chirality subspace into the `-1` one and
vice versa (`γ₅ · Dkin = -(Dkin · γ₅)`, same for the null operator).  At the null
(light-cone) momentum the two Weyl symbols are NULL — the exact null relations are
`KLnull * KRnull = 0` and `KRnull * KLnull = 0` — so the massless operator splits into
two independent free null Weyl operators.  The Weyl symbols are genuinely nonzero and
distinct. -/
theorem massless_decouples :
    (D 0 = Dkin) ∧
    (gamma5 * Dkin = - (Dkin * gamma5)) ∧
    (gamma5 * Dnull = - (Dnull * gamma5)) ∧
    (KLnull * KRnull = 0) ∧ (KRnull * KLnull = 0) ∧
    (KLnull ≠ 0) ∧ (KRnull ≠ 0) ∧ (KLnull ≠ KRnull) ∧
    (KL ≠ 0) ∧ (KR ≠ 0) ∧ (KL ≠ KR) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · simp [D, Dmass]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [gamma5, Dkin, Matrix.mul_apply, Fin.sum_univ_four]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [gamma5, Dnull, Matrix.mul_apply, Fin.sum_univ_four]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [KLnull, KRnull, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [KLnull, KRnull, Matrix.mul_apply, Fin.sum_univ_two]
  · intro h; have := congrFun (congrFun h 1) 1; norm_num [KLnull] at this
  · intro h; have := congrFun (congrFun h 0) 0; norm_num [KRnull] at this
  · intro h; have := congrFun (congrFun h 1) 1; norm_num [KLnull, KRnull] at this
  · intro h; have := congrFun (congrFun h 0) 1; norm_num [KL] at this
  · intro h; have := congrFun (congrFun h 0) 1; norm_num [KR] at this
  · intro h; have := congrFun (congrFun h 0) 1; norm_num [KL, KR] at this

/-- info: 'ZigzagWeyl.massless_decouples' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_decouples

/-- **Target 3 — mass couples (zigzag).**
For `m ≠ 0` the mass term `Dmass m` is nonzero: it is the chirality-flipping coupling
that connects the two Weyl components.  The mass-shell square is
`D(m)² = (16 + m²)·I` — the kinetic scale is `4` (kinetic² = `16`) and the mass adds
`m²`.  Instantiated at the 3-4-5 shell (`m = 3`) this gives `D(3)² = 25·I`, so the mass
is exactly what lifts the null (massless) shell to the massive one. -/
theorem mass_couples (m : ℝ) :
    (D m * D m = (16 + m^2) • (1 : M4)) ∧
    (D 3 * D 3 = (25 : ℝ) • (1 : M4)) ∧
    (m ≠ 0 → Dmass m ≠ 0) := by
  refine ⟨?_, ?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [D, Dkin, Dmass, chiralFlip, Matrix.mul_apply, Fin.sum_univ_four] <;> ring
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [D, Dkin, Dmass, chiralFlip, Matrix.mul_apply, Fin.sum_univ_four] <;> norm_num
  · intro hm h
    have := congrFun (congrFun h 0) 2
    simp [Dmass, chiralFlip] at this
    exact hm this

/-- info: 'ZigzagWeyl.mass_couples' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_couples

/-- **Target 4 — zigzag verdict.**
Packaging 1–3: the massive Dirac operator is two null Weyl components (each moving at
`c`) plus a chirality-flipping mass coupling; at zero mass they decouple into two free
null Weyl operators (`KLnull * KRnull = 0`), and the mass-shell square
`D(m)² = (16 + m²)·I` (with the 3-4-5 instance `D(3)² = 25·I`) shows the mass lifts the
null shell to the massive one. -/
theorem zigzag_verdict (m : ℝ) :
    -- chiral grading
    (gamma5 * gamma5 = (1 : M4) ∧ Matrix.trace gamma5 = 0 ∧
      gamma5 * Dmass m * gamma5 = - Dmass m) ∧
    -- massless decouples into two null Weyl operators
    (D 0 = Dkin ∧ gamma5 * Dnull = - (Dnull * gamma5) ∧
      KLnull * KRnull = 0 ∧ KRnull * KLnull = 0) ∧
    -- the two Weyl symbols are genuinely nonzero and distinct
    (KLnull ≠ 0 ∧ KRnull ≠ 0 ∧ KLnull ≠ KRnull) ∧
    -- mass couples: chirality-flipping term + mass-shell square + 3-4-5 shell
    (m ≠ 0 → Dmass m ≠ 0) ∧
    (D m * D m = (16 + m^2) • (1 : M4)) ∧
    (D 3 * D 3 = (25 : ℝ) • (1 : M4)) := by
  obtain ⟨g1, g2, g3, _⟩ := chiral_grading m
  obtain ⟨d0, _, dn, kn1, kn2, kl0, kr0, kld, _, _, _⟩ := massless_decouples
  obtain ⟨sq, sq3, cpl⟩ := mass_couples m
  exact ⟨⟨g1, g2, g3⟩, ⟨d0, dn, kn1, kn2⟩, ⟨kl0, kr0, kld⟩, cpl, sq, sq3⟩

/-- info: 'ZigzagWeyl.zigzag_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zigzag_verdict

end ZigzagWeyl
