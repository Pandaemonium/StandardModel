import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldPurity

/-!
# Algebra.Jordan.CayleyPlaneD5Chart

The `D₅`-graded chart of the complex Cayley plane: the Freudenthal adjoint
(sharp) map on `J = ℂ ⊕ S⁺ ⊕ V` and the rank-one locus.

## Mathematical context

Under the parabolic `Spin(10) × U(1) ⊂ E₆`, the complexified exceptional
Jordan algebra decomposes as `27 = 1 ⊕ 16 ⊕ 10`, so a chart point is a triple
`X = (a, ψ, v)`. The cubic norm is `N(X) = a Q(v) - ⟨v, q(ψ)⟩` (up to harmless
normalization), and differentiating gives the adjoint ("sharp") map in the
dual grading:

  `X^# = (Q(v), -(v · ψ), a v - q(ψ, ψ))`.

The complex Cayley plane `𝕏 = E₆/P₁ ⊂ ℙ²⁶` is the projectivized rank-one
locus `X^# = 0`. This module proves, in the concrete Fock model of
`PhysicsSM.Spinor.SpinorTenfold`:

- **Proposition 1(a)**: `(0, ψ, 0)^# = 0` iff `q(ψ, ψ) = 0` — the slice of the
  Cayley plane by the spinor summand is exactly the pure-spinor quadric
  (the spinor tenfold `𝕊₁₀ = 𝕏 ∩ ℙ(S⁺)`).
- **Proposition 1(b)** (conditional form): given the ten-dimensional Fierz
  identity `q(ψ, ψ) · ψ = 0`, the affine chart point `(1, ψ, q(ψ, ψ))` is
  rank one. The scalar component `Q(q(ψ))` vanishes *for free* by the
  contraction lemma `Q10_gammaBilinear_eq_zero_of_clifford`. The Fierz
  identity itself — the identity that makes `D = 10` super-Yang-Mills
  supersymmetric — is proved (kernel-clean) in
  `PhysicsSM.Spinor.SpinorTenfoldFierz`, where the unconditional
  version of Prop 1(b) is derived.
- **Proposition 2 (rank-one collinearity)**: for two rank-one spinor points,
  the whole projective line through them is rank one iff the symmetrized
  gamma-bilinear vanishes — Krasnov's alignment condition. The line
  `s X₁ + t X₂` has `(s X₁ + t X₂)^# = s t (X₁ # X₂)` where `#` is the
  Freudenthal cross (bilinearization of sharp).

## Conventions

- `ChartPoint := ℂ × FockSpinor × V10`, with the spinor slot intended even
  (positive chirality). The sharp output's spinor slot is then odd; parities
  are tracked by hypotheses, not by the type.
- `freudenthalCross X Y := (X + Y)^# - X^# - Y^#` (full bilinearization,
  **without** the factor `1/2`), so `cross X X = 2 X^#`.

## Claim boundary

No `E₆` action, no cubic norm, no projective geometry is constructed; this is
the algebraic sharp-map layer only. The statements are exactly the
computations of Lemma 1 / Proposition 1-2 of the research notes.

## Sources

- Baez, "Geometry and the Exceptional Jordan Algebra" (Azimuth, 2026-03-27).
- Landsberg-Manivel, "The projective geometry of Freudenthal's magic square"
  (rank-one loci and Severi varieties).
- Krasnov, arXiv:2209.05088 (two-pure-spinor symmetry breaking).
- Internal research notes: `Sources/Spin10_stabilizer.txt`, Lemma 1,
  Lemma 2 / Propositions 1-2.
- Provenance: clean-room formalization; sign conventions inherited from
  `PhysicsSM.Spinor.SpinorTenfold` (oracle-validated).

Status: trusted — no `s o r r y`.
-/

noncomputable section

namespace PhysicsSM.Algebra.Jordan.CayleyPlaneD5

open PhysicsSM.Spinor.SpinorTenfold

/-- A point of the `D₅`-graded chart of the complexified exceptional Jordan
algebra: `(a, ψ, v) ∈ ℂ ⊕ S ⊕ V`. The spinor slot is intended to be even
(the `16`); the sharp map sends it to an odd spinor (the dual grading). -/
abbrev ChartPoint := ℂ × FockSpinor × V10

/-- The scalar component of a chart point. -/
abbrev ChartPoint.scalar (X : ChartPoint) : ℂ := X.1

/-- The spinor component of a chart point. -/
abbrev ChartPoint.spinor (X : ChartPoint) : FockSpinor := X.2.1

/-- The vector component of a chart point. -/
abbrev ChartPoint.vector (X : ChartPoint) : V10 := X.2.2

/-- The Freudenthal adjoint (sharp) map in the `D₅` grading:
`(a, ψ, v)^# = (Q(v), -(v · ψ), a v - q(ψ, ψ))`.

The rank-one locus `X^# = 0` is the cone over the complex Cayley plane.
Source: research notes `Sources/Spin10_stabilizer.txt`, Setup; the formula is
the differential of the cubic norm `N(X) = a Q(v) - ⟨v, q(ψ)⟩`. -/
def sharpMap (X : ChartPoint) : ChartPoint :=
  (Q10 X.vector,
   -(cliffordAction X.vector X.spinor),
   X.scalar • X.vector - gammaBilinear X.spinor X.spinor)

/-- The Freudenthal cross product: the full bilinearization of `sharpMap`,
normalized so that `freudenthalCross X X = 2 • sharpMap X` (no factor `1/2`,
which keeps all coefficients integral). -/
def freudenthalCross (X Y : ChartPoint) : ChartPoint :=
  (B10 X.vector Y.vector,
   -(cliffordAction X.vector Y.spinor) - cliffordAction Y.vector X.spinor,
   X.scalar • Y.vector + Y.scalar • X.vector
     - gammaBilinear X.spinor Y.spinor - gammaBilinear Y.spinor X.spinor)

/-- The cross product is symmetric. -/
theorem freudenthalCross_comm (X Y : ChartPoint) :
    freudenthalCross X Y = freudenthalCross Y X := by
  unfold freudenthalCross
  refine Prod.ext ?_ (Prod.ext ?_ ?_)
  · exact B10_comm _ _
  · abel
  · abel

/-- `sharpMap` is quadratic: its deviation from additivity is exactly the
cross product. -/
theorem sharpMap_add (X Y : ChartPoint) :
    sharpMap (X + Y) = sharpMap X + sharpMap Y + freudenthalCross X Y := by
  unfold sharpMap freudenthalCross
  refine Prod.ext ?_ (Prod.ext ?_ ?_)
  · simp only [ChartPoint.vector, Prod.snd_add, Prod.fst_add]
    exact Q10_add _ _
  · simp only [ChartPoint.vector, ChartPoint.spinor, Prod.snd_add, Prod.fst_add,
      cliffordAction_add_vec, cliffordAction_add_spinor]
    abel
  · simp only [ChartPoint.scalar, ChartPoint.vector, ChartPoint.spinor,
      Prod.snd_add, Prod.fst_add, gammaBilinear_add_left, gammaBilinear_add_right,
      add_smul, smul_add]
    abel

/-- `sharpMap` is homogeneous of degree two. -/
theorem sharpMap_smul (c : ℂ) (X : ChartPoint) :
    sharpMap (c • X) = (c ^ 2) • sharpMap X := by
  unfold sharpMap
  refine Prod.ext ?_ (Prod.ext ?_ ?_)
  · simp only [ChartPoint.vector, Prod.smul_snd, Prod.smul_fst, smul_eq_mul]
    exact Q10_smul c _
  · simp only [ChartPoint.vector, ChartPoint.spinor, Prod.smul_snd, Prod.smul_fst,
      cliffordAction_smul_vec, cliffordAction_smul_spinor, smul_smul, smul_neg,
      pow_two]
  · simp only [ChartPoint.scalar, ChartPoint.vector, ChartPoint.spinor,
      Prod.smul_snd, Prod.smul_fst, smul_eq_mul, gammaBilinear_smul_left,
      gammaBilinear_smul_right, smul_smul, smul_sub]
    congr 1
    rw [show c * X.scalar * c = c ^ 2 * X.scalar by ring]
    rw [show c * c = c ^ 2 by ring]

/-- The cross product is bilinear under simultaneous scaling. -/
theorem freudenthalCross_smul_smul (s t : ℂ) (X Y : ChartPoint) :
    freudenthalCross (s • X) (t • Y) = (s * t) • freudenthalCross X Y := by
  unfold freudenthalCross
  refine Prod.ext ?_ (Prod.ext ?_ ?_)
  · simp only [ChartPoint.vector, Prod.smul_snd, Prod.smul_fst, smul_eq_mul,
      B10_smul_left, B10_smul_right]
    ring
  · simp only [ChartPoint.vector, ChartPoint.spinor, Prod.smul_snd, Prod.smul_fst,
      cliffordAction_smul_vec, cliffordAction_smul_spinor, smul_smul, smul_neg,
      smul_sub]
    rw [mul_comm t s]
  · simp only [ChartPoint.scalar, ChartPoint.vector, ChartPoint.spinor,
      Prod.smul_snd, Prod.smul_fst, smul_eq_mul, gammaBilinear_smul_left,
      gammaBilinear_smul_right, smul_smul, smul_sub, smul_add]
    rw [show s * X.scalar * t = s * t * X.scalar by ring,
      show t * Y.scalar * s = s * t * Y.scalar by ring,
      show s * t = t * s from mul_comm s t]

/-- The cross of a point with itself is twice its sharp. -/
theorem freudenthalCross_self (X : ChartPoint) :
    freudenthalCross X X = (2 : ℂ) • sharpMap X := by
  unfold freudenthalCross sharpMap
  refine Prod.ext ?_ (Prod.ext ?_ ?_)
  · simp only [Prod.smul_fst, smul_eq_mul]
    exact B10_self _
  · simp only [Prod.smul_snd, Prod.smul_fst]
    rw [two_smul]
    abel
  · simp only [Prod.smul_snd]
    rw [two_smul]
    abel

/-! ## Proposition 1(a): the spinor slice of the rank-one locus -/

/-- The sharp of a pure spinor slot: `(0, ψ, 0)^# = (0, 0, -q(ψ, ψ))`. -/
theorem sharpMap_spinorOnly (ψ : FockSpinor) :
    sharpMap ((0 : ℂ), ψ, (0 : V10)) = (0, 0, -(gammaBilinear ψ ψ)) := by
  unfold sharpMap
  refine Prod.ext ?_ (Prod.ext ?_ ?_)
  · exact Q10_zero
  · simp [ChartPoint.spinor, ChartPoint.vector]
  · simp [ChartPoint.scalar, ChartPoint.spinor, ChartPoint.vector]

/-- **Proposition 1(a)**: a spinor-slot chart point is rank one iff the spinor
satisfies Cartan's purity quadric. Hence `𝕊₁₀ = 𝕏 ∩ ℙ(S⁺)`: the spinor
tenfold is the boundary slice of the Cayley plane. -/
theorem sharpMap_spinorOnly_eq_zero_iff (ψ : FockSpinor) :
    sharpMap ((0 : ℂ), ψ, (0 : V10)) = 0 ↔ gammaBilinear ψ ψ = 0 := by
  rw [sharpMap_spinorOnly]
  constructor
  · intro h
    have h3 := congrArg (fun Z : ChartPoint => Z.2.2) h
    simpa using neg_eq_zero.mp h3
  · intro h
    rw [h, neg_zero]
    rfl

/-- Purity-language form of Proposition 1(a) for nonzero even spinors. -/
theorem sharpMap_spinorOnly_eq_zero_iff_pure {ψ : FockSpinor}
    (hne : ψ ≠ 0) (heven : IsEvenSpinor ψ) :
    sharpMap ((0 : ℂ), ψ, (0 : V10)) = 0 ↔ IsPureSpinor ψ := by
  rw [sharpMap_spinorOnly_eq_zero_iff]
  constructor
  · intro h
    exact ⟨hne, heven, h⟩
  · intro h
    exact h.quadric

/-! ## Proposition 1(b): the affine chart lands on the Cayley plane -/

/-- **Proposition 1(b), conditional form**: given the ten-dimensional Fierz
identity `q(ψ, ψ) · ψ = 0` for `ψ`, the graph point `(1, ψ, q(ψ, ψ))` is rank
one. The scalar component `Q(q(ψ, ψ))` vanishes automatically by the
contraction lemma — only the spinor component needs the Fierz identity.

This is the precise statement that "the `D = 10` SUSY identity *is* the affine
chart of the Cayley plane": the unconditional version (for every even spinor)
is `sharpMap_graph_eq_zero_of_even` in
`PhysicsSM.Spinor.SpinorTenfoldFierz`. -/
theorem sharpMap_graph_eq_zero {ψ : FockSpinor}
    (hfierz : cliffordAction (gammaBilinear ψ ψ) ψ = 0) :
    sharpMap ((1 : ℂ), ψ, gammaBilinear ψ ψ) = 0 := by
  unfold sharpMap
  refine Prod.ext ?_ (Prod.ext ?_ ?_)
  · simpa [ChartPoint.vector] using
      Q10_gammaBilinear_eq_zero_of_clifford hfierz
  · simpa [ChartPoint.spinor, ChartPoint.vector] using
      congrArg Neg.neg hfierz
  · simp [ChartPoint.scalar, ChartPoint.spinor, ChartPoint.vector]

/-! ## Proposition 2: rank-one collinearity -/

/-- On the rank-one locus, the sharp of a linear combination is governed by
the cross product alone: `(s X + t Y)^# = s t (X # Y)` when `X^# = Y^# = 0`. -/
theorem sharpMap_line {X Y : ChartPoint}
    (hX : sharpMap X = 0) (hY : sharpMap Y = 0) (s t : ℂ) :
    sharpMap (s • X + t • Y) = (s * t) • freudenthalCross X Y := by
  rw [sharpMap_add, sharpMap_smul, sharpMap_smul, hX, hY, smul_zero, smul_zero,
    zero_add, zero_add, freudenthalCross_smul_smul]

/-- If two rank-one points also have vanishing cross product, the entire line
through them lies in the rank-one locus (is contained in the Cayley plane). -/
theorem sharpMap_line_eq_zero {X Y : ChartPoint}
    (hX : sharpMap X = 0) (hY : sharpMap Y = 0)
    (hc : freudenthalCross X Y = 0) (s t : ℂ) :
    sharpMap (s • X + t • Y) = 0 := by
  rw [sharpMap_line hX hY, hc, smul_zero]

/-- The cross product of two spinor-slot points encodes exactly the
symmetrized gamma-bilinear:
`(0, ψ₁, 0) # (0, ψ₂, 0) = (0, 0, -(q(ψ₁, ψ₂) + q(ψ₂, ψ₁)))`. -/
theorem freudenthalCross_spinorOnly (ψ₁ ψ₂ : FockSpinor) :
    freudenthalCross ((0 : ℂ), ψ₁, (0 : V10)) ((0 : ℂ), ψ₂, (0 : V10))
      = (0, 0, -(gammaBilinear ψ₁ ψ₂ + gammaBilinear ψ₂ ψ₁)) := by
  unfold freudenthalCross
  refine Prod.ext ?_ (Prod.ext ?_ ?_)
  · simp [ChartPoint.vector]
  · simp [ChartPoint.spinor, ChartPoint.vector]
  · simp only [ChartPoint.scalar, ChartPoint.spinor, ChartPoint.vector, zero_smul,
      add_zero]
    abel

/-- **Proposition 2 (rank-one collinearity)**: for two spinors on the purity
quadric, the projective line through their chart points lies entirely in the
rank-one locus iff the symmetrized gamma-bilinear vanishes — Krasnov's
condition. Together with `line_quadric`/`sum_quadric_iff` in the purity
module, this completes the equivalence chain (1)-(4) of Lemma 2 of the
research notes at the quadric level. -/
theorem spinor_line_rank_one_iff {ψ₁ ψ₂ : FockSpinor}
    (h₁ : gammaBilinear ψ₁ ψ₁ = 0) (h₂ : gammaBilinear ψ₂ ψ₂ = 0) :
    (∀ s t : ℂ,
        sharpMap (s • ((0 : ℂ), ψ₁, (0 : V10)) + t • ((0 : ℂ), ψ₂, (0 : V10))) = 0)
      ↔ gammaBilinear ψ₁ ψ₂ + gammaBilinear ψ₂ ψ₁ = 0 := by
  have hX := (sharpMap_spinorOnly_eq_zero_iff ψ₁).mpr h₁
  have hY := (sharpMap_spinorOnly_eq_zero_iff ψ₂).mpr h₂
  constructor
  · intro hline
    have h11 := hline 1 1
    rw [sharpMap_line hX hY, one_mul, one_smul, freudenthalCross_spinorOnly] at h11
    have h3 := congrArg (fun Z : ChartPoint => Z.2.2) h11
    simpa using neg_eq_zero.mp h3
  · intro hq s t
    apply sharpMap_line_eq_zero hX hY
    rw [freudenthalCross_spinorOnly, hq, neg_zero]
    rfl

end PhysicsSM.Algebra.Jordan.CayleyPlaneD5

end
