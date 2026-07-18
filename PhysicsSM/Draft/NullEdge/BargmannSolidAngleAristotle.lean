import Mathlib

/-!
# The Bargmann three-cycle phase is the half solid angle (VOS-arctan law)

Standalone Aristotle package (Mathlib-only imports). Spiral-layer wave 3,
job A, 2026-07-16.
Integrated 2026-07-16 from Aristotle project 9ba69cff-0383-4052-81fb-4927fd0b3a12 (run bc705062); statements verbatim from the submitted package; namespace renamed for the draft tree; axiom guards added at integration.

## What this file states

Wave 1 landed the polynomial three-cycle identity
tr(P(a)P(b)P(c)) = (1 + a.b + b.c + c.a + i a.(b x c)) / 4. Standard
spherical trigonometry (the Van Oosterom-Strackee formula, cited in the
provenance) says that for unit vectors the oriented solid angle Omega of
the spherical triangle (a, b, c) satisfies
tan(Omega/2) = a.(b x c) / (1 + a.b + b.c + c.a). The right-hand side is
EXACTLY Im/Re of the landed trace. This file kernel-checks the
trace-side half of that correspondence:

1. `bargmann_arg_eq_arctan`: on the domain where the real part
   1 + a.b + b.c + c.a is positive, the complex argument of the Bargmann
   three-cycle equals arctan(triple / (1 + dots)). Combined with the cited
   VOS formula this reads: the corner phase IS the signed half solid angle
   (the identification with Omega is an IMPORT, documented, not claimed as
   a Lean theorem here).
2. `bargmann_arg_octant`: the octant witness x -> y -> z has argument
   exactly pi/4 (= half the octant solid angle pi/2).
3. `bargmann_arg_planar`: a coplanar (zigzag) triple with positive real
   part has argument exactly 0 - no enclosed angle, no phase.
4. `bargmann_arg_neg`: orientation reversal negates the argument on the
   positive-real-part domain (conjugation = opposite handedness).

## Conventions

Identical to the wave-1/wave-2 packages: standard Pauli matrices, raw real
triples `Fin 3 -> R`, proj a = (1 + a.sigma)/2, `dot`/`triple` the
Euclidean dot and right-handed oriented triple product. The positivity
hypothesis `0 < 1 + dot a b + dot b c + dot c a` delimits the principal
branch (it holds for every triangle strictly inside an open hemisphere;
obtuse configurations need branch care and are deliberately out of scope).

## Intended reading (spiral layer)

This turns the wave-1 numerical confirmations (octant arg = pi/4;
tetrahedral ir/3) into the general triangle law "corner phase = half the
enclosed solid angle" with exactly one imported classical identity. It is
the C1-triangle gate of the spiral-layer conjecture ledger
(`AutonomousLab/work/SPIRAL-LAYER/CLAUDE_SPIRAL_LAYER_PROGRAM_NOTE_2026-07-16.md`).
M-grade once proved; the solid-angle reading carries the [import] tag for
Van Oosterom-Strackee.

## Provenance

Clean-room from standard Pauli algebra; the solid-angle identification is
A. Van Oosterom and J. Strackee, "The solid angle of a plane triangle,"
IEEE Trans. Biomed. Eng. BME-30 (1983) 125-126 (standard result; also in
spherical-trigonometry references as L'Huilier-type formulas). Wave-1
companion: the parent repo's SpinCornerBargmannAristotle (three-cycle
identity and witnesses).

## Proof guidance

`bargmann_arg_eq_arctan`: rewrite the trace with the three-cycle identity
(prove it inline as a helper - same entrywise computation as wave 1 - or
re-derive Re/Im directly), then apply Mathlib's arg-of-positive-real-part
characterization (`Complex.arg_eq_arctan` shape: for 0 < z.re,
arg z = arctan (z.im / z.re); search `Complex.arg` API for the exact
name). Note the trace is the quarter of (Re + i Im) with Re > 0 by
hypothesis, and arg is scaling-invariant (`Complex.arg_real_mul` with
positive scalar 1/4). The witnesses are finite 2x2 computations plus
`Real.arctan_one` and `Real.arctan_zero` / `Real.arctan_neg`.

Do not weaken or modify any statement or definition; the placeholder
proofs are the only intended gaps.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.BargmannSolidAngle

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

/-- Spin-coherent corner matrix (1 + a.sigma)/2. -/
def proj (a : Vec3) : SpinMat := (1 / 2 : ℂ) • (1 + pauli a)

/-- Euclidean dot product of raw triples. -/
def dot (a b : Vec3) : ℝ := a 0 * b 0 + a 1 * b 1 + a 2 * b 2

/-- Oriented triple product a.(b x c). -/
def triple (a b c : Vec3) : ℝ :=
  a 0 * (b 1 * c 2 - b 2 * c 1) + a 1 * (b 2 * c 0 - b 0 * c 2)
    + a 2 * (b 0 * c 1 - b 1 * c 0)

/-- Entrywise Pauli-algebra evaluation of the three-cycle trace. -/
lemma trace_proj_cycle (a b c : Vec3) :
    (proj a * proj b * proj c).trace =
      ((1 + dot a b + dot b c + dot c a : ℝ) : ℂ) / 4 +
        ((triple a b c : ℝ) : ℂ) * Complex.I / 4 := by
  unfold proj pauli dot triple;
  simp +decide [ Matrix.trace, Matrix.mul_apply, sigmaX, sigmaY, sigmaZ ] ; ring;
  norm_num ; ring

/-- The principal argument in the open right half-plane. -/
lemma arg_of_re_pos_eq_arctan (x y : ℝ) (hx : 0 < x) :
    Complex.arg ((x : ℂ) + (y : ℂ) * Complex.I) = Real.arctan (y / x) := by
  rw [ Complex.arg, Complex.norm_def, Complex.normSq_apply ];
  norm_num [ Real.arctan_eq_arcsin, hx.le ];
  field_simp;
  rw [ Real.sqrt_div ( by positivity ), Real.sqrt_sq hx.le, mul_div_cancel₀ _ hx.ne' ]

/-- **VOS-arctan law (trace side).** On the principal domain
(positive real part), the Bargmann three-cycle phase is
arctan(triple / (1 + pairwise dots)) - by the cited Van Oosterom-Strackee
formula, the signed half solid angle of the corner triangle. -/
theorem bargmann_arg_eq_arctan (a b c : Vec3)
    (h : 0 < 1 + dot a b + dot b c + dot c a) :
    Complex.arg ((proj a * proj b * proj c).trace)
      = Real.arctan (triple a b c / (1 + dot a b + dot b c + dot c a)) := by
  rw [trace_proj_cycle]
  have hs : (0 : ℝ) < 1 / 4 := by norm_num
  rw [show ((↑(1 + dot a b + dot b c + dot c a) : ℂ) / 4 +
      ↑(triple a b c) * Complex.I / 4) =
      (1 / 4 : ℝ) * (↑(1 + dot a b + dot b c + dot c a) +
        ↑(triple a b c) * Complex.I) by push_cast; ring]
  rw [Complex.arg_real_mul _ hs]
  exact arg_of_re_pos_eq_arctan _ _ h

/-- Unit x direction. -/
def ex : Vec3 := ![1, 0, 0]

/-- Unit y direction. -/
def ey : Vec3 := ![0, 1, 0]

/-- Unit z direction. -/
def ez : Vec3 := ![0, 0, 1]

/-- Octant witness: the handed triple x -> y -> z has phase exactly pi/4,
half the octant solid angle pi/2. -/
theorem bargmann_arg_octant :
    Complex.arg ((proj ex * proj ey * proj ez).trace) = Real.pi / 4 := by
  refine' bargmann_arg_eq_arctan ex ey ez _ |> Eq.trans <| Real.arctan_one ▸ _;
  · unfold dot; norm_num [ ex, ey, ez ] ;
    simp +zetaDelta at *;
  · unfold triple dot ex ey ez; norm_num;
    simp +zetaDelta at *

/-- Planar control: a coplanar triple with positive real part has phase
exactly zero (zigzag content encloses nothing). -/
theorem bargmann_arg_planar :
    Complex.arg ((proj ex * proj ey * proj (fun i => (ex i + ey i) / 2)).trace)
      = 0 := by
  convert bargmann_arg_eq_arctan _ _ _ _ using 1 <;> norm_num [ ex, ey, ez, dot, triple ];
  · simp +zetaDelta at *;
  · erw [ Matrix.cons_val_succ' ] ; norm_num;

/-- Orientation reversal negates the phase on the principal domain. -/
theorem bargmann_arg_neg (a b c : Vec3)
    (h : 0 < 1 + dot a b + dot b c + dot c a) :
    Complex.arg ((proj c * proj b * proj a).trace)
      = -Complex.arg ((proj a * proj b * proj c).trace) := by
  rw [bargmann_arg_eq_arctan, bargmann_arg_eq_arctan]
  · rw [show triple c b a = -triple a b c by unfold triple; ring]
    rw [show dot c b = dot b c by unfold dot; ring]
    rw [show dot b a = dot a b by unfold dot; ring]
    rw [show dot a c = dot c a by unfold dot; ring]
    rw [← Real.arctan_neg]
    ring
  · exact h
  · unfold dot at *
    linarith

end PhysicsSM.Draft.NullEdge.BargmannSolidAngle

/-! ## Build-enforced assumption-footprint guards (added at integration) -/

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannSolidAngle.bargmann_arg_eq_arctan' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannSolidAngle.bargmann_arg_eq_arctan

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannSolidAngle.bargmann_arg_octant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannSolidAngle.bargmann_arg_octant

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannSolidAngle.bargmann_arg_planar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannSolidAngle.bargmann_arg_planar

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannSolidAngle.bargmann_arg_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannSolidAngle.bargmann_arg_neg


end
