import Mathlib

/-!
# Gate YM1: fusion by convolution, abstract iteration core

This draft module starts the finite-group part of PKG-YM1-C from the overnight
YM run, following the convention correction in
`AgentTasks/overnight-ym-run-2026-07-03/PREP_NOTES.md` section 1 and the
statement freeze
`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md` section 4.

The oracle v0.2 Z3 complex-character fixture made the argument order
load-bearing: the general fusion lemma must be stated in convolution form

```text
sum_h w(h) chi(h^{-1} A) = c * chi(A),
```

not in the naive `chi(A h)` order unless the weight is inversion-symmetric.
This file proves the part of theorem 2 that does not need character theory:
once a function `chi` is an eigenfunction of this convolution operator, applying
the independent plaquette convolution `n` times multiplies it by `c^n`.

The finite-group character fusion lemma has now been supplied by Aristotle
project `3435c7a3` and integrated here as
`lemma2a_fusion_convolution`. It uses Schur's lemma directly rather than a
character-basis expansion theorem: the class-function average
`sum_h w(h) • rho(h^{-1})` is an intertwiner, hence scalar on a simple complex
representation; tracing it and its product with `rho(A)` gives the convolution
identity.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity** (finite-group character fusion, its
division-free iteration, and the abstract convolution iteration core for the 2D
exact solution).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace FusionConvolution

open BigOperators CategoryTheory

variable {G : Type} [Group G] [Fintype G]

/-- The convolution operator in the oracle-pinned argument order:
`(T_w chi)(A) = sum_h w(h) chi(h^{-1} A)`. -/
def convLeft (w chi : G → ℂ) (A : G) : ℂ :=
  ∑ h : G, w h * chi (h⁻¹ * A)

/-- A complex-valued class function on a group. The argument order matches
Mathlib's `FDRep.char_conj` convention: invariance under
`a * g * a^{-1}`. -/
def IsClassFunction (w : G → ℂ) : Prop :=
  ∀ a g : G, w (a * g * a⁻¹) = w g

/-- Conjugation reindexing for a class function: since `w (g h g^{-1}) = w h`,
`sum_h w h • rho(h^{-1} g) = sum_h w h • rho(g h^{-1})`. -/
lemma sum_conj_reindex (R : FDRep ℂ G)
    (w : G → ℂ) (hw : IsClassFunction w) (g : G) :
    (∑ h : G, w h • R.ρ (h⁻¹ * g)) = ∑ h : G, w h • R.ρ (g * h⁻¹) := by
  rw [← Equiv.sum_comp ((Equiv.mulRight g⁻¹).trans (Equiv.mulLeft g))
    (fun h => w h • R.ρ (h⁻¹ * g))]
  refine Finset.sum_congr rfl ?_
  intro h _
  simp only [Equiv.coe_trans, Equiv.coe_mulRight, Equiv.coe_mulLeft, Function.comp_apply]
  have hassoc : g * (h * g⁻¹) = g * h * g⁻¹ := by
    group
  rw [hassoc, hw g h]
  congr 2
  group

/-- The averaged endomorphism `T = sum_h w h • rho(h^{-1})` commutes with
`rho(g)` for every `g`, when `w` is a class function. -/
lemma intertwiner_comm (R : FDRep ℂ G)
    (w : G → ℂ) (hw : IsClassFunction w) (g : G) :
    (∑ h : G, w h • R.ρ h⁻¹) ∘ₗ R.ρ g =
      R.ρ g ∘ₗ (∑ h : G, w h • R.ρ h⁻¹) := by
  have hL : (∑ h : G, w h • R.ρ h⁻¹) ∘ₗ R.ρ g =
      ∑ h : G, w h • R.ρ (h⁻¹ * g) := by
    change (∑ h : G, w h • R.ρ h⁻¹) * R.ρ g = _
    rw [Finset.sum_mul]
    refine Finset.sum_congr rfl ?_
    intro h _
    rw [smul_mul_assoc, ← map_mul]
  have hR : R.ρ g ∘ₗ (∑ h : G, w h • R.ρ h⁻¹) =
      ∑ h : G, w h • R.ρ (g * h⁻¹) := by
    change R.ρ g * (∑ h : G, w h • R.ρ h⁻¹) = _
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl ?_
    intro h _
    rw [mul_smul_comm, ← map_mul]
  rw [hL, hR, sum_conj_reindex R w hw g]

/-- Schur's lemma in endomorphism form: a linear endomorphism of a simple
complex representation that commutes with the whole group action is scalar. -/
lemma schur_scalar {H : Type} [Group H] (R : FDRep ℂ H) [Simple R]
    (T : R →ₗ[ℂ] R) (hT : ∀ g : H, T ∘ₗ R.ρ g = R.ρ g ∘ₗ T) :
    ∃ c : ℂ, T = c • LinearMap.id := by
  set W := (Representation.linHom R.ρ R.ρ).invariants with hW
  have hgg : ∀ g : H, R.ρ g ∘ₗ R.ρ g⁻¹ = (LinearMap.id : R →ₗ[ℂ] R) := by
    intro g
    have h1 : R.ρ g ∘ₗ R.ρ g⁻¹ = R.ρ (g * g⁻¹) := by
      rw [map_mul]
      rfl
    rw [h1, mul_inv_cancel, map_one]
    ext x
    simp
  have hfin : Module.finrank ℂ W = 1 := by
    rw [LinearEquiv.finrank_eq (Representation.linHom.invariantsEquivFDRepHom R R),
      FDRep.finrank_hom_simple_simple R R]
    simp
  have hTmem : T ∈ W := by
    rw [hW, Representation.mem_invariants]
    intro g
    rw [Representation.linHom_apply, ← LinearMap.comp_assoc, ← hT g,
      LinearMap.comp_assoc, hgg g, LinearMap.comp_id]
  have hidmem : (LinearMap.id : R →ₗ[ℂ] R) ∈ W := by
    rw [hW, Representation.mem_invariants]
    intro g
    rw [Representation.linHom_apply, LinearMap.id_comp, hgg g]
  have hNT : Nontrivial R := by
    by_contra h
    rw [not_nontrivial_iff_subsingleton] at h
    have hss : Subsingleton W := by
      constructor
      intro a b
      ext x
      exact Subsingleton.elim _ _
    have : Module.finrank ℂ W = 0 := Module.finrank_zero_of_subsingleton
    omega
  have hid_ne : (⟨LinearMap.id, hidmem⟩ : W) ≠ 0 := by
    intro h
    rw [Subtype.ext_iff] at h
    simp only [Submodule.coe_zero] at h
    obtain ⟨x, hx⟩ := exists_ne (0 : R)
    apply hx
    have := LinearMap.congr_fun h x
    simpa using this
  obtain ⟨c, hc⟩ :=
    (finrank_eq_one_iff_of_nonzero' (⟨LinearMap.id, hidmem⟩ : W) hid_ne).mp
      hfin ⟨T, hTmem⟩
  refine ⟨c, ?_⟩
  have hval := congrArg (Subtype.val) hc
  simp only [SetLike.val_smul] at hval
  rw [← hval]

/-- Trace of the averaged endomorphism:
`trace T = sum_h w h * chi_R(h^{-1})`. -/
lemma trace_avg (R : FDRep ℂ G) (w : G → ℂ) :
    LinearMap.trace ℂ R (∑ h : G, w h • R.ρ h⁻¹) =
      ∑ h : G, w h * R.character h⁻¹ := by
  rw [map_sum]
  refine Finset.sum_congr rfl ?_
  intro h _
  rw [map_smul, smul_eq_mul]
  rfl

/-- Trace of the averaged endomorphism composed with `rho(A)`:
`trace (T . rho(A)) = sum_h w h * chi_R(h^{-1} A)`. -/
lemma trace_avg_comp (R : FDRep ℂ G) (w : G → ℂ) (A : G) :
    LinearMap.trace ℂ R ((∑ h : G, w h • R.ρ h⁻¹) ∘ₗ R.ρ A) =
      ∑ h : G, w h * R.character (h⁻¹ * A) := by
  have hcomp : (∑ h : G, w h • R.ρ h⁻¹) ∘ₗ R.ρ A =
      ∑ h : G, w h • R.ρ (h⁻¹ * A) := by
    change (∑ h : G, w h • R.ρ h⁻¹) * R.ρ A = _
    rw [Finset.sum_mul]
    refine Finset.sum_congr rfl ?_
    intro h _
    rw [smul_mul_assoc, ← map_mul]
  rw [hcomp, map_sum]
  refine Finset.sum_congr rfl ?_
  intro h _
  rw [map_smul, smul_eq_mul]
  rfl

/-- Lemma 2a from the freeze document, in corrected cross-multiplied form.

For a class function `w` and a simple complex finite-dimensional
representation `R`, the oracle-pinned convolution
`sum_h w(h) chi_R(h^{-1} A)` acts on `chi_R` by the scalar determined by the
unnormalized Fourier coefficient `sum_g w(g) chi_R(g^{-1})`, with no extra
factor of `|G|`.

Proven by Aristotle project `3435c7a3`: the proof uses Schur's lemma on the
class-function average `sum_h w(h) • R.rho(h^{-1})`, then compares traces. -/
theorem lemma2a_fusion_convolution
    (R : FDRep ℂ G) [Simple R] (w : G → ℂ) (hw : IsClassFunction w) (A : G) :
    R.character 1 * (∑ h : G, w h * R.character (h⁻¹ * A)) =
      (∑ g : G, w g * R.character g⁻¹) * R.character A := by
  obtain ⟨c, hc⟩ :=
    schur_scalar R (∑ h : G, w h • R.ρ h⁻¹) (intertwiner_comm R w hw)
  have e1 : (∑ g : G, w g * R.character g⁻¹) = c * R.character 1 := by
    rw [← trace_avg R w, hc, map_smul, LinearMap.trace_id, smul_eq_mul,
      FDRep.char_one]
  have e2 : (∑ h : G, w h * R.character (h⁻¹ * A)) = c * R.character A := by
    rw [← trace_avg_comp R w A, hc, LinearMap.smul_comp, LinearMap.id_comp,
      map_smul, smul_eq_mul]
    rfl
  rw [e1, e2]
  ring

/-- Repeated independent plaquette convolution. The base case is the input
function `chi`; the successor step applies the same left-convolution operator
one more time. -/
def iterConv (w chi : G → ℂ) : ℕ → G → ℂ
  | 0, A => chi A
  | n + 1, A => ∑ h : G, w h * iterConv w chi n (h⁻¹ * A)

/-- Division-free iteration of Lemma 2a.

Let `d = chi_R(1)` and `s = sum_g w(g) chi_R(g^{-1})`.  Lemma 2a says
`d * (T_w chi_R)(A) = s * chi_R(A)`.  Iterating this identity gives
`d^n * T_w^n chi_R(A) = s^n * chi_R(A)`.

This is the finite-group character-fusion part of Theorem 2 before choosing a
normalization convention that divides by `d` and by the scalar attached to the
trivial representation. -/
theorem iterConv_character_fusion_cross
    (R : FDRep ℂ G) [Simple R] (w : G → ℂ) (hw : IsClassFunction w) :
    ∀ (n : ℕ) (A : G),
      R.character 1 ^ n * iterConv w R.character n A =
        (∑ g : G, w g * R.character g⁻¹) ^ n * R.character A := by
  intro n
  induction n with
  | zero =>
      intro A
      simp [iterConv]
  | succ n ih =>
      intro A
      rw [iterConv]
      calc
        R.character 1 ^ (n + 1) *
            (∑ h : G, w h * iterConv w R.character n (h⁻¹ * A))
            =
          R.character 1 *
            (∑ h : G, w h *
              (R.character 1 ^ n * iterConv w R.character n (h⁻¹ * A))) := by
                rw [Finset.mul_sum, Finset.mul_sum]
                refine Finset.sum_congr rfl ?_
                intro h _hh
                rw [pow_succ]
                ring
        _ =
          R.character 1 *
            (∑ h : G, w h *
              ((∑ g : G, w g * R.character g⁻¹) ^ n * R.character (h⁻¹ * A))) := by
                congr 1
                refine Finset.sum_congr rfl ?_
                intro h _hh
                rw [ih (h⁻¹ * A)]
        _ =
          (∑ g : G, w g * R.character g⁻¹) ^ n *
            (R.character 1 *
              (∑ h : G, w h * R.character (h⁻¹ * A))) := by
                rw [Finset.mul_sum, Finset.mul_sum, Finset.mul_sum]
                refine Finset.sum_congr rfl ?_
                intro h _hh
                ring
        _ =
          (∑ g : G, w g * R.character g⁻¹) ^ n *
            ((∑ g : G, w g * R.character g⁻¹) * R.character A) := by
                rw [lemma2a_fusion_convolution R w hw A]
        _ = (∑ g : G, w g * R.character g⁻¹) ^ (n + 1) * R.character A := by
                rw [pow_succ]
                ring

/-- If `chi` is an eigenfunction of the convolution operator with eigenvalue
`c`, then `n` independent plaquette convolutions multiply `chi` by `c^n`.

This is the formal induction behind the finite-group 2D exact solution after
the one-step fusion lemma has been supplied by character orthogonality. -/
theorem iterConv_eigen (w chi : G → ℂ) (c : ℂ)
    (heig : ∀ A : G, convLeft w chi A = c * chi A) :
    ∀ (n : ℕ) (A : G), iterConv w chi n A = c ^ n * chi A := by
  intro n
  induction n with
  | zero =>
      intro A
      simp [iterConv]
  | succ n ih =>
      intro A
      rw [iterConv]
      calc
        ∑ h : G, w h * iterConv w chi n (h⁻¹ * A)
            = ∑ h : G, w h * (c ^ n * chi (h⁻¹ * A)) := by
                refine Finset.sum_congr rfl ?_
                intro h _hh
                rw [ih]
        _ = c ^ n * ∑ h : G, w h * chi (h⁻¹ * A) := by
                rw [Finset.mul_sum]
                refine Finset.sum_congr rfl ?_
                intro h _hh
                ring
        _ = c ^ n * convLeft w chi A := by
                simp [convLeft]
        _ = c ^ n * (c * chi A) := by
                rw [heig A]
        _ = c ^ (n + 1) * chi A := by
                ring

/-- Identity-evaluation form of `iterConv_eigen`. If `chi(1) = d` and the
one-step convolution eigenvalue is `gamma`, then `n` independent plaquette
convolutions give exactly `d * gamma^n` at the identity.

This is the algebraic shape of the open-rectangle 2D exact solution after the
character-theoretic fusion lemma supplies
`gamma = w_hat_R / (d_R * w_hat_0)` and `d = d_R`. -/
theorem iterConv_eigen_at_one (w chi : G → ℂ) (gamma d : ℂ)
    (hchi_one : chi 1 = d)
    (heig : ∀ A : G, convLeft w chi A = gamma * chi A)
    (n : ℕ) :
    iterConv w chi n 1 = d * gamma ^ n := by
  rw [iterConv_eigen w chi gamma heig n 1, hchi_one]
  ring

end FusionConvolution
end GateYM
end NullEdge
end Draft
end PhysicsSM
