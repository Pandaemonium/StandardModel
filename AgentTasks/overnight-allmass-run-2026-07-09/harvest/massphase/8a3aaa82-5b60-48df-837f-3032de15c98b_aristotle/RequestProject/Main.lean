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

set_option grind.warning false

/-!
# The multi-channel mass-phase diagram of the 4-parameter block (P-B)

This file gives an explicit, fully finite / rational-linear-algebra model of the mass-phase
diagram of a four-channel block.  The four couplings are

* `lam` — the **aperture** (diagonal mass term),
* `kap` — the **closure** (the landed off-diagonal `[[lam,kap,0],[kap,lam,0],[0,0,lam]]`),
* `tau` — the **chiral turn** (a second off-diagonal channel),
* `E`   — the **soldering** (a diagonal shift `lam ↦ lam + E`).

We assemble the real symmetric rational `3×3` block

```
Bc = [[lam+E, kap,   tau  ],
      [kap,   lam+E, 0    ],
      [tau,   0,     lam+E]]
```

Its characteristic polynomial factors completely over `ℝ` as
`(μ - d)·((μ - d)^2 - (kap^2 + tau^2))` with `d = lam + E`, so its spectrum is
`{ d, d ± √(kap^2 + tau^2) }`.  The least eigenvalue `m^2 = d - √(kap^2+tau^2)` is the mass of the
lightest sector.  Rather than introduce `Real.sqrt`, we classify the sign of `m^2` through the
quadratic form `Q(x) = xᵀ Bc x`, which is the standard sqrt-free characterisation:

* **MASSIVE**  — `Q` positive definite   (`m^2 > 0`),
* **CRITICAL** — `Q` PSD with a kernel   (`m^2 = 0`),
* **GHOST**    — `Q` has a negative direction (`m^2 < 0`).

The closed-form **critical surface** is `(lam+E)^2 = kap^2 + tau^2` with `lam+E ≥ 0`, generalising
the landed critical line `|kap| = lam` (recovered at `tau = E = 0`).

Everything is proved over `ℝ` with rational witnesses; kernel-checked, no `sorry`, no `Real.sqrt`,
no `Complex`.
-/

namespace MassPhase4Channel

/-- The soldered aperture `d = lam + E` (the common diagonal entry of the block). -/
def dCoup (lam E : ℝ) : ℝ := lam + E

/-- The explicit real symmetric rational four-channel block. -/
def Bc (lam kap tau E : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![lam + E, kap, tau; kap, lam + E, 0; tau, 0, lam + E]

/-- The quadratic form `Q(x) = xᵀ Bc x` of the block, written out explicitly. -/
def Q (lam kap tau E : ℝ) (x : Fin 3 → ℝ) : ℝ :=
  (lam + E) * ((x 0) ^ 2 + (x 1) ^ 2 + (x 2) ^ 2)
    + 2 * kap * (x 0) * (x 1) + 2 * tau * (x 0) * (x 2)

/-- The **criticality discriminant** (margin): `margin > 0` ↔ massive, `= 0` ↔ critical,
`< 0` ↔ ghost (when `lam+E ≥ 0`). -/
def margin (lam kap tau E : ℝ) : ℝ := (lam + E) ^ 2 - (kap ^ 2 + tau ^ 2)

/-- The block is a real symmetric matrix. -/
theorem Bc_isSymm (lam kap tau E : ℝ) : (Bc lam kap tau E).IsSymm := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Bc]

/-- `Q` is genuinely the quadratic form `xᵀ Bc x` of the block. -/
theorem Q_eq_quadForm (lam kap tau E : ℝ) (x : Fin 3 → ℝ) :
    Q lam kap tau E x = (Bc lam kap tau E).mulVec x ⬝ᵥ x := by
  simp [Q, Bc, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  ring

/-- **The key SOS identity** driving every phase result:
`d·Q = (d·x₀+kap·x₁+tau·x₂)² + (tau·x₁-kap·x₂)² + (d²-kap²-tau²)(x₁²+x₂²)`, with `d = lam+E`. -/
theorem key_identity (lam kap tau E : ℝ) (x : Fin 3 → ℝ) :
    (lam + E) * Q lam kap tau E x
      = ((lam + E) * (x 0) + kap * (x 1) + tau * (x 2)) ^ 2
        + (tau * (x 1) - kap * (x 2)) ^ 2
        + ((lam + E) ^ 2 - kap ^ 2 - tau ^ 2) * ((x 1) ^ 2 + (x 2) ^ 2) := by
  simp only [Q]; ring

/-!
## Target 1 : the spectrum in closed form
-/

/-- **`spectrum_closed_form`** : the characteristic polynomial of `Bc` factors completely,
`det(μ·I - Bc) = (μ - d)·((μ - d)^2 - (kap^2 + tau^2))` with `d = lam + E`.  Its roots are the
eigenvalues `d` and `d ± √(kap^2+tau^2)`. -/
theorem spectrum_closed_form (lam kap tau E μ : ℝ) :
    (μ • (1 : Matrix (Fin 3) (Fin 3) ℝ) - Bc lam kap tau E).det
      = (μ - (lam + E)) * ((μ - (lam + E)) ^ 2 - (kap ^ 2 + tau ^ 2)) := by
  simp [Bc, Matrix.det_fin_three, Matrix.one_fin_three]
  ring

/-- The soldered aperture `d = lam + E` is an eigenvalue, with rational eigenvector `(0, tau, -kap)`. -/
theorem eigen_d (lam kap tau E : ℝ) :
    (Bc lam kap tau E).mulVec ![0, tau, -kap] = (lam + E) • ![0, tau, -kap] := by
  funext i
  fin_cases i <;> simp [Bc, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  all_goals ring

/-!
## Target 2 : the phase predicates and their exhaustivity / exclusivity
-/

/-- **MASSIVE** phase : `Q` is positive definite (`m^2 > 0`). -/
def Massive (lam kap tau E : ℝ) : Prop :=
  ∀ x : Fin 3 → ℝ, x ≠ 0 → 0 < Q lam kap tau E x

/-- **CRITICAL** phase : `Q` is positive semidefinite with a non-trivial kernel (`m^2 = 0`). -/
def Critical (lam kap tau E : ℝ) : Prop :=
  (∀ x : Fin 3 → ℝ, 0 ≤ Q lam kap tau E x) ∧ (∃ x : Fin 3 → ℝ, x ≠ 0 ∧ Q lam kap tau E x = 0)

/-- **GHOST** / over-closure phase : `Q` has a negative direction (`m^2 < 0`). -/
def Ghost (lam kap tau E : ℝ) : Prop :=
  ∃ x : Fin 3 → ℝ, Q lam kap tau E x < 0

/-- The three phases are **exhaustive**. -/
theorem phases_exhaustive (lam kap tau E : ℝ) :
    Massive lam kap tau E ∨ Critical lam kap tau E ∨ Ghost lam kap tau E := by
  by_cases hg : Ghost lam kap tau E
  · exact Or.inr (Or.inr hg)
  · have hpsd : ∀ x : Fin 3 → ℝ, 0 ≤ Q lam kap tau E x := by
      intro x
      by_contra h
      exact hg ⟨x, lt_of_not_ge h⟩
    by_cases hm : Massive lam kap tau E
    · exact Or.inl hm
    · refine Or.inr (Or.inl ⟨hpsd, ?_⟩)
      simp only [Massive, not_forall] at hm
      obtain ⟨x, hx, hxle⟩ := hm
      exact ⟨x, hx, le_antisymm (not_lt.1 hxle) (hpsd x)⟩

/-- MASSIVE and CRITICAL are mutually exclusive. -/
theorem not_massive_critical (lam kap tau E : ℝ) :
    ¬ (Massive lam kap tau E ∧ Critical lam kap tau E) := by
  rintro ⟨hm, _, x, hx, hx0⟩
  exact (lt_irrefl _ (hx0 ▸ hm x hx))

/-- MASSIVE and GHOST are mutually exclusive. -/
theorem not_massive_ghost (lam kap tau E : ℝ) :
    ¬ (Massive lam kap tau E ∧ Ghost lam kap tau E) := by
  rintro ⟨hm, x, hx⟩
  by_cases h0 : x = 0
  · rw [h0] at hx; simp [Q] at hx
  · exact absurd (hm x h0) (not_lt.2 (le_of_lt hx))

/-- CRITICAL and GHOST are mutually exclusive. -/
theorem not_critical_ghost (lam kap tau E : ℝ) :
    ¬ (Critical lam kap tau E ∧ Ghost lam kap tau E) := by
  rintro ⟨⟨hpsd, _⟩, x, hx⟩
  exact absurd (hpsd x) (not_le.2 hx)

/-!
## Target 3 : the closed-form phase boundaries
-/

/-- Arithmetic criterion for the MASSIVE phase. -/
def critMassive (lam kap tau E : ℝ) : Prop := 0 < lam + E ∧ kap ^ 2 + tau ^ 2 < (lam + E) ^ 2

/-- Arithmetic criterion for the CRITICAL phase (the **critical surface**). -/
def critCritical (lam kap tau E : ℝ) : Prop := 0 ≤ lam + E ∧ kap ^ 2 + tau ^ 2 = (lam + E) ^ 2

/-- Arithmetic criterion for the GHOST phase. -/
def critGhost (lam kap tau E : ℝ) : Prop := lam + E < 0 ∨ (lam + E) ^ 2 < kap ^ 2 + tau ^ 2

/-- The arithmetic criteria are exhaustive. -/
theorem crit_exhaustive (lam kap tau E : ℝ) :
    critMassive lam kap tau E ∨ critCritical lam kap tau E ∨ critGhost lam kap tau E := by
  unfold critMassive critCritical critGhost
  rcases lt_trichotomy (lam + E) 0 with hd | hd | hd
  · exact Or.inr (Or.inr (Or.inl hd))
  · rcases lt_trichotomy (kap ^ 2 + tau ^ 2) ((lam + E) ^ 2) with h | h | h
    · exact Or.inl ⟨by rw [hd]; norm_num at h ⊢; nlinarith [sq_nonneg kap, sq_nonneg tau], h⟩
    · exact Or.inr (Or.inl ⟨le_of_eq hd.symm, h⟩)
    · exact Or.inr (Or.inr (Or.inr h))
  · rcases lt_trichotomy (kap ^ 2 + tau ^ 2) ((lam + E) ^ 2) with h | h | h
    · exact Or.inl ⟨hd, h⟩
    · exact Or.inr (Or.inl ⟨le_of_lt hd, h⟩)
    · exact Or.inr (Or.inr (Or.inr h))

/-- The arithmetic criteria are mutually exclusive. -/
theorem crit_exclusive (lam kap tau E : ℝ) :
    ¬ (critMassive lam kap tau E ∧ critCritical lam kap tau E) ∧
    ¬ (critMassive lam kap tau E ∧ critGhost lam kap tau E) ∧
    ¬ (critCritical lam kap tau E ∧ critGhost lam kap tau E) := by
  unfold critMassive critCritical critGhost
  refine ⟨?_, ?_, ?_⟩
  · rintro ⟨⟨_, h1⟩, _, h2⟩; linarith
  · rintro ⟨⟨hd, h1⟩, h2 | h2⟩ <;> linarith
  · rintro ⟨⟨hd, h1⟩, h2 | h2⟩ <;> linarith

/-
criterion ⟹ MASSIVE.
-/
theorem massive_of (lam kap tau E : ℝ) (h : critMassive lam kap tau E) :
    Massive lam kap tau E := by
  intro x hx_ne_zero
  obtain ⟨hd_pos, hc⟩ := h;
  by_cases hx12 : x 1 = 0 ∧ x 2 = 0;
  · unfold Q; simp_all +decide [ funext_iff, Fin.forall_fin_succ ] ;
    positivity;
  · have hkey := key_identity lam kap tau E x;
    nlinarith [ show 0 < ( lam + E ) ^ 2 - kap ^ 2 - tau ^ 2 by linarith, show 0 < x 1 ^ 2 + x 2 ^ 2 by exact not_le.mp fun h => hx12 ⟨ by nlinarith, by nlinarith ⟩ ]

/-
criterion ⟹ CRITICAL.
-/
theorem critical_of (lam kap tau E : ℝ) (h : critCritical lam kap tau E) :
    Critical lam kap tau E := by
  constructor;
  · unfold critCritical at h;
    intro x;
    by_cases h₂ : lam + E = 0;
    · unfold Q; simp_all +decide [ add_eq_zero_iff_eq_neg ] ;
      norm_num [ show kap = 0 by nlinarith, show tau = 0 by nlinarith ];
    · unfold Q;
      cases lt_or_gt_of_ne h₂ <;> nlinarith [ sq_nonneg ( ( lam + E ) * x 0 + kap * x 1 + tau * x 2 ), sq_nonneg ( tau * x 1 - kap * x 2 ) ];
  · by_cases h_d : lam + E = 0;
    · use ![1, 0, 0];
      unfold Q; aesop;
    · refine' ⟨ fun i => if i = 0 then - ( lam + E ) else if i = 1 then kap else tau, _, _ ⟩ <;> simp_all +decide [ funext_iff, Fin.forall_fin_succ ];
      · exact fun h₁ h₂ h₃ => h_d <| by linarith;
      · grind +locals

/-
criterion ⟹ GHOST.
-/
theorem ghost_of (lam kap tau E : ℝ) (h : critGhost lam kap tau E) :
    Ghost lam kap tau E := by
  rcases h with ( h | h );
  · exact ⟨ fun i => if i.val = 0 then 1 else 0, by simpa [ Q ] using by nlinarith ⟩;
  · -- If $d > 0$, use $x = ![-(kap^2+tau^2), d*kap, d*tau]$.
    by_cases hd_pos : 0 < lam + E;
    · use ![-(kap^2 + tau^2), (lam + E) * kap, (lam + E) * tau];
      unfold Q;
      simp +zetaDelta at *;
      nlinarith [ mul_pos hd_pos ( sub_pos.mpr h ) ];
    · exact ⟨ fun i => if i = 0 then 1 else if i = 1 then -kap else -tau, by simp +decide [ Q ] ; nlinarith ⟩

/-- **`massive_iff`** : the MASSIVE phase is exactly `0 < lam+E ∧ kap^2+tau^2 < (lam+E)^2`. -/
theorem massive_iff (lam kap tau E : ℝ) :
    Massive lam kap tau E ↔ critMassive lam kap tau E := by
  constructor
  · intro hM
    rcases crit_exhaustive lam kap tau E with h | h | h
    · exact h
    · exact absurd ⟨hM, critical_of _ _ _ _ h⟩ (not_massive_critical _ _ _ _)
    · exact absurd ⟨hM, ghost_of _ _ _ _ h⟩ (not_massive_ghost _ _ _ _)
  · exact massive_of _ _ _ _

/-- **`critical_iff`** : the CRITICAL phase is exactly the surface `kap^2+tau^2 = (lam+E)^2`,
`lam+E ≥ 0`.  This generalises the landed critical line `|kap| = lam` (take `tau = E = 0`). -/
theorem critical_iff (lam kap tau E : ℝ) :
    Critical lam kap tau E ↔ critCritical lam kap tau E := by
  constructor
  · intro hC
    rcases crit_exhaustive lam kap tau E with h | h | h
    · exact absurd ⟨massive_of _ _ _ _ h, hC⟩ (not_massive_critical _ _ _ _)
    · exact h
    · exact absurd ⟨hC, ghost_of _ _ _ _ h⟩ (not_critical_ghost _ _ _ _)
  · exact critical_of _ _ _ _

/-- **`ghost_iff`** : the GHOST phase is exactly `lam+E < 0 ∨ (lam+E)^2 < kap^2+tau^2`. -/
theorem ghost_iff (lam kap tau E : ℝ) :
    Ghost lam kap tau E ↔ critGhost lam kap tau E := by
  constructor
  · intro hG
    rcases crit_exhaustive lam kap tau E with h | h | h
    · exact absurd ⟨massive_of _ _ _ _ h, hG⟩ (not_massive_ghost _ _ _ _)
    · exact absurd ⟨critical_of _ _ _ _ h, hG⟩ (not_critical_ghost _ _ _ _)
    · exact h
  · exact ghost_of _ _ _ _

/-!
## Mandatory non-degeneracy : explicit rational witnesses with computed `m^2`
-/

/-- **Massive witness** : the all-aperture point `lam=1, kap=tau=E=0`.  Spectrum `{1,1,1}`,
so the least eigenvalue is `m^2 = 1 > 0`. -/
theorem witness_massive :
    Massive 1 0 0 0 ∧
      (∀ μ : ℝ, (μ • (1 : Matrix (Fin 3) (Fin 3) ℝ) - Bc 1 0 0 0).det = (μ - 1) ^ 3) := by
  refine ⟨(massive_iff 1 0 0 0).2 ?_, ?_⟩
  · constructor <;> norm_num
  · intro μ; rw [spectrum_closed_form]; ring

/-- **Critical witness** : `lam=1, kap=1, tau=E=0` (the landed `|kap|=lam` line).  Spectrum
`{0,1,2}`, so the least eigenvalue is `m^2 = 0`; the kernel vector is `(1,-1,0)`. -/
theorem witness_critical :
    Critical 1 1 0 0 ∧
      (∀ μ : ℝ, (μ • (1 : Matrix (Fin 3) (Fin 3) ℝ) - Bc 1 1 0 0).det = μ * (μ - 1) * (μ - 2)) ∧
      (Bc 1 1 0 0).mulVec ![1, -1, 0] = (0 : ℝ) • ![1, -1, 0] := by
  refine ⟨(critical_iff 1 1 0 0).2 ?_, ?_, ?_⟩
  · constructor <;> norm_num
  · intro μ; rw [spectrum_closed_form]; ring
  · funext i
    fin_cases i <;> simp [Bc, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-- **Ghost witness** : `lam=1, kap=2, tau=E=0`.  Spectrum `{-1,1,3}`, so the least eigenvalue is
`m^2 = -1 < 0`; the negative-mode eigenvector is `(1,-1,0)`. -/
theorem witness_ghost :
    Ghost 1 2 0 0 ∧
      (∀ μ : ℝ, (μ • (1 : Matrix (Fin 3) (Fin 3) ℝ) - Bc 1 2 0 0).det
          = (μ + 1) * (μ - 1) * (μ - 3)) ∧
      (Bc 1 2 0 0).mulVec ![1, -1, 0] = (-1 : ℝ) • ![1, -1, 0] := by
  refine ⟨(ghost_iff 1 2 0 0).2 ?_, ?_, ?_⟩
  · right; norm_num
  · intro μ; rw [spectrum_closed_form]; ring
  · funext i
    fin_cases i <;> simp [Bc, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
    all_goals norm_num

/-!
## Target 4 : the qualitative role of each channel

The `margin (lam+E)^2 - (kap^2+tau^2)` controls the phase (its sign, at `lam+E ≥ 0`, is the sign of
`m^2`).  We record the monotonicity of `margin` in each channel and, concretely, that turning a
channel moves a fixed rational point across the critical surface.
-/

/-- **Aperture is a mass generator** : raising `lam` (at `lam+E ≥ 0`) raises the margin. -/
theorem aperture_raises (lam₁ lam₂ kap tau E : ℝ) (hd : 0 ≤ lam₁ + E) (h : lam₁ < lam₂) :
    margin lam₁ kap tau E < margin lam₂ kap tau E := by
  unfold margin; nlinarith

/-- **Soldering shifts the mass** : raising `E` (at `lam+E ≥ 0`) raises the margin. -/
theorem soldering_raises (lam kap tau E₁ E₂ : ℝ) (hd : 0 ≤ lam + E₁) (h : E₁ < E₂) :
    margin lam kap tau E₁ < margin lam kap tau E₂ := by
  unfold margin; nlinarith

/-- **Closure is a mass reducer** : increasing `kap^2` lowers the margin. -/
theorem closure_reduces (lam kap₁ kap₂ tau E : ℝ) (h : kap₁ ^ 2 < kap₂ ^ 2) :
    margin lam kap₂ tau E < margin lam kap₁ tau E := by
  unfold margin; linarith

/-- **Chiral turn is a mass reducer** : increasing `tau^2` lowers the margin. -/
theorem turn_reduces (lam kap tau₁ tau₂ E : ℝ) (h : tau₁ ^ 2 < tau₂ ^ 2) :
    margin lam kap tau₂ E < margin lam kap tau₁ E := by
  unfold margin; linarith

/-- **Aperture generates mass, concretely** : the ghost point `(1,2,0,0)` becomes massive when the
aperture is raised to `3`. -/
theorem aperture_generates_mass : Ghost 1 2 0 0 ∧ Massive 3 2 0 0 := by
  refine ⟨(ghost_iff 1 2 0 0).2 (Or.inr (by norm_num)), (massive_iff 3 2 0 0).2 ⟨by norm_num, by norm_num⟩⟩

/-- **Closure reduces mass, concretely** : the massive point `(3,0,0,0)` becomes a ghost when the
closure is raised to `4`. -/
theorem closure_reduces_mass : Massive 3 0 0 0 ∧ Ghost 3 4 0 0 := by
  refine ⟨(massive_iff 3 0 0 0).2 ⟨by norm_num, by norm_num⟩, (ghost_iff 3 4 0 0).2 (Or.inr (by norm_num))⟩

/-- **Chiral turn reduces mass, concretely** : the massive point `(3,0,0,0)` becomes a ghost when the
turn is raised to `4`. -/
theorem turn_reduces_mass : Massive 3 0 0 0 ∧ Ghost 3 0 4 0 := by
  refine ⟨(massive_iff 3 0 0 0).2 ⟨by norm_num, by norm_num⟩, (ghost_iff 3 0 4 0).2 (Or.inr (by norm_num))⟩

/-- **Soldering shifts across criticality, concretely** : the ghost point `(1,2,0,0)` becomes massive
when soldering `E = 2` is turned on. -/
theorem soldering_shifts_mass : Ghost 1 2 0 0 ∧ Massive 1 2 0 2 := by
  refine ⟨(ghost_iff 1 2 0 0).2 (Or.inr (by norm_num)), (massive_iff 1 2 0 2).2 ⟨by norm_num, by norm_num⟩⟩

/-!
## Kernel-checked axiom footprint of every headline result

Each headline depends only on `[propext, Classical.choice, Quot.sound]` — no `sorry`, no
`native_decide`, no new axioms.
-/

/-- info: 'MassPhase4Channel.spectrum_closed_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spectrum_closed_form

/-- info: 'MassPhase4Channel.eigen_d' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eigen_d

/-- info: 'MassPhase4Channel.phases_exhaustive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phases_exhaustive

/-- info: 'MassPhase4Channel.not_massive_critical' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms not_massive_critical

/-- info: 'MassPhase4Channel.not_massive_ghost' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms not_massive_ghost

/-- info: 'MassPhase4Channel.not_critical_ghost' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms not_critical_ghost

/-- info: 'MassPhase4Channel.massive_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_iff

/-- info: 'MassPhase4Channel.critical_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms critical_iff

/-- info: 'MassPhase4Channel.ghost_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ghost_iff

/-- info: 'MassPhase4Channel.witness_massive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_massive

/-- info: 'MassPhase4Channel.witness_critical' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_critical

/-- info: 'MassPhase4Channel.witness_ghost' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_ghost

/-- info: 'MassPhase4Channel.aperture_raises' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms aperture_raises

/-- info: 'MassPhase4Channel.soldering_raises' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms soldering_raises

/-- info: 'MassPhase4Channel.closure_reduces' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms closure_reduces

/-- info: 'MassPhase4Channel.turn_reduces' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms turn_reduces

/-- info: 'MassPhase4Channel.aperture_generates_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms aperture_generates_mass

/-- info: 'MassPhase4Channel.closure_reduces_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms closure_reduces_mass

/-- info: 'MassPhase4Channel.turn_reduces_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms turn_reduces_mass

/-- info: 'MassPhase4Channel.soldering_shifts_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms soldering_shifts_mass

end MassPhase4Channel
