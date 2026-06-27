import Mathlib

/-!
# Finite tetrad-postulate frame-term vanishing theorem

This file is the Aristotle deliverable for proof-chain task **T15** of the
null-edge unified mass program (see `PROMPT.md`, `docs/NULLSTRAND.md` and
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` §15, §17).

This is **finite algebra**, not a continuum claim.  We model the finite
null-edge operators `C_a = c(α^a)` (Clifford / dual-soldered symbols) and the
finite transports / connections `∇_a` as elements of an arbitrary, possibly
non-commutative, `Ring R`, indexed by a finite type `ι`.

The central object is the finite null Dirac operator
`D_N = ∑_a C_a ∇_a` and its square.  Following the sign / decomposition
convention fixed in `docs/NULLSTRAND.md`:

```text
D_N      = ∑_a C_a ∇_a
D_N²     = Box_null + C_diamond + T_frame
Box_null = ¼ ∑_{a,b} {C_a, C_b} {∇_a, ∇_b}
C_diamond= ¼ ∑_{a,b} [C_a, C_b] [∇_a, ∇_b]
T_frame  = ∑_{a,b} C_a [∇_a, C_b] ∇_b
```

The **finite tetrad postulate** is the edge-transport compatibility equation
`[∇_a, C_b] = 0` for all `a, b`.  The main theorem `frame_term_vanishes`
shows that under this postulate the frame/tetrad defect term `T_frame`
vanishes identically.

## Guardrails (see `docs/NULLSTRAND.md`)

* The vanishing is a *finite* identity; it removes the frame defect term from
  the square **only when the finite tetrad-postulate hypothesis genuinely
  holds**.
* The theorem therefore prevents hidden `O(h⁻¹)` frame contamination *only*
  under that hypothesis.  If the frame varies but transport does not carry it
  compatibly (i.e. `[∇_a, C_b] ≠ 0`), the hypothesis fails and the defect must
  be *classified* (nonmetricity / curvature-holonomy / torsion-like /
  smooth-limit contamination) rather than hidden.  That classification is
  out of scope for this finite-algebra file; see the report.
-/

namespace PhysicsSM
namespace Draft

open Finset

section FrameTerm

variable {ι : Type*} [Fintype ι]
variable {R : Type*} [Ring R]
variable (C nab : ι → R)

/-- Finite commutator of the transport `∇_a` with the frame symbol `C_b`,
i.e. `[∇_a, C_b]`.  The finite tetrad postulate asserts this is `0`. -/
def frameComm (a b : ι) : R := nab a * C b - C b * nab a

/-- The frame/tetrad defect term `T_frame = ∑_{a,b} C_a [∇_a, C_b] ∇_b`. -/
def Tframe : R := ∑ a, ∑ b, C a * frameComm C nab a b * nab b

/-- The combined kinetic + curvature block `∑_{a,b} C_a C_b ∇_a ∇_b`.
This is `Box_null + C_diamond` (proved in `boxnull_add_cdiamond` below). -/
def Kplus : R := ∑ a, ∑ b, C a * C b * (nab a * nab b)

/-- The finite null Dirac operator `D_N = ∑_a C_a ∇_a`. -/
def DN : R := ∑ a, C a * nab a

/-
**Frame/tetrad-postulate theorem (T15).**
Under the finite tetrad postulate `[∇_a, C_b] = 0` for all `a, b`, the
frame/tetrad defect term `T_frame` vanishes identically.
-/
theorem frame_term_vanishes (h : ∀ a b, frameComm C nab a b = 0) :
    Tframe C nab = 0 := by
      exact Finset.sum_eq_zero fun i hi => Finset.sum_eq_zero fun j hj => by simp +decide [ h i j ] ;

/-
The finite square decomposition `D_N² = Kplus + T_frame`, where
`Kplus = ∑_{a,b} C_a C_b ∇_a ∇_b` is the combined kinetic + curvature block.
This holds for arbitrary (non-commuting) `C` and `∇`.
-/
theorem dirac_square_decomp :
    (DN C nab) ^ 2 = Kplus C nab + Tframe C nab := by
      unfold DN Kplus Tframe;
      simp +decide [ sq, mul_assoc, Finset.mul_sum, Finset.sum_mul ];
      simp +decide [ ← mul_assoc, ← Finset.sum_add_distrib, frameComm ];
      exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by simp +decide [ mul_sub, sub_mul, mul_assoc ] )

/-
Under the finite tetrad postulate the square reduces to the combined
kinetic + curvature block, with the frame defect removed:
`D_N² = Kplus`.
-/
theorem dirac_square_of_tetrad (h : ∀ a b, frameComm C nab a b = 0) :
    (DN C nab) ^ 2 = Kplus C nab := by
      grind +suggestions

end FrameTerm

section SymmetricSplit

variable {ι : Type*} [Fintype ι]
variable {R : Type*} [Ring R] [Invertible (4 : R)]
variable (C nab : ι → R)

/-- The symmetric "null box" block
`Box_null = ¼ ∑_{a,b} {C_a, C_b} {∇_a, ∇_b}`. -/
def Boxnull : R :=
  ⅟(4 : R) * ∑ a, ∑ b, (C a * C b + C b * C a) * (nab a * nab b + nab b * nab a)

/-- The antisymmetric "curvature/Pauli" block
`C_diamond = ¼ ∑_{a,b} [C_a, C_b] [∇_a, ∇_b]`. -/
def Cdiamond : R :=
  ⅟(4 : R) * ∑ a, ∑ b, (C a * C b - C b * C a) * (nab a * nab b - nab b * nab a)

/-
The symmetric/antisymmetric split recombines to the combined block:
`Box_null + C_diamond = Kplus`.
-/
theorem boxnull_add_cdiamond :
    Boxnull C nab + Cdiamond C nab = Kplus C nab := by
      unfold Boxnull Cdiamond Kplus;
      simp +decide only [mul_add, add_mul, sum_add_distrib, mul_sub, sub_mul, sum_sub_distrib];
      rw [ Finset.sum_comm ] ; abel_nf;
      simp +decide [ ← mul_assoc, ← Finset.sum_mul ]

/-
**Full finite square decomposition** in the `Box_null`/`C_diamond`/`T_frame`
convention of `docs/NULLSTRAND.md`:
`D_N² = Box_null + C_diamond + T_frame`.
-/
theorem dirac_square_full_decomp :
    (DN C nab) ^ 2 = Boxnull C nab + Cdiamond C nab + Tframe C nab := by
      rw [ dirac_square_decomp, boxnull_add_cdiamond ]

/-
Under the finite tetrad postulate the full square loses its frame defect:
`D_N² = Box_null + C_diamond`.
-/
theorem dirac_square_full_of_tetrad (h : ∀ a b, frameComm C nab a b = 0) :
    (DN C nab) ^ 2 = Boxnull C nab + Cdiamond C nab := by
      convert dirac_square_full_decomp C nab using 1;
      rw [ frame_term_vanishes C nab h, add_zero ]

end SymmetricSplit

end Draft
end PhysicsSM
