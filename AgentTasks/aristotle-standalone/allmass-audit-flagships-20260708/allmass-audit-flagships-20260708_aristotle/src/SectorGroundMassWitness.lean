/-
# All-mass strengthening batch 1: instantiate the keystone on a positive sector

Proof job (Aristotle). Three targets, ordered; T1 and T2 are the critical path
(they turn the mass-budget's quadratic functional into a genuine positive mass
*in a concrete finite model*), T5 is an independent cheap win.

The keystone `sector_ground_mass` is **already proved** and provided below
(clean-room from an earlier Aristotle job). Your job is to add the three
theorems T1, T2, T5 below, kernel-clean (no `s o r r y`). State them precisely;
these docstrings fix the intended mathematics.

## T1 - Sector-compression lemma  (clean Mathlib; unblocks T2)

For a finite-dimensional inner product space `E`, a submodule `K` (with its
induced inner product), and an ordinary-self-adjoint / symmetric `S : E ->L[C] E`,
the compression `T_K := (orthogonalProjection K) . S |_K : K ->L[C] K` is
symmetric on `K`, and its Rayleigh quotient agrees with that of `S` on `K \ {0}`.
Consequently `sector_ground_mass` applies to `(K, T_K)`: if the form of `S` is
`>= c > 0` on `K`, the least eigenvalue of the compression is a genuine positive
mass. Deliver the compression lemma (symmetry + Rayleigh-quotient agreement),
and a corollary chaining it into `sector_ground_mass`.

Here this is delivered as:
* `sectorCompression`      - the compression operator `K ->L[C] K`;
* `sectorCompression_isSymmetric` - symmetry;
* `sectorCompression_reApplyInnerSelf` - `reApplyInnerSelf` (hence Rayleigh
  quotient) agreement with `S`;
* `sectorCompression_sector_ground_mass` - the corollary chaining into
  `sector_ground_mass`.

## T2 - A two-edge carrier with a genuine J-positive positive-mass sector

This is the linchpin. A numeric oracle
(`Scripts/oracle/probe_multiedge_positive_sector.py`) has VALIDATED the
following construction; formalize it and prove the positivity.

Clifford factor `C^4 = C^2 (x) C^2`, Hermitian Cl(4) gammas
  g1 = sx(x)I, g2 = sy(x)I, g3 = sz(x)sx, g4 = sz(x)sy   (anticommuting, square I).
  omega := g1*g2  (= i sz (x) I)      closure bivector
  b     := g1     (= sx (x) I)        closure grading
  Js    := i*g3*g4 (= -I (x) sz)      Krein fundamental symmetry (Js^2 = I)
Color factor `C^3`; aperture strength `lam` (take `lam = 2`), curvature
  K := (E01 - E10) on C^3 (skew-Hermitian).
Blocks on `C^12 = C^4 (x) C^3`:
  Q_A := I4 (x) (lam . I3)     (aperture; Clifford-scalar)
  Q_C := omega (x) K           (closure)
  J   := Js (x) I3             (Krein metric; J = Jᴴ, J^2 = 1)
Krein forms `H_A := J * Q_A`, `H_C := J * Q_C` are Hermitian.

For this explicit representation everything is diagonal in the Clifford factor:
`Js = diag(-1,1,-1,1)`, `omega = diag(i,i,-i,-i)`, so with `lam = 2` the assembled
total Krein form `HAC := H_A + H_C = J (Q_A + Q_C)` is block-diagonal over the
four Clifford blocks, block `j` equal to `2 Js_j I3 + (Js omega)_j K`:
```
  B0 = -2 I3 - i K,  B1 = 2 I3 + i K,  B2 = -2 I3 + i K,  B3 = 2 I3 - i K.
```
`J = Js (x) I3 = diag(-1,-1,-1, 1,1,1, -1,-1,-1, 1,1,1)` has inertia `(6,6)`,
and its `+1` (J-positive) eigenspace is exactly the coordinate subspace
`{3,4,5,9,10,11}` (Clifford blocks `1` and `3`). The `12x6` isometry `Piso`
selecting those coordinates gives the compressed total form
`M6 := Pisoᴴ HAC Piso = blockdiag(B1, B3) = blockdiag(2 I3 + i K, 2 I3 - i K)`,
whose eigenvalues are `{1,3,2}` on each block, so `M6` is positive-definite with
least eigenvalue `1` (aperture dominance `lam = 2 > 1`).

Facts formalized (targets):
  (a) `HAC_isHermitian`, `Piso_isometry` (`Pisoᴴ Piso = 1`), and
      `compression_eq` (`Pisoᴴ HAC Piso = M6`): the 6-dim J-positive sector as
      an explicit `12x6` isometry with its `6x6` compressed total form. The
      Krein metric is materialized as `Jmet` with `Jmet_isHermitian`,
      `Jmet_sq` (`J² = 1`) and `Jmet_mul_Piso` (`J · Piso = Piso`), certifying
      that `Piso`'s columns are genuine `J = +1` eigenvectors (the J-positive
      sector).
  (b) `M6_posDef` : `M6.PosDef`, and `M6_sub_one_posSemidef` :
      `(M6 - 1).PosSemidef` (the `c = 1` aperture-dominance form bound), proved
      via the exact Gaussian-rational Gram witness `M6 = 1 + Bwitᴴ Bwit`.
  (c) `T2_positive_mass` : chaining (b) with `sector_ground_mass` (via the
      helper `reApplyInnerSelf_ge_of_sub_posSemidef` and
      `toEuclideanCLM_isSymmetric_of_isHermitian` that realize the compression
      T1-style on `EuclideanSpace C (Fin 6)`): the least eigenvalue of the
      compressed `D^#D`-form on the sector is a genuine positive squared mass.

## T5 - Gauge covariance of the four blocks  (independent; cheap)

Conjugating all transports by a unitary `u` that commutes with the Clifford
coefficients, the chirality `Gamma`, and the turn field `phi`, sends the
soldered operator `D` to `u D u⁻¹` and each Krein block to its `u`-conjugate:
`Q_X(u nabla u⁻¹) = u Q_X(nabla) u⁻¹` for `X in {A,C,T,#}`. Hence block
expectations in `u`-covariant states are gauge-invariant.

The abstract content (independent of the modelling names) is that conjugation by
a unitary `u` (`uᴴ u = 1`) is a `*`-algebra endomorphism preserving expectations:
it is multiplicative (the assembled square `D^#D`, a product, is carried to its
conjugate), additive (the block decomposition is preserved), sends Hermitian
Krein blocks to Hermitian blocks, and leaves every block expectation
`⟪u x, (u A uᴴ) (u x)⟫ = ⟪x, A x⟫` invariant in `u`-covariant states. This is
`gauge_covariance` below.

## Provenance

Targets + validated numeric construction: all-mass overnight run 2026-07-08,
`STRENGTHENING_ROADMAP.md` (T1/T2/T5), `T2_MULTIEDGE_ESCAPE_FINDING.md`.
`sector_ground_mass`: earlier Aristotle job 4bf9899f, re-checked under the
pinned toolchain. [orig]/[import].
-/

import Mathlib

/-!
PROJECT PROVENANCE (landed 2026-07-08). Aristotle strengthening batch-1 job
`8b3efa7c-1d11-4ff9-890e-a8d2d6c5bc12`, re-checked under the pinned toolchain.
This is the critical-path linchpin: `T2_positive_mass` instantiates
`sector_ground_mass` on the explicit two-edge Cl(4) carrier, turning the
mass-budget functional into a genuine positive squared mass IN A CONCRETE MODEL
(the numeric T2 escape of `T2_MULTIEDGE_ESCAPE_FINDING.md`, now kernel-checked).
Also lands T1 (sector compression) and T5 (gauge covariance). `sector_ground_mass`
is re-proved self-contained here (identical to `Carrier/SectorGroundMass.lean`).
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness

open ContinuousLinearMap Matrix
open scoped ComplexOrder

/-- **The keystone (already proved; provided for T1/T2 to build on).** On a
finite-dimensional sector with a definite inner product, a symmetric `T` whose
real quadratic form is bounded below by `c > 0` has its Rayleigh-quotient
infimum attained as a genuine eigenvalue that is `> 0`. -/
theorem sector_ground_mass
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] [Nontrivial H]
    (T : H →L[ℂ] H) (hT : (T : H →ₗ[ℂ] H).IsSymmetric)
    (c : ℝ) (hc : 0 < c)
    (hpos : ∀ x : H, c * ‖x‖ ^ 2 ≤ T.reApplyInnerSelf x) :
    Module.End.HasEigenvalue (T : H →ₗ[ℂ] H)
        (((⨅ x : {x : H // x ≠ 0}, T.rayleighQuotient x : ℝ)) : ℂ)
      ∧ 0 < (⨅ x : {x : H // x ≠ 0}, T.rayleighQuotient x : ℝ) := by
  haveI : Nonempty { x : H // x ≠ 0 } := by
    obtain ⟨y, hy⟩ := exists_ne (0 : H); exact ⟨⟨y, hy⟩⟩
  have hbound : c ≤ (⨅ x : {x : H // x ≠ 0}, T.rayleighQuotient x : ℝ) := by
    apply le_ciInf
    intro x
    have hx2 : (0 : ℝ) < ‖(x : H)‖ ^ 2 := by
      have := norm_ne_zero_iff.mpr x.2; positivity
    rw [ContinuousLinearMap.rayleighQuotient, le_div_iff₀ hx2]
    simpa [mul_comm] using hpos x
  exact ⟨hT.hasEigenvalue_iInf_of_finiteDimensional, lt_of_lt_of_le hc hbound⟩

/-! ## T1 - Sector-compression lemma -/

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]

/-- The compression of `S : E →L[ℂ] E` to a submodule `K` (with its induced
inner product): `T_K = (orthogonalProjection K) ∘ S|_K : K →L[ℂ] K`. -/
noncomputable def sectorCompression (K : Submodule ℂ E) [K.HasOrthogonalProjection]
    (S : E →L[ℂ] E) : K →L[ℂ] K :=
  K.orthogonalProjection ∘L (S ∘L K.subtypeL)

/--
**T1 (symmetry).** The compression of a symmetric operator to a submodule is
symmetric.
-/
theorem sectorCompression_isSymmetric (K : Submodule ℂ E) [K.HasOrthogonalProjection]
    {S : E →L[ℂ] E} (hS : (S : E →ₗ[ℂ] E).IsSymmetric) :
    ((sectorCompression K S : K →L[ℂ] K) : K →ₗ[ℂ] K).IsSymmetric := by
  intro x y; simp +decide [ *, sectorCompression ] ;

/--
**T1 (Rayleigh-quotient agreement, core).** The real quadratic form of the
compression at `x ∈ K` equals that of `S` at `(x : E)`. Together with
`‖(x : K)‖ = ‖(x : E)‖` this gives agreement of the Rayleigh quotients.
-/
theorem sectorCompression_reApplyInnerSelf (K : Submodule ℂ E) [K.HasOrthogonalProjection]
    (S : E →L[ℂ] E) (x : K) :
    (sectorCompression K S).reApplyInnerSelf x = S.reApplyInnerSelf (x : E) := by
  simp +decide [ sectorCompression, ContinuousLinearMap.reApplyInnerSelf_apply ]

/--
**T1 (corollary).** If `S` is symmetric and its real quadratic form is
bounded below by `c > 0` on the nontrivial finite-dimensional sector `K`, then
the least Rayleigh quotient of the compression `T_K` is a genuine positive
eigenvalue: `sector_ground_mass` applies to `(K, T_K)`.
-/
theorem sectorCompression_sector_ground_mass (K : Submodule ℂ E)
    [K.HasOrthogonalProjection] [FiniteDimensional ℂ K] [Nontrivial K]
    {S : E →L[ℂ] E} (hS : (S : E →ₗ[ℂ] E).IsSymmetric)
    (c : ℝ) (hc : 0 < c)
    (hpos : ∀ x : K, c * ‖(x : E)‖ ^ 2 ≤ S.reApplyInnerSelf (x : E)) :
    Module.End.HasEigenvalue ((sectorCompression K S : K →L[ℂ] K) : K →ₗ[ℂ] K)
        (((⨅ x : {x : K // x ≠ 0}, (sectorCompression K S).rayleighQuotient x : ℝ)) : ℂ)
      ∧ 0 < (⨅ x : {x : K // x ≠ 0}, (sectorCompression K S).rayleighQuotient x : ℝ) := by
  convert sector_ground_mass ( sectorCompression K S ) ( sectorCompression_isSymmetric K hS ) c hc _;
  convert hpos using 1;
  rw [ sectorCompression_reApplyInnerSelf ];
  rfl

/-! ## Matrix → `sector_ground_mass` bridge helpers -/

/--
If `M` is Hermitian, its Euclidean operator is symmetric.
-/
theorem toEuclideanCLM_isSymmetric_of_isHermitian {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℂ} (hM : M.IsHermitian) :
    ((Matrix.toEuclideanCLM (𝕜 := ℂ) (n := n) M) : EuclideanSpace ℂ n →ₗ[ℂ] EuclideanSpace ℂ n).IsSymmetric := by
  convert Matrix.isHermitian_iff_isSymmetric.mp hM using 1

/--
If `M - c•1` is positive semidefinite, the Euclidean operator of `M` has real
quadratic form bounded below by `c‖x‖²` (no sign condition on `c` is needed).
With `c > 0` this is exactly the form bound `sector_ground_mass` consumes.
-/
theorem reApplyInnerSelf_ge_of_sub_posSemidef {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℂ} {c : ℝ}
    (hpos : (M - (c : ℂ) • (1 : Matrix n n ℂ)).PosSemidef) (x : EuclideanSpace ℂ n) :
    c * ‖x‖ ^ 2 ≤ (Matrix.toEuclideanCLM (𝕜 := ℂ) (n := n) M).reApplyInnerSelf x := by
  obtain ⟨h₁, h₂⟩ := hpos;
  specialize h₂ ( Finsupp.equivFunOnFinite.symm x );
  simp_all +decide [ Finsupp.sum_fintype, EuclideanSpace.norm_eq ];
  simp_all +decide [ Matrix.one_apply, sub_mul, mul_sub, Finset.sum_sub_distrib, mul_assoc, mul_left_comm, ContinuousLinearMap.reApplyInnerSelf_apply, inner ];
  convert Complex.re_le_re h₂ using 1 <;> simp +decide [ Complex.normSq, Complex.sq_norm, Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, mul_comm ];
  · rw [ Real.sq_sqrt ( Finset.sum_nonneg fun _ _ => add_nonneg ( mul_self_nonneg _ ) ( mul_self_nonneg _ ) ), ← Finset.mul_sum _ _ _ ];
  · simp +decide [ mul_add, mul_sub, Finset.mul_sum _ _ _, Finset.sum_add_distrib, mul_left_comm, Finset.sum_sub_distrib ] ; ring

/-! ## T2 - The explicit two-edge Cl(4) carrier -/

/-- Assembled total Krein form `HAC = H_A + H_C = J (Q_A + Q_C)` on `C^12`, for
aperture strength `lam = 2`. Block-diagonal over the four Clifford blocks:
`B0 = -2I - iK`, `B1 = 2I + iK`, `B2 = -2I + iK`, `B3 = 2I - iK`. -/
def HAC : Matrix (Fin 12) (Fin 12) ℂ :=
  !![ (-2 : ℂ), -Complex.I, 0,  0, 0, 0,   0, 0, 0,   0, 0, 0;
      Complex.I, -2, 0,          0, 0, 0,   0, 0, 0,   0, 0, 0;
      0, 0, -2,                  0, 0, 0,   0, 0, 0,   0, 0, 0;
      0, 0, 0,   (2 : ℂ), Complex.I, 0,     0, 0, 0,   0, 0, 0;
      0, 0, 0,   -Complex.I, 2, 0,          0, 0, 0,   0, 0, 0;
      0, 0, 0,   0, 0, 2,                   0, 0, 0,   0, 0, 0;
      0, 0, 0,   0, 0, 0,   (-2 : ℂ), Complex.I, 0,    0, 0, 0;
      0, 0, 0,   0, 0, 0,   -Complex.I, -2, 0,         0, 0, 0;
      0, 0, 0,   0, 0, 0,   0, 0, -2,                  0, 0, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   (2 : ℂ), -Complex.I, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   Complex.I, 2, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   0, 0, 2]

/-- The `12x6` isometry onto the `J`-positive sector: columns are the standard
basis vectors `e3,e4,e5,e9,e10,e11` (Clifford blocks 1 and 3). -/
def Piso : Matrix (Fin 12) (Fin 6) ℂ :=
  !![ 0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0;
      1, 0, 0, 0, 0, 0;
      0, 1, 0, 0, 0, 0;
      0, 0, 1, 0, 0, 0;
      0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0;
      0, 0, 0, 1, 0, 0;
      0, 0, 0, 0, 1, 0;
      0, 0, 0, 0, 0, 1]

/-- The Krein fundamental symmetry `J = Js ⊗ I3 = diag(-1,-1,-1, 1,1,1, -1,-1,-1, 1,1,1)`
on `C^12`. It is Hermitian with `J² = 1`; its `+1` (J-positive) eigenspace is the
sector spanned by `Piso`. -/
def Jmet : Matrix (Fin 12) (Fin 12) ℂ :=
  Matrix.diagonal ![(-1 : ℂ), -1, -1, 1, 1, 1, -1, -1, -1, 1, 1, 1]

/-
The Krein metric is Hermitian (`J = Jᴴ`).
-/
theorem Jmet_isHermitian : Jmet.IsHermitian := by
  exact Matrix.ext fun i j => by fin_cases i <;> fin_cases j <;> simp +decide [ Jmet ] ;

/-
The Krein metric squares to the identity (`J² = 1`).
-/
theorem Jmet_sq : Jmet * Jmet = 1 := by
  ext i j;
  fin_cases i <;> fin_cases j <;> simp +decide [ Jmet ]

/-
The columns of `Piso` are genuine `J = +1` eigenvectors: `Piso` embeds `C^6`
onto the `J`-positive sector, `J · Piso = Piso`. This certifies that the sector
compressed in `compression_eq` is exactly the `J`-positive one.
-/
theorem Jmet_mul_Piso : Jmet * Piso = Piso := by
  ext i j; simp +decide [ Jmet, Piso ] ;
  fin_cases i <;> fin_cases j <;> simp +decide

/-- The `6x6` compressed total Krein form on the `J`-positive sector,
`M6 = blockdiag(B1, B3) = blockdiag(2I + iK, 2I - iK)`. -/
def M6 : Matrix (Fin 6) (Fin 6) ℂ :=
  !![ (2 : ℂ), Complex.I, 0,   0, 0, 0;
      -Complex.I, 2, 0,        0, 0, 0;
      0, 0, 2,                 0, 0, 0;
      0, 0, 0,   (2 : ℂ), -Complex.I, 0;
      0, 0, 0,   Complex.I, 2, 0;
      0, 0, 0,   0, 0, 2]

/-- Gaussian-rational Gram witness: `M6 - 1 = Bwitᴴ Bwit`, i.e. `M6 = 1 + BwitᴴBwit`. -/
def Bwit : Matrix (Fin 6) (Fin 6) ℂ :=
  !![ 1, Complex.I, 0,   0, 0, 0;
      0, 0, 1,           0, 0, 0;
      0, 0, 0,           0, 0, 0;
      0, 0, 0,   1, -Complex.I, 0;
      0, 0, 0,   0, 0, 1;
      0, 0, 0,   0, 0, 0]

theorem HAC_isHermitian : HAC.IsHermitian := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ HAC ] ;

theorem Piso_isometry : Pisoᴴ * Piso = (1 : Matrix (Fin 6) (Fin 6) ℂ) := by
  unfold Piso;
  simp +decide [ ← Matrix.ext_iff ];
  simp +decide [ Fin.sum_univ_succ, Matrix.mul_apply ];
  simp +decide [ Fin.forall_fin_succ, Matrix.one_apply ]

/--
The compressed total form equals `M6`: the explicit `12x6` isometry `Piso`
compresses the assembled Krein form `HAC` to the `6x6` sector form `M6`.
-/
theorem compression_eq : Pisoᴴ * HAC * Piso = M6 := by
  unfold Piso HAC M6;
  ext i j; simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ ] ;
  fin_cases i <;> fin_cases j <;> simp +decide

/--
`M6 = 1 + Bwitᴴ Bwit`: the exact Gaussian-rational Gram decomposition.
-/
theorem M6_eq_one_add_gram : M6 = 1 + Bwitᴴ * Bwit := by
  unfold M6 Bwit;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Fin.sum_univ_succ, Matrix.mul_apply ] ;

/--
**T2 (b).** The compressed total form on the `J`-positive sector is
positive-definite.
-/
theorem M6_posDef : M6.PosDef := by
  -- Now consider the matrix $M6$. By the provided solution, we know that $M6 - 1$ is positive semidefinite.
  have hM6_minus_one_posSemidef : (M6 - 1).PosSemidef := by
    convert Matrix.posSemidef_conjTranspose_mul_self Bwit using 1;
    exact sub_eq_iff_eq_add'.mpr ( M6_eq_one_add_gram );
  convert Matrix.PosDef.add_posSemidef Matrix.PosDef.one hM6_minus_one_posSemidef using 1 ; norm_num

/--
**T2 (b), form bound.** `M6 - 1` is positive semidefinite: the `c = 1`
aperture-dominance lower bound on the sector.
-/
theorem M6_sub_one_posSemidef : (M6 - (1 : ℂ) • (1 : Matrix (Fin 6) (Fin 6) ℂ)).PosSemidef := by
  have h : M6 - (1 : ℂ) • (1 : Matrix (Fin 6) (Fin 6) ℂ) = Bwitᴴ * Bwit := by
    rw [M6_eq_one_add_gram]; simp
  rw [h]
  exact Matrix.posSemidef_conjTranspose_mul_self Bwit

/--
**T2 (c) - end-to-end.** On the concrete two-edge Cl(4) carrier, the least
eigenvalue of the compressed `D^#D`-form (`M6`, the compression of the assembled
Krein form to the 6-dimensional J-positive sector) is a genuine positive squared
mass: `sector_ground_mass` fires, producing an eigenvalue equal to the (positive)
least Rayleigh quotient.
-/
theorem T2_positive_mass :
    Module.End.HasEigenvalue
        ((Matrix.toEuclideanCLM (𝕜 := ℂ) (n := Fin 6) M6) :
          EuclideanSpace ℂ (Fin 6) →ₗ[ℂ] EuclideanSpace ℂ (Fin 6))
        (((⨅ x : {x : EuclideanSpace ℂ (Fin 6) // x ≠ 0},
            (Matrix.toEuclideanCLM (𝕜 := ℂ) (n := Fin 6) M6).rayleighQuotient x : ℝ)) : ℂ)
      ∧ 0 < (⨅ x : {x : EuclideanSpace ℂ (Fin 6) // x ≠ 0},
            (Matrix.toEuclideanCLM (𝕜 := ℂ) (n := Fin 6) M6).rayleighQuotient x : ℝ) := by
  apply sector_ground_mass;
  convert toEuclideanCLM_isSymmetric_of_isHermitian M6_posDef.isHermitian;
  exact zero_lt_one;
  convert reApplyInnerSelf_ge_of_sub_posSemidef M6_sub_one_posSemidef using 1

/-! ## T5 - Gauge covariance of the four blocks -/

/--
**T5.** Conjugation by a unitary `u` (`uᴴ u = 1`) is a `*`-algebra
endomorphism preserving expectations: it is multiplicative (the assembled square
`D^#D`, a product, transforms by conjugation), additive (the block
decomposition is preserved), sends Hermitian Krein blocks to Hermitian blocks,
and leaves every block expectation invariant in `u`-covariant states
(`star (u x) ⬝ᵥ ((u A uᴴ) *ᵥ (u x)) = star x ⬝ᵥ (A *ᵥ x)`). Hence block
expectations are gauge-invariant.
-/
theorem gauge_covariance {n : Type*} [Fintype n] [DecidableEq n]
    (u : Matrix n n ℂ) (hu : uᴴ * u = 1) :
    (∀ A B : Matrix n n ℂ, (u * A * uᴴ) * (u * B * uᴴ) = u * (A * B) * uᴴ) ∧
    (∀ A B : Matrix n n ℂ, u * (A + B) * uᴴ = u * A * uᴴ + u * B * uᴴ) ∧
    (∀ A : Matrix n n ℂ, A.IsHermitian → (u * A * uᴴ).IsHermitian) ∧
    (∀ (A : Matrix n n ℂ) (x : n → ℂ),
      star (u *ᵥ x) ⬝ᵥ ((u * A * uᴴ) *ᵥ (u *ᵥ x)) = star x ⬝ᵥ (A *ᵥ x)) := by
  refine' ⟨ _, _, _, _ ⟩;
  · grind +splitIndPred;
  · simp +decide [ mul_add, add_mul ];
  · simp +contextual [ Matrix.IsHermitian, mul_assoc ];
  · intro A x; simp +decide [ Matrix.mul_assoc, Matrix.mulVec_mulVec, Matrix.dotProduct_mulVec, hu ] ;
    have h_simp : star (u *ᵥ x) = star x ᵥ* uᴴ := by
      ext i; simp +decide [ Matrix.mulVec, dotProduct ] ;
      simp +decide [ Matrix.vecMul, dotProduct, mul_comm ];
    simp +decide [ h_simp ];
    simp +decide [ ← Matrix.mul_assoc, hu ]

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness.T2_positive_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms T2_positive_mass

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness.sectorCompression_sector_ground_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sectorCompression_sector_ground_mass

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness.gauge_covariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gauge_covariance

end PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness
