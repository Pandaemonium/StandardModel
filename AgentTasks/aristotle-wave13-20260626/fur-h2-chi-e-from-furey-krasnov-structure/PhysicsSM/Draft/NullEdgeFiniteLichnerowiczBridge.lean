import Mathlib
import PhysicsSM.Draft.NullEdgeFiniteTetradPostulate
import PhysicsSM.Draft.NullEdgeSuperDiracSignAudit

/-!
# B17 — Post-Gate-A finite dual-soldered Lichnerowicz square

This module is the Aristotle deliverable for proof-chain task **B17** of the
null-edge unified-mass program.  It assembles the finite, dual-soldered
null-edge **generalized Lichnerowicz formula** by gluing two already-integrated
finite-algebra layers:

* the **finite square decomposition** of the null Dirac operator
  `D_N = ∑_a C_a ∇_a` from
  `PhysicsSM.Draft.NullEdgeFiniteTetradPostulate`
  (`dirac_square_full_decomp`), and
* the **Gate A super-Dirac sign square** for the full operator
  `D = i D_N + Γ_s Φ_H` from
  `PhysicsSM.Draft.NullEdgeSuperDiracSignAudit`
  (`super_dirac_square_sum`, `graded_square_comm`, `graded_square_anticomm`,
  `CleanSquareHypotheses`).

Everything here is **finite associative-ring / matrix algebra**; no continuum
claim, no small-mesh limit, no Stokes theorem.

## Target shape (task statement)

```text
D_N        = ∑_a C_a ∇_a
D_N²       = K_null + C_diamond + T_frame
K_null     = ¼ ∑_{a,b} {C_a, C_b} {∇_a, ∇_b}
C_diamond  = ¼ ∑_{a,b} [C_a, C_b] [∇_a, ∇_b]
T_frame    = ∑_{a,b} C_a [∇_a, C_b] ∇_b

D          = i D_N + Γ_s Φ_H
D²         = -K_null - C_diamond - T_frame + Φ_H²
             - i Γ_s ∑_a C_a [∇_a, Φ_H]
```

## Convention map to the existing Lean definitions

The repository already fixes these objects (do **not** introduce parallel
copies):

| task symbol  | Lean definition (this repo)                          |
| ------------ | ---------------------------------------------------- |
| `D_N`        | `SuperDirac.dNsum C nab = PhysicsSM.Draft.DN C nab` (defeq, `∑ a, C a * nab a`) |
| `K_null`     | `PhysicsSM.Draft.Boxnull C nab` (the `¼ {C,C}{∇,∇}` block) |
| `C_diamond`  | `PhysicsSM.Draft.Cdiamond C nab`                     |
| `T_frame`    | `PhysicsSM.Draft.Tframe C nab`                       |
| `i`          | central `Im` with `Im² = -1`                         |
| `Γ_s`        | `Gs` (spacetime chirality, `Gs² = 1`)               |
| `Φ_H`        | `Ph`                                                 |

So the existing `Boxnull` *is* the `K_null` of the task statement; we expose a
`Knull` notation-alias below purely for readability and prove it `rfl`-equal.

The Gate A sign hypotheses are exactly `SuperDirac.CleanSquareHypotheses`:
```text
(H1) Γ_s² = 1            (H2) {Γ_s, C_a} = 0      (H3) [Γ_s, ∇_a] = 0
(H4) [Γ_s, Φ] = 0        (H5) [C_a, Φ] = 0        (i central, i² = -1)
```
The `±Φ²` dichotomy is governed by (H4) vs its anticommuting negation, matching
`docs/CONVENTIONS.md` ("Super-Dirac square signs").

## Main results

* `dNsum_sq_decomp` — bridges the two namespaces: `D_N² = K_null + C_diamond + T_frame`.
* `finite_lichnerowicz_square` — the headline post-Gate-A Lichnerowicz formula
  with the kinetic term fully expanded into the `K_null / C_diamond / T_frame`
  blocks.
* `finite_lichnerowicz_square_gateA` — the same identity packaged with
  `CleanSquareHypotheses`, the downstream-facing named theorem.
* `finite_lichnerowicz_sign_bridge` — the full Lichnerowicz square **and** the
  `(Γ_s Φ)² = +Φ²` / `(χ_E Φ)² = -Φ²` sign dichotomy in one object (the Gate A
  closeout shape, abstract two-grading form).
* `finite_lichnerowicz_square_tetrad` — specialization under the finite tetrad
  postulate `[∇_a, C_b] = 0`: the `T_frame` defect drops, leaving
  `D² = -K_null - C_diamond + Φ² - i Γ_s ∑_a C_a [∇_a, Φ]`.
-/

namespace PhysicsSM
namespace Draft
namespace FiniteLichnerowiczBridge

open Finset
open PhysicsSM.Draft
open PhysicsSM.Draft.SuperDirac

section Bridge

variable {ι : Type*} [Fintype ι]
variable {A : Type*} [Ring A] [Invertible (4 : A)]
variable (C nab : ι → A)

/-- Readability alias: the task's `K_null` is the existing `Boxnull` block
`¼ ∑_{a,b} {C_a, C_b} {∇_a, ∇_b}`.  This is definitionally `Boxnull`. -/
abbrev Knull : A := Boxnull C nab

theorem Knull_eq_Boxnull : Knull C nab = Boxnull C nab := rfl

/-
**Namespace bridge.**  The Gate A kinetic square `D_N²` (written with
`SuperDirac.dNsum`) equals the finite-tetrad decomposition into the
`K_null / C_diamond / T_frame` blocks.  This is the single defeq glue between
the two draft layers.
-/
theorem dNsum_sq_decomp :
    dNsum C nab * dNsum C nab
      = Boxnull C nab + Cdiamond C nab + Tframe C nab := by
  -- By definition of $dNsum$, we know that $(dNsum C nab)^2 = Knull C nab + Cdiamond C nab + Tframe C nab$.
  have h_dNsum_sq : (dNsum C nab)^2 = Boxnull C nab + Cdiamond C nab + Tframe C nab := by
    convert dirac_square_full_decomp C nab using 1;
  rwa [ sq ] at h_dNsum_sq

end Bridge

section Lichnerowicz

variable {ι : Type*} [Fintype ι]
variable {A : Type*} [Ring A] [Invertible (4 : A)]

/-
**B17 — Post-Gate-A finite dual-soldered Lichnerowicz square.**

Under the clean Gate A sign hypotheses (H1)-(H5) with `i` central and `i² = -1`,
the square of the full null Dirac operator `D = i D_N + Γ_s Φ` is the finite
generalized Lichnerowicz formula

```text
D² = -K_null - C_diamond - T_frame + Φ² - i Γ_s ∑_a C_a [∇_a, Φ].
```

The kinetic part `-D_N²` from the Gate A square is resolved into the three
`docs/NULLSTRAND.md` blocks via `dNsum_sq_decomp`.
-/
theorem finite_lichnerowicz_square
    (Im Gs Ph : A) (C nab : ι → A)
    (hImc : ∀ x : A, Im * x = x * Im)
    (hIm2 : Im * Im = -1)
    (hGs2 : Gs * Gs = 1)
    (hGsC : ∀ a, Gs * C a = -(C a * Gs))
    (hGsNb : ∀ a, Gs * nab a = nab a * Gs)
    (hGsPh : Gs * Ph = Ph * Gs)
    (hCPh : ∀ a, C a * Ph = Ph * C a) :
    (Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
      = -(Boxnull C nab) - Cdiamond C nab - Tframe C nab + Ph * Ph
        - Im * (Gs * ∑ a, C a * (nab a * Ph - Ph * nab a)) := by
  rw [ super_dirac_square_sum Im Gs Ph C nab hImc hIm2 hGs2 hGsC hGsNb hGsPh hCPh ];
  rw [ dNsum_sq_decomp ] ; abel

/-
**B17 packaged form.**  Identical to `finite_lichnerowicz_square` but taking
the Gate A hypotheses bundled as `SuperDirac.CleanSquareHypotheses`, so
downstream files depend on one semantic object.
-/
theorem finite_lichnerowicz_square_gateA
    (Im Gs Ph : A) (C nab : ι → A)
    (h : CleanSquareHypotheses Im Gs Ph C nab) :
    (Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
      = -(Boxnull C nab) - Cdiamond C nab - Tframe C nab + Ph * Ph
        - Im * (Gs * ∑ a, C a * (nab a * Ph - Ph * nab a)) := by
  convert finite_lichnerowicz_square Im Gs Ph C nab h.im_central h.im_sq h.gs_sq h.gs_clifford h.gs_transport h.gs_mass h.clifford_mass using 1

/-
**Gate A sign-bridge closeout (Lichnerowicz form).**

Bundles the full finite Lichnerowicz square together with the headline `±Φ²`
sign dichotomy: with the spacetime chirality `Gs` (which commutes with `Φ`) the
mass block is the physical `+Φ²`, while with an internal chirality `Xe` under
which `Φ` is odd, the same construction gives the tachyonic `-Φ²`.  This is the
finite-square face of `super_dirac_sign_bridge` / `super_dirac_square_sum_safe`
from `NullEdgeSuperDiracSignBridge`, here with the kinetic term resolved into
`K_null / C_diamond / T_frame`.
-/
theorem finite_lichnerowicz_sign_bridge
    (Im Gs Xe Ph : A) (C nab : ι → A)
    (hImc : ∀ x : A, Im * x = x * Im)
    (hIm2 : Im * Im = -1)
    (hGs2 : Gs * Gs = 1)
    (hXe2 : Xe * Xe = 1)
    (hGsC : ∀ a, Gs * C a = -(C a * Gs))
    (hGsNb : ∀ a, Gs * nab a = nab a * Gs)
    (hGsPh : Gs * Ph = Ph * Gs)
    (hXePh : Xe * Ph = -(Ph * Xe))
    (hCPh : ∀ a, C a * Ph = Ph * C a) :
    (Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
        = -(Boxnull C nab) - Cdiamond C nab - Tframe C nab + Ph * Ph
          - Im * (Gs * ∑ a, C a * (nab a * Ph - Ph * nab a))
      ∧ (Gs * Ph) * (Gs * Ph) = Ph * Ph
      ∧ (Xe * Ph) * (Xe * Ph) = -(Ph * Ph) := by
  refine' ⟨ _, _, _ ⟩;
  · convert finite_lichnerowicz_square Im Gs Ph C nab hImc hIm2 hGs2 hGsC hGsNb hGsPh hCPh using 1;
  · grind;
  · convert graded_square_anticomm Xe Ph hXe2 hXePh using 1

/-
**Finite tetrad-postulate specialization.**  If the finite tetrad postulate
`[∇_a, C_b] = 0` holds (`frameComm C nab = 0`), the frame/tetrad defect term
`T_frame` vanishes and the Lichnerowicz square loses it:

```text
D² = -K_null - C_diamond + Φ² - i Γ_s ∑_a C_a [∇_a, Φ].
```
-/
theorem finite_lichnerowicz_square_tetrad
    (Im Gs Ph : A) (C nab : ι → A)
    (h : CleanSquareHypotheses Im Gs Ph C nab)
    (htetrad : ∀ a b, frameComm C nab a b = 0) :
    (Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
      = -(Boxnull C nab) - Cdiamond C nab + Ph * Ph
        - Im * (Gs * ∑ a, C a * (nab a * Ph - Ph * nab a)) := by
  convert finite_lichnerowicz_square_gateA Im Gs Ph C nab h using 1
  rw [frame_term_vanishes C nab htetrad]
  abel

end Lichnerowicz

end FiniteLichnerowiczBridge
end Draft
end PhysicsSM
