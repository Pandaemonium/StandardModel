import PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer
import PhysicsSM.Draft.NullEdge.BargmannFanInductionAristotle

/-!
# The kink-area crossover: perimeter cost versus area cost, exactly

Spiral-layer C3 target T3 (crossover quantification), 2026-07-16. This
module makes the "kinks cost magnitude" half of the C3 split
quantitative and locates the exact crossover against the framed area
law:

1. `pair_pow_collapse` - the two-projector semigroup is one-dimensional:
   for a unit second direction, (P(a) P(b))^(k+1) equals
   ((1 + a.b)/2)^k times P(a) P(b). Each repeated bend costs exactly one
   pair factor; nothing else accumulates.
2. `equator_pair_pow` and `kinked_square_trace` - at right angles the
   factor is exactly 1/2, so the k-times-rewalked equatorial square has
   invariant exactly (1/2)^k * (-1/4): the k-kink penalty is exact,
   with the hemisphere Berry sign untouched.
3. `kink_dominance_iff` - the exact crossover: (1/2)^k <= exp(-s*A)
   if and only if s*A <= k * log 2. Below k* = s*A/log 2 the area
   factor dominates; above it the kink (perimeter-type) factor does.
4. `kinked_framed_rectangle_area_law` - composition with the landed
   sharp framed bound: the k-kinked framing scalar gives
   norm <= (1/2)^k * (1/4) * exp(-s_R * A) at the unchanged string
   tension.

Claim boundary: finite exact identities and one real-analysis
equivalence; the "perimeter versus area" reading is the displayed
arithmetic of the two exponents, not a lattice-QCD claim. The
character-expansion factorization remains the displayed hypothesis of
the landed interface.

Provenance: program-internal composition of the wave-5 rank-one
collapse (`BargmannFanInduction.proj_collapse`), the landed framed
transfer layer, and Mathlib real analysis. Corner conventions are the
wave-5 module's.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GateYM.KinkAreaCrossover

open StrongCouplingAreaLaw
open FramedAreaLawTransfer
open PhysicsSM.Draft.NullEdge.BargmannFanInduction

variable {G : Type} [Group G] [Fintype G] {n : ℕ}

/-- **The two-projector semigroup is one-dimensional.** For a unit
second direction, powers of the ordered pair product collapse to pair
factors times the product itself: each repeated bend costs exactly one
factor `(1 + a.b)/2`. -/
theorem pair_pow_collapse (a b : Vec3) (hb : dot b b = 1) :
    ∀ k : ℕ, (proj a * proj b) ^ (k + 1)
      = ((((1 + dot a b) / 2 : ℝ)) : ℂ) ^ k • (proj a * proj b) := by
  intro k
  induction k with
  | zero => simp
  | succ m ih =>
    have hstep : (proj a * proj b) * (proj a * proj b)
        = ((((1 + dot a b) / 2 : ℝ)) : ℂ) • (proj a * proj b) := by
      have hsandwich := proj_collapse b hb (proj a)
      have htrace : (proj b * proj a).trace
          = (((1 + dot b a : ℝ)) : ℂ) / 2 := pair_trace b a
      calc (proj a * proj b) * (proj a * proj b)
          = proj a * (proj b * proj a * proj b) := by
            noncomm_ring
        _ = proj a * ((proj b * proj a).trace • proj b) := by
            rw [hsandwich]
        _ = (proj b * proj a).trace • (proj a * proj b) := by
            rw [mul_smul_comm]
        _ = ((((1 + dot a b) / 2 : ℝ)) : ℂ) • (proj a * proj b) := by
            rw [htrace]
            have hcomm : dot b a = dot a b := by unfold dot; ring
            rw [hcomm]
            norm_num
    calc (proj a * proj b) ^ (m + 1 + 1)
        = (proj a * proj b) ^ (m + 1) * (proj a * proj b) := pow_succ _ _
      _ = (((((1 + dot a b) / 2 : ℝ)) : ℂ) ^ m • (proj a * proj b))
            * (proj a * proj b) := by rw [ih]
      _ = ((((1 + dot a b) / 2 : ℝ)) : ℂ) ^ m
            • ((proj a * proj b) * (proj a * proj b)) := by
            rw [smul_mul_assoc]
      _ = ((((1 + dot a b) / 2 : ℝ)) : ℂ) ^ m
            • (((((1 + dot a b) / 2 : ℝ)) : ℂ) • (proj a * proj b)) := by
            rw [hstep]
      _ = ((((1 + dot a b) / 2 : ℝ)) : ℂ) ^ (m + 1)
            • (proj a * proj b) := by
            rw [smul_smul, ← pow_succ]

/-- Westward equatorial direction in the wave-5 conventions. -/
def exmW : Vec3 := ![-1, 0, 0]

/-- Southward equatorial direction in the wave-5 conventions. -/
def eymW : Vec3 := ![0, -1, 0]

/-- At right angles the pair factor is exactly one half. -/
theorem equator_pair_pow (k : ℕ) :
    (proj ex * proj ey) ^ (k + 1)
      = ((1 / 2 : ℝ) : ℂ) ^ k • (proj ex * proj ey) := by
  have hy : dot ey ey = 1 := by
    norm_num [dot, ey, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.vecHead, Matrix.vecTail]
  have hxy : dot ex ey = 0 := by
    norm_num [dot, ex, ey, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.vecHead, Matrix.vecTail]
  have h := pair_pow_collapse ex ey hy k
  rw [hxy] at h
  norm_num at h ⊢
  exact h

/-- The equatorial square in the wave-5 conventions has invariant
exactly -(1/4) (the hemisphere Berry sign; matches the wave-7 value and
the transfer-layer restatement). -/
theorem equator_square_trace_w5 :
    (proj ex * proj ey * proj exmW * proj eymW).trace = -(1 / 4) := by
  unfold proj pauli
  norm_num [ex, ey, exmW, eymW, sigmaX, sigmaY, sigmaZ,
    Matrix.trace_fin_two, Matrix.mul_apply, Fin.sum_univ_succ,
    Matrix.one_apply, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.vecHead, Matrix.vecTail,
    Fin.succ_zero_eq_one, Complex.ext_iff]

/-- **Exact k-kink penalty.** Rewalking the first edge of the
equatorial square `k` extra times multiplies the invariant by exactly
`(1/2)^k`, leaving the hemisphere sign untouched: kinks cost pure
magnitude, at one corner factor per kink. -/
theorem kinked_square_trace (k : ℕ) :
    ((proj ex * proj ey) ^ (k + 1) * proj exmW * proj eymW).trace
      = ((1 / 2 : ℝ) : ℂ) ^ k * (-(1 / 4)) := by
  rw [equator_pair_pow k, smul_mul_assoc, smul_mul_assoc,
    Matrix.trace_smul, equator_square_trace_w5, smul_eq_mul]

/-- **The exact perimeter-versus-area crossover.** The k-kink penalty
beats the area factor exactly when `s * A <= k * log 2`: the crossover
kink count is `s * A / log 2`. -/
theorem kink_dominance_iff (s A : ℝ) (k : ℕ) :
    ((1 : ℝ) / 2) ^ k ≤ Real.exp (-(s * A)) ↔ s * A ≤ k * Real.log 2 := by
  have hpow : ((1 : ℝ) / 2) ^ k = Real.exp (-(k * Real.log 2)) := by
    have hhalf : ((1 : ℝ) / 2) = Real.exp (-Real.log 2) := by
      rw [Real.exp_neg, Real.exp_log two_pos]
      norm_num
    rw [hhalf, ← Real.exp_nat_mul]
    congr 1
    ring
  rw [hpow, Real.exp_le_exp, neg_le_neg_iff]

/-- **k-kinked framed rectangle area law.** The k-kinked equatorial
framing scalar composes with the landed sharp framed bound: the framed
Wilson value obeys `norm <= (1/2)^k * (1/4) * exp(-s_R * A)` at the
unchanged string tension. Combined with `kink_dominance_iff`, beyond
`k* = s_R * A / log 2` the kink cost alone exceeds the area cost. -/
theorem kinked_framed_rectangle_area_law (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hne : gammaR beta rho R ≠ 0) (A : ℕ) (wloop : ℂ)
    (hfact : ‖wloop‖ ≤ ‖gammaR beta rho R‖ ^ A) (k : ℕ) :
    ‖(((1 / 2 : ℝ) : ℂ) ^ k * (-(1 / 4))) * wloop‖
      ≤ (1 / 2) ^ k * (1 / 4)
          * Real.exp (-(sigmaR beta rho R) * A) := by
  have hsharp := framed_wilson_area_law_sharp beta rho R hne A wloop
    (((1 / 2 : ℝ) : ℂ) ^ k * (-(1 / 4))) hfact
  have hnorm : ‖((1 / 2 : ℝ) : ℂ) ^ k * (-(1 / 4 : ℂ))‖
      = (1 / 2 : ℝ) ^ k * (1 / 4) := by
    rw [norm_mul, norm_pow]
    norm_num
  calc ‖(((1 / 2 : ℝ) : ℂ) ^ k * (-(1 / 4))) * wloop‖
      ≤ ‖((1 / 2 : ℝ) : ℂ) ^ k * (-(1 / 4 : ℂ))‖
          * Real.exp (-(sigmaR beta rho R) * A) := hsharp
    _ = (1 / 2) ^ k * (1 / 4)
          * Real.exp (-(sigmaR beta rho R) * A) := by rw [hnorm]

end PhysicsSM.Draft.NullEdge.GateYM.KinkAreaCrossover

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.KinkAreaCrossover.pair_pow_collapse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.KinkAreaCrossover.pair_pow_collapse

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.KinkAreaCrossover.kinked_square_trace' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.KinkAreaCrossover.kinked_square_trace

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.KinkAreaCrossover.kink_dominance_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.KinkAreaCrossover.kink_dominance_iff

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.KinkAreaCrossover.kinked_framed_rectangle_area_law' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.KinkAreaCrossover.kinked_framed_rectangle_area_law
