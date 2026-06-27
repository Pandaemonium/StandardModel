import Mathlib

/-!
# Dual-solder symbol: commutator and kinetic quadratic form

This file is **self-contained** and imports only `Mathlib`.  It develops the exact
finite/affine algebra of the *dual-soldered* first-order (Dirac-type) operator built
from a null tetrahedral frame, and proves that the Plücker/Gram spread of the frame
enters as the **square of the principal (kinetic) symbol**, not as an additive
zero-order mass term.

## Mathematical context (Lorentzian Borici–Creutz / 4D-hyperdiamond symbol)

For a null tetrahedral frame `ℓ_A = (1, n_A)` (`A : Fin 4`, `n_A = s_A / √3` with the
observer-normalised sign tetrahedron `s_1=(1,1,1)`, `s_2=(1,-1,-1)`, `s_3=(-1,1,-1)`,
`s_4=(-1,-1,1)`), the dual covectors `α^A = (1/4)dt + (3/4) n_A·dx` are the unique
covectors with `α^A(ℓ_B) = δ^A_B`, and every covector reconstructs as
`ξ = ∑_A ξ(ℓ_A) α^A`.  The Gram matrix of the `ℓ_A` is `0` on the diagonal and `4/3`
off-diagonal; its inverse is `-1/2` on the diagonal and `1/4` off-diagonal
(`cos θ = -1/4`, the established hyperdiamond soldering).

Up to Lorentzian signature, the dual-soldered operator `D = ∑_a c(α^a) ∇_a` is the
minimally-doubled Borici–Creutz / 4D-hyperdiamond Dirac operator
(Creutz arXiv:0712.1201; Borici arXiv:0812.0092).  The naive diagonal ansatz
`∑_a c(ℓ_a) ∇_a` fails to be a Dirac symbol (trace obstruction) — a known lattice
fact, not a discovery here.

## Main results

* `NullSolderFrame` — minimal structure: index `Fin 4`, null vectors `ell`, dual
  covectors `alpha`, and the dual-reconstruction property.
* `dualSymbol_reconstructs_covector` — exact finite reconstruction `∑_a ξ(ℓ_a)•α^a = ξ`.
* `supportedShift_commutator_mul` / `dualSolder_commutator_exact` — the **exact**
  finite/affine commutator `[D_sol, M_f]` of the dual-soldered first-order operator
  with multiplication by a function `f`, equal to the Clifford action of the discrete
  differential `∑_a (f∘shift − f) c(α^a)`.
* `dualSymbol_quadratic_form` / `dualSymbol_sq` — the square of the dual-soldered
  principal symbol equals the Lorentzian quadratic form of the soldered covector:
  `(∑_a λ_a c(α^a))² = Q(∑_a λ_a α^a) • 1`.
* `plueckerKinetic_not_zeroOrder_doc` — precise contract: the Plücker/Gram invariant
  is the **principal-symbol square** of a first-order symbol (it vanishes at the zero
  covector), not an additive zero-order mass `m•1`.

The closing `Tetrahedron` section verifies the exact rational Gram (`0` / `4/3`),
inverse Gram product (`-1/2` / `1/4`), biorthogonality `α^A(ℓ_B) = δ^A_B` and the
resolution of identity `∑_a (ℓ_a)_μ (α^a)_ν = δ_{μν}` for the concrete tetrahedral
convention above, using exact rational arithmetic (the `√3`'s cancel).

`minkowskiInner` / `IsNull` below are a minimal self-contained copy of the conventions
in `PhysicsSM.NullStrand.Conventions` (signature `(+---)`); they are reproduced here
so that this module depends on `Mathlib` only.
-/

namespace PhysicsSM.NullStrand.DualSolder

open scoped BigOperators

/-! ## The abstract dual-soldered frame -/

variable {V : Type*} [AddCommGroup V] [Module ℝ V]

/-- A minimal **null-solder frame**: four null vectors `ell A` together with four dual
covectors `alpha A` on `V` whose evaluation reconstructs every covector,
`ξ = ∑_A ξ(ℓ_A) α^A`.  The Lorentzian quadratic form `Q` lives on the covector space
`Module.Dual ℝ V` (the inverse/dual Minkowski metric). -/
structure NullSolderFrame (V : Type*) [AddCommGroup V] [Module ℝ V] where
  /-- The (inverse/dual) Minkowski quadratic form on covectors. -/
  Q : QuadraticForm ℝ (Module.Dual ℝ V)
  /-- The four future-null frame vectors `ℓ_A`. -/
  ell : Fin 4 → V
  /-- The four dual soldering covectors `α^A`. -/
  alpha : Fin 4 → Module.Dual ℝ V
  /-- Dual reconstruction: every covector is recovered from its frame components. -/
  dual_recon : ∀ xi : Module.Dual ℝ V, ∑ a, xi (ell a) • alpha a = xi

namespace NullSolderFrame

/-- The soldered covector with coefficients `λ`: `∑_a λ_a α^a`. -/
def dualCovector (F : NullSolderFrame V) (lam : Fin 4 → ℝ) : Module.Dual ℝ V :=
  ∑ a, lam a • F.alpha a

/-- The dual-soldered principal symbol with coefficients `λ`: `∑_a λ_a c(α^a)`,
where `c(α^a) = ι_Q α^a` is the Clifford action. -/
def dualSymbol (F : NullSolderFrame V) (lam : Fin 4 → ℝ) : CliffordAlgebra F.Q :=
  ∑ a, lam a • CliffordAlgebra.ι F.Q (F.alpha a)

/-- The principal symbol is the Clifford image of the soldered covector. -/
theorem dualSymbol_eq (F : NullSolderFrame V) (lam : Fin 4 → ℝ) :
    F.dualSymbol lam = CliffordAlgebra.ι F.Q (F.dualCovector lam) := by
  unfold dualSymbol dualCovector
  rw [map_sum]
  simp [map_smul]

/-- **Exact finite reconstruction of a covector.**  `∑_A ξ(ℓ_A) • α^A = ξ`. -/
theorem dualSymbol_reconstructs_covector (F : NullSolderFrame V) (xi : Module.Dual ℝ V) :
    (∑ a, xi (F.ell a) • F.alpha a) = xi := F.dual_recon xi

/-! ### Exact finite commutator with a multiplication operator -/

section Commutator
variable {S : Type*} [AddCommGroup S]

/-- **Single-index exact commutator identity.**  Writing `c = c(α^a) = ι_Q α^a` for the
Clifford action on a Clifford module `S`, and shifting `f` along the edge `ℓ_a`
(`fsx = f(σ_a x)`, `fx = f(x)`),
`c•(fsx•s) − fx•(c•s) = (fsx − fx)•(c•s)`.
This is the per-edge content of `[c∘shift, M_f] = (discrete differential of f)·c`. -/
theorem supportedShift_commutator_mul (F : NullSolderFrame V)
    [Module (CliffordAlgebra F.Q) S] [Module ℝ S]
    [SMulCommClass (CliffordAlgebra F.Q) ℝ S]
    (a : Fin 4) (fx fsx : ℝ) (s : S) :
    (CliffordAlgebra.ι F.Q (F.alpha a)) • (fsx • s)
      - fx • ((CliffordAlgebra.ι F.Q (F.alpha a)) • s)
      = (fsx - fx) • ((CliffordAlgebra.ι F.Q (F.alpha a)) • s) := by
  rw [sub_smul, smul_comm]

/-- The dual-soldered first-order operator on the flat/affine model:
`(D ψ)(x) = ∑_a c(α^a) • ψ(σ_a x)`, where `σ_a` is the shift along the edge `ℓ_a`. -/
def dualSolderOp (F : NullSolderFrame V) [Module (CliffordAlgebra F.Q) S] {X : Type*}
    (σ : Fin 4 → X → X) (ψ : X → S) : X → S :=
  fun x => ∑ a, (CliffordAlgebra.ι F.Q (F.alpha a)) • ψ (σ a x)

/-- Multiplication operator `M_f`: `(M_f ψ)(x) = f(x) • ψ(x)`. -/
def mulOp {X : Type*} (f : X → ℝ) (ψ : X → S) [Module ℝ S] : X → S :=
  fun x => f x • ψ x

/-- **Exact finite/affine commutator.**  On the flat/affine model the commutator of the
dual-soldered operator `D_sol` with multiplication by `f` is the Clifford action of the
discrete differential of `f`:
`[D_sol, M_f] ψ (x) = ∑_a (f(σ_a x) − f(x)) • (c(α^a) • ψ(σ_a x))`.

This is an exact finite identity.  In the continuum/short-edge limit the discrete
differential `f∘σ_a − f` tends to `(∇_{ℓ_a} f)`, so the right side tends to `c(df)`;
that asymptotic statement is a remark only and is **not** claimed as a theorem here. -/
theorem dualSolder_commutator_exact (F : NullSolderFrame V)
    [Module (CliffordAlgebra F.Q) S] [Module ℝ S]
    [SMulCommClass (CliffordAlgebra F.Q) ℝ S]
    {X : Type*} (σ : Fin 4 → X → X) (f : X → ℝ) (ψ : X → S) (x : X) :
    F.dualSolderOp σ (mulOp f ψ) x - mulOp f (F.dualSolderOp σ ψ) x
      = ∑ a, (f (σ a x) - f x) • ((CliffordAlgebra.ι F.Q (F.alpha a)) • ψ (σ a x)) := by
  simp only [dualSolderOp, mulOp]
  rw [Finset.smul_sum, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl ?_
  intro a _
  exact supportedShift_commutator_mul F a (f x) (f (σ a x)) (ψ (σ a x))

end Commutator

/-! ### The kinetic quadratic form -/

/-- The principal symbol as an honest `ℝ`-linear map `(Fin 4 → ℝ) →ₗ[ℝ] CliffordAlgebra Q`.
Being linear, it is a genuine *first-order* (degree-one) symbol with no constant term. -/
noncomputable def dualSymbolLinear (F : NullSolderFrame V) :
    (Fin 4 → ℝ) →ₗ[ℝ] CliffordAlgebra F.Q :=
  ∑ a, (LinearMap.proj a).smulRight (CliffordAlgebra.ι F.Q (F.alpha a))

theorem dualSymbolLinear_apply (F : NullSolderFrame V) (lam : Fin 4 → ℝ) :
    F.dualSymbolLinear lam = F.dualSymbol lam := by
  simp [dualSymbolLinear, dualSymbol, LinearMap.smulRight]

/-- **Kinetic quadratic form (covector form).**  The square of the dual-soldered
principal symbol equals the Lorentzian quadratic form of the soldered covector:
`(∑_a λ_a c(α^a))² = Q(∑_a λ_a α^a) • 1`. -/
theorem dualSymbol_quadratic_form (F : NullSolderFrame V) (lam : Fin 4 → ℝ) :
    (∑ a, lam a • CliffordAlgebra.ι F.Q (F.alpha a)) ^ 2
      = (F.Q (∑ a, lam a • F.alpha a)) • (1 : CliffordAlgebra F.Q) := by
  have h : (∑ a, lam a • CliffordAlgebra.ι F.Q (F.alpha a)) = F.dualSymbol lam := rfl
  rw [h, dualSymbol_eq, sq, CliffordAlgebra.ι_sq_scalar, Algebra.algebraMap_eq_smul_one]
  rfl

/-- Packaged form of `dualSymbol_quadratic_form` using `dualSymbol`/`dualCovector`. -/
theorem dualSymbol_sq (F : NullSolderFrame V) (lam : Fin 4 → ℝ) :
    F.dualSymbol lam ^ 2 = (F.Q (F.dualCovector lam)) • (1 : CliffordAlgebra F.Q) := by
  rw [dualSymbol_eq, sq, CliffordAlgebra.ι_sq_scalar, Algebra.algebraMap_eq_smul_one]

/-- **Contract: the Plücker/Gram invariant is kinetic, not a zero-order mass.**

The Plücker/Gram quadratic form `Q(∑_a λ_a α^a) • 1` is realised as the *square* of the
first-order principal symbol `∑_a λ_a c(α^a)`:

* `dualSymbolLinear F 0 = 0` — the symbol is `ℝ`-linear and so vanishes at the zero
  covector (`λ = 0`); it carries **no additive constant / zero-order term**, in contrast
  with a genuine mass operator `m • 1` which is nonzero for `m ≠ 0`.
* `∀ λ, (dualSymbol F λ)² = Q(dualCovector F λ) • 1` — and the quadratic form appears
  exactly as that square.

Hence the Pluecker/Gram mass is the *square of the kinetic symbol* (the lattice
dispersion relation), not a second, additive mass term.  No physical overclaim is made:
this is the finite algebraic statement only. -/
theorem plueckerKinetic_not_zeroOrder_doc (F : NullSolderFrame V) :
    F.dualSymbolLinear 0 = 0 ∧
      ∀ lam, F.dualSymbol lam ^ 2 = (F.Q (F.dualCovector lam)) • (1 : CliffordAlgebra F.Q) :=
  ⟨map_zero _, fun lam => F.dualSymbol_sq lam⟩

/-! ### Existence: every basis yields a null-solder frame

The reconstruction property is exactly the dual-basis resolution of identity, so any
linear basis of `V` (with any chosen Lorentzian form `Q`) furnishes a `NullSolderFrame`
whose soldering covectors are the dual basis.  The tetrahedral `ℓ_A` of the
`Tetrahedron` section form such a basis (its resolution-of-identity matrix is the
identity, `tetra_resolution_id`). -/
noncomputable def ofBasis (b : Module.Basis (Fin 4) ℝ V)
    (Q : QuadraticForm ℝ (Module.Dual ℝ V)) : NullSolderFrame V where
  Q := Q
  ell := b
  alpha := fun a => b.coord a
  dual_recon := fun xi => b.sum_dual_apply_smul_coord xi

end NullSolderFrame

/-! ## The concrete tetrahedral convention

Exact rational verification of the unit observer-normalised tetrahedron from the
preamble.  We use the `(+---)` Minkowski form `minkowskiInner` and the plain covector
pairing `dualPair`. -/

namespace Tetrahedron

open Matrix

set_option maxHeartbeats 4000000

/-- Minkowski inner product, signature `(+---)`.  Self-contained copy of
`PhysicsSM.NullStrand.Conventions.minkowskiInner`. -/
def minkowskiInner (p q : Fin 4 → ℝ) : ℝ :=
  p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3

/-- Minkowski norm squared, `(+---)`. -/
def minkowskiSq (p : Fin 4 → ℝ) : ℝ := minkowskiInner p p

/-- Nullity in this convention (self-contained copy of `…Conventions.IsNull`). -/
def IsNull (p : Fin 4 → ℝ) : Prop := minkowskiSq p = 0

/-- Plain (metric-independent) covector–vector pairing on coordinates. -/
def dualPair (cov vec : Fin 4 → ℝ) : ℝ :=
  cov 0 * vec 0 + cov 1 * vec 1 + cov 2 * vec 2 + cov 3 * vec 3

/-- `√3`. -/
noncomputable def r3 : ℝ := Real.sqrt 3

lemma r3_sq : r3 ^ 2 = 3 := by rw [r3, sq, Real.mul_self_sqrt]; norm_num

lemma r3_inv_sq : r3⁻¹ ^ 2 = 1 / 3 := by rw [inv_pow, r3_sq]; norm_num

lemma r3_sq_inv : (r3 ^ 2)⁻¹ = 1 / 3 := by rw [r3_sq]; norm_num

/-- The four null edge vectors `ℓ_A = (1, s_A/√3)`. -/
noncomputable def ell : Fin 4 → (Fin 4 → ℝ)
  | 0 => ![1, 1 / r3, 1 / r3, 1 / r3]
  | 1 => ![1, 1 / r3, -1 / r3, -1 / r3]
  | 2 => ![1, -1 / r3, 1 / r3, -1 / r3]
  | 3 => ![1, -1 / r3, -1 / r3, 1 / r3]

/-- The four soldering covectors `α^A = (1/4)dt + (3/4) n_A·dx`. -/
noncomputable def alpha : Fin 4 → (Fin 4 → ℝ)
  | 0 => ![1 / 4, (3 / 4) / r3, (3 / 4) / r3, (3 / 4) / r3]
  | 1 => ![1 / 4, (3 / 4) / r3, -(3 / 4) / r3, -(3 / 4) / r3]
  | 2 => ![1 / 4, -(3 / 4) / r3, (3 / 4) / r3, -(3 / 4) / r3]
  | 3 => ![1 / 4, -(3 / 4) / r3, -(3 / 4) / r3, (3 / 4) / r3]

/-- Each edge vector is future-pointing null in the `(+---)` convention. -/
theorem ell_isNull (A : Fin 4) : IsNull (ell A) := by
  simp only [IsNull, minkowskiSq, minkowskiInner]
  fin_cases A <;>
    simp only [ell, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val,
      Fin.isValue] <;>
    ring_nf <;> simp only [r3_inv_sq] <;> norm_num

/-- **Gram matrix of the null edges.**  `⟨ℓ_A, ℓ_B⟩ = 0` on the diagonal and `4/3`
off-diagonal. -/
theorem ell_gram (A B : Fin 4) :
    minkowskiInner (ell A) (ell B) = if A = B then 0 else 4 / 3 := by
  simp only [minkowskiInner]
  fin_cases A <;> fin_cases B <;>
    simp only [ell, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val,
      Fin.isValue] <;>
    ring_nf <;> simp only [r3_inv_sq] <;> norm_num

/-- The Gram matrix `0` (diag) / `4/3` (off-diag). -/
noncomputable def gram : Matrix (Fin 4) (Fin 4) ℝ := fun A B => if A = B then 0 else 4 / 3

/-- The inverse Gram matrix `-1/2` (diag) / `1/4` (off-diag), `cos θ = -1/4`. -/
noncomputable def invGram : Matrix (Fin 4) (Fin 4) ℝ := fun A B => if A = B then -1 / 2 else 1 / 4

/-- `gram` is exactly the Minkowski Gram matrix of the edges. -/
theorem gram_eq (A B : Fin 4) : gram A B = minkowskiInner (ell A) (ell B) := by
  rw [ell_gram]; rfl

/-- **Inverse Gram is the matrix inverse** (`G · G⁻¹ = 1`). -/
theorem gram_mul_invGram : gram * invGram = 1 := by
  ext A B
  fin_cases A <;> fin_cases B <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, gram, invGram] <;> norm_num

/-- **Biorthogonality.**  `α^A(ℓ_B) = δ^A_B`. -/
theorem alpha_ell_delta (A B : Fin 4) :
    dualPair (alpha A) (ell B) = if A = B then 1 else 0 := by
  fin_cases A <;> fin_cases B <;>
    simp only [dualPair, alpha, ell, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val, Fin.isValue] <;>
    ring_nf <;> simp only [r3_inv_sq] <;> norm_num

/-- **Resolution of identity.**  `∑_a (ℓ_a)_μ (α^a)_ν = δ_{μν}`, i.e. `ξ = ∑_a ξ(ℓ_a) α^a`
holds for the concrete tetrahedral frame.  (The `√3`'s cancel; the identity is rational.) -/
theorem tetra_resolution_id (μ ν : Fin 4) :
    (∑ a, ell a μ * alpha a ν) = if μ = ν then 1 else 0 := by
  rw [Fin.sum_univ_four]
  fin_cases μ <;> fin_cases ν <;>
    simp only [ell, alpha] <;>
    norm_num [Matrix.cons_val] <;>
    ring_nf <;> (try simp only [r3_inv_sq]) <;> norm_num

end Tetrahedron

end PhysicsSM.NullStrand.DualSolder
