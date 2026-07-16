# Aristotle semantic context pack

Generated: 2026-07-14T20:10:08
Query: `Null-edge celestial parity reflection preserves pairwise mass spread and conjugates Bargmann handedness`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeBargmannPhaseInvariance.lean`

Score: `0.811`

```text
import PhysicsSM.Draft.NullEdgeBargmannPhasePort

/-!
# Bargmann phase invariance

This draft module proves that the closed Bargmann/Pancharatnam product and its
rank-one projector trace are invariant under independent local unit complex
phase rescalings of the three spinor vertices.
-/
```

### 2. `PhysicsSM/Draft/NullEdge/CPTAntiparticleZigzag.lean` [concrete_conjugate_pair]

Score: `0.809`

```text
— the *same* `m` governs both orientations (`Θ D Θ = D`);
4. spectra are conjugate-paired: an eigenpair `(λ, v)` maps to `(conj λ, Θ v)` with `Θ v ≠ 0`;
5. concretely, `(1+i, (1,i,1,i))` mirrors to `(1-i, (1,-i,1,-i))`, both nonzero.

So particle/antiparticle is the *orientation* of the null-edge zigzag, and matter–antimatter
asymmetry is a state/initial-condition question, not a law asymmetry.  (Honest scope: a finite
one-carrier CPT statement, not a baryogenesis mechanism.) -/
```

### 3. `PhysicsSM/Draft/NullEdgeP2BranchOrientation.lean` [branchReflection_ne_one_on_massShell]

Score: `0.795`

```text
theorem branchReflection_ne_one_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    branchReflection h p m E ≠ (1 : RMat2) := by
  intro hcontra
  have hdet : det2 (branchReflection h p m E) = det2 (1 : RMat2) := by
    rw [hcontra]
  rw [branchReflection_det2_eq_neg_one_on_massShell h p m E hh hE0 hshell,
    det2_one] at hdet
  norm_num at hdet

end PhysicsSM.Draft.NullEdgeP2BranchOrientation

end
```

### 4. `PhysicsSM/Draft/NullEdge/CPTAntiparticleZigzag.lean` [concrete_conjugate_pair]

Score: `0.793`

```text
theorem concrete_conjugate_pair :
    (Dmat 1).mulVec ![1, Complex.I, 1, Complex.I]
        = (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] ∧
    (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 ∧
    Theta ![1, Complex.I, 1, Complex.I] = ![1, -Complex.I, 1, -Complex.I] ∧
    (Dmat 1).mulVec (Theta ![1, Complex.I, 1, Complex.I])
        = (starRingEnd ℂ (1 + Complex.I)) • Theta ![1, Complex.I, 1, Complex.I] ∧
    Theta ![1, Complex.I, 1, Complex.I] ≠ 0 := by
  have heig : (Dmat 1).mulVec ![1, Complex.I, 1, Complex.I]
      = (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] := by
    funext i; fin_cases i <;>
      simp [Dmat, Matrix.mulVec, dotProduct, Fin.sum_univ_four, Matrix.cons_val_zero,
        Matrix.cons_val_one, Matrix.cons_val, Complex.ext_iff]
  have hne : (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 := by
    intro h
    have := congrArg (fun f => f 0) h
    simp at this
  have hmir : Theta ![1, Complex.I, 1, Complex.I] = ![1, -Complex.I, 1, -Complex.I] := by
    crunch
  -- eigenvalue on the mirror is the conjugate, via the general theorem with m = 1
  have hspec := (spectrum_conjugate_paired 1 (1 + Complex.I) ![1, Complex.I, 1, Complex.I] hne
    (by simpa using heig))
  refine ⟨heig, hne, hmir, ?_, hspec.2⟩
  simpa using hspec.1

/-! ## Target 4: the antiparticle verdict -/

/-- **`antiparticle_verdict`.**  Matter and antimatter are the two CPT-orientations of the
*same* null-edge (Weyl) pair:

1. `Theta` is an antiunitary involution (CPT);
2. `Theta` is chirality-odd, i.e. CPT swaps the two null Weyl pieces of the zigzag;
3. the mass coupling is CPT-even — the *same* `m` governs both orientations (`Θ D Θ = D`);
4. spectra are conjugate-paired: an eigenpair `(λ, v)` maps to `(conj λ, Θ v)` with `Θ v ≠ 0`;
5. concretely, `(1+i, (1,i,1,i))` mirrors to `(
```

### 5. `AgentTasks/context-packs/unitary-checkerboard-transfer-20260710-20260710-015011.md` [Bargmann phase invariance]

Score: `0.791`

```text
# Bargmann phase invariance

This draft module proves that the closed Bargmann/Pancharatnam product and its
rank-one projector trace are invariant under independent local unit complex
phase rescalings of the three spinor vertices.
-/
```
```

### 6. `PhysicsSM/Draft/NullEdge/PinnedControlAndBlind.lean` [mirror_modes]

Score: `0.789`

```text
theorem mirror_modes (b : Fin 4 → Bool) (hb : mirrorProtected b = true) :
    (∃ V : V8 → ℂ, V ≠ 0 ∧ (toC (Wof b)).mulVec V = -V) ∧
    (∃ V : V8 → ℂ, V ≠ 0 ∧ (toC (Wof b)).mulVec V = V) := by
  have ic := involutiveCompression0_of_mirror b hb
  refine ⟨?_, ?_⟩
  · exact involutive_compression_flip_mode ic
      (fun h => Mfix0_ne_one b (toC_injective (by rw [h, toC_one])))
  · exact involutive_compression_fixed_mode ic
      (fun h => Mfix0_ne_neg_one b (toC_injective (by rw [toC_neg, toC_one, h])))

end PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved
```

### 7. `PhysicsSM/Draft/NullEdge/PinnedSectorDefs.lean` [parityProj]

Score: `0.789`

```text
def parityProj (R : Matrix V8 V8 ℚ) (r : ℚ) : Matrix V8 V8 ℚ :=
  (1/2 : ℚ) • ((1 : Matrix V8 V8 ℚ) + r • R)

end PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved
```

### 8. `PhysicsSM/Draft/NullEdgeP2BranchReflection.lean` [branchReflection_sq_eq_one_on_massShell]

Score: `0.788`

```text
theorem branchReflection_sq_eq_one_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    branchReflection h p m E * branchReflection h p m E = (1 : RMat2) := by
  calc
    branchReflection h p m E * branchReflection h p m E =
        positiveBranch h p m E * positiveBranch h p m E
          - positiveBranch h p m E * negativeBranch h p m E
          - negativeBranch h p m E * positiveBranch h p m E
          + negativeBranch h p m E * negativeBranch h p m E := by
            rw [branchReflection]
            noncomm_ring
    _ = positiveBranch h p m E + negativeBranch h p m E := by
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.positiveBranch_idempotent_on_massShell h p m E hh hE0 hshell]
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.positive_mul_negative_eq_zero_on_massShell h p m E hh hE0 hshell]
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.negative_mul_positive_eq_zero_on_massShell h p m E hh hE0 hshell]
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.negativeBranch_idempotent_on_massShell h p m E hh hE0 hshell]
      simp
    _ = (1 : RMat2) :=
      PhysicsSM.Draft.NullEdgeP2BranchResolution.positive_add_negative_eq_one h p m E

/-- The branch reflection commutes with its Hamiltonian generator. -/
```

## Scoped paper hits

No paper hits returned.
