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

/-!
# The finite spectral-action avatar: one functional yields BOTH gravity and matter

This file builds an explicit, fully rational **finite avatar** of the Connes–Chamseddine
spectral action.  In the real theory the *single* functional `Tr f(D/Λ)` of a Dirac
operator, expanded via the heat kernel, produces at successive orders a cosmological term,
the Einstein–Hilbert **gravity** term, and the Yang–Mills/Higgs **matter** terms.

Here everything is finite: `D` is an explicit rational `6 × 6` matrix
`D = Dkin + Dsold + Dmatter`, a sum of a kinetic/carrier part, a **soldering (gravity)** part
`Dsold` built from the `E`-slot (soldering) generator, and a **matter** part `Dmatter` built
from the aperture/closure/turn channel generators.  With the polynomial cutoff
`f(x) = a0 + a2 x + a4 x²` the finite spectral action is

  `S(D) = a0 · tr(1) + a2 · tr(D²) + a4 · tr(D⁴)`.

The payload theorems compute `tr 1`, `tr D²`, `tr D⁴` in closed form and show:

* the order-2 term `tr D² = 6 + 2 E²` is the **gravity (soldering) sector**: it depends only
  on the soldering datum `E` and is completely independent of the matter couplings;
* the order-4 term `tr D⁴ = 6 + 12 E² + 2 E⁴ + 4·a·c·t` carries the **matter channel
  couplings** `(a, c, t) = (aperture, closure, turn)` as the explicit multilinear channel
  form `4·a·c·t`, which is *absent* at order 2.

So the two sectors are genuinely separated **by order**, and the single functional `S`
yields both.

**Honest scope.**  This is a finite, polynomial-cutoff *avatar* of the spectral action, i.e.
a genuine identity about traces of powers of one explicit rational Dirac matrix.  It is **not**
the heat-kernel asymptotic expansion of a real (infinite-dimensional) spectral triple, and the
matter form here is the multilinear `4·a·c·t` (a finite stand-in for the Yang–Mills/Higgs
quartic), not a curvature invariant.
-/

namespace SpectralActionAvatar

open Matrix

/-- **Kinetic / carrier part** of the finite Dirac operator: the identity (the volume /
cosmological block) together with a single "carrier" hop `5 → 2` that closes the matter
channel into a `4`-cycle so that the channel couplings first appear at order `4`. -/
def Dkin : Matrix (Fin 6) (Fin 6) ℚ :=
  !![1, 0, 0, 0, 0, 0;
     0, 1, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 1, 0;
     0, 0, 1, 0, 0, 1]

/-- **Soldering (gravity) part**: the symmetric `E`-slot generator on the geometry block
`{0,1}`.  This is the finite analogue of the soldering form that produces the
Einstein–Hilbert / cosmological (order-2) sector. -/
def Dsold (E : ℚ) : Matrix (Fin 6) (Fin 6) ℚ :=
  !![0, E, 0, 0, 0, 0;
     E, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0]

/-- **Matter part**: the aperture (`a`), closure (`c`) and turn (`t`) channel generators
placed as the three forward hops `2 → 3 → 4 → 5` of the matter block `{2,3,4,5}`.  Together
with the carrier hop `5 → 2` from `Dkin` they form a `4`-cycle, so the channel couplings
enter the spectral action first at order `4`. -/
def Dmatter (a c t : ℚ) : Matrix (Fin 6) (Fin 6) ℚ :=
  !![0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, a, 0, 0;
     0, 0, 0, 0, c, 0;
     0, 0, 0, 0, 0, t;
     0, 0, 0, 0, 0, 0]

/-- The finite carrier **Dirac operator** `D = Dkin + Dsold + Dmatter`. -/
def D (E a c t : ℚ) : Matrix (Fin 6) (Fin 6) ℚ := Dkin + Dsold E + Dmatter a c t

/-- The three pieces `Dsold` and `Dmatter` are non-degenerate: both nonzero and distinct,
so the geometry and matter data are genuinely present and genuinely different. -/
theorem parts_nondegenerate :
    Dsold 1 ≠ 0 ∧ Dmatter 1 1 1 ≠ 0 ∧ Dsold 1 ≠ Dmatter 1 1 1 := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    have := congrFun (congrFun h 0) 1
    simp [Dsold] at this
  · intro h
    have := congrFun (congrFun h 2) 3
    simp [Dmatter] at this
  · intro h
    have := congrFun (congrFun h 0) 1
    simp [Dsold, Dmatter] at this

/-- Explicit combined form of the finite Dirac operator. -/
theorem D_explicit (E a c t : ℚ) :
    D E a c t =
      !![1, E, 0, 0, 0, 0;
         E, 1, 0, 0, 0, 0;
         0, 0, 1, a, 0, 0;
         0, 0, 0, 1, c, 0;
         0, 0, 0, 0, 1, t;
         0, 0, 1, 0, 0, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [D, Dkin, Dsold, Dmatter]

/-- The finite **spectral action** with polynomial cutoff `f(x) = a0 + a2·x + a4·x²`:
`S(D) = a0·tr 1 + a2·tr D² + a4·tr D⁴`. -/
def S (a0 a2 a4 E a c t : ℚ) : ℚ :=
  a0 * (1 : Matrix (Fin 6) (Fin 6) ℚ).trace
    + a2 * (D E a c t ^ 2).trace
    + a4 * (D E a c t ^ 4).trace

/-! ## Closed-form traces -/

/-- Order-0: `tr 1 = 6` (the volume / cosmological constant term). -/
theorem trace_one : (1 : Matrix (Fin 6) (Fin 6) ℚ).trace = 6 := by
  simp [Matrix.trace, Matrix.diag]

/-- Order-2 trace, in closed form. -/
theorem trace_D_sq (E a c t : ℚ) : (D E a c t ^ 2).trace = 6 + 2 * E ^ 2 := by
  rw [D_explicit]
  simp [pow_two, Matrix.trace, Matrix.diag, Matrix.mul_apply, Fin.sum_univ_six]
  ring

/-- Order-4 trace, in closed form. -/
theorem trace_D_four (E a c t : ℚ) :
    (D E a c t ^ 4).trace = 6 + 12 * E ^ 2 + 2 * E ^ 4 + 4 * a * c * t := by
  have h4 : (D E a c t) ^ 4 = D E a c t * D E a c t * D E a c t * D E a c t := by
    rw [pow_succ, pow_succ, pow_succ, pow_one]
  rw [h4, D_explicit]
  simp [Matrix.trace, Matrix.diag, Matrix.mul_apply, Fin.sum_univ_six]
  ring

/-! ## Target 1 — the spectral-action expansion -/

/-- **`spectral_action_expansion`.**  Closed form of `S(D)` as an explicit rational
polynomial in the cutoff coefficients `(a0, a2, a4)`, the soldering datum `E`, and the matter
couplings `(a, c, t)`:

`S = 6·a0 + a2·(6 + 2E²) + a4·(6 + 12E² + 2E⁴ + 4·a·c·t)`.

The three orders are, respectively, the cosmological (`a0`), gravity/soldering (`a2`) and
matter (`a4`) sectors. -/
theorem spectral_action_expansion (a0 a2 a4 E a c t : ℚ) :
    S a0 a2 a4 E a c t =
      a0 * 6 + a2 * (6 + 2 * E ^ 2) + a4 * (6 + 12 * E ^ 2 + 2 * E ^ 4 + 4 * a * c * t) := by
  rw [S, trace_one, trace_D_sq, trace_D_four]

/-! ## Target 2 — the gravity (soldering, order 2) sector -/

/-- **`gravity_term_isolated`.**  The order-2 term `tr D² = 6 + 2E²` is the GRAVITY sector:
a volume constant `6` plus the gravity coefficient `2` times `E²`.  It depends *only* on the
soldering datum `E`: switching the matter couplings off (or to anything else) does not change
it. -/
theorem gravity_term_isolated (E a c t : ℚ) :
    (D E a c t ^ 2).trace = 6 + 2 * E ^ 2 ∧
      (D E a c t ^ 2).trace = (D E 0 0 0 ^ 2).trace := by
  refine ⟨trace_D_sq E a c t, ?_⟩
  rw [trace_D_sq, trace_D_sq]

/-! ## Target 3 — the matter (channel, order 4) sector -/

/-- **`matter_term_isolated`.**  The matter channel couplings `(a, c, t)` enter the order-4
term as the explicit multilinear channel form `4·a·c·t` (the finite Yang–Mills/Higgs-analog
sector), and they are entirely **absent at order 2**.  Concretely, the matter contribution
(value with the couplings minus value with them switched off) is `4·a·c·t` at order 4 and `0`
at order 2 — so the two sectors are genuinely separated by order. -/
theorem matter_term_isolated (E a c t : ℚ) :
    (D E a c t ^ 4).trace - (D E 0 0 0 ^ 4).trace = 4 * a * c * t ∧
      (D E a c t ^ 2).trace - (D E 0 0 0 ^ 2).trace = 0 := by
  constructor
  · rw [trace_D_four, trace_D_four]; ring
  · rw [trace_D_sq, trace_D_sq]; ring

/-! ## Target 4 — one functional, both forces -/

/-- **`one_functional_verdict`.**  Packaging, instantiated at the explicit rational data
`(a0, a2, a4) = (1, 1, 1)`, soldering `E = 2` and matter couplings `(a, c, t) = (1, 3, 5)`:

* the single functional evaluates to `S = 166`;
* the GRAVITY (order-2, soldering) contribution is the specific nonzero rational `8`;
* the MATTER (order-4, channel) contribution is the specific nonzero rational `60`;
* varying the **soldering** changes the gravity (order-2) sector
  (`tr D²` at `E = 3` ≠ at `E = 2`);
* varying the **matter** couplings leaves the gravity (order-2) sector *unchanged*
  (the two sectors are not proportional: matter does not feed the order-2 term);
* yet varying the **matter** couplings *does* change the matter (order-4) sector.

Hence one finite functional `S(D)` yields BOTH a gravity term (order 2, from soldering) and a
matter term (order 4, from the channels), and the two respond to disjoint data. -/
theorem one_functional_verdict :
    S 1 1 1 2 1 3 5 = 166 ∧
      ((D 2 1 3 5 ^ 2).trace - 6 = 8 ∧ (8 : ℚ) ≠ 0) ∧
      ((D 2 1 3 5 ^ 4).trace - (D 2 0 0 0 ^ 4).trace = 60 ∧ (60 : ℚ) ≠ 0) ∧
      (D 3 1 3 5 ^ 2).trace ≠ (D 2 1 3 5 ^ 2).trace ∧
      (D 2 7 8 9 ^ 2).trace = (D 2 1 3 5 ^ 2).trace ∧
      (D 2 1 3 6 ^ 4).trace ≠ (D 2 1 3 5 ^ 4).trace := by
  refine ⟨?_, ⟨?_, by norm_num⟩, ⟨?_, by norm_num⟩, ?_, ?_, ?_⟩
  · rw [spectral_action_expansion]; norm_num
  · rw [trace_D_sq]; norm_num
  · rw [trace_D_four, trace_D_four]; norm_num
  · rw [trace_D_sq, trace_D_sq]; norm_num
  · rw [trace_D_sq, trace_D_sq]
  · rw [trace_D_four, trace_D_four]; norm_num

/-! ## Axiom footprint of every headline theorem -/

/-- info: 'SpectralActionAvatar.parts_nondegenerate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parts_nondegenerate

/-- info: 'SpectralActionAvatar.spectral_action_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spectral_action_expansion

/-- info: 'SpectralActionAvatar.gravity_term_isolated' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gravity_term_isolated

/-- info: 'SpectralActionAvatar.matter_term_isolated' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms matter_term_isolated

/-- info: 'SpectralActionAvatar.one_functional_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms one_functional_verdict

end SpectralActionAvatar
