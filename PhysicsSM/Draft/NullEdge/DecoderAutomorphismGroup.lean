import Mathlib

/-!
# The derived charge group: automorphisms of the witness decoder

Bridge (vii) of the manuscript's open-bridge list, and RUN_PLAN E2.2: derive
the gauge group as the automorphism group of the decoder data rather than
supplying charge registers.  This package computes it EXACTLY for the
program's explicit three-dimensional witness: the constraint differential
`Q = !![0,1,0;0,0,0;0,0,0]`, the Krein involution `J = !![0,1,0;1,0,0;0,0,1]`,
and the spectral decoder `D = diag(0,0,mu)` (`mu` real, nonzero).

A physical symmetry of the decoder is an invertible `U` with

  `U Q = Q U`,  `Uᴴ J U = J`,  `U D = D U`.

## Targets

1. `automorphism_classification` — the exact two-way normal form.  The
   commutant of the nilpotent `Q` forces the flag form
   `!![a, b, c; 0, a, 0; 0, e, f]`; the Krein isometry then forces
   `|a| = |f| = 1`, `2 Re(conj(a) b) + |e|^2 = 0`, and
   `conj(a) c + conj(e) f = 0`; commutation with `D = diag(0,0,mu)`
   (`mu ≠ 0`) kills `c` and `e`.  The result is the two-parameter torus with
   one real gauge modulus:
   `IsDecoderAut mu U ↔ ∃ (a w : ℂ) (t : ℝ), star a * a = 1 ∧
      star w * w = 1 ∧ U = !![a, (Complex.I * t) * a, 0; 0, a, 0; 0, 0, w]`
   (the condition `Re(conj(a) b) = 0` is equivalent to `b = I t a`, `t`
   real).  This derivation chain was checked by hand before submission; if
   any clause fails, REPORT the discrepancy — do not weaken the
   biconditional to one direction.
2. `induced_action_on_class` — every decoder automorphism acts on the
   physical representative `e2 = ![0,0,1]` by a unit phase: the DERIVED
   charge group acting on the physical class is exactly `U(1)` — derived,
   not inserted.  (The `t`-modulus moves only the exact/gauge line: channel
   gauge, not physical charge.)
3. `witness_nontrivial` — the explicit automorphism `diag(1, 1, I)` acts on
   `e2` by the quarter phase.
4. `rigidity_control` — dropping `D`-commutation strictly enlarges the
   group: a `U0` satisfying the `Q` and Krein conditions but not commuting
   with `D` exists (e.g. flag form with `e = 1`, `c = -1`,
   `b = -1/2`); the decoder is load-bearing in cutting the symmetry to the
   physical torus.

Honest scope: the automorphism group of ONE witness decoder; deriving
`SU(3) x SU(2) x U(1)` or any nonabelian structure is untouched.  What this
establishes is the METHOD: charge groups can be outputs of decoder data.
Do not weaken the statements (two-way characterizations stay two-way; if a
normal form is wrong, report and correct rather than dropping a direction).
Run `lake env lean DecoderAutomorphismGroup/DerivedChargeGroup.lean` first.
Recovered from Aristotle project `c120b23e-292c-45e9-a061-43c83d44fa73`; statements audited unchanged
and proof bodies verified locally under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.DecoderAutomorphismGroup

open Matrix

/-- The witness constraint differential. -/
def Qc : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 0, 0, 0; 0, 0, 0]

/-- The witness Krein involution. -/
def Jc : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 1, 0, 0; 0, 0, 1]

/-- The witness spectral decoder. -/
noncomputable def Dc (mu : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![0, 0, 0; 0, 0, 0; 0, 0, (mu : ℂ)]

/-- A decoder automorphism: invertible, intertwines `Q`, preserves the Krein
form, commutes with the decoder. -/
def IsDecoderAut (mu : ℝ) (U : Matrix (Fin 3) (Fin 3) ℂ) : Prop :=
  IsUnit U ∧ U * Qc = Qc * U ∧ Uᴴ * Jc * U = Jc ∧ U * Dc mu = Dc mu * U

/-- The physical class representative. -/
def e2 : Fin 3 → ℂ := ![0, 0, 1]

/-
Target 2: exact classification of the decoder automorphisms.  (If the
derived normal form differs, prove the corrected two-way version and report
the discrepancy.)
-/
set_option maxHeartbeats 1600000 in
theorem automorphism_classification (mu : ℝ) (hmu : mu ≠ 0)
    (U : Matrix (Fin 3) (Fin 3) ℂ) :
    IsDecoderAut mu U ↔
      ∃ (a w : ℂ) (t : ℝ), star a * a = 1 ∧ star w * w = 1 ∧
        U = !![a, (Complex.I * (t : ℂ)) * a, 0; 0, a, 0; 0, 0, w] := by
  constructor;
  · intro hU
    obtain ⟨h_unit, h_Q, h_J, h_D⟩ := hU;
    -- From hQ : U * Qc = Qc * U, we get the following entries:
    have h10 : U 1 0 = 0 := by
      simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, Qc ];
      simp_all +decide [ Fin.sum_univ_three, Matrix.vecMul ]
    have h20 : U 2 0 = 0 := by
      simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply ];
      simp_all +decide [ Fin.sum_univ_three, Qc, Dc ]
    have h12 : U 1 2 = 0 := by
      simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply ];
      simp_all +decide [ Fin.sum_univ_three, Qc, Dc ]
    have h11 : U 1 1 = U 0 0 := by
      have := congr_fun ( congr_fun h_Q 0 ) 1; simp_all +decide [ Matrix.mul_apply, Fin.sum_univ_succ ] ;
      simp_all +decide [ Qc ];
    -- From hD : U * Dc mu = Dc mu * U, we get the following entries:
    have h02 : U 0 2 = 0 := by
      simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
      simp_all +decide [ Matrix.mul_apply, Fin.sum_univ_three, Dc ]
    have h21 : U 2 1 = 0 := by
      simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
      simp_all +decide [ Matrix.mul_apply, Fin.sum_univ_three, Dc ];
    -- Set a := U 0 0, b := U 0 1, w := U 2 2. All other entries are 0, and U 1 1 = a.
    set a := U 0 0
    set b := U 0 1
    set w := U 2 2
    have ha : star a * a = 1 := by
      replace h_J := congr_fun ( congr_fun h_J 0 ) 1; simp_all +decide [ Matrix.mul_apply, Fin.sum_univ_three ] ;
      unfold Jc at h_J; aesop;
    have hw : star w * w = 1 := by
      replace h_J := congr_fun ( congr_fun h_J 2 ) 2; simp_all +decide [ Matrix.mul_apply, Fin.sum_univ_three ] ;
      unfold Jc at h_J; aesop;
    have hb : ∃ t : ℝ, b = Complex.I * t * a := by
      have hb : star b * a + star a * b = 0 := by
        convert congr_arg ( fun m : Matrix ( Fin 3 ) ( Fin 3 ) ℂ => m 1 1 ) h_J using 1 ; simp +decide [ Matrix.mul_apply, Fin.sum_univ_three ] ; ring;
        simp +decide [ Jc, h10, h20, h12, h02, h21, h11 ];
        rfl;
      -- Let $s = b * star a$. Then $s + star s = 0$, which implies $s$ is purely imaginary.
      set s := b * star a
      have hs : s + star s = 0 := by
        convert hb using 1 ; ring!;
        norm_num [ Complex.ext_iff ]
      have hs_im : ∃ t : ℝ, s = Complex.I * t := by
        simp_all +decide [ Complex.ext_iff ];
      grind;
    obtain ⟨ t, ht ⟩ := hb; use a, w, t; simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ] ;
    exact ⟨ ⟨ rfl, ht ⟩, rfl ⟩;
  · rintro ⟨ a, w, t, ha, hw, rfl ⟩;
    constructor;
    · rw [ Matrix.isUnit_iff_isUnit_det ] ; norm_num [ Matrix.det_fin_three ];
      aesop;
    · simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply ];
      simp +decide [ Fin.sum_univ_succ, Matrix.vecMul, Qc, Jc, Dc ] at *;
      exact ⟨ ⟨ ha, ⟨ ha, by ring ⟩, hw ⟩, mul_comm _ _ ⟩

/-- Target 3: the derived charge group.  Every decoder automorphism acts on
the physical class by a unit phase — the derived `U(1)`. -/
theorem induced_action_on_class (mu : ℝ) (hmu : mu ≠ 0)
    (U : Matrix (Fin 3) (Fin 3) ℂ) (hU : IsDecoderAut mu U) :
    ∃ w : ℂ, star w * w = 1 ∧ U.mulVec e2 = w • e2 := by
  obtain ⟨a, w, t, ha, hw, hUeq⟩ := (automorphism_classification mu hmu U).mp hU
  refine ⟨w, hw, ?_⟩
  subst hUeq
  ext i; fin_cases i <;> simp [e2, Matrix.mulVec, Fin.sum_univ_three, dotProduct]

/-- Target 5: an explicit nontrivial automorphism acting on the physical
class by the quarter phase. -/
theorem witness_nontrivial (mu : ℝ) :
    IsDecoderAut mu !![1, 0, 0; 0, 1, 0; 0, 0, Complex.I] ∧
    (!![1, 0, 0; 0, 1, 0; 0, 0, Complex.I] : Matrix (Fin 3) (Fin 3) ℂ).mulVec e2
      = Complex.I • e2 := by
  constructor
  · refine ⟨?_, ?_, ?_, ?_⟩
    · rw [Matrix.isUnit_iff_isUnit_det, Matrix.det_fin_three]; simp
    · ext i j; fin_cases i <;> fin_cases j <;>
        simp [Qc, Matrix.mul_apply, Fin.sum_univ_three]
    · ext i j; fin_cases i <;> fin_cases j <;>
        simp [Jc, Matrix.mul_apply, Fin.sum_univ_three, Matrix.conjTranspose_apply]
    · ext i j; fin_cases i <;> fin_cases j <;>
        simp [Dc, Matrix.mul_apply, Fin.sum_univ_three] <;> ring
  · ext i; fin_cases i <;> simp [e2, Matrix.mulVec, Fin.sum_univ_three, dotProduct]

/-- Target 6 (rigidity control): dropping decoder-commutation strictly
enlarges the group — an explicit `U0` satisfies the `Q` and Krein conditions
but fails to commute with `D`. -/
theorem rigidity_control (mu : ℝ) (hmu : mu ≠ 0) :
    ∃ U0 : Matrix (Fin 3) (Fin 3) ℂ,
      IsUnit U0 ∧ U0 * Qc = Qc * U0 ∧ U0ᴴ * Jc * U0 = Jc ∧
        U0 * Dc mu ≠ Dc mu * U0 := by
  refine ⟨!![1, -1/2, -1; 0, 1, 0; 0, 1, 1], ?_, ?_, ?_, ?_⟩
  · rw [Matrix.isUnit_iff_isUnit_det, Matrix.det_fin_three]; simp
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [Qc, Matrix.mul_apply, Fin.sum_univ_three]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [Jc, Matrix.mul_apply, Fin.sum_univ_three, Matrix.conjTranspose_apply,
        Complex.ext_iff, Complex.div_re, Complex.div_im] <;> norm_num
  · intro h
    have := congrFun (congrFun h 2) 1
    simp [Dc, Matrix.mul_apply, Fin.sum_univ_three] at this
    exact hmu (by exact_mod_cast this.symm)

end PhysicsSM.Draft.NullEdge.DecoderAutomorphismGroup

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.DecoderAutomorphismGroup.automorphism_classification' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DecoderAutomorphismGroup.automorphism_classification

/-- info: 'PhysicsSM.Draft.NullEdge.DecoderAutomorphismGroup.induced_action_on_class' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DecoderAutomorphismGroup.induced_action_on_class

/-- info: 'PhysicsSM.Draft.NullEdge.DecoderAutomorphismGroup.rigidity_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DecoderAutomorphismGroup.rigidity_control
