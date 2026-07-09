import Mathlib

/-!
# CP-oddness and celestial solid angle of the Bargmann/Pancharatnam triple

This file makes two pieces of the "null-edge mass" program into kernel-checked
theorems, working with two-component spinors `ψ = (a, b) : ℂ × ℂ`.

The gauge-invariant Bargmann/Pancharatnam triple of three rays is
`B(ψ₁,ψ₂,ψ₃) = ⟨ψ₁|ψ₂⟩⟨ψ₂|ψ₃⟩⟨ψ₃|ψ₁⟩`, with the physics inner product
`⟨ψ|φ⟩ = conj(a_ψ) a_φ + conj(b_ψ) b_φ`.

* `bargmann_CP_odd`: under CP-conjugation (componentwise complex conjugation of the
  spinors) the triple maps to its complex conjugate, so `arg B ↦ -arg B`; hence
  `Im B ≠ 0` is a genuine, non-gaugeable CP-violating invariant
  (`bargmann_CP_genuine_iff`).

* `bargmann_bloch_re` / `bargmann_bloch_im`: the exact finite Bloch/solid-angle
  identity.  Writing the (unnormalized) Bloch vector `nᵢ = ⟨ψᵢ|σ|ψᵢ⟩` and
  `Nᵢ = ⟨ψᵢ|ψᵢ⟩`,
  `B = ¼ (N₁N₂N₃ + N₃ n₁·n₂ + N₁ n₂·n₃ + N₂ n₃·n₁ + i n₁·(n₂×n₃))`.
  For unit rays (`Nᵢ = 1`) this is
  `B = ¼(1 + n₁·n₂ + n₂·n₃ + n₃·n₁ + i n₁·(n₂×n₃))` (`bargmann_bloch_unit`),
  the exact `Tr(ρ₁ρ₂ρ₃)` form of the Pancharatnam identity.

* `bargmann_tan_arg_unit`: consequently `tan (arg B) = n₁·(n₂×n₃) / (1 + n₁·n₂ +
  n₂·n₃ + n₃·n₁)`. **Scope (kernel vs commentary):** what is *proved* is exactly
  this algebraic identity for `tan (arg B)`. The reading that this right-hand side
  is the Van Oosterom–Strackee expression for `tan(Ω/2)` (with `Ω` the solid angle
  of the Bloch-vector geodesic triangle), hence that `arg B` is *half* that solid
  angle, is geometric COMMENTARY: no solid-angle object, spherical-excess area, or
  `arg`-branch handling is formalized (that would need spherical-triangle theory
  absent from Mathlib). The kernel content is the tangent identity; the solid-angle
  identification is prose. (Audit: Codex 2026-07-09, docstring-outruns-statement.)
-/

namespace Bargmann

open Complex

/-- Physics inner product `⟨(a₁,b₁)|(a₂,b₂)⟩ = conj a₁ * a₂ + conj b₁ * b₂`. -/
def ip (a₁ b₁ a₂ b₂ : ℂ) : ℂ := (starRingEnd ℂ) a₁ * a₂ + (starRingEnd ℂ) b₁ * b₂

/-- The Bargmann/Pancharatnam triple `⟨ψ₁|ψ₂⟩⟨ψ₂|ψ₃⟩⟨ψ₃|ψ₁⟩`. -/
def bargmann (a₁ b₁ a₂ b₂ a₃ b₃ : ℂ) : ℂ :=
  ip a₁ b₁ a₂ b₂ * ip a₂ b₂ a₃ b₃ * ip a₃ b₃ a₁ b₁

/-- Squared norm `⟨ψ|ψ⟩` of a spinor. -/
def sqNorm (a b : ℂ) : ℝ := normSq a + normSq b

/-- `x`-component of the Bloch vector `⟨ψ|σₓ|ψ⟩`. -/
def bx (a b : ℂ) : ℝ := 2 * ((starRingEnd ℂ) a * b).re
/-- `y`-component of the Bloch vector `⟨ψ|σ_y|ψ⟩`. -/
def by' (a b : ℂ) : ℝ := 2 * ((starRingEnd ℂ) a * b).im
/-- `z`-component of the Bloch vector `⟨ψ|σ_z|ψ⟩`. -/
def bz (a b : ℂ) : ℝ := normSq a - normSq b

/-- Euclidean dot product of the Bloch vectors of two spinors. -/
def bdot (a₁ b₁ a₂ b₂ : ℂ) : ℝ :=
  bx a₁ b₁ * bx a₂ b₂ + by' a₁ b₁ * by' a₂ b₂ + bz a₁ b₁ * bz a₂ b₂

/-- Scalar triple product `n₁·(n₂×n₃)` of the three Bloch vectors. -/
def btriple (a₁ b₁ a₂ b₂ a₃ b₃ : ℂ) : ℝ :=
  bx a₁ b₁ * (by' a₂ b₂ * bz a₃ b₃ - bz a₂ b₂ * by' a₃ b₃)
  - by' a₁ b₁ * (bx a₂ b₂ * bz a₃ b₃ - bz a₂ b₂ * bx a₃ b₃)
  + bz a₁ b₁ * (bx a₂ b₂ * by' a₃ b₃ - by' a₂ b₂ * bx a₃ b₃)

/-
CP-conjugation of a ray: componentwise complex conjugation.
Under CP the inner product conjugates.
-/
theorem ip_CP (a₁ b₁ a₂ b₂ : ℂ) :
    ip ((starRingEnd ℂ) a₁) ((starRingEnd ℂ) b₁) ((starRingEnd ℂ) a₂) ((starRingEnd ℂ) b₂)
      = (starRingEnd ℂ) (ip a₁ b₁ a₂ b₂) := by
  unfold ip; simp +decide [ mul_comm ] ;

/-
**CP-oddness of the Bargmann triple.** Under CP (componentwise complex
conjugation of all three spinors) the Bargmann triple maps to its complex
conjugate. Hence `arg B ↦ -arg B`.
-/
theorem bargmann_CP_odd (a₁ b₁ a₂ b₂ a₃ b₃ : ℂ) :
    bargmann ((starRingEnd ℂ) a₁) ((starRingEnd ℂ) b₁)
        ((starRingEnd ℂ) a₂) ((starRingEnd ℂ) b₂)
        ((starRingEnd ℂ) a₃) ((starRingEnd ℂ) b₃)
      = (starRingEnd ℂ) (bargmann a₁ b₁ a₂ b₂ a₃ b₃) := by
  unfold bargmann; simp +decide [ mul_assoc ] ;
  simp +decide only [ip_CP]

/-
The Bargmann triple is CP-invariant iff its imaginary part vanishes; so
`Im B ≠ 0` is a genuine (non-gaugeable) CP-violating invariant.
-/
theorem bargmann_CP_genuine_iff (a₁ b₁ a₂ b₂ a₃ b₃ : ℂ) :
    bargmann ((starRingEnd ℂ) a₁) ((starRingEnd ℂ) b₁)
        ((starRingEnd ℂ) a₂) ((starRingEnd ℂ) b₂)
        ((starRingEnd ℂ) a₃) ((starRingEnd ℂ) b₃)
      = bargmann a₁ b₁ a₂ b₂ a₃ b₃ ↔ (bargmann a₁ b₁ a₂ b₂ a₃ b₃).im = 0 := by
  norm_num [ Complex.ext_iff, bargmann_CP_odd ];
  constructor <;> intro h <;> linarith

/-
**Real part of the Bloch identity** (exact, homogeneous, no normalization).
-/
theorem bargmann_bloch_re (a₁ b₁ a₂ b₂ a₃ b₃ : ℂ) :
    (bargmann a₁ b₁ a₂ b₂ a₃ b₃).re
      = (1 / 4) * (sqNorm a₁ b₁ * sqNorm a₂ b₂ * sqNorm a₃ b₃
          + sqNorm a₃ b₃ * bdot a₁ b₁ a₂ b₂
          + sqNorm a₁ b₁ * bdot a₂ b₂ a₃ b₃
          + sqNorm a₂ b₂ * bdot a₃ b₃ a₁ b₁) := by
  unfold bargmann sqNorm bdot;
  norm_num [ ip, bx, by', bz, Complex.normSq, Complex.mul_re, Complex.mul_im ] ; ring;

/-
**Imaginary part of the Bloch identity**: `Im B = ¼ n₁·(n₂×n₃)` (exact,
homogeneous, no normalization).
-/
theorem bargmann_bloch_im (a₁ b₁ a₂ b₂ a₃ b₃ : ℂ) :
    (bargmann a₁ b₁ a₂ b₂ a₃ b₃).im = (1 / 4) * btriple a₁ b₁ a₂ b₂ a₃ b₃ := by
  unfold bargmann btriple bx by' bz;
  unfold ip; norm_num [ Complex.normSq, Complex.mul_re, Complex.mul_im ] ; ring;

/-
**The Bloch/solid-angle identity for unit rays.** For normalized spinors
`B = ¼(1 + n₁·n₂ + n₂·n₃ + n₃·n₁ + i n₁·(n₂×n₃))`.
-/
theorem bargmann_bloch_unit (a₁ b₁ a₂ b₂ a₃ b₃ : ℂ)
    (h₁ : sqNorm a₁ b₁ = 1) (h₂ : sqNorm a₂ b₂ = 1) (h₃ : sqNorm a₃ b₃ = 1) :
    bargmann a₁ b₁ a₂ b₂ a₃ b₃
      = (1 / 4) * ((1 + bdot a₁ b₁ a₂ b₂ + bdot a₂ b₂ a₃ b₃ + bdot a₃ b₃ a₁ b₁
          : ℝ) + Complex.I * btriple a₁ b₁ a₂ b₂ a₃ b₃) := by
  simp_all +decide [ Complex.ext_iff, bargmann_bloch_re, bargmann_bloch_im ]

/-
**Algebraic tangent identity (what is proved).** For unit rays,
`tan (arg B) = n₁·(n₂×n₃) / (1 + n₁·n₂ + n₂·n₃ + n₃·n₁)`. This much is
kernel-checked below. The identification of the right-hand side with the Van
Oosterom–Strackee expression for `tan(Ω/2)`, and hence the reading that `arg B` is
half the solid angle of the geodesic triangle `n₁,n₂,n₃` on the Bloch sphere, is
geometric commentary — the solid angle itself is not formalized.
-/
theorem bargmann_tan_arg_unit (a₁ b₁ a₂ b₂ a₃ b₃ : ℂ)
    (h₁ : sqNorm a₁ b₁ = 1) (h₂ : sqNorm a₂ b₂ = 1) (h₃ : sqNorm a₃ b₃ = 1) :
    Real.tan (bargmann a₁ b₁ a₂ b₂ a₃ b₃).arg
      = btriple a₁ b₁ a₂ b₂ a₃ b₃
          / (1 + bdot a₁ b₁ a₂ b₂ + bdot a₂ b₂ a₃ b₃ + bdot a₃ b₃ a₁ b₁) := by
  rw [ Complex.tan_arg, bargmann_bloch_im, bargmann_bloch_re ];
  grind

end Bargmann

-- In-file axiom guard: each of the delivered theorems depends only on the
-- kernel footprint [propext, Classical.choice, Quot.sound].
/-- info: 'Bargmann.bargmann_CP_odd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Bargmann.bargmann_CP_odd

/-- info: 'Bargmann.bargmann_CP_genuine_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Bargmann.bargmann_CP_genuine_iff

/-- info: 'Bargmann.bargmann_bloch_re' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Bargmann.bargmann_bloch_re

/-- info: 'Bargmann.bargmann_bloch_im' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Bargmann.bargmann_bloch_im

/-- info: 'Bargmann.bargmann_bloch_unit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Bargmann.bargmann_bloch_unit

/-- info: 'Bargmann.bargmann_tan_arg_unit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Bargmann.bargmann_tan_arg_unit
