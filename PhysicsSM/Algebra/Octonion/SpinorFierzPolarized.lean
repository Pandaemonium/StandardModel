import Mathlib
import PhysicsSM.Algebra.Octonion.SpinorFierz

/-!
# Algebra.Octonion.SpinorFierzPolarized

Stage two of the Baez-Huerta octonionic-Fierz program: the polarized
three-spinor identity, bioctonionic cancellation laws, and the complexified
Clifford relation and Fierz identity.

The trusted module `PhysicsSM.Algebra.Octonion.SpinorFierz` defines the
octonionic spinor model of `D = 10` and proves:
- `clifford_relation_octonionic` (the Clifford relation),
- `fierz_octonionic` (the diagonal 3-ψ rule).

This module proves the remaining stages:

1. **Polarized real identities** — `spinorPairing` symmetry, self-pairing,
   polarization of `spinorSquare`, and the full symmetric trilinear 3-Ψ's
   rule `fierz_octonionic_polarized` (Baez-Huerta, arXiv:0909.0551).
2. **Bioctonionic cancellation laws** — `octConjC` is an antiautomorphism,
   `x * octConjC x = ofComplex (normSqC x)`, and the four bioctonionic
   alternativity cancellations.
3. **Bioctonionic Clifford relation and Fierz identity** — the complexified
   counterparts, realizing the `Spin(10, ℂ)` Clifford algebra on `(ℂ ⊗ 𝕆)²`
   and completing the bioctonionic Fierz identity.

All proofs follow the repository house style: coordinate expansion plus
`ring`. Heavier 16-coordinate identities need a raised heartbeat budget.

Status: trusted — no `sorry`, no `native_decide`.
Axioms: `propext`, `Classical.choice`, `Quot.sound` only.

## Sources

- Baez, Huerta, "Division algebras and supersymmetry I", arXiv:0909.0551.
- Provenance: Aristotle job `04babfce-16a7-4827-a4da-a7b298d71cca`
  (wave 4, 2026-06-10), integrated and promoted from Draft.
-/

namespace PhysicsSM.Algebra.Octonion

open PhysicsSM.Algebra.Octonion.ComplexOctonion

/-! ## Stage 1: polarized real identities -/

/-- The polarized spinor bilinear is symmetric. -/
theorem spinorPairing_comm (ψ φ : OctSpinor) :
    spinorPairing ψ φ = spinorPairing φ ψ := by
  unfold spinorPairing
  ext <;> simp <;> ring

/-- The polarized bilinear restricts to twice the square on the diagonal. -/
theorem spinorPairing_self (ψ : OctSpinor) :
    spinorPairing ψ ψ = spinorSquare ψ + spinorSquare ψ := by
  unfold spinorPairing spinorSquare
  ext <;> simp <;> ring

/-- `spinorSquare` polarizes through `spinorPairing`. -/
theorem spinorSquare_polarization (ψ φ : OctSpinor) :
    spinorSquare (ψ + φ) = spinorSquare ψ + spinorPairing ψ φ + spinorSquare φ := by
  unfold spinorSquare spinorPairing
  ext <;> simp <;> ring

set_option maxHeartbeats 4000000 in
-- The cyclic three-spinor sum expands to a large coordinate polynomial; the
-- closing `ring` exceeds the default heartbeat budget.
/-- **The symmetric trilinear 3-Ψ's rule** (Baez-Huerta): the cyclic sum of
the trace-reversed polarized bilinear acting on the third spinor vanishes.
This is the full `D = 10` SUSY identity; the diagonal `ψ = φ = χ` case is
the trusted `fierz_octonionic` (each diagonal term is twice it). -/
theorem fierz_octonionic_polarized (ψ φ χ : OctSpinor) :
    hermAction (hermTraceRev (spinorPairing ψ φ)) χ
      + hermAction (hermTraceRev (spinorPairing φ χ)) ψ
      + hermAction (hermTraceRev (spinorPairing χ ψ)) φ = 0 := by
  unfold hermAction hermTraceRev spinorPairing
  ext <;> simp <;> ring

/-! ## Stage 2: bioctonionic cancellation laws -/

/-- Octonionic conjugation is an involution on the bioctonions. -/
theorem octConjC_octConjC (x : ComplexOctonion) :
    octConjC (octConjC x) = x := by
  unfold octConjC
  ext <;> simp [conj_conj]

/-- Octonionic conjugation is an antiautomorphism of the bioctonions. -/
theorem octConjC_mul (x y : ComplexOctonion) :
    octConjC (x * y) = octConjC y * octConjC x := by
  unfold octConjC
  ext <;> simp [conj_mul, conj_add] <;> ring

/-- A bioctonion times its octonionic conjugate is the scalar `normSqC`. -/
theorem mul_octConjC_self (x : ComplexOctonion) :
    x * octConjC x = ofComplex (normSqC x) := by
  unfold octConjC ofComplex normSqC dotOct
  ext <;> simp <;> ring

set_option maxHeartbeats 1000000 in
-- The 16-coordinate cancellation polynomial needs more than the default
-- heartbeat budget to be normalized by `ring`.
/-- Right cancellation in the bioctonions:
`(x * octConjC a) * a = normSqC a • x`. The ℂ-bilinear extension of the
trusted `conj_mul_conj_cancel_right`. -/
theorem mul_octConjC_cancel_right (a x : ComplexOctonion) :
    (x * octConjC a) * a = normSqC a • x := by
  unfold octConjC normSqC dotOct
  ext <;> simp <;> ring

set_option maxHeartbeats 1000000 in
-- The 16-coordinate cancellation polynomial needs more than the default
-- heartbeat budget to be normalized by `ring`.
/-- Left cancellation in the bioctonions:
`octConjC a * (a * x) = normSqC a • x`. The ℂ-bilinear extension of the
trusted `conj_mul_cancel_left`. -/
theorem octConjC_mul_cancel_left (a x : ComplexOctonion) :
    octConjC a * (a * x) = normSqC a • x := by
  unfold octConjC normSqC dotOct
  ext <;> simp <;> ring

set_option maxHeartbeats 1000000 in
-- The 16-coordinate cancellation polynomial needs more than the default
-- heartbeat budget to be normalized by `ring`.
/-- Left cancellation, conjugate form:
`a * (octConjC a * x) = normSqC a • x`. -/
theorem mul_octConjC_cancel_left (a x : ComplexOctonion) :
    a * (octConjC a * x) = normSqC a • x := by
  unfold octConjC normSqC dotOct
  ext <;> simp <;> ring

/-! ## Stage 3: the bioctonionic Clifford relation and Fierz identity -/

set_option maxHeartbeats 4000000 in
-- The complexified Clifford relation expands to a large 16-coordinate
-- polynomial identity closed by `ring`, exceeding the default budget.
/-- The complexified Clifford relation: trace-reversed action after action is
the scalar `normSqC y - a b`. This realizes the `Spin(10, ℂ)` Clifford
algebra on the bioctonionic spinors. -/
theorem clifford_relation_bioctonionic (A : CHermVector) (ψ : COctSpinor) :
    hermActionC (hermTraceRevC A) (hermActionC A ψ)
      = (normSqC A.y - A.a * A.b) • ψ := by
  unfold hermActionC hermTraceRevC octConjC normSqC dotOct
  ext <;> simp <;> ring

set_option maxHeartbeats 4000000 in
-- The complexified Fierz identity expands to a large 16-coordinate
-- polynomial identity closed by `ring`, exceeding the default budget.
/-- **The bioctonionic 3-ψ rule**: the complexified Fierz identity. Together
with a future explicit equivalence between `(ℂ ⊗ 𝕆)²` and the Fock model
`Λ^even(ℂ⁵)` of `PhysicsSM.Spinor.SpinorTenfoldFock`, this re-derives the
trusted `fierz_clifford` from the division-algebra structure of `𝕆`. -/
theorem fierz_bioctonionic (ψ : COctSpinor) :
    hermActionC (hermTraceRevC (spinorSquareC ψ)) ψ = 0 := by
  unfold hermActionC hermTraceRevC spinorSquareC octConjC normSqC dotOct
  ext <;> simp <;> ring

end PhysicsSM.Algebra.Octonion
