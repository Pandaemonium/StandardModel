import PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

/-!
# Finite CAR covariance and inherited coefficient support

This module packages locality-shaped consequences of the determinant-minor
second quantization in `FiniteCARSecondQuantization`.

The first layer proves that occupation-basis creation and annihilation are
exact adjoints for the displayed finite Fock inner product. The support layer
starts with the creation half: when a one-particle matrix
coefficient vanishes outside a displayed relation `R`, creation covariance has
exactly the same relation-filtered support. This is a finite algebraic support
law. It is not a Lieb--Robinson estimate, a causal-cone theorem for interacting
observables, or a completed local quantum field theory.

Annihilation covariance and its relation-filtered support law are derived from
these adjoint identities in the successor layer.

Provenance: the two finite-sum reindexing proofs were returned by Aristotle
project `224621b8-d3ac-4a0b-be34-f4f32b09175e`, then adapted to the live
namespace and independently checked under Lean 4.28.0. The annihilation
covariance proof was composed locally from those adjoint identities,
`gamma_create_covariance`, and `fockInner_Gamma_left`; Aristotle project
`816777bf-e973-4324-a6b0-ffcf07351845` was used as a parallel proof search.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.CARAnnihilationLocality

open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

variable {ι : Type*} [Fintype ι] [LinearOrder ι] [DecidableEq ι]

theorem belowCount_insert_self (i : ι) (S : Finset ι) (hi : i ∉ S) :
    belowCount i (insert i S) = belowCount i S := by
  unfold belowCount
  rw [Finset.filter_insert, if_neg (lt_irrefl i)]

theorem opSign_insert_self (i : ι) (S : Finset ι) (hi : i ∉ S) :
    opSign i (insert i S) = opSign i S := by
  rw [opSign, opSign, belowCount_insert_self i S hi]

/-- Occupation-basis creation is the adjoint of annihilation for the finite
Fock inner product. -/
theorem fockInner_create_left (i : ι) (psi phi : Fock ι) :
    fockInner (create i psi) phi = fockInner psi (annihilate i phi) := by
  have h1 : ∑ S : Finset ι, star (create i psi S) * phi S =
      ∑ S ∈ Finset.univ.filter (fun S => i ∈ S),
        star (opSign i S * psi (S.erase i)) * phi S := by
    unfold create
    rw [Finset.sum_filter]
    congr
    ext
    aesop
  have h2 : ∑ S ∈ Finset.univ.filter (fun S => i ∈ S),
      star (opSign i S * psi (S.erase i)) * phi S =
      ∑ T ∈ Finset.univ.filter (fun T => i ∉ T),
        star (opSign i (insert i T) * psi T) * phi (insert i T) := by
    apply Finset.sum_bij (fun S hS => S.erase i)
    · grind
    · simp +contextual [Finset.ext_iff]
      grind
    · exact fun T hT => ⟨Insert.insert i T, by aesop⟩
    · simp +contextual [Finset.insert_erase]
  convert h1.trans h2 using 1
  unfold fockInner annihilate
  simp +decide [Finset.sum_ite]
  refine Finset.sum_congr rfl fun x hx => ?_
  simp +decide [mul_assoc, mul_comm, mul_left_comm,
    opSign_insert_self i x (by simpa using hx)]
  unfold opSign
  simp +decide [mul_assoc, mul_comm, mul_left_comm]

/-- Occupation-basis annihilation is the adjoint of creation for the finite
Fock inner product. -/
theorem fockInner_annihilate_left (i : ι) (psi phi : Fock ι) :
    fockInner (annihilate i psi) phi = fockInner psi (create i phi) := by
  simp only [fockInner, annihilate, create]
  rw [← Finset.sum_subset
    (Finset.subset_univ (Finset.filter (fun x => i ∉ x) Finset.univ))]
  · rw [← Finset.sum_subset
      (Finset.subset_univ
        (Finset.image (fun x => insert i x)
          (Finset.filter (fun x => i ∉ x) Finset.univ)))]
    · rw [Finset.sum_image]
      · refine Finset.sum_congr rfl fun x hx => ?_
        simp_all +decide [opSign_insert_self]
        unfold opSign
        simp +decide [mul_assoc, mul_comm, mul_left_comm]
      · intro x hx y hy
        simp_all +decide [Finset.ext_iff]
        grind
    · simp +contextual [Finset.mem_image]
      exact fun x hx hi => False.elim
        (hx (x.erase i) (by aesop) (by aesop))
  · aesop

/-! ## Annihilation covariance from adjointness -/

theorem fockInner_comm (a b : Fock ι) :
    fockInner a b = star (fockInner b a) := by
  unfold fockInner
  simp +decide [mul_comm]

theorem fockInner_sum_right {β : Type*} (s : Finset β) (a : Fock ι)
    (g : β → Fock ι) :
    fockInner a (∑ b ∈ s, g b) = ∑ b ∈ s, fockInner a (g b) := by
  simp only [fockInner, Finset.sum_apply, Finset.mul_sum]
  rw [Finset.sum_comm]

theorem fock_ext_inner (A B : Fock ι)
    (h : ∀ phi : Fock ι, fockInner phi A = fockInner phi B) : A = B := by
  funext S
  have hS := h (fun T => if T = S then 1 else 0)
  simpa [fockInner] using hS

theorem fockInner_smul_right (c : Complex) (a b : Fock ι) :
    fockInner a (c • b) = c * fockInner a b := by
  simp [fockInner, Finset.mul_sum, mul_assoc, mul_comm]

theorem fockInner_smul_left (c : Complex) (a b : Fock ι) :
    fockInner (c • a) b = star c * fockInner a b := by
  rw [fockInner_comm, fockInner_smul_right]
  rw [StarMul.star_mul, ← fockInner_comm a b]
  ring

theorem fockInner_sum_left {β : Type*} (s : Finset β) (g : β → Fock ι)
    (b : Fock ι) :
    fockInner (∑ a ∈ s, g a) b = ∑ a ∈ s, fockInner (g a) b := by
  rw [fockInner_comm, fockInner_sum_right]
  rw [star_sum]
  apply Finset.sum_congr rfl
  intro i hi
  exact (fockInner_comm (g i) b).symm

/-- Moving an exterior lift across the right side of the Fock inner product
replaces its one-particle matrix by the conjugate transpose. -/
theorem fockInner_Gamma_right (U : Matrix ι ι Complex) (a b : Fock ι) :
    fockInner a (Gamma U b) = fockInner (Gamma Uᴴ a) b := by
  rw [fockInner_comm, fockInner_Gamma_left, fockInner_comm]
  rw [star_star]

/-- Annihilation covariance for the determinant-minor exterior lift. This
intertwining identity is algebraic and does not require unitarity. -/
theorem gamma_annihilate_covariance (U : Matrix ι ι Complex)
    (j : ι) (psi : Fock ι) :
    annihilate j (Gamma U psi) =
      ∑ i : ι, U j i • Gamma U (annihilate i psi) := by
  apply fock_ext_inner
  intro phi
  calc
    fockInner phi (annihilate j (Gamma U psi)) =
        fockInner (create j phi) (Gamma U psi) :=
      (fockInner_create_left j phi (Gamma U psi)).symm
    _ = fockInner (Gamma Uᴴ (create j phi)) psi :=
      fockInner_Gamma_right U (create j phi) psi
    _ = fockInner
        (∑ i : ι, Uᴴ i j • create i (Gamma Uᴴ phi)) psi := by
      rw [gamma_create_covariance]
    _ = ∑ i : ι, fockInner (Uᴴ i j • create i (Gamma Uᴴ phi)) psi := by
      rw [fockInner_sum_left Finset.univ]
    _ = ∑ i : ι, U j i * fockInner (create i (Gamma Uᴴ phi)) psi := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [fockInner_smul_left]
      simp [Matrix.conjTranspose_apply]
    _ = ∑ i : ι, U j i * fockInner (Gamma Uᴴ phi) (annihilate i psi) := by
      simp_rw [fockInner_create_left]
    _ = ∑ i : ι, U j i * fockInner phi (Gamma U (annihilate i psi)) := by
      simp_rw [fockInner_Gamma_right]
    _ = ∑ i : ι, fockInner phi (U j i • Gamma U (annihilate i psi)) := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [fockInner_smul_right]
    _ = fockInner phi
        (∑ i : ι, U j i • Gamma U (annihilate i psi)) := by
      rw [fockInner_sum_right Finset.univ]

/-- Compatibility corollary in the unitary hypothesis shape used by the
one-particle walk API. -/
theorem gamma_annihilate_covariance_of_unitary (U : Matrix ι ι Complex)
    (_hleft : Uᴴ * U = 1) (_hright : U * Uᴴ = 1)
    (j : ι) (psi : Fock ι) :
    annihilate j (Gamma U psi) =
      ∑ i : ι, U j i • Gamma U (annihilate i psi) :=
  gamma_annihilate_covariance U j psi

/-- Creation covariance inherits any displayed support relation of the
one-particle matrix, with no coefficients outside that relation. -/
theorem gamma_create_covariance_restrict
    (U : Matrix ι ι Complex) (R : ι -> ι -> Prop) [DecidableRel R]
    (i : ι) (psi : Fock ι)
    (hlocal : ∀ j, ¬ R j i -> U j i = 0) :
    Gamma U (create i psi) =
      ∑ j ∈ Finset.univ.filter (fun j => R j i),
        U j i • create j (Gamma U psi) := by
  rw [gamma_create_covariance]
  symm
  apply Finset.sum_subset (Finset.filter_subset _ _)
  intro j _ hj
  have hnot : ¬ R j i := by simpa using hj
  simp [hlocal j hnot]

/-- Annihilation covariance inherits the displayed row-support relation of the
one-particle matrix, with no coefficients outside that relation. -/
theorem gamma_annihilate_covariance_restrict
    (U : Matrix ι ι Complex) (R : ι -> ι -> Prop) [DecidableRel R]
    (j : ι) (psi : Fock ι)
    (hlocal : ∀ i, ¬ R j i -> U j i = 0) :
    annihilate j (Gamma U psi) =
      ∑ i ∈ Finset.univ.filter (fun i => R j i),
        U j i • Gamma U (annihilate i psi) := by
  rw [gamma_annihilate_covariance]
  symm
  apply Finset.sum_subset (Finset.filter_subset _ _)
  intro i hi hnotMem
  have hnot : ¬ R j i := by simpa using hnotMem
  simp [hlocal i hnot]

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.CARAnnihilationLocality.gamma_create_covariance_restrict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gamma_create_covariance_restrict

/-- info: 'PhysicsSM.Draft.NullEdge.CARAnnihilationLocality.fockInner_create_left' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fockInner_create_left

/-- info: 'PhysicsSM.Draft.NullEdge.CARAnnihilationLocality.fockInner_annihilate_left' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fockInner_annihilate_left

/-- info: 'PhysicsSM.Draft.NullEdge.CARAnnihilationLocality.gamma_annihilate_covariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gamma_annihilate_covariance

/-- info: 'PhysicsSM.Draft.NullEdge.CARAnnihilationLocality.gamma_annihilate_covariance_restrict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gamma_annihilate_covariance_restrict

end PhysicsSM.Draft.NullEdge.CARAnnihilationLocality
