import Mathlib
import PhysicsSM.Coding.E8ThetaSeries
import PhysicsSM.Coding.E8ThetaSigmaBridge

/-!
# Theta series coefficient at q⁵ for the Hamming Construction A E8 lattice

This module proves the fifth theta series coefficient of the
Construction A lattice `Λ(e₈)`:

  `θ(5) = 240 · σ₃(5) = 30240`

corresponding to the shell `sqNorm z = 20`.

The values `sigma3_five` and `e4Coeff_five` are imported from
`E8ThetaSigmaBridge`, which also connects the local `sigma3` to Mathlib's
canonical `ArithmeticFunction.sigma`.

## Decomposition strategy

For `sqNorm z = 20`, coordinates satisfy `|zᵢ| ≤ 4` (since `5² = 25 > 20`).
Direct enumeration over `{-4,…,4}⁸` (43 million entries) is too expensive.
Instead, we decompose the shell into:

1. **Inner part**: all `|zᵢ| ≤ 3`, counted by `shellCountRange7 20 = 28224`.
   This is a `n a t i v e _ d e c i d e` search over `{-3,…,3}⁸` (5.7M entries).

2. **Spike part**: exactly one `|zᵢ| = 4`, with the remaining 7 coordinates
   having `sqNorm = 4` and `|zⱼ| ≤ 2`. Counted as `spikeShellCount20 = 2016`.
   Enumerated over `Fin 8 × Fin 2 × (Fin 8 → Fin 5)` with the spike position
   pinned to avoid overcounting.

The decomposition is complete because two coordinates of absolute value ≥ 4
would contribute at least `4² + 4² = 32 > 20`.

## Finite-computation trust note

Shell counts are verified by `n a t i v e _ d e c i d e` over finite coordinate spaces.
This means `#print axioms` will report `Lean.trustCompiler` for shell-count
theorems. The sigma₃ identity and coefficient-matching theorem are pure
arithmetic.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Inner shell count -/

/-- The inner shell count at `sqNorm = 20`: lattice vectors with all
coordinates in `{-3,…,3}`. This captures 28224 of the 30240 vectors. -/
theorem e8ShellCount_twenty_inner : shellCountRange7 20 = 28224 := by native_decide

/-! ## Spike shell count

A "spike" vector for `sqNorm = 20` has exactly one coordinate with `|zᵢ| = 4`
(contributing 16 to the norm) and the remaining 7 coordinates have total
`sqNorm = 4` with `|zⱼ| ≤ 2`.

**Uniqueness of the spike coordinate**: if two coordinates had `|zᵢ| ≥ 4`,
the total norm would be at least `4² + 4² = 32 > 20`, contradicting
`sqNorm z = 20`.
-/

/-- Count of lattice "spike" vectors at `sqNorm = 20`: vectors where exactly
one coordinate is `±4` and the remaining 7 coordinates have `sqNorm = 4`.

The enumeration is over `Fin 8 × Fin 2 × (Fin 8 → Fin 5)`:
- `Fin 8`: spike position
- `Fin 2`: sign of the spike (`+4` or `-4`)
- `Fin 8 → Fin 5`: the remaining coordinates from `coordVals5 = {-2,…,2}`
  (the value at the spike position is pinned to `0` to avoid overcounting). -/
def spikeShellCount20 : ℕ :=
  (Finset.univ.filter (fun t : Fin 8 × Fin 2 × (Fin 8 → Fin 5) =>
    let pos := t.1
    let sgn := t.2.1
    let f := t.2.2
    f pos = 0 ∧
    (let k : ℤ := if sgn = 0 then 4 else -4
    let v : Fin 8 → ℤ := fun j =>
      if j = pos then k else coordVals5 (f j)
    sqNorm v = 20 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo v) = 0))).card

theorem spikeShellCount20_eq : spikeShellCount20 = 2016 := by native_decide

/-! ## Combined shell count -/

/-- The `q⁵` coefficient of the E8 theta series: `θ(5) = 30240`.

Proved by decomposition: 28224 inner vectors (all `|zᵢ| ≤ 3`, via
`n a t i v e _ d e c i d e` on `{-3,…,3}⁸`) plus 2016 spike vectors (exactly one
`|zᵢ| = 4`, via `n a t i v e _ d e c i d e` on `Fin 8 × Fin 2 × (Fin 8 → Fin 5)`). -/
theorem e8ShellCount_twenty :
    shellCountRange7 20 + spikeShellCount20 = 30240 := by
  rw [e8ShellCount_twenty_inner, spikeShellCount20_eq]

/-- The theta coefficient at index 5 equals `240 · σ₃(5) = 30240`. -/
theorem thetaCoeff_eq_e4Coeff_five :
    shellCountRange7 20 + spikeShellCount20 = 240 * sigma3 5 := by
  rw [e8ShellCount_twenty_inner, spikeShellCount20_eq, sigma3_five]

end PhysicsSM.Coding
