/-
# C227 Gate C1 operator-freeze API (strategy / interface module)

Local strategy + API artifact authored 2026-06-28.

Status: API / interface module.  It *freezes* the shapes
`H_ref`, `H_ne`, the transport `S`/`Sinv`, the gap threshold `gamma_free`, and the
five-term mismatch budget `kappa + omega + rho + alpha + beta`, and proves the
single assembly theorem

  ‖H_ne - S H_ref S⁻¹‖ ≤ kappa + omega + rho + alpha + beta < gamma_free
      → gapped homotopy.

Claim boundary (explicit, see `NoOverclaim` section):

* This is **not** a proof of full `GateC1_NU`.
* The actual null-edge operator `H_ne` is **not** defined here; it is carried as an
  abstract `OpFamily` so that the budget interface can be discharged later, leg by
  leg, against a concrete realization.
* No claim is made about anomaly inflow, the determinant line, Krein / indefinite-
  metric structure, ghosts, gauge fixing, or any quantum Gate C closure.
* The doubler-resolution gap `gamma_free` is supplied by the Wilson/Neuberger
  reference (`FrozenOverlap.hRefGapped`); CKM lives only inside the *budget legs*
  (`omega`) and is structurally forbidden from supplying that gap — see
  `ckm_cannot_lift_spacetime_doublers`.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.CKMWilsonWindow
import PhysicsSM.Draft.NullEdge.GateC1.GappedHomotopy
import PhysicsSM.Draft.NullEdge.GateC1.SignStability

open NullEdgeGateC1
open scoped Classical

namespace GateC1.OperatorFreeze

variable {P : Type*}
variable {E : Type*}
  [NormedAddCommGroup E] [InnerProductSpace ℂ E] [FiniteDimensional ℂ E]

/-! ## 1. Frozen overlap data

`FrozenOverlap` freezes the four operator families of the C227 architecture
together with the gap threshold and the *bridge obligation* that the
Wilson/Neuberger reference is genuinely gapped at that threshold.

* `H_ref` — the CKM-decorated Wilson/Neuberger overlap reference
  `Gamma_ref [D_W^0(U) ⊗ I_CKM + I ⊗ r_b(15 I - M_CKM) - m0 I]`.
* `H_ne`  — the null-edge endpoint (kept abstract; *not* defined here).
* `S`, `Sinv` — the sector/branch-frame transport and its inverse.
* `gammaFree` — the free-reference margin
  `min(m0, 2 r_W - m0, 16 r_b - m0)` (cf. `GateC1.CKMWilsonWindow.gamma_free`).
* `hRefGapped` — the bridge obligation that the reference operator gap is at least
  `gammaFree` (the operator-level upgrade of `gamma_free_pos`). -/
structure FrozenOverlap (P E : Type*)
    [NormedAddCommGroup E] [InnerProductSpace ℂ E] [FiniteDimensional ℂ E] where
  /-- Wilson/Neuberger overlap reference family. -/
  H_ref : OpFamily P E
  /-- Null-edge endpoint family (abstract; not realized in this module). -/
  H_ne : OpFamily P E
  /-- Sector/branch-frame transport. -/
  S : OpFamily P E
  /-- Inverse transport. -/
  Sinv : OpFamily P E
  /-- The free-reference gap threshold. -/
  gammaFree : ℝ
  /-- Bridge obligation: the reference is operator-gapped at `gammaFree`. -/
  hRefGapped : Gapped gammaFree H_ref

/-! ## 2. The five-term mismatch budget

`BudgetDecomposition M` freezes the additive split of the transported mismatch
`transport S Sinv H_ne - H_ref` into five legs, each with its own operator-norm
budget constant:

* `Dkappa` / `kappa` — genuine kinetic / Wilson mismatch (`D_ne^cov + W_NE,space`
  vs `D_W^0`); this is the only leg that may carry doubler content.
* `Domega` / `omega` — CKM transport mismatch (flavor texture moved through `S`).
* `Drho`   / `rho`   — mass-rescale mismatch `R_ne` vs `R_ref`.
* `Dalpha` / `alpha` — link / gauge deviation away from `U = 1`.
* `Dbeta`  / `beta`  — branch-frame mismatch away from the flat frame. -/
structure BudgetDecomposition (M : FrozenOverlap P E) where
  /-- Kinetic / Wilson leg. -/
  Dkappa : OpFamily P E
  /-- CKM-transport leg. -/
  Domega : OpFamily P E
  /-- Mass-rescale leg. -/
  Drho : OpFamily P E
  /-- Link/gauge leg. -/
  Dalpha : OpFamily P E
  /-- Branch-frame leg. -/
  Dbeta : OpFamily P E
  /-- Kinetic/Wilson budget constant. -/
  kappa : ℝ
  /-- CKM-transport budget constant. -/
  omega : ℝ
  /-- Mass-rescale budget constant. -/
  rho : ℝ
  /-- Link/gauge budget constant. -/
  alpha : ℝ
  /-- Branch-frame budget constant. -/
  beta : ℝ
  hkappa0 : 0 ≤ kappa
  homega0 : 0 ≤ omega
  hrho0 : 0 ≤ rho
  halpha0 : 0 ≤ alpha
  hbeta0 : 0 ≤ beta
  /-- The mismatch splits additively into the five legs. -/
  hdecomp : ∀ p, transport M.S M.Sinv M.H_ne p - M.H_ref p
      = Dkappa p + Domega p + Drho p + Dalpha p + Dbeta p
  hkappa : ∀ p, ‖Dkappa p‖ ≤ kappa
  homega : ∀ p, ‖Domega p‖ ≤ omega
  hrho : ∀ p, ‖Drho p‖ ≤ rho
  halpha : ∀ p, ‖Dalpha p‖ ≤ alpha
  hbeta : ∀ p, ‖Dbeta p‖ ≤ beta

namespace BudgetDecomposition

variable {M : FrozenOverlap P E}

/-- The total budget `kappa + omega + rho + alpha + beta`. -/
def total (B : BudgetDecomposition M) : ℝ :=
  B.kappa + B.omega + B.rho + B.alpha + B.beta

/-- The total budget is nonnegative. -/
theorem total_nonneg (B : BudgetDecomposition M) : 0 ≤ B.total := by
  unfold total
  have := B.hkappa0; have := B.homega0; have := B.hrho0
  have := B.halpha0; have := B.hbeta0
  linarith

/-- `kappa ≤ total`: the kinetic leg never exceeds the full budget.  (Used by the
no-overclaim guardrail: enlarging the CKM/frame legs can only *raise* the budget,
never supply the doubler gap.) -/
theorem kappa_le_total (B : BudgetDecomposition M) : B.kappa ≤ B.total := by
  unfold total
  have := B.homega0; have := B.hrho0; have := B.halpha0; have := B.hbeta0
  linarith

/-- **Budget ⇒ κ-certificate.**  The five-leg decomposition with its per-leg
operator-norm bounds yields a single `KappaCertificate` at the total budget, via
the triangle inequality. -/
theorem kappaCertificate (B : BudgetDecomposition M) :
    KappaCertificate M.S M.Sinv M.H_ne M.H_ref B.total := by
  intro p
  rw [B.hdecomp p]
  calc ‖B.Dkappa p + B.Domega p + B.Drho p + B.Dalpha p + B.Dbeta p‖
      ≤ ‖B.Dkappa p + B.Domega p + B.Drho p + B.Dalpha p‖ + ‖B.Dbeta p‖ :=
        norm_add_le _ _
    _ ≤ (‖B.Dkappa p + B.Domega p + B.Drho p‖ + ‖B.Dalpha p‖) + ‖B.Dbeta p‖ := by
        gcongr; exact norm_add_le _ _
    _ ≤ ((‖B.Dkappa p + B.Domega p‖ + ‖B.Drho p‖) + ‖B.Dalpha p‖) + ‖B.Dbeta p‖ := by
        gcongr; exact norm_add_le _ _
    _ ≤ (((‖B.Dkappa p‖ + ‖B.Domega p‖) + ‖B.Drho p‖) + ‖B.Dalpha p‖) + ‖B.Dbeta p‖ := by
        gcongr; exact norm_add_le _ _
    _ ≤ B.total := by
        unfold total
        have := B.hkappa p; have := B.homega p; have := B.hrho p
        have := B.halpha p; have := B.hbeta p
        linarith

end BudgetDecomposition

/-! ## 3. Master assembly theorem

`‖H_ne - S H_ref S⁻¹‖ ≤ kappa + omega + rho + alpha + beta < gamma_free`
⇒ the transported null-edge endpoint is gapped-homotopic to the reference. -/

/-- **C227 master theorem.**  Given frozen overlap data `M` (in particular the
Wilson/Neuberger reference gapped at `gammaFree`) and a five-leg budget whose total
is strictly below `gammaFree`, the transported null-edge endpoint is
gapped-homotopic to the reference.  CKM (`omega`) enters only the budget, never the
gap. -/
theorem frozen_gappedHomotopic_of_budget
    (M : FrozenOverlap P E) (B : BudgetDecomposition M)
    (hbudget : B.total < M.gammaFree) :
    GappedHomotopic M.H_ref (transport M.S M.Sinv M.H_ne) :=
  nullEdge_gappedHomotopic_to_ref M.hRefGapped B.total_nonneg hbudget B.kappaCertificate

/-! ## 4. First-pass zero clauses

The C227 first pass argues four of the five legs vanish identically:

* `omega = 0` by **exact CKM transport** (`S` carries the flavor texture exactly);
* `rho   = 0` by **trivial mass rescale** `R_ref = R_ne = I`;
* `alpha = 0` **at `U = 1`** (no link deviation);
* `beta  = 0` in the **flat branch frame**.

Each clause is the statement "this leg is identically `0`", whose immediate
consequence is that its budget constant may be taken to be `0`. -/

/-- A leg that vanishes identically admits the budget bound `0`. -/
theorem bound_zero_of_leg_zero {D : OpFamily P E} (h : ∀ p, D p = 0) :
    ∀ p, ‖D p‖ ≤ (0 : ℝ) := by
  intro p; rw [h p, norm_zero]

/-- Zero clause `omega = 0`: exact CKM transport (the flavor texture passes through
`S` unchanged) means the CKM leg vanishes. -/
def ExactCKMTransport {M : FrozenOverlap P E} (B : BudgetDecomposition M) : Prop :=
  ∀ p, B.Domega p = 0

/-- Zero clause `rho = 0`: `R_ref = R_ne = I` means the mass-rescale leg vanishes. -/
def TrivialMassRescale {M : FrozenOverlap P E} (B : BudgetDecomposition M) : Prop :=
  ∀ p, B.Drho p = 0

/-- Zero clause `alpha = 0`: at `U = 1` there is no link deviation. -/
def TrivialLinkDeviation {M : FrozenOverlap P E} (B : BudgetDecomposition M) : Prop :=
  ∀ p, B.Dalpha p = 0

/-- Zero clause `beta = 0`: in the flat branch frame the frame leg vanishes. -/
def FlatBranchFrame {M : FrozenOverlap P E} (B : BudgetDecomposition M) : Prop :=
  ∀ p, B.Dbeta p = 0

/-- **First-pass budget certificate.**  When `omega = rho = alpha = beta = 0` (the
four physical zero clauses hold), the whole budget collapses to a single kinetic /
Wilson leg `Dk` of size `kappa`, i.e. the entire mismatch *is* the kinetic
mismatch.  This is the assembled first-pass `BudgetDecomposition`. -/
def firstPass (M : FrozenOverlap P E) (Dk : OpFamily P E) (kappa : ℝ)
    (hk0 : 0 ≤ kappa)
    (hdecomp : ∀ p, transport M.S M.Sinv M.H_ne p - M.H_ref p = Dk p)
    (hk : ∀ p, ‖Dk p‖ ≤ kappa) : BudgetDecomposition M where
  Dkappa := Dk
  Domega := 0
  Drho := 0
  Dalpha := 0
  Dbeta := 0
  kappa := kappa
  omega := 0
  rho := 0
  alpha := 0
  beta := 0
  hkappa0 := hk0
  homega0 := le_refl 0
  hrho0 := le_refl 0
  halpha0 := le_refl 0
  hbeta0 := le_refl 0
  hdecomp := by intro p; simp [hdecomp p]
  hkappa := hk
  homega := by intro p; simp
  hrho := by intro p; simp
  halpha := by intro p; simp
  hbeta := by intro p; simp

/-- The first-pass total budget is exactly `kappa`. -/
theorem firstPass_total (M : FrozenOverlap P E) (Dk : OpFamily P E) (kappa : ℝ)
    (hk0 : 0 ≤ kappa)
    (hdecomp : ∀ p, transport M.S M.Sinv M.H_ne p - M.H_ref p = Dk p)
    (hk : ∀ p, ‖Dk p‖ ≤ kappa) :
    (firstPass M Dk kappa hk0 hdecomp hk).total = kappa := by
  simp [firstPass, BudgetDecomposition.total]

/-- **First-pass master theorem.**  Under the four zero clauses, if the single
kinetic / Wilson mismatch `kappa` is below `gammaFree`, the transported null-edge
endpoint is gapped-homotopic to the reference.  This is exactly the engine
`nullEdge_gappedHomotopic_to_ref` with `omega = rho = alpha = beta = 0`. -/
theorem frozen_firstPass
    (M : FrozenOverlap P E) (Dk : OpFamily P E) (kappa : ℝ)
    (hk0 : 0 ≤ kappa)
    (hdecomp : ∀ p, transport M.S M.Sinv M.H_ne p - M.H_ref p = Dk p)
    (hk : ∀ p, ‖Dk p‖ ≤ kappa)
    (hbudget : kappa < M.gammaFree) :
    GappedHomotopic M.H_ref (transport M.S M.Sinv M.H_ne) := by
  have h := frozen_gappedHomotopic_of_budget M (firstPass M Dk kappa hk0 hdecomp hk)
  rw [firstPass_total] at h
  exact h hbudget

/-! ## 5. Bridge to γ-free sign stability (`SignStability.lean`)

The budget total `B.total < gammaFree` is exactly the perturbation size consumed by
the C201 no-sign-crossing certificate.  This corollary repackages
`C201.operator_sign_stability` with `normE := B.total`. -/

/-- The C201 and C193 free-margin definitions are the same expression, with
arguments ordered for their respective modules. -/
theorem C201_gammaFree_eq_CKMWilsonWindow_gamma_free
    (m0 r_W r_b : ℝ) :
    C201.gammaFree m0 r_W r_b =
      GateC1.CKMWilsonWindow.gamma_free r_W r_b m0 := by
  rfl

/-- The CKM/Wilson mass-window theorem supplies the C201 positive margin. -/
theorem C201_gammaFree_pos_of_CKMWilsonWindow
    {r_W r_b m0 : ℝ}
    (hm0 : 0 < m0) (hwin : m0 < min (2 * r_W) (16 * r_b)) :
    0 < C201.gammaFree m0 r_W r_b := by
  simpa [C201_gammaFree_eq_CKMWilsonWindow_gamma_free] using
    GateC1.CKMWilsonWindow.gamma_free_pos hm0 hwin

/--
CKM/Wilson sector sign stability.

The C193 mass window gives a concrete sector mass profile
`mu r_W r_b m0`.  If a perturbation of every sector is smaller than the checked
free margin, then the physical sector `(0, 0)` remains negative and every other
sector remains positive.  This is the scalar, sector-level version of the
operator budget theorem below.
-/
theorem CKMWilsonWindow_scalar_sign_stability
    {r_W r_b m0 : ℝ} (hW : 0 < r_W)
    (delta : ℕ × ℕ -> ℝ)
    (hpert : ∀ p : ℕ × ℕ,
      |delta p| < GateC1.CKMWilsonWindow.gamma_free r_W r_b m0) :
    GateC1.CKMWilsonWindow.mu r_W r_b m0 0 0 + delta (0, 0) < 0 ∧
      ∀ p : ℕ × ℕ, p ≠ (0, 0) ->
        0 < GateC1.CKMWilsonWindow.mu r_W r_b m0 p.1 p.2 + delta p := by
  refine C201.scalar_sign_stability
    (phys := (0, 0))
    (m := fun p : ℕ × ℕ => GateC1.CKMWilsonWindow.mu r_W r_b m0 p.1 p.2)
    (delta := delta)
    (gamma := GateC1.CKMWilsonWindow.gamma_free r_W r_b m0)
    ?hphys ?hother hpert
  · exact GateC1.CKMWilsonWindow.mu_phys_le_neg_margin
  · intro p hp
    exact GateC1.CKMWilsonWindow.mu_heavy_ge_margin hW p.1 p.2 (by
      intro h
      apply hp
      exact Prod.ext h.1 h.2)

/-- **No sign crossing along the budget homotopy.**  Given a sector mass tracking
`mt` that is Lipschitz in the homotopy parameter with constant `B.total`, the
sign-isolated spectrum at `t = 0` (physical below `-gammaFree`, all others above
`+gammaFree`) keeps its sign pattern for all `t ∈ [0,1]`. -/
theorem frozen_no_sign_crossing
    {Sec : Type*} (phys : Sec) (mt : Sec → ℝ → ℝ)
    (M : FrozenOverlap P E) (B : BudgetDecomposition M)
    (hbudget : B.total < M.gammaFree)
    (hLip : ∀ s, ∀ t ∈ Set.Icc (0 : ℝ) 1, |mt s t - mt s 0| ≤ t * B.total)
    (hphys0 : mt phys 0 ≤ -M.gammaFree)
    (hother0 : ∀ s, s ≠ phys → M.gammaFree ≤ mt s 0) :
    ∀ t ∈ Set.Icc (0 : ℝ) 1, mt phys t < 0 ∧ ∀ s, s ≠ phys → 0 < mt s t :=
  C201.operator_sign_stability phys M.gammaFree B.total mt B.total_nonneg hbudget
    hLip hphys0 hother0

/--
First-pass no-sign-crossing theorem.

When the only active budget leg is the kinetic/Wilson mismatch, the sign pattern
is stable under the simpler condition `kappa < gammaFree`.  This is the
sector-sign companion to `frozen_firstPass`.
-/
theorem frozen_firstPass_no_sign_crossing
    {Sec : Type*} (phys : Sec) (mt : Sec → ℝ → ℝ)
    (M : FrozenOverlap P E) {kappa : ℝ}
    (hk0 : 0 ≤ kappa) (hbudget : kappa < M.gammaFree)
    (hLip : ∀ s, ∀ t ∈ Set.Icc (0 : ℝ) 1, |mt s t - mt s 0| ≤ t * kappa)
    (hphys0 : mt phys 0 ≤ -M.gammaFree)
    (hother0 : ∀ s, s ≠ phys → M.gammaFree ≤ mt s 0) :
    ∀ t ∈ Set.Icc (0 : ℝ) 1, mt phys t < 0 ∧ ∀ s, s ≠ phys → 0 < mt s t :=
  C201.operator_sign_stability phys M.gammaFree kappa mt hk0 hbudget
    hLip hphys0 hother0

/-! ## 6. No-overclaim guardrails

The guardrail forbids the CKM-only spacetime-doubler-resolution overclaim.  In the
sector model of `CKMWilsonWindow.lean`, the spacetime-doubler index is `n` and is
lifted *only* by the Wilson coefficient `r_W`; the CKM coefficient `r_b` lifts only
the flavor index `ell > 0`.  With `r_W = 0` every spacetime doubler (`ell = 0`, any
`n`) stays light no matter how large `r_b` (CKM) is. -/

/-- **Guardrail (scalar teeth).**  With `r_W = 0` the CKM weight cannot lift any
spacetime doubler: for every `n` and *every* CKM coefficient `r_b`, the
CKM-light sector `(n, 0)` stays strictly light.  Hence CKM alone never resolves
spacetime momentum doublers — that is the Wilson/Neuberger job. -/
theorem ckm_cannot_lift_spacetime_doublers
    {r_b m0 : ℝ} (hm0 : 0 < m0) (n : ℕ) :
    GateC1.CKMWilsonWindow.mu 0 r_b m0 n 0 < 0 := by
  simp only [GateC1.CKMWilsonWindow.mu, GateC1.CKMWilsonWindow.w_zero,
    mul_zero, zero_mul, add_zero, zero_sub]
  linarith

/-- **Guardrail (contrast).**  By contrast, a strictly positive Wilson coefficient
*does* lift the spacetime doublers (`n ≥ 1`): doubler resolution requires `r_W > 0`,
not CKM.  (Restatement of `mu_doubler_pos` for the guardrail.) -/
theorem wilson_lifts_spacetime_doublers
    {r_W r_b m0 : ℝ} (hW : 0 < r_W)
    (hwin : m0 < min (2 * r_W) (16 * r_b)) {n : ℕ} (hn : 1 ≤ n) :
    0 < GateC1.CKMWilsonWindow.mu r_W r_b m0 n 0 :=
  GateC1.CKMWilsonWindow.mu_doubler_pos hW hwin hn

/-- **Guardrail (operator teeth).**  The doubler gap is a property of the reference
(`hRefGapped`), independent of the CKM/frame budget legs.  If at some momentum the
transported null-edge endpoint is at least `gammaFree` away from the reference, no
`kappa < gammaFree` certificate exists — *no enlargement of the CKM/frame budget can
manufacture the missing gap*.  (Specialization of `gateC1_certificate_unavailable`.)
-/
theorem budget_cannot_manufacture_gap
    (M : FrozenOverlap P E) (p : P)
    (hfar : M.gammaFree ≤ ‖transport M.S M.Sinv M.H_ne p - M.H_ref p‖) :
    ¬ ∃ κ : ℝ, κ < M.gammaFree ∧
        KappaCertificate M.S M.Sinv M.H_ne M.H_ref κ :=
  gateC1_certificate_unavailable p hfar

end GateC1.OperatorFreeze
