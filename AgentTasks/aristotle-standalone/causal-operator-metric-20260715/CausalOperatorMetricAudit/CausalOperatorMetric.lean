import Mathlib

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CausalOperatorMetric

variable {A : Type*} [Field A] [CharZero A]

def correctedCarreDuChamp (L : A -> A) (f h : A) : A :=
  (2 : A)⁻¹ *
    (L (f * h) - f * L h - h * L f + f * h * L 1)

def addScalarPotential (L : A -> A) (V : A) : A -> A :=
  fun u => L u + V * u

theorem correctedCarreDuChamp_comm
    (L : A -> A) (f h : A) :
    correctedCarreDuChamp L f h = correctedCarreDuChamp L h f := by
  unfold correctedCarreDuChamp
  ring_nf

@[simp] theorem correctedCarreDuChamp_one_left
    (L : A -> A) (h : A) :
    correctedCarreDuChamp L 1 h = 0 := by
  unfold correctedCarreDuChamp
  ring_nf

theorem correctedCarreDuChamp_addScalarPotential
    (L : A -> A) (V f h : A) :
    correctedCarreDuChamp (addScalarPotential L V) f h =
      correctedCarreDuChamp L f h := by
  unfold correctedCarreDuChamp addScalarPotential
  ring_nf

theorem correctedCarreDuChamp_eq_metricPair
    (box : A -> A) (metricPair f h : A)
    (hOne : box 1 = 0)
    (hProduct :
      box (f * h) = f * box h + h * box f + 2 * metricPair) :
    correctedCarreDuChamp box f h = metricPair := by
  unfold correctedCarreDuChamp
  rw [hProduct, hOne]
  ring_nf

theorem correctedCarreDuChamp_box_add_potential
    (box : A -> A) (V metricPair f h : A)
    (hOne : box 1 = 0)
    (hProduct :
      box (f * h) = f * box h + h * box f + 2 * metricPair) :
    correctedCarreDuChamp (addScalarPotential box V) f h = metricPair := by
  rw [correctedCarreDuChamp_addScalarPotential]
  exact correctedCarreDuChamp_eq_metricPair box metricPair f h hOne hProduct

end PhysicsSM.Draft.NullEdge.CausalOperatorMetric
