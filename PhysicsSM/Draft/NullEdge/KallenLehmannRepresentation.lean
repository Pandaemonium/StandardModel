import Mathlib

/-!
# Kallen-Lehmann finite representation capstone (Opus, verified Aristotle e711dfe9)

Finite KL spectral representation and physical mass (namespace kept as the
prover's `FiniteKallenLehmann` to preserve the exact kernel-checked proofs).
physical_mass_can_exceed_spectral_minimum: spec {1,3}, obs (0,1) -> mass 3 > min 1,
re-deriving gap_does_not_fix_pole at the spectral-measure level.
Provenance: verified verbatim at pin from Aristotle task ba61441f. Standard three. -/

open scoped BigOperators ComplexConjugate
open Filter Matrix

set_option autoImplicit false
set_option maxHeartbeats 8000000

namespace FiniteKallenLehmann

noncomputable section

/-- The diagonal Hermitian Hamiltonian whose real eigenvalue in channel `i` is `d i`. -/
def hamiltonian {m : ℕ} (d : Fin m → ℝ) : Matrix (Fin m) (Fin m) ℂ :=
  Matrix.diagonal fun i => (d i : ℂ)

/-- The KL weight in a diagonal eigenchannel.  It is the squared norm of the
observable's overlap with that channel. -/
def weight {m : ℕ} (v : Fin m → ℂ) (i : Fin m) : ℝ :=
  Complex.normSq (v i)

/-- The two-point response, defined directly from the matrix resolvent and the
standard Hermitian inner product on coordinate vectors. -/
def response {m : ℕ} (d : Fin m → ℝ) (v : Fin m → ℂ) (z : ℂ) : ℂ :=
  ∑ i, conj (v i) *
    (((z • (1 : Matrix (Fin m) (Fin m) ℂ) - hamiltonian d)⁻¹).mulVec v i)

/-- The explicit finite Kallen--Lehmann sum in a diagonal eigenbasis. -/
def klSum {m : ℕ} (d : Fin m → ℝ) (v : Fin m → ℂ) (z : ℂ) : ℂ :=
  ∑ i, (weight v i : ℂ) / (z - (d i : ℂ))

/-
The diagonal Hamiltonian really is Hermitian.
-/
theorem hamiltonian_isHermitian {m : ℕ} (d : Fin m → ℝ) :
    (hamiltonian d)ᴴ = hamiltonian d := by
  ext i j; by_cases hi : i = j <;> simp +decide [ hi, hamiltonian ] ;
  exact if_neg ( Ne.symm hi )

/-
Every finite diagonal KL spectral weight is real and nonnegative.
-/
theorem weight_nonneg {m : ℕ} (v : Fin m → ℂ) (i : Fin m) :
    0 ≤ weight v i := by
  exact Complex.normSq_nonneg _

/-
**Finite diagonal Kallen--Lehmann representation.**  Away from every
spectral point, the response obtained from the matrix inverse is the finite sum
of the nonnegative weights divided by `z - d i`.

The sum is over eigenchannels.  Thus repeated eigenvalues occur repeatedly;
grouping equal denominators gives the usual sum over distinct eigenvalues, with
their channel weights added.
-/
theorem finite_kl_representation {m : ℕ} (d : Fin m → ℝ) (v : Fin m → ℂ)
    (z : ℂ) (hz : ∀ i, z ≠ (d i : ℂ)) :
    response d v z = klSum d v z := by
  unfold response klSum;
  -- We simplify the matrix inverse and multiplication.
  have h_inv : (z • (1 : Matrix (Fin m) (Fin m) ℂ) - hamiltonian d)⁻¹ = Matrix.diagonal (fun i : Fin m => (z - (d i : ℂ))⁻¹) := by
    refine' Matrix.inv_eq_left_inv _;
    ext i j ; by_cases hi : i = j <;> simp_all +decide [ sub_eq_iff_eq_add, hamiltonian ];
    simp +decide [ hi, Matrix.one_apply ];
  simp_all +decide [ mul_comm, div_eq_mul_inv, Matrix.mulVec, weight ];
  simp +decide [mul_assoc, Complex.normSq_eq_norm_sq];
  simp +decide [ mul_left_comm ( v _ ), Complex.mul_conj, Complex.normSq_eq_norm_sq ]

/-- The regular part obtained after extracting the pole in channel `k`.
The distinctness assumption in the residue theorem below says that this channel
is a simple spectral point. -/
def regularizedResponse {m : ℕ} (d : Fin m → ℝ) (v : Fin m → ℂ)
    (k : Fin m) (z : ℂ) : ℂ :=
  (weight v k : ℂ) +
    ∑ i ∈ Finset.univ.filter (fun i => i ≠ k),
      (weight v i : ℂ) * (z - (d k : ℂ)) / (z - (d i : ℂ))

/-
Algebraic pole extraction: away from the spectrum, multiplying the KL sum
by `z - d k` gives its regularized expression.
-/
theorem pole_extraction {m : ℕ} (d : Fin m → ℝ) (v : Fin m → ℂ)
    (k : Fin m) (z : ℂ) (hz : ∀ i, z ≠ (d i : ℂ)) :
    (z - (d k : ℂ)) * klSum d v z = regularizedResponse d v k z := by
  unfold klSum regularizedResponse;
  simp +decide [Finset.filter_ne', div_eq_mul_inv, Finset.mul_sum _ _ _,
    mul_assoc, mul_left_comm, sub_ne_zero.mpr (hz _)]

/-
**Residue equals KL weight**, in the requested algebraic finite form.
Evaluation of the channel-regularized pole expression at that eigenvalue is
exactly its KL weight.  This algebraic evaluation itself needs no simplicity
hypothesis; interpreting it as the residue of the whole response requires that
no other channel have the same eigenvalue (or, equivalently, grouping all such
channels and adding their weights).
-/
theorem residue_eq_weight {m : ℕ} (d : Fin m → ℝ) (v : Fin m → ℂ)
    (k : Fin m) :
    regularizedResponse d v k (d k : ℂ) = (weight v k : ℂ) := by
  unfold regularizedResponse; aesop

/-- Analytic residue statement for a simple eigenchannel: along the punctured
neighborhood of `d k`, `(z - d k) G(z)` tends to the KL weight. -/
theorem tendsto_residue_eq_weight {m : ℕ} (d : Fin m → ℝ) (v : Fin m → ℂ)
    (k : Fin m) (hsimple : ∀ i, i ≠ k → d i ≠ d k) :
    Tendsto (fun z : ℂ => (z - (d k : ℂ)) * klSum d v z)
      (nhdsWithin (d k : ℂ) ({(d k : ℂ)} : Set ℂ)ᶜ)
      (nhds (weight v k : ℂ)) := by
  have h_cont :
      Filter.Tendsto
        (fun z : ℂ => ∑ i ∈ Finset.univ.filter (fun i => i ≠ k),
          (weight v i : ℂ) * (z - (d k : ℂ)) / (z - (d i : ℂ)))
        (nhdsWithin (d k : ℂ) {(d k : ℂ)}ᶜ) (nhds 0) := by
    refine' tendsto_nhdsWithin_of_tendsto_nhds _;
    refine' ContinuousAt.tendsto _ |> fun h => h.trans _;
    · exact tendsto_finset_sum _ fun i hi => ContinuousAt.div ( Continuous.continuousAt ( by continuity ) ) ( Continuous.continuousAt ( by continuity ) ) ( sub_ne_zero_of_ne <| by norm_cast; aesop );
    · norm_num;
  refine' Filter.Tendsto.congr' _ ( by simpa using h_cont.const_add ( weight v k : ℂ ) );
  refine' eventually_nhdsWithin_iff.mpr _;
  simp +decide [Finset.filter_ne', klSum]
  simp +contextual [div_eq_mul_inv, mul_assoc, mul_left_comm,
    Finset.mul_sum _ _ _, sub_ne_zero]

/-- The finite set of spectral points having nonzero physical overlap. -/
def weightedSpectrum {m : ℕ} (d : Fin m → ℝ) (v : Fin m → ℂ) : Finset ℝ :=
  (Finset.univ.filter fun i => weight v i ≠ 0).image d

/-- The physical mass is the smallest spectral point with nonzero KL weight.
The nonemptiness argument records that the observable overlaps at least one
channel. -/
def physicalMass {m : ℕ} (d : Fin m → ℝ) (v : Fin m → ℂ)
    (h : (weightedSpectrum d v).Nonempty) : ℝ :=
  (weightedSpectrum d v).min' h

/-
A concrete two-level witness: the spectral minimum is `1`, but an observable
orthogonal to its eigenvector has weights `(0,1)`, so its physical mass is `3`.
This is the spectral-measure form of the propagator-zero obstruction: a positive
spectral gap alone does not force a pole at the ground spectral point.
-/
theorem physical_mass_can_exceed_spectral_minimum :
    let d : Fin 2 → ℝ := ![1, 3]
    let v : Fin 2 → ℂ := ![0, 1]
    let hs : (Finset.univ.image d).Nonempty := by simp
    let hw : (weightedSpectrum d v).Nonempty := by
      refine ⟨3, ?_⟩
      simp [weightedSpectrum, weight, d, v]
    (Finset.univ.image d).min' hs = 1 ∧
      weight v 0 = 0 ∧
      physicalMass d v hw = 3 ∧
      (Finset.univ.image d).min' hs < physicalMass d v hw := by
  simp [physicalMass, weightedSpectrum, weight] at *;
  simp +decide [ Fin.univ_succ ];
  norm_num [ Finset.min', Finset.filter_insert, Finset.filter_singleton ]

end

end FiniteKallenLehmann
