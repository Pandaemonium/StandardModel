import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldFock

/-!
# Spinor.SpinorTenfoldPurity

The Chevalley pairing, the gamma-bilinear `q`, and the pure-spinor quadric for
the concrete `Spin(10)` Fock model of `PhysicsSM.Spinor.SpinorTenfoldFock`.

## Mathematical context

Cartan's pure-spinor condition in ten dimensions is the vanishing of the
vector-valued bilinear `q(ψ, ψ)`, where `q : S⁺ × S⁺ → V` is the symmetric
gamma-bilinear `q(ψ)^a = ψ Γ^a ψ`. The projective variety it cuts out in
`ℙ(S⁺) = ℙ¹⁵` is the spinor tenfold `𝕊₁₀ ≅ OGr⁺(5, 10)`, whose points
correspond to maximal isotropic subspaces of `ℂ¹⁰`.

Krasnov's characterization of the Standard Model gauge group uses a pair of
pure spinors `(ψ₁, ψ₂)` with `q(ψ₁, ψ₂) = 0`; this module proves (in the
concrete model) the equivalence chain of "Proposition 2" of the research notes:

  `q(ψ₁, ψ₂) + q(ψ₂, ψ₁) = 0`
    ↔ `ψ₁ + ψ₂` satisfies the purity quadric
    ↔ every point `s ψ₁ + t ψ₂` of the projective line satisfies the quadric,

i.e. *Krasnov's condition is exactly the condition that the line through the
two spinors lies on the spinor tenfold*. (The symmetrized form is used here;
the symmetry `q(ψ₁, ψ₂) = q(ψ₂, ψ₁)` is proved in
`PhysicsSM.Spinor.SpinorTenfoldGammaSymm`, which upgrades the condition to the
single equation `q(ψ₁, ψ₂) = 0`.)

It also exhibits the concrete normal-form witness pair
`ψ₁ = 1` (Fock vacuum) and `ψ₂ = e₃ ∧ e₄`, which is a genuine `d = 3`
(Standard-Model stratum) Krasnov pair: both are pure, mutually orthogonal
under `q`, and their sum is pure. The intersection of their annihilator
subspaces is the color `ℂ³` (the "axis of the pencil"); see the draft module
`PhysicsSM.Draft.SpinorTenfoldColorAxisAristotle` for the dimension count.

## Conventions

- The Chevalley pairing on `Λ•(ℂ⁵)` is
  `β(ψ, φ) = Σ_S (-1)^{|S|(|S|-1)/2} ε(S) ψ(S) φ(Sᶜ)`,
  where `ε(S)` is the shuffle sign of `(S, Sᶜ)` and the **alpha twist**
  `(-1)^{|S|(|S|-1)/2}` comes from the main anti-automorphism of the exterior
  algebra. The twist is load-bearing: the oracle
  `Scripts/oracle/validate_spinor_tenfold.py` confirms that with it `q` is
  symmetric on even spinors and the ten-dimensional Fierz identity holds,
  and that both fail without it.
- `q(ψ, φ) ∈ V10` is defined componentwise by the adjunction
  `B10 (q ψ φ) v = β(v · ψ, φ)`, proved below as `B10_gammaBilinear`.
- Purity: `ψ ≠ 0`, even, and `q(ψ, ψ) = 0`.

## Main declarations

- `chevalleyPairing` : the Chevalley bilinear form `β`.
- `gammaBilinear` : the vector-valued bilinear `q`.
- `B10_gammaBilinear` : the defining adjunction.
- `Q10_gammaBilinear_eq_zero_of_clifford` : `q(ψ)·ψ = 0 → Q(q(ψ)) = 0`
  (the contraction step of Lemma 1(b) of the research notes).
- `IsPureSpinor`, `gammaBilinear_polarization`, `sum_quadric_iff`,
  `line_quadric` : the purity quadric and the Proposition 2 chain.
- `vacuumSpinor`, `weakSpinor`, `krasnov_pair` : the concrete `d = 3` witness.
- `annihilator`, `mem_annihilator_vacuumSpinor_iff` : annihilator subspaces.

## Claim boundary

This module does NOT construct the group `Spin(10)`, classify orbits of
pure-spinor pairs, or compute stabilizers. The orbit trichotomy
(`d ∈ {5, 3, 1}`) and the `S(U(2) × U(3))` Selector Theorem of the research
notes remain future work; this module provides the kernel-checked quadric-level
layer those results sit on.

## Sources

- C. Chevalley, "The Algebraic Theory of Spinors and Clifford Algebras".
- Krasnov, "Geometry of Spin(10) Symmetry Breaking", arXiv:2209.05088.
- Krasnov, "Octonions, complex structures and Standard Model fermions",
  arXiv:2504.16465.
- Kuznetsov, "On linear sections of the spinor tenfold I" (lines on `𝕊₁₀`).
- Internal research notes: `Sources/Spin10_stabilizer.txt`.
- Provenance: clean-room formalization; conventions validated by
  `Scripts/oracle/validate_spinor_tenfold.py`.

Status: trusted — no `sorry`.
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinorTenfold

open Finset

/-! ## The Chevalley pairing -/

/-- The number of inversions of the shuffle permutation `(S, Sᶜ)` of
`(0, …, 4)`: pairs `(s, t)` with `s ∈ S`, `t ∉ S`, `t < s`. -/
def shuffleInversions (S : Finset (Fin 5)) : ℕ :=
  ∑ s ∈ S, ((Sᶜ : Finset (Fin 5)).filter (fun t => t < s)).card

/-- The total sign of the `S`-term of the Chevalley pairing: the alpha twist
`(-1)^{|S|(|S|-1)/2}` (from the main anti-automorphism on degree `|S|`)
times the shuffle sign `(-1)^{shuffleInversions S}`.

The alpha twist is essential: see the module docstring and the oracle script. -/
def chevalleySign (S : Finset (Fin 5)) : ℂ :=
  (-1 : ℂ) ^ (S.card * (S.card - 1) / 2 + shuffleInversions S)

/-- The Chevalley pairing `β(ψ, φ) = Σ_S chevalleySign S * ψ(S) * φ(Sᶜ)` on
the full 32-dimensional spinor space. It pairs even spinors with odd spinors
(the `S`-term needs `|S| + |Sᶜ| = 5`), which is why the vector-valued
`gammaBilinear` below is the natural bilinear on the *even* (Weyl) part. -/
def chevalleyPairing (ψ φ : FockSpinor) : ℂ :=
  ∑ S : Finset (Fin 5), chevalleySign S * ψ S * φ Sᶜ

@[simp] theorem chevalleyPairing_zero_left (φ : FockSpinor) :
    chevalleyPairing 0 φ = 0 := by
  simp [chevalleyPairing]

@[simp] theorem chevalleyPairing_zero_right (ψ : FockSpinor) :
    chevalleyPairing ψ 0 = 0 := by
  simp [chevalleyPairing]

theorem chevalleyPairing_add_left (ψ₁ ψ₂ φ : FockSpinor) :
    chevalleyPairing (ψ₁ + ψ₂) φ
      = chevalleyPairing ψ₁ φ + chevalleyPairing ψ₂ φ := by
  unfold chevalleyPairing
  rw [← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl fun S _ => by simp [Pi.add_apply]; ring

theorem chevalleyPairing_add_right (ψ φ₁ φ₂ : FockSpinor) :
    chevalleyPairing ψ (φ₁ + φ₂)
      = chevalleyPairing ψ φ₁ + chevalleyPairing ψ φ₂ := by
  unfold chevalleyPairing
  rw [← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl fun S _ => by simp [Pi.add_apply]; ring

theorem chevalleyPairing_smul_left (c : ℂ) (ψ φ : FockSpinor) :
    chevalleyPairing (c • ψ) φ = c * chevalleyPairing ψ φ := by
  unfold chevalleyPairing
  rw [Finset.mul_sum]
  exact Finset.sum_congr rfl fun S _ => by simp [Pi.smul_apply]; ring

theorem chevalleyPairing_smul_right (c : ℂ) (ψ φ : FockSpinor) :
    chevalleyPairing ψ (c • φ) = c * chevalleyPairing ψ φ := by
  unfold chevalleyPairing
  rw [Finset.mul_sum]
  exact Finset.sum_congr rfl fun S _ => by simp [Pi.smul_apply]; ring

/-- The Chevalley pairing distributes over finite sums in the first slot. -/
theorem chevalleyPairing_sum_left {ι : Type*} (s : Finset ι)
    (f : ι → FockSpinor) (φ : FockSpinor) :
    chevalleyPairing (∑ i ∈ s, f i) φ = ∑ i ∈ s, chevalleyPairing (f i) φ := by
  unfold chevalleyPairing
  simp only [Finset.sum_apply, Finset.mul_sum, Finset.sum_mul]
  exact Finset.sum_comm

/-- The Chevalley pairing against a wedge monomial in the first slot picks out
the complementary coefficient of the second argument. -/
theorem chevalleyPairing_basisSpinor_left (T : Finset (Fin 5)) (φ : FockSpinor) :
    chevalleyPairing (basisSpinor T) φ = chevalleySign T * φ Tᶜ := by
  unfold chevalleyPairing basisSpinor
  rw [Finset.sum_eq_single T]
  · rw [if_pos rfl, mul_one]
  · intro S _ hS
    rw [if_neg hS, mul_zero, zero_mul]
  · intro h
    exact absurd (Finset.mem_univ T) h

/-- The Chevalley pairing of two wedge monomials: nonzero exactly on
complementary subsets. -/
theorem chevalleyPairing_basis_basis (T U : Finset (Fin 5)) :
    chevalleyPairing (basisSpinor T) (basisSpinor U)
      = if (Tᶜ : Finset (Fin 5)) = U then chevalleySign T else 0 := by
  rw [chevalleyPairing_basisSpinor_left]
  unfold basisSpinor
  by_cases h : (Tᶜ : Finset (Fin 5)) = U
  · rw [if_pos h, if_pos h, mul_one]
  · rw [if_neg h, if_neg h, mul_zero]

/-! ## The gamma-bilinear `q : S × S → V10` -/

/-- The vector-valued gamma-bilinear `q(ψ, φ) ∈ V10`, defined componentwise so
that the adjunction `B10 (q ψ φ) v = β(v · ψ, φ)` holds (see
`B10_gammaBilinear`). On even (Weyl) spinors this is the classical symmetric
bilinear `ψ Γ^a φ` of ten-dimensional physics; Cartan's purity condition is
`gammaBilinear ψ ψ = 0`. -/
def gammaBilinear (ψ φ : FockSpinor) : V10 :=
  (fun j => chevalleyPairing (contract j ψ) φ,
   fun j => chevalleyPairing (wedge j ψ) φ)

@[simp] theorem gammaBilinear_zero_left (φ : FockSpinor) :
    gammaBilinear 0 φ = 0 := by
  unfold gammaBilinear
  rw [Prod.mk_eq_zero]
  constructor <;> funext j <;> simp

@[simp] theorem gammaBilinear_zero_right (ψ : FockSpinor) :
    gammaBilinear ψ 0 = 0 := by
  unfold gammaBilinear
  rw [Prod.mk_eq_zero]
  constructor <;> funext j <;> simp

theorem gammaBilinear_add_left (ψ₁ ψ₂ φ : FockSpinor) :
    gammaBilinear (ψ₁ + ψ₂) φ = gammaBilinear ψ₁ φ + gammaBilinear ψ₂ φ := by
  simp only [gammaBilinear, Prod.mk_add_mk, Prod.mk.injEq]
  constructor
  · funext j
    rw [Pi.add_apply, contract_add, chevalleyPairing_add_left]
  · funext j
    rw [Pi.add_apply, wedge_add, chevalleyPairing_add_left]

theorem gammaBilinear_add_right (ψ φ₁ φ₂ : FockSpinor) :
    gammaBilinear ψ (φ₁ + φ₂) = gammaBilinear ψ φ₁ + gammaBilinear ψ φ₂ := by
  simp only [gammaBilinear, Prod.mk_add_mk, Prod.mk.injEq]
  constructor
  · funext j
    rw [Pi.add_apply, chevalleyPairing_add_right]
  · funext j
    rw [Pi.add_apply, chevalleyPairing_add_right]

theorem gammaBilinear_smul_left (c : ℂ) (ψ φ : FockSpinor) :
    gammaBilinear (c • ψ) φ = c • gammaBilinear ψ φ := by
  simp only [gammaBilinear, Prod.smul_mk, Prod.mk.injEq]
  constructor
  · funext j
    rw [Pi.smul_apply, smul_eq_mul, contract_smul, chevalleyPairing_smul_left]
  · funext j
    rw [Pi.smul_apply, smul_eq_mul, wedge_smul, chevalleyPairing_smul_left]

theorem gammaBilinear_smul_right (c : ℂ) (ψ φ : FockSpinor) :
    gammaBilinear ψ (c • φ) = c • gammaBilinear ψ φ := by
  simp only [gammaBilinear, Prod.smul_mk, Prod.mk.injEq]
  constructor
  · funext j
    rw [Pi.smul_apply, smul_eq_mul, chevalleyPairing_smul_right]
  · funext j
    rw [Pi.smul_apply, smul_eq_mul, chevalleyPairing_smul_right]

/-- **The defining adjunction**: `B10 (q ψ φ) v = β(v · ψ, φ)`. This is the
coordinate-free characterization of the gamma-bilinear; everything that uses
"contract `q(ψ, ψ)` back against `ψ`" (e.g. killing `Q(q(ψ))` in Lemma 1(b)
of the research notes) factors through this identity. -/
theorem B10_gammaBilinear (ψ φ : FockSpinor) (v : V10) :
    B10 (gammaBilinear ψ φ) v = chevalleyPairing (cliffordAction v ψ) φ := by
  rw [cliffordAction_eq_sum, chevalleyPairing_add_left, chevalleyPairing_sum_left,
    chevalleyPairing_sum_left]
  simp only [chevalleyPairing_smul_left]
  unfold B10 gammaBilinear
  rw [Finset.sum_add_distrib, add_comm]
  congr 1
  · exact Finset.sum_congr rfl fun i _ => by ring
  · exact Finset.sum_congr rfl fun i _ => by ring

/-- The contraction step of Lemma 1(b): if the Fierz identity
`q(ψ, ψ) · ψ = 0` holds for `ψ`, then `Q(q(ψ, ψ)) = 0` as well. Geometrically:
once the spinor component of `(1, ψ, q(ψ))^#` vanishes, its scalar component
vanishes for free. The Fierz identity itself is proved in
`PhysicsSM.Spinor.SpinorTenfoldFierz` (`fierz_clifford`). -/
theorem Q10_gammaBilinear_eq_zero_of_clifford {ψ : FockSpinor}
    (h : cliffordAction (gammaBilinear ψ ψ) ψ = 0) :
    Q10 (gammaBilinear ψ ψ) = 0 := by
  have h2 := B10_gammaBilinear ψ ψ (gammaBilinear ψ ψ)
  rw [h, chevalleyPairing_zero_left, B10_self] at h2
  rcases mul_eq_zero.mp h2 with h' | h'
  · exact absurd h' two_ne_zero
  · exact h'

/-! ## The pure-spinor quadric -/

/-- A *pure spinor*: a nonzero even (positive-chirality) spinor satisfying
Cartan's quadric `q(ψ, ψ) = 0`. In ten dimensions these are exactly the
spinors whose annihilator `{v : v · ψ = 0}` is a maximal (5-dimensional)
isotropic subspace of `ℂ¹⁰`; the projectivized solutions form the spinor
tenfold `𝕊₁₀`.

This supersedes the placeholder predicate in
`PhysicsSM.Spinor.PureSpinor10` (where the Cartan equations were recorded as
`True`): here the quadric is the honest gamma-bilinear of the Fock model. -/
structure IsPureSpinor (ψ : FockSpinor) : Prop where
  /-- A pure spinor is nonzero. -/
  ne_zero : ψ ≠ 0
  /-- A pure spinor has definite (positive) chirality. -/
  even : IsEvenSpinor ψ
  /-- Cartan's purity quadric: the gamma-bilinear square vanishes. -/
  quadric : gammaBilinear ψ ψ = 0

/-- Purity is projective: stable under nonzero rescaling. -/
theorem IsPureSpinor.smul {ψ : FockSpinor} (h : IsPureSpinor ψ)
    {c : ℂ} (hc : c ≠ 0) : IsPureSpinor (c • ψ) where
  ne_zero := by
    intro h0
    rcases smul_eq_zero.mp h0 with h' | h'
    · exact hc h'
    · exact h.ne_zero h'
  even := h.even.smul c
  quadric := by
    rw [gammaBilinear_smul_left, gammaBilinear_smul_right, h.quadric,
      smul_zero, smul_zero]

/-- Polarization of the purity quadric. -/
theorem gammaBilinear_polarization (ψ φ : FockSpinor) :
    gammaBilinear (ψ + φ) (ψ + φ)
      = gammaBilinear ψ ψ + (gammaBilinear ψ φ + gammaBilinear φ ψ)
        + gammaBilinear φ φ := by
  rw [gammaBilinear_add_left, gammaBilinear_add_right, gammaBilinear_add_right]
  abel

/-- **Proposition 2, symmetrized form**: for two spinors satisfying the purity
quadric, the sum satisfies the quadric iff the symmetrized gamma-bilinear
vanishes. This is Krasnov's "orthogonal pure spinors with pure sum" condition.
(With the symmetry of `q` on even spinors — an Aristotle draft target — the
condition becomes simply `q(ψ₁, ψ₂) = 0`.) -/
theorem sum_quadric_iff {ψ₁ ψ₂ : FockSpinor}
    (h₁ : gammaBilinear ψ₁ ψ₁ = 0) (h₂ : gammaBilinear ψ₂ ψ₂ = 0) :
    gammaBilinear (ψ₁ + ψ₂) (ψ₁ + ψ₂) = 0
      ↔ gammaBilinear ψ₁ ψ₂ + gammaBilinear ψ₂ ψ₁ = 0 := by
  rw [gammaBilinear_polarization, h₁, h₂, zero_add, add_zero]

/-- **Proposition 2, line form**: if two spinors satisfy the purity quadric and
the symmetrized gamma-bilinear vanishes, then *every* point `s ψ₁ + t ψ₂` of
the line through them satisfies the quadric — the line lies on the spinor
tenfold. This is the quadric-level content of "Krasnov's condition is
collinearity". -/
theorem line_quadric {ψ₁ ψ₂ : FockSpinor}
    (h₁ : gammaBilinear ψ₁ ψ₁ = 0) (h₂ : gammaBilinear ψ₂ ψ₂ = 0)
    (h₁₂ : gammaBilinear ψ₁ ψ₂ + gammaBilinear ψ₂ ψ₁ = 0) (s t : ℂ) :
    gammaBilinear (s • ψ₁ + t • ψ₂) (s • ψ₁ + t • ψ₂) = 0 := by
  rw [gammaBilinear_polarization]
  simp only [gammaBilinear_smul_left, gammaBilinear_smul_right, h₁, h₂, smul_zero]
  rw [zero_add, add_zero, smul_smul, smul_smul, mul_comm t s, ← smul_add,
    h₁₂, smul_zero]

/-- Conversely, if the whole line satisfies the quadric then the symmetrized
gamma-bilinear vanishes (specialize to `s = t = 1` and polarize). -/
theorem symmetrized_eq_zero_of_line {ψ₁ ψ₂ : FockSpinor}
    (h₁ : gammaBilinear ψ₁ ψ₁ = 0) (h₂ : gammaBilinear ψ₂ ψ₂ = 0)
    (hline : ∀ s t : ℂ,
      gammaBilinear (s • ψ₁ + t • ψ₂) (s • ψ₁ + t • ψ₂) = 0) :
    gammaBilinear ψ₁ ψ₂ + gammaBilinear ψ₂ ψ₁ = 0 := by
  have h := hline 1 1
  rw [one_smul, one_smul] at h
  exact (sum_quadric_iff h₁ h₂).mp h

/-! ## Vanishing of `q` on wedge-monomial pairs -/

/-- Vanishing criterion for the gamma-bilinear of two wedge monomials: all ten
components vanish provided the relevant complements never match. The
hypotheses are decidable, so concrete instances follow by `decide`. -/
theorem gammaBilinear_basis_basis_eq_zero (T U : Finset (Fin 5))
    (ha : ∀ j ∈ T, ((T.erase j)ᶜ : Finset (Fin 5)) ≠ U)
    (hb : ∀ j : Fin 5, j ∉ T → ((insert j T)ᶜ : Finset (Fin 5)) ≠ U) :
    gammaBilinear (basisSpinor T) (basisSpinor U) = 0 := by
  unfold gammaBilinear
  rw [Prod.mk_eq_zero]
  constructor
  · funext j
    simp only [Pi.zero_apply]
    by_cases hj : j ∈ T
    · rw [contract_basisSpinor_of_mem j T hj, chevalleyPairing_smul_left,
        chevalleyPairing_basis_basis, if_neg (ha j hj), mul_zero]
    · rw [contract_basisSpinor_of_not_mem j T hj, chevalleyPairing_zero_left]
  · funext j
    simp only [Pi.zero_apply]
    by_cases hj : j ∈ T
    · rw [wedge_basisSpinor_of_mem j T hj, chevalleyPairing_zero_left]
    · rw [wedge_basisSpinor_of_not_mem j T hj, chevalleyPairing_smul_left,
        chevalleyPairing_basis_basis, if_neg (hb j hj), mul_zero]

/-! ## The concrete `d = 3` Krasnov pair

The normal form of the research notes: `N₁ = ⟨f₀,…,f₄⟩` (the annihilator of
the Fock vacuum) and `N₂ = ⟨e₃, e₄, f₀, f₁, f₂⟩` (the annihilator of
`e₃ ∧ e₄`), with `N₁ ∩ N₂ = ⟨f₀, f₁, f₂⟩ ≅ ℂ³` — the **color axis**. With the
index convention of `PhysicsSM.StandardModel.SpinorFockHypercharge`, indices
`{0,1,2}` are color directions and `{3,4}` are weak directions, so the second
spinor `e₃ ∧ e₄` is the `Λ²(W̄₂)` direction — physically the positron `e^c`
line, exactly the second marked spinor of Krasnov's configuration. -/

/-- The Fock vacuum `1 ∈ Λ⁰`: the highest-weight pure spinor whose stabilizer
(in the future group-level development) is the Georgi-Glashow `SU(5)`. -/
def vacuumSpinor : FockSpinor := basisSpinor ∅

/-- The wedge monomial `e₃ ∧ e₄ ∈ Λ²`: the second spinor of the concrete
`d = 3` Krasnov pair (the `e^c` direction of the hypercharge table). -/
def weakSpinor : FockSpinor := basisSpinor ({3, 4} : Finset (Fin 5))

theorem isPureSpinor_vacuumSpinor : IsPureSpinor vacuumSpinor where
  ne_zero := basisSpinor_ne_zero ∅
  even := isEvenSpinor_basisSpinor (by decide)
  quadric := gammaBilinear_basis_basis_eq_zero ∅ ∅ (by decide) (by decide)

theorem isPureSpinor_weakSpinor : IsPureSpinor weakSpinor where
  ne_zero := basisSpinor_ne_zero _
  even := isEvenSpinor_basisSpinor (by decide)
  quadric := gammaBilinear_basis_basis_eq_zero _ _ (by decide) (by decide)

theorem gammaBilinear_vacuum_weak :
    gammaBilinear vacuumSpinor weakSpinor = 0 :=
  gammaBilinear_basis_basis_eq_zero _ _ (by decide) (by decide)

theorem gammaBilinear_weak_vacuum :
    gammaBilinear weakSpinor vacuumSpinor = 0 :=
  gammaBilinear_basis_basis_eq_zero _ _ (by decide) (by decide)

/-- The sum `1 + e₃ ∧ e₄` is again pure: the witness pair is aligned. -/
theorem isPureSpinor_vacuum_add_weak :
    IsPureSpinor (vacuumSpinor + weakSpinor) where
  ne_zero := by
    intro h
    have h0 := congrFun h ∅
    have hne : (∅ : Finset (Fin 5)) ≠ ({3, 4} : Finset (Fin 5)) := by decide
    simp [vacuumSpinor, weakSpinor, basisSpinor, hne] at h0
  even :=
    (isEvenSpinor_basisSpinor (by decide)).add (isEvenSpinor_basisSpinor (by decide))
  quadric := by
    rw [show vacuumSpinor + weakSpinor = vacuumSpinor + weakSpinor from rfl,
      gammaBilinear_polarization, isPureSpinor_vacuumSpinor.quadric,
      isPureSpinor_weakSpinor.quadric, gammaBilinear_vacuum_weak,
      gammaBilinear_weak_vacuum]
    abel

/-- **The concrete Krasnov configuration exists.** The pair
`(1, e₃ ∧ e₄)` is a `d = 3` aligned pure-spinor pair: both pure, gamma-
orthogonal in both orders, sum pure, and the entire projective line through
them satisfies the purity quadric (it is a line on the spinor tenfold).

This is the normal form whose full `Spin(10)`-stabilizer is the Standard Model
gauge group `S(U(2) × U(3))` in the Selector Theorem of the research notes;
the group-level statement is future work (see the claim boundary). -/
theorem krasnov_pair :
    IsPureSpinor vacuumSpinor ∧ IsPureSpinor weakSpinor
      ∧ gammaBilinear vacuumSpinor weakSpinor = 0
      ∧ gammaBilinear weakSpinor vacuumSpinor = 0
      ∧ IsPureSpinor (vacuumSpinor + weakSpinor)
      ∧ ∀ s t : ℂ,
          gammaBilinear (s • vacuumSpinor + t • weakSpinor)
            (s • vacuumSpinor + t • weakSpinor) = 0 := by
  refine ⟨isPureSpinor_vacuumSpinor, isPureSpinor_weakSpinor,
    gammaBilinear_vacuum_weak, gammaBilinear_weak_vacuum,
    isPureSpinor_vacuum_add_weak, ?_⟩
  intro s t
  exact line_quadric isPureSpinor_vacuumSpinor.quadric
    isPureSpinor_weakSpinor.quadric
    (by rw [gammaBilinear_vacuum_weak, gammaBilinear_weak_vacuum, add_zero]) s t

/-! ## Annihilator subspaces -/

/-- The annihilator of a spinor: the subspace of vectors acting as zero. For a
pure spinor this is the associated maximal isotropic subspace `N_ψ ⊂ ℂ¹⁰`
(isotropy follows from the Clifford relation, proved in the CAR draft
module). -/
def annihilator (ψ : FockSpinor) : Submodule ℂ V10 where
  carrier := {v : V10 | cliffordAction v ψ = 0}
  add_mem' := by
    intro v w hv hw
    simp only [Set.mem_setOf_eq] at hv hw ⊢
    rw [cliffordAction_add_vec, hv, hw, add_zero]
  zero_mem' := by
    simp only [Set.mem_setOf_eq]
    exact cliffordAction_zero_vec ψ
  smul_mem' := by
    intro c v hv
    simp only [Set.mem_setOf_eq] at hv ⊢
    rw [cliffordAction_smul_vec, hv, smul_zero]

theorem mem_annihilator {ψ : FockSpinor} {v : V10} :
    v ∈ annihilator ψ ↔ cliffordAction v ψ = 0 := Iff.rfl

/-- The Clifford action on the vacuum creates single-index monomials with unit
signs: `(a, b) · 1 = Σᵢ aᵢ eᵢ`. -/
theorem cliffordAction_vacuumSpinor (v : V10) :
    cliffordAction v vacuumSpinor = ∑ i, v.1 i • basisSpinor {i} := by
  rw [vacuumSpinor, cliffordAction_eq_sum]
  have hc : ∀ i : Fin 5, contract i (basisSpinor (∅ : Finset (Fin 5))) = 0 :=
    fun i => contract_basisSpinor_of_not_mem i ∅ (Finset.notMem_empty i)
  have hw : ∀ i : Fin 5,
      wedge i (basisSpinor (∅ : Finset (Fin 5))) = basisSpinor {i} := by
    intro i
    rw [wedge_basisSpinor_of_not_mem i ∅ (Finset.notMem_empty i)]
    have hins : (insert i ∅ : Finset (Fin 5)) = {i} := rfl
    have hsign : opSign i ({i} : Finset (Fin 5)) = 1 := by
      unfold opSign belowCount
      rw [Finset.filter_singleton, if_neg (lt_irrefl i)]
      simp
    rw [hins, hsign, one_smul]
  simp only [hw, hc, smul_zero, Finset.sum_const_zero, add_zero]

/-- The annihilator of the Fock vacuum is exactly the annihilation half
`N₁ = {(0, b)} = ⟨f₀, …, f₄⟩` of the hyperbolic splitting. -/
theorem mem_annihilator_vacuumSpinor_iff (v : V10) :
    v ∈ annihilator vacuumSpinor ↔ v.1 = 0 := by
  rw [mem_annihilator, cliffordAction_vacuumSpinor]
  constructor
  · intro h
    funext k
    have hk := congrFun h {k}
    rw [Finset.sum_apply] at hk
    rw [Finset.sum_eq_single k] at hk
    · simpa [basisSpinor] using hk
    · intro i _ hik
      have hne : ({k} : Finset (Fin 5)) ≠ {i} := by
        intro h'
        exact hik (Finset.singleton_injective h').symm
      simp [basisSpinor, hne]
    · intro hk'
      exact absurd (Finset.mem_univ k) hk'
  · intro h
    rw [h]
    simp

end PhysicsSM.Spinor.SpinorTenfold

end
