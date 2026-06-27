import Mathlib
import PhysicsSM.Draft.NullEdgeYukawaCheckerboard

/-!
# FUR-H4 — Gauge-covariant internal Yukawa map `Φ_H` with `χ_E` oddness

This file supplies the **internal finite spectral-triple half** of the null-edge
Gate A operator

```text
D = i D_N ⊗ 1 + Γ_s ⊗ Φ_H,
```

namely a concrete, gauge-covariant finite internal Dirac/Yukawa map `Φ_H`
together with the three structural facts that the Gate A square needs:

* `Φ_H` is **`χ_E`-odd**  (`{χ_E, Φ_H} = 0`), because it is the off-diagonal
  chirality-flip block on the internal `L ⊕ R` carrier;
* `Φ_H` is **`Γ_s`-even** (it commutes with the spacetime chirality, which acts
  on the internal factor as the identity), so the Gate A square carries the
  physical `+Φ_H²` mass block;
* `Φ_H` is **gauge-covariant**: it commutes with the (block-diagonal) gauge
  action whenever the constant Yukawa block `M` is a gauge intertwiner.

## Domain / codomain (Task step 2)

In the Furey picture the internal one-generation carrier is the minimal left
ideal `J` (particles) and its conjugate `J*` (antiparticles), and the finite
Yukawa map is morally `Φ_H : J → J*`.  Concretely, after electroweak symmetry
breaking the **Dirac-basis equivalent** is an off-diagonal chirality-flip block
on `H_L ⊕ H_R`, where `H_L`, `H_R` are the left/right chiral carriers and the
constant block is `M : H_R →ₗ[ℂ] H_L` (the convention fixed by
`PhysicsSM.Draft.NullEdgeYukawaCheckerboard`).  We work in this Dirac `L ⊕ R`
basis throughout.

**Guardrail (Task).** This Dirac `L ⊕ R` basis is *not* the all-left anomaly
basis used by the Furey anomaly bridge / `NullEdgeInternalSpectrum`.  The
all-left basis is a bookkeeping list of left-handed Weyl multiplets used to
verify anomaly cancellation; the Dirac `L ⊕ R` basis here is the kinetic carrier
on which the mass operator acts.  We deliberately do not identify them.

## Relation to the existing Gate A files

* The `±Φ_H²` sign dichotomy is the abstract two-grading bridge of
  `PhysicsSM.Draft.NullEdgeSuperDiracSignBridge` (`super_dirac_sign_bridge`);
  because that module is not available in this excerpt we restate the two
  one-line graded-square identities (`graded_square_comm` /
  `graded_square_anticomm`) locally and apply them to `Φ_H`.
* The squared mass blocks `Φ_H² = (M Mᴴ) ⊕ (Mᴴ M)` are exactly the checkerboard
  blocks of `PhysicsSM.Draft.NullEdgeYukawaCheckerboard`; the singular-value
  correspondence `yukawa_nonzero_eigenvalue_correspondence` is reused verbatim.

## Guardrails honoured

* This does **not** derive Yukawa eigenvalues: `M` is an arbitrary linear map.
* No new axioms or fake assumptions; everything is finite linear algebra.

## Main results

* `chiE_sq` — `χ_E² = 1`.
* `phiH_chiE_odd` — `{χ_E, Φ_H} = 0` (the `χ_E`-oddness).
* `phiH_gammaS_even` — `Φ_H` commutes with the internal restriction of `Γ_s`.
* `phiH_sq_apply` / `phiH_sq` — `Φ_H²` is the block-diagonal `(M Mᴴ) ⊕ (Mᴴ M)`.
* `phiH_sign_dichotomy` — the `+Φ_H²` (safe, `Γ_s`) vs `−Φ_H²` (conflated, `χ_E`)
  super-Dirac sign dichotomy.
* `gammaS_internal_ne_chiE` — non-conflation: `Γ_s` and `χ_E` are distinct maps.
* `phiH_gauge_covariant` — gauge covariance from a gauge-intertwining `M`.
* `chiE_gauge_commutes` — the gauge action preserves the `χ_E` grading.
* `phiH_sq_nonzero_eigenvalue_correspondence` — the Yukawa singular-value pairing
  relating the two diagonal blocks of `Φ_H²` (bridge to the checkerboard).
* `GaugeCovariantPhiH` / `GaugeCovariantPhiH.isProperPhiH` — the packaged
  interface and its bundled correctness theorem.
-/

namespace PhysicsSM
namespace Draft
namespace FureyPhiH

open scoped ComplexConjugate

/-! ## 1. Abstract graded-square sign identities

These mirror `PhysicsSM.Draft.SuperDiracSignBridge.graded_square_comm` /
`graded_square_anticomm`; restated locally so this file is self-contained. -/

section Abstract

variable {A : Type*} [Ring A]

/-- If `G² = 1` and `G` commutes with `Ph`, then `(G Ph)² = +Ph²`. -/
theorem graded_square_comm (G Ph : A) (hG2 : G * G = 1) (hcomm : G * Ph = Ph * G) :
    (G * Ph) * (G * Ph) = Ph * Ph := by
  calc (G * Ph) * (G * Ph) = G * (Ph * G) * Ph := by noncomm_ring
    _ = G * (G * Ph) * Ph := by rw [hcomm]
    _ = (G * G) * (Ph * Ph) := by noncomm_ring
    _ = Ph * Ph := by rw [hG2, one_mul]

/-- If `G² = 1` and `G` anticommutes with `Ph`, then `(G Ph)² = −Ph²`. -/
theorem graded_square_anticomm (G Ph : A) (hG2 : G * G = 1)
    (hanti : G * Ph = -(Ph * G)) :
    (G * Ph) * (G * Ph) = -(Ph * Ph) := by
  have hanti' : Ph * G = -(G * Ph) := by rw [hanti, neg_neg]
  calc (G * Ph) * (G * Ph) = G * (Ph * G) * Ph := by noncomm_ring
    _ = G * (-(G * Ph)) * Ph := by rw [hanti']
    _ = -((G * G) * (Ph * Ph)) := by noncomm_ring
    _ = -(Ph * Ph) := by rw [hG2, one_mul]

end Abstract

/-! ## 2. The internal Dirac `L ⊕ R` carrier and the maps `χ_E`, `Φ_H` -/

section Dirac

variable {H_L H_R : Type*}
  [NormedAddCommGroup H_L] [InnerProductSpace ℂ H_L] [FiniteDimensional ℂ H_L]
  [NormedAddCommGroup H_R] [InnerProductSpace ℂ H_R] [FiniteDimensional ℂ H_R]

/-- The internal chirality grading `χ_E` on `H_L × H_R`: `+1` on `H_L`,
`−1` on `H_R`. -/
noncomputable def chiE : Module.End ℂ (H_L × H_R) :=
  LinearMap.prodMap LinearMap.id (-LinearMap.id)

/-- The internal Yukawa / chirality-flip map `Φ_H` built from the constant block
`M : H_R →ₗ[ℂ] H_L`.  In the Dirac `L ⊕ R` basis it is the off-diagonal block
`[[0, M], [Mᴴ, 0]]`, i.e. `(x_L, x_R) ↦ (M x_R, Mᴴ x_L)`. -/
noncomputable def phiH (M : H_R →ₗ[ℂ] H_L) : Module.End ℂ (H_L × H_R) :=
  LinearMap.coprod
    (LinearMap.inr ℂ H_L H_R ∘ₗ LinearMap.adjoint M)
    (LinearMap.inl ℂ H_L H_R ∘ₗ M)

/-- The block-diagonal gauge action `(g_L, g_R)` on `H_L × H_R`. -/
noncomputable def gaugeAct (gL : Module.End ℂ H_L) (gR : Module.End ℂ H_R) :
    Module.End ℂ (H_L × H_R) :=
  LinearMap.prodMap gL gR

omit [FiniteDimensional ℂ H_L] [FiniteDimensional ℂ H_R] in
@[simp] theorem chiE_apply (x : H_L × H_R) : chiE x = (x.1, -x.2) := by
  simp [chiE]

@[simp] theorem phiH_apply (M : H_R →ₗ[ℂ] H_L) (x : H_L × H_R) :
    phiH M x = (M x.2, LinearMap.adjoint M x.1) := by
  simp [phiH]

omit [FiniteDimensional ℂ H_L] [FiniteDimensional ℂ H_R] in
@[simp] theorem gaugeAct_apply (gL : Module.End ℂ H_L) (gR : Module.End ℂ H_R)
    (x : H_L × H_R) : gaugeAct gL gR x = (gL x.1, gR x.2) := by
  simp [gaugeAct]

/-! ### `χ_E` is an involution and `Φ_H` is `χ_E`-odd -/

omit [FiniteDimensional ℂ H_L] [FiniteDimensional ℂ H_R] in
/-- `χ_E² = 1`. -/
theorem chiE_sq : (chiE : Module.End ℂ (H_L × H_R)) * chiE = 1 := by
  ext x <;> simp [Module.End.mul_apply]

/-- **`χ_E` oddness.** `Φ_H` anticommutes with the internal chirality grading:
`χ_E Φ_H = −Φ_H χ_E`, i.e. `{χ_E, Φ_H} = 0`.  This is the precise sense in which
`Φ_H` is an off-diagonal block on `L ⊕ R`. -/
theorem phiH_chiE_odd (M : H_R →ₗ[ℂ] H_L) :
    chiE * phiH M = -(phiH M * chiE) := by
  ext x <;> simp [Module.End.mul_apply]

/-! ### `Φ_H` is `Γ_s`-even

The spacetime chirality `Γ_s` lives on the spacetime factor of `D = i D_N ⊗ 1 +
Γ_s ⊗ Φ_H`; on the internal carrier it acts as the identity.  Hence `Φ_H`, being
internal, is `Γ_s`-even.  We record this as commutation with `1`, and the genuine
non-conflation `Γ_s ≠ χ_E` separately. -/

/-- `Φ_H` commutes with the internal restriction of `Γ_s` (the identity). -/
theorem phiH_gammaS_even (M : H_R →ₗ[ℂ] H_L) :
    (1 : Module.End ℂ (H_L × H_R)) * phiH M = phiH M * 1 := by
  simp

omit [FiniteDimensional ℂ H_L] [FiniteDimensional ℂ H_R] in
/-- **Non-conflation guardrail.** When the right carrier is nontrivial, the
internal restriction of `Γ_s` (the identity) is genuinely different from `χ_E`;
they must not be conflated, exactly the sign trap of the Gate A square. -/
theorem gammaS_internal_ne_chiE [Nontrivial H_R] :
    (1 : Module.End ℂ (H_L × H_R)) ≠ chiE := by
  intro h
  obtain ⟨y, hy⟩ := exists_ne (0 : H_R)
  have h2 := congrArg (fun f => (f ((0 : H_L), y)).2) h
  simp [Module.End.one_apply] at h2
  have h3 : (2 : ℂ) • y = 0 := by rw [two_smul]; linear_combination (norm := module) h2
  rcases smul_eq_zero.mp h3 with h | h
  · norm_num at h
  · exact hy h

/-! ### The squared mass block `Φ_H² = (M Mᴴ) ⊕ (Mᴴ M)` -/

/-- `Φ_H²` is block-diagonal with the checkerboard mass blocks `M Mᴴ` on `H_L`
and `Mᴴ M` on `H_R`. -/
theorem phiH_sq_apply (M : H_R →ₗ[ℂ] H_L) (x : H_L × H_R) :
    (phiH M * phiH M) x =
      ((M ∘ₗ LinearMap.adjoint M) x.1, (LinearMap.adjoint M ∘ₗ M) x.2) := by
  simp [Module.End.mul_apply]

/-- `Φ_H²` as a single linear map: the block-diagonal `(M Mᴴ) ⊕ (Mᴴ M)`. -/
theorem phiH_sq (M : H_R →ₗ[ℂ] H_L) :
    phiH M * phiH M =
      LinearMap.prodMap (M ∘ₗ LinearMap.adjoint M) (LinearMap.adjoint M ∘ₗ M) := by
  ext x <;> simp [Module.End.mul_apply]

/-! ### The `±Φ_H²` super-Dirac sign dichotomy -/

/-- **Super-Dirac sign dichotomy.**  Pairing `Φ_H` with the spacetime chirality
`Γ_s` (which commutes with it — here its internal restriction `1`) gives the
physical `+Φ_H²`, while pairing it with the internal chirality `χ_E` (which it is
odd under) gives the tachyonic `−Φ_H²`. -/
theorem phiH_sign_dichotomy (M : H_R →ₗ[ℂ] H_L) :
    ((1 : Module.End ℂ (H_L × H_R)) * phiH M) * (1 * phiH M) = phiH M * phiH M
      ∧ (chiE * phiH M) * (chiE * phiH M) = -(phiH M * phiH M) := by
  refine ⟨?_, graded_square_anticomm chiE (phiH M) chiE_sq (phiH_chiE_odd M)⟩
  simp only [one_mul]

/-! ### Gauge covariance -/

/-- **Gauge covariance.**  If the constant Yukawa block `M` is a gauge
intertwiner — `g_L ∘ M = M ∘ g_R` and the adjoint relation `g_R ∘ Mᴴ = Mᴴ ∘ g_L`
— then `Φ_H` commutes with the block-diagonal gauge action: the Yukawa term is
gauge-covariant. -/
theorem phiH_gauge_covariant (M : H_R →ₗ[ℂ] H_L)
    (gL : Module.End ℂ H_L) (gR : Module.End ℂ H_R)
    (hLR : gL ∘ₗ M = M ∘ₗ gR)
    (hRL : gR ∘ₗ LinearMap.adjoint M = LinearMap.adjoint M ∘ₗ gL) :
    gaugeAct gL gR * phiH M = phiH M * gaugeAct gL gR := by
  ext x <;> simp [Module.End.mul_apply] <;>
    first
      | exact LinearMap.congr_fun hLR _
      | exact LinearMap.congr_fun hRL _

omit [FiniteDimensional ℂ H_L] [FiniteDimensional ℂ H_R] in
/-- The gauge action preserves the `χ_E` grading: gauge transformations are
chirality-diagonal, so they always commute with `χ_E`. -/
theorem chiE_gauge_commutes (gL : Module.End ℂ H_L) (gR : Module.End ℂ H_R) :
    gaugeAct gL gR * chiE = chiE * gaugeAct gL gR := by
  ext x <;> simp [Module.End.mul_apply]

/-! ### Bridge to the Yukawa checkerboard: singular-value pairing -/

/-- **Legal Yukawa pairing / checkerboard bridge.**  The two diagonal blocks of
`Φ_H²` are exactly the checkerboard mass blocks `M Mᴴ` (on `H_L`) and `Mᴴ M`
(on `H_R`); their nonzero eigenvalues — the squared Dirac masses — coincide.
This is `yukawa_nonzero_eigenvalue_correspondence` transported to the blocks of
`Φ_H²`. -/
theorem phiH_sq_nonzero_eigenvalue_correspondence
    (M : H_R →ₗ[ℂ] H_L) {μ : ℂ} (hμ : μ ≠ 0) :
    (∃ x : H_L, x ≠ 0 ∧ (M ∘ₗ LinearMap.adjoint M) x = μ • x) ↔
      (∃ y : H_R, y ≠ 0 ∧ (LinearMap.adjoint M ∘ₗ M) y = μ • y) :=
  PhysicsSM.Draft.yukawa_nonzero_eigenvalue_correspondence M hμ

end Dirac

/-! ## 3. Packaged gauge-covariant `Φ_H` interface -/

section Package

variable {H_L H_R : Type*}
  [NormedAddCommGroup H_L] [InnerProductSpace ℂ H_L] [FiniteDimensional ℂ H_L]
  [NormedAddCommGroup H_R] [InnerProductSpace ℂ H_R] [FiniteDimensional ℂ H_R]
  {G : Type*} [Monoid G]

/-- A **gauge-covariant internal Yukawa datum**: a constant chirality-flip block
`M` together with a gauge representation on each chiral carrier under which `M`
is an intertwiner (a *legal*, gauge-invariant Yukawa coupling).  This is the
interface a Furey-style internal sector must supply for `Φ_H`. -/
structure GaugeCovariantPhiH
    (H_L H_R : Type*)
    [NormedAddCommGroup H_L] [InnerProductSpace ℂ H_L] [FiniteDimensional ℂ H_L]
    [NormedAddCommGroup H_R] [InnerProductSpace ℂ H_R] [FiniteDimensional ℂ H_R]
    (G : Type*) [Monoid G] where
  /-- The constant Yukawa block `M : H_R →ₗ[ℂ] H_L`. -/
  M : H_R →ₗ[ℂ] H_L
  /-- The gauge representation on the left carrier. -/
  rhoL : G → Module.End ℂ H_L
  /-- The gauge representation on the right carrier. -/
  rhoR : G → Module.End ℂ H_R
  /-- `M` is a gauge intertwiner (gauge invariance of the Yukawa coupling). -/
  intertwine : ∀ g, rhoL g ∘ₗ M = M ∘ₗ rhoR g
  /-- The adjoint intertwining relation (gauge action is chirality-diagonal). -/
  intertwine_adj :
    ∀ g, rhoR g ∘ₗ LinearMap.adjoint M = LinearMap.adjoint M ∘ₗ rhoL g

namespace GaugeCovariantPhiH

variable (P : GaugeCovariantPhiH H_L H_R G)

/-- The internal Yukawa operator `Φ_H` of the datum. -/
noncomputable def op : Module.End ℂ (H_L × H_R) := phiH P.M

/-- The gauge action of `g` on the Dirac carrier. -/
noncomputable def act (g : G) : Module.End ℂ (H_L × H_R) :=
  gaugeAct (P.rhoL g) (P.rhoR g)

/-- **Bundled correctness of the interface.**  For every gauge-covariant Yukawa
datum, the resulting `Φ_H`:
1. is `χ_E`-odd;
2. is `Γ_s`-even (commutes with the internal `1`), giving the `+Φ_H²` sign;
3. is gauge-covariant for every group element;
4. has `Φ_H²` equal to the block-diagonal checkerboard mass block. -/
theorem isProperPhiH :
    (chiE * P.op = -(P.op * chiE))
      ∧ ((1 : Module.End ℂ (H_L × H_R)) * P.op = P.op * 1)
      ∧ (∀ g, P.act g * P.op = P.op * P.act g)
      ∧ (P.op * P.op =
          LinearMap.prodMap (P.M ∘ₗ LinearMap.adjoint P.M)
            (LinearMap.adjoint P.M ∘ₗ P.M)) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · simpa only [op] using phiH_chiE_odd P.M
  · simpa only [op] using phiH_gammaS_even P.M
  · intro g
    simpa only [op, act] using
      phiH_gauge_covariant P.M (P.rhoL g) (P.rhoR g) (P.intertwine g) (P.intertwine_adj g)
  · simpa only [op] using phiH_sq P.M

end GaugeCovariantPhiH

end Package

end FureyPhiH
end Draft
end PhysicsSM
