# Summary of changes for run 1a1bd25e-17dc-4269-966c-3ad6c730c482
Delivered a kernel-checked finite interacting two-body bound state strictly below threshold, in the new file `src/InteractingTwoBody.lean` (builds clean via `lake build`; zero `sorry`; the flagship theorem's `#print axioms` guard confirms only `propext`, `Classical.choice`, `Quot.sound`).

## What was built

**The interacting Hamiltonian (explicit finite types).** For `N = 3` one-particle modes with energies `d : Fin 3 → ℝ`, the two-particle sector `Λ²(sector)` is `C(3,2)=3`-dimensional, with occupation basis the three pairs `{0,1},{0,2},{1,2}` (indices `0,1,2`). Concretely:
- `freeH2 d : Matrix (Fin 3) (Fin 3) ℝ := Matrix.diagonal (pairEnergy d)` — the free `dΓ(B)|_{Λ²}`, diagonal of pair energies `d0+d1, d0+d2, d1+d2`.
- `interaction kappa := !![0,-kappa,0; -kappa,0,0; 0,0,0]` — an attractive rank-one/local coupling of strength `κ` between the two lowest pairs (those sharing the lowest mode `0`); it is proved real-symmetric/Hermitian (`interaction_isHermitian`).
- `H2 d kappa := freeH2 d + interaction kappa`, proved Hermitian (`H2_isHermitian`).
- `pairThreshold d := min (d0+d1) (min (d0+d2) (d1+d2))` — the free threshold `min_{i≠j}(d i + d j)`.
- `spectrum2 d kappa := {μ | ∃ v ≠ 0, (H2 d kappa).mulVec v = μ • v}` — the eigenvalue set.

**The theorem (the real content).** `interacting_boundState_below_threshold`: for a sorted spectrum `d 0 ≤ d 1 ≤ d 2` and `κ > 0`,
`IsLeast (spectrum2 d κ) (boundEnergy d κ) ∧ boundEnergy d κ < pairThreshold d`,
where `boundEnergy d κ = (a+c)/2 - sqrt((a-c)²/4 + κ²)` with `a=d0+d1`, `c=d0+d2` — the smaller root of the attractive `2×2` block. So the least eigenvalue is a genuine `IsLeast` of the spectrum AND lies strictly below the sum of the constituents. The strictness is driven exactly by `κ > 0` (`boundEnergy_lt_pairThreshold`). The route was a direct small-matrix computation: the bound state is exhibited via an explicit eigenvector (`boundEnergy_mem_spectrum`), and the least-eigenvalue lower bound comes from `det(H₂ - μ) = 0` (via `Matrix.exists_mulVec_eq_zero_iff` + `Matrix.det_fin_three`) factoring as `(e-μ)((a-μ)(c-μ)-κ²)=0`, with a completing-the-square argument giving every root `≥ boundEnergy` (`boundEnergy_lower_bound`). This sidesteps the missing Mathlib min-max/variational packaging flagged as the blocker.

**Semantic honesty (hadron vs. toy).** Documented in the module header:
- Grade **M** (earned matrix/spectral fact): the below-threshold bound state is a kernel-checked eigenvalue computation, with no hand-inserted binding defect (unlike the seeded `twoBody_bound_below_threshold` in `FockMassGap.lean`).
- Grade **C** (the physical *hadron* identification is a claim, not earned): the interaction `V` is *modelled* on the carrier's closure strength — its scale is `κ`, matching the block-level binding defect `Δ = -κ` — but its rank-one attractive *form* is inserted, not derived from the carrier's closure geometry. So this is an honest finite witness that "an attractive interaction of the closure scale produces a bound state strictly below the sum of constituents", and not yet a first-principles derivation of a hadron mass from the null-transport geometry.

The companion `src/FockMassGap.lean` (the free second-quantized gap) is unchanged and still builds.
