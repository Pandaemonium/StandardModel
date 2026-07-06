import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
import PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
import PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomySeparation

/-!
# Gate I1 / NE-U: mass-taxonomy NON-DEGENERACY (independent realizability)

This module is the non-degeneracy companion to
`MassTaxonomySeparation.massTaxonomy_functionals_pairwise_separated`. That
theorem shows the four null-edge mass functionals are PAIRWISE DISTINCT (each can
vanish while another is positive). "Pairwise distinct" does not by itself say the
taxonomy is **non-degenerate**: that each obstruction is *independently
realizable* — turnable ON while the others are held OFF — so no functional is a
shadow of another. This file supplies that upgrade.

## The four functionals and their (INDEPENDENT) parameter domains

The whole point is that the four masses live on **separate parameter domains**,
which is exactly why independent realizability is available:

| leg | functional | parameter domain |
| --- | ---------- | ---------------- |
| regulator | `wilsonRegulatorMass r = log (1 + 4 r)` | `r : ℝ` |
| closure   | `z2GlueballMass β = log coth β`          | `β : ℝ` |
| turn/bare | `quarkMassParameter` (detached input)    | (none; pinned `= 0`) |
| aperture  | `compositeApertureMassSq p q = minkowskiSq (p+q)` | `p q : Momentum4` (null) |

Because these domains are independent, a configuration turning one mass ON places
no constraint on the others; we simply evaluate each other functional at an OFF
witness on its own domain.

## Which legs have clean in-range OFF/ON witnesses (honesty report)

* **regulator** — two-sided and clean: OFF at `r = 0` (`wilsonRegulatorMass 0 = 0`,
  in range) and ON at any `r > 0` (`wilsonRegulatorMass_pos`).
* **aperture** — two-sided and clean: OFF at collinear momenta
  (`compositeApertureMassSq nullX nullX = 0`, in range) and ON at a non-collinear
  future-null pair (`compositeApertureMassSq nullX nullY > 0`).
* **closure** — ON is clean (`z2GlueballMass β > 0` for every `β > 0`), but there
  is **NO in-range (finite `β > 0`) OFF witness**: `log coth β > 0` throughout the
  physical range and vanishes only in the limit `β → ∞`
  (`z2GlueballMass_off_limit`). The equality `z2GlueballMass 0 = 0`
  (`z2GlueballMass_boundary_zero`) used as the closure OFF slot in the bundle is
  the value at the DEGENERATE boundary `β = 0`, produced by Lean's
  division-by-zero convention (`coth` is singular there); it is a boundary/limit
  artifact, not a finite-temperature gap closure. See the docstrings for the exact
  claims.
* **turn/bare** — the EXCEPTIONAL leg. `quarkMassParameter` is a detached input
  constant pinned to `0`, so it has a clean OFF witness (trivially `= 0`) but
  admits **NO ON witness**: there is no parameter to vary and it can never be
  strictly positive (`turn_identically_off`). Its non-degeneracy content is
  therefore the honest dual: it stays OFF while the other three are independently
  turned ON (`turn_off_others_on`).

## Honesty note (scope of this statement)

Independent realizability here follows **because the four functionals live on
independent parameter domains**. This is a NON-DEGENERACY / basis-like statement
about the FUNCTIONALS: no one of them is a reparametrization or shadow of another.
It is emphatically **NOT** a claim that a single physical model exhibits all four
masses at once (a "common carrier" turning all four ON in one system). That
stronger claim is a separate question and is explicitly **NOT** proved here.

## Claim discipline

Claim label: **finite identity / taxonomy non-degeneracy**. Draft-trust,
kernel-checked, `sorry`-free, no new axioms, no `native_decide`. Reuses the
existing functionals from `MassTaxonomySeparation` / `MassWithoutMass` verbatim
(nothing is weakened or restated). This is a statement about the FUNCTIONALS, not
a physical claim about QCD.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace MassTaxonomyNonDegeneracy

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
open PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomySeparation

/-! ## Closure off-witnesses: boundary value, no in-range zero, and the honest limit -/

/-- **Closure boundary value.** At the degenerate boundary `β = 0` the closure
mass is exactly zero. This is the div-by-zero convention: `coth` is singular at
`β = 0` (`sinh 0 = 0`), Lean sets `cosh 0 / sinh 0 = 1 / 0 = 0`, and
`Real.log 0 = 0`. It is a boundary artifact used as the closure OFF slot in the
bundle, NOT a finite-temperature gap closure. -/
theorem z2GlueballMass_boundary_zero : z2GlueballMass 0 = 0 := by
  simp [z2GlueballMass, gap2]

/-- Bridge to the `coth` form: `z2GlueballMass β = log(cosh β / sinh β)`.  Both
equal `log((e^β+e^{-β})/(e^β-e^{-β}))`; the repo's `z2GlueballMass` is defined via
`gap2` on the exponentials, so this reconciles it with the hyperbolic form. -/
theorem z2GlueballMass_eq_log_cosh_div_sinh (β : ℝ) :
    z2GlueballMass β = Real.log (Real.cosh β / Real.sinh β) := by
  rw [z2GlueballMass, gap2, Real.cosh_eq, Real.sinh_eq,
    div_div_div_cancel_right₀ (show (2 : ℝ) ≠ 0 by norm_num)]

/-- **Closure has no in-range OFF witness.** For every finite `β > 0` the closure
mass is strictly positive, hence never zero. So, unlike the regulator and
aperture legs, the closure leg has no clean interior zero. -/
theorem z2GlueballMass_no_inrange_zero {β : ℝ} (hβ : 0 < β) :
    z2GlueballMass β ≠ 0 :=
  ne_of_gt (z2GlueballMass_pos hβ)

/-
**Closure genuine physical off-limit.** The honest OFF direction for the
closure mass is the limit `β → ∞`: `coth β → 1`, so `z2GlueballMass β = log coth β
→ 0`. This — not the `β = 0` boundary value — is the physical gap-closing limit.
-/
theorem z2GlueballMass_off_limit :
    Filter.Tendsto (fun β => z2GlueballMass β) Filter.atTop (nhds 0) := by
  have hbot : Filter.Tendsto (fun β : ℝ => -2 * β) Filter.atTop Filter.atBot :=
    Filter.tendsto_atTop_atBot.mpr fun x => ⟨-x / 2, fun y hy => by linarith⟩
  have hexp : Filter.Tendsto (fun β : ℝ => Real.exp (-2 * β)) Filter.atTop (nhds 0) :=
    Real.tendsto_exp_atBot.comp hbot
  have hratio :
      Filter.Tendsto (fun β : ℝ => Real.cosh β / Real.sinh β) Filter.atTop (nhds 1) := by
    have hlim :
        Filter.Tendsto (fun β : ℝ => (1 + Real.exp (-2 * β)) / (1 - Real.exp (-2 * β)))
          Filter.atTop (nhds 1) := by
      have hnum : Filter.Tendsto (fun β : ℝ => 1 + Real.exp (-2 * β)) Filter.atTop (nhds 1) := by
        simpa using tendsto_const_nhds.add hexp
      have hden : Filter.Tendsto (fun β : ℝ => 1 - Real.exp (-2 * β)) Filter.atTop (nhds 1) := by
        simpa using tendsto_const_nhds.sub hexp
      simpa using hnum.div hden (by norm_num)
    refine hlim.congr' ?_
    filter_upwards [Filter.eventually_gt_atTop 0] with β hβ
    have hd : (1 : ℝ) - Real.exp (-2 * β) ≠ 0 := by
      have hlt : Real.exp (-2 * β) < 1 := by
        rw [show (-2 * β) = -(2 * β) by ring, Real.exp_neg, inv_lt_one_iff₀]
        exact Or.inr (Real.one_lt_exp_iff.mpr (by linarith))
      linarith
    have hs2 : Real.exp β - Real.exp (-β) ≠ 0 := by
      have : Real.exp (-β) < Real.exp β := Real.exp_lt_exp.mpr (by linarith)
      linarith
    have key : Real.exp (-(2 * β)) * Real.exp β = Real.exp (-β) := by
      rw [← Real.exp_add]; ring_nf
    rw [Real.cosh_eq, Real.sinh_eq]
    rw [div_eq_div_iff hd (by
      have h2 : (Real.exp β - Real.exp (-β)) / 2 ≠ 0 := by
        rw [div_ne_zero_iff]; exact ⟨hs2, by norm_num⟩
      exact h2)]
    field_simp
    linear_combination 2 * key
  have := (Real.continuousAt_log (by norm_num : (1:ℝ) ≠ 0)).tendsto.comp hratio
  simp only [Real.log_one] at this
  exact this.congr (fun β => (z2GlueballMass_eq_log_cosh_div_sinh β).symm)

/-! ## The four independent-realizability theorems -/

/-- **Regulator ON, others OFF.** At Wilson parameter `r > 0` the regulator mass
is strictly positive, while the bare mass is `0`, the closure mass is evaluated at
its OFF witness (boundary `β = 0`), and the aperture mass is `0` at collinear
momenta. The parameters `r`, `β`, and the momenta are INDEPENDENT, so turning the
regulator ON constrains nothing else. -/
theorem regulator_on_others_off {r : ℝ} (hr : 0 < r) :
    0 < wilsonRegulatorMass r ∧
    quarkMassParameter = 0 ∧
    z2GlueballMass 0 = 0 ∧
    compositeApertureMassSq nullX nullX = 0 :=
  ⟨wilsonRegulatorMass_pos hr, rfl, z2GlueballMass_boundary_zero,
    compositeApertureMassSq_collinear_zero⟩

/-- **Closure ON, others OFF.** At inverse temperature `β > 0` the closure mass is
strictly positive, while the bare mass is `0`, the regulator mass is `0` at
`r = 0`, and the aperture mass is `0` at collinear momenta. -/
theorem closure_on_others_off {β : ℝ} (hβ : 0 < β) :
    0 < z2GlueballMass β ∧
    quarkMassParameter = 0 ∧
    wilsonRegulatorMass 0 = 0 ∧
    compositeApertureMassSq nullX nullX = 0 :=
  ⟨z2GlueballMass_pos hβ, rfl, wilsonRegulatorMass_zero,
    compositeApertureMassSq_collinear_zero⟩

/-- **Aperture ON, others OFF.** At a non-collinear future-null pair the aperture
mass is strictly positive, while the bare mass is `0`, the regulator mass is `0`
at `r = 0`, and the closure mass is evaluated at its OFF witness (boundary
`β = 0`). -/
theorem aperture_on_others_off :
    0 < compositeApertureMassSq nullX nullY ∧
    quarkMassParameter = 0 ∧
    wilsonRegulatorMass 0 = 0 ∧
    z2GlueballMass 0 = 0 :=
  ⟨compositeApertureMassSq_noncollinear_pos, rfl, wilsonRegulatorMass_zero,
    z2GlueballMass_boundary_zero⟩

/-- **Turn/bare is identically OFF.** The bare/turn functional `quarkMassParameter`
is a detached input constant pinned to `0`; it admits NO configuration making it
strictly positive. This is the exceptional leg: it has a clean OFF witness but no
ON witness. -/
theorem turn_identically_off : quarkMassParameter = 0 := rfl

/-- **Turn OFF, the other three independently ON.** The honest non-degeneracy
content of the turn/bare axis: because `quarkMassParameter` is pinned to `0`, it
cannot be turned ON; instead we record that its being OFF places no constraint on
the others, which can be simultaneously ON at `r > 0`, `β > 0`, and a
non-collinear future-null pair. This shows the taxonomy does not collapse onto the
bare mass. -/
theorem turn_off_others_on {r β : ℝ} (hr : 0 < r) (hβ : 0 < β) :
    quarkMassParameter = 0 ∧
    0 < wilsonRegulatorMass r ∧
    0 < z2GlueballMass β ∧
    0 < compositeApertureMassSq nullX nullY :=
  ⟨rfl, wilsonRegulatorMass_pos hr, z2GlueballMass_pos hβ,
    compositeApertureMassSq_noncollinear_pos⟩

/-! ## The bundled non-degeneracy headline -/

/-- **HEADLINE (mass-taxonomy non-degeneracy; independent realizability).** The
four taxonomy legs are independently realizable on their separate parameter
domains: (regulator) at `r > 0` the regulator mass is ON while bare, closure
(boundary), and aperture are OFF; (closure) at `β > 0` the closure mass is ON
while the other three are OFF; (aperture) at a non-collinear null pair the
aperture mass is ON while the other three are OFF; and (turn/bare) the bare mass
is identically OFF while the other three are independently ON — the honest dual
for the one leg (a pinned input) that has no ON witness.

This is the non-degeneracy companion to
`MassTaxonomySeparation.massTaxonomy_functionals_pairwise_separated`: no
functional is a shadow of another. It is a statement about the FUNCTIONALS on
independent domains, NOT a claim that one physical model exhibits all four masses
at once. -/
theorem massTaxonomy_nondegenerate {r β : ℝ} (hr : 0 < r) (hβ : 0 < β) :
    -- regulator ON, others OFF
    (0 < wilsonRegulatorMass r ∧
      quarkMassParameter = 0 ∧
      z2GlueballMass 0 = 0 ∧
      compositeApertureMassSq nullX nullX = 0) ∧
    -- closure ON, others OFF
    (0 < z2GlueballMass β ∧
      quarkMassParameter = 0 ∧
      wilsonRegulatorMass 0 = 0 ∧
      compositeApertureMassSq nullX nullX = 0) ∧
    -- aperture ON, others OFF
    (0 < compositeApertureMassSq nullX nullY ∧
      quarkMassParameter = 0 ∧
      wilsonRegulatorMass 0 = 0 ∧
      z2GlueballMass 0 = 0) ∧
    -- turn/bare identically OFF, the other three independently ON
    (quarkMassParameter = 0 ∧
      0 < wilsonRegulatorMass r ∧
      0 < z2GlueballMass β ∧
      0 < compositeApertureMassSq nullX nullY) :=
  ⟨regulator_on_others_off hr,
   closure_on_others_off hβ,
   aperture_on_others_off,
   turn_off_others_on hr hβ⟩

/-! ## Build-enforced axiom-footprint guard

Mirrors the guard pattern of `AllMassFromNullEdges`: this block FAILS TO BUILD if
the non-degeneracy headline's transitive axiom surface changes — e.g. if a
`sorry` leaks in through any leg, a `native_decide`
(`Lean.ofReduceBool` / `Lean.trustCompiler`) is introduced underneath, or a new
`axiom` appears. -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomyNonDegeneracy.massTaxonomy_nondegenerate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massTaxonomy_nondegenerate

end MassTaxonomyNonDegeneracy
end PhysicsSM.Draft.NullEdge.GateI1
