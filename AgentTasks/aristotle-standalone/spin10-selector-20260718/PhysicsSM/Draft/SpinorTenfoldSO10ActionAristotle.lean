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

Everything reduces to the trusted CAR layer
(`PhysicsSM.Spinor.SpinorTenfoldCAR`): `cliffordAction_anticomm`
(`γ_v γ_w + γ_w γ_v = B(v, w) • id`), `cliffordAction_cliffordAction_self`,
bilinearity (`cliffordAction_add_vec/_spinor`, `cliffordAction_smul_vec`),
the adjunction `B10_gammaBilinear`, the symmetry `gammaBilinear_symm`, and
`chevalleyPairing` linearity from `PhysicsSM.Spinor.SpinorTenfoldPurity`.

Targets (1), (2) are formal consequences of the CAR layer. For (3) the key
fact is the **double-operator transpose**
`β(γ_p γ_q ψ, φ) = β(ψ, γ_q γ_p φ)`. We obtain it from two single-operator
argument-swap identities:
* `β(γ_u ψ, φ) = β(γ_u φ, ψ)` (operator on the left slot), which follows
  directly from `B10_gammaBilinear` and `gammaBilinear_symm`;
* `β(ψ, γ_u φ) = β(φ, γ_u ψ)` (operator on the right slot), verified on basis
  monomials via the computable integer mirror of
  `PhysicsSM.Spinor.SpinorTenfoldGammaSymm`, transported to `ℂ` and
  bilinearized.

Note that the *single*-operator self-adjoint relation
`β(γ_u ψ, φ) = ± β(ψ, γ_u φ)` is **not** a global sign here, so (3) genuinely
needs the two-operator statement. Target (4) follows from (1), (3),
`B10_gammaBilinear`, `B10_soAd_skew`, and nondegeneracy of `B10`.

Do not change any definition or sign convention. Helper lemmas are welcome.

Status: all four targets are proved (no `s o r r y`, no `a x i o m`, no
`n a t i v e _ d e c i d e`); the two single-operator right-slot swap facts on the integer
mirror are closed by kernel `decide`.
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

/-! ## Linearity of `rho`

`rho` is linear in the spinor argument and in each of its two vector slots;
these are immediate from the bilinearity of `cliffordAction`. -/

theorem rho_add_spinor (v w : V10) (ψ φ : FockSpinor) :
    rho v w (ψ + φ) = rho v w ψ + rho v w φ := by
      unfold rho;
      simp +decide only [cliffordAction_add_spinor];
      rw [ ← smul_add ] ; ring

theorem rho_sub_spinor (v w : V10) (ψ φ : FockSpinor) :
    rho v w (ψ - φ) = rho v w ψ - rho v w φ := by
      convert rho_add_spinor v w ψ ( -φ ) using 1 ; simp +decide [ sub_eq_add_neg, rho ] ; ring;
      rw [ show cliffordAction v ( -φ ) = -cliffordAction v φ from ?_, show cliffordAction w ( -φ ) = -cliffordAction w φ from ?_ ] ; norm_num ; ring;
      · rw [ show cliffordAction v ( -cliffordAction w φ ) = -cliffordAction v ( cliffordAction w φ ) from ?_, show cliffordAction w ( -cliffordAction v φ ) = -cliffordAction w ( cliffordAction v φ ) from ?_ ] ; ring;
        · ext; norm_num; ring;
        · rw [ show -cliffordAction v φ = ( -1 : ℂ ) • cliffordAction v φ by ext; simp +decide, cliffordAction_smul_spinor ] ; norm_num;
        · convert cliffordAction_smul_spinor ( -1 ) v ( cliffordAction w φ ) using 1 ; norm_num;
          norm_num [ neg_smul ];
      · ext; simp [cliffordAction];
        unfold wedge contract; simp +decide [ Finset.sum_add_distrib, mul_add, add_mul, add_assoc, add_left_comm, add_comm ] ; ring;
        rw [ ← Finset.sum_neg_distrib ] ; congr ; ext ; split_ifs <;> ring;
      · convert cliffordAction_smul_spinor ( -1 ) v φ using 1 ; norm_num;
        norm_num [ neg_smul ]

theorem rho_smul_spinor (c : ℂ) (v w : V10) (ψ : FockSpinor) :
    rho v w (c • ψ) = c • rho v w ψ := by
      unfold rho
      simp [cliffordAction_smul_spinor];
      rw [ ← smul_sub, smul_comm ]

theorem rho_add_left (v₁ v₂ w : V10) (ψ : FockSpinor) :
    rho (v₁ + v₂) w ψ = rho v₁ w ψ + rho v₂ w ψ := by
      unfold rho;
      rw [ ← smul_add, cliffordAction_add_vec, cliffordAction_add_vec ] ; ring;
      rw [ cliffordAction_add_spinor ] ; ring

theorem rho_sub_left (v₁ v₂ w : V10) (ψ : FockSpinor) :
    rho (v₁ - v₂) w ψ = rho v₁ w ψ - rho v₂ w ψ := by
      have h_rho_add_left : rho (v₁ - v₂) w ψ = rho v₁ w ψ + rho (-v₂) w ψ := by
        convert rho_add_left v₁ ( -v₂ ) w ψ using 1;
      convert h_rho_add_left using 1 ; ring;
      unfold rho;
      rw [ show cliffordAction ( -v₂ ) = fun ψ => -cliffordAction v₂ ψ from funext fun _ => ?_ ] ; norm_num ; ring;
      · rw [ show cliffordAction w ( -cliffordAction v₂ ψ ) = -cliffordAction w ( cliffordAction v₂ ψ ) from ?_ ] ; ring;
        · module;
        · rw [ show -cliffordAction v₂ ψ = ( -1 : ℂ ) • cliffordAction v₂ ψ by ext; simp +decide, cliffordAction_smul_spinor ] ; norm_num;
      · ext; simp +decide [ cliffordAction ] ; ring;

theorem rho_smul_left (c : ℂ) (v w : V10) (ψ : FockSpinor) :
    rho (c • v) w ψ = c • rho v w ψ := by
      -- Expand `rho` for `(c • v)` and `v`, then use linearity of `cliffordAction` to pull `c` out.
      -- This reduces the goal to algebraic simplification via `smul_comm` and `smul_sub`.
      unfold rho
      simp [cliffordAction_smul_vec]
      group;
      rw [ cliffordAction_smul_spinor ] ; ext ; norm_num ; ring;

theorem rho_add_right (v w₁ w₂ : V10) (ψ : FockSpinor) :
    rho v (w₁ + w₂) ψ = rho v w₁ ψ + rho v w₂ ψ := by
      unfold rho;
      simp +decide only [cliffordAction_add_vec, ← smul_add, sub_add_sub_comm];
      rw [ cliffordAction_add_spinor ]

theorem rho_sub_right (v w₁ w₂ : V10) (ψ : FockSpinor) :
    rho v (w₁ - w₂) ψ = rho v w₁ ψ - rho v w₂ ψ := by
      unfold rho;
      rw [ show cliffordAction ( w₁ - w₂ ) = fun ψ => cliffordAction w₁ ψ - cliffordAction w₂ ψ from ?_ ] ; ring;
      · rw [ show cliffordAction v ( cliffordAction w₁ ψ - cliffordAction w₂ ψ ) = cliffordAction v ( cliffordAction w₁ ψ ) - cliffordAction v ( cliffordAction w₂ ψ ) from ?_ ] ; ring;
        · ext; norm_num; ring;
        · convert cliffordAction_add_spinor v (cliffordAction w₁ ψ) ( -cliffordAction w₂ ψ ) using 1 ; simp +decide [ sub_eq_add_neg ];
          exact Eq.symm ( by rw [ show -cliffordAction w₂ ψ = ( -1 : ℂ ) • cliffordAction w₂ ψ by ext; simp +decide ] ; rw [ cliffordAction_smul_spinor ] ; simp +decide );
      · ext ψ; simp +decide [ sub_eq_add_neg, cliffordAction_add_vec ] ;
        unfold cliffordAction; simp +decide [ neg_mul ] ;
        ring

theorem rho_smul_right (c : ℂ) (v w : V10) (ψ : FockSpinor) :
    rho v (c • w) ψ = c • rho v w ψ := by
      unfold rho;
      rw [ cliffordAction_smul_vec, cliffordAction_smul_vec ] ; simp +decide [ smul_sub, smul_smul, mul_comm ] ; ring;
      rw [ cliffordAction_smul_spinor, smul_smul, mul_comm ]

/-! ## Nondegeneracy of `B10` -/

/-
`B10` is nondegenerate: a vector is determined by its `B10`-pairings
against all vectors (provable componentwise).
-/
theorem B10_ext {a b : V10} (h : ∀ u : V10, B10 a u = B10 b u) : a = b := by
  -- By definition of $B10$, we know that $B10 a u = \sum i, (a.1 i * u.2 i + a.2 i * u.1 i)$ and $B10 b u = \sum i, (b.1 i * u.2 i + b.2 i * u.1 i)$.
  ext i; simp [B10] at h ⊢;
  · specialize h 0 ( fun j => if j = i then 1 else 0 ) ; simp_all +decide [ Finset.sum_add_distrib ] ;
  · have := h ( ⟨ fun j => if j = i then 1 else 0, fun j => 0 ⟩ : V10 ) ; ( have := h ( ⟨ fun j => 0, fun j => if j = i then 1 else 0 ⟩ : V10 ) ; ( simp_all +decide [ B10 ] ; ) )

/-! ## Argument-swap identities for the Chevalley pairing

Two single-operator identities power the double-operator transpose. The first
(operator on the left slot) is a clean consequence of the gamma-bilinear
symmetry; the second (operator on the right slot) is checked on the integer
mirror, transported to `ℂ`, and bilinearized. -/

/-
**Left-slot argument swap**: `β(γ_u ψ, φ) = β(γ_u φ, ψ)`. Immediate from
`B10_gammaBilinear` and `gammaBilinear_symm`.
-/
theorem chevalleyPairing_cliffordAction_swap_left (u : V10) (ψ φ : FockSpinor) :
    chevalleyPairing (cliffordAction u ψ) φ
      = chevalleyPairing (cliffordAction u φ) ψ := by
        rw [ ← B10_gammaBilinear, ← B10_gammaBilinear, gammaBilinear_symm ]

set_option maxRecDepth 10000 in
set_option maxHeartbeats 4000000 in -- kernel `decide` over the 32×32 basis pairs
/-- Right-slot wedge swap on the integer mirror. -/
theorem chevalleyPairingZ_wedgeZ_swap_right :
    ∀ j : Fin 5, ∀ S T : Finset (Fin 5),
      chevalleyPairingZ (basisZ S) (wedgeZ j (basisZ T))
        = chevalleyPairingZ (basisZ T) (wedgeZ j (basisZ S)) := by decide

set_option maxRecDepth 10000 in
set_option maxHeartbeats 4000000 in -- kernel `decide` over the 32×32 basis pairs
/-- Right-slot contract swap on the integer mirror. -/
theorem chevalleyPairingZ_contractZ_swap_right :
    ∀ j : Fin 5, ∀ S T : Finset (Fin 5),
      chevalleyPairingZ (basisZ S) (contractZ j (basisZ T))
        = chevalleyPairingZ (basisZ T) (contractZ j (basisZ S)) := by decide

/-
Right-slot wedge swap on basis monomials over `ℂ`.
-/
theorem chevalleyPairing_wedge_swap_right_basis (j : Fin 5) (S T : Finset (Fin 5)) :
    chevalleyPairing (basisSpinor S) (wedge j (basisSpinor T))
      = chevalleyPairing (basisSpinor T) (wedge j (basisSpinor S)) := by
        -- Use `chevalleyPairingZ_wedgeZ_swap_right` to finish the proof.
        convert (chevalleyPairingZ_wedgeZ_swap_right j S T) using 1;
        convert Int.cast_inj using 1;
        convert Iff.rfl;
        all_goals try infer_instance;
        · convert chevalleyPairingZ_castC ( basisZ S ) ( wedgeZ j ( basisZ T ) ) using 1;
          rw [ castS_wedgeZ ];
          rw [ castS_basisZ, castS_basisZ ];
        · convert chevalleyPairingZ_castC ( basisZ T ) ( wedgeZ j ( basisZ S ) ) using 1;
          rw [ castS_wedgeZ, castS_basisZ, castS_basisZ ]

/-
Right-slot contract swap on basis monomials over `ℂ`.
-/
theorem chevalleyPairing_contract_swap_right_basis (j : Fin 5) (S T : Finset (Fin 5)) :
    chevalleyPairing (basisSpinor S) (contract j (basisSpinor T))
      = chevalleyPairing (basisSpinor T) (contract j (basisSpinor S)) := by
        convert congr_arg ( ( ↑ ) : ℤ → ℂ ) ( chevalleyPairingZ_contractZ_swap_right j S T ) using 1 <;> norm_num [ castS_basisZ, castS_contractZ, chevalleyPairingZ_castC ]

/-
Right-slot wedge swap for arbitrary spinors.
-/
theorem chevalleyPairing_wedge_swap_right (j : Fin 5) (ψ φ : FockSpinor) :
    chevalleyPairing ψ (wedge j φ) = chevalleyPairing φ (wedge j ψ) := by
      -- By definition of wedge product, we can write wedge j φ as a sum of wedge products of basis elements.
      have h_wedge : ∀ (φ : FockSpinor), wedge j φ = ∑ S : Finset (Fin 5), φ S • wedge j (basisSpinor S) := by
        intro φ
        have h_sum : φ = ∑ S : Finset (Fin 5), φ S • basisSpinor S := by
          exact funext fun S => by simp +decide [ basisSpinor ] ;
        conv_lhs => rw [ h_sum, wedge_sum, Finset.sum_congr rfl fun _ _ => wedge_smul _ _ _ ] ;
      -- By definition of Chevalley pairing, we can expand both sides using the linearity of the pairing.
      have h_expand : ∀ (ψ φ : FockSpinor), chevalleyPairing ψ (wedge j φ) = ∑ S : Finset (Fin 5), ψ S * ∑ T : Finset (Fin 5), φ T * chevalleyPairing (basisSpinor S) (wedge j (basisSpinor T)) := by
        intros ψ φ
        rw [h_wedge];
        simp +decide [ chevalleyPairing, Finset.mul_sum _ _ _, mul_assoc, mul_left_comm, Finset.sum_mul ];
        simp +decide [ basisSpinor, Finset.sum_ite ];
      rw [ h_expand, h_expand ];
      simp +decide only [Finset.mul_sum _ _ _, mul_left_comm];
      exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by rw [ chevalleyPairing_wedge_swap_right_basis ] )

/-
Right-slot contract swap for arbitrary spinors.
-/
theorem chevalleyPairing_contract_swap_right (j : Fin 5) (ψ φ : FockSpinor) :
    chevalleyPairing ψ (contract j φ) = chevalleyPairing φ (contract j ψ) := by
      have h_sum_comm : ∑ S, ∑ T, (ψ S * φ T) * chevalleyPairing (basisSpinor S) (contract j (basisSpinor T)) = ∑ S, ∑ T, (φ T * ψ S) * chevalleyPairing (basisSpinor T) (contract j (basisSpinor S)) := by
        grind +suggestions;
      convert h_sum_comm using 1;
      · rw [ show contract j φ = ∑ T, φ T • contract j ( basisSpinor T ) from ?_ ];
        · unfold chevalleyPairing;
          simp +decide [ Finset.mul_sum _ _ _, mul_assoc, mul_left_comm, Finset.sum_mul ];
          simp +decide [ basisSpinor, Finset.sum_ite, Finset.filter_eq', Finset.filter_ne' ];
        · convert contract_sum j ( Finset.univ : Finset ( Finset ( Fin 5 ) ) ) ( fun T => φ T • basisSpinor T ) using 1;
          · exact congr_arg _ ( spinor_eq_sum_basis φ ▸ rfl );
          · exact Finset.sum_congr rfl fun _ _ => by rw [ contract_smul ] ;
      · rw [ spinor_eq_sum_basis ψ ];
        simp +decide [ chevalleyPairing, contract_sum, contract_smul ];
        simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul, basisSpinor ];
        exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring )

/-
**Right-slot argument swap**: `β(ψ, γ_u φ) = β(φ, γ_u ψ)`.
-/
theorem chevalleyPairing_cliffordAction_swap_right (u : V10) (ψ φ : FockSpinor) :
    chevalleyPairing ψ (cliffordAction u φ)
      = chevalleyPairing φ (cliffordAction u ψ) := by
        rw [cliffordAction_eq_sum, cliffordAction_eq_sum];
        have h_sum : ∀ (s : Finset (Fin 5)) (f : Fin 5 → FockSpinor), chevalleyPairing ψ (∑ i ∈ s, f i) = ∑ i ∈ s, chevalleyPairing ψ (f i) := by
          intros s f; induction s using Finset.induction <;> simp_all +decide [ Finset.sum_insert, Finset.sum_singleton ] ;
          rw [ ← ‹chevalleyPairing ψ ( ∑ i ∈ _, f i ) = ∑ i ∈ _, chevalleyPairing ψ ( f i ) ›, chevalleyPairing_add_right ];
        have h_sum : ∀ (s : Finset (Fin 5)) (f : Fin 5 → FockSpinor), chevalleyPairing φ (∑ i ∈ s, f i) = ∑ i ∈ s, chevalleyPairing φ (f i) := by
          intros s f; induction s using Finset.induction <;> simp_all +decide [ Finset.sum_insert, Finset.sum_singleton ] ;
          rw [ ← ‹chevalleyPairing φ ( ∑ i ∈ _, f i ) = ∑ i ∈ _, chevalleyPairing φ ( f i ) ›, chevalleyPairing_add_right ];
        simp_all +decide [ chevalleyPairing_add_right, chevalleyPairing_smul_right ];
        exact congrArg₂ ( · + · ) ( Finset.sum_congr rfl fun _ _ => by rw [ chevalleyPairing_wedge_swap_right ] ) ( Finset.sum_congr rfl fun _ _ => by rw [ chevalleyPairing_contract_swap_right ] )

/-
**Double Clifford operator transpose** for the Chevalley pairing:
`β(γ_p γ_q ψ, φ) = β(ψ, γ_q γ_p φ)`. Apply the left-slot swap (moving `γ_p`),
then the right-slot swap (moving `γ_q`).
-/
theorem chevalleyPairing_cliffordAction_transpose (p q : V10) (ψ φ : FockSpinor) :
    chevalleyPairing (cliffordAction p (cliffordAction q ψ)) φ
      = chevalleyPairing ψ (cliffordAction q (cliffordAction p φ)) := by
        rw [ chevalleyPairing_cliffordAction_swap_left, chevalleyPairing_cliffordAction_swap_right ]

/-! ## Aristotle targets -/

/-
**Target 1 (intertwining)**: `[ρ(v ∧ w), γ_u] = γ_{ad(v ∧ w) u}`. The
Clifford action is `so(10)`-equivariant from the spinor to the vector side.
Oracle: `[so10] intertwine`.
-/
theorem rho_intertwine (v w u : V10) (ψ : FockSpinor) :
    rho v w (cliffordAction u ψ) - cliffordAction u (rho v w ψ)
      = cliffordAction (soAd v w u) ψ := by
  -- Unfold `rho` and `soAd`.
  unfold rho soAd;
  rw [ show cliffordAction ( B10 w u • v - B10 v u • w ) ψ = B10 w u • cliffordAction v ψ - B10 v u • cliffordAction w ψ from ?_ ];
  · have h_anticomm : ∀ (a b : V10) (χ : FockSpinor), cliffordAction a (cliffordAction b χ) = B10 a b • χ - cliffordAction b (cliffordAction a χ) := by
      exact fun a b χ => eq_sub_of_add_eq <| cliffordAction_anticomm a b χ;
    rw [ show cliffordAction v ( cliffordAction w ψ ) = B10 v w • ψ - cliffordAction w ( cliffordAction v ψ ) from h_anticomm v w ψ ] ; rw [ show cliffordAction w ( cliffordAction v ( cliffordAction u ψ ) ) = B10 w v • cliffordAction u ψ - cliffordAction v ( cliffordAction w ( cliffordAction u ψ ) ) from h_anticomm w v ( cliffordAction u ψ ) ] ; ring;
    rw [ show cliffordAction v ( cliffordAction w ( cliffordAction u ψ ) ) = B10 v w • cliffordAction u ψ - cliffordAction w ( cliffordAction v ( cliffordAction u ψ ) ) from h_anticomm v w ( cliffordAction u ψ ) ] ; rw [ show cliffordAction v ( cliffordAction u ψ ) = B10 v u • ψ - cliffordAction u ( cliffordAction v ψ ) from h_anticomm v u ψ ] ; ring;
    rw [ show B10 w v = B10 v w by exact B10_comm v w ▸ rfl ] ; norm_num [ mul_assoc, mul_comm, mul_left_comm, smul_smul ] ; ring;
    rw [ show cliffordAction w ( B10 v u • ψ - cliffordAction u ( cliffordAction v ψ ) ) = B10 v u • cliffordAction w ψ - cliffordAction w ( cliffordAction u ( cliffordAction v ψ ) ) from ?_ ] ; rw [ show cliffordAction u ( ( 1 / 2 : ℂ ) • ( B10 v w • ψ - cliffordAction w ( cliffordAction v ψ ) * 2 ) ) = ( 1 / 2 : ℂ ) • ( B10 v w • cliffordAction u ψ - cliffordAction u ( cliffordAction w ( cliffordAction v ψ ) ) * 2 ) from ?_ ] ; ring;
    · rw [ show B10 w u = B10 u w by exact B10_comm u w ▸ rfl ] ; rw [ h_anticomm u w ( cliffordAction v ψ ) ] ; ring;
      ext; norm_num; ring;
    · convert cliffordAction_smul_spinor ( 1 / 2 : ℂ ) u ( B10 v w • ψ - cliffordAction w ( cliffordAction v ψ ) * 2 ) using 1 ; norm_num [ mul_assoc, mul_comm, mul_left_comm, smul_smul ] ; ring;
      rw [ show cliffordAction u ( B10 v w • ψ - cliffordAction w ( cliffordAction v ψ ) * 2 ) = B10 v w • cliffordAction u ψ - cliffordAction u ( cliffordAction w ( cliffordAction v ψ ) * 2 ) from ?_ ] ; ring;
      · ext; simp +decide [ mul_two, add_mul ] ;
        rw [ cliffordAction_add_spinor ] ; ring;
        norm_num [ two_mul ];
        ring;
      · convert cliffordAction_smul_spinor ( B10 v w ) u ψ |> fun h => congr_arg₂ ( · - · ) h rfl using 1;
        convert cliffordAction_add_spinor u ( B10 v w • ψ ) ( -cliffordAction w ( cliffordAction v ψ ) * 2 ) using 1 ; ring;
        rw [ show -cliffordAction w ( cliffordAction v ψ ) * 2 = - ( cliffordAction w ( cliffordAction v ψ ) * 2 ) by ring, show cliffordAction u ( - ( cliffordAction w ( cliffordAction v ψ ) * 2 ) ) = -cliffordAction u ( cliffordAction w ( cliffordAction v ψ ) * 2 ) by
                                                                                                                              convert cliffordAction_smul_spinor ( -1 ) u ( cliffordAction w ( cliffordAction v ψ ) * 2 ) using 1 ; norm_num [ mul_assoc, mul_comm, mul_left_comm, smul_smul ] ; ring;
                                                                                                                              norm_num [ neg_smul ] ] ; ring;
    · convert cliffordAction_add_spinor w ( B10 v u • ψ ) ( -cliffordAction u ( cliffordAction v ψ ) ) using 1 ; norm_num [ cliffordAction_smul_spinor ];
      rw [ show cliffordAction w ( -cliffordAction u ( cliffordAction v ψ ) ) = -cliffordAction w ( cliffordAction u ( cliffordAction v ψ ) ) from ?_ ] ; ring;
      convert cliffordAction_smul_spinor ( -1 ) w ( cliffordAction u ( cliffordAction v ψ ) ) using 1 ; norm_num;
      norm_num [ neg_smul ];
  · convert cliffordAction_add_vec ( B10 w u • v ) ( -B10 v u • w ) ψ using 1;
    · norm_num [ sub_eq_add_neg ];
    · rw [ cliffordAction_smul_vec, cliffordAction_smul_vec ] ; ring;
      norm_num [ sub_eq_add_neg ]

/-
Bracket of two bivectors, in `soAd`-form: the commutator of `ρ(v∧w)` and
`ρ(v'∧w')` is `ρ((soAd v w v')∧w') + ρ(v'∧(soAd v w w'))`. This is the
operator content of the bracket; the final `B10`-coefficient form follows by
linearity of `ρ`.
-/
theorem rho_bracket_aux (v w v' w' : V10) (ψ : FockSpinor) :
    rho v w (rho v' w' ψ) - rho v' w' (rho v w ψ)
      = rho (soAd v w v') w' ψ + rho v' (soAd v w w') ψ := by
  -- Unfold the inner `rho v' w' ψ = 2⁻¹ • (γ_{v'} (γ_{w'} ψ) - γ_{w'} (γ_{v'} ψ))`. Then by `rho_smul_spinor` and `rho_sub_spinor`:
  have h_rhs : rho v w (rho v' w' ψ) = (2⁻¹ : ℂ) • (rho v w (cliffordAction v' (cliffordAction w' ψ)) - rho v w (cliffordAction w' (cliffordAction v' ψ))) := by
    rw [ ← rho_sub_spinor, ← rho_smul_spinor ];
    rfl;
  -- Apply INT twice to each summand:
  have h1 : rho v w (cliffordAction v' (cliffordAction w' ψ)) = cliffordAction v' (rho v w (cliffordAction w' ψ)) + cliffordAction (soAd v w v') (cliffordAction w' ψ) := by
    have := rho_intertwine v w v' ( cliffordAction w' ψ );
    exact eq_add_of_sub_eq' this
  have h2 : rho v w (cliffordAction w' (cliffordAction v' ψ)) = cliffordAction w' (rho v w (cliffordAction v' ψ)) + cliffordAction (soAd v w w') (cliffordAction v' ψ) := by
    have := rho_intertwine v w w' ( cliffordAction v' ψ );
    exact eq_add_of_sub_eq' this;
  have h3 : rho v w (cliffordAction w' ψ) = cliffordAction w' (rho v w ψ) + cliffordAction (soAd v w w') ψ := by
    convert eq_add_of_sub_eq' ( rho_intertwine v w w' ψ ) using 1
  have h4 : rho v w (cliffordAction v' ψ) = cliffordAction v' (rho v w ψ) + cliffordAction (soAd v w v') ψ := by
    exact eq_add_of_sub_eq' ( rho_intertwine v w v' ψ );
  simp_all +decide [ rho ];
  simp +decide [ ← smul_add, ← smul_sub ] ; ring;
  rw [ cliffordAction_add_spinor, cliffordAction_add_spinor ] ; ring

/-
**Target 2 (Lie representation)**: the bivector bracket. Oracle:
`[so10] bracket`.
-/
theorem rho_bracket (v w v' w' : V10) (ψ : FockSpinor) :
    rho v w (rho v' w' ψ) - rho v' w' (rho v w ψ)
      = B10 w v' • rho v w' ψ - B10 v v' • rho w w' ψ
        - B10 w w' • rho v v' ψ + B10 v w' • rho w v' ψ := by
  convert rho_bracket_aux v w v' w' ψ using 1;
  rw [ show soAd v w v' = B10 w v' • v - B10 v v' • w by rfl, show soAd v w w' = B10 w w' • v - B10 v w' • w by rfl ];
  rw [ rho_sub_left, rho_sub_right ];
  rw [ rho_smul_left, rho_smul_left, rho_smul_right, rho_smul_right ];
  rw [ show rho v' v ψ = -rho v v' ψ by rw [ rho_antisymm ], show rho v' w ψ = -rho w v' ψ by rw [ rho_antisymm ] ] ; norm_num ; ring

/-
**Target 3 (pairing invariance)**: the Chevalley pairing is
infinitesimally `so(10)`-invariant. Oracle: `[so10] skew`.
-/
theorem chevalleyPairing_rho_skew (v w : V10) (ψ φ : FockSpinor) :
    chevalleyPairing (rho v w ψ) φ + chevalleyPairing ψ (rho v w φ) = 0 := by
  unfold rho;
  -- Apply the linearity of the Chevalley pairing in the first argument to split the subtraction into two terms.
  have h_split : chevalleyPairing (cliffordAction v (cliffordAction w ψ) - cliffordAction w (cliffordAction v ψ)) φ = chevalleyPairing (cliffordAction v (cliffordAction w ψ)) φ - chevalleyPairing (cliffordAction w (cliffordAction v ψ)) φ := by
    convert chevalleyPairing_add_left (cliffordAction v (cliffordAction w ψ)) (-cliffordAction w (cliffordAction v ψ)) φ using 1;
    unfold chevalleyPairing; simp +decide [ sub_eq_add_neg ] ;
  -- Apply the linearity of the Chevalley pairing in the second argument to split the subtraction into two terms.
  have h_split_second : chevalleyPairing ψ (cliffordAction v (cliffordAction w φ) - cliffordAction w (cliffordAction v φ)) = chevalleyPairing ψ (cliffordAction v (cliffordAction w φ)) - chevalleyPairing ψ (cliffordAction w (cliffordAction v φ)) := by
    unfold chevalleyPairing; simp +decide [ sub_eq_add_neg, add_assoc, add_left_comm, add_comm ] ;
    simp +decide [ mul_add, Finset.sum_add_distrib, Finset.sum_neg_distrib ];
  rw [ chevalleyPairing_smul_left, chevalleyPairing_smul_right, h_split, h_split_second ] ; ring;
  rw [ chevalleyPairing_cliffordAction_transpose, chevalleyPairing_cliffordAction_transpose ] ; ring

/-
**Target 4 (gamma-bilinear equivariance)**: `q` intertwines the spinor
and vector actions. Oracle: `[so10] equivariance`.
-/
theorem gammaBilinear_rho_equivariant (v w : V10) (ψ φ : FockSpinor) :
    gammaBilinear (rho v w ψ) φ + gammaBilinear ψ (rho v w φ)
      = soAd v w (gammaBilinear ψ φ) := by
  apply B10_ext;
  -- By the properties of the bilinear form and the definition of `soAd`, we can expand and simplify the left-hand side.
  intro u
  simp [B10_add_left, B10_gammaBilinear, B10_soAd_skew];
  rw [ show B10 ( soAd v w ( gammaBilinear ψ φ ) ) u = - B10 ( gammaBilinear ψ φ ) ( soAd v w u ) from ?_ ];
  · have h_expand : chevalleyPairing (cliffordAction u (rho v w ψ)) φ + chevalleyPairing (cliffordAction u ψ) (rho v w φ) = chevalleyPairing (rho v w (cliffordAction u ψ)) φ - chevalleyPairing (cliffordAction (soAd v w u) ψ) φ + chevalleyPairing (cliffordAction u ψ) (rho v w φ) := by
      have h_expand : cliffordAction u (rho v w ψ) = rho v w (cliffordAction u ψ) - cliffordAction (soAd v w u) ψ := by
        grind +suggestions;
      rw [h_expand];
      unfold chevalleyPairing; simp +decide [ sub_eq_add_neg, add_assoc ] ;
      simp +decide [ mul_add, add_mul, Finset.sum_add_distrib, Finset.sum_neg_distrib, neg_mul, mul_neg ] ; ring;
    have h_expand : chevalleyPairing (rho v w (cliffordAction u ψ)) φ + chevalleyPairing (cliffordAction u ψ) (rho v w φ) = 0 := by
      apply chevalleyPairing_rho_skew;
    rw [ B10_gammaBilinear ];
    grind;
  · exact eq_neg_of_add_eq_zero_left ( B10_soAd_skew v w ( gammaBilinear ψ φ ) u )

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
