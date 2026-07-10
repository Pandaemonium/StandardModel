import Mathlib

/-!
# Spectral monodromy for generations: the honest dichotomy

Post-no-go route to generation structure.  The landed family no-gos (parent
repository: `FamilyIndexNoGo`, `FamilyRankNoGo`) show three generations are
not forced by local completion counts.  The proposed alternative is GLOBAL:
generations as sheets of a spectral cover over decoder moduli space,
permuted by monodromy.  This package pins BOTH halves of the honest
dichotomy:

* **Positive half (complexified moduli).**  The explicit family
  `charpoly = λ³ - e^{iθ}` (a companion-matrix carrier family) has three
  continuous eigenvalue sheets `λ_k(θ) = exp (i (θ + 2πk)/3)` that undergo
  an exact 3-cycle as `θ` runs `0 → 2π`: a genuine Z₃ spectral monodromy on
  an explicit finite carrier family.
* **No-go half (Hermitian loops).**  For real, everywhere-strictly-ordered
  eigenvalue paths (the Hermitian situation: distinct real eigenvalues along
  the loop), the endpoint permutation is necessarily trivial.  So
  generation-as-monodromy REQUIRES either complexified moduli loops or
  degeneracy crossings; for Hermitian families the carrier of generation
  structure must instead be eigenVECTOR (Berry) holonomy.

## Targets

1. `sheet_continuous` — each sheet `λ_k` is continuous.
2. `sheet_is_root` — each sheet satisfies `(λ_k θ)³ = e^{iθ}`.
3. `sheet_companion_eigenvalue` — the sheets are eigenvalues of the explicit
   companion carrier: `det (λ • 1 - C(e^{iθ})) = λ³ - e^{iθ}` for the 3×3
   companion matrix `C(z) = !![0,0,z; 1,0,0; 0,1,0]`.
4. `sheets_distinct` — the three sheets are pairwise distinct at every `θ`.
5. `monodromy_three_cycle` — the exact 3-cycle: `λ_k (2π) = λ_{k+1 mod 3} 0`
   for every `k`.
6. `ordered_real_paths_no_monodromy` — the Hermitian no-go: if
   `f : Fin n → ℝ → ℝ` are eigenvalue paths with `f i t < f j t` for all
   `i < j` and all `t ∈ [0,1]`, and `σ` is a permutation closing the loop
   (`f i 1 = f (σ i) 0` for all `i`), then `σ` is the identity: strictly
   ordered real spectra cannot braid.

Do not weaken the statements.  Helper lemmas welcome.  Run the narrow check
`lake env lean SpectralMonodromyDichotomy/MonodromyDichotomy.lean` first;
avoid a full lake build until the holes are closed.
-/

namespace SpectralMonodromyDichotomy

open Complex

/-- The `k`-th eigenvalue sheet of the cube-root spectral cover. -/
noncomputable def sheet (k : Fin 3) (θ : ℝ) : ℂ :=
  Complex.exp (Complex.I * ((θ + 2 * Real.pi * (k : ℕ)) / 3 : ℝ))

/-- The explicit companion carrier of the family `λ³ - z`. -/
def companion (z : ℂ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![0, 0, z; 1, 0, 0; 0, 1, 0]

/-- Target 1: each sheet is continuous in the family parameter. -/
theorem sheet_continuous (k : Fin 3) : Continuous (sheet k) := by
  sorry

/-- Target 2: each sheet is a cube root of the family parameter phase. -/
theorem sheet_is_root (k : Fin 3) (θ : ℝ) :
    (sheet k θ) ^ 3 = Complex.exp (Complex.I * (θ : ℝ)) := by
  sorry

/-- Target 3: the sheets are eigenvalues of the explicit companion carrier:
its characteristic determinant is `λ³ - z`. -/
theorem sheet_companion_eigenvalue (z lam : ℂ) :
    Matrix.det (lam • (1 : Matrix (Fin 3) (Fin 3) ℂ) - companion z) =
      lam ^ 3 - z := by
  sorry

/-- Target 4: the three sheets are pairwise distinct at every parameter. -/
theorem sheets_distinct (θ : ℝ) {k l : Fin 3} (hkl : k ≠ l) :
    sheet k θ ≠ sheet l θ := by
  sorry

/-- Target 5: the exact Z₃ monodromy — after one loop of the family
parameter, each sheet lands on the next sheet's starting value. -/
theorem monodromy_three_cycle (k : Fin 3) :
    sheet k (2 * Real.pi) = sheet (k + 1) 0 := by
  sorry

/-- Target 6: the Hermitian no-go.  Strictly ordered real eigenvalue paths
cannot braid: if the loop closes the spectrum as a set via the permutation
`σ` (`f i 1 = f (σ i) 0` for all `i`), the permutation is the identity. -/
theorem ordered_real_paths_no_monodromy {n : ℕ} (f : Fin n → ℝ → ℝ)
    (horder : ∀ (i j : Fin n), i < j → ∀ t ∈ Set.Icc (0 : ℝ) 1,
      f i t < f j t)
    (σ : Equiv.Perm (Fin n))
    (hclose : ∀ i : Fin n, f i 1 = f (σ i) 0) :
    σ = Equiv.refl (Fin n) := by
  sorry

end SpectralMonodromyDichotomy
