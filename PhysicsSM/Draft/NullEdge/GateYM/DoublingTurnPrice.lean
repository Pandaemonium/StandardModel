import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma
import PhysicsSM.Draft.NullEdge.GateYM.WilsonDiracOperator
import PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure
import PhysicsSM.Draft.NullEdge.GateI1.MassTaxonomySeparation

/-!
# Lane T: finite spin-algebra channel decomposition of the Wilson vertex

**SCOPE / AUDIT DOWNGRADE (semantic audit 2026-07-06, job `521d1c86`).** An
earlier version of this docstring framed the module as "the finite
Nielsen–Ninomiya no-go / the price of the turn establishing forced doubling".
That framing was an OVER-CLAIM and has been withdrawn. What is actually proved
here is entirely LOCAL, per-vertex, finite spin algebra: the chirality-channel
(`γ5`-conjugation) decomposition of the single `4×4` Wilson-vertex spin matrix
`massVertexW m r μ`. There is **no momentum variable, no Brillouin torus, no
dispersion relation, no pole/zero counting, and nothing global or topological**.
In particular this module does NOT prove the topological Nielsen–Ninomiya theorem
(the signed chirality sum of a chirally-symmetric lattice Dirac symbol's zeros
vanishing over the Brillouin torus) and does NOT establish the NECESSITY
direction ("chiral symmetry ⟹ forced doubling / forced Wilson term"). Those need
a discrete-torus chirality-sum / degree argument that is absent here; see the
open item in `JOB_BACKLOG.md`. Cite this module ONLY as the finite Wilson-vertex
channel decomposition, not as the no-go proper.

This module formalises, at the level of the finite Euclidean spin algebra
underlying the QMF4 Wilson–Dirac operator (`WilsonDiracOperator.lean`), the
chirality-channel decomposition of the Wilson vertex: the Wilson term is
chirality-EVEN (the same channel that carries the physical mass `m • 1`), while
the null-transport `- γ μ` is chirality-ODD and `r`-independent. This is a
suggestive local *illustration* of why the naive (`r = 0`) limit leaves the
transport generator intact, NOT a proof of doubling.

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

### The local channel facts (honestly labeled)

These are correct finite spin-matrix identities; their NAMES retain the physics
motivation but the reader must read them as the LOCAL algebraic facts they are
(the audit downgrade above), NOT as a doubling no-go.

* `no_chiral_and_doubler_removal`: the two channels never vanish simultaneously.
  Its actual content is just that the odd channel `chiralOdd (massVertexW m r μ)
  = - γ μ ≠ 0` (the proof discards the even conjunct); it is the local fact
  `γ μ ≠ 0`, NOT a global ±-pole-pairing / chirality-sum statement.
* `naive_limit_doubler_survives`: at `r = 0`, `m = 0` the even channel is `0`
  while `- γ μ ≠ 0` survives. Real content: `γ μ ≠ 0` at the chiral point — a
  suggestive local illustration, not a proof the doubler is unremovable.
* `chiralEven_standardVertex_eq_zero_iff`: the even channel of the standard
  Wilson vertex vanishes *iff* `m = -1` (reusing
  `ChiralMassStructure.chiralEven_massVertex_eq_zero_iff`); the `+1` is the
  `m`-independent Wilson regulator contribution. A clean finite `iff`.
* `regulator_turn_tie`: the Wilson even channel is nonzero *iff*
  `MassTaxonomySeparation.wilsonRegulatorMass r = log (1 + 4 r) > 0`. This is a
  shared sign/threshold COINCIDENCE (both vanish at `r = 0`, both positive for
  `r > 0`), NOT a functional identity between the two separately-defined objects.

## Claim discipline

Claim label: **finite identity** (Wilson-vertex channel decomposition ONLY).
Pure finite spin algebra plus the elementary properties of `wilsonRegulatorMass`;
no lattice dynamics, no momentum/torus, no topology, no continuum limit, no
Nielsen–Ninomiya no-go, no necessity claim; standard axioms only. The genuine
finite N-N no-go (a discrete-Brillouin-torus signed chirality-sum theorem) is an
OPEN item, not proved here.
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

/-! ## (2) The naive limit and the vertex-channel non-simultaneous-vanishing
(local facts — NOT the topological Nielsen–Ninomiya no-go; see the scope note) -/

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

/-- **The two vertex channels never vanish simultaneously.** For every `m, r, μ`
the chirality-odd transport channel is `- γ μ ≠ 0`. NOTE (audit `521d1c86`): the
proof discards the even conjunct, so the ACTUAL content is just `γ μ ≠ 0`, a
LOCAL per-vertex spin fact. This is NOT the topological Nielsen–Ninomiya no-go
(no chirality sum, no pole pairing) and does NOT establish doubling necessity;
read it only as the stated non-simultaneous-vanishing of the two channels. -/
theorem no_chiral_and_doubler_removal (m r : ℂ) (μ : Fin 4) :
    ¬ (chiralEven (massVertexW m r μ) = 0 ∧ chiralOdd (massVertexW m r μ) = 0) := by
  rintro ⟨_, hodd⟩
  rw [chiralOdd_massVertexW] at hodd
  exact γ_ne_zero μ (neg_eq_zero.mp hodd)

/-- **The naive-limit even channel vanishes while transport survives.** At
`r = 0` (no Wilson term) and `m = 0` (chiral point) the chirality-even "turn"
channel is `0` while the chirality-odd transport `- γ μ ≠ 0` survives. Real
content: `γ μ ≠ 0` at the chiral point — a suggestive LOCAL illustration of why
one expects an unlifted doubler, NOT a proof that the doubler is unremovable
(that needs the absent global chirality-sum argument; audit `521d1c86`). -/
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

/-! ## Tie to the mass taxonomy: a shared r=0 threshold (NOT a functional identity) -/

/-- **Shared sign/threshold with the regulator mass.** For a real Wilson
parameter `r`, the Wilson even channel `chiralEven (wilsonProjector r μ)` and the
regulator mass `MassTaxonomySeparation.wilsonRegulatorMass r = log (1 + 4 r)`
have the SAME threshold behaviour: both vanish at `r = 0` and both are strictly
present for `r > 0`. NOTE (audit `521d1c86`): this is a shared-sign COINCIDENCE
of two separately-defined objects, NOT a functional identity between them; do
not read it as "the regulator turn IS the Wilson turn". -/
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
