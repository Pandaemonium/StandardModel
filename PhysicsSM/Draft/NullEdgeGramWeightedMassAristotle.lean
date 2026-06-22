import Mathlib
import PhysicsSM.Spinor.PluckerMass
import PhysicsSM.Draft.NullEdgeDecoherenceChannelAristotle

/-!
# Draft.NullEdgeGramWeightedMassAristotle

This Aristotle handoff develops the nonorthogonal internal-label version of
the null-edge Plucker mass theorem.

The trusted theorem
`PhysicsSM.Spinor.PluckerMass.fin_bundle_plucker_mass_identity` covers the
orthogonal/decohered internal-label case:

```text
det(sum_i psi_i psi_i^dagger) = sum_{i<j} |psi_i wedge psi_j|^2.
```

For nonorthogonal internal labels with Gram matrix `G`, the visible momentum is

```text
P_vis = M G M^dagger.
```

The expected finite theorem is the Cauchy-Binet exterior-square formula:

```text
det(P_vis)
  =
sum_{p,q}
  det(G_{p,q}) (psi_p.1 wedge psi_p.2)
    conj(psi_q.1 wedge psi_q.2).
```

This is the finite algebraic core of the flavor-overlap line in
`Sources/Null_Edge_Big_Physics_Inquiry_Development.md`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeGramWeightedMass

open BigOperators
open Matrix Complex
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdgeDecoherenceChannel

/-! ## Gram-weighted visible momentum -/

/-- Visible momentum after tracing out nonorthogonal internal labels. -/
def gramWeightedVisibleMomentum {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor) : Matrix (Fin 2) (Fin 2) Complex :=
  fun a b =>
    Finset.univ.sum fun i : Fin n =>
      Finset.univ.sum fun j : Fin n =>
        G i j * psi i a * (starRingEnd Complex) (psi j b)

/-- The exterior-square Gram matrix entry indexed by two ordered pairs. -/
def exteriorPairGram {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex)
    (p q : Prod (Fin n) (Fin n)) : Complex :=
  G p.1 q.1 * G p.2 q.2 - G p.1 q.2 * G p.2 q.1

/-- The Gram-weighted Plucker quadratic form. -/
def gramWeightedPluckerMass {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor) : Complex :=
  (finPairIndexSet n).sum fun p =>
    (finPairIndexSet n).sum fun q =>
      exteriorPairGram G p q *
        spinorWedge (psi p.1) (psi p.2) *
          (starRingEnd Complex) (spinorWedge (psi q.1) (psi q.2))

/-! ## Three-stage Cauchy-Binet decomposition -/

/-- The raw four-fold determinant expansion. -/
def gramDetFullSum {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor) : Complex :=
  Finset.univ.sum fun i : Fin n =>
    Finset.univ.sum fun k : Fin n =>
      Finset.univ.sum fun j : Fin n =>
        Finset.univ.sum fun l : Fin n =>
          psi i 0 * psi k 1 * (G i j * G k l) *
            (starRingEnd Complex) (spinorWedge (psi j) (psi l))

/-- The same expansion after folding the hidden/output indices. -/
def gramDetInnerFold {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor) : Complex :=
  Finset.univ.sum fun i : Fin n =>
    Finset.univ.sum fun k : Fin n =>
      (finPairIndexSet n).sum fun q =>
        psi i 0 * psi k 1 * exteriorPairGram G (i, k) q *
          (starRingEnd Complex) (spinorWedge (psi q.1) (psi q.2))

/-! ## Folding helper lemmas -/

/-- The spinor wedge of a spinor with itself vanishes. -/
theorem spinorWedge_self (psi : CSpinor) : spinorWedge psi psi = 0 := by
  simp [spinorWedge]
  ring

/-- Fold a double sum with vanishing diagonal into a sum over unordered pairs. -/
theorem sum_sum_eq_pairSum {n : Nat} (F : Fin n -> Fin n -> Complex)
    (hdiag : forall a, F a a = 0) :
    (Finset.univ.sum fun j => Finset.univ.sum fun l => F j l) =
      (finPairIndexSet n).sum fun q => F q.1 q.2 + F q.2 q.1 := by
  simp +decide only [finPairIndexSet, Finset.sum_filter]
  erw [Finset.sum_product]
  simp +decide [Finset.sum_ite, Finset.filter_lt_eq_Ioi]
  induction' n with n ih <;> simp +decide [Fin.sum_univ_succ, *]
  simp +decide [Finset.sum_add_distrib,
    ih (fun i j => F i.succ j.succ) fun i => hdiag i.succ]
  ring

/-- Determinant of the Gram-weighted visible momentum as a four-fold sum. -/
theorem gramWeightedVisibleMomentum_det_fullSum {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex) (psi : Fin n -> CSpinor) :
    (gramWeightedVisibleMomentum G psi).det = gramDetFullSum G psi := by
  unfold gramWeightedVisibleMomentum gramDetFullSum
  simp +decide only [starRingEnd_apply, det_fin_two, spinorWedge]
  simp +decide [mul_sub, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _]
  simp +decide only [← Finset.sum_sub_distrib]
  exact Finset.sum_comm.trans
    (Finset.sum_congr rfl fun _ _ =>
      Finset.sum_congr rfl fun _ _ =>
        Finset.sum_comm.trans
          (Finset.sum_congr rfl fun _ _ =>
            Finset.sum_congr rfl fun _ _ => by ring))

/-- Fold the hidden/output `(j,l)` double sum into exterior Gram entries. -/
theorem gramDetFullSum_eq_innerFold {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex) (psi : Fin n -> CSpinor) :
    gramDetFullSum G psi = gramDetInnerFold G psi := by
  apply Finset.sum_congr rfl
  intro i hi
  apply Finset.sum_congr rfl
  intro k hk
  convert sum_sum_eq_pairSum _ _ using 2
  · unfold exteriorPairGram spinorWedge
    norm_num
    ring
  · simp +decide [spinorWedge_self]

/-- Fold the visible/input `(i,k)` double sum into spinor wedges. -/
theorem gramDetInnerFold_eq_pluckerMass {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex) (psi : Fin n -> CSpinor) :
    gramDetInnerFold G psi = gramWeightedPluckerMass G psi := by
  unfold gramDetInnerFold gramWeightedPluckerMass
  rw [Finset.sum_congr rfl fun i _ => Finset.sum_comm, Finset.sum_comm]
  conv_rhs => rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun q hq => ?_
  rw [sum_sum_eq_pairSum
      (fun i k => psi i 0 * psi k 1 * exteriorPairGram G (i, k) q *
        (starRingEnd Complex) (spinorWedge (psi q.1) (psi q.2)))
      (fun a => by simp only [exteriorPairGram]; ring)]
  refine Finset.sum_congr rfl fun p hp => ?_
  simp only [exteriorPairGram, spinorWedge]
  ring

/--
Main target: Cauchy-Binet with an internal Gram matrix.

When `G = 1`, this recovers the trusted orthogonal Plucker mass theorem.  When
`G` has rank one, `exteriorPairGram G` vanishes and the visible determinant is
zero.
-/
theorem visibleDet_eq_exteriorGram_weighted_plucker {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor) :
    (gramWeightedVisibleMomentum G psi).det =
      gramWeightedPluckerMass G psi := by
  rw [gramWeightedVisibleMomentum_det_fullSum,
    gramDetFullSum_eq_innerFold,
    gramDetInnerFold_eq_pluckerMass]

/-! ## Important limits -/

/-- The orthogonal internal Gram matrix recovers the usual visible bundle. -/
theorem gramWeightedVisibleMomentum_one_eq_finBundleMomentum {n : Nat}
    (psi : Fin n -> CSpinor) :
    gramWeightedVisibleMomentum (1 : Matrix (Fin n) (Fin n) Complex) psi =
      finBundleMomentum psi := by
  ext a b
  unfold gramWeightedVisibleMomentum finBundleMomentum rankOneHermitian
  rw [Finset.sum_apply]
  simp [Matrix.vecMulVec, Matrix.one_apply]

/-- The Gram-weighted theorem recovers the trusted Plucker sum at `G = 1`. -/
theorem orthonormal_internalGram_recovers_plucker_sum {n : Nat}
    (psi : Fin n -> CSpinor) :
    (gramWeightedVisibleMomentum (1 : Matrix (Fin n) (Fin n) Complex) psi).det =
      finPairwisePluckerMass psi := by
  rw [gramWeightedVisibleMomentum_one_eq_finBundleMomentum]
  exact fin_bundle_plucker_mass_identity psi

/-- Coherent internal superposition of visible spinors. -/
def coherentInternalSuperposition {n : Nat}
    (u : Fin n -> Complex) (psi : Fin n -> CSpinor) : CSpinor :=
  fun a => Finset.univ.sum fun i : Fin n => u i * psi i a

/--
A rank-one internal Gram matrix makes the visible momentum rank one.
-/
theorem rankOne_internalGram_eq_rankOneHermitian {n : Nat}
    (u : Fin n -> Complex) (psi : Fin n -> CSpinor) :
    gramWeightedVisibleMomentum
        (fun i j : Fin n => u i * (starRingEnd Complex) (u j)) psi =
      rankOneHermitian (coherentInternalSuperposition u psi) := by
  ext a b
  unfold gramWeightedVisibleMomentum rankOneHermitian coherentInternalSuperposition
  simp [Matrix.vecMulVec, Finset.sum_mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  ring

/-- Perfect internal coherence forces visible determinant mass to vanish. -/
theorem rankOne_internalGram_implies_visible_massless {n : Nat}
    (u : Fin n -> Complex) (psi : Fin n -> CSpinor) :
    (gramWeightedVisibleMomentum
        (fun i j : Fin n => u i * (starRingEnd Complex) (u j)) psi).det = 0 := by
  rw [rankOne_internalGram_eq_rankOneHermitian]
  exact det_rankOneHermitian_eq_zero _

/-! ## Two-state partial-coherence bridge -/

/-- Two-state internal Gram matrix with overlap `k`. -/
def twoStatePartialGram (k : Complex) :
    Matrix (Fin 2) (Fin 2) Complex :=
  fun i j =>
    if i = 0 /\ j = 0 then 1
    else if i = 0 /\ j = 1 then k
    else if i = 1 /\ j = 0 then (starRingEnd Complex) k
    else 1

/-- Two visible spinors as a `Fin 2` family. -/
def twoStateVisibleFamily (psi phi : CSpinor) : Fin 2 -> CSpinor :=
  fun i => if i = 0 then psi else phi

/--
The general Gram-weighted momentum specializes to the existing
partial-coherence momentum.
-/
theorem gramWeightedVisibleMomentum_twoStatePartial_eq_partialCoherence
    (k : Complex) (psi phi : CSpinor) :
    gramWeightedVisibleMomentum (twoStatePartialGram k)
        (twoStateVisibleFamily psi phi) =
      partialCoherenceMomentum k psi phi := by
  ext a b
  fin_cases a <;> fin_cases b <;>
    simp [gramWeightedVisibleMomentum, twoStatePartialGram,
      twoStateVisibleFamily, partialCoherenceMomentum, spinorOuter,
      rankOneHermitian, Matrix.vecMulVec]
    <;> ring

/-- The two-state Gram formula recovers the existing hidden-overlap factor. -/
theorem twoStatePartialGram_det_eq_factor_mul_plucker
    (k : Complex) (psi phi : CSpinor) :
    (gramWeightedVisibleMomentum (twoStatePartialGram k)
        (twoStateVisibleFamily psi phi)).det =
      hiddenOverlapDetFactor k * complexAbsSq (spinorWedge psi phi) := by
  rw [gramWeightedVisibleMomentum_twoStatePartial_eq_partialCoherence]
  exact partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker k psi phi

end PhysicsSM.Draft.NullEdgeGramWeightedMass

end
