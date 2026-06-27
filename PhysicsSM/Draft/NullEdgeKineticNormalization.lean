import Mathlib
import PhysicsSM.Draft.NullEdgeFiniteTetradPostulate

/-!
# Kinetic naming and mass-shell normalization (job A6)

Aristotle deliverable for the null-edge Gate A/B/C wave (see `PROMPT.md`,
`AgentTasks/null-edge-sign-normalization-dashboard.md` §1-§3 and
`AgentTasks/aristotle-wave-integration-triage.md` §3-A).

This is **naming / finite-algebra normalization, not a continuum theorem.**

We work in the same finite operator algebra as
`PhysicsSM.Draft.NullEdgeFiniteTetradPostulate`: the null-edge symbols
`C_a = c(α^a)` and finite transports `∇_a` are elements of an arbitrary
(possibly non-commutative) `Ring R`, indexed by a `Fintype ι`, and
`D_N = ∑_a C_a ∇_a`.

## Canonical kinetic naming (closes dashboard conflicts C-1 and C-2)

The single symmetric kinetic mass-shell operator appears in the corpus under
four different names (`K_null`, `Box_null`, `K_h`, `K`). We fix **one** canonical
name and provide alias lemmas:

```text
K_null     := Box_null = ¼ ∑_{a,b} {C_a, C_b} {∇_a, ∇_b}   -- symmetric kinetic block
C_diamond  := ¼ ∑_{a,b} [C_a, C_b] [∇_a, ∇_b]              -- commutator / curvature block
T_frame    := ∑_{a,b} C_a [∇_a, C_b] ∇_b                   -- frame defect
K_full     := ∑_{a,b} C_a C_b ∇_a ∇_b                      -- combined kinetic + curvature
```

The aliases `Box_null`, `K_h`, `K` all denote `K_null`. The Lean spellings
`Cdiamond`, `Tframe` are the ASCII forms of `C_diamond`, `T_frame`.

**Guardrail (C-2):** the object called `Kplus` in the tetrad-postulate report is
*not* `K_null`. It is the combined kinetic + curvature block

```text
K_full = K_null + C_diamond ≠ K_null   (whenever C_diamond ≠ 0).
```

Do **not** let `Kplus` / `K_full` and `K_null` drift into the same trusted
statement as if equal: that would silently double-count the curvature block.

## Identity lemmas

```text
K_full   = K_null + C_diamond
D_N²     = K_full + T_frame
D_N²     = K_null + C_diamond + T_frame
```

## Mass-shell naming convention (closes dashboard conflict C-3)

The metric is mostly-minus `+t² - x²` (`docs/CONVENTIONS.md`, "Metric
signature"), so null momenta satisfy `p² = 0` and massive on-shell modes satisfy
`p² = m²`.

The kinetic block `K_null` is normalized to have plane-wave symbol `+p²` (it is
the *negative* of the analytic d'Alembertian, whose symbol is `-p²`, i.e.
`K_null = -Box_analytic` at the symbol level). With this normalization the
no-double-counting mass-shell relation reads

```text
-K_null + Phi_H² = 0     gives     p² = m².
```

Equivalently `K_null = Phi_H²` on-shell (one relation; never
`m_Plucker² + m_Higgs²`). This is captured formally by `mass_shell_iff`.
-/

namespace PhysicsSM
namespace Draft

open Finset

section KineticNormalization

variable {ι : Type*} [Fintype ι]
variable {R : Type*} [Ring R] [Invertible (4 : R)]
variable (C nab : ι → R)

/-- **Canonical kinetic mass-shell operator** `K_null` (symmetric kinetic
block), the unique name for the symmetric box
`¼ ∑_{a,b} {C_a, C_b} {∇_a, ∇_b}`. The aliases `Box_null`, `K_h`, `K` from the
corpus all denote this object. Plane-wave symbol `+p²` (mostly-minus). -/
def Knull : R := Boxnull C nab

/-- **Combined kinetic + curvature block** `K_full = ∑_{a,b} C_a C_b ∇_a ∇_b`.
This is the object called `Kplus` in the tetrad-postulate report; it equals
`K_null + C_diamond`, **not** `K_null` (guardrail C-2). -/
def Kfull : R := Kplus C nab

/-- `K_null` is by definition the symmetric `Box_null` block (alias lemma,
closes naming conflict C-1). -/
@[simp] theorem Knull_eq_Boxnull : Knull C nab = Boxnull C nab := rfl

omit [Invertible (4 : R)] in
/-- `K_full` is by definition the combined `Kplus` block (alias lemma). -/
@[simp] theorem Kfull_eq_Kplus : Kfull C nab = Kplus C nab := rfl

/-- **Identity lemma:** `K_full = K_null + C_diamond`. -/
theorem Kfull_eq_Knull_add_Cdiamond :
    Kfull C nab = Knull C nab + Cdiamond C nab := by
  simp only [Kfull_eq_Kplus, Knull_eq_Boxnull]
  exact (boxnull_add_cdiamond C nab).symm

omit [Invertible (4 : R)] in
/-- **Identity lemma:** `D_N² = K_full + T_frame`. -/
theorem dirac_square_eq_Kfull_add_Tframe :
    (DN C nab) ^ 2 = Kfull C nab + Tframe C nab := by
  simp only [Kfull_eq_Kplus]
  exact dirac_square_decomp C nab

/-- **Identity lemma:** `D_N² = K_null + C_diamond + T_frame`. -/
theorem dirac_square_eq_Knull_add_Cdiamond_add_Tframe :
    (DN C nab) ^ 2 = Knull C nab + Cdiamond C nab + Tframe C nab := by
  simp only [Knull_eq_Boxnull]
  exact dirac_square_full_decomp C nab

/-- **Guardrail (C-2):** the tetrad-postulate `Kplus` is `K_null + C_diamond`,
i.e. the combined kinetic + curvature block, not the kinetic block `K_null`. -/
theorem Kplus_eq_Knull_add_Cdiamond :
    Kplus C nab = Knull C nab + Cdiamond C nab := by
  simp only [Knull_eq_Boxnull]
  exact (boxnull_add_cdiamond C nab).symm

/-- **Guardrail (C-2):** `K_full` coincides with `K_null` *exactly* when the
curvature / diamond block vanishes; in general (`C_diamond ≠ 0`) they differ, so
they must never be conflated. -/
theorem Kfull_eq_Knull_iff_Cdiamond_zero :
    Kfull C nab = Knull C nab ↔ Cdiamond C nab = 0 := by
  rw [Kfull_eq_Knull_add_Cdiamond]
  exact add_eq_left

end KineticNormalization

section MassShell

variable {R : Type*} [Ring R]

/-- **Mass-shell naming convention (closes C-3).** With `K_null` normalized to
plane-wave symbol `+p²` (mostly-minus), the no-double-counting mass-shell
relation `-K_null + Phi_H² = 0` is equivalent to the single operator identity
`K_null = Phi_H²` (giving `p² = m²`). Here `k` plays the role of `K_null` and
`phi2` the role of `Phi_H²`. -/
theorem mass_shell_iff (k phi2 : R) :
    -k + phi2 = 0 ↔ k = phi2 := by
  exact neg_add_eq_zero

end MassShell

end Draft
end PhysicsSM
