import Mathlib

/-!
# Spin-corner Bargmann calculus: orientation is the only T-odd invariant

Standalone Aristotle package (Mathlib-only imports). Spiral-layer wave 1,
job B, 2026-07-14.

## What this file states

The corner calculus of the null-edge mass program composes spin-coherent
projectors P(a) = (1 + a.sigma)/2 along a history of null directions. This
file pins down, at the polynomial level (no unit-norm hypotheses unless
stated):

1. the pair trace tr(P(a)P(b)) = (1 + a.b)/2 (free-bend channel weight);
2. the Bargmann three-cycle
   tr(P(a)P(b)P(c)) = (1 + a.b + b.c + c.a + i a.(b x c)) / 4,
   whose imaginary part is the oriented triple product - the unique
   orientation-odd (T-odd) scalar of a three-corner history;
3. planar (zigzag) direction content is CP-inert: coplanar directions give a
   real invariant;
4. orientation reversal conjugates the invariant (CPT reading: the reversed
   history carries the complex-conjugate amplitude);
5. same-chirality hairpins are forbidden: for unit a, P(a) P(-a) = 0;
6. the two-channel corner split: (1 + a.b)/2 + (1 - a.b)/2 = 1 at the trace
   level (free-bend channel + mass-flip channel);
7. a handed witness: the x -> y -> z triple has invariant (1 + i)/4 and its
   mirror (1 - i)/4.

## Conventions

- Pauli matrices: sigmaX = !![0,1;1,0], sigmaY = !![0,-i;i,0],
  sigmaZ = !![1,0;0,-1] (standard).
- Directions are raw real triples `Fin 3 -> R`; `dot` and `triple` are the
  Euclidean dot and oriented triple product a.(b x c). No normalization is
  assumed except where a `dot a a = 1` hypothesis is written.
- proj a = (1 + a.sigma)/2 is a genuine projector exactly when a is unit;
  the polynomial identities below do not need that.

## Intended reading (spiral layer)

Im tr(P(a)P(b)P(c)) = a.(b x c) / 4 is the only orientation-odd scalar in
the corner calculus, and it vanishes on every planar history. So zigzag
(planar) direction content cannot generate CP-odd phases; handed, nonplanar
(spiral) direction content is necessary. Reversal-conjugation matches the
program's CPT module (antiparticle = orientation-reversed history). The
tetrahedral witness in the parent repo (trace value i*r/3, reversal -i*r/3)
is this file's general identity evaluated at the tetrahedral frame.

These are M-grade finite identities once proved. No claim about continuum CP
violation is made by the statements; that reading is interpretation.

## Provenance

Clean-room from standard Pauli two-spinor algebra and the Bargmann invariant
for spin-1/2 coherent states (geometric phase = minus half the enclosed solid
angle). Companion modules in the parent repo:
`PhysicsSM.Draft.NullEdge.TetrahedralSpinProjectorPath` (tetrahedral witness),
`PhysicsSM.Draft.NullEdge.GateI1.MassCoinBridge` (flip channel = mass coin),
and the CPT zigzag module (conjugation = orientation reversal).

## Proof guidance

Everything is 2x2 and entrywise-finite. Unfold `proj`, `pauli`, `dot`,
`triple`; then `ext i j; fin_cases i <;> fin_cases j` with
`simp [Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply]` and
`Complex.ext_iff` / `norm_num` / `ring` should close each goal. For trace
goals, `Matrix.trace_fin_two` helps. For `antipodal_annihilation`, expand and
use the hypothesis `dot a a = 1` after `ring_nf`.

Do not weaken or modify any statement or definition; the placeholder proofs
are the only intended gaps.
-/

noncomputable section

namespace SpinCornerCore

open Matrix

/-- 2x2 complex matrices: the spin-coherent corner algebra. -/
abbrev SpinMat := Matrix (Fin 2) (Fin 2) ℂ

/-- Raw real direction triples (no normalization built in). -/
abbrev Vec3 := Fin 3 → ℝ

/-- Standard Pauli sigma_x. -/
def sigmaX : SpinMat := !![0, 1; 1, 0]

/-- Standard Pauli sigma_y. -/
def sigmaY : SpinMat := !![0, -Complex.I; Complex.I, 0]

/-- Standard Pauli sigma_z. -/
def sigmaZ : SpinMat := !![1, 0; 0, -1]

/-- Pauli vector a.sigma for a raw real triple a. -/
def pauli (a : Vec3) : SpinMat :=
  ((a 0 : ℂ)) • sigmaX + ((a 1 : ℂ)) • sigmaY + ((a 2 : ℂ)) • sigmaZ

/-- Spin-coherent corner matrix (1 + a.sigma)/2; a genuine projector exactly
when a is unit. Polynomial statements below carry no norm hypothesis. -/
def proj (a : Vec3) : SpinMat := (1 / 2 : ℂ) • (1 + pauli a)

/-- Euclidean dot product of raw triples. -/
def dot (a b : Vec3) : ℝ := a 0 * b 0 + a 1 * b 1 + a 2 * b 2

/-- Oriented triple product a.(b x c): the orientation-odd scalar. -/
def triple (a b c : Vec3) : ℝ :=
  a 0 * (b 1 * c 2 - b 2 * c 1) + a 1 * (b 2 * c 0 - b 0 * c 2)
    + a 2 * (b 0 * c 1 - b 1 * c 0)

/-- Pauli-vector square: (a.sigma)^2 = (a.a) * 1. Polynomial in a. -/
theorem pauli_sq (a : Vec3) :
    pauli a * pauli a = ((dot a a : ℝ) : ℂ) • (1 : SpinMat) := by
      ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply ] <;> ring;
      · unfold pauli dot; norm_num [ sigmaX, sigmaY, sigmaZ ] ; ring;
        norm_num ; ring;
      · unfold pauli; norm_num [ sigmaX, sigmaY, sigmaZ ] ; ring;
      · unfold pauli;
        simp +decide [ sigmaX, sigmaY, sigmaZ ];
      · unfold pauli; norm_num [ dot ] ; ring;
        unfold sigmaX sigmaY sigmaZ; norm_num ; ring;
        norm_num

/-- Pair trace: tr(P(a) P(b)) = (1 + a.b)/2. Free-bend channel weight;
polynomial, no unit-norm hypothesis. -/
theorem pair_trace (a b : Vec3) :
    (proj a * proj b).trace = ((1 + dot a b : ℝ) : ℂ) / 2 := by
      unfold proj dot;
      norm_num [ Matrix.trace, Matrix.mul_apply, pauli, sigmaX, sigmaY, sigmaZ ];
      ring ; norm_num

/-- Bargmann three-cycle:
tr(P(a) P(b) P(c)) = (1 + a.b + b.c + c.a + i * a.(b x c)) / 4.
Polynomial - no norm hypotheses. -/
theorem bargmann_three_cycle (a b c : Vec3) :
    (proj a * proj b * proj c).trace
      = (((1 + dot a b + dot b c + dot c a : ℝ) : ℂ)
          + Complex.I * ((triple a b c : ℝ) : ℂ)) / 4 := by
            unfold proj;
            unfold pauli;
            simp +decide [ Matrix.trace_fin_two, Matrix.mul_apply ];
            unfold sigmaX sigmaY sigmaZ dot triple; norm_num [ Complex.ext_iff ] ; ring;
            norm_num

/-- The imaginary part of the Bargmann three-cycle is the oriented volume:
the unique T-odd (orientation-odd) invariant of a three-corner history. -/
theorem bargmann_im (a b c : Vec3) :
    ((proj a * proj b * proj c).trace).im = triple a b c / 4 := by
      rw [ bargmann_three_cycle ];
      norm_num [ div_eq_mul_inv ]

/-- Planar (zigzag) direction content is CP-inert: coplanar directions give a
real Bargmann invariant. -/
theorem planar_cp_inert (a b c : Vec3) (h : triple a b c = 0) :
    ((proj a * proj b * proj c).trace).im = 0 := by
      rw [ bargmann_im, h, zero_div ]

/-- Orientation reversal conjugates the invariant (CPT reading: the reversed
history is the complex-conjugate amplitude). -/
theorem reversal_conj (a b c : Vec3) :
    (proj c * proj b * proj a).trace
      = star ((proj a * proj b * proj c).trace) := by
        convert bargmann_three_cycle c b a using 1;
        convert congr_arg Star.star ( bargmann_three_cycle a b c ) using 1 ; norm_num [ Complex.ext_iff ] ; ring;
        unfold dot triple; ring; aesop;

/-- Same-chirality hairpins are forbidden: for a unit direction a, the
corner matrices at a and -a annihilate. -/
theorem antipodal_annihilation (a : Vec3) (h : dot a a = 1) :
    proj a * proj (-a) = 0 := by
      unfold proj;
      -- By definition of $pauli$, we know that $pauli (-a) = -pauli a$.
      have h_pauli_neg : pauli (-a) = -pauli a := by
        unfold pauli; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ sigmaX, sigmaY, sigmaZ ] <;> ring;
      simp_all +decide [ Matrix.mul_add, add_mul, smul_smul ];
      rw [ pauli_sq ] ; norm_num [ h ] ; abel_nf;

/-- Two-channel corner split: same-helicity continuation weight (1 + a.b)/2
plus flipped-helicity weight (1 - a.b)/2 equals 1 (free-bend channel plus
mass-flip channel). Polynomial, no norm hypotheses. -/
theorem corner_channel_sum (a b : Vec3) :
    (proj a * proj b).trace + (proj a * proj (-b)).trace = 1 := by
      rw [ pair_trace, pair_trace ] ; norm_num ; ring;
      unfold dot; norm_num; ring;

/-- Unit x direction. -/
def ex : Vec3 := ![1, 0, 0]

/-- Unit y direction. -/
def ey : Vec3 := ![0, 1, 0]

/-- Unit z direction. -/
def ez : Vec3 := ![0, 0, 1]

/-- Handed witness: the x -> y -> z corner triple has Bargmann invariant
(1 + i)/4 - nonzero imaginary part, i.e. nonzero enclosed orientation. -/
theorem witness_handed :
    (proj ex * proj ey * proj ez).trace = (1 + Complex.I) / 4 := by
      convert SpinCornerCore.bargmann_three_cycle ex ey ez using 1;
      unfold ex ey ez dot triple; norm_num [ Complex.ext_iff ] ;
      aesop

/-- Mirror witness: the reversed triple gives the conjugate (1 - i)/4. -/
theorem witness_mirror :
    (proj ez * proj ey * proj ex).trace = (1 - Complex.I) / 4 := by
      convert reversal_conj _ _ _ using 1;
      rw [ witness_handed ] ; norm_num [ Complex.ext_iff ]

end SpinCornerCore

end
