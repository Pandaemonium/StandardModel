import Mathlib

/-!
# Metric pairing from a scalar causal operator

This module isolates the algebraic core of an operator-first metric
reconstruction. For a scalar operator `L`, the corrected carre du champ

`(1 / 2) * (L (f * h) - f * L h - h * L f + f * h * L 1)`

is symmetric, annihilates constants, and is unchanged when `L` is shifted by
an arbitrary scalar multiplication operator `u |-> V * u`. If the differential
part obeys the second-order product rule with metric pairing `g`, the corrected
expression is exactly `g`.

The last `f * h * L 1` term is essential when the continuum operator has the
form `Box + V`; in the causal-set application one expects `V = -R / 2` for the
standard curved-spacetime limit. This file proves the exact algebraic identity
and transports it through four supplied operator limits on `1`, `f`, `h`, and
`f * h`. It does not construct a causal-set wave operator, select probe
functions, recover dimension or signature, or prove those probabilistic
continuum limits. Claim grade: `M [comp]`.

Provenance: the product-rule calculation is standard for the principal symbol
of a second-order scalar differential operator. The explicit zeroth-order
correction is recorded here as the proposed null-edge reconstruction interface.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CausalOperatorMetric

open Filter

variable {A : Type*} [Field A] [CharZero A]

/-- Corrected metric-pairing candidate associated with a scalar operator. -/
def correctedCarreDuChamp (L : A -> A) (f h : A) : A :=
  (2 : A)⁻¹ *
    (L (f * h) - f * L h - h * L f + f * h * L 1)

/-- Addition of a scalar zeroth-order potential to an operator. -/
def addScalarPotential (L : A -> A) (V : A) : A -> A :=
  fun u => L u + V * u

/-- The corrected pairing is symmetric even before imposing a product rule. -/
theorem correctedCarreDuChamp_comm
    (L : A -> A) (f h : A) :
    correctedCarreDuChamp L f h = correctedCarreDuChamp L h f := by
  unfold correctedCarreDuChamp
  ring_nf

/-- The corrected pairing annihilates the constant function represented by
the multiplicative identity. -/
@[simp] theorem correctedCarreDuChamp_one_left
    (L : A -> A) (h : A) :
    correctedCarreDuChamp L 1 h = 0 := by
  unfold correctedCarreDuChamp
  ring_nf

/-- The corrected pairing is independent of every scalar zeroth-order
potential, without requiring a normalization condition on `L 1`. -/
theorem correctedCarreDuChamp_addScalarPotential
    (L : A -> A) (V f h : A) :
    correctedCarreDuChamp (addScalarPotential L V) f h =
      correctedCarreDuChamp L f h := by
  unfold correctedCarreDuChamp addScalarPotential
  ring_nf

/-- A normalized second-order product rule identifies the corrected pairing
with its supplied principal-symbol bilinear value. -/
theorem correctedCarreDuChamp_eq_metricPair
    (box : A -> A) (metricPair f h : A)
    (hOne : box 1 = 0)
    (hProduct :
      box (f * h) = f * box h + h * box f + 2 * metricPair) :
    correctedCarreDuChamp box f h = metricPair := by
  unfold correctedCarreDuChamp
  rw [hProduct, hOne]
  ring_nf

/-- **Potential-canceling principal-symbol identity.** For
`L u = box u + V * u`, the scalar potential cancels and the corrected pairing
is exactly the metric value supplied by the second-order product rule. -/
theorem correctedCarreDuChamp_box_add_potential
    (box : A -> A) (V metricPair f h : A)
    (hOne : box 1 = 0)
    (hProduct :
      box (f * h) = f * box h + h * box f + 2 * metricPair) :
    correctedCarreDuChamp (addScalarPotential box V) f h = metricPair := by
  rw [correctedCarreDuChamp_addScalarPotential]
  exact correctedCarreDuChamp_eq_metricPair box metricPair f h hOne hProduct

/-! ## Joint operator convergence -/

section Convergence

variable {K I : Type*} [NormedField K]
variable {l : Filter I}

/-- Joint convergence of an operator family on `1`, `f`, `h`, and `f * h`
passes through the corrected pairing. These four limits are separate premises:
convergence on individual probes alone does not control the product term. -/
theorem tendsto_correctedCarreDuChamp
    (B : I -> K -> K) (L : K -> K) (f h : K)
    (hProd : Tendsto (fun i => B i (f * h)) l (nhds (L (f * h))))
    (hRight : Tendsto (fun i => B i h) l (nhds (L h)))
    (hLeft : Tendsto (fun i => B i f) l (nhds (L f)))
    (hOne : Tendsto (fun i => B i 1) l (nhds (L 1))) :
    Tendsto (fun i => correctedCarreDuChamp (B i) f h) l
      (nhds (correctedCarreDuChamp L f h)) := by
  have hFRight :
      Tendsto (fun i => f * B i h) l (nhds (f * L h)) :=
    tendsto_const_nhds.mul hRight
  have hHLeft :
      Tendsto (fun i => h * B i f) l (nhds (h * L f)) :=
    tendsto_const_nhds.mul hLeft
  have hFHOne :
      Tendsto (fun i => f * h * B i 1) l (nhds (f * h * L 1)) :=
    tendsto_const_nhds.mul hOne
  have hBracket := ((hProd.sub hFRight).sub hHLeft).add hFHOne
  have hHalf :
      Tendsto (fun _ : I => (2 : K)⁻¹) l (nhds (2 : K)⁻¹) :=
    tendsto_const_nhds
  simpa only [correctedCarreDuChamp] using hHalf.mul hBracket

/-- **Operator-to-metric convergence interface.** If the four required
operator evaluations converge to `box + V`, and `box` obeys the normalized
second-order product rule at the displayed probes, then the reconstructed
pairing converges to the supplied principal-symbol metric value. -/
theorem tendsto_correctedCarreDuChamp_box_add_potential
    [CharZero K] (B : I -> K -> K) (box : K -> K) (V metricPair f h : K)
    (hProdLimit : Tendsto (fun i => B i (f * h)) l
      (nhds (addScalarPotential box V (f * h))))
    (hRightLimit : Tendsto (fun i => B i h) l
      (nhds (addScalarPotential box V h)))
    (hLeftLimit : Tendsto (fun i => B i f) l
      (nhds (addScalarPotential box V f)))
    (hOneLimit : Tendsto (fun i => B i 1) l
      (nhds (addScalarPotential box V 1)))
    (hBoxOne : box 1 = 0)
    (hProductRule :
      box (f * h) = f * box h + h * box f + 2 * metricPair) :
    Tendsto (fun i => correctedCarreDuChamp (B i) f h) l
      (nhds metricPair) := by
  have hLimit := tendsto_correctedCarreDuChamp B
    (addScalarPotential box V) f h hProdLimit hRightLimit hLeftLimit hOneLimit
  simpa only [correctedCarreDuChamp_box_add_potential box V metricPair f h
    hBoxOne hProductRule] using hLimit

end Convergence

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CausalOperatorMetric.correctedCarreDuChamp_addScalarPotential' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms correctedCarreDuChamp_addScalarPotential

/-- info: 'PhysicsSM.Draft.NullEdge.CausalOperatorMetric.correctedCarreDuChamp_box_add_potential' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms correctedCarreDuChamp_box_add_potential

/-- info: 'PhysicsSM.Draft.NullEdge.CausalOperatorMetric.tendsto_correctedCarreDuChamp_box_add_potential' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tendsto_correctedCarreDuChamp_box_add_potential

end PhysicsSM.Draft.NullEdge.CausalOperatorMetric
