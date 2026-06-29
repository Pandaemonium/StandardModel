/-
# C194 kappa-to-gapped-homotopy

Local Draft promotion copied from Aristotle output on 2026-06-28.
Source artifact: AgentTasks/aristotle-output/81b3e990-1a16-4494-8b7c-de9d974732be/extracted/7c7d5b92-870e-4b5f-8240-eeb37d9813e1_aristotle/RequestProject/NullEdgeGateC1.lean

Status: Draft artifact, locally checked and targeted-built on 2026-06-28.
Claim boundary: this is not a proof of full GateC1_NU.
-/

import Mathlib

/-!
# Gate C1 — Null-edge endpoint vs. Wilson/Neuberger reference (draft module)

This module formalizes the *engine* behind the Gate C1 direction:

> Use Wilson/Neuberger overlap as the first physical reference.
> Insert CKM only as an internal branch/flavor mass texture.
> Prove the actual null-edge endpoint is gapped-homotopic to that reference.

The mathematical core is deliberately discretization-agnostic and lives in the
free/flat free-field momentum picture, where every operator is a parameter
(momentum) indexed family of bounded operators on a fixed finite-dimensional
complex inner-product space `E` (the Dirac ⊗ CKM internal space).

The two physical inputs are encoded *as the things one must prove*:

* `Gapped g H_ref` : the reference Hamiltonian family has a uniform invertibility
  gap `g > 0` (this is exactly the statement "the Wilson/Neuberger reference lifts
  all spacetime doublers and is massive"); and
* `KappaCertificate S Sinv H_ne H_ref κ` : after transport by a sector/frame map
  `S` (with inverse `Sinv`), the null-edge endpoint differs from the reference by
  at most `κ` in operator norm, uniformly in momentum.

The headline result `nullEdge_gappedHomotopic_to_ref` says: if `κ < g` then the
transported null-edge endpoint is **gapped-homotopic** to the reference, i.e.
there is a per-momentum continuous straight-line path of operator families that
stays uniformly invertible (gap `g - κ`) throughout. CKM never appears here:
doublers are killed by the *kinetic + Wilson* data inside the gap `g`, exactly as
required by the success criterion "do not ask CKM to solve spacetime doublers".

The free/flat spatial Wilson profile `W_NE_space` proposed for the null-edge
endpoint is given explicitly at the end, together with the basic positivity and
doubler-lifting facts it must satisfy.
-/

open scoped BigOperators
open scoped Classical

namespace NullEdgeGateC1

/-! ## 1. Abstract gap / homotopy engine -/

section Engine

variable {P : Type*}
variable {E : Type*}
  [NormedAddCommGroup E] [InnerProductSpace ℂ E] [FiniteDimensional ℂ E]

/-- A momentum-indexed family of bounded operators on the internal space `E`. -/
abbrev OpFamily (P E : Type*)
    [NormedAddCommGroup E] [InnerProductSpace ℂ E] [FiniteDimensional ℂ E] :=
  P → (E →L[ℂ] E)

/-- `Gapped g H` : the family `H` is uniformly bounded below by `g`.  For `g > 0`
this is a quantitative invertibility (spectral-gap) statement: every operator in
the family is injective with `‖H p x‖ ≥ g ‖x‖`.  Physically this is the assertion
that the Wilson/Neuberger reference has *no zero modes* — neither the physical one
(absorbed by the mass `m0`) nor any doubler. -/
def Gapped (g : ℝ) (H : OpFamily P E) : Prop :=
  0 < g ∧ ∀ p x, g * ‖x‖ ≤ ‖H p x‖

/-- Transport of a family by a frame/sector map `S` with inverse `Sinv`:
`(transport S Sinv H) p = S p ∘ H p ∘ Sinv p`. -/
def transport (S Sinv H : OpFamily P E) : OpFamily P E :=
  fun p => (S p).comp ((H p).comp (Sinv p))

/-- The κ-mismatch certificate: after transport by `S`/`Sinv`, the null-edge
endpoint `H_ne` differs from the reference `H_ref` by at most `κ` in operator
norm, uniformly in momentum. -/
def KappaCertificate (S Sinv H_ne H_ref : OpFamily P E) (κ : ℝ) : Prop :=
  ∀ p, ‖transport S Sinv H_ne p - H_ref p‖ ≤ κ

/-- Per-momentum straight-line homotopy between two families. -/
def lineHomotopy (A B : OpFamily P E) (t : ℝ) : OpFamily P E :=
  fun p => ((1 - t : ℝ) : ℂ) • A p + ((t : ℝ) : ℂ) • B p

/-- `GappedHomotopic A B` : there is a per-momentum continuous path of families
from `A` to `B` that remains uniformly gapped (hence invertible) throughout
`[0,1]`.  This is the precise meaning of "the null-edge endpoint is
gapped-homotopic to the reference". -/
def GappedHomotopic (A B : OpFamily P E) : Prop :=
  ∃ (H : ℝ → OpFamily P E) (g : ℝ),
    H 0 = A ∧ H 1 = B ∧
    (∀ p, Continuous fun t => H t p) ∧
    (∀ t ∈ Set.Icc (0 : ℝ) 1, Gapped g (H t))

/-- A gapped family is gapped-homotopic to itself by the constant path. -/
theorem GappedHomotopic.refl {A : OpFamily P E} {g : ℝ} (hA : Gapped g A) :
    GappedHomotopic A A := by
  refine ⟨fun _ => A, g, rfl, rfl, ?_, ?_⟩
  · intro p
    exact continuous_const
  · intro _ _
    exact hA

/-- Gapped homotopy is symmetric, by reversing the homotopy parameter. -/
theorem GappedHomotopic.symm {A B : OpFamily P E}
    (h : GappedHomotopic A B) : GappedHomotopic B A := by
  obtain ⟨H, g, h0, h1, hcont, hgap⟩ := h
  refine ⟨fun t => H (1 - t), g, ?_, ?_, ?_, ?_⟩
  · simpa using h1
  · simpa using h0
  · intro p
    exact (hcont p).comp (by fun_prop)
  · intro t ht
    have hrev : 1 - t ∈ Set.Icc (0 : ℝ) 1 := by
      constructor
      · linarith [ht.1, ht.2]
      · linarith [ht.1, ht.2]
    exact hgap (1 - t) hrev

/-- A gapped operator family is pointwise injective. -/
theorem Gapped.injective {g : ℝ} {A : OpFamily P E} (hA : Gapped g A) (p : P) :
    Function.Injective (A p) := by
  intro x y hxy
  have hz : (A p) (x - y) = 0 := by rw [map_sub, hxy, sub_self]
  have h2 := hA.2 p (x - y)
  rw [hz, norm_zero] at h2
  have hxn : ‖x - y‖ ≤ 0 := by
    by_contra h
    push_neg at h
    have : 0 < g * ‖x - y‖ := mul_pos hA.1 h
    linarith
  have : x - y = 0 := by
    have := norm_nonneg (x - y)
    have : ‖x - y‖ = 0 := le_antisymm hxn this
    exact norm_eq_zero.mp this
  exact sub_eq_zero.mp this

/-- The key perturbation bound: a convex combination of a gapped family `A` and a
family `B` with `‖B p - A p‖ ≤ κ` stays bounded below by `g - κ` on `[0,1]`. -/
theorem lineHomotopy_lower_bound
    {A B : OpFamily P E} {g κ : ℝ}
    (hA : Gapped g A) (hκ0 : 0 ≤ κ) (hbound : ∀ p, ‖B p - A p‖ ≤ κ)
    {t : ℝ} (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    ∀ p x, (g - κ) * ‖x‖ ≤ ‖lineHomotopy A B t p x‖ := by
  intro p x
  have key : lineHomotopy A B t p x = A p x + ((t : ℝ) : ℂ) • ((B p - A p) x) := by
    simp only [lineHomotopy, ContinuousLinearMap.add_apply,
      ContinuousLinearMap.smul_apply, ContinuousLinearMap.sub_apply, smul_sub]
    push_cast
    module
  have hAx : g * ‖x‖ ≤ ‖A p x‖ := hA.2 p x
  have hdiff : ‖(B p - A p) x‖ ≤ κ * ‖x‖ := by
    calc ‖(B p - A p) x‖ ≤ ‖B p - A p‖ * ‖x‖ := (B p - A p).le_opNorm x
      _ ≤ κ * ‖x‖ := by
          apply mul_le_mul_of_nonneg_right (hbound p) (norm_nonneg x)
  have hsm : ‖((t : ℝ) : ℂ) • ((B p - A p) x)‖ ≤ κ * ‖x‖ := by
    rw [norm_smul]
    simp only [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg ht0]
    calc t * ‖(B p - A p) x‖ ≤ t * (κ * ‖x‖) :=
          mul_le_mul_of_nonneg_left hdiff ht0
      _ ≤ 1 * (κ * ‖x‖) := by
          apply mul_le_mul_of_nonneg_right ht1
          exact mul_nonneg hκ0 (norm_nonneg x)
      _ = κ * ‖x‖ := one_mul _
  -- reverse triangle inequality: ‖a + b‖ ≥ ‖a‖ - ‖b‖
  have htri : ‖A p x‖ - ‖((t : ℝ) : ℂ) • ((B p - A p) x)‖
      ≤ ‖A p x + ((t : ℝ) : ℂ) • ((B p - A p) x)‖ := by
    have := norm_sub_norm_le (A p x) (-(((t : ℝ) : ℂ) • ((B p - A p) x)))
    rwa [norm_neg, sub_neg_eq_add] at this
  rw [key]
  calc (g - κ) * ‖x‖ = g * ‖x‖ - κ * ‖x‖ := by ring
    _ ≤ ‖A p x‖ - ‖((t : ℝ) : ℂ) • ((B p - A p) x)‖ := by linarith
    _ ≤ _ := htri

/-- Endpoints of the straight-line homotopy. -/
theorem lineHomotopy_zero (A B : OpFamily P E) : lineHomotopy A B 0 = A := by
  funext p; simp [lineHomotopy]

theorem lineHomotopy_one (A B : OpFamily P E) : lineHomotopy A B 1 = B := by
  funext p; simp [lineHomotopy]

/-- Per-momentum continuity in the homotopy parameter. -/
theorem lineHomotopy_continuous (A B : OpFamily P E) (p : P) :
    Continuous fun t => lineHomotopy A B t p := by
  unfold lineHomotopy
  fun_prop

/-- **Core homotopy criterion.**  If `A` is gapped with gap `g`, `0 ≤ κ < g`, and
`‖B p - A p‖ ≤ κ` for all `p`, then `A` and `B` are gapped-homotopic (with gap
`g - κ` along the straight line). -/
theorem gappedHomotopic_of_kappa
    {A B : OpFamily P E} {g κ : ℝ}
    (hA : Gapped g A) (hκ0 : 0 ≤ κ) (hκ : κ < g)
    (hbound : ∀ p, ‖B p - A p‖ ≤ κ) :
    GappedHomotopic A B := by
  refine ⟨lineHomotopy A B, g - κ, lineHomotopy_zero A B, lineHomotopy_one A B,
    lineHomotopy_continuous A B, ?_⟩
  intro t ht
  refine ⟨by linarith, ?_⟩
  exact lineHomotopy_lower_bound hA hκ0 hbound ht.1 ht.2

/-- **Gate C1 master theorem (free/flat, ω = 0, ρ = 0).**  If the Wilson/Neuberger
reference family `H_ref` is gapped with gap `g` (no doublers, massive), and the
null-edge endpoint `H_ne`, transported by the sector/frame map `S`/`Sinv`, meets
the κ-mismatch certificate with `κ < g`, then the transported null-edge endpoint
is gapped-homotopic to the reference.  CKM data never enters the doubler-lifting:
it is fully carried by the gap `g`. -/
theorem nullEdge_gappedHomotopic_to_ref
    {H_ref H_ne S Sinv : OpFamily P E} {g κ : ℝ}
    (hRef : Gapped g H_ref) (hκ0 : 0 ≤ κ) (hκ : κ < g)
    (hCert : KappaCertificate S Sinv H_ne H_ref κ) :
    GappedHomotopic H_ref (transport S Sinv H_ne) := by
  apply gappedHomotopic_of_kappa hRef hκ0 hκ
  intro p
  exact hCert p

end Engine

/-! ## 2. Explicit free/flat spatial Wilson profile `W_NE_space`

In the free/flat free-field picture momenta are `p : Fin (d+1) → ℝ` on the torus,
with direction `0` the temporal/null direction and directions `1 … d` spatial.

The Wilson/Neuberger reference uses the *full* Wilson scalar
`r_W ∑_{μ} (1 - cos p_μ)` (acting as a scalar in Dirac ⊗ CKM space), which lifts
*all* spacetime doublers.  The null-edge endpoint already supplies a covariant
derivative `D_ne^cov` carrying the temporal/null direction, so the additional term
it needs is the **spatial-only** Wilson scalar.  The cleanest definition
compatible with the reference is therefore: -/

section FreeFlat

variable {d : ℕ}

/-- Wilson scalar profile over a chosen set of directions:
`wilsonScalar r dirs p = r * ∑_{μ ∈ dirs} (1 - cos p_μ)`.  It is the scalar (i.e.
identity-in-internal-space) coefficient of the Wilson term. -/
noncomputable def wilsonScalar (r : ℝ) (dirs : Finset (Fin d)) (p : Fin d → ℝ) : ℝ :=
  r * ∑ μ ∈ dirs, (1 - Real.cos (p μ))

/-- The spatial directions: every direction except the temporal/null direction `0`. -/
def spatialDirs (d : ℕ) : Finset (Fin (d + 1)) := (Finset.univ).erase 0

/-- **Proposed `W_NE,space`.**  The spatial Wilson scalar with parameter `r_b`,
i.e. `r_b ∑_{j spatial} (1 - cos p_j)`.  This is exactly the Wilson reference
profile restricted to the spatial directions, so that
`D_ne^cov + W_NE,space` reproduces the full Wilson doubler-lifting on the spatial
sublattice while the null/temporal direction is handled covariantly. -/
noncomputable def W_NE_space (r_b : ℝ) (p : Fin (d + 1) → ℝ) : ℝ :=
  wilsonScalar r_b (spatialDirs d) p

/-- The full reference Wilson scalar (all directions), parameter `r_W`. -/
noncomputable def W_ref_full (r_W : ℝ) (p : Fin (d + 1) → ℝ) : ℝ :=
  wilsonScalar r_W (Finset.univ) p

/-- Each summand `1 - cos θ` is nonnegative. -/
theorem one_sub_cos_nonneg (θ : ℝ) : 0 ≤ 1 - Real.cos θ := by
  have := Real.cos_le_one θ
  linarith

/-- The Wilson scalar is nonnegative when `r ≥ 0`. -/
theorem wilsonScalar_nonneg {r : ℝ} (hr : 0 ≤ r) (dirs : Finset (Fin d))
    (p : Fin d → ℝ) : 0 ≤ wilsonScalar r dirs p := by
  apply mul_nonneg hr
  apply Finset.sum_nonneg
  intro μ _
  exact one_sub_cos_nonneg _

/-- `W_NE_space` is nonnegative for `r_b ≥ 0`. -/
theorem W_NE_space_nonneg {r_b : ℝ} (hr : 0 ≤ r_b) (p : Fin (d + 1) → ℝ) :
    0 ≤ W_NE_space r_b p :=
  wilsonScalar_nonneg hr _ p

/-- **Doubler-lifting (spatial).**  If `r > 0` and at least one direction in `dirs`
sits strictly off its cosine maximum (`cos p_μ < 1`, e.g. a Brillouin corner with
`p_μ = π`), then the Wilson scalar is strictly positive.  This is the mechanism by
which `W_NE,space` removes spatial doublers without any CKM input. -/
theorem wilsonScalar_pos_of_corner {r : ℝ} (hr : 0 < r) {dirs : Finset (Fin d)}
    {p : Fin d → ℝ} {μ : Fin d} (hμ : μ ∈ dirs) (hcos : Real.cos (p μ) < 1) :
    0 < wilsonScalar r dirs p := by
  apply mul_pos hr
  apply Finset.sum_pos'
  · intro i _; exact one_sub_cos_nonneg _
  · exact ⟨μ, hμ, by linarith⟩

end FreeFlat

/-! ## 3. Doubler / gap obligations: "what must be proved" about `D_ne^cov + W_NE,space`

The predicates below name, precisely, the two facts that close the program once a
concrete operator realization is supplied.  They are *not* assumptions about CKM. -/

section Obligations

variable {P : Type*}
variable {E : Type*}
  [NormedAddCommGroup E] [InnerProductSpace ℂ E] [FiniteDimensional ℂ E]

/-- Obligation (A): the reference is genuinely gapped.  Concretely this is the
spectral statement that the Wilson/Neuberger kinetic + mass data is bounded below
on the whole Brillouin zone — the physical mode lives at the gap edge through `m0`
and every doubler is pushed up by the Wilson term. -/
def ReferenceIsGapped (H_ref : OpFamily P E) : Prop := ∃ g : ℝ, Gapped g H_ref

/-- Obligation (B): the null-edge kinetic `D_ne^cov + W_NE,space` is close enough to
the reference after a single frame/sector transport `S`/`Sinv`.  The certificate
quantifies "close enough" by the same gap `g`. -/
def NullEdgeKineticCloseEnough
    (S Sinv H_ne H_ref : OpFamily P E) (g : ℝ) : Prop :=
  ∃ κ : ℝ, 0 ≤ κ ∧ κ < g ∧ KappaCertificate S Sinv H_ne H_ref κ

/-- Packaged success criterion: discharging both obligations yields gapped
homotopy.  This is the deliverable theorem in fully assembled form. -/
theorem gateC1_success
    {H_ref H_ne S Sinv : OpFamily P E} {g : ℝ}
    (hRef : Gapped g H_ref)
    (hClose : NullEdgeKineticCloseEnough S Sinv H_ne H_ref g) :
    GappedHomotopic H_ref (transport S Sinv H_ne) := by
  obtain ⟨κ, hκ0, hκ, hcert⟩ := hClose
  exact nullEdge_gappedHomotopic_to_ref hRef hκ0 hκ hcert

/-- **Failure condition.**  If the transported null-edge kinetic is *not* within the
reference gap of the reference at some momentum, the straight-line certificate is
unavailable: there is no `κ < g` bound, so this construction cannot conclude
gapped homotopy.  (Physically: the null-edge kinetic is too far from
Wilson/Neuberger — a residual doubler or frame mismatch survives — and a different
`S`, a different `W_NE,space`, or a larger `g` is required.) -/
theorem gateC1_certificate_unavailable
    {S Sinv H_ne H_ref : OpFamily P E} {g : ℝ}
    (p : P) (hfar : g ≤ ‖transport S Sinv H_ne p - H_ref p‖) :
    ¬ ∃ κ : ℝ, κ < g ∧ KappaCertificate S Sinv H_ne H_ref κ := by
  rintro ⟨κ, hκ, hcert⟩
  have := hcert p
  linarith

end Obligations

end NullEdgeGateC1
