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

set_option grind.warning false

/-!
# A finite CPT theorem (Conjecture R)

A finite null-edge carrier is modelled here by the explicit `4`-dimensional
Clifford ⊗ color witness `H = ℂ⁴` (spin `2` ⊗ color `2`).  On it we fix:

* the **chiral grading** `Gamma = σz ⊗ I = diag(1,1,-1,-1)`  (`Gamma² = 1`, `Gammaᴴ = Gamma`),
* the **fundamental symmetry / indefinite metric** `Jmet = I ⊗ σx`
  (`Jmet² = 1`, `Jmetᴴ = Jmet`, trace `0` so genuinely indefinite),
* the **Krein adjoint** `X^# = Jmet Xᴴ Jmet`,
* the **Dirac operator** `Dop = i·(σx ⊗ σy)`, which is chiral-odd
  (`Gamma Dop Gamma = -Dop`) and Krein-self-adjoint (`Dop^# = Dop`).

The CPT operator is `Theta = C ∘ Γrev ∘ #` realised on the carrier as the
antilinear map `Θ v = R · conj v` where `R = Gamma * Jmet` is the product of the
grading (edge-orientation reversal `Γrev`) and the metric part of `#`.

We prove:
1. `Theta_antiunitary`  — `Θ` is antilinear and Krein-isometric.
2. `Theta_conjugates_D_to_sharp` — `Θ D Θ⁻¹ = D^#` (`Θ` is an involution, so `Θ⁻¹ = Θ`).
3. `spectrum_conjugate_paired` — the spectrum of `D` is conjugate-paired.
-/

open Matrix

namespace ConjectureR

/-- Carrier Hilbert space of the finite null-edge witness: `ℂ⁴ = spin ⊗ color`. -/
abbrev Carrier : Type := Fin 4 → ℂ

/-- The chiral grading `Γ = σz ⊗ I = diag(1,1,-1,-1)`. -/
noncomputable def Gamma : Matrix (Fin 4) (Fin 4) ℂ :=
  !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- The fundamental symmetry / indefinite metric `J = I ⊗ σx`. -/
noncomputable def Jmet : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0,1,0,0; 1,0,0,0; 0,0,0,1; 0,0,1,0]

/-- The Dirac operator `D = i·(σx ⊗ σy)` (real, antisymmetric, chiral-odd). -/
noncomputable def Dop : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0,0,0,1; 0,0,-1,0; 0,1,0,0; -1,0,0,0]

/-- The matrix part of the CPT operator: `R = Γ · J`
(grading composed with the metric part of `#`). -/
noncomputable def Rmat : Matrix (Fin 4) (Fin 4) ℂ := Gamma * Jmet

/-- The Krein adjoint (indefinite-metric adjoint) `X^# = J Xᴴ J`. -/
noncomputable def sharp (X : Matrix (Fin 4) (Fin 4) ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  Jmet * Xᴴ * Jmet

/-- The CPT operator `Θ = C ∘ Γrev ∘ #` realised on the carrier:
`Θ v = R · conj v`, an antilinear map. -/
noncomputable def Theta (v : Carrier) : Carrier := Rmat *ᵥ (star v)

/-- The Krein (indefinite) sesquilinear form `⟪v,w⟫_J = ∑ conj(vᵢ) (J w)ᵢ`. -/
noncomputable def kreinForm (v w : Carrier) : ℂ := (star v) ⬝ᵥ (Jmet *ᵥ w)

/-! ## Basic structural identities of the witness -/

/--
`R` in explicit form.
-/
theorem Rmat_eq : Rmat = !![0,1,0,0; 1,0,0,0; 0,0,0,-1; 0,0,-1,0] := by
  unfold Rmat Gamma Jmet;
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ;

theorem Gamma_sq : Gamma * Gamma = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Gamma, Matrix.mul_apply, Fin.sum_univ_four ] ;

theorem Jmet_sq : Jmet * Jmet = 1 := by
  unfold Jmet; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ;

theorem Jmet_herm : Jmetᴴ = Jmet := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Jmet ] ;

theorem Gamma_herm : Gammaᴴ = Gamma := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Gamma ] ;

/--
The Dirac operator is chiral-odd: it anticommutes with the grading.
-/
theorem Dop_chiral_odd : Gamma * Dop * Gamma = -Dop := by
  ext i j;
  fin_cases i <;> fin_cases j <;> simp +decide [ Gamma, Dop, Matrix.mul_apply, Fin.sum_univ_succ ] ;

/--
The Dirac operator is Krein-self-adjoint: `D^# = D`.
-/
theorem sharp_Dop_eq : sharp Dop = Dop := by
  unfold sharp Dop;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ];
  all_goals simp +decide [ Jmet ] ;

/--
`Rmat` squares to the identity, hence `Θ² = 1`.
-/
theorem Rmat_sq : Rmat * Rmat = 1 := by
  convert congr_arg₂ ( fun x y => x * y ) Gamma_sq Jmet_sq using 1 ;
  · simp +decide [ Rmat, Matrix.mul_assoc ];
    unfold Gamma Jmet; norm_num [ ← Matrix.ext_iff, Fin.forall_fin_succ ] ;
  · norm_num

/--
`Rmat` is real (fixed by entrywise conjugation).
-/
theorem Rmat_map_star : Rmat.map (starRingEnd ℂ) = Rmat := by
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ Rmat_eq ]

/--
`Dop` is real (fixed by entrywise conjugation).
-/
theorem Dop_map_star : Dop.map (starRingEnd ℂ) = Dop := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Dop ] ;

/--
Krein-isometry identity at matrix level: `Rᴴ J R = J`.
-/
theorem Rmat_krein_isom : Rmatᴴ * Jmet * Rmat = Jmet := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Rmat_eq, Jmet, Matrix.mul_apply, Fin.sum_univ_four ]

/--
The core CPT matrix identity `R · conj(D) · R = D^#`.
-/
theorem Rmat_conjD_Rmat : Rmat * (Dop.map (starRingEnd ℂ)) * Rmat = sharp Dop := by
  rw [ Dop_map_star, sharp_Dop_eq ];
  rw [ show Rmat = !![0,1,0,0; 1,0,0,0; 0,0,0,-1; 0,0,-1,0] from Rmat_eq ] ; ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ];
  all_goals simp +decide [ Dop, Matrix.vecMul ] ;

/-! ## Target 1 — antiunitarity of `Θ` -/

/--
`Θ` is additive.
-/
theorem Theta_add (v w : Carrier) : Theta (v + w) = Theta v + Theta w := by
  unfold Theta; ext i; simp +decide [ dotProduct, Matrix.mulVec, Fin.sum_univ_succ ] ; ring;

/--
`Θ` is **antilinear**: `Θ (c • v) = conj c • Θ v`.
-/
theorem Theta_smul (c : ℂ) (v : Carrier) :
    Theta (c • v) = (starRingEnd ℂ c) • Theta v := by
  ext i;
  simp +decide [ Theta, Matrix.mulVec, dotProduct, Fin.sum_univ_succ ] ; ring!

/--
`Θ` is **Krein-isometric**: `⟪Θ v, Θ w⟫_J = conj ⟪v, w⟫_J`.
-/
theorem Theta_krein_isometry (v w : Carrier) :
    kreinForm (Theta v) (Theta w) = starRingEnd ℂ (kreinForm v w) := by
  unfold Theta kreinForm;
  simp +decide [ Rmat, Jmet, Gamma, Matrix.mulVec, dotProduct, Fin.sum_univ_four ];
  ring

/-- **Target 1.** `Θ` is antiunitary: antilinear and Krein-isometric. -/
theorem Theta_antiunitary :
    (∀ v w : Carrier, Theta (v + w) = Theta v + Theta w) ∧
    (∀ (c : ℂ) (v : Carrier), Theta (c • v) = (starRingEnd ℂ c) • Theta v) ∧
    (∀ v w : Carrier, kreinForm (Theta v) (Theta w) = starRingEnd ℂ (kreinForm v w)) :=
  ⟨Theta_add, Theta_smul, Theta_krein_isometry⟩

/-! ## Target 2 — `Θ D Θ⁻¹ = D^#` -/

/--
`Θ` is an involution, so `Θ⁻¹ = Θ`.
-/
theorem Theta_involutive (v : Carrier) : Theta (Theta v) = v := by
  unfold Theta;
  simp +decide [ Rmat_eq, funext_iff ];
  simp +decide [ Fin.forall_fin_succ, vecHead, vecTail ]

/--
**Target 2.** CPT conjugates the Dirac operator to its Krein adjoint:
`Θ D Θ⁻¹ = D^#`.  As `Θ` is an involution this reads `Θ (D (Θ v)) = D^# v`.
-/
theorem Theta_conjugates_D_to_sharp (v : Carrier) :
    Theta (Dop *ᵥ (Theta v)) = (sharp Dop) *ᵥ v := by
  unfold Theta sharp;
  unfold Rmat Jmet Dop;
  unfold Gamma; norm_num [ Matrix.vecMul, Matrix.mul_apply ] ;
  simp +decide [ Matrix.vecHead, Matrix.vecTail, Matrix.vecMul, Matrix.mul_apply, dotProduct, Fin.sum_univ_succ ] at *

/-! ## Target 3 — conjugate pairing of the spectrum -/

/--
`Θ` commutes with `D` (since `D^# = D`): `Θ (D v) = D (Θ v)`.
-/
theorem Theta_comm_Dop (v : Carrier) :
    Theta (Dop *ᵥ v) = Dop *ᵥ (Theta v) := by
  convert Theta_conjugates_D_to_sharp ( Theta v ) using 1;
  · rw [ Theta_involutive ];
  · rw [ sharp_Dop_eq ]

/--
`Θ` maps nonzero vectors to nonzero vectors.
-/
theorem Theta_ne_zero {v : Carrier} (hv : v ≠ 0) : Theta v ≠ 0 := by
  intro h_zero
  have h_v_zero : v = 0 := by
    have := @Theta_involutive v; simp_all +decide [ Theta ] ;
  contradiction

/--
**Target 3.** CPT spectral pairing: if `λ` is an eigenvalue of `D` (with
eigenvector `v`), then its complex conjugate `conj λ` is also an eigenvalue of `D`
(with eigenvector `Θ v`).  Hence the spectrum of `D` is conjugate-paired.
-/
theorem spectrum_conjugate_paired {lam : ℂ} {v : Carrier}
    (hv : v ≠ 0) (heig : Dop *ᵥ v = lam • v) :
    Dop *ᵥ (Theta v) = (starRingEnd ℂ lam) • (Theta v) ∧ Theta v ≠ 0 := by
  refine ⟨ ?_, Theta_ne_zero hv ⟩
  rw [ ← Theta_smul, ← Theta_comm_Dop, heig ]

/--
The Dirac operator squares to `-1`; combined with the pairing this pins the
spectrum to the conjugate pair `{i, -i}`.
-/
theorem Dop_sq : Dop * Dop = -1 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Dop, Matrix.mul_apply, Fin.sum_univ_succ ] ;

end ConjectureR

/-! ## Axiom-footprint guard

Each headline result depends only on `[propext, Classical.choice, Quot.sound]`. -/

/-- info: 'ConjectureR.Theta_antiunitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ConjectureR.Theta_antiunitary

/-- info: 'ConjectureR.Theta_conjugates_D_to_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ConjectureR.Theta_conjugates_D_to_sharp

/-- info: 'ConjectureR.spectrum_conjugate_paired' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ConjectureR.spectrum_conjugate_paired

/-- info: 'ConjectureR.Dop_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ConjectureR.Dop_sq
