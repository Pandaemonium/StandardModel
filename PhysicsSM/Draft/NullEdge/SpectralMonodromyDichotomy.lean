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
Recovered from Aristotle project `8066248d-d28b-4262-ab65-94a0696a893c`; proof bodies verified locally
under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.SpectralMonodromyDichotomy

open Complex

/-- The `k`-th eigenvalue sheet of the cube-root spectral cover. -/
noncomputable def sheet (k : Fin 3) (θ : ℝ) : ℂ :=
  Complex.exp (Complex.I * ((θ + 2 * Real.pi * (k : ℕ)) / 3 : ℝ))

/-- The explicit companion carrier of the family `λ³ - z`. -/
def companion (z : ℂ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![0, 0, z; 1, 0, 0; 0, 1, 0]

/-- Target 1: each sheet is continuous in the family parameter. -/
theorem sheet_continuous (k : Fin 3) : Continuous (sheet k) := by
  exact Complex.continuous_exp.comp <| by continuity;

/-- Target 2: each sheet is a cube root of the family parameter phase. -/
theorem sheet_is_root (k : Fin 3) (θ : ℝ) :
    (sheet k θ) ^ 3 = Complex.exp (Complex.I * (θ : ℝ)) := by
  rw [ sheet, ← Complex.exp_nat_mul ];
  convert Complex.exp_periodic.int_mul ( k : ℤ ) _ using 2 ; push_cast ; ring

/-- Target 3: the sheets are eigenvalues of the explicit companion carrier:
its characteristic determinant is `λ³ - z`. -/
theorem sheet_companion_eigenvalue (z lam : ℂ) :
    Matrix.det (lam • (1 : Matrix (Fin 3) (Fin 3) ℂ) - companion z) =
      lam ^ 3 - z := by
  unfold companion; simp +decide [ Matrix.det_fin_three ] ; ring;

/-- Target 4: the three sheets are pairwise distinct at every parameter. -/
theorem sheets_distinct (θ : ℝ) {k l : Fin 3} (hkl : k ≠ l) :
    sheet k θ ≠ sheet l θ := by
  unfold sheet;
  rw [ Ne.eq_def, Complex.exp_eq_exp_iff_exists_int ];
  norm_num [ Complex.ext_iff ];
  intro x hx
  fin_cases k <;> fin_cases l <;> norm_num at * <;>
    rcases x with ⟨_ | _ | x⟩ <;> norm_num at * <;> nlinarith [Real.pi_pos]

/-- Target 5: the exact Z₃ monodromy — after one loop of the family
parameter, each sheet lands on the next sheet's starting value. -/
theorem monodromy_three_cycle (k : Fin 3) :
    sheet k (2 * Real.pi) = sheet (k + 1) 0 := by
  unfold sheet
  fin_cases k
  all_goals simp only [Fin.val_add, Fin.val_one]
  all_goals push_cast
  all_goals ring_nf
  all_goals norm_num [Complex.ext_iff, Complex.exp_re, Complex.exp_im, mul_two]

/-- Target 6: the Hermitian no-go.  Strictly ordered real eigenvalue paths
cannot braid: if the loop closes the spectrum as a set via the permutation
`σ` (`f i 1 = f (σ i) 0` for all `i`), the permutation is the identity. -/
theorem ordered_real_paths_no_monodromy {n : ℕ} (f : Fin n → ℝ → ℝ)
    (horder : ∀ (i j : Fin n), i < j → ∀ t ∈ Set.Icc (0 : ℝ) 1,
      f i t < f j t)
    (σ : Equiv.Perm (Fin n))
    (hclose : ∀ i : Fin n, f i 1 = f (σ i) 0) :
    σ = Equiv.refl (Fin n) := by
  -- Step 1: the closing permutation is strictly monotone, because both
  -- endpoints of the paths are strictly ordered.
  have h_strict_mono : StrictMono σ := by
    intro i j hij
    refine lt_of_le_of_ne (le_of_not_gt fun h => by
      linarith [horder _ _ hij 1 (by norm_num), horder _ _ h 0 (by norm_num),
        hclose i, hclose j]) (fun h => hij.ne (σ.injective h))
  -- Step 2: its inverse is strictly monotone as well.
  have hinv : StrictMono (σ.symm) := by
    intro a b hab
    by_contra hc
    push_neg at hc
    rcases lt_or_eq_of_le hc with hlt | heq
    · exact absurd (h_strict_mono hlt) (by
        simp only [Equiv.apply_symm_apply, not_lt]; exact le_of_lt hab)
    · simp [σ.symm.injective heq] at hab
  -- Step 3: a strictly monotone self-bijection of `Fin n` is the identity.
  ext i
  refine le_antisymm ?_ h_strict_mono.le_apply
  have := hinv.le_apply (x := σ i)
  simpa using this

end PhysicsSM.Draft.NullEdge.SpectralMonodromyDichotomy

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SpectralMonodromyDichotomy.monodromy_three_cycle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpectralMonodromyDichotomy.monodromy_three_cycle

/-- info: 'PhysicsSM.Draft.NullEdge.SpectralMonodromyDichotomy.ordered_real_paths_no_monodromy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpectralMonodromyDichotomy.ordered_real_paths_no_monodromy
