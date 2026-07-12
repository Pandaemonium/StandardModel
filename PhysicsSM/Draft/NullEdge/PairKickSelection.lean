/-
Provenance: Aristotle job c2c1d0b0 (fable-24h-selection), harvested
2026-07-11 ~19:50 PDT. All three statements integrated UNCHANGED
(statement-level diff). KERNEL-ONLY (standard three axioms; the string
"native_decide" below appears only in prose).
Oracle: selection_oracle (2026-07-11) - exact linear algebra on the
4-real-dimensional block space under the repo's own site-local chiral
phase action.
AUDIT NOTES (hostile2 F5/F6/F8): `Dphase = diag(u,1)` is the site-local
CHIRAL phase, not the scalar common phase (under `diag(u,u)` the block
transforms trivially and the constraints force H = 0 - the scalar-gauge
collapse theorem is now LANDED: Selection2Repairs.scalar_gauge_collapse;
the lemma tying `Dphase` to the repo's one-particle phase operator
remains open). The uniqueness is a
2x2 BLOCK-level classification; the reduction from the CAR quartic class
to the block is definitional packaging, not a theorem here.
Program role: RESOLVES Paper A's pre-registered selection conjecture
POSITIVELY AT BLOCK LEVEL - block-gauge equivariance + Hermiticity +
vanishing at z = 0 force exactly the one-complex-parameter pair-kick
family (uniqueness and converse; the control covers the vanishing
constraint only). Within the stated boundaries the supplied interaction
is the unique solution of the displayed constraint set.
-/
import Mathlib

/-!
# The pair kick is the unique phase-reading block coupling

Resolves (at block level) the pre-registered selection conjecture of the
null-edge Paper A: among pair-block couplings that read the derived
complex datum `z`, the phase-covariance constraint selects exactly the
one-complex-parameter family of the supplied interaction generator.

Setting: the interaction block is spanned by the two doubly-occupied
pair states, so a coupling is a `2 x 2` complex matrix.  A DATUM-READING
FAMILY is `H z = C + z • A + (conj z) • B` for fixed matrices `A B C`
(linear response to the field plus a field-independent part).  The
repo's gauge action (`chiralPhase`, one-particle `diag(u,1)` at the
kick's site) acts on the block as conjugation by `D u = !![u, 0; 0, 1]`.

The three pre-registered constraints:
* EQUIVARIANCE: for all unimodular `u` and all `z`,
  `H (u * z) = D u * H z * (D u)^H`  (the family transforms with the
  field under the site-local CHIRAL phase action `diag(u,1)` - see the
  audit note above: this is NOT the scalar common phase);
* HERMITICITY: `(H z)^H = H z` for every `z`;
* VANISHING: `H 0 = 0` (the coupling reads the datum and nothing else).

Oracle (exact sympy, 2026-07-11): the joint solution space is
`A = !![0, a; 0, 0]`, `B = A^H`, `C = 0` - exactly
`H z = !![0, a*z; conj (a*z), 0]`, one complex parameter `a`,
real dimension two: the real span of the supplied generator `K z` and
its quarter-phase rotation `K (i z)`.  The kill condition (dimension
above two) does NOT fire: uniqueness holds.

## Targets

T1 (uniqueness, the headline): under the three constraints there exists
`a : C` with `H z = !![0, a * z; conj (a * z), 0]` for every `z`.

T2 (converse/nonvacuity): every member of the family satisfies all
three constraints.

T3 (control, honest scope per the hostile2 audit F7): the landed
control `H' z = !![1, 0; 0, 0]` (constant, Hermitian) witnesses ONLY a
violation of the VANISHING constraint (`H' 0 /= 0`); it does not test
equivariance, which is the constraint actually driving uniqueness.  An
equivariance-violating control and the scalar-gauge collapse theorem
are now LANDED (Selection2Repairs.equivariance_violating_control,
Selection2Repairs.scalar_gauge_collapse) - the control suite covers
vanishing, equivariance, and the scalar gauge; the lemma tying `Dphase`
to the repo's one-particle phase operator remains the open item.

Proof notes: instantiate equivariance at two unimodular values, e.g.
`u = Complex.I` and `u = -1`, and read off entrywise linear equations;
Hermiticity at `z = 1` and `z = Complex.I` pins `B = A^H` and `C^H = C`;
vanishing kills `C`.  All finite 2x2 complex algebra - kernel-only, NO
native_decide.  Statements must not be weakened; kill condition: if any
entry equation contradicts the oracle solution, prove the corrected
fact, name it, stop.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PairKickSelection

open Matrix

abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ

/-- The block gauge action of the site-local chiral phase. -/
def Dphase (u : ℂ) : M2 := !![u, 0; 0, 1]

/-- A datum-reading family: constant + linear response. -/
def famH (C A B : M2) (z : ℂ) : M2 := C + z • A + (starRingEnd ℂ z) • B

/-
T1: the three pre-registered constraints force the one-parameter
kick family.
-/
theorem selection_uniqueness (C A B : M2)
    (hequi : ∀ u z : ℂ, ‖u‖ = 1 →
      famH C A B (u * z) = Dphase u * famH C A B z * (Dphase u)ᴴ)
    (hherm : ∀ z : ℂ, (famH C A B z)ᴴ = famH C A B z)
    (hzero : famH C A B 0 = 0) :
    ∃ a : ℂ, ∀ z : ℂ,
      famH C A B z = !![0, a * z; starRingEnd ℂ (a * z), 0] := by
  simp_all +decide [ famH, Dphase ];
  simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.vecMul, Matrix.mul_apply ];
  simp_all +decide [ vecHead, vecTail ];
  use A 0 1;
  intro z; have := hherm z; have := hequi ( -1 ) z; have := hequi Complex.I z; norm_num [ Complex.ext_iff ] at * ;
  grind

/-
T2: every member of the family satisfies the constraints.
-/
theorem selection_family_admissible (a : ℂ) :
    (∀ u z : ℂ, ‖u‖ = 1 →
        (!![0, a * (u * z); starRingEnd ℂ (a * (u * z)), 0] : M2)
          = Dphase u * !![0, a * z; starRingEnd ℂ (a * z), 0] * (Dphase u)ᴴ)
      ∧ (∀ z : ℂ, (!![0, a * z; starRingEnd ℂ (a * z), 0] : M2)ᴴ
          = !![0, a * z; starRingEnd ℂ (a * z), 0])
      ∧ (!![0, a * (0:ℂ); starRingEnd ℂ (a * 0), 0] : M2) = 0 := by
  refine' ⟨ _, _, _ ⟩;
  · intro u z hu; ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Dphase, Matrix.mul_apply ] ; ring;
    ring;
  · intro z; ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.conjTranspose ] ;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num

/-
T3: the constraint set is load-bearing - the constant Hermitian
coupling `!![1,0;0,0]` fails the vanishing constraint.
-/
theorem selection_control :
    (∀ z : ℂ, ((fun _ : ℂ => (!![1, 0; 0, 0] : M2)) z)ᴴ
        = (fun _ : ℂ => (!![1, 0; 0, 0] : M2)) z)
      ∧ (fun _ : ℂ => (!![1, 0; 0, 0] : M2)) 0 ≠ 0 := by
  norm_num [ ← Matrix.ext_iff, Fin.forall_fin_two ]

end PhysicsSM.Draft.NullEdge.PairKickSelection
