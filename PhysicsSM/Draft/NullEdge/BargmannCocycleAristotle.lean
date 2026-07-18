import Mathlib

/-!
# The Bargmann cocycle law: polygon phases decompose over triangles

Standalone Aristotle package (Mathlib-only imports). Spiral-layer wave 4,
job A, 2026-07-16.
Integrated 2026-07-16 from Aristotle project 74a06ae4-2d52-4ab2-a400-a865083da653 (run 6921d3b6); statements verbatim from the submitted package; namespace renamed for the draft tree; axiom guards added at integration.

## What this file states

For UNIT direction triples, the spin-coherent corner invariants satisfy the
exact multiplicative cocycle law

  tr(P(a)P(b)P(c)) * tr(P(a)P(c)P(d))
    = tr(P(a)P(b)P(c)P(d)) * tr(P(a)P(c)),

and since the pair trace tr(P(a)P(c)) = (1 + a.c)/2 is a nonnegative real
(positive when a.c > -1), the FOUR-corner phase equals the phase of the
product of the two TRIANGLE invariants obtained by cutting along the
diagonal (a, c). Combined with the landed wave-3 triangle law
(arg = arctan(triple/(1+dots)), i.e. the signed half solid angle via the
cited Van Oosterom-Strackee import), this makes the solid-angle law for
spherical POLYGONS provable by induction on a triangulating diagonal fan:
the C1-polygon gate of the spiral-layer conjecture ledger reduces to this
cocycle plus the landed triangle case.

Statements:

1. `bargmann_cocycle` - the exact law above, for unit a, b, c, d.
2. `bargmann_cocycle_arg` - phase form: when -1 < a.c, the four-cycle
   argument equals the argument of the product of the two diagonal
   triangles (multiplying by the positive real pair trace preserves arg
   exactly; no mod-2pi bookkeeping enters this statement).
3. `bargmann_cocycle_degenerate` - boundary control: with c = -a
   (antipodal diagonal) both sides vanish; the law is degenerate exactly
   where the diagonal pair trace vanishes.
4. `quadrilateral_witness` - a rational nonplanar witness: a = x, b = y,
   c = z, d = (0, 3/5, 4/5) (a Pythagorean unit vector); the cocycle
   instantiates with all four traces nonzero, certifying nonvacuity of
   the phase-addition reading.

## Conventions

Identical to the wave-1/2/3 packages: standard Pauli matrices, raw real
triples `Fin 3 -> R`, proj a = (1 + a.sigma)/2, `dot`/`triple` Euclidean.
Unlike the polynomial wave-2 identities, the cocycle needs the four UNIT
hypotheses (`dot a a = 1` etc.): it is the rank-one projector property
P(v)^2 = P(v) that makes the middle P(a) and P(c) collapse; the underlying
bra-ket derivation is
tr = <a|b><b|c><c|a> etc., so LHS = <a|b><b|c><c|d><d|a> |<a|c>|^2 = RHS.

## Intended reading (spiral layer)

Cutting a spherical polygon along a diagonal splits its Bargmann phase
into the two sub-polygon phases EXACTLY (the diagonal contributes a
positive real factor, never a phase). By induction from the landed
triangle solid-angle law, the corner phase of ANY diagonal-triangulated
spherical polygon is half its total oriented solid angle - closing the
C1-polygon gate at M + the single documented VOS [import], with the
obtuse/branch caveats inherited from the triangle case. M-grade once
proved; the induction packaging and the solid-angle reading live in the
program note, not in this file's statements.

## Provenance

Clean-room from standard rank-one projector algebra (Bargmann invariant
multiplicativity); the bra-ket identity above was re-derived by hand
before submission and checked at the degenerate hairpin (0 = 0). Wave-1/2/3
parent-repo companions: SpinCornerBargmannAristotle,
SpinCornerFourCycleAristotle, BargmannSolidAngleAristotle.

## Proof guidance

Everything is 2x2 entrywise-finite. For `bargmann_cocycle`, either the
direct route (ext/fin_cases/simp with Matrix.mul_apply, Fin.sum_univ_succ,
then Complex.ext_iff + ring, using the unit hypotheses via ring_nf and
substitution of a0^2 + a1^2 + a2^2 = 1 where needed) or the structured
route (prove P(v) * M * P(v) = (scalar) * P(v)-type collapse lemmas from
idempotence P(v)^2 = P(v), which holds exactly under `dot v v = 1` -
wave-1's sandwich pattern). `bargmann_cocycle_arg`: rewrite with the
cocycle, then `Complex.arg_real_mul`-shaped lemmas with the positive real
(1 + a.c)/2 (positivity from -1 < a.c); the pair-trace value is wave-1's
`pair_trace` re-proved inline as a helper. The witness is instantiation
plus norm_num. Helper lemmas welcome; the four numbered statements must
stay verbatim.

Do not weaken or modify any statement or definition; the placeholder
proofs are the only intended gaps.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.BargmannCocycle

open Matrix

/-- 2x2 complex matrices: the spin-coherent corner algebra. -/
abbrev SpinMat := Matrix (Fin 2) (Fin 2) ℂ

/-- Raw real direction triples. -/
abbrev Vec3 := Fin 3 → ℝ

/-- Standard Pauli sigma_x. -/
def sigmaX : SpinMat := !![0, 1; 1, 0]

/-- Standard Pauli sigma_y. -/
def sigmaY : SpinMat := !![0, -Complex.I; Complex.I, 0]

/-- Standard Pauli sigma_z. -/
def sigmaZ : SpinMat := !![1, 0; 0, -1]

/-- Pauli vector a.sigma. -/
def pauli (a : Vec3) : SpinMat :=
  ((a 0 : ℂ)) • sigmaX + ((a 1 : ℂ)) • sigmaY + ((a 2 : ℂ)) • sigmaZ

/-- Spin-coherent corner matrix (1 + a.sigma)/2. -/
def proj (a : Vec3) : SpinMat := (1 / 2 : ℂ) • (1 + pauli a)

/-- Euclidean dot product. -/
def dot (a b : Vec3) : ℝ := a 0 * b 0 + a 1 * b 1 + a 2 * b 2

/-- **1. The Bargmann cocycle law.** For unit directions, cutting the
four-corner invariant along the diagonal (a, c) factorizes it into the two
triangle invariants times the real diagonal pair trace. -/
theorem bargmann_cocycle (a b c d : Vec3)
    (ha : dot a a = 1) (hb : dot b b = 1) (hc : dot c c = 1)
    (hd : dot d d = 1) :
    (proj a * proj b * proj c).trace * (proj a * proj c * proj d).trace
      = (proj a * proj b * proj c * proj d).trace
          * (proj a * proj c).trace := by
  norm_num [ Matrix.trace, Matrix.mul_apply ];
  unfold proj;
  unfold pauli;
  simp +decide [ sigmaX, sigmaY, sigmaZ ] at *;
  unfold dot at *;
  norm_num [ Complex.ext_iff ] at *;
  grind +locals

/-- **2. Phase form.** With a nondegenerate diagonal (-1 < a.c), the
four-corner phase equals the phase of the product of the two diagonal
triangles: the diagonal contributes a positive real factor, never a
phase. -/
theorem bargmann_cocycle_arg (a b c d : Vec3)
    (ha : dot a a = 1) (hb : dot b b = 1) (hc : dot c c = 1)
    (hd : dot d d = 1) (hac : -1 < dot a c) :
    Complex.arg ((proj a * proj b * proj c * proj d).trace)
      = Complex.arg
          ((proj a * proj b * proj c).trace
            * (proj a * proj c * proj d).trace) := by
  convert Complex.arg_real_mul _ _ using 2;
  case convert_2 => exact ( 2 : ℝ ) / ( 1 + dot a c );
  · rw [ bargmann_cocycle a b c d ha hb hc hd ];
    -- By definition of `proj`, we know that `(proj a * proj c).trace = ((1 + dot a c) / 2 : ℝ)`.
    have h_trace : (proj a * proj c).trace = ((1 + dot a c) / 2 : ℝ) := by
      unfold proj dot pauli;
      norm_num [ Matrix.trace, Matrix.mul_apply, sigmaX, sigmaY, sigmaZ ] ; ring;
      norm_num;
    rw [ h_trace ] ; push_cast ; ring;
    linear_combination -mul_inv_cancel₀ ( show ( 1 + dot a c : ℂ ) ≠ 0 from mod_cast by linarith ) * ( proj a * proj b * proj c * proj d |> Matrix.trace );
  · exact div_pos zero_lt_two ( by linarith )

/-- **3. Degenerate-diagonal control.** With an antipodal diagonal both
sides of the cocycle vanish (unit a): the law degenerates exactly where
the diagonal pair trace does. -/
theorem bargmann_cocycle_degenerate (a b d : Vec3) (ha : dot a a = 1) :
    (proj a * proj b * proj (-a)).trace * (proj a * proj (-a) * proj d).trace
      = 0 := by
  simp_all +decide [ Matrix.trace ];
  unfold proj pauli at *;
  unfold sigmaX sigmaY sigmaZ at *; norm_num [ Matrix.mul_apply ] at *;
  ring_nf at *;
  norm_num [ Complex.ext_iff, sq ] at *;
  unfold dot at ha; linarith;

/-- Unit x direction. -/
def ex : Vec3 := ![1, 0, 0]

/-- Unit y direction. -/
def ey : Vec3 := ![0, 1, 0]

/-- Unit z direction. -/
def ez : Vec3 := ![0, 0, 1]

/-- Pythagorean unit direction (0, 3/5, 4/5). -/
def ew : Vec3 := ![0, 3 / 5, 4 / 5]

/-- **4. Nonvacuity witness.** For the nonplanar quadrilateral
x -> y -> z -> (0, 3/5, 4/5), the diagonal pair trace is the positive real
1/2 and the four-cycle invariant is nonzero, so the phase-addition reading
is nonvacuous. -/
theorem quadrilateral_witness :
    (proj ex * proj ez).trace = 1 / 2 ∧
    (proj ex * proj ey * proj ez * proj ew).trace ≠ 0 := by
  norm_num [ Fin.sum_univ_succ, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.trace ];
  unfold proj;
  unfold pauli;
  simp +decide [ sigmaX, sigmaY, sigmaZ, ex, ey, ez, ew ];
  norm_num [ Complex.ext_iff ]

/-! ## Strengthened forms (post-integration pass, 2026-07-16)

The Aristotle linter reported that the proof of `bargmann_cocycle` never
uses the unit hypotheses on `b` and `d`.  The mathematical reason: writing
the unit diagonal projectors as rank-one bra-kets, the law reduces to
scalar commutativity of `<a|P(b)|c><c|a> * <a|c><c|P(d)|a>`, in which
`P(b)` and `P(d)` are arbitrary matrix slots.  The general forms below drop
those hypotheses; the original four numbered statements above are kept
verbatim per the integration provenance. -/

/-- **1'. General cocycle law.** Only the diagonal directions need to be
unit; `b` and `d` are arbitrary raw direction triples. -/
theorem bargmann_cocycle_general (a b c d : Vec3)
    (ha : dot a a = 1) (hc : dot c c = 1) :
    (proj a * proj b * proj c).trace * (proj a * proj c * proj d).trace
      = (proj a * proj b * proj c * proj d).trace
          * (proj a * proj c).trace := by
  norm_num [ Matrix.trace, Matrix.mul_apply ];
  unfold proj;
  unfold pauli;
  simp +decide [ sigmaX, sigmaY, sigmaZ ] at *;
  unfold dot at *;
  norm_num [ Complex.ext_iff ] at *;
  grind +locals

/-- **2'. General phase form.** Only the diagonal directions need to be
unit, plus nondegeneracy `-1 < a.c`. -/
theorem bargmann_cocycle_arg_general (a b c d : Vec3)
    (ha : dot a a = 1) (hc : dot c c = 1) (hac : -1 < dot a c) :
    Complex.arg ((proj a * proj b * proj c * proj d).trace)
      = Complex.arg
          ((proj a * proj b * proj c).trace
            * (proj a * proj c * proj d).trace) := by
  convert Complex.arg_real_mul _ _ using 2;
  case convert_2 => exact ( 2 : ℝ ) / ( 1 + dot a c );
  · rw [ bargmann_cocycle_general a b c d ha hc ];
    have h_trace : (proj a * proj c).trace = ((1 + dot a c) / 2 : ℝ) := by
      unfold proj dot pauli;
      norm_num [ Matrix.trace, Matrix.mul_apply, sigmaX, sigmaY, sigmaZ ] ; ring;
      norm_num;
    rw [ h_trace ] ; push_cast ; ring;
    linear_combination -mul_inv_cancel₀ ( show ( 1 + dot a c : ℂ ) ≠ 0 from mod_cast by linarith ) * ( proj a * proj b * proj c * proj d |> Matrix.trace );
  · exact div_pos zero_lt_two ( by linarith )

end PhysicsSM.Draft.NullEdge.BargmannCocycle

/-! ## Build-enforced assumption-footprint guards (added at integration) -/

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannCocycle.bargmann_cocycle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannCocycle.bargmann_cocycle

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannCocycle.bargmann_cocycle_arg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannCocycle.bargmann_cocycle_arg

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannCocycle.bargmann_cocycle_degenerate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannCocycle.bargmann_cocycle_degenerate

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannCocycle.quadrilateral_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannCocycle.quadrilateral_witness

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannCocycle.bargmann_cocycle_general' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannCocycle.bargmann_cocycle_general

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannCocycle.bargmann_cocycle_arg_general' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannCocycle.bargmann_cocycle_arg_general


end
