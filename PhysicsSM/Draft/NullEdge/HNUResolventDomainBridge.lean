import PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent

/-!
# Sharp fibre resolvent estimates: the mass gap is visible in the resolvent bound

Independent-review contribution (Opus) to `CONT-FOURIER-001`, arising from the
review Codex requested in `msg-20260721-014420-9d8db14e`.

**Attribution first, so this module does not claim a gap it did not close.**
Codex asked what the smallest exact theorem was for combining the bounded `L2`
resolvent half with the graph domain. Reviewing the tree to answer that, the
answer turned out to be: *nothing is missing*. `HNUMassiveMaximalMultiplier`
already lands `minusResolventL2_mem_hamiltonian_domain`,
`plusResolventL2_mem_hamiltonian_domain`, both surjectivity statements, and
`massiveHamiltonian_isSelfAdjoint` itself, via the basic criterion (dense
maximal graph domain, formal self-adjointness, and surjectivity of both
imaginary shifts). That proof was checked as part of this review and is sound
and correctly scoped. The domain identities recorded below are therefore **not**
a missing piece; they are the cheaper fibre-level reason for the same fact,
kept because they are reusable and because they make the mechanism transparent:

* `massiveGenerator_mul_minusShiftInverse` - the algebraic identity
  `H * R = 1 + i * R`. `H * R` is bounded simply because it differs from the
  identity by a bounded operator; no analysis is involved.
* `massiveGenerator_minusResolvent_norm_le_two` - the resulting uniform fibre
  bound `norm (H(q) (R(q) v)) <= 2 * norm v`.

**The novel content of this module is the sharp estimate below**, which the
bounded half left on the table.
`HNUMassiveFibreResolvent.minusShiftInverse_norm_le` proves the contraction
bound `norm (R v) <= norm v`, but the coercivity identity it is derived from
(`shifted_minus_norm_sq`) gives the exact value
`resolventDenom * norm (R v) ^ 2 = norm v ^ 2`. Since
`resolventDenom = |q|^2 + normSq z + 1 >= 1 + normSq z`, the sharp uniform bound
is `(1 + normSq z) * norm (R v) ^ 2 <= norm v ^ 2`, which is strictly stronger
than the contraction bound whenever the mass `z` is nonzero. Physically this is
the statement that **the resolvent bound sees the mass gap**: the distance from
the spectral point `i` to the spectrum `+-sqrt(|q|^2 + |z|^2)` is bounded below
by `sqrt(1 + |z|^2)`, not merely by `1`. The contraction bound is the massless
shadow of this estimate.

Scope, stated so the docstring does not outrun the kernel: nothing here defines
an unbounded operator, and nothing here proves self-adjointness - that is landed
separately in `HNUMassiveMaximalMultiplier` and is not reproved or reclaimed
here. These are fibre identities and fibre estimates only. In particular the
mass-gap bound is a statement about the *fibre* resolvent uniform in momentum;
turning it into a spectral-gap statement for the global operator, or into any
claim about a physical mass, requires further steps that are not taken here.

Provenance: clean-room derivation from the landed
`HNUMassiveFibreResolvent.shifted_minus_mul_inverse` /
`shifted_minus_norm_sq` (Codex, Aristotle-assisted), following the standard
resolvent route to self-adjointness of Dirac multiplication operators.
Claim grade `M`, `[comp]`.
-/

noncomputable section

open Matrix Complex
open scoped Matrix.Norms.L2Operator

set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.HNUResolventDomainBridge

open HNUMassiveCompactSupportL2Generator
open HNUMassiveContinuumReduction
open HNUMassiveFibreResolvent
open Pluecker3Plus1ComplexMass

abbrev Momentum3 := HNUMassiveFibreResolvent.Momentum3
abbrev Mat4 := HNUMassiveFibreResolvent.Mat4
abbrev Fibre4 := HNUMassiveFibreResolvent.Fibre4

/-- Abbreviation for the fibre action of a matrix on the Euclidean spinor. -/
abbrev act (M : Mat4) : Fibre4 →L[Complex] Fibre4 :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) M

/-! ## The domain identity -/

/-- **The bridge identity at `+i`.** Multiplying the generator by its own
resolvent differs from the identity by a bounded operator:
`H * R = 1 + i * R`. This is the exact algebraic reason the resolvent maps
`L2` into the maximal domain of the multiplier - no analysis is involved. -/
theorem massiveGenerator_mul_minusShiftInverse (z : Complex) (q : Momentum3) :
    massiveGenerator z q * minusShiftInverse z q =
      1 + (I : Complex) • minusShiftInverse z q := by
  have hsplit : massiveGenerator z q =
      (massiveGenerator z q - (I : Complex) • (1 : Mat4)) +
        (I : Complex) • (1 : Mat4) := by
    abel
  rw [hsplit, add_mul, shifted_minus_mul_inverse, Matrix.smul_mul,
    Matrix.one_mul]

/-- **The bridge identity at `-i`.** -/
theorem massiveGenerator_mul_plusShiftInverse (z : Complex) (q : Momentum3) :
    massiveGenerator z q * plusShiftInverse z q =
      1 - (I : Complex) • plusShiftInverse z q := by
  have hsplit : massiveGenerator z q =
      (massiveGenerator z q + (I : Complex) • (1 : Mat4)) -
        (I : Complex) • (1 : Mat4) := by
    abel
  rw [hsplit, sub_mul, shifted_plus_mul_inverse, Matrix.smul_mul,
    Matrix.one_mul]

/-- **Range of the resolvent lies in the domain of the multiplier**, at `+i`,
with the explicit uniform constant `2`. This is the estimate the maximal-domain
argument consumes: it makes `q |-> H(q) (R(q) (f q))` square-integrable for
every `L2` function `f`, uniformly in momentum and in the mass. -/
theorem massiveGenerator_minusResolvent_norm_le_two (z : Complex)
    (q : Momentum3) (v : Fibre4) :
    ‖act (massiveGenerator z q) (act (minusShiftInverse z q) v)‖ ≤ 2 * ‖v‖ := by
  have hcompose :
      act (massiveGenerator z q) (act (minusShiftInverse z q) v) =
        v + (I : Complex) • act (minusShiftInverse z q) v := by
    rw [← ContinuousLinearMap.mul_apply, ← map_mul,
      massiveGenerator_mul_minusShiftInverse]
    simp
  rw [hcompose]
  have hcontract : ‖act (minusShiftInverse z q) v‖ ≤ ‖v‖ :=
    minusShiftInverse_norm_le z q v
  calc ‖v + (I : Complex) • act (minusShiftInverse z q) v‖
      ≤ ‖v‖ + ‖(I : Complex) • act (minusShiftInverse z q) v‖ :=
        norm_add_le _ _
    _ = ‖v‖ + ‖act (minusShiftInverse z q) v‖ := by
        rw [norm_smul, Complex.norm_I, one_mul]
    _ ≤ ‖v‖ + ‖v‖ := by linarith
    _ = 2 * ‖v‖ := by ring

/-- **Range of the resolvent lies in the domain of the multiplier**, at `-i`. -/
theorem massiveGenerator_plusResolvent_norm_le_two (z : Complex)
    (q : Momentum3) (v : Fibre4) :
    ‖act (massiveGenerator z q) (act (plusShiftInverse z q) v)‖ ≤ 2 * ‖v‖ := by
  have hcompose :
      act (massiveGenerator z q) (act (plusShiftInverse z q) v) =
        v - (I : Complex) • act (plusShiftInverse z q) v := by
    rw [← ContinuousLinearMap.mul_apply, ← map_mul,
      massiveGenerator_mul_plusShiftInverse]
    simp
  rw [hcompose]
  have hcontract : ‖act (plusShiftInverse z q) v‖ ≤ ‖v‖ :=
    plusShiftInverse_norm_le z q v
  calc ‖v - (I : Complex) • act (plusShiftInverse z q) v‖
      ≤ ‖v‖ + ‖(I : Complex) • act (plusShiftInverse z q) v‖ :=
        norm_sub_le _ _
    _ = ‖v‖ + ‖act (plusShiftInverse z q) v‖ := by
        rw [norm_smul, Complex.norm_I, one_mul]
    _ ≤ ‖v‖ + ‖v‖ := by linarith
    _ = 2 * ‖v‖ := by ring

/-! ## The sharp resolvent estimate, and the mass gap it exposes -/

/-- **Exact fibre norm of the resolvent** at `+i`: not an inequality. The
coercivity identity is an equality, so the resolvent norm is determined
exactly by the mass-shell denominator. -/
theorem minusShiftInverse_norm_sq_exact (z : Complex) (q : Momentum3)
    (v : Fibre4) :
    resolventDenom z q * ‖act (minusShiftInverse z q) v‖ ^ 2 = ‖v‖ ^ 2 := by
  have hresolve :
      act (massiveGenerator z q - (I : Complex) • (1 : Mat4))
          (act (minusShiftInverse z q) v) = v := by
    rw [← ContinuousLinearMap.mul_apply, ← map_mul,
      shifted_minus_mul_inverse]
    simp
  have hcoercive :=
    shifted_minus_norm_sq z q (act (minusShiftInverse z q) v)
  rw [hresolve] at hcoercive
  exact hcoercive.symm

/-- **The resolvent bound sees the mass gap.** The uniform bound is governed by
`1 + normSq z`, not by `1`: the spectral point `i` stands off the spectrum
`+-sqrt(|q|^2 + normSq z)` by at least `sqrt (1 + normSq z)`. For nonzero mass
this is strictly stronger than the contraction bound
`HNUMassiveFibreResolvent.minusShiftInverse_norm_le`, which is its massless
shadow. -/
theorem minusShiftInverse_mass_gap_bound (z : Complex) (q : Momentum3)
    (v : Fibre4) :
    (1 + Complex.normSq z) * ‖act (minusShiftInverse z q) v‖ ^ 2 ≤ ‖v‖ ^ 2 := by
  have hexact := minusShiftInverse_norm_sq_exact z q v
  have hdenom : 1 + Complex.normSq z ≤ resolventDenom z q := by
    unfold resolventDenom massShellSq
    nlinarith [sq_nonneg (q 0), sq_nonneg (q 1), sq_nonneg (q 2)]
  nlinarith [sq_nonneg ‖act (minusShiftInverse z q) v‖]

/-- The same sharp estimate at `-i`. -/
theorem plusShiftInverse_norm_sq_exact (z : Complex) (q : Momentum3)
    (v : Fibre4) :
    resolventDenom z q * ‖act (plusShiftInverse z q) v‖ ^ 2 = ‖v‖ ^ 2 := by
  have hresolve :
      act (massiveGenerator z q + (I : Complex) • (1 : Mat4))
          (act (plusShiftInverse z q) v) = v := by
    rw [← ContinuousLinearMap.mul_apply, ← map_mul,
      shifted_plus_mul_inverse]
    simp
  have hcoercive :=
    shifted_plus_norm_sq z q (act (plusShiftInverse z q) v)
  rw [hresolve] at hcoercive
  exact hcoercive.symm

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUResolventDomainBridge.massiveGenerator_mul_minusShiftInverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveGenerator_mul_minusShiftInverse

/-- info: 'PhysicsSM.Draft.NullEdge.HNUResolventDomainBridge.massiveGenerator_minusResolvent_norm_le_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveGenerator_minusResolvent_norm_le_two

/-- info: 'PhysicsSM.Draft.NullEdge.HNUResolventDomainBridge.minusShiftInverse_norm_sq_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms minusShiftInverse_norm_sq_exact

/-- info: 'PhysicsSM.Draft.NullEdge.HNUResolventDomainBridge.minusShiftInverse_mass_gap_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms minusShiftInverse_mass_gap_bound

end PhysicsSM.Draft.NullEdge.HNUResolventDomainBridge
