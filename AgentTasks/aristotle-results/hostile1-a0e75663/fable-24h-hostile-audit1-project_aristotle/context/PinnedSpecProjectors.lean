/-
# Deliverable 2 (part 3c) — the spectral projectors are genuine (structural)

Companion Lean file for `PINNED_STABILITY_DESIGN.md`.  Certifies that the
projectors of `Pinned.SectorDefs` used to define the sector-resolved index are
genuine orthogonal spectral projectors onto `ker(W-ε)`.  Proved **structurally**
(matrix algebra) from the landed isometry/intertwining facts plus the exact
`4×4` involution of the fixed-leg compression — no heavy `native_decide` on the
full `8×8` expressions.

* general `B`-compression projector lemma `bproj_spectral`;
* general involution projector lemma `invproj_spectral`;
* instantiations: `eigProj13_is_spectral` (protected singletons, rank `2`),
  `eigProj02_is_spectral` (blind singletons, rank `2`),
  `eigProjW_is_spectral` (blocks, rank `4`).

Draft-trust disclosure: only the small `4×4` involution facts
(`Mfix_involution`, `Mfix0_involution`) use `native_decide`; everything else is
kernel-only.
-/
/-
Provenance: Aristotle job 573430f4 harvest (statements) + local Fable
proofs for the two abstract projector lemmas (2026-07-11, 24h run;
elementary ring algebra closed locally per the local-first policy).
Statements UNCHANGED from the harvest; import rewires only.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.HalfPeriodInvariant
import PhysicsSM.Draft.NullEdge.PinnedMirrorChart
import PhysicsSM.Draft.NullEdge.PinnedSectorDefs

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved

open Matrix
open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
open PhysicsSM.Draft.NullEdge.HalfPeriodInvariant

/-! ## 1.  Exact `4×4` involution of the fixed-leg compressions (cheap `native_decide`) -/

/-- The `{1,3}`-fixed-leg compression is an involution on protected fields. -/
theorem Mfix_involution : ∀ b, protectedField b = true → Mfix b * Mfix b = 1 := by native_decide

/-- The `{0,2}`-fixed-leg compression is an involution on mirror-protected fields. -/
theorem Mfix0_involution : ∀ b, mirrorProtected b = true → Mfix0 b * Mfix0 b = 1 := by native_decide

/-! ## 2.  General structural projector lemmas -/

/-- **`B`-compression spectral projector.**  If `B` is an isometry
(`Bᵀ B = 1`), `W B = B M`, `M` is an involution (`M M = 1`) and self-adjoint
(`Mᵀ = M`), then for `ε² = 1` the operator `P = ½·B(1 + εM)Bᵀ` is an orthogonal
projection annihilated by `W - ε`, with `tr P = ½(k + ε·tr M)`. -/
theorem bproj_spectral {m : Type*} [Fintype m] [DecidableEq m] {k : ℕ}
    (W : Matrix m m ℚ) (B : Matrix m (Fin k) ℚ) (M : Matrix (Fin k) (Fin k) ℚ)
    (eps : ℚ) (heps : eps * eps = 1) (iso : Bᵀ * B = 1) (intw : W * B = B * M)
    (hinv : M * M = 1) (hsa : Mᵀ = M) :
    let P := (1/2 : ℚ) • (B * (1 + eps • M) * Bᵀ)
    P * P = P ∧ Pᵀ = P ∧ (W - eps • 1) * P = 0 ∧
      P.trace = (1/2 : ℚ) * ((k : ℚ) + eps * M.trace) := by
    constructor
    · -- idempotent
      have hmm : ((1 : Matrix (Fin k) (Fin k) ℚ) + eps • M) * (1 + eps • M)
          = (2 : ℚ) • (1 + eps • M) := by
        have h2 : (eps * eps) • (M * M) = (1 : Matrix (Fin k) (Fin k) ℚ) := by
          rw [heps, hinv, one_smul]
        calc ((1 : Matrix (Fin k) (Fin k) ℚ) + eps • M) * (1 + eps • M)
            = 1 + eps • M + (eps • M + (eps * eps) • (M * M)) := by
              simp only [add_mul, mul_add, one_mul, mul_one, smul_mul_assoc,
                mul_smul_comm, smul_smul, smul_add]
          _ = (2 : ℚ) • (1 + eps • M) := by rw [h2, two_smul]; abel
      show (1/2 : ℚ) • (B * (1 + eps • M) * Bᵀ) * ((1/2 : ℚ) • (B * (1 + eps • M) * Bᵀ))
          = (1/2 : ℚ) • (B * (1 + eps • M) * Bᵀ)
      rw [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
      have : B * (1 + eps • M) * Bᵀ * (B * (1 + eps • M) * Bᵀ)
          = B * ((1 + eps • M) * (Bᵀ * B) * (1 + eps • M)) * Bᵀ := by
        simp only [Matrix.mul_assoc]
      rw [this, iso, Matrix.mul_one, hmm]
      rw [Matrix.mul_smul, Matrix.smul_mul, smul_smul]
      norm_num
    constructor
    · -- symmetric
      show ((1/2 : ℚ) • (B * (1 + eps • M) * Bᵀ))ᵀ = (1/2 : ℚ) • (B * (1 + eps • M) * Bᵀ)
      rw [Matrix.transpose_smul, Matrix.transpose_mul, Matrix.transpose_mul,
        Matrix.transpose_transpose, Matrix.transpose_add, Matrix.transpose_one,
        Matrix.transpose_smul, hsa, Matrix.mul_assoc]
    constructor
    · -- annihilated by W - eps
      show (W - eps • 1) * ((1/2 : ℚ) • (B * (1 + eps • M) * Bᵀ)) = 0
      rw [Matrix.mul_smul, Matrix.sub_mul]
      have hW : W * (B * (1 + eps • M) * Bᵀ) = B * (M * (1 + eps • M)) * Bᵀ := by
        calc W * (B * (1 + eps • M) * Bᵀ) = W * B * (1 + eps • M) * Bᵀ := by
              simp only [Matrix.mul_assoc]
          _ = B * M * (1 + eps • M) * Bᵀ := by rw [intw]
          _ = B * (M * (1 + eps • M)) * Bᵀ := by simp only [Matrix.mul_assoc]
      have hE : (eps • (1 : Matrix m m ℚ)) * (B * (1 + eps • M) * Bᵀ)
          = B * (eps • (1 + eps • M)) * Bᵀ := by
        rw [Matrix.smul_mul, Matrix.one_mul, Matrix.mul_smul, Matrix.smul_mul]
      rw [hW, hE]
      have hcancel : M * ((1 : Matrix (Fin k) (Fin k) ℚ) + eps • M)
          = eps • ((1 : Matrix (Fin k) (Fin k) ℚ) + eps • M) := by
        simp only [mul_add, mul_one, mul_smul_comm, smul_smul, hinv, heps,
          smul_add]
        module
      rw [hcancel, sub_self, smul_zero]
    · -- trace
      show ((1/2 : ℚ) • (B * (1 + eps • M) * Bᵀ)).trace
          = (1/2 : ℚ) * ((k : ℚ) + eps * M.trace)
      rw [Matrix.trace_smul, smul_eq_mul]
      congr 1
      have : (B * (1 + eps • M) * Bᵀ).trace = ((1 + eps • M) * (Bᵀ * B)).trace := by
        rw [Matrix.mul_assoc, Matrix.trace_mul_comm, Matrix.mul_assoc]
      rw [this, iso, Matrix.mul_one, Matrix.trace_add, Matrix.trace_smul,
        Matrix.trace_one]
      simp [Fintype.card_fin, smul_eq_mul]

/-- **Involution spectral projector.**  If `A` is an involution (`A A = 1`) and
self-adjoint (`Aᵀ = A`), then for `ε² = 1` the operator `P = ½·(1 + εA)` is an
orthogonal projection annihilated by `A - ε`, with `tr P = ½(card m + ε·tr A)`. -/
theorem invproj_spectral {m : Type*} [Fintype m] [DecidableEq m]
    (A : Matrix m m ℚ) (eps : ℚ) (heps : eps * eps = 1)
    (hinv : A * A = 1) (hsa : Aᵀ = A) :
    let P := (1/2 : ℚ) • ((1 : Matrix m m ℚ) + eps • A)
    P * P = P ∧ Pᵀ = P ∧ (A - eps • 1) * P = 0 ∧
      P.trace = (1/2 : ℚ) * ((Fintype.card m : ℚ) + eps * A.trace) := by
    constructor
    · -- idempotent
      show (1/2 : ℚ) • ((1 : Matrix m m ℚ) + eps • A) * ((1/2 : ℚ) • ((1 : Matrix m m ℚ) + eps • A))
          = (1/2 : ℚ) • ((1 : Matrix m m ℚ) + eps • A)
      rw [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
      have hmm : ((1 : Matrix m m ℚ) + eps • A) * (1 + eps • A)
          = (2 : ℚ) • (1 + eps • A) := by
        rw [two_smul]
        simp only [add_mul, mul_add, one_mul, mul_one, smul_mul_assoc,
          mul_smul_comm, smul_smul, smul_add, hinv, heps, one_smul]
        abel
      rw [hmm, smul_smul]
      norm_num
    constructor
    · -- symmetric
      show ((1/2 : ℚ) • ((1 : Matrix m m ℚ) + eps • A))ᵀ
          = (1/2 : ℚ) • ((1 : Matrix m m ℚ) + eps • A)
      rw [Matrix.transpose_smul, Matrix.transpose_add, Matrix.transpose_one,
        Matrix.transpose_smul, hsa]
    constructor
    · -- annihilated by A - eps
      show (A - eps • 1) * ((1/2 : ℚ) • ((1 : Matrix m m ℚ) + eps • A)) = 0
      rw [Matrix.mul_smul, Matrix.sub_mul]
      have h1 : A * ((1 : Matrix m m ℚ) + eps • A) = eps • ((1 : Matrix m m ℚ) + eps • A) := by
        simp only [mul_add, mul_one, mul_smul_comm, smul_smul, hinv, heps,
          smul_add]
        module
      have h2 : (eps • (1 : Matrix m m ℚ)) * ((1 : Matrix m m ℚ) + eps • A)
          = eps • ((1 : Matrix m m ℚ) + eps • A) := by
        rw [Matrix.smul_mul, Matrix.one_mul]
      rw [h1, h2, sub_self, smul_zero]
    · -- trace
      show ((1/2 : ℚ) • ((1 : Matrix m m ℚ) + eps • A)).trace
          = (1/2 : ℚ) * ((Fintype.card m : ℚ) + eps * A.trace)
      rw [Matrix.trace_smul, smul_eq_mul, Matrix.trace_add, Matrix.trace_smul,
        Matrix.trace_one]
      simp [smul_eq_mul]

/-! ## 3.  Sign-square fact -/

theorem sgn_sq (s : Bool) : sgn s * sgn s = 1 := by cases s <;> norm_num [sgn]

/-! ## 4.  Instantiations -/

/-- **`eigProj13` is the true spectral projector on protected singletons:**
idempotent, symmetric, rank `2`, annihilated by `(W-ε)`. -/
theorem eigProj13_is_spectral (se : Bool) (b : Fin 4 → Bool) (hb : protectedSingleton b = true) :
    eigProj13 b (sgn se) * eigProj13 b (sgn se) = eigProj13 b (sgn se) ∧
    (eigProj13 b (sgn se))ᵀ = eigProj13 b (sgn se) ∧
    (Wof b - (sgn se) • 1) * eigProj13 b (sgn se) = 0 ∧
    (eigProj13 b (sgn se)).trace = 2 := by
  have hbp : protectedField b = true := by revert hb; revert b; decide
  have h := bproj_spectral (Wof b) Bfix (Mfix b) (sgn se) (sgn_sq se)
    fixedSector_isometry (fixedSector_intertwine b) (Mfix_involution b hbp)
    ((selfadj_iff_protected b).2 hbp).symm
  obtain ⟨h1, h2, h3, h4⟩ := h
  refine ⟨h1, h2, h3, ?_⟩
  simp only [eigProj13]
  rw [h4, Mfix_trace_zero b]; norm_num

/-- **`eigProj02` is the true spectral projector on blind singletons.** -/
theorem eigProj02_is_spectral (se : Bool) (b : Fin 4 → Bool) (hb : fixedSingleton b = true) :
    eigProj02 b (sgn se) * eigProj02 b (sgn se) = eigProj02 b (sgn se) ∧
    (eigProj02 b (sgn se))ᵀ = eigProj02 b (sgn se) ∧
    (Wof b - (sgn se) • 1) * eigProj02 b (sgn se) = 0 ∧
    (eigProj02 b (sgn se)).trace = 2 := by
  have hbm : mirrorProtected b = true := by revert hb; revert b; decide
  have h := bproj_spectral (Wof b) Bfix0 (Mfix0 b) (sgn se) (sgn_sq se)
    Bfix0_isometry (Bfix0_intertwine b) (Mfix0_involution b hbm)
    ((selfadj0_iff_mirrorProtected b).2 hbm).symm
  obtain ⟨h1, h2, h3, h4⟩ := h
  refine ⟨h1, h2, h3, ?_⟩
  simp only [eigProj02]
  rw [h4, Mfix0_trace_zero b]; norm_num

/-- **`eigProjW` is the true spectral projector on blocks** (rank `4`). -/
theorem eigProjW_is_spectral (se : Bool) (b : Fin 4 → Bool) (hb : isBlock b = true) :
    eigProjW b (sgn se) * eigProjW b (sgn se) = eigProjW b (sgn se) ∧
    (eigProjW b (sgn se))ᵀ = eigProjW b (sgn se) ∧
    (Wof b - (sgn se) • 1) * eigProjW b (sgn se) = 0 ∧
    (eigProjW b (sgn se)).trace = 4 := by
  obtain ⟨hinv, hsa, htr⟩ := block_involution b hb
  have h := invproj_spectral (Wof b) (sgn se) (sgn_sq se) hinv hsa.symm
  obtain ⟨h1, h2, h3, h4⟩ := h
  refine ⟨h1, h2, h3, ?_⟩
  simp only [eigProjW]
  rw [h4, htr]
  have : (Fintype.card V8 : ℚ) = 8 := by simp [V8]
  rw [this]; norm_num

end PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved
