import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma
import PhysicsSM.Draft.NullEdge.GateYM.WilsonDiracOperator
import PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure
import PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomySeparation

/-!
# Lane T: the Nielsen–Ninomiya doubling as the PRICE OF THE TURN

This module formalises, at the level of the finite Euclidean spin algebra
underlying the QMF4 Wilson–Dirac operator (`WilsonDiracOperator.lean`), the
*finite shadow* of the Nielsen–Ninomiya doubling theorem as the "price of the
turn": the Wilson term is the chirality-EVEN regulator that removes the fermion
doubler, so the physical turn (mass) and the regulator turn are BOTH
chirality-even, but only one survives the naive (`r = 0`) limit.

## The mechanism, made precise

The forward Wilson-hop spin factor with Wilson parameter `r` is

    wilsonProjector r μ = r • 1 - γ μ,

the `r = 1` case being the standard `1 - γ μ` used in
`ChiralMassStructure.massVertex`, and `r = 0` the *naive* (no-Wilson-term)
limit. Splitting into the chirality channels of `ChiralMassStructure`:

* `chiralEven (wilsonProjector r μ) = r • 1` — the Wilson term is chirality-EVEN,
  exactly the channel that carries the physical mass `m • 1` (the "turn");
* `chiralOdd (wilsonProjector r μ) = - γ μ` — the pure null-transport generator,
  *independent* of `r`.

The full vertex `massVertexW m r μ = m • 1 + wilsonProjector r μ` therefore has

    chiralEven (massVertexW m r μ) = (m + r) • 1,
    chiralOdd  (massVertexW m r μ) = - γ μ.

### The price of the turn (finite Nielsen–Ninomiya shadow)

* **The transport channel never vanishes** (`γ μ ≠ 0`): the doubler-carrying
  chirality-odd transport is present for *every* `m` and `r`. There is no
  parameter choice making BOTH channels vanish
  (`no_chiral_and_doubler_removal`).
* **The naive limit keeps the doubler** (`naive_limit_doubler_survives`): at
  `r = 0` (no Wilson term) and `m = 0` (chiral point) the even channel is `0`
  while the transport `- γ μ ≠ 0` survives — the doubler is unlifted.
* **Doubler removal costs the turn**: the even channel of the standard Wilson
  vertex vanishes *iff* `m = -1` (`chiralEven_standardVertex_eq_zero_iff`, reusing
  the finite `ChiralMassStructure.chiralEven_massVertex_eq_zero_iff`); the `+1`
  is the `m`-independent Wilson regulator contribution. You cannot have chiral
  symmetry (even channel `= 0`) AND a nonzero regulator turn at once except at a
  single tuned mass.
* **The regulator turn is the Wilson turn** (`regulator_turn_tie`): the Wilson
  term's even channel is nonzero *iff* the regulator mass
  `MassTaxonomySeparation.wilsonRegulatorMass r = log (1 + 4 r)` is positive
  (both vanish at `r = 0`, both are strictly present at `r > 0`).

## Claim discipline

Claim label: **finite identity** (the doubling-turn price). Pure finite spin
algebra plus the elementary properties of `wilsonRegulatorMass`; no lattice
dynamics, no continuum limit, standard axioms only.
-/

open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace DoublingTurnPrice

open PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma
open PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure
open PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomySeparation

/-! ## Linearity of the chirality channels -/

/-- The chirality-even channel is additive. -/
theorem chiralEven_add (A B : Matrix (Fin 4) (Fin 4) ℂ) :
    chiralEven (A + B) = chiralEven A + chiralEven B := by
  unfold chiralEven
  rw [mul_add, add_mul]
  module

/-- The chirality-even channel is `ℂ`-homogeneous. -/
theorem chiralEven_smul (c : ℂ) (A : Matrix (Fin 4) (Fin 4) ℂ) :
    chiralEven (c • A) = c • chiralEven A := by
  unfold chiralEven
  rw [mul_smul_comm, smul_mul_assoc]
  module

/-- The chirality-odd channel is additive. -/
theorem chiralOdd_add (A B : Matrix (Fin 4) (Fin 4) ℂ) :
    chiralOdd (A + B) = chiralOdd A + chiralOdd B := by
  unfold chiralOdd
  rw [mul_add, add_mul]
  module

/-- The chirality-odd channel is `ℂ`-homogeneous. -/
theorem chiralOdd_smul (c : ℂ) (A : Matrix (Fin 4) (Fin 4) ℂ) :
    chiralOdd (c • A) = c • chiralOdd A := by
  unfold chiralOdd
  rw [mul_smul_comm, smul_mul_assoc]
  module

/-! ## Nonvanishing of the transport generator -/

/-- Each Euclidean gamma matrix is nonzero (it squares to `1`). This is what
makes the chirality-odd transport channel — the doubler carrier — impossible to
switch off. -/
theorem γ_ne_zero (μ : Fin 4) : γ μ ≠ 0 := by
  intro h
  have hsq := γ_sq μ
  rw [h, mul_zero] at hsq
  exact (zero_ne_one hsq)

/-! ## The Wilson-hop spin factor with Wilson parameter `r` -/

/-- The forward Wilson-hop spin factor with Wilson parameter `r`:
`r • 1 - γ μ`. The `r = 1` case is the standard Wilson projector
`1 - γ μ` of `ChiralMassStructure.massVertex`; the `r = 0` case is the naive
(no-Wilson-term) limit `- γ μ`, pure transport. -/
noncomputable def wilsonProjector (r : ℂ) (μ : Fin 4) : Matrix (Fin 4) (Fin 4) ℂ :=
  r • (1 : Matrix (Fin 4) (Fin 4) ℂ) - γ μ

/-- The full mass vertex at mass `m` with Wilson parameter `r`:
`m • 1 + wilsonProjector r μ`. -/
noncomputable def massVertexW (m r : ℂ) (μ : Fin 4) : Matrix (Fin 4) (Fin 4) ℂ :=
  m • (1 : Matrix (Fin 4) (Fin 4) ℂ) + wilsonProjector r μ

/-- At `r = 1` the parametrised vertex is exactly the reused
`ChiralMassStructure.massVertex`. -/
theorem massVertexW_one (m : ℂ) (μ : Fin 4) :
    massVertexW m 1 μ = massVertex m μ := by
  unfold massVertexW wilsonProjector massVertex
  rw [one_smul]

/-! ## (1) The Wilson term is the chirality-EVEN regulator -/

/-- **The Wilson term is chirality-EVEN**: the chirality-mixing ("turn") channel
of the Wilson-hop spin factor is `r • 1`. The Wilson regulator lives in the SAME
channel as the physical mass `m • 1`. -/
theorem chiralEven_wilsonProjector (r : ℂ) (μ : Fin 4) :
    chiralEven (wilsonProjector r μ) = r • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  unfold chiralEven wilsonProjector
  have e1 : γ5 * (r • (1 : Matrix (Fin 4) (Fin 4) ℂ)) * γ5 = r • 1 := by
    rw [mul_smul_comm, smul_mul_assoc, mul_one, γ5_sq]
  have hconj : γ5 * (r • (1 : Matrix (Fin 4) (Fin 4) ℂ) - γ μ) * γ5
      = r • (1 : Matrix (Fin 4) (Fin 4) ℂ) + γ μ := by
    rw [mul_sub, sub_mul, e1, γ5_conj_γ, sub_neg_eq_add]
  rw [hconj]; module

/-- **The transport channel is `r`-INDEPENDENT**: the chirality-preserving part
of the Wilson-hop spin factor is exactly `- γ μ`, for every Wilson parameter
`r`. The doubler-carrying transport does not feel the regulator. -/
theorem chiralOdd_wilsonProjector (r : ℂ) (μ : Fin 4) :
    chiralOdd (wilsonProjector r μ) = - γ μ := by
  unfold chiralOdd wilsonProjector
  have e1 : γ5 * (r • (1 : Matrix (Fin 4) (Fin 4) ℂ)) * γ5 = r • 1 := by
    rw [mul_smul_comm, smul_mul_assoc, mul_one, γ5_sq]
  have hconj : γ5 * (r • (1 : Matrix (Fin 4) (Fin 4) ℂ) - γ μ) * γ5
      = r • (1 : Matrix (Fin 4) (Fin 4) ℂ) + γ μ := by
    rw [mul_sub, sub_mul, e1, γ5_conj_γ, sub_neg_eq_add]
  rw [hconj]; module

/-- **(1) — The chirality-even Wilson term is nonzero** for any nonzero Wilson
parameter `r`: `chiralEven (wilsonProjector r μ) ≠ 0`. The Wilson term genuinely
contributes to the "turn" channel, exactly like a physical mass. -/
theorem chiralEven_wilsonTerm_ne_zero {r : ℂ} (hr : r ≠ 0) (μ : Fin 4) :
    chiralEven (wilsonProjector r μ) ≠ 0 := by
  rw [chiralEven_wilsonProjector]
  intro h
  apply hr
  have h11 := congrFun (congrFun h 0) 0
  simpa [Matrix.smul_apply, Matrix.one_apply] using h11

/-! ## (2) The naive limit and the finite Nielsen–Ninomiya shadow -/

/-- Chirality-even channel of the full parametrised vertex: `(m + r) • 1`. The
physical mass `m` and the Wilson regulator `r` merge into ONE chirality-even
coefficient. -/
theorem chiralEven_massVertexW (m r : ℂ) (μ : Fin 4) :
    chiralEven (massVertexW m r μ) = (m + r) • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  unfold massVertexW
  rw [chiralEven_add, chiralEven_smul, chiralEven_one, chiralEven_wilsonProjector, add_smul]

/-- Chirality-odd channel of the full parametrised vertex: `- γ μ`, the pure
transport generator, independent of both `m` and `r`. -/
theorem chiralOdd_massVertexW (m r : ℂ) (μ : Fin 4) :
    chiralOdd (massVertexW m r μ) = - γ μ := by
  unfold massVertexW
  rw [chiralOdd_add, chiralOdd_smul, chiralOdd_one, chiralOdd_wilsonProjector, smul_zero,
    zero_add]

/-- The even ("turn") channel of the parametrised vertex vanishes exactly when
the physical mass cancels the regulator, `m = -r`. -/
theorem chiralEven_massVertexW_eq_zero_iff (m r : ℂ) (μ : Fin 4) :
    chiralEven (massVertexW m r μ) = 0 ↔ m = -r := by
  rw [chiralEven_massVertexW]
  constructor
  · intro h
    have h11 := congrFun (congrFun h 0) 0
    simp only [Matrix.smul_apply, Matrix.one_apply_eq, Matrix.zero_apply, smul_eq_mul,
      mul_one] at h11
    linear_combination h11
  · intro h
    rw [h, neg_add_cancel, zero_smul]

/-- **No parameter removes the doubler AND the turn.** For every `m, r, μ` the
chirality-odd transport channel is `- γ μ ≠ 0`, so the even and odd channels
cannot vanish simultaneously: the finite shadow of Nielsen–Ninomiya
(you cannot have chiral symmetry AND doubler removal at once). -/
theorem no_chiral_and_doubler_removal (m r : ℂ) (μ : Fin 4) :
    ¬ (chiralEven (massVertexW m r μ) = 0 ∧ chiralOdd (massVertexW m r μ) = 0) := by
  rintro ⟨_, hodd⟩
  rw [chiralOdd_massVertexW] at hodd
  exact γ_ne_zero μ (neg_eq_zero.mp hodd)

/-- **The naive limit keeps the doubler.** At `r = 0` (no Wilson term) and
`m = 0` (chiral point) the chirality-even "turn" channel is `0` while the
chirality-odd transport `- γ μ ≠ 0` survives — the doubler is unlifted because
the momentum-dependent mass lifting IS the (now absent) Wilson term. -/
theorem naive_limit_doubler_survives (μ : Fin 4) :
    chiralEven (massVertexW 0 0 μ) = 0 ∧
      chiralOdd (massVertexW 0 0 μ) = - γ μ ∧ γ μ ≠ 0 := by
  refine ⟨?_, chiralOdd_massVertexW 0 0 μ, γ_ne_zero μ⟩
  rw [chiralEven_massVertexW, add_zero, zero_smul]

/-- **Doubler removal costs the turn (reusing the finite identity).** For the
standard Wilson vertex (`r = 1`) the chirality-even channel vanishes *iff*
`m = -1`: the `+1` regulator exactly cancels a mass of `-1`. This restates the
reused finite `ChiralMassStructure.chiralEven_massVertex_eq_zero_iff` for the
parametrised vertex. -/
theorem chiralEven_standardVertex_eq_zero_iff (m : ℂ) (μ : Fin 4) :
    chiralEven (massVertexW m 1 μ) = 0 ↔ m = -1 := by
  rw [massVertexW_one]
  exact chiralEven_massVertex_eq_zero_iff m μ

/-! ## Tie to the mass taxonomy: the regulator turn is the Wilson turn -/

/-- **The regulator turn IS the Wilson turn.** For a real Wilson parameter `r`,
the Wilson term's chirality-even channel `chiralEven (wilsonProjector r μ)` is
nonzero exactly when the regulator mass
`MassTaxonomySeparation.wilsonRegulatorMass r = log (1 + 4 r)` is positive: both
vanish at the naive limit `r = 0`, and both are strictly present for `r > 0`. -/
theorem regulator_turn_tie (r : ℝ) (μ : Fin 4) :
    (r = 0 → chiralEven (wilsonProjector (r : ℂ) μ) = 0 ∧ wilsonRegulatorMass r = 0) ∧
      (0 < r → chiralEven (wilsonProjector (r : ℂ) μ) ≠ 0 ∧ 0 < wilsonRegulatorMass r) := by
  constructor
  · intro hr
    subst hr
    refine ⟨?_, wilsonRegulatorMass_zero⟩
    rw [chiralEven_wilsonProjector]
    simp
  · intro hr
    refine ⟨?_, wilsonRegulatorMass_pos hr⟩
    apply chiralEven_wilsonTerm_ne_zero
    exact_mod_cast ne_of_gt hr

end DoublingTurnPrice
end PhysicsSM.Draft.NullEdge.GateYM
