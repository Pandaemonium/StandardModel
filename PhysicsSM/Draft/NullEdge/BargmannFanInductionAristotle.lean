import Mathlib

/-!
# Fan induction for Bargmann polygon phases

Integrated 2026-07-16 from Aristotle project 6a413e71-997c-43ad-abe2-214dd37faa58 (run wave5); statements verbatim from the submitted package; namespace renamed for the draft tree; axiom guards added at integration.

Standalone Aristotle package (Mathlib-only imports). Spiral-layer wave 5,
2026-07-16. Successor to the landed wave-4 cocycle package
(project 74a06ae4): this file packages the diagonal-fan induction that
turns the pairwise cocycle law into the full polygon factorization, which
is the C1-POLYGON statement of the spiral-layer conjecture ledger.

## What this file states

For spin-coherent corner matrices P(v) = (1 + v.sigma)/2 over raw real
direction triples:

1. `pair_trace` - tr(P(a)P(b)) = (1 + a.b)/2 (polynomial; no unit
   hypotheses).
2. `proj_collapse` - the rank-one sandwich: for unit v and ANY 2x2
   complex matrix M, P(v) * M * P(v) = tr(P(v) * M) * P(v). This is the
   engine of the whole file.
3. `bargmann_cocycle_matrix` - the cocycle law with ARBITRARY matrix
   slots: for unit a, c and any matrices X, Y,
   tr(P(a) X P(c)) * tr(P(a) P(c) Y)
     = tr(P(a) X P(c) Y) * tr(P(a) P(c)).
   The landed wave-4 law is the special case X = P(b), Y = P(d); the
   matrix form is what the induction below consumes (the X slot holds a
   product of corner matrices, not a single corner).
4. `fan_factorization` - the polygon law, equation form. For a unit apex
   v0 and a list l of unit directions with 2 <= l.length,
   tr(P(v0) * cornerProd l) * PROD_{w in l.tail.dropLast} tr(P(v0)P(w))
     = PROD_{(u,w) in l.zip l.tail} tr(P(v0)P(u)P(w)).
   The left product runs over the interior fan diagonals, the right over
   the fan triangles. No nondegeneracy is needed: the equation holds
   even when both sides vanish.
5. `fan_arg` - the phase corollary: if additionally every interior
   diagonal satisfies -1 < v0.w, the polygon phase equals the phase of
   the product of the fan-triangle invariants (the diagonal traces are
   then strictly positive reals and drop out of the argument).
6. `pentagon_witness` - exact nonvacuity anchor: for the nonplanar
   pentagon with apex e_z and rim (e_x, (3/5,0,4/5), (0,3/5,4/5), e_y),
   the full five-corner trace is exactly (9 + i)/25. Hand-computed via
   the factorization: triangle values 3/5, (81+9i)/100, 3/5 and diagonal
   traces 9/10, 9/10.

## Conventions

Directions are raw `Fin 3 -> Real` triples with no normalization built
in; Pauli matrices standard; `dot` is the Euclidean dot product;
`cornerProd` multiplies corner matrices left-to-right along the list.
Same conventions as the wave-1/2/3/4 companions
(SpinCornerBargmann, SpinCornerFourCycle, BargmannSolidAngle,
BargmannCocycle).

## Proof guidance

`pair_trace` is entrywise (trace_fin_two, mul_apply, then ring).
`proj_collapse` is entrywise in the four complex entries of M and the
three real components of v, using dot v v = 1; ext/fin_cases/simp with
Matrix.mul_apply then Complex.ext_iff/ring/linear_combination should
close it (each entry identity is linear in M's entries, quadratic in v).
`bargmann_cocycle_matrix` follows structurally from `proj_collapse`:
first fuse at a (tr(P M) * tr(P N) = tr(P M P N) via the collapse), then
collapse P(c) P(a) P(c)... alternatively fuse at a with M = X * proj c,
N = proj c * Y, then rewrite the inner proj c * (stuff) * proj c by
collapse at c; a direct entrywise assault is possible but heavy - the
structured route is intended. `fan_factorization` is induction on l from
the right (l = l' ++ [z]): List.prod_append, the identity
cornerProd l' = cornerProd l'.dropLast * proj (l'.getLast h) for
nonempty l', and one application of `bargmann_cocycle_matrix` with
X = cornerProd l'.dropLast, c = l'.getLast, Y = proj z; the base case
l = [u, w] is definitional (empty diagonal product). Mind the list
bookkeeping: (l' ++ [z]).tail.dropLast = l'.tail when l' is nonempty,
and (l' ++ [z]).zip (l' ++ [z]).tail = (l'.zip l'.tail) ++
[(l'.getLast h, z)]. `fan_arg` divides the factorization by the
positive real diagonal product: each diagonal trace is
((1 + dot v0 w)/2 : Real) > 0 by `pair_trace` and -1 < dot v0 w, so the
product is a positive real and Complex.arg_real_mul-shaped lemmas give
the phase equality. `pentagon_witness` is finite rational arithmetic
(norm_num with Complex.ext_iff after unfolding; simp +decide is
acceptable in this draft-layer package).

Helper lemmas welcome; the six numbered statements must stay verbatim.
Do not weaken or modify any statement or definition; the placeholder
proofs are the only intended gaps.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.BargmannFanInduction

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

/-- Corner-matrix product along a list of directions, left to right. -/
def cornerProd (l : List Vec3) : SpinMat := (l.map proj).prod

/-- **1. Pair trace.** Polynomial in the components; no unit hypotheses. -/
theorem pair_trace (a b : Vec3) :
    (proj a * proj b).trace = (((1 + dot a b : ℝ)) : ℂ) / 2 := by
  unfold proj
  norm_num [Matrix.trace_fin_two, Matrix.mul_apply, pauli]
  unfold sigmaX sigmaY sigmaZ dot
  norm_num
  ring
  norm_num

/-- **2. Rank-one collapse.** For a unit direction the corner matrix is a
rank-one projector, so sandwiching ANY matrix collapses to a scalar times
the projector. This is the engine of the cocycle and the fan induction. -/
theorem proj_collapse (v : Vec3) (hv : dot v v = 1) (M : SpinMat) :
    proj v * M * proj v = (proj v * M).trace • proj v := by
  ext i j; simp +decide [ *, Matrix.mul_apply, Matrix.trace_fin_two ] ; ring;
  unfold proj;
  fin_cases i <;> fin_cases j <;> simp +decide [ pauli, sigmaX, sigmaY, sigmaZ ] <;> ring;
  · norm_num [ Complex.ext_iff, sq ] at *;
    unfold dot at hv; constructor <;> rw [ show v 0 * v 0 = 1 - v 1 * v 1 - v 2 * v 2 by linarith ] <;> ring;
  · unfold dot at hv; norm_num [ Complex.ext_iff, sq ] at hv ⊢; ring_nf at hv ⊢;
    grind;
  · unfold dot at hv; norm_num [ Complex.ext_iff, sq ] at *; ring_nf at *;
    grind;
  · norm_num [ Complex.ext_iff, sq ] ; ring;
    unfold dot at hv; constructor <;> rw [ show v 0 ^ 2 = 1 - v 1 ^ 2 - v 2 ^ 2 by linarith ] <;> ring;

/-- **3. Matrix-slot cocycle law.** Only the diagonal directions carry
unit hypotheses; the slots X and Y are arbitrary 2x2 complex matrices.
The landed wave-4 law is the special case X = P(b), Y = P(d). -/
theorem bargmann_cocycle_matrix (a c : Vec3) (X Y : SpinMat)
    (ha : dot a a = 1) (hc : dot c c = 1) :
    (proj a * X * proj c).trace * (proj a * proj c * Y).trace
      = (proj a * X * proj c * Y).trace * (proj a * proj c).trace := by
  have h_cocycle_a_c.straightforward : (proj a * X * (proj c)).trace * (proj a * proj c * Y).trace = (proj a * X * proj c * proj a * proj c * Y).trace := by
    have := proj_collapse a ha ( X * proj c ) ; simp_all +decide [ Matrix.mul_assoc ] ;
  rw [ h_cocycle_a_c.straightforward ];
  rw [ ← Matrix.trace_mul_comm ] ; simp +decide [ Matrix.mul_assoc ] ;
  rw [ ← Matrix.trace_mul_comm ] ; simp +decide [ Matrix.mul_assoc ] ;
  simp_all +decide [ ← mul_assoc, BargmannFanInduction.proj_collapse ];
  rw [ ← Matrix.trace_mul_comm ] ; simp +decide [ Matrix.mul_assoc ] ;
  ring

/-- **4. Fan factorization (equation form).** The polygon invariant times
the product of interior fan-diagonal pair traces equals the product of
the fan-triangle invariants. Holds without nondegeneracy hypotheses:
both sides may vanish together. -/
theorem fan_factorization (v0 : Vec3) (l : List Vec3)
    (h0 : dot v0 v0 = 1) (hl : ∀ v ∈ l, dot v v = 1)
    (hlen : 2 ≤ l.length) :
    (proj v0 * cornerProd l).trace
        * (l.tail.dropLast.map (fun w => (proj v0 * proj w).trace)).prod
      = ((l.zip l.tail).map
          (fun p => (proj v0 * proj p.1 * proj p.2).trace)).prod := by
  induction' n : l.length using Nat.strong_induction_on with n ih generalizing l v0;
  rcases l with ( _ | ⟨ v, _ | ⟨ w, l ⟩ ⟩ ) <;> simp_all +decide [ cornerProd ];
  · linarith;
  · rcases l with ( _ | ⟨ x, l ⟩ ) <;> simp_all +decide [ List.dropLast ];
    · rw [ Matrix.mul_assoc ];
    · specialize ih ( l.length + 2 ) ( by linarith ) v0 ( w :: x :: l ) ; simp_all +decide [ List.zip ];
      have := bargmann_cocycle_matrix v0 w ( proj v ) ( List.prod ( List.map proj l ) |> fun m => proj x * m ) h0 hl.2.1; simp_all +decide [ ← mul_assoc, List.zipWith ] ;
      grobner

/-- **5. Fan phase law.** With nondegenerate interior diagonals the
polygon phase is the phase of the product of fan-triangle invariants:
the diagonal pair traces are strictly positive reals and cancel from the
argument. This is the C1-POLYGON packaging. -/
theorem fan_arg (v0 : Vec3) (l : List Vec3)
    (h0 : dot v0 v0 = 1) (hl : ∀ v ∈ l, dot v v = 1)
    (hlen : 2 ≤ l.length)
    (hdiag : ∀ w ∈ l.tail.dropLast, -1 < dot v0 w) :
    Complex.arg ((proj v0 * cornerProd l).trace)
      = Complex.arg (((l.zip l.tail).map
          (fun p => (proj v0 * proj p.1 * proj p.2).trace)).prod) := by
  obtain ⟨r, hr_pos, hr_eq⟩ : ∃ r : ℝ, 0 < r ∧ (l.tail.dropLast.map (fun w => (proj v0 * proj w).trace)).prod = r := by
    use (l.tail.dropLast.map (fun w => (1 + dot v0 w) / 2)).prod;
    constructor;
    · exact List.prod_pos ( by intros x hx; rcases List.mem_map.mp hx with ⟨ w, hw, rfl ⟩ ; linarith [ hdiag w hw ] );
    · induction l.tail.dropLast <;> simp_all +decide [ List.prod_cons ];
      exact Or.inl ( by rw [ pair_trace ] ; norm_num );
  convert Complex.arg_mul_real hr_pos _ |> Eq.symm using 1;
  rw [ ← hr_eq, ← fan_factorization v0 l h0 hl hlen ]

/-- Unit x direction. -/
def ex : Vec3 := ![1, 0, 0]

/-- Unit y direction. -/
def ey : Vec3 := ![0, 1, 0]

/-- Unit z direction. -/
def ez : Vec3 := ![0, 0, 1]

/-- Pythagorean unit direction (3/5, 0, 4/5). -/
def exz : Vec3 := ![3 / 5, 0, 4 / 5]

/-- Pythagorean unit direction (0, 3/5, 4/5). -/
def eyz : Vec3 := ![0, 3 / 5, 4 / 5]

/-- **6. Pentagon witness.** The nonplanar pentagon with apex e_z and rim
(e_x, (3/5,0,4/5), (0,3/5,4/5), e_y) has five-corner invariant exactly
(9 + i)/25: nonreal, so the fan phase law is nonvacuous at five corners.
Fan data: triangles 3/5, (81 + 9i)/100, 3/5; diagonals 9/10, 9/10. -/
theorem pentagon_witness :
    (proj ez * cornerProd [ex, exz, eyz, ey]).trace
      = (9 + Complex.I) / 25 := by
  norm_num [ Matrix.trace, Matrix.mul_apply, cornerProd, proj, pauli, sigmaX, sigmaY, sigmaZ, ez, ex, exz, eyz, ey ];
  simp +zetaDelta at *;
  ring_nf; norm_num [ Complex.ext_iff ] ;

end PhysicsSM.Draft.NullEdge.BargmannFanInduction

/-! ## Build-enforced assumption-footprint guards (added at integration) -/

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannFanInduction.pair_trace' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannFanInduction.pair_trace

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannFanInduction.proj_collapse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannFanInduction.proj_collapse

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannFanInduction.bargmann_cocycle_matrix' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannFanInduction.bargmann_cocycle_matrix

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannFanInduction.fan_factorization' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannFanInduction.fan_factorization

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannFanInduction.fan_arg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannFanInduction.fan_arg

/-- info: 'PhysicsSM.Draft.NullEdge.BargmannFanInduction.pentagon_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BargmannFanInduction.pentagon_witness


end
