import PhysicsSM.Draft.NullEdge.DixonWeakLadders

/-!
# KERNEL NO-GO: the weak-ladder algebra is NOT element products - the anti-Fock dictionary

**Status: DRAFT; kernel-checked no-go + the decisive element dictionary.**

This module records the 2026-07-18 kernel finding that RESOLVES the item-2
"operator vs element" question. Two inputs collided:

1. **Transcription correction (PDF eq 30 re-parsed):** Furey's `beta_1` is
   `(1/2)(-i_2 + i i_1 tau_3)` with **`tau_3 = omega omega‡ - omega‡ omega`**,
   NOT `tau_1 = omega + omega‡` as first transcribed. (Abstract Fock
   computation: with `tau_3` ALL of eq 31 holds in the associative operator
   algebra; with `tau_1` the cross-CAR is a robust nonzero `1/2` - which is
   exactly what the kernel showed for the `tau_1` variant:
   `DixonWeakLadders.betaH_like_anticomm_ne_zero`.)
2. **The element dictionary (THIS module, kernel):** at ELEMENT level, with the
   left-associated repo ladder products `omega = (a_1 a_2) a_3`,
   `omega‡ = (a_3‡ a_2‡) a_1‡`, the Fock relations FAIL in a structured
   "anti-Fock" pattern:

   | assumed (operator Fock) | kernel element fact |
   |---|---|
   | `omega^2 = 0`            | `omega^2 = -v`  (`v = (1 - i e_111)/2`) |
   | `(omega‡)^2 = 0`         | `(omega‡)^2 = -v*` |
   | `omega omega‡ = v`       | `omega omega‡ = 0` |
   | `omega‡ omega = v*`      | `omega‡ omega = 0` |
   | `tau_3 != 0`             | **`tau_3 = 0` identically** |

   The squares and the idempotents EXCHANGE roles (up to sign): octonion
   non-associativity scrambles the composition order. In particular the
   element-level `tau_3`-variant CAR is VACUOUS (`beta_1` collapses to
   `-i_2/2`), so no element-level reading of eq 29-31 is faithful - the
   `tau_1` variant fails honestly (`1/2 != 0`), the `tau_3` variant fails
   vacuously (`tau_3 = 0`).

**Consequence (the resolution).** Furey's Cl(6)/Cl(2) ladder algebra is the
algebra of COMPOSITION OPERATORS - nested left multiplications
`omega-hat = L_{a_1} o L_{a_2} o L_{a_3}` - which is associative, satisfies
the Fock relations, and makes `tau_3-hat = P_000 - P_111 != 0`. The eq-31 CAR
must be realized as OPERATOR identities on the minimal ideal (the repo's
`MinimalLeftIdeal` basis states are exactly the nested-application form
`alpha1 * (alpha2 * omega)` - already the operator picture). Successor module:
the composition-operator weak sector. The landed `DixonAlgebra` substrate is
unaffected (the `H`-sector is associative); it is the COLOUR factor whose
ladder products must be compositions.

Provenance: probes generated from the leftover goals of the failed Fock
assumptions; each value below is the kernel-computed one.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DixonWeakCARTau3

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.WeakBetaLaddersFromColor

set_option maxRecDepth 10000
set_option maxHeartbeats 16000000

/-- The colour idempotent literal `v = (1 - i e_111)/2` (matches
`MinimalLeftIdeal.omega` - the IDEMPOTENT, not the ladder). -/
def vIdem : ComplexOctonion := ⟨⟨1/2,0,0,0,0,0,0,0⟩, ⟨0,0,0,0,0,0,0,-1/2⟩⟩

/-- The conjugate idempotent literal `v* = (1 + i e_111)/2`. -/
def vIdemStar : ComplexOctonion := ⟨⟨1/2,0,0,0,0,0,0,0⟩, ⟨0,0,0,0,0,0,0,1/2⟩⟩

/-- **Anti-Fock 1 (kernel):** the ladder element square is NOT zero:
`omega^2 = -v`. -/
theorem omega_sq_eq_neg_vIdem : omega * omega = -vIdem := by
  ext <;>
    simp [omega, vIdem, alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **Anti-Fock 2 (kernel):** `(omega‡)^2 = -v*`. -/
theorem omegaDag_sq_eq_neg_vIdemStar : omegaDag * omegaDag = -vIdemStar := by
  ext <;>
    simp [omegaDag, vIdemStar, alpha1_dag, alpha2_dag, alpha3_dag,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **Anti-Fock 3 (kernel):** the would-be idempotent VANISHES:
`omega omega‡ = 0`. -/
theorem omega_mul_omegaDag_eq_zero : omega * omegaDag = 0 := by
  ext <;>
    simp [omega, omegaDag, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag,
      alpha3_dag, ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **Anti-Fock 4 (kernel):** `omega‡ omega = 0`. -/
theorem omegaDag_mul_omega_eq_zero : omegaDag * omega = 0 := by
  ext <;>
    simp [omega, omegaDag, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag,
      alpha3_dag, ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **The collapse (kernel): `tau_3 = 0` identically at element level** - so
every element-level `tau_3` construction is vacuous, and the faithful eq-29/31
weak sector MUST be composition operators, not element products. -/
theorem tau3_eq_zero : tau3 = 0 := by
  unfold tau3
  rw [omega_mul_omegaDag_eq_zero, omegaDag_mul_omega_eq_zero]
  ext <;> simp

end PhysicsSM.Draft.NullEdge.DixonWeakCARTau3

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.tau3_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.tau3_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.omega_mul_omegaDag_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.omega_mul_omegaDag_eq_zero
