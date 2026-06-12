import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldCAR
import PhysicsSM.Spinor.SpinorTenfoldGammaSymm

/-!
# Draft.SpinorTenfoldSO10ActionAristotle

Aristotle handoff: the infinitesimal `Spin(10)` action on the Fock model.

## Mathematical intent

This is the entry point to the *group-level* part of the
`Sources/Spin10_stabilizer.txt` program (orbit trichotomy, Selector
Theorem). The spin representation of `so(10)` on the Fock spinors is given by
Clifford bivectors

  `ρ(v ∧ w) = (1/2) (γ_v γ_w - γ_w γ_v)`,

and the four target theorems below are the standard structure facts:

1. `rho_intertwine` — `[ρ(v ∧ w), γ_u] = γ_{ad(v ∧ w) u}` with
   `ad(v ∧ w) u = B(w, u) v - B(v, u) w`: the Clifford action intertwines the
   spinor and vector representations.
2. `rho_bracket` — `ρ` is a Lie algebra representation of `so(10)` (the
   bivector bracket).
3. `chevalleyPairing_rho_skew` — infinitesimal invariance of the Chevalley
   pairing.
4. `gammaBilinear_rho_equivariant` — the gamma-bilinear `q` is equivariant:
   `q(ρψ, φ) + q(ψ, ρφ) = ad(v ∧ w) q(ψ, φ)`. Together with the symmetry of
   `q` this makes the purity quadric infinitesimally `so(10)`-invariant
   (`purity_infinitesimally_invariant` below, already derived from the
   targets), the key step toward orbit and stabilizer arguments.

All four statements are verified numerically by the oracle
`Scripts/oracle/validate_spinor_tenfold.py` (test section `[so10]`), with
exact rational arithmetic in the same conventions. Use it only as sign
guidance; the Lean proofs must be kernel-checked from the definitions.

## Proof guidance

Everything should reduce to the trusted CAR layer
(`PhysicsSM.Spinor.SpinorTenfoldCAR`): `cliffordAction_anticomm`
(`γ_v γ_w + γ_w γ_v = B(v, w) • id`), `cliffordAction_cliffordAction_self`,
bilinearity (`cliffordAction_add_vec/_spinor`, `cliffordAction_smul_vec`),
and for (3) the adjunction `B10_gammaBilinear` plus
`chevalleyPairing` linearity from `PhysicsSM.Spinor.SpinorTenfoldPurity`.
For (3) a direct route is: prove the skew-adjointness of a single Clifford
operator first, `β(γ_u ψ, φ) = β(ψ, γ_u φ)` or its signed variant — derive
the correct sign from the alpha-twist convention (the oracle confirms the
final statement) — then (3) follows formally; (4) follows from (3) via the
adjunction, or can be proved directly.

Do not change any definition or sign convention. Helper lemmas are welcome.

This is draft code: the statements below contain documented `sorry`s and
must not be imported from trusted code until the holes are eliminated.
-/

noncomputable section

namespace PhysicsSM.Draft.SpinorTenfoldSO10Action

open PhysicsSM.Spinor.SpinorTenfold

/-! ## The infinitesimal action -/

/-- The spin representation of the bivector `v ∧ w` on Fock spinors:
`ρ(v ∧ w) = (1/2)(γ_v γ_w - γ_w γ_v)`. With this normalization the
intertwining relation below has no spurious factor. -/
def rho (v w : V10) (ψ : FockSpinor) : FockSpinor :=
  (2⁻¹ : ℂ) • (cliffordAction v (cliffordAction w ψ)
    - cliffordAction w (cliffordAction v ψ))

/-- The action of the bivector `v ∧ w` on the vector representation:
`ad(v ∧ w) u = B(w, u) v - B(v, u) w`. -/
def soAd (v w u : V10) : V10 := B10 w u • v - B10 v u • w

/-! ## Easy structure lemmas (proved here) -/

@[simp] theorem rho_self (v : V10) (ψ : FockSpinor) : rho v v ψ = 0 := by
  unfold rho
  rw [sub_self, smul_zero]

theorem rho_antisymm (v w : V10) (ψ : FockSpinor) : rho v w ψ = -(rho w v ψ) := by
  unfold rho
  rw [← smul_neg, neg_sub]

/-- `ρ` preserves positive chirality: bivectors act within each Weyl half. -/
theorem isEvenSpinor_rho {ψ : FockSpinor} (hψ : IsEvenSpinor ψ) (v w : V10) :
    IsEvenSpinor (rho v w ψ) := by
  intro S hS
  unfold rho
  rw [Pi.smul_apply, Pi.sub_apply,
    ((hψ.cliffordAction w).cliffordAction v) S hS,
    ((hψ.cliffordAction v).cliffordAction w) S hS, sub_zero, smul_zero]

/-- `soAd` annihilates the zero vector. -/
@[simp] theorem soAd_zero (v w : V10) : soAd v w 0 = 0 := by
  unfold soAd
  rw [B10_zero_right, B10_zero_right, zero_smul, zero_smul, sub_zero]

/-- `B10` of a difference, left slot. -/
theorem B10_sub_left (u v w : V10) : B10 (u - v) w = B10 u w - B10 v w := by
  unfold B10
  rw [← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun i _ => ?_
  simp only [Prod.fst_sub, Prod.snd_sub, Pi.sub_apply]
  ring

/-- `B10` of a difference, right slot. -/
theorem B10_sub_right (u v w : V10) : B10 u (v - w) = B10 u v - B10 u w := by
  rw [B10_comm, B10_sub_left, B10_comm v u, B10_comm w u]

/-- `soAd` is infinitesimally orthogonal: it is skew for `B10`, so the
quadratic form `Q10` is infinitesimally invariant on the vector
representation. -/
theorem B10_soAd_skew (v w u u' : V10) :
    B10 (soAd v w u) u' + B10 u (soAd v w u') = 0 := by
  unfold soAd
  rw [B10_sub_left, B10_sub_right, B10_smul_left, B10_smul_left,
    B10_smul_right, B10_smul_right, B10_comm u v, B10_comm u w]
  ring

/-! ## Aristotle targets -/

/-- **Target 1 (intertwining)**: `[ρ(v ∧ w), γ_u] = γ_{ad(v ∧ w) u}`. The
Clifford action is `so(10)`-equivariant from the spinor to the vector side.
Oracle: `[so10] intertwine`. -/
theorem rho_intertwine (v w u : V10) (ψ : FockSpinor) :
    rho v w (cliffordAction u ψ) - cliffordAction u (rho v w ψ)
      = cliffordAction (soAd v w u) ψ := by
  sorry

/-- **Target 2 (Lie representation)**: the bivector bracket. Oracle:
`[so10] bracket`. -/
theorem rho_bracket (v w v' w' : V10) (ψ : FockSpinor) :
    rho v w (rho v' w' ψ) - rho v' w' (rho v w ψ)
      = B10 w v' • rho v w' ψ - B10 v v' • rho w w' ψ
        - B10 w w' • rho v v' ψ + B10 v w' • rho w v' ψ := by
  sorry

/-- **Target 3 (pairing invariance)**: the Chevalley pairing is
infinitesimally `so(10)`-invariant. Oracle: `[so10] skew`. -/
theorem chevalleyPairing_rho_skew (v w : V10) (ψ φ : FockSpinor) :
    chevalleyPairing (rho v w ψ) φ + chevalleyPairing ψ (rho v w φ) = 0 := by
  sorry

/-- **Target 4 (gamma-bilinear equivariance)**: `q` intertwines the spinor
and vector actions. Oracle: `[so10] equivariance`. -/
theorem gammaBilinear_rho_equivariant (v w : V10) (ψ φ : FockSpinor) :
    gammaBilinear (rho v w ψ) φ + gammaBilinear ψ (rho v w φ)
      = soAd v w (gammaBilinear ψ φ) := by
  sorry

/-! ## Derived consequence (proof complete modulo the targets) -/

/-- **The purity quadric is infinitesimally `so(10)`-invariant**: if `ψ` lies
on the quadric then every `ρ(v ∧ w) ψ` is `q`-orthogonal to `ψ`, i.e. the
infinitesimal orbit stays tangent to the spinor-tenfold cone. This is the
first stone of the orbit/stabilizer program. -/
theorem purity_infinitesimally_invariant {ψ : FockSpinor}
    (h : gammaBilinear ψ ψ = 0) (v w : V10) :
    gammaBilinear (rho v w ψ) ψ = 0 := by
  have h2 := gammaBilinear_rho_equivariant v w ψ ψ
  rw [h, soAd_zero, gammaBilinear_symm ψ (rho v w ψ)] at h2
  have h3 : (2 : ℂ) • gammaBilinear (rho v w ψ) ψ = 0 := by
    rw [two_smul]
    exact h2
  rcases smul_eq_zero.mp h3 with h' | h'
  · exact absurd h' two_ne_zero
  · exact h'

end PhysicsSM.Draft.SpinorTenfoldSO10Action

end
