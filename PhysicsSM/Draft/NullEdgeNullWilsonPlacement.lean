import Mathlib
import PhysicsSM.Draft.NullEdgeSuperDiracSignAudit

/-!
# C71 — Null-Wilson operator-placement audit (Gate-A sign helper)

This is the small Lean companion to the report
`AgentTasks/null-edge-null-wilson-operator-placement-audit-report.md`.

The audit question is *how the null-Wilson regulator `R_W` should enter the
Gate C physical operator*.  The decision recorded in the report is:

> `R_W` is a **scalar Wilson kernel** that enters the same `Γ_s`-even, zero-order
> "mass" slot as the physical Yukawa `Φ_H`, i.e.
> `D_phys = i D_N + Γ_s Φ_H + Γ_s R_W`, but is tracked as a **separate,
> `χ_E`-even, branch-control counterterm** (not merged into `Φ_H`, which is
> `χ_E`-odd).

The single non-negotiable Gate-A constraint is the **grading of `R_W` under the
spacetime chirality `Γ_s`**: `R_W` must be `Γ_s`-*even* (`[Γ_s, R_W] = 0`).  This
file makes that constraint machine-checkable by reusing the abstract super-Dirac
square results of `PhysicsSM.Draft.NullEdgeSuperDiracSignAudit`:

* `nullWilson_square_healthy` — with `R_W` `Γ_s`-even the regulator enters the
  square with the **healthy `+R_W²`** sign (positive branch-gapping cost);
* `nullWilson_square_tachyonic` — the misplacement: if `R_W` were `Γ_s`-*odd*
  the square flips to the **fatal `-R_W²`** (a tachyonic "regulator" that would
  destabilise instead of gap the doublers);
* `nullWilson_combined_block_square` — when `Φ_H` and `R_W` are *both* `Γ_s`-even
  and commute with the Clifford symbol, they add inside one zero-order block and
  square to `+(Φ_H + R_W)²`, the Wilson mass-shift `m → m + R_W` made formal.

This is **finite algebra**, not a continuum claim, and proves nothing about full
Gate C release (positivity of the Wilson shape, gauge covariance, Krein
positivity, ghost safety are the separate C70/C72/C73/C74 obligations).
-/

namespace PhysicsSM
namespace Draft
namespace NullWilsonPlacement

open PhysicsSM.Draft.SuperDirac

variable {A : Type*} [Ring A]

/-- The grading data the Gate-A sign requires of a *scalar null-Wilson kernel*
`R_W` placed in the `Γ_s`-even zero-order slot of `D = i D_N + Γ_s R_W`.

* `gs_sq` — `Γ_s² = 1`;
* `gs_anti_C` — `{Γ_s, C} = 0` (the kinetic Clifford symbol stays `Γ_s`-odd);
* `gs_comm_RW` — `[Γ_s, R_W] = 0` (**the load-bearing constraint**: `R_W` is
  `Γ_s`-even, so it lands in the mass/regulator block, not the kinetic block);
* `C_comm_RW` — `[C, R_W] = 0` (`R_W` is a scalar in spinor space, so the
  Clifford symbol passes through it cleanly).

`Im` is the central scalar `i` (`Im² = -1`); `Nb = ∇` is a finite transport. -/
structure NullWilsonPlacement (Im Gs C Nb RW : A) : Prop where
  im_central : ∀ x : A, Im * x = x * Im
  im_sq : Im * Im = -1
  gs_sq : Gs * Gs = 1
  gs_anti_C : Gs * C = -(C * Gs)
  gs_comm_Nb : Gs * Nb = Nb * Gs
  gs_comm_RW : Gs * RW = RW * Gs
  C_comm_RW : C * RW = RW * C

/-- **Healthy placement.**  With `R_W` `Γ_s`-even the null-Wilson Dirac operator
`D = i D_N + Γ_s R_W` squares with the correct **`+R_W²`** sign:
`D² = -D_N² + R_W² - i Γ_s C (∇R_W - R_W ∇)`.  The regulator therefore adds a
*positive* mass-square cost on every branch where `R_W ≠ 0`. -/
theorem nullWilson_square_healthy (Im Gs C Nb RW : A)
    (h : NullWilsonPlacement Im Gs C Nb RW) :
    (Im * (C * Nb) + Gs * RW) * (Im * (C * Nb) + Gs * RW)
      = -((C * Nb) * (C * Nb)) + RW * RW
        - Im * (Gs * (C * (Nb * RW - RW * Nb))) :=
  super_dirac_square_single Im Gs C Nb RW
    h.im_central h.im_sq h.gs_sq h.gs_anti_C h.gs_comm_Nb h.gs_comm_RW h.C_comm_RW

/-- **Misplacement guardrail.**  If `R_W` were instead `Γ_s`-*odd*
(`{Γ_s, R_W} = 0`), the square flips the mass sign to the fatal tachyonic
**`-R_W²`**.  A `Γ_s`-odd "Wilson term" would destabilise the spectrum rather
than gap the doublers; hence the placement in `nullWilson_square_healthy`
(`Γ_s`-even) is forced. -/
theorem nullWilson_square_tachyonic (Im Gs C Nb RW : A)
    (im_central : ∀ x : A, Im * x = x * Im) (im_sq : Im * Im = -1)
    (gs_sq : Gs * Gs = 1) (gs_anti_C : Gs * C = -(C * Gs))
    (gs_comm_Nb : Gs * Nb = Nb * Gs)
    (gs_anti_RW : Gs * RW = -(RW * Gs))
    (C_comm_RW : C * RW = RW * C) :
    (Im * (C * Nb) + Gs * RW) * (Im * (C * Nb) + Gs * RW)
      = -((C * Nb) * (C * Nb)) - RW * RW
        - Im * (Gs * (C * (Nb * RW - RW * Nb))) :=
  super_dirac_square_single_odd Im Gs C Nb RW
    im_central im_sq gs_sq gs_anti_C gs_comm_Nb gs_anti_RW C_comm_RW

/-- **One shared zero-order block.**  When the physical Yukawa `Φ_H` (`Ph`) and
the null-Wilson kernel `R_W` are *both* `Γ_s`-even and both commute with the
Clifford symbol, they add inside a single zero-order block and the operator
`D = i D_N + Γ_s (Φ_H + R_W)` squares to `+(Φ_H + R_W)²`.  This is the lattice
Wilson mass shift `m → m + R_W` realised as finite algebra, and shows the
placement `D_NW = i D_N + Γ_s R_W` is compatible with the existing `Γ_s Φ_H`
mass block of Gate A. -/
theorem nullWilson_combined_block_square (Im Gs C Nb Ph RW : A)
    (im_central : ∀ x : A, Im * x = x * Im) (im_sq : Im * Im = -1)
    (gs_sq : Gs * Gs = 1) (gs_anti_C : Gs * C = -(C * Gs))
    (gs_comm_Nb : Gs * Nb = Nb * Gs)
    (gs_comm_Ph : Gs * Ph = Ph * Gs) (gs_comm_RW : Gs * RW = RW * Gs)
    (C_comm_Ph : C * Ph = Ph * C) (C_comm_RW : C * RW = RW * C) :
    (Im * (C * Nb) + Gs * (Ph + RW)) * (Im * (C * Nb) + Gs * (Ph + RW))
      = -((C * Nb) * (C * Nb)) + (Ph + RW) * (Ph + RW)
        - Im * (Gs * (C * (Nb * (Ph + RW) - (Ph + RW) * Nb))) := by
  refine super_dirac_square_single Im Gs C Nb (Ph + RW)
    im_central im_sq gs_sq gs_anti_C gs_comm_Nb ?_ ?_
  · rw [mul_add, add_mul, gs_comm_Ph, gs_comm_RW]
  · rw [mul_add, add_mul, C_comm_Ph, C_comm_RW]

end NullWilsonPlacement
end Draft
end PhysicsSM
