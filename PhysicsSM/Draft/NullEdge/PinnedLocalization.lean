/-
# Deliverable 1 — Transfer-contraction localization of the pinned defect modes

Companion Lean file for `PINNED_STABILITY_DESIGN.md`, deliverable 1 (localization,
kernel-only target).  Builds on the landed context engine
(`context/ModeInvariantHalfWinding.lean`, `context/HalfPeriodInvariant.lean`),
which is left byte-identical.

Two exact, finite, analysis-free statements:

* **(b) Abstract one-step transfer contraction** (`§1`, kernel-only over `ℂ`):
  the pre-registered `λ = ±1` transfer matrix
  `T(λ,σ) = [[1/(λc), -i s σ/c], [i s σ/c, λ/c]]` (with the exact `3-4-5`
  data `c = 4/5`, `s = 3/5`) has `det T = 1`, and on its **stable**
  eigenvector it scales coordinates by **exactly `λ/2`** (contraction
  ratio `1/2`); on the complementary eigenvector by `2·λ`.  Proved by exact
  `ℚ(i)` / `ℂ` ring algebra, no analysis, no `native_decide`.

* **(a) The landed L=8 two-wall fixture** (`§2`, exact over `ℚ`, `native_decide`):
  explicit `±1` eigenvectors `psiPlus`, `psiMinus` of the landed two-wall walk
  `Wwall`, supported **exactly on the two reflection-fixed sites `1, 3`** and
  vanishing on the non-fixed sites `0, 2`.  Along the single bulk transfer step
  `site 1 → site 3` (crossing the wall at site `2`) the amplitude is scaled by
  exactly `±1/2`, hence the per-site squared norm is scaled by exactly `1/4`:
  `siteNormSq _ 3 = (1/4) · siteNormSq _ 1`.  These are the finite avatars of
  the `1/2`-per-step contraction of (b): the mode's site-1 amplitude is the
  *stable* eigenvector of the site-amplitude transfer.

  Draft-trust disclosure: every `ℚ` fact in §2 is discharged by `native_decide`
  (adds `Lean.ofReduceBool` / `Lean.trustCompiler`), matching the sibling K6
  fixtures.  The abstract §1 lemmas are kernel-only.
-/
/-
Provenance: Aristotle job 573430f4 (fable-pub-pinned-stability-20260711),
harvested 2026-07-11 ~10:20 PDT (24h-run P0); part of a six-module return
(SpecProjectors held back pending two abstract-lemma proofs). Statements
integrated UNCHANGED except this header and import rewires
(context/Pinned paths -> project paths). The job absorbed three exact
mid-task data injections (census, axis-equivariant charts, block
involutions) recorded in the 2026-07-11 overnight ledger. Draft-trust
disclosure: finite family decisions use native_decide (+2 footprint) as
stated per-file; abstract lemmas are kernel-only.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PinnedLocalization

open Matrix
open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

/-! ## 1.  Abstract one-step transfer contraction (kernel-only, over `ℂ`)

The `λ = ±1` transfer matrix at the `3-4-5` coin (`c = 4/5`, `s = 3/5`), exactly
as pre-registered:
`T(λ,σ) = [[1/(λc), -i s σ/c], [i s σ/c, λ/c]]`. -/

/-- The exact transfer matrix `T(λ,σ)` over `ℂ` (`c = 4/5`, `s = 3/5`). -/
def Tc (lam sg : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![ 1 / (lam * (4/5)), -Complex.I * (3/5) * sg / (4/5);
      Complex.I * (3/5) * sg / (4/5), lam / (4/5) ]

/-- The **stable** eigenvector of `T(λ,σ)` (eigenvalue `λ/2`, |ratio| = `1/2`):
`(λσ i, 1)` — i.e. `(i,1)` or `(-i,1)` depending on the sign `λσ`. -/
def stableVec (lam sg : ℂ) : Fin 2 → ℂ := ![lam * sg * Complex.I, 1]

/-- The complementary **unstable** eigenvector of `T(λ,σ)` (eigenvalue `2λ`). -/
def unstableVec (lam sg : ℂ) : Fin 2 → ℂ := ![-(lam * sg) * Complex.I, 1]

/-
`det T(λ,σ) = 1` for `λ² = 1`, `σ² = 1` (the pre-registered fact).
-/
theorem Tc_det (lam sg : ℂ) (hlam : lam ^ 2 = 1) (hsg : sg ^ 2 = 1) :
    (Tc lam sg).det = 1 := by
  unfold Tc; norm_num; ring;
  rw [ mul_inv_cancel₀ ( by aesop_cat ), one_mul, Complex.I_sq, hsg ] ; norm_num

/-
**The contraction (b).**  On its stable eigenvector `T(λ,σ)` scales
coordinates by **exactly `λ/2`** — contraction ratio `1/2`.
-/
theorem Tc_stable (lam sg : ℂ) (hlam : lam ^ 2 = 1) (hsg : sg ^ 2 = 1) :
    (Tc lam sg).mulVec (stableVec lam sg) = (lam / 2) • stableVec lam sg := by
  unfold Tc stableVec;
  ext i; fin_cases i <;> norm_num [ Matrix.mulVec ] <;> ring;
  · grind;
  · norm_num [ hlam, hsg ] ; ring

/-
The complementary direction is scaled by exactly `2λ` (the unstable leg).
-/
theorem Tc_unstable (lam sg : ℂ) (hlam : lam ^ 2 = 1) (hsg : sg ^ 2 = 1) :
    (Tc lam sg).mulVec (unstableVec lam sg) = (2 * lam) • unstableVec lam sg := by
  ext i; fin_cases i <;> norm_num <;> ring;
  · unfold Tc unstableVec; norm_num [ Matrix.mulVec ] ; ring;
    grind +qlia;
  · norm_num [ unstableVec, Tc ] ; ring;
    norm_num [ hsg ] ; ring

/-! ## 2.  The landed L=8 two-wall fixture (exact over `ℚ`, `native_decide`)

`Wwall = walkQ cW sWall` with `sWall = [+,+,-,+]` (two walls, at the bonds
`1–2` and `2–3`).  The register is `V8 = Fin 4 × Fin 2` (site × coin). -/

/-- The **exact `+1` mode** of `Wwall`: supported on the reflection-fixed sites
`1, 3`, vanishing on `0, 2`.  Site-1 amplitude `(2,-2)` is the *stable*
eigenvector of the site-amplitude transfer; site-3 amplitude `(1,-1)` is exactly
`(1/2)·` it. -/
def psiPlus : V8 → ℚ := fun x =>
  if x.1 = 1 then (if x.2 = 0 then 2 else -2)
  else if x.1 = 3 then (if x.2 = 0 then 1 else -1)
  else 0

/-- The **exact `-1` mode** of `Wwall`: site-1 amplitude `(-2,-2)`, site-3
amplitude `(1,1) = (-1/2)·` it (stable eigenvalue `-1/2`). -/
def psiMinus : V8 → ℚ := fun x =>
  if x.1 = 1 then -2
  else if x.1 = 3 then 1
  else 0

/-- Per-site squared norm `|psi_site|² = psi(site,0)² + psi(site,1)²`. -/
def siteNormSq (psi : V8 → ℚ) (site : Fin 4) : ℚ :=
  (psi (site, 0)) ^ 2 + (psi (site, 1)) ^ 2

/-- `psiPlus` is an exact `+1` eigenvector of the landed two-wall walk. -/
theorem Wwall_psiPlus : Wwall.mulVec psiPlus = psiPlus := by native_decide

/-- `psiMinus` is an exact `-1` eigenvector of the landed two-wall walk. -/
theorem Wwall_psiMinus : Wwall.mulVec psiMinus = -psiMinus := by native_decide

/-- Both modes are nonzero. -/
theorem psiPlus_ne_zero : psiPlus ≠ 0 := by native_decide
theorem psiMinus_ne_zero : psiMinus ≠ 0 := by native_decide

/-- **Compact localization:** the `+1` mode vanishes on the non-fixed sites `0,2`. -/
theorem psiPlus_localized :
    siteNormSq psiPlus 0 = 0 ∧ siteNormSq psiPlus 2 = 0 := by native_decide
/-- Same for the `-1` mode. -/
theorem psiMinus_localized :
    siteNormSq psiMinus 0 = 0 ∧ siteNormSq psiMinus 2 = 0 := by native_decide

/-- **Exact `1/2`-per-step amplitude contraction (`+1` mode).**  Along the bulk
transfer step `site 1 → site 3` each coin amplitude is scaled by exactly `1/2`. -/
theorem psiPlus_amp_halving :
    ∀ c : Fin 2, psiPlus (3, c) = (1/2) * psiPlus (1, c) := by native_decide

/-- **Exact `-1/2`-per-step amplitude contraction (`-1` mode)** (stable
eigenvalue `-1/2`). -/
theorem psiMinus_amp_halving :
    ∀ c : Fin 2, psiMinus (3, c) = (-1/2) * psiMinus (1, c) := by native_decide

/-- **Exact `(1/4)`-scaled per-site localization (`+1` mode)** with exact
constants: `|psi_3|² = (1/4)·|psi_1|²`, and the site-1 norm is nonzero. -/
theorem psiPlus_quarter_localization :
    siteNormSq psiPlus 3 = (1/4) * siteNormSq psiPlus 1 ∧ siteNormSq psiPlus 1 = 8 := by
  native_decide

/-- **Exact `(1/4)`-scaled per-site localization (`-1` mode).** -/
theorem psiMinus_quarter_localization :
    siteNormSq psiMinus 3 = (1/4) * siteNormSq psiMinus 1 ∧ siteNormSq psiMinus 1 = 8 := by
  native_decide

end PhysicsSM.Draft.NullEdge.PinnedLocalization
