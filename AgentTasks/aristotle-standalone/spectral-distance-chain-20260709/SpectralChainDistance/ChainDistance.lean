import Mathlib

/-!
# Finite spectral distance on an (n+1)-point causal chain

Escalation target for the null-edge program's operator-to-geometry lane.  The
landed two-point witness (`SuiteAOp2Geom`, in the parent repository) proves
`dCausal m 0 1 = 1/m` for a single Krein pair.  This package asks for the
n-point chain: the finite Connes/Lipschitz distance on a nearest-neighbor
chain with local scales `m k` equals the weighted geodesic
`sum_{k in [i,j)} 1/(m k)`.

## Convention (edge-doubled Dirac operator)

The Lipschitz condition `LipschitzOnChain` is the finite Connes condition
`‖[D, f]‖ ≤ 1` for the EDGE-DOUBLED Dirac operator `D = ⊕_k (m k) • σ_x`,
where each edge `k` carries its own 2-dimensional block on which a function
`f` acts as `diag (f k, f (k+1))`.  The commutator is then block diagonal and
the block for edge `k` is `(m k * (f (k+1) - f k)) • !![0,1;-1,0]`, whose
operator norm is `m k * |f (k+1) - f k|`; the target
`edge_commutator_block` records that identity so the Lipschitz set is honestly
spectral, not a relabeled definition.  (For the NON-doubled tridiagonal Dirac
operator the Connes distance is known to receive corrections beyond nearest
neighbors — Iochum-Krajewski-Martinetti 2001 — so this package deliberately
uses the edge-doubled operator, and says so.)

## Targets

1. `lipschitz_le_chainDist` — every chain-Lipschitz function is bounded by the
   weighted geodesic (telescoping bound).
2. `chainDist_lipschitz` and `chainDist_isGreatest` — the geodesic profile is
   itself chain-Lipschitz and attains the bound, so the distance IS the
   weighted geodesic (`IsGreatest` packaging).
3. `chainDist_add` — geodesic additivity along the chain (finite triangle
   EQUALITY, the order/metric compatibility statement).
4. `chainDist_scale` — conformal/scale covariance: rescaling every local mass
   by `c > 0` rescales every distance by `1/c` (mass scale = inverse length
   scale, the finite Malament split's scale half).
5. `edge_commutator_block` — the 2x2 edge-block commutator identity grounding
   the Lipschitz condition in an actual Dirac commutator.
6. `chainDist_witness` — exact rational three-point witness: scales `3, 5`
   give `d(0,2) = 8/15`.

Do not weaken the statements.  Helper lemmas are welcome.  Run the narrow
check `lake env lean SpectralChainDistance/ChainDistance.lean` rather than a
full build.
-/

namespace SpectralChainDistance

open Finset

/-- Per-edge Lipschitz constraint: `f` moves by at most `1 / m k` across edge
`k`.  This is `‖[D, f]‖ ≤ 1` for the edge-doubled Dirac operator described in
the module docstring. -/
def LipschitzOnChain (m : ℕ → ℝ) (f : ℕ → ℝ) : Prop :=
  ∀ k, |f (k + 1) - f k| ≤ 1 / m k

/-- The weighted geodesic length from point `i` to point `j` along the chain:
each edge contributes its inverse local scale. -/
noncomputable def chainDist (m : ℕ → ℝ) (i j : ℕ) : ℝ :=
  ∑ k ∈ Finset.Ico i j, 1 / m k

/-- Target 1: the telescoping bound.  Every chain-Lipschitz function is
bounded between points `i ≤ j` by the weighted geodesic. -/
theorem lipschitz_le_chainDist (m f : ℕ → ℝ) (hf : LipschitzOnChain m f)
    {i j : ℕ} (hij : i ≤ j) :
    |f j - f i| ≤ chainDist m i j := by
  sorry

/-- Target 2a: the geodesic profile `i ↦ chainDist m 0 i` is itself
chain-Lipschitz once every local scale is positive. -/
theorem chainDist_lipschitz (m : ℕ → ℝ) (hm : ∀ k, 0 < m k) :
    LipschitzOnChain m (fun i => chainDist m 0 i) := by
  sorry

/-- Target 2b: the finite spectral distance IS the weighted geodesic: the
geodesic value is the greatest displacement any chain-Lipschitz function can
achieve from `i` to `j`. -/
theorem chainDist_isGreatest (m : ℕ → ℝ) (hm : ∀ k, 0 < m k)
    {i j : ℕ} (hij : i ≤ j) :
    IsGreatest {d : ℝ | ∃ f : ℕ → ℝ, LipschitzOnChain m f ∧ d = f j - f i}
      (chainDist m i j) := by
  sorry

/-- Target 3: geodesic additivity — the finite triangle equality along the
ordered chain. -/
theorem chainDist_add (m : ℕ → ℝ) {i j l : ℕ} (hij : i ≤ j) (hjl : j ≤ l) :
    chainDist m i l = chainDist m i j + chainDist m j l := by
  sorry

/-- Target 4: conformal/scale covariance.  Rescaling every local mass by
`c > 0` rescales every distance by `1 / c`. -/
theorem chainDist_scale (m : ℕ → ℝ) (c : ℝ) (i j : ℕ) :
    chainDist (fun k => c * m k) i j = (1 / c) * chainDist m i j := by
  sorry

/-- Target 5: the edge-block Dirac commutator identity.  On edge `k` the
commutator of the block Dirac operator with the multiplication operator is
exactly the antisymmetric block scaled by `m k * (f (k+1) - f k)`, whose
operator norm is `m k * |f (k+1) - f k|`.  This grounds `LipschitzOnChain`
as a genuine `‖[D, f]‖ ≤ 1` condition. -/
theorem edge_commutator_block (m f : ℕ → ℝ) (k : ℕ) :
    (m k • !![(0 : ℝ), 1; 1, 0]) * !![f k, 0; 0, f (k + 1)]
        - !![f k, 0; 0, f (k + 1)] * (m k • !![(0 : ℝ), 1; 1, 0])
      = (m k * (f (k + 1) - f k)) • !![0, 1; -1, 0] := by
  sorry

/-- Target 6: exact rational witness.  Local scales `3` then `5` give the
two-edge distance `1/3 + 1/5 = 8/15`. -/
theorem chainDist_witness :
    chainDist (fun k => if k = 0 then (3 : ℝ) else 5) 0 2 = 8 / 15 := by
  sorry

end SpectralChainDistance
