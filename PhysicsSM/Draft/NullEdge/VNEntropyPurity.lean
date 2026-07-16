import Mathlib

/-!
# Von Neumann entropy >= -log(purity): the operator Renyi-2 bound

Draft module. Matrix capstone of the finite resource hierarchy: connects the
landed `VonNeumannEntropyBound` (`S(rho) <= log d`) and `PurityBounds`
(`1/d <= Tr(rho^2) <= 1`) at the operator level. For a density matrix `rho`
(Hermitian, PSD, unit trace), the von Neumann entropy
`S(rho) = sum_i negMulLog(lambda_i)` is at least `-log(purity)` where the purity
is `Tr(rho^2) = sum_i lambda_i^2`. Equivalently `S(rho) >= H_2(rho)` (Renyi-2 /
collision entropy), the operator lift of the classical `collision_le_shannon`
(`CollisionShannonEntropy`). CFC-free: everything is expressed through the
eigenvalue vector.

## Scope (anti-overclaim)

Finite algebraic spectral inequality over an arbitrary density matrix; the
entropy and purity are the genuine spectral functionals (`IsHermitian.eigenvalues`).
No dynamics, channel, continuum limit, or physical Hilbert-space interpretation
is claimed. This is the operator-level order-monotonicity `H_1 >= H_2` of the
Renyi hierarchy for a single finite density matrix.

## Trust status

Draft-trust by kernel: `vonNeumann_ge_neg_log_purity` is `sorry`-free and depends
only on `[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12, DYN-MODULAR resource
hierarchy). Proof search by Aristotle (project
`2546eaa9-456a-4388-a5c7-75d426b9f9b7`), then independently re-checked in this
repo (`lake env lean`; axiom footprint confirmed kernel-only). Route: the
eigenvalues `p i = hrho.eigenvalues i` form a probability vector
(`Matrix.PosSemidef.eigenvalues_nonneg`;
`Matrix.IsHermitian.trace_eq_sum_eigenvalues` with unit trace gives
`sum p_i = 1`); the goal is then the classical `-log(sum p_i^2) <= sum
negMulLog(p_i)`, Jensen's inequality for the convex `-Real.log` on `Ioi 0` with
weights and points `p_i`, restricted to the support (`0 * log 0 = 0` convention
for zero-probability atoms). Clean-room formalization from the mathematical
statement.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.VNEntropyPurity

open Matrix
open scoped ComplexOrder BigOperators

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Von Neumann entropy `sum_i negMulLog(lambda_i)`. -/
def vonNeumannEntropy (ρ : Matrix n n ℂ) (hρ : ρ.IsHermitian) : ℝ :=
  ∑ i, Real.negMulLog (hρ.eigenvalues i)

/-- Purity `Tr(rho^2) = sum_i lambda_i^2`. -/
def purity (ρ : Matrix n n ℂ) (hρ : ρ.IsHermitian) : ℝ :=
  ∑ i, (hρ.eigenvalues i) ^ 2

/-- **Von Neumann entropy >= -log(purity).**  The operator Renyi-2 bound: von
Neumann entropy dominates minus the log of the purity. -/
theorem vonNeumann_ge_neg_log_purity [Nonempty n] (ρ : Matrix n n ℂ)
    (hρ : ρ.IsHermitian) (hpsd : ρ.PosSemidef) (htr : ρ.trace = 1) :
    - Real.log (purity ρ hρ) ≤ vonNeumannEntropy ρ hρ := by
  -- By definition of $purity$, we have $purity ρ hρ = ∑ i, (hρ.eigenvalues i) ^ 2$.
  unfold purity vonNeumannEntropy;
  -- Let $p_i = hρ.eigenvalues i$.
  set p : n → ℝ := fun i => hρ.eigenvalues i;
  -- Since $p_i$ are non-negative and sum to 1, we can apply Jensen's inequality.
  have h_jensen : -Real.log (∑ i, p i ^ 2) ≤ ∑ i, p i * (-Real.log (p i)) := by
    have h_support : -Real.log (∑ i ∈ Finset.univ.filter (fun i => p i ≠ 0), p i ^ 2) ≤ ∑ i ∈ Finset.univ.filter (fun i => p i ≠ 0), p i * (-Real.log (p i)) := by
      have h_support : -Real.log (∑ i ∈ Finset.univ.filter (fun i => p i ≠ 0), p i * p i) ≤ ∑ i ∈ Finset.univ.filter (fun i => p i ≠ 0), p i * (-Real.log (p i)) := by
        have h_convex : ConvexOn ℝ (Set.Ioi 0) (fun x : ℝ => -Real.log x) := by
          exact ( StrictConcaveOn.concaveOn <| strictConcaveOn_log_Ioi ) |> ( fun h => h.neg )
        convert h_convex.map_sum_le _ _ _ <;> norm_num;
        · exact fun i hi => hpsd.eigenvalues_nonneg i;
        · have h_sum : ∑ i, p i = 1 := by
            convert congr_arg Complex.re htr using 1;
            have := hρ.trace_eq_sum_eigenvalues;
            exact this ▸ by norm_cast;
          rw [ ← h_sum, Finset.sum_filter_of_ne ] ; aesop;
        · exact fun i hi => lt_of_le_of_ne ( hpsd.eigenvalues_nonneg i ) ( Ne.symm hi );
      simpa only [ sq ] using h_support;
    convert h_support using 1; all_goals rw [ Finset.sum_filter_of_ne ] ; aesop;
  convert h_jensen using 2 ; norm_num [ Real.negMulLog ] ; ring

end PhysicsSM.Draft.NullEdge.VNEntropyPurity

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.VNEntropyPurity.vonNeumann_ge_neg_log_purity' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.VNEntropyPurity.vonNeumann_ge_neg_log_purity
