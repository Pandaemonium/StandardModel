import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldPurity
import PhysicsSM.Algebra.Octonion.SpinorFierz

/-!
# Spinor.SpinorTenfoldOctonionBridge

**Definitions** for the explicit bridge between the two `D = 10` spinor
models of this repository:

- the **bioctonionic model** of `PhysicsSM.Algebra.Octonion.SpinorFierz`
  (`COctSpinor = (ℂ ⊗ 𝕆)²`, `CHermVector`, `hermActionC`,
  `hermTraceRevC`, `spinorSquareC`), and
- the **Fock model** of `PhysicsSM.Spinor.SpinorTenfoldFock`
  (`FockSpinor = Finset (Fin 5) → ℂ`, `V10`, `cliffordAction`).

This module contains only definitions, algebraic instances, and lemmas with
complete proofs; the bridge *theorems* (intertwining, inverse identities,
the quadric bridge, the Fierz transport) are Aristotle targets in
`PhysicsSM.Draft.SpinorTenfoldOctonionBridgeAristotle`.

## The bridge, in outline

1. `iotaV : V10 → CHermVector` sends the hyperbolic basis to null
   bioctonionic vectors: `e₄ ↦ (0, -1, 0)`, `f₄ ↦ (1, 0, 0)`, and for
   `j ∈ {0,1,2,3}` with the **unit pairing** `(p_j, q_j) = (j, 7 - j)`
   (octonion labels in the project XOR convention, `q = p XOR 111`):

     `e_j ↦ (0, 0, (e_{p_j} - i e_{q_j})/2)`,
     `f_j ↦ (0, 0, (e_{p_j} + i e_{q_j})/2)`.

   This matches the bilinear forms: the polarization of
   `N(A) = normSqC A.y - A.a * A.b` pulls back to `B10`.
2. `octImage S : COctSpinor` is the image of the Fock basis state
   `basisSpinor S`. Each image is a *single signed unit bioctonion*
   `±e_p ± i·e_q` in one slot — the table below is generated and fully
   verified (exact Gaussian-rational arithmetic) by the oracle
   `Scripts/oracle/validate_bioctonion_fock_bridge.py`, which constructs
   `octImage` by applying creation operators to the unique joint kernel of
   the five annihilation operators `hermActionC (iotaV f_j)`.
3. `fockToOct ψ = Σ_S ψ S • octImage S` is the bridge, and
   `octToFockEven` / `octToFockOdd` are its two chirality-restricted
   inverses (rows from the inverted basis matrix, denominators only `2`).

## Chirality convention

The Fock model is realized on the chirality copy in which the *plain*
`hermActionC` of the annihilation null vectors kills the vacuum. With this
convention the intended intertwining statements (Aristotle targets) are

- even `ψ`:  `fockToOct (cliffordAction v ψ) = hermActionC (iotaV v) (fockToOct ψ)`,
- odd `ψ`:   `fockToOct (cliffordAction v ψ) = hermActionC (hermTraceRevC (iotaV v)) (fockToOct ψ)`,

and the vector-valued bilinears match through one trace reversal:
`spinorSquareC (fockToOct ψ) = 2 • hermTraceRevC (iotaV (gammaBilinear ψ ψ))`
on even `ψ` (the oracle-determined constant is exactly `2`).

## Sources

- Baez, Huerta, "Division algebras and supersymmetry I", arXiv:0909.0551.
- Chevalley, "The Algebraic Theory of Spinors" (the Fock construction).
- Oracle: `Scripts/oracle/validate_bioctonion_fock_bridge.py` (exact
  arithmetic; all data below is machine-generated from it).
- Provenance: clean-room construction; the oracle pins the definitions and
  signs, the Lean proofs are kernel-checked from the definitions.

Status: trusted definitions — no `sorry`. Theorems live in the draft
module until proved.
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinorTenfoldOctonionBridge

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Octonion.ComplexOctonion

/-! ## Algebraic instances for `COctSpinor`

`PhysicsSM.Algebra.Octonion.SpinorFierz` defines only `Zero`, `Add`, and
`SMul ℂ` on `COctSpinor`; the bridge needs finite sums, so we upgrade to
`AddCommGroup` and `Module ℂ`, delegating componentwise to the
`ComplexOctonion` instances (same pattern as
`PhysicsSM.Algebra.Octonion.ComplexOctonion`). -/

instance : Neg COctSpinor := ⟨fun ψ => ⟨-ψ.fst, -ψ.snd⟩⟩

@[simp] theorem COctSpinor.neg_fst (ψ : COctSpinor) : (-ψ).fst = -ψ.fst := rfl
@[simp] theorem COctSpinor.neg_snd (ψ : COctSpinor) : (-ψ).snd = -ψ.snd := rfl

instance : AddCommGroup COctSpinor where
  add_assoc a b c := by ext1 <;> simp [add_assoc]
  zero_add a := by ext1 <;> simp
  add_zero a := by ext1 <;> simp
  add_comm a b := by ext1 <;> simp [add_comm]
  neg_add_cancel a := by ext1 <;> simp
  nsmul := nsmulRec
  zsmul := zsmulRec

instance : Module ℂ COctSpinor where
  one_smul ψ := by ext1 <;> simp
  mul_smul z w ψ := by ext1 <;> simp [mul_smul]
  smul_zero z := by ext1 <;> simp
  smul_add z ψ φ := by ext1 <;> simp
  add_smul z w ψ := by ext1 <;> simp [add_smul]
  zero_smul ψ := by ext1 <;> simp

/-! ## Algebraic instances for `CHermVector` -/

instance : Zero CHermVector := ⟨⟨0, 0, 0⟩⟩

@[simp] theorem CHermVector.zero_a : (0 : CHermVector).a = 0 := rfl
@[simp] theorem CHermVector.zero_b : (0 : CHermVector).b = 0 := rfl
@[simp] theorem CHermVector.zero_y : (0 : CHermVector).y = 0 := rfl

instance : Add CHermVector := ⟨fun A B => ⟨A.a + B.a, A.b + B.b, A.y + B.y⟩⟩

@[simp] theorem CHermVector.add_a (A B : CHermVector) : (A + B).a = A.a + B.a := rfl
@[simp] theorem CHermVector.add_b (A B : CHermVector) : (A + B).b = A.b + B.b := rfl
@[simp] theorem CHermVector.add_y (A B : CHermVector) : (A + B).y = A.y + B.y := rfl

instance : Neg CHermVector := ⟨fun A => ⟨-A.a, -A.b, -A.y⟩⟩

@[simp] theorem CHermVector.neg_a (A : CHermVector) : (-A).a = -A.a := rfl
@[simp] theorem CHermVector.neg_b (A : CHermVector) : (-A).b = -A.b := rfl
@[simp] theorem CHermVector.neg_y (A : CHermVector) : (-A).y = -A.y := rfl

instance : SMul ℂ CHermVector := ⟨fun z A => ⟨z * A.a, z * A.b, z • A.y⟩⟩

@[simp] theorem CHermVector.smul_a (z : ℂ) (A : CHermVector) : (z • A).a = z * A.a := rfl
@[simp] theorem CHermVector.smul_b (z : ℂ) (A : CHermVector) : (z • A).b = z * A.b := rfl
@[simp] theorem CHermVector.smul_y (z : ℂ) (A : CHermVector) : (z • A).y = z • A.y := rfl

instance : AddCommGroup CHermVector where
  add_assoc a b c := by ext1 <;> simp [add_assoc]
  zero_add a := by ext1 <;> simp
  add_zero a := by ext1 <;> simp
  add_comm a b := by ext1 <;> simp [add_comm]
  neg_add_cancel a := by ext1 <;> simp
  nsmul := nsmulRec
  zsmul := zsmulRec

instance : Module ℂ CHermVector where
  one_smul A := by ext1 <;> simp
  mul_smul z w A := by ext1 <;> simp [mul_smul, mul_assoc]
  smul_zero z := by ext1 <;> simp
  smul_add z A B := by ext1 <;> simp [mul_add]
  add_smul z w A := by ext1 <;> simp [add_mul, add_smul]
  zero_smul A := by ext1 <;> simp

/-! ## Complex coordinates of a bioctonion

`ComplexOctonion` stores a pair of real octonions `re + i·im`; the `k`-th
complex coordinate is `z_k = re.c_k + i·im.c_k`. These are the `ℂ`-linear
coordinate functionals used by the inverse bridge. -/

/-- The eight complex coordinates of a bioctonion. -/
def coordC (x : ComplexOctonion) : Fin 8 → ℂ :=
  ![⟨x.re.c0, x.im.c0⟩, ⟨x.re.c1, x.im.c1⟩, ⟨x.re.c2, x.im.c2⟩,
    ⟨x.re.c3, x.im.c3⟩, ⟨x.re.c4, x.im.c4⟩, ⟨x.re.c5, x.im.c5⟩,
    ⟨x.re.c6, x.im.c6⟩, ⟨x.re.c7, x.im.c7⟩]

/-! ## The null-vector bridge `iotaV : V10 → CHermVector` -/

/-- The image of the creation basis vector `e_j`: a null bioctonionic
vector. For `j < 4` this is `(e_j - i e_{7-j})/2` in the off-diagonal slot;
`e₄` goes to the diagonal `(0, -1, 0)`. -/
def nullVecE (j : Fin 5) : CHermVector :=
  match j with
  | 0 => ⟨0, 0, ⟨⟨(1/2 : ℝ), 0, 0, 0, 0, 0, 0, 0⟩, ⟨0, 0, 0, 0, 0, 0, 0, -(1/2 : ℝ)⟩⟩⟩
  | 1 => ⟨0, 0, ⟨⟨0, (1/2 : ℝ), 0, 0, 0, 0, 0, 0⟩, ⟨0, 0, 0, 0, 0, 0, -(1/2 : ℝ), 0⟩⟩⟩
  | 2 => ⟨0, 0, ⟨⟨0, 0, (1/2 : ℝ), 0, 0, 0, 0, 0⟩, ⟨0, 0, 0, 0, 0, -(1/2 : ℝ), 0, 0⟩⟩⟩
  | 3 => ⟨0, 0, ⟨⟨0, 0, 0, (1/2 : ℝ), 0, 0, 0, 0⟩, ⟨0, 0, 0, 0, -(1/2 : ℝ), 0, 0, 0⟩⟩⟩
  | 4 => ⟨0, -1, 0⟩

/-- The image of the annihilation basis vector `f_j`: the conjugate null
vector `(e_j + i e_{7-j})/2` for `j < 4`; `f₄` goes to `(1, 0, 0)`. -/
def nullVecF (j : Fin 5) : CHermVector :=
  match j with
  | 0 => ⟨0, 0, ⟨⟨(1/2 : ℝ), 0, 0, 0, 0, 0, 0, 0⟩, ⟨0, 0, 0, 0, 0, 0, 0, (1/2 : ℝ)⟩⟩⟩
  | 1 => ⟨0, 0, ⟨⟨0, (1/2 : ℝ), 0, 0, 0, 0, 0, 0⟩, ⟨0, 0, 0, 0, 0, 0, (1/2 : ℝ), 0⟩⟩⟩
  | 2 => ⟨0, 0, ⟨⟨0, 0, (1/2 : ℝ), 0, 0, 0, 0, 0⟩, ⟨0, 0, 0, 0, 0, (1/2 : ℝ), 0, 0⟩⟩⟩
  | 3 => ⟨0, 0, ⟨⟨0, 0, 0, (1/2 : ℝ), 0, 0, 0, 0⟩, ⟨0, 0, 0, 0, (1/2 : ℝ), 0, 0, 0⟩⟩⟩
  | 4 => ⟨1, 0, 0⟩

/-- The vector bridge: the `ℂ`-linear extension of the null-vector
assignment. Pulls the bioctonionic quadratic form
`N(A) = normSqC A.y - A.a * A.b` back to `Q10` (Aristotle target
`Q10_iotaV` in the draft module). -/
def iotaV (v : V10) : CHermVector :=
  (∑ j, v.1 j • nullVecE j) + (∑ j, v.2 j • nullVecF j)

/-! ## The spinor bridge table

Machine-generated by `Scripts/oracle/validate_bioctonion_fock_bridge.py`
(do not edit by hand; regenerate from the oracle if a convention changes).
`octImage S` is the bioctonionic image of `basisSpinor S`. -/

/-- The bioctonionic image of the Fock basis state `basisSpinor S`. -/
def octImage (S : Finset (Fin 5)) : COctSpinor :=
  if S = (∅ : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 1, 0, 0, 0⟩, ⟨0, 0, 0, -1, 0, 0, 0, 0⟩⟩⟩
  else if S = ({0} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 1, 0, 0, 0⟩, ⟨0, 0, 0, -1, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({1} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, -1, 0, 0⟩, ⟨0, 0, 1, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({2} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, 0, 1, 0⟩, ⟨0, -1, 0, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({3} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, 0, 0, -1⟩, ⟨1, 0, 0, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({4} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, -1, 0, 0, 0⟩, ⟨0, 0, 0, 1, 0, 0, 0, 0⟩⟩⟩
  else if S = ({0, 1} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, -1, 0, 0⟩, ⟨0, 0, 1, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({0, 2} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, 0, 1, 0⟩, ⟨0, -1, 0, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({0, 3} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, 0, 0, -1⟩, ⟨1, 0, 0, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({0, 4} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, -1, 0, 0, 0⟩, ⟨0, 0, 0, 1, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({1, 2} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, 0, 0, -1⟩, ⟨-1, 0, 0, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({1, 3} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, 0, -1, 0⟩, ⟨0, -1, 0, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({1, 4} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, 1, 0, 0⟩, ⟨0, 0, -1, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({2, 3} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, -1, 0, 0⟩, ⟨0, 0, -1, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({2, 4} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, 0, -1, 0⟩, ⟨0, 1, 0, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({3, 4} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, 0, 0, 1⟩, ⟨-1, 0, 0, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({0, 1, 2} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, 0, 0, -1⟩, ⟨-1, 0, 0, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({0, 1, 3} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, 0, -1, 0⟩, ⟨0, -1, 0, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({0, 1, 4} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, 1, 0, 0⟩, ⟨0, 0, -1, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({0, 2, 3} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, -1, 0, 0⟩, ⟨0, 0, -1, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({0, 2, 4} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, 0, -1, 0⟩, ⟨0, 1, 0, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({0, 3, 4} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, 0, 0, 1⟩, ⟨-1, 0, 0, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({1, 2, 3} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, -1, 0, 0, 0⟩, ⟨0, 0, 0, -1, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({1, 2, 4} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, 0, 0, 1⟩, ⟨1, 0, 0, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({1, 3, 4} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, 0, 1, 0⟩, ⟨0, 1, 0, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({2, 3, 4} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 0, 1, 0, 0⟩, ⟨0, 0, 1, 0, 0, 0, 0, 0⟩⟩⟩
  else if S = ({0, 1, 2, 3} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, -1, 0, 0, 0⟩, ⟨0, 0, 0, -1, 0, 0, 0, 0⟩⟩⟩
  else if S = ({0, 1, 2, 4} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, 0, 0, 1⟩, ⟨1, 0, 0, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({0, 1, 3, 4} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, 0, 1, 0⟩, ⟨0, 1, 0, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({0, 2, 3, 4} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 0, 1, 0, 0⟩, ⟨0, 0, 1, 0, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({1, 2, 3, 4} : Finset (Fin 5)) then ⟨⟨⟨0, 0, 0, 0, 1, 0, 0, 0⟩, ⟨0, 0, 0, 1, 0, 0, 0, 0⟩⟩, 0⟩
  else if S = ({0, 1, 2, 3, 4} : Finset (Fin 5)) then ⟨0, ⟨⟨0, 0, 0, 0, 1, 0, 0, 0⟩, ⟨0, 0, 0, 1, 0, 0, 0, 0⟩⟩⟩
  else 0

/-! ## The bridge and its chirality-restricted inverses -/

/-- **The bridge**: the `ℂ`-linear extension of `basisSpinor S ↦ octImage S`.
Restricted to even (resp. odd) spinors it is a linear isomorphism onto
`COctSpinor`; the two restrictions realize the two half-spin
representations on the same bioctonionic carrier. -/
def fockToOct (ψ : FockSpinor) : COctSpinor :=
  ∑ S : Finset (Fin 5), ψ S • octImage S

/-- The inverse of the bridge on **even** spinors (rows of the inverted
basis matrix; machine-generated, do not edit by hand). -/
def octToFockEven (φ : COctSpinor) : FockSpinor := fun S =>
  if S = (∅ : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.snd 3 + (⟨1/2, 0⟩ : ℂ) * coordC φ.snd 4
  else if S = ({0, 1} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.snd 2 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.snd 5
  else if S = ({0, 2} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.snd 1 + (⟨1/2, 0⟩ : ℂ) * coordC φ.snd 6
  else if S = ({0, 3} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.snd 0 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.snd 7
  else if S = ({0, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.fst 3 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.fst 4
  else if S = ({1, 2} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.snd 0 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.snd 7
  else if S = ({1, 3} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.snd 1 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.snd 6
  else if S = ({1, 4} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.fst 2 + (⟨1/2, 0⟩ : ℂ) * coordC φ.fst 5
  else if S = ({2, 3} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.snd 2 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.snd 5
  else if S = ({2, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.fst 1 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.fst 6
  else if S = ({3, 4} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.fst 0 + (⟨1/2, 0⟩ : ℂ) * coordC φ.fst 7
  else if S = ({0, 1, 2, 3} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.snd 3 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.snd 4
  else if S = ({0, 1, 2, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.fst 0 + (⟨1/2, 0⟩ : ℂ) * coordC φ.fst 7
  else if S = ({0, 1, 3, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.fst 1 + (⟨1/2, 0⟩ : ℂ) * coordC φ.fst 6
  else if S = ({0, 2, 3, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.fst 2 + (⟨1/2, 0⟩ : ℂ) * coordC φ.fst 5
  else if S = ({1, 2, 3, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.fst 3 + (⟨1/2, 0⟩ : ℂ) * coordC φ.fst 4
  else 0

/-- The inverse of the bridge on **odd** spinors (machine-generated, do not
edit by hand). -/
def octToFockOdd (φ : COctSpinor) : FockSpinor := fun S =>
  if S = ({0} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.fst 3 + (⟨1/2, 0⟩ : ℂ) * coordC φ.fst 4
  else if S = ({1} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.fst 2 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.fst 5
  else if S = ({2} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.fst 1 + (⟨1/2, 0⟩ : ℂ) * coordC φ.fst 6
  else if S = ({3} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.fst 0 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.fst 7
  else if S = ({4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.snd 3 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.snd 4
  else if S = ({0, 1, 2} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.fst 0 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.fst 7
  else if S = ({0, 1, 3} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.fst 1 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.fst 6
  else if S = ({0, 1, 4} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.snd 2 + (⟨1/2, 0⟩ : ℂ) * coordC φ.snd 5
  else if S = ({0, 2, 3} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.fst 2 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.fst 5
  else if S = ({0, 2, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.snd 1 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.snd 6
  else if S = ({0, 3, 4} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.snd 0 + (⟨1/2, 0⟩ : ℂ) * coordC φ.snd 7
  else if S = ({1, 2, 3} : Finset (Fin 5)) then (⟨0, 1/2⟩ : ℂ) * coordC φ.fst 3 + (⟨-1/2, 0⟩ : ℂ) * coordC φ.fst 4
  else if S = ({1, 2, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.snd 0 + (⟨1/2, 0⟩ : ℂ) * coordC φ.snd 7
  else if S = ({1, 3, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.snd 1 + (⟨1/2, 0⟩ : ℂ) * coordC φ.snd 6
  else if S = ({2, 3, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.snd 2 + (⟨1/2, 0⟩ : ℂ) * coordC φ.snd 5
  else if S = ({0, 1, 2, 3, 4} : Finset (Fin 5)) then (⟨0, -1/2⟩ : ℂ) * coordC φ.snd 3 + (⟨1/2, 0⟩ : ℂ) * coordC φ.snd 4
  else 0

/-! ## Elementary lemmas (proved here) -/

/-- All complex coordinates of the zero bioctonion vanish. -/
@[simp] theorem coordC_zero (k : Fin 8) : coordC (0 : ComplexOctonion) k = 0 := by
  fin_cases k <;> simp [coordC, Complex.ext_iff]

/-- The even inverse sends `0` to `0`. -/
@[simp] theorem octToFockEven_zero : octToFockEven (0 : COctSpinor) = 0 := by
  funext S
  unfold octToFockEven
  simp

/-- The odd inverse sends `0` to `0`. -/
@[simp] theorem octToFockOdd_zero : octToFockOdd (0 : COctSpinor) = 0 := by
  funext S
  unfold octToFockOdd
  simp

/-- The bridge sends basis spinors to their table images. -/
theorem fockToOct_basisSpinor (T : Finset (Fin 5)) :
    fockToOct (basisSpinor T) = octImage T := by
  unfold fockToOct
  rw [Finset.sum_eq_single T]
  · rw [basisSpinor_self, one_smul]
  · intro S _ hST
    rw [basisSpinor_ne T S hST, zero_smul]
  · intro h
    exact absurd (Finset.mem_univ T) h

/-- The bridge is additive. -/
theorem fockToOct_add (ψ φ : FockSpinor) :
    fockToOct (ψ + φ) = fockToOct ψ + fockToOct φ := by
  unfold fockToOct
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun S _ => ?_
  rw [Pi.add_apply, add_smul]

/-- The bridge commutes with scalars. -/
theorem fockToOct_smul (c : ℂ) (ψ : FockSpinor) :
    fockToOct (c • ψ) = c • fockToOct ψ := by
  unfold fockToOct
  rw [Finset.smul_sum]
  refine Finset.sum_congr rfl fun S _ => ?_
  rw [Pi.smul_apply, smul_smul, smul_eq_mul]

/-- The bridge of the zero spinor. -/
@[simp] theorem fockToOct_zero : fockToOct (0 : FockSpinor) = 0 := by
  unfold fockToOct
  refine Finset.sum_eq_zero fun S _ => ?_
  rw [Pi.zero_apply, zero_smul]

end PhysicsSM.Spinor.SpinorTenfoldOctonionBridge

end
