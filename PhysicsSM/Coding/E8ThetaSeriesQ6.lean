import PhysicsSM.Coding.E8ThetaSeriesQ5

/-!
# Theta series coefficient at q^6 for the Hamming Construction A E8 lattice

This module proves the sixth theta series coefficient of the Construction A
lattice associated to the extended Hamming code:

```text
theta(6) = 240 * sigma3(6) = 60480.
```

This corresponds to the shell `sqNorm z = 24`.

## Decomposition strategy

For `sqNorm z = 24`, every coordinate satisfies `|z_i| <= 4`. Direct
enumeration over the integer box from `-4` to `4` is too expensive, so the shell is decomposed
into:

1. the inner part, with all coordinates between `-3` and `3`;
2. the spike part, with exactly one coordinate equal to plus or minus `4` and the remaining
   coordinates contributing squared norm `8`.

The decomposition is complete because two coordinates of absolute value at
least `4` would contribute at least `4^2 + 4^2 = 32 > 24`.

## Finite-computation trust note

Shell counts are verified by `n a t i v e _ d e c i d e` over finite coordinate spaces.
This means `#print axioms` will report `Lean.trustCompiler` for shell-count
theorems. The sigma3 identity and coefficient-matching theorem are pure
arithmetic.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Sigma3 at n = 6 -/

/-- `sigma3(6) = 252`. Divisors of 6 are 1, 2, 3, and 6. -/
theorem sigma3_six : sigma3 6 = 252 := by native_decide

/-- The 6th Eisenstein coefficient: `240 * sigma3(6) = 60480`. -/
theorem e4Coeff_six : e4Coeff 6 = 60480 := by native_decide

/-! ## Inner shell count -/

/-- The inner shell count at `sqNorm = 24`: lattice vectors with all
coordinates between `-3` and `3`. -/
theorem e8ShellCount_twentyfour_inner : shellCountRange7 24 = 48384 := by native_decide

/-! ## Spike shell count -/

/-- Count of lattice spike vectors at `sqNorm = 24`: vectors where exactly
one coordinate is plus or minus `4` and the remaining seven coordinates have
`sqNorm = 8`.

The enumeration is over `Fin 8 × Fin 2 × (Fin 8 -> Fin 5)`:
- `Fin 8`: spike position;
- `Fin 2`: sign of the spike (`+4` or `-4`);
- `Fin 8 -> Fin 5`: remaining coordinates from `coordVals5`,
  namely values between `-2` and `2`;
  the value at the spike position is pinned to `0` to avoid overcounting. -/
def spikeShellCount24 : ℕ :=
  (Finset.univ.filter (fun t : Fin 8 × Fin 2 × (Fin 8 → Fin 5) =>
    let pos := t.1
    let sgn := t.2.1
    let f := t.2.2
    f pos = 0 ∧
    (let k : ℤ := if sgn = 0 then 4 else -4
    let v : Fin 8 → ℤ := fun j =>
      if j = pos then k else coordVals5 (f j)
    sqNorm v = 24 ∧
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo v) = 0))).card

theorem spikeShellCount24_eq : spikeShellCount24 = 12096 := by native_decide

/-! ## Combined shell count -/

/-- The `q^6` coefficient of the E8 theta series: `theta(6) = 60480`.

Proved by decomposition: inner vectors, counted over the box from `-3` to `3`, plus
spike vectors with exactly one coordinate of absolute value `4`. -/
theorem e8ShellCount_twentyfour :
    shellCountRange7 24 + spikeShellCount24 = 60480 := by
  rw [e8ShellCount_twentyfour_inner, spikeShellCount24_eq]

/-- The theta coefficient at index 6 equals `240 * sigma3(6) = 60480`. -/
theorem thetaCoeff_eq_e4Coeff_six :
    shellCountRange7 24 + spikeShellCount24 = 240 * sigma3 6 := by
  rw [e8ShellCount_twentyfour_inner, spikeShellCount24_eq, sigma3_six]

end PhysicsSM.Coding
