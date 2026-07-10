import Mathlib

/-!
# Goal II finite CP phase-count arithmetic

This draft module records the finite parameter-counting part of the Goal II
Kobayashi-Maskawa lane. It is a small arithmetic anchor, not the full
constructive rephasing theorem.

The physical reading is the standard finite bookkeeping for an `N`-generation
quark mixing matrix:

* `ckmAngles N = N * (N - 1) / 2`, the real mixing-angle count.
* `ckmRemovable N = 2 * N - 1`, the quark-field rephasings modulo one common
  phase.
* `ckmPhysCP N = (N - 1) * (N - 2) / 2`, the Dirac CP-phase count.

The kernel-checked content below proves the arithmetic split and the sharp
threshold `0 < ckmPhysCP N <-> 3 <= N`. It does not yet prove that every `2 x 2`
unitary is rephasing-equivalent to a real matrix, nor does it construct the
required nonzero Jarlskog witness at `N = 3`.

Provenance: clean-room port of the Aristotle standalone seed returned by
`codex-grand-strategy-goalII-IV-suiteCD-20260709`
(`d9630630-1394-4ca7-b423-3bdeec333bcf`,
`RequestProject/GoalII_CPCount.lean`).
-/

namespace KMPhaseCounting

/-- Number of real mixing angles in the `N`-generation CKM bookkeeping. -/
def ckmAngles (N : ℕ) : ℕ := N * (N - 1) / 2

/-- Number of physical Dirac CP-violating phases in the CKM bookkeeping. -/
def ckmPhysCP (N : ℕ) : ℕ := (N - 1) * (N - 2) / 2

/-- Number of quark-field phases removable by rephasing, modulo one common phase. -/
def ckmRemovable (N : ℕ) : ℕ := 2 * N - 1

/--
The finite bookkeeping split: for `N >= 1`, the `N^2` real parameters are the
mixing angles, removable phases, and physical CP phases.
-/
theorem ckm_param_split (N : ℕ) (hN : 1 ≤ N) :
    N * N = ckmAngles N + ckmRemovable N + ckmPhysCP N := by
  unfold ckmAngles ckmRemovable ckmPhysCP
  match N, hN with
  | 1, _ => decide
  | (m + 2), _ =>
    simp only [show m + 2 - 1 = m + 1 from rfl, show m + 2 - 2 = m from rfl]
    obtain ⟨a, ha⟩ : Even ((m + 2) * (m + 1)) := by
      rw [Nat.mul_comm]
      exact Nat.even_mul_succ_self (m + 1)
    obtain ⟨b, hb⟩ : Even ((m + 1) * m) := by
      rw [Nat.mul_comm]
      exact Nat.even_mul_succ_self m
    have key : 2 * ((m + 2) * (m + 2))
        = (m + 2) * (m + 1) + (m + 1) * m + 4 * m + 6 := by
      ring
    omega

/-- The CP-phase count is positive exactly from three generations onward. -/
theorem cp_possible_iff (N : ℕ) : 0 < ckmPhysCP N ↔ 3 ≤ N := by
  unfold ckmPhysCP
  match N with
  | 0 => decide
  | 1 => decide
  | 2 => decide
  | (n + 3) =>
    simp only [show n + 3 - 1 = n + 2 from rfl, show n + 3 - 2 = n + 1 from rfl]
    obtain ⟨a, ha⟩ : Even ((n + 2) * (n + 1)) := by
      rw [Nat.mul_comm]
      exact Nat.even_mul_succ_self (n + 1)
    have hpos : 0 < (n + 2) * (n + 1) := by
      positivity
    omega

/-- Majorana neutrino CP bookkeeping: add `N - 1` Majorana phases. -/
def pmnsPhysCPMajorana (N : ℕ) : ℕ := ckmPhysCP N + (N - 1)

/-- The PMNS Majorana branch is kept as a separate definition for auditability. -/
theorem pmns_majorana_count (N : ℕ) :
    pmnsPhysCPMajorana N = ckmPhysCP N + (N - 1) := rfl

/-! ## Nondegeneracy fixtures for the arithmetic count -/

example : ckmAngles 3 = 3 := by decide
example : ckmPhysCP 3 = 1 := by decide
example : ckmPhysCP 2 = 0 := by decide
example : ckmPhysCP 1 = 0 := by decide
example : ckmPhysCP 4 = 3 := by decide
example : pmnsPhysCPMajorana 3 = 3 := by decide
example : pmnsPhysCPMajorana 2 = 1 := by decide

end KMPhaseCounting

/-! ## Axiom audit (build-enforced guard pin) -/

/-- info: 'KMPhaseCounting.ckm_param_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMPhaseCounting.ckm_param_split

/-- info: 'KMPhaseCounting.cp_possible_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMPhaseCounting.cp_possible_iff

/-- info: 'KMPhaseCounting.pmns_majorana_count' does not depend on any axioms -/
#guard_msgs (whitespace := lax) in
#print axioms KMPhaseCounting.pmns_majorana_count
