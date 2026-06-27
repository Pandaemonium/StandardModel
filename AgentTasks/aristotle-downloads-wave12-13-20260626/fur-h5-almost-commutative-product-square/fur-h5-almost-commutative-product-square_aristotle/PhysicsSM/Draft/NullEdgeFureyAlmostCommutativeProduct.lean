import Mathlib

/-!
# FUR-H5 — The null-edge / Furey almost-commutative product, reusing the Gate A square

This module is the Aristotle deliverable for proof-chain task **FUR-H5** of the
null-edge unified-mass program.  It assembles the *finite* almost-commutative
spectral-triple **product Dirac operator**

```text
D = i D_N ⊗ 1 + Γ_s ⊗ Φ_H
```

out of two halves:

* an **external** finite null-edge Dirac datum `D_N = ∑_a C_a ∇_a` with the
  spacetime chirality `Γ_s` (the "Gate A" Clifford data), and
* an **internal** Furey/Baez/DVT datum: the internal chirality `χ_E` and the
  internal mass block `Φ_H` (here kept abstract — a *placeholder/interface*, see
  `FureyInternalData`).

and proves that *once a Furey-compatible `Φ_H` satisfies the required
sign/oddness/commutation hypotheses, the square of the product operator is
exactly the existing Gate A finite super-Dirac square specialised to the Furey
internal space.*

## Relation to the upstream Gate A bridge

In the full repository the abstract Gate A finite square lives in
`PhysicsSM.Draft.NullEdgeSuperDiracSignAudit`
(`SuperDirac.CleanSquareHypotheses`, `SuperDirac.super_dirac_square_sum`,
`SuperDirac.graded_square_comm`, `SuperDirac.graded_square_anticomm`), and the
post-Gate-A Lichnerowicz packaging lives in
`PhysicsSM.Draft.NullEdgeFiniteLichnerowiczBridge`.  In *this* project slice
those upstream modules are not present, so to keep the deliverable
self-contained the abstract Gate A square is **re-stated and re-derived here**
(it is pure finite associative-ring algebra) under the identical interface
`CleanSquareHypotheses` / `superDiracSquare`.  Downstream, this file's
`AlmostCommutativeProduct.toCleanSquareHypotheses` and
`product_square_eq_gateA` are exactly the bridge: *the product square is the
Gate A square, with the abstract `Φ` instantiated by the Furey `Φ_H`.*

## Convention map

| task symbol  | Lean object (this file)                              |
| ------------ | ---------------------------------------------------- |
| `D_N`        | `dNsum C nab = ∑ a, C a * nab a`                      |
| `i`          | `Im`, central with `Im² = -1`                         |
| `Γ_s`        | `Gs` (external/spacetime chirality, `Gs² = 1`)       |
| `χ_E`        | `Xe` (internal/Furey chirality, `Xe² = 1`)           |
| `Φ_H`        | `Ph` (internal mass block — abstract placeholder)    |

## The almost-commutative product hypotheses

In a genuine product `A = End(H_ext) ⊗ End(H_int)` with external operators of
the form `X ⊗ 1` and the internal mass block `Φ_H = 1 ⊗ φ`, the cross-factor
commutators

```text
[Γ_s, Φ_H] = 0,   [C_a, Φ_H] = 0,   [∇_a, Φ_H] = 0
```

hold **automatically** (different tensor legs commute).  We keep them as named
hypotheses (`gs_int`, `clifford_int`, `transport_int`) so that the *algebraic
architecture* of the product square is independent of any concrete construction
of `Φ_H`.  This is exactly point 5 of the task: the theorem-level product
architecture is separated from the (here unconstructed) `Φ_H`.

* `[Γ_s, Φ_H] = 0` and `[C_a, Φ_H] = 0` are the Gate A hypotheses `hGsPh`,
  `hCPh`; with them `superDiracSquare` (= Gate A square) applies verbatim.
* `[∇_a, Φ_H] = 0` is the extra *product* hypothesis (`Φ_H` is constant along the
  external null directions).  It makes the Lichnerowicz cross/defect term vanish,
  collapsing the square to the clean `D² = -D_N² + Φ_H²`.

The internal sector carries the genuine Furey sign data: `Φ_H` is `χ_E`-**odd**
(`xe_odd : {χ_E, Φ_H} = 0`), an off-diagonal block on `L ⊕ R`.  Pairing `Φ_H`
with the grading it **commutes** with (`Γ_s`) yields the physical `+Φ_H²`;
pairing it with the grading it is **odd** under (`χ_E`) would give the tachyonic
`-Φ_H²` (`product_sign_dichotomy`).

## Main results

* `CleanSquareHypotheses`, `superDiracSquare` — the abstract Gate A finite
  super-Dirac square (interface mirrored from the upstream sign audit).
* `graded_square_comm`, `graded_square_anticomm` — the abstract `±Φ²` signs.
* `FureyInternalData` — the internal Furey interface/placeholder: an internal
  chirality `χ_E` and a `χ_E`-odd mass block `Φ_H`.  **No construction of `Φ_H`
  is asserted.**
* `AlmostCommutativeProduct` — the assembled product datum and
  `AlmostCommutativeProduct.toCleanSquareHypotheses` exposing it as Gate A data.
* `product_square_eq_gateA` — *the headline*: the product square is exactly the
  Gate A square specialised to the Furey internal `Φ_H`.
* `product_square_clean` — under the product hypothesis `[∇_a, Φ_H] = 0` the
  defect term vanishes: `D² = -D_N² + Φ_H²`.
* `product_sign_dichotomy` — the `(Γ_s Φ_H)² = +Φ_H²` / `(χ_E Φ_H)² = -Φ_H²`
  sign bridge for the Furey internal space.
* `concreteWitness`, `concreteWitness_*` — an explicit non-vacuous instantiation
  on `Matrix (Fin 2) (Fin 2) ℂ` (`Φ_H = σ_x`, `χ_E = σ_z`) where the sign flip is
  genuine (`+1` vs `-1`), confirming the interface is inhabited.

Everything here is finite associative-ring / matrix algebra; no continuum claim,
no small-mesh limit, no Stokes theorem.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdgeFureyAlmostCommutativeProduct

open Finset

/-! ## 1. The abstract Gate A finite super-Dirac square (interface mirror) -/

section AbstractGateA

variable {ι : Type*} [Fintype ι]
variable {A : Type*} [Ring A]

/-- The external null-edge Dirac operator `D_N = ∑_a C_a ∇_a`. -/
def dNsum (C nab : ι → A) : A := ∑ a, C a * nab a

/--
**Gate A clean-square hypotheses** (interface mirrored from the upstream
`SuperDirac.CleanSquareHypotheses`).  With `i` central and `i² = -1`:

* `gs_sq`        : `Γ_s² = 1`;
* `gs_clifford`  : `{Γ_s, C_a} = 0`;
* `gs_transport` : `[Γ_s, ∇_a] = 0`;
* `gs_mass`      : `[Γ_s, Φ] = 0`;
* `clifford_mass`: `[C_a, Φ] = 0`.
-/
structure CleanSquareHypotheses (Im Gs Ph : A) (C nab : ι → A) : Prop where
  im_central : ∀ x : A, Im * x = x * Im
  im_sq : Im * Im = -1
  gs_sq : Gs * Gs = 1
  gs_clifford : ∀ a, Gs * C a = -(C a * Gs)
  gs_transport : ∀ a, Gs * nab a = nab a * Gs
  gs_mass : Gs * Ph = Ph * Gs
  clifford_mass : ∀ a, C a * Ph = Ph * C a

/--
**Abstract Gate A finite super-Dirac square.**  Under `CleanSquareHypotheses`,

```text
(i D_N + Γ_s Φ)² = -D_N² + Φ² - i (Γ_s ∑_a C_a [∇_a, Φ]).
```

This is the self-contained re-derivation of `SuperDirac.super_dirac_square_sum`.
-/
theorem superDiracSquare (Im Gs Ph : A) (C nab : ι → A)
    (h : CleanSquareHypotheses Im Gs Ph C nab) :
    (Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
      = -(dNsum C nab * dNsum C nab) + Ph * Ph
        - Im * (Gs * ∑ a, C a * (nab a * Ph - Ph * nab a)) := by
  simp +decide only [dNsum, mul_add, add_mul];
  simp +decide [ mul_assoc, h.im_central, h.im_sq, h.gs_mass, Finset.mul_sum _ _ _, Finset.sum_mul, mul_sub, sub_mul ];
  simp +decide [ ← mul_assoc, ← Finset.sum_mul, h.gs_mass, h.gs_clifford, h.clifford_mass ] ; abel_nf;
  simp +decide [ mul_assoc, h.gs_mass, h.gs_transport, h.gs_clifford, Finset.sum_mul, h.gs_sq ] ; abel_nf;

/--
**Even (commuting) grading square.**  If `Γ_s² = 1` and `[Γ_s, Φ] = 0` then
`(Γ_s Φ)² = +Φ²`.
-/
theorem graded_square_comm (Gs Ph : A) (hGs2 : Gs * Gs = 1)
    (hGsPh : Gs * Ph = Ph * Gs) :
    (Gs * Ph) * (Gs * Ph) = Ph * Ph := by
  grind +qlia

/--
**Odd (anticommuting) grading square.**  If `Xe² = 1` and `{Xe, Φ} = 0` then
`(Xe Φ)² = -Φ²`.
-/
theorem graded_square_anticomm (Xe Ph : A) (hXe2 : Xe * Xe = 1)
    (hXePh : Xe * Ph = -(Ph * Xe)) :
    (Xe * Ph) * (Xe * Ph) = -(Ph * Ph) := by
  simp_all +decide [ mul_assoc ];
  simp +decide [ ← mul_assoc, hXePh ];
  simp +decide [ mul_assoc, hXe2 ]

end AbstractGateA

/-! ## 2. The Furey internal-space interface (placeholder) -/

section Internal

variable {A : Type*} [Ring A]

/--
**Furey internal-space interface / placeholder.**

The internal half of the almost-commutative spectral triple, recorded as the
*minimal algebraic data* a Furey/Baez/DVT construction must supply:

* `Xe` — the internal chirality `χ_E`, with `xe_sq : χ_E² = 1`;
* `Ph` — the internal mass block `Φ_H`, with
  `xe_odd : {χ_E, Φ_H} = 0` (it is an off-diagonal block on `L ⊕ R`, hence
  `χ_E`-odd).

**No construction of `Φ_H` is asserted here.**  This structure is exactly the
interface against which the product architecture below is proved; a concrete
Furey realisation (minimal left ideal `J = (ℂ⊗𝕆)ω`, ladder operators, the
octonionic mass map) would *implement* it, but that construction is not part of
this file.
-/
structure FureyInternalData (A : Type*) [Ring A] where
  /-- internal chirality `χ_E`. -/
  Xe : A
  /-- internal mass block `Φ_H` (abstract placeholder). -/
  Ph : A
  /-- `χ_E² = 1`. -/
  xe_sq : Xe * Xe = 1
  /-- `Φ_H` is `χ_E`-odd: `{χ_E, Φ_H} = 0`. -/
  xe_odd : Xe * Ph = -(Ph * Xe)

end Internal

/-! ## 3. The assembled almost-commutative product -/

section Product

variable {ι : Type*} [Fintype ι]
variable {A : Type*} [Ring A]

/--
**The null-edge / Furey almost-commutative product datum.**

Bundles the external null-edge Clifford data (`Im`, `Gs`, `C`, `nab`) with a
Furey internal datum (`FureyInternalData`, via `extends`), together with the
**almost-commutative compatibility** hypotheses recording that the internal mass
block commutes with every external operator:

* `gs_int`        : `[Γ_s, Φ_H] = 0`;
* `clifford_int`  : `[C_a, Φ_H] = 0`;
* `transport_int` : `[∇_a, Φ_H] = 0`.

In a genuine tensor product `End(H_ext) ⊗ End(H_int)` (external = `X ⊗ 1`,
internal = `1 ⊗ φ`) all three hold automatically; here they are the only
interface assumptions linking the two sectors.
-/
structure AlmostCommutativeProduct (ι A : Type*) [Fintype ι] [Ring A]
    extends FureyInternalData A where
  /-- central imaginary unit `i`. -/
  Im : A
  /-- external/spacetime chirality `Γ_s`. -/
  Gs : A
  /-- external Clifford generators `C_a`. -/
  C : ι → A
  /-- external null finite-difference operators `∇_a`. -/
  nab : ι → A
  im_central : ∀ x : A, Im * x = x * Im
  im_sq : Im * Im = -1
  gs_sq : Gs * Gs = 1
  gs_clifford : ∀ a, Gs * C a = -(C a * Gs)
  gs_transport : ∀ a, Gs * nab a = nab a * Gs
  /-- almost-commutative: `[Γ_s, Φ_H] = 0`. -/
  gs_int : Gs * Ph = Ph * Gs
  /-- almost-commutative: `[C_a, Φ_H] = 0`. -/
  clifford_int : ∀ a, C a * Ph = Ph * C a
  /-- almost-commutative: `[∇_a, Φ_H] = 0` (the genuine product hypothesis). -/
  transport_int : ∀ a, nab a * Ph = Ph * nab a

namespace AlmostCommutativeProduct

variable (P : AlmostCommutativeProduct ι A)

/-- The product Dirac operator `D = i D_N + Γ_s Φ_H`. -/
def dirac : A := P.Im * dNsum P.C P.nab + P.Gs * P.Ph

/--
The product datum is, in particular, Gate A data: its external Clifford data
together with the internal `Φ_H` satisfies `CleanSquareHypotheses`.  This is the
formal sense in which "the product reuses the Gate A square". -/
def toCleanSquareHypotheses :
    CleanSquareHypotheses P.Im P.Gs P.Ph P.C P.nab where
  im_central := P.im_central
  im_sq := P.im_sq
  gs_sq := P.gs_sq
  gs_clifford := P.gs_clifford
  gs_transport := P.gs_transport
  gs_mass := P.gs_int
  clifford_mass := P.clifford_int

end AlmostCommutativeProduct

/--
**FUR-H5 headline — the product square *is* the Gate A square specialised.**

For any almost-commutative product datum `P`, the square of the product Dirac
operator `D = i D_N + Γ_s Φ_H` equals the abstract Gate A super-Dirac square with
the abstract mass `Φ` instantiated by the Furey internal block `Φ_H`:

```text
D² = -D_N² + Φ_H² - i (Γ_s ∑_a C_a [∇_a, Φ_H]).
```
-/
theorem product_square_eq_gateA (P : AlmostCommutativeProduct ι A) :
    P.dirac * P.dirac
      = -(dNsum P.C P.nab * dNsum P.C P.nab) + P.Ph * P.Ph
        - P.Im * (P.Gs * ∑ a, P.C a * (P.nab a * P.Ph - P.Ph * P.nab a)) := by
  convert superDiracSquare P.Im P.Gs P.Ph P.C P.nab P.toCleanSquareHypotheses using 1

/--
**Clean almost-commutative Lichnerowicz square.**

Using the genuine product hypothesis `[∇_a, Φ_H] = 0` (`transport_int`), the
Lichnerowicz defect term drops and the product square collapses to

```text
D² = -D_N² + Φ_H².
```
-/
theorem product_square_clean (P : AlmostCommutativeProduct ι A) :
    P.dirac * P.dirac = -(dNsum P.C P.nab * dNsum P.C P.nab) + P.Ph * P.Ph := by
  convert product_square_eq_gateA P using 1
  simp [AlmostCommutativeProduct.transport_int]

/--
**Furey internal sign bridge.**  Pairing the internal block `Φ_H` with the
external chirality `Γ_s` it **commutes** with gives the physical `+Φ_H²`;
pairing it with the internal Furey chirality `χ_E` it is **odd** under gives the
tachyonic `-Φ_H²`. -/
theorem product_sign_dichotomy (P : AlmostCommutativeProduct ι A) :
    (P.Gs * P.Ph) * (P.Gs * P.Ph) = P.Ph * P.Ph ∧
      (P.Xe * P.Ph) * (P.Xe * P.Ph) = -(P.Ph * P.Ph) :=
  ⟨graded_square_comm P.Gs P.Ph P.gs_sq P.gs_int,
   graded_square_anticomm P.Xe P.Ph P.xe_sq P.xe_odd⟩

end Product

/-! ## 4. A concrete non-vacuity witness on `Matrix (Fin 2) (Fin 2) ℂ`

The external Clifford data is taken trivial (`ι = PEmpty`, so `D_N = 0`); the
internal Furey data is the explicit chirality-flip block `Φ_H = σ_x` graded by
`χ_E = σ_z`.  This shows the `AlmostCommutativeProduct` interface is inhabited
and that the sign dichotomy is genuine: `(Γ_s Φ_H)² = +1` while
`(χ_E Φ_H)² = -1`.
-/

section Witness

open Matrix

/-- Internal chirality `χ_E = σ_z = diag(1, -1)`. -/
def sigmaZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Internal mass block `Φ_H = σ_x = antidiag(1, 1)`. -/
def sigmaX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- The explicit Furey-style internal datum `χ_E = σ_z`, `Φ_H = σ_x`. -/
def concreteInternal : FureyInternalData (Matrix (Fin 2) (Fin 2) ℂ) where
  Xe := sigmaZ
  Ph := sigmaX
  xe_sq := by simp only [sigmaZ]; ext i j; fin_cases i <;> fin_cases j <;> simp
  xe_odd := by
    simp only [sigmaZ, sigmaX]; ext i j; fin_cases i <;> fin_cases j <;> simp

/-- The explicit almost-commutative product with trivial external data. -/
def concreteWitness : AlmostCommutativeProduct PEmpty (Matrix (Fin 2) (Fin 2) ℂ) where
  toFureyInternalData := concreteInternal
  Im := Complex.I • (1 : Matrix (Fin 2) (Fin 2) ℂ)
  Gs := 1
  C := fun e => e.elim
  nab := fun e => e.elim
  im_central := by intro x; simp
  im_sq := by rw [smul_mul_smul_comm]; simp [Complex.I_mul_I]
  gs_sq := by simp
  gs_clifford := by rintro ⟨⟩
  gs_transport := by rintro ⟨⟩
  gs_int := by simp
  clifford_int := by rintro ⟨⟩
  transport_int := by rintro ⟨⟩

/-- In the concrete witness the clean square reads `D² = Φ_H² = σ_x² = 1`. -/
theorem concreteWitness_square :
    concreteWitness.dirac * concreteWitness.dirac = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ concreteWitness, AlmostCommutativeProduct.dirac, dNsum ] ;
  · simp +decide [ Matrix.mul_apply, concreteInternal ];
    norm_num [ sigmaX ];
  · simp +decide [ concreteInternal, sigmaX, Matrix.mul_apply ];
  · simp +decide [ concreteInternal, sigmaX ];
  · simp +decide [ concreteInternal, sigmaX ]

/-- In the concrete witness the sign flip is genuine: `+1` vs `-1`. -/
theorem concreteWitness_sign_flip :
    (concreteWitness.Gs * concreteWitness.Ph) * (concreteWitness.Gs * concreteWitness.Ph) = 1 ∧
      (concreteWitness.Xe * concreteWitness.Ph) * (concreteWitness.Xe * concreteWitness.Ph) = -1 := by
  -- By definition of `concreteWitness`, we know that `concreteWitness.Gs = 1`.
  simp [concreteWitness];
  simp +decide [ concreteInternal ];
  norm_num [ ← Matrix.one_fin_two, ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply, sigmaX, sigmaZ ]

end Witness

end NullEdgeFureyAlmostCommutativeProduct
end Draft
end PhysicsSM
