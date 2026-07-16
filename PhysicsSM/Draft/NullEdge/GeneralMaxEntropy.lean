import PhysicsSM.Draft.NullEdge.GeneralQuantumKlein
import PhysicsSM.Draft.NullEdge.VNEntropyPurity

/-!
# General-N operator max-entropy (Gibbs) bound

Draft module (DYN-MODULAR-001 general-`N` extension). The general non-commuting
quantum Klein inequality (`GeneralQuantumKlein.qKlein_nonneg`) directly gives the
operator max-entropy / Gibbs bound at ARBITRARY finite dimension, with no
commuting or qubit restriction: for density matrices `rho` (Hermitian PSD unit
trace) and `g` (Hermitian PD unit trace), the von Neumann entropy of `rho` is at
most its cross-entropy with `g`,
`S(rho) <= -Tr(rho log g)`.

This is the general-`N` counterpart of the qubit operator-S2 entropy bound: when
`g = exp(-beta H)/Z` is the Gibbs state, `-Tr(rho log g) = beta Tr(rho H) + log Z`
and the bound becomes the free-energy / max-entropy inequality; but the raw form
here needs no such Gibbs structure -- it is exactly `S(rho||g) >= 0` rearranged
through `entropy_trace_eq_sum`.

## Scope (anti-overclaim)

This is the entropy-vs-cross-entropy bound only. It does NOT include the
equality/uniqueness characterization (`GeneralQuantumKlein.qKlein_nonneg` proves
nonnegativity, not the equality case), nor the identification of `g` with a
specific Gibbs state of a supplied generator. `rho`, `g` are displayed supplied
density matrices. No dynamics or physical interpretation is claimed.

## Trust status

Draft-trust by kernel: `vonNeumann_le_cross_entropy` is `sorry`-free and depends
only on `[propext, Classical.choice, Quot.sound]`, pinned by the `#print axioms`
guard block at the end.

## Provenance

Composition authored in-project (AFPL run 2026-07-12), assembling
`GeneralQuantumKlein.qKlein_nonneg` and `entropy_trace_eq_sum`. Clean-room
composition; no new mathematics.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GeneralMaxEntropy

open Matrix
open scoped ComplexOrder BigOperators
open PhysicsSM.Draft.NullEdge.GeneralQuantumKlein

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **General-N operator max-entropy bound.** For density matrices `rho` (PSD,
unit trace) and `g` (PD, unit trace), the von Neumann entropy is bounded by the
cross-entropy: `S(rho) <= -Tr(rho log g)`, with NO commuting/qubit restriction.
Direct consequence of the general non-commuting quantum Klein inequality. -/
theorem vonNeumann_le_cross_entropy (ρ g : Matrix n n ℂ)
    (hρ : ρ.IsHermitian) (hg : g.IsHermitian)
    (hρpsd : ρ.PosSemidef) (hgpd : g.PosDef)
    (hρtr : ρ.trace = 1) (hgtr : g.trace = 1) :
    VNEntropyPurity.vonNeumannEntropy ρ hρ
      ≤ -(ρ * logHermitian g hg).trace.re := by
  have hqre : qRelEntropy ρ g hρ hg
      = (ρ * logHermitian ρ hρ).trace.re - (ρ * logHermitian g hg).trace.re := by
    unfold qRelEntropy
    rw [Matrix.mul_sub, Matrix.trace_sub, Complex.sub_re]
  have hk := qKlein_nonneg ρ g hρ hg hρpsd hgpd hρtr hgtr
  rw [hqre, entropy_trace_eq_sum ρ hρ] at hk
  have hnml : VNEntropyPurity.vonNeumannEntropy ρ hρ
      = -∑ i, (hρ.eigenvalues i) * Real.log (hρ.eigenvalues i) := by
    unfold VNEntropyPurity.vonNeumannEntropy
    rw [← Finset.sum_neg_distrib]
    exact Finset.sum_congr rfl (fun i _ => by rw [Real.negMulLog]; ring)
  rw [hnml]
  linarith

/-- Forward half of the Klein equality case: the quantum relative entropy of a
state with itself is zero. (The hard converse -- `qRelEntropy rho sigma = 0
=> rho = sigma`, giving full general-N max-entropy uniqueness -- is the pending
`GeneralKleinEquality` successor.) -/
theorem qRelEntropy_self_eq_zero (ρ : Matrix n n ℂ) (hρ : ρ.IsHermitian) :
    GeneralQuantumKlein.qRelEntropy ρ ρ hρ hρ = 0 := by
  unfold GeneralQuantumKlein.qRelEntropy
  simp [sub_self]

end PhysicsSM.Draft.NullEdge.GeneralMaxEntropy

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only.
/--
info: 'PhysicsSM.Draft.NullEdge.GeneralMaxEntropy.vonNeumann_le_cross_entropy' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GeneralMaxEntropy.vonNeumann_le_cross_entropy
