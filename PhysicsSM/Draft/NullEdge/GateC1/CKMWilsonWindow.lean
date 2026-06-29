/-
# C193 CKM-decorated Wilson mass window

Local Draft promotion copied from Aristotle output on 2026-06-28.
Source artifact: AgentTasks/aristotle-output/e63bde80-6cec-4422-a350-0189a78037dc/extracted/0678f49b-4230-465f-94fa-4c0210598cdd_aristotle/RequestProject/Main.lean

Status: Draft artifact, targeted-built on 2026-06-28.
Claim boundary: this is not a proof of full GateC1_NU.
-/

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

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# Gate C1 / C193 — CKM-decorated Wilson/Neuberger free mass-window theorem

This file formalizes the *combined free mass-window / sign-straddling certificate*
for the CKM-decorated Wilson/Neuberger overlap reference.

A sector is labeled by a pair of natural numbers `(n, ell)`:

* `n`   = number of spacetime `π`-components: `n = 0` is the physical mode,
          `n ≥ 1` is a Wilson spacetime doubler;
* `ell` = CKM level: `ell = 0` is CKM-light, `ell > 0` is CKM-heavy.

The shifted sector mass is

```
mu(n, ell) = 2 * r_W * n + w(ell) - m0
```

with CKM weight `w(0) = 0` and `w(ell > 0) = 16 * r_b`.

Under `r_W > 0`, `r_b > 0` and `0 < m0 < min (2*r_W) (16*r_b)` we certify that
*exactly one* sector, namely `(0, 0)`, has negative shifted mass (it is light),
while every spacetime doubler (`n ≥ 1`) and every CKM-heavy sector (`ell > 0`)
has positive shifted mass (they are heavy), with an explicit positive free margin

```
gamma_free = min m0 (min (2*r_W - m0) (16*r_b - m0)).
```

This is **not** a claim of full `GateC1_NU`; it is the free-reference sign-window
certificate that feeds the sector-signature match and the C170/C181
reference-gap budget.
-/

namespace GateC1.CKMWilsonWindow

/-- CKM level weight: `0` for the CKM-light level `ell = 0`,
and `16 * r_b` for any CKM-heavy level `ell > 0`. -/
noncomputable def w (r_b : ℝ) (ell : ℕ) : ℝ := if ell = 0 then 0 else 16 * r_b

@[simp] theorem w_zero (r_b : ℝ) : w r_b 0 = 0 := by simp [w]

theorem w_pos_of_pos {r_b : ℝ} {ell : ℕ} (hl : 0 < ell) :
    w r_b ell = 16 * r_b := by
  simp [w, hl.ne']

/-- Shifted sector mass of sector `(n, ell)`:
`mu(n, ell) = 2 * r_W * n + w(ell) - m0`. -/
noncomputable def mu (r_W r_b m0 : ℝ) (n ell : ℕ) : ℝ :=
  2 * r_W * (n : ℝ) + w r_b ell - m0

/-- The explicit free margin (gap) of the mass window. -/
noncomputable def gamma_free (r_W r_b m0 : ℝ) : ℝ :=
  min m0 (min (2 * r_W - m0) (16 * r_b - m0))

/-- The free margin is strictly positive under the window hypotheses. -/
theorem gamma_free_pos {r_W r_b m0 : ℝ}
    (hm0 : 0 < m0) (hwin : m0 < min (2 * r_W) (16 * r_b)) :
    0 < gamma_free r_W r_b m0 := by
  obtain ⟨h1, h2⟩ := lt_min_iff.mp hwin
  simp only [gamma_free, lt_min_iff]
  exact ⟨hm0, by linarith, by linarith⟩

/-- **(1)** The physical, CKM-light sector `(0,0)` is light: `mu(0,0) < 0`. -/
theorem mu_phys_neg {r_W r_b m0 : ℝ} (hm0 : 0 < m0) :
    mu r_W r_b m0 0 0 < 0 := by
  simp only [mu, w_zero, Nat.cast_zero, mul_zero, add_zero, zero_sub]
  linarith

/-- **(2)** A spacetime doubler at CKM-light level is heavy: for `n ≥ 1`,
`mu(n, 0) > 0`. -/
theorem mu_doubler_pos {r_W r_b m0 : ℝ} (hW : 0 < r_W)
    (hwin : m0 < min (2 * r_W) (16 * r_b)) {n : ℕ} (hn : 1 ≤ n) :
    0 < mu r_W r_b m0 n 0 := by
  have hm : m0 < 2 * r_W := (lt_min_iff.mp hwin).1
  have hn1 : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  simp only [mu, w_zero, add_zero]
  nlinarith [mul_nonneg (by linarith : (0:ℝ) ≤ 2 * r_W) (by linarith : (0:ℝ) ≤ (n:ℝ) - 1)]

/-- **(3)** Any CKM-heavy sector is heavy: for `ell > 0` and every `n`,
`mu(n, ell) > 0`. -/
theorem mu_heavy_pos {r_W r_b m0 : ℝ} (hW : 0 < r_W)
    (hwin : m0 < min (2 * r_W) (16 * r_b)) {n ell : ℕ} (hl : 0 < ell) :
    0 < mu r_W r_b m0 n ell := by
  have hm : m0 < 16 * r_b := (lt_min_iff.mp hwin).2
  have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  rw [mu, w_pos_of_pos hl]
  nlinarith [mul_nonneg (by linarith : (0:ℝ) ≤ 2 * r_W) hn]

/-- **(4)** Sign-split / exactly-one characterization: a sector is light
(`mu < 0`) **iff** it is the physical CKM-light sector `(0,0)`. -/
theorem mu_neg_iff {r_W r_b m0 : ℝ} (hW : 0 < r_W)
    (hm0 : 0 < m0) (hwin : m0 < min (2 * r_W) (16 * r_b)) (n ell : ℕ) :
    mu r_W r_b m0 n ell < 0 ↔ (n = 0 ∧ ell = 0) := by
  constructor
  · intro h
    by_contra hc
    have hpos : 0 < mu r_W r_b m0 n ell := by
      rcases Nat.eq_zero_or_pos ell with he | he
      · subst he
        have hn0 : n ≠ 0 := by simpa using hc
        exact mu_doubler_pos hW hwin (Nat.one_le_iff_ne_zero.mpr hn0)
      · exact mu_heavy_pos hW hwin he
    linarith
  · rintro ⟨rfl, rfl⟩
    exact mu_phys_neg hm0

/-- **(5a)** Quantitative margin for the light sector: the physical sector mass
is below `-gamma_free`. -/
theorem mu_phys_le_neg_margin {r_W r_b m0 : ℝ} :
    mu r_W r_b m0 0 0 ≤ - gamma_free r_W r_b m0 := by
  have hmu : mu r_W r_b m0 0 0 = -m0 := by
    simp only [mu, w_zero, Nat.cast_zero, mul_zero, add_zero, zero_sub]
  have hg : gamma_free r_W r_b m0 ≤ m0 := min_le_left _ _
  rw [hmu]; linarith

/-- **(5b)** Quantitative margin for the heavy sectors: every non-physical sector
mass is at least `gamma_free`. -/
theorem mu_heavy_ge_margin {r_W r_b m0 : ℝ} (hW : 0 < r_W)
    (n ell : ℕ) (h : ¬ (n = 0 ∧ ell = 0)) :
    gamma_free r_W r_b m0 ≤ mu r_W r_b m0 n ell := by
  have hg2 : gamma_free r_W r_b m0 ≤ 2 * r_W - m0 :=
    le_trans (min_le_right _ _) (min_le_left _ _)
  have hg3 : gamma_free r_W r_b m0 ≤ 16 * r_b - m0 :=
    le_trans (min_le_right _ _) (min_le_right _ _)
  rcases Nat.eq_zero_or_pos ell with he | he
  · subst he
    have hn0 : n ≠ 0 := by simpa using h
    have hn1 : (1 : ℝ) ≤ (n : ℝ) := by
      exact_mod_cast Nat.one_le_iff_ne_zero.mpr hn0
    rw [mu, w_zero, add_zero]
    nlinarith [mul_nonneg (by linarith : (0:ℝ) ≤ 2 * r_W) (by linarith : (0:ℝ) ≤ (n:ℝ) - 1)]
  · rw [mu, w_pos_of_pos he]
    have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    nlinarith [mul_nonneg (by linarith : (0:ℝ) ≤ 2 * r_W) hn]

/-- **Counting / multiplicity.** Over the `d = 4` spacetime corners
(`n ∈ {0,1,2,3}`) and the `16` CKM corners (`ell ∈ {0,…,15}`), exactly one
sector — `(0,0)` — is light. -/
theorem light_sector_count {r_W r_b m0 : ℝ} (hW : 0 < r_W)
    (hm0 : 0 < m0) (hwin : m0 < min (2 * r_W) (16 * r_b)) :
    ((Finset.range 4 ×ˢ Finset.range 16).filter
        (fun p => mu r_W r_b m0 p.1 p.2 < 0)).card = 1 := by
  have hset : (Finset.range 4 ×ˢ Finset.range 16).filter
      (fun p => mu r_W r_b m0 p.1 p.2 < 0) = {(0, 0)} := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_product, Finset.mem_range,
      Finset.mem_singleton]
    rw [mu_neg_iff hW hm0 hwin]
    constructor
    · rintro ⟨-, h1, h2⟩
      exact Prod.ext_iff.mpr ⟨h1, h2⟩
    · rintro rfl
      exact ⟨⟨by norm_num, by norm_num⟩, rfl, rfl⟩
  rw [hset, Finset.card_singleton]

/-- **Combined free mass-window / sign-straddling certificate.**

Under the model hypotheses `r_W > 0`, `r_b > 0` and
`0 < m0 < min (2*r_W) (16*r_b)`, the CKM-decorated Wilson/Neuberger reference
straddles zero in exactly one sector:

1. the physical CKM-light sector `(0,0)` is light (`mu < 0`);
2. every spacetime doubler at CKM-light level (`n ≥ 1`, `ell = 0`) is heavy;
3. every CKM-heavy sector (`ell > 0`, any `n`) is heavy;
4. a sector is light iff it is `(0,0)`, so there is exactly one light sector;
5. there is a uniform positive free margin `gamma_free`: the light sector sits at
   `≤ -gamma_free` and every heavy sector at `≥ gamma_free`, with
   `0 < gamma_free`.

This bundles `mu_phys_neg`, `mu_doubler_pos`, `mu_heavy_pos`, `mu_neg_iff`,
`gamma_free_pos`, `mu_phys_le_neg_margin` and `mu_heavy_ge_margin`.

Feeds: the sign-split (parts 1–4) supplies the sector-signature match for the
Wilson+CKM reference (one light = one physical generation slot, all doublers and
CKM-heavy partners lifted), and the explicit margin `gamma_free` (part 5) is the
quantity entering the C170/C181 reference-gap budget — any perturbation of size
below `gamma_free` cannot move a heavy sector across zero or lift the light one,
so the sign pattern is stable within that budget.

Note on hypotheses: the model nominally assumes `r_W > 0` and `r_b > 0`, but both
are already implied by `0 < m0 < min (2*r_W) (16*r_b)` (e.g.
`0 < m0 < 16*r_b` forces `0 < r_b`). We therefore keep only `r_W > 0` (which the
proof uses directly) and drop the redundant `r_b > 0`; nothing is lost.

This is **not** a proof of full `GateC1_NU`; it is the free-reference
mass-window certificate only. -/
theorem gateC1_free_mass_window {r_W r_b m0 : ℝ}
    (hW : 0 < r_W) (hm0 : 0 < m0)
    (hwin : m0 < min (2 * r_W) (16 * r_b)) :
    -- (1) physical sector is light
    mu r_W r_b m0 0 0 < 0 ∧
    -- (2) spacetime doublers (CKM-light) are heavy
    (∀ n : ℕ, 1 ≤ n → 0 < mu r_W r_b m0 n 0) ∧
    -- (3) CKM-heavy sectors are heavy
    (∀ n ell : ℕ, 0 < ell → 0 < mu r_W r_b m0 n ell) ∧
    -- (4) light iff physical CKM-light sector
    (∀ n ell : ℕ, mu r_W r_b m0 n ell < 0 ↔ (n = 0 ∧ ell = 0)) ∧
    -- (5) explicit positive free margin
    0 < gamma_free r_W r_b m0 ∧
    mu r_W r_b m0 0 0 ≤ - gamma_free r_W r_b m0 ∧
    (∀ n ell : ℕ, ¬ (n = 0 ∧ ell = 0) →
        gamma_free r_W r_b m0 ≤ mu r_W r_b m0 n ell) := by
  refine ⟨mu_phys_neg hm0, ?_, ?_, ?_, gamma_free_pos hm0 hwin,
    mu_phys_le_neg_margin, ?_⟩
  · intro n hn; exact mu_doubler_pos hW hwin hn
  · intro n ell hl; exact mu_heavy_pos hW hwin hl
  · intro n ell; exact mu_neg_iff hW hm0 hwin n ell
  · intro n ell h; exact mu_heavy_ge_margin hW n ell h

end GateC1.CKMWilsonWindow
