import Mathlib
import PhysicsSM.Algebra.Octonion.Basic
import PhysicsSM.Algebra.Octonion.Conjugation
import PhysicsSM.Algebra.Octonion.Norm
import PhysicsSM.Algebra.Octonion.TrialityCompanions
import PhysicsSM.Algebra.Octonion.ComplexOctonion

/-!
# Algebra.Octonion.SpinorFierz

The octonionic spinor model of ten-dimensional spacetime and the
Baez-Huerta route to the Fierz identity: "the `D = 10` SUSY identity holds
because the octonions are a normed division algebra".

## Mathematical context

For a normed division algebra `K` of dimension `n`, spacetime of dimension
`n + 2` can be modeled with vectors as `2 x 2` hermitian matrices over `K`
and (Weyl) spinors as `K²`. For `K = 𝕆` this gives `D = 10`:

- a vector is `A = [[a, y], [conj y, b]]` with `a, b : ℝ`, `y : Octonion`
  (`HermVector`), with Minkowski norm `det A = a b - normSq y`;
- a spinor is a pair `ψ = (ψ₁, ψ₂) : 𝕆²` (`OctSpinor`);
- the Clifford action of `A` on a spinor is matrix-vector multiplication
  with explicit parenthesization (`hermAction`), and the "other chirality"
  action uses the trace reversal `Ã = A - tr(A)·1` (`hermTraceRev`);
- the vector-valued spinor bilinear is `ψ ψ† = [[|ψ₁|², ψ₁ conj ψ₂],
  [ψ₂ conj ψ₁, |ψ₂|²]]` (`spinorSquare`).

The two theorems proved here:

- `clifford_relation_octonionic` : `Ã (A ψ) = (normSq y - a b) • ψ`, i.e.
  the action satisfies the Clifford relation for `-det`. Conceptually this is
  the composition law: the only nontrivial steps are the alternativity
  cancellations `y (conj y ψ₁) = normSq y • ψ₁` (`mul_conj_cancel_left`) and
  `conj y (y ψ₂) = normSq y • ψ₂` (`conj_mul_cancel_left`).
- `fierz_octonionic` : the **3-ψ rule** `(ψψ†)~ ψ = 0`. Conceptually the
  components are exactly `conj_mul_conj_cancel_right`:
  `(ψ₁ * conj ψ₂) * ψ₂ = normSq ψ₂ • ψ₁`, i.e. alternativity again.

Following the repository house style for octonion identities, the Lean proofs
expand to the eight real coordinates and close by `ring`; the conceptual
cancellation-law derivation above is recorded so a reader can check each
component by hand in two lines.

This is the first stage of the Baez-Huerta program for this repository: the
ten-dimensional Fierz identity of
`PhysicsSM.Spinor.SpinorTenfoldFierz` re-derived from the division-algebra
structure of `𝕆` instead of a finite enumeration. The remaining stages
(polarized three-spinor identity, the bioctonionic/complexified model, and
the bridge to the Fock model of `PhysicsSM.Spinor.SpinorTenfoldFock`) are
Aristotle targets; see `PhysicsSM.Draft.OctonionFierzAristotle`.

## Complexified (bioctonionic) definitions

The complexified model needed for the eventual bridge to the (complex) Fock
spinor model is *defined* here as well (`COctSpinor`, `CHermVector`,
`octConjC`, `normSqC`, `hermActionC`, ...), with theorems deferred to the
draft module. The octonionic conjugation `octConjC` conjugates the octonion
units and is `ℂ`-linear — it is **not** `complexConj` (which conjugates the
complex scalar).

## Conventions

- Octonion basis and multiplication: the project XOR convention of
  `PhysicsSM.Algebra.Octonion.Basic` (NOT Baez-Huerta verbatim; any formula
  from the literature must pass through
  `PhysicsSM.Algebra.Octonion.ConventionBridge`). The statements here are
  convention-independent (they hold in any composition algebra), so no
  bridge is required.
- Signature bookkeeping: with vectors `[[a, y], [conj y, b]]`, the quadratic
  form is `-det = normSq y - a b`, split signature `(9, 1)` over `ℝ`. Over
  `ℂ` (bioctonions) the signature distinction disappears, matching the
  complexified Fock model.

## Sources

- Baez, Huerta, "Division algebras and supersymmetry I", arXiv:0909.0551
  (the 2x2 hermitian model and the 3-ψ's rule).
- Internal research notes: `Sources/Spin10_stabilizer.txt`, Lemma 1(b)
  ("octonions explain 10d SUSY" = "octonions build the Cayley plane").
- Provenance: clean-room formalization from the mathematical definitions.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## The real octonionic spinor model -/

/-- A spinor of the octonionic `D = 10` model: a pair of octonions
(one Weyl spinor `S⁺ = 𝕆²` worth of real dimensions: 16). -/
@[ext]
structure OctSpinor where
  /-- The first octonion component. -/
  fst : Octonion
  /-- The second octonion component. -/
  snd : Octonion

namespace OctSpinor

instance : Zero OctSpinor := ⟨⟨0, 0⟩⟩

@[simp] theorem zero_fst : (0 : OctSpinor).fst = 0 := rfl
@[simp] theorem zero_snd : (0 : OctSpinor).snd = 0 := rfl

instance : Add OctSpinor := ⟨fun ψ φ => ⟨ψ.fst + φ.fst, ψ.snd + φ.snd⟩⟩

@[simp] theorem add_fst (ψ φ : OctSpinor) : (ψ + φ).fst = ψ.fst + φ.fst := rfl
@[simp] theorem add_snd (ψ φ : OctSpinor) : (ψ + φ).snd = ψ.snd + φ.snd := rfl

instance : SMul ℝ OctSpinor := ⟨fun r ψ => ⟨r • ψ.fst, r • ψ.snd⟩⟩

@[simp] theorem smul_fst (r : ℝ) (ψ : OctSpinor) : (r • ψ).fst = r • ψ.fst := rfl
@[simp] theorem smul_snd (r : ℝ) (ψ : OctSpinor) : (r • ψ).snd = r • ψ.snd := rfl

end OctSpinor

/-- A `D = 10` Minkowski vector in the octonionic model: the `2 x 2`
hermitian octonionic matrix `[[a, y], [conj y, b]]`, recorded by its two real
diagonal entries and the octonion off-diagonal entry (`2 + 8 = 10` real
dimensions). The Minkowski norm is `minkDet`. -/
@[ext]
structure HermVector where
  /-- The upper-left (real) diagonal entry. -/
  a : ℝ
  /-- The lower-right (real) diagonal entry. -/
  b : ℝ
  /-- The upper-right octonion entry; the lower-left entry is `conj y`. -/
  y : Octonion

namespace HermVector

instance : Zero HermVector := ⟨⟨0, 0, 0⟩⟩

@[simp] theorem zero_a : (0 : HermVector).a = 0 := rfl
@[simp] theorem zero_b : (0 : HermVector).b = 0 := rfl
@[simp] theorem zero_y : (0 : HermVector).y = 0 := rfl

instance : Add HermVector := ⟨fun A B => ⟨A.a + B.a, A.b + B.b, A.y + B.y⟩⟩

@[simp] theorem add_a (A B : HermVector) : (A + B).a = A.a + B.a := rfl
@[simp] theorem add_b (A B : HermVector) : (A + B).b = A.b + B.b := rfl
@[simp] theorem add_y (A B : HermVector) : (A + B).y = A.y + B.y := rfl

end HermVector

/-- The determinant of the hermitian matrix: the Minkowski quadratic form
(up to overall sign; the Clifford relation below realizes `-minkDet`). -/
def minkDet (A : HermVector) : ℝ := A.a * A.b - normSq A.y

/-- Trace reversal `Ã = A - tr(A) · 1 = [[-b, y], [conj y, -a]]`: the map
exchanging the two chiral halves of the Clifford action. -/
def hermTraceRev (A : HermVector) : HermVector := ⟨-A.b, -A.a, A.y⟩

@[simp] theorem hermTraceRev_hermTraceRev (A : HermVector) :
    hermTraceRev (hermTraceRev A) = A := by
  unfold hermTraceRev
  ext <;> simp

/-- The Clifford action of a hermitian vector on a spinor: matrix-vector
multiplication `A ψ = (a ψ₁ + y ψ₂, conj y ψ₁ + b ψ₂)`, with the octonion
products explicitly parenthesized (octonions are not associative). -/
def hermAction (A : HermVector) (ψ : OctSpinor) : OctSpinor :=
  ⟨A.a • ψ.fst + A.y * ψ.snd, conj A.y * ψ.fst + A.b • ψ.snd⟩

/-- The vector-valued spinor bilinear `ψ ψ†`: diagonal entries are the
squared norms, off-diagonal entry is `ψ₁ conj ψ₂`. This is the octonionic
counterpart of the gamma-bilinear `q(ψ, ψ)` of the Fock model. -/
def spinorSquare (ψ : OctSpinor) : HermVector :=
  ⟨normSq ψ.fst, normSq ψ.snd, ψ.fst * conj ψ.snd⟩

/-- The polarized (vector-valued, symmetric) spinor bilinear, normalized so
that `spinorPairing ψ ψ = 2 • spinorSquare ψ`. The scalar entries are the
real inner products `2⟨ψᵢ, φᵢ⟩` read off as the `c0` coordinate of
`x conj y + y conj x`. Theorems about it are Aristotle targets in
`PhysicsSM.Draft.OctonionFierzAristotle`. -/
def spinorPairing (ψ φ : OctSpinor) : HermVector :=
  ⟨(ψ.fst * conj φ.fst + φ.fst * conj ψ.fst).c0,
   (ψ.snd * conj φ.snd + φ.snd * conj ψ.snd).c0,
   ψ.fst * conj φ.snd + φ.fst * conj ψ.snd⟩

/-! ## The two core theorems -/

/-- **The Clifford relation of the octonionic model**: trace-reversed action
after action is the scalar `normSq y - a b = -minkDet A`. Conceptually:

  `Ã(Aψ)₁ = -b•(a•ψ₁ + yψ₂) + y(conj y ψ₁ + b•ψ₂)
          = (normSq y - ab)•ψ₁`  by `mul_conj_cancel_left`,

and symmetrically for the second component via `conj_mul_cancel_left`. The
formal proof expands the eight coordinates and closes by `ring` (house style
for octonion identities). -/
theorem clifford_relation_octonionic (A : HermVector) (ψ : OctSpinor) :
    hermAction (hermTraceRev A) (hermAction A ψ)
      = (normSq A.y - A.a * A.b) • ψ := by
  unfold hermAction hermTraceRev
  ext <;> simp [normSq] <;> ring

/-- **The 3-ψ rule (octonionic Fierz identity)**: the trace-reversed spinor
bilinear annihilates the spinor itself,

  `(ψψ†)~ ψ = 0`.

Conceptually the first component is

  `-normSq ψ₂ • ψ₁ + (ψ₁ * conj ψ₂) * ψ₂ = 0`

by the alternativity cancellation `conj_mul_conj_cancel_right`, and the
second component is the mirror image. This is the Baez-Huerta explanation of
why `D = 10` super-Yang-Mills is supersymmetric: the identity holds because
`𝕆` is a normed (alternative) division algebra. The formal proof expands the
eight coordinates and closes by `ring`. -/
theorem fierz_octonionic (ψ : OctSpinor) :
    hermAction (hermTraceRev (spinorSquare ψ)) ψ = 0 := by
  unfold hermAction hermTraceRev spinorSquare
  ext <;> simp [normSq] <;> ring

/-! ## The complexified (bioctonionic) model: definitions

The bridge target `Spin(10, ℂ)` lives over `ℂ`, so the model must be
complexified. Theorems are deferred to
`PhysicsSM.Draft.OctonionFierzAristotle`; only the definitions live here. -/

open ComplexOctonion in
/-- Octonionic conjugation on the bioctonions: conjugate the octonion units,
leave the complex scalar alone. (`ℂ`-linear; distinct from
`ComplexOctonion.complexConj`, which conjugates the complex unit.) -/
def octConjC (x : ComplexOctonion.ComplexOctonion) : ComplexOctonion.ComplexOctonion :=
  ⟨conj x.re, conj x.im⟩

/-- The real dot product of two octonions in coordinates. -/
def dotOct (x y : Octonion) : ℝ :=
  x.c0 * y.c0 + x.c1 * y.c1 + x.c2 * y.c2 + x.c3 * y.c3
    + x.c4 * y.c4 + x.c5 * y.c5 + x.c6 * y.c6 + x.c7 * y.c7

/-- The `ℂ`-valued (bilinearly extended) octonion norm on the bioctonions:
for `x = re + i·im`, `N(x) = (normSq re - normSq im) + 2i ⟨re, im⟩`. This is
the `ℂ`-bilinear extension of `normSq`, NOT a positive-definite norm; the
bioctonions have zero divisors exactly where it vanishes. -/
def normSqC (x : ComplexOctonion.ComplexOctonion) : ℂ :=
  ⟨normSq x.re - normSq x.im, 2 * dotOct x.re x.im⟩

/-- A bioctonionic spinor: a pair of complexified octonions
(`S⁺ = (ℂ ⊗ 𝕆)²`, complex dimension 16 — the `16` of `Spin(10, ℂ)`). -/
@[ext]
structure COctSpinor where
  /-- The first bioctonion component. -/
  fst : ComplexOctonion.ComplexOctonion
  /-- The second bioctonion component. -/
  snd : ComplexOctonion.ComplexOctonion

namespace COctSpinor

instance : Zero COctSpinor := ⟨⟨0, 0⟩⟩

@[simp] theorem zero_fst : (0 : COctSpinor).fst = 0 := rfl
@[simp] theorem zero_snd : (0 : COctSpinor).snd = 0 := rfl

instance : Add COctSpinor := ⟨fun ψ φ => ⟨ψ.fst + φ.fst, ψ.snd + φ.snd⟩⟩

@[simp] theorem add_fst (ψ φ : COctSpinor) : (ψ + φ).fst = ψ.fst + φ.fst := rfl
@[simp] theorem add_snd (ψ φ : COctSpinor) : (ψ + φ).snd = ψ.snd + φ.snd := rfl

instance : SMul ℂ COctSpinor := ⟨fun z ψ => ⟨z • ψ.fst, z • ψ.snd⟩⟩

@[simp] theorem smul_fst (z : ℂ) (ψ : COctSpinor) : (z • ψ).fst = z • ψ.fst := rfl
@[simp] theorem smul_snd (z : ℂ) (ψ : COctSpinor) : (z • ψ).snd = z • ψ.snd := rfl

end COctSpinor

/-- A complexified hermitian vector: `[[a, y], [octConjC y, b]]` with
`a, b : ℂ` and `y` a bioctonion (`2 + 8 = 10` complex dimensions — the
vector representation of `Spin(10, ℂ)`). -/
@[ext]
structure CHermVector where
  /-- The upper-left (complex) diagonal entry. -/
  a : ℂ
  /-- The lower-right (complex) diagonal entry. -/
  b : ℂ
  /-- The upper-right bioctonion entry; the lower-left is `octConjC y`. -/
  y : ComplexOctonion.ComplexOctonion

/-- Complexified trace reversal. -/
def hermTraceRevC (A : CHermVector) : CHermVector := ⟨-A.b, -A.a, A.y⟩

/-- Complexified Clifford action of a hermitian vector on a bioctonionic
spinor, with explicit parenthesization. -/
def hermActionC (A : CHermVector) (ψ : COctSpinor) : COctSpinor :=
  ⟨A.a • ψ.fst + A.y * ψ.snd, octConjC A.y * ψ.fst + A.b • ψ.snd⟩

/-- The complexified vector-valued spinor bilinear `ψ ψ†` (with `†` built
from `octConjC`). -/
def spinorSquareC (ψ : COctSpinor) : CHermVector :=
  ⟨normSqC ψ.fst, normSqC ψ.snd, ψ.fst * octConjC ψ.snd⟩

end PhysicsSM.Algebra.Octonion
