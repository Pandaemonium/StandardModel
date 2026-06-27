import Mathlib
import PhysicsSM.Draft.NullEdgeProjectedGateCRelease

/-!
# C77 (Wave 18): abstract flavored spectral-flow / modified-chirality API

This is the **Route B construction-layer interface** for the post-C21 Gate C
release target.  It records, as named finite predicates and small algebraic
theorems, the data that a later *concrete* construction module is expected to
instantiate:

* point-split **branch projectors** (`BranchProjectorSystem`),
* **taste signs** in `{+1, -1}` (`TasteSignSystem`),
* the **taste involution** `τ = Σ_a s_a Π_a` built from the two and its square
  `τ² = Π_B` on the branch subspace (`tasteTau`, `tasteTau_sq`),
* **modified chirality** `Γ_f = Γ_s · τ` and its square under a commuting
  hypothesis (`ModifiedChiralityData`, `gammaF_sq`),
* **flavored mass data** carrying a `γ₅`-commuting Hermitian mass-parameter
  family (`FlavoredMassData`),
* **Hermitian spectral-flow kernels** `H(t) = γ₅ · D(t)`
  (`HermitianSpectralFlowKernel`, `FlavoredMassData.kernel`), and
* a **flavored-index-ready** predicate (`FlavoredIndexReady`) abstractly
  implying the chirality clause of
  `PhysicsSM.Draft.NullEdgeProjectedGateCRelease.ProjectedGateCRelease`.

## Honesty discipline (scope guardrails)

Nothing here asserts that the actual flat tetrahedral null-edge operator *has*
such projectors, signs, modified chirality, or Hermitian spectral-flow kernel.
Every nontrivial object is a **structure carrying hypotheses**, and every theorem
is a *finite algebraic consequence* of those explicitly supplied hypotheses
(orthogonality/idempotence of projectors, signs squaring to one, commutation of
`Γ_s` with `τ`, Hermiticity and commutation of `γ₅` with the mass family).  The
genuine open obligation — discharging these predicates on the concrete projected
null-edge operator (the C58 obligation) — is *not* addressed here.

The connection to the release API is the lightweight import of
`NullEdgeProjectedGateCRelease`; `FlavoredIndexReady` is stated so that the
chirality clause of `ProjectedGateCRelease` is a definitional substitution once
the projected branch data is in scope.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeFlavoredSpectralFlowAPI

open scoped BigOperators
open Matrix

/-! ## Point-split branch projectors -/

/-- A finite system of **point-split branch projectors** on an (associative,
unital) algebra `A`, indexed by a finite taste/branch index `ι`.

* `proj a` — the projector onto branch `a` (the point-split would-be zero mode of
  taste corner `a`);
* `idem` — each projector is idempotent;
* `orth` — distinct branch projectors are orthogonal;
* `branch` — the projector `Π_B` onto the whole branch subspace;
* `sum_eq` — the branch projectors resolve `Π_B`.

No claim is made that the concrete null-edge operator supplies such a system;
this is the carrier for the algebraic consequences below. -/
structure BranchProjectorSystem (ι : Type*) [Fintype ι] [DecidableEq ι]
    (A : Type*) [Ring A] where
  /-- the projector onto branch `a`. -/
  proj : ι → A
  /-- each branch projector is idempotent. -/
  idem : ∀ a, proj a * proj a = proj a
  /-- distinct branch projectors are orthogonal. -/
  orth : ∀ a b, a ≠ b → proj a * proj b = 0
  /-- the projector onto the whole branch subspace. -/
  branch : A
  /-- the branch projectors resolve `Π_B`. -/
  sum_eq : ∑ a, proj a = branch

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- The branch-subspace projector `Π_B` is itself idempotent (sum of orthogonal
idempotents). -/
theorem BranchProjectorSystem.branch_idem {A : Type*} [Ring A]
    (B : BranchProjectorSystem ι A) : B.branch * B.branch = B.branch := by
  rw [← B.sum_eq, Finset.sum_mul]
  refine Finset.sum_congr rfl ?_
  intro a _
  rw [Finset.mul_sum, Finset.sum_eq_single a]
  · exact B.idem a
  · intro b _ hb; exact B.orth a b (Ne.symm hb)
  · intro h; exact absurd (Finset.mem_univ a) h

/-! ## Taste signs in `{+1, -1}` -/

/-- A finite system of **taste signs** valued in `{+1, -1}` of a field `𝕜`.
These are the `s_a = ±1` taste-involution eigenvalues on the branch index. -/
structure TasteSignSystem (ι : Type*) (𝕜 : Type*) [Field 𝕜] where
  /-- the taste sign of branch `a`. -/
  sign : ι → 𝕜
  /-- each taste sign is `+1` or `-1`. -/
  sign_pm : ∀ a, sign a = 1 ∨ sign a = -1

omit [Fintype ι] [DecidableEq ι] in
/-- A `±1` taste sign squares to `1`. -/
theorem TasteSignSystem.sign_sq {𝕜 : Type*} [Field 𝕜]
    (S : TasteSignSystem ι 𝕜) (a : ι) : S.sign a * S.sign a = 1 := by
  rcases S.sign_pm a with h | h <;> rw [h] <;> ring

/-! ## The taste involution `τ = Σ_a s_a Π_a` and `τ² = Π_B` -/

variable {𝕜 : Type*} [Field 𝕜] {A : Type*} [Ring A] [Algebra 𝕜 A]

/-- The **taste involution** `τ = Σ_a s_a · Π_a` built from a branch-projector
system and a taste-sign system. -/
def tasteTau (B : BranchProjectorSystem ι A) (S : TasteSignSystem ι 𝕜) : A :=
  ∑ a, S.sign a • B.proj a

/-- **Branch involution identity.**  With orthogonal idempotent branch
projectors and taste signs in `{+1, -1}`, the taste involution squares to the
branch-subspace projector: `τ² = Π_B`.  (This is the "taste involution restricts
to a genuine involution on the branch subspace" statement.) -/
theorem tasteTau_sq (B : BranchProjectorSystem ι A) (S : TasteSignSystem ι 𝕜) :
    tasteTau B S * tasteTau B S = B.branch := by
  unfold tasteTau
  rw [← B.sum_eq, Finset.sum_mul]
  refine Finset.sum_congr rfl ?_
  intro a _
  rw [Finset.mul_sum, Finset.sum_eq_single a]
  · rw [smul_mul_smul_comm, B.idem a, S.sign_sq a, one_smul]
  · intro b _ hb
    rw [smul_mul_smul_comm, B.orth a b (Ne.symm hb), smul_zero]
  · intro h; exact absurd (Finset.mem_univ a) h

/-! ## Modified chirality `Γ_f = Γ_s · τ` -/

/-- **Modified-chirality data**: a spacetime chirality `Γ_s`, a taste involution
`τ`, each squaring to `1`, together with the commutation hypothesis
`Γ_s τ = τ Γ_s` (they act on distinct factors). -/
structure ModifiedChiralityData (A : Type*) [Ring A] where
  /-- spacetime chirality `Γ_s`. -/
  gammaS : A
  /-- taste involution `τ`. -/
  tau : A
  /-- `Γ_s² = 1`. -/
  gammaS_sq : gammaS * gammaS = 1
  /-- `τ² = 1`. -/
  tau_sq : tau * tau = 1
  /-- `Γ_s` and `τ` commute. -/
  comm : gammaS * tau = tau * gammaS

/-- The **modified (flavored) chirality** `Γ_f = Γ_s · τ`. -/
def ModifiedChiralityData.gammaF {A : Type*} [Ring A]
    (M : ModifiedChiralityData A) : A := M.gammaS * M.tau

/-- For commuting elements, the square of a product factors:
`(g·t)² = g²·t²`. -/
theorem sq_mul_of_comm {A : Type*} [Ring A] (g t : A) (h : g * t = t * g) :
    (g * t) * (g * t) = (g * g) * (t * t) := by
  have e : g * t * (g * t) = g * (t * g) * t := by simp only [mul_assoc]
  rw [e, ← h]; simp only [mul_assoc]

/-- **Modified-chirality involution.**  Under the commuting hypothesis, the
flavored chirality `Γ_f = Γ_s · τ` squares to `1` exactly as expected from the
factor involutions. -/
theorem ModifiedChiralityData.gammaF_sq {A : Type*} [Ring A]
    (M : ModifiedChiralityData A) : M.gammaF * M.gammaF = 1 := by
  unfold ModifiedChiralityData.gammaF
  rw [sq_mul_of_comm M.gammaS M.tau M.comm, M.gammaS_sq, M.tau_sq, one_mul]

/-! ## Hermitian spectral-flow kernels and flavored mass data -/

/-- Product of two **commuting Hermitian** matrices is Hermitian. -/
theorem isHermitian_mul_of_comm {n : Type*} [Fintype n]
    {X Y : Matrix n n ℂ} (hX : X.IsHermitian) (hY : Y.IsHermitian)
    (hcomm : X * Y = Y * X) : (X * Y).IsHermitian := by
  have : (X * Y)ᴴ = X * Y := by
    rw [Matrix.conjTranspose_mul, hY, hX, hcomm]
  exact this

/-- A **Hermitian spectral-flow kernel**: a real one-parameter family of
Hermitian matrices `H(t)`.  The Hermiticity field is exactly what makes the
eigenvalue flow `t ↦ spec H(t)` real, which the index-by-spectral-flow argument
requires. -/
structure HermitianSpectralFlowKernel (n : Type*) [Fintype n] [DecidableEq n] where
  /-- the kernel at flow parameter `t`. -/
  H : ℝ → Matrix n n ℂ
  /-- each kernel is Hermitian. -/
  isHerm : ∀ t, (H t).IsHermitian

/-- **Flavored mass data**: a Hermitian chirality `γ₅` and a real one-parameter
family of Hermitian mass-parameter operators `D(t)` (the point-split flavored
mass term added to the kernel), each commuting with `γ₅`.

This is the data from which a Hermitian spectral-flow kernel `H(t) = γ₅ · D(t)`
is built; no claim is made that the concrete null-edge operator supplies it. -/
structure FlavoredMassData (n : Type*) [Fintype n] [DecidableEq n] where
  /-- the (Hermitian) chirality operator `γ₅`. -/
  gamma5 : Matrix n n ℂ
  /-- `γ₅` is Hermitian. -/
  g5_herm : gamma5.IsHermitian
  /-- the mass-parameter family `D(t)`. -/
  D : ℝ → Matrix n n ℂ
  /-- each `D(t)` is Hermitian. -/
  D_herm : ∀ t, (D t).IsHermitian
  /-- each `D(t)` commutes with `γ₅`. -/
  D_comm : ∀ t, gamma5 * D t = D t * gamma5

/-- **Flavored mass ⇒ Hermitian spectral-flow kernel.**  From flavored mass data
the kernel `H(t) = γ₅ · D(t)` is a Hermitian spectral-flow kernel (product of
commuting Hermitians). -/
def FlavoredMassData.kernel {n : Type*} [Fintype n] [DecidableEq n]
    (F : FlavoredMassData n) : HermitianSpectralFlowKernel n where
  H := fun t => F.gamma5 * F.D t
  isHerm := fun t => isHermitian_mul_of_comm F.g5_herm (F.D_herm t) (F.D_comm t)

/-! ## Flavored-index readiness and the projected chirality clause -/

open PhysicsSM.Draft.NullEdgeProjectedGateCRelease
  (ProjData ProjectedKernelOneDim ProjectedChiralityAligned)

open PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety (g5pattern)

/-- **Flavored-index-ready** projected data: the species/Krein/Weyl projection
has produced, on every retained branch, a one-dimensional kernel with the
aligned chirality sign `g5pattern` and positive Krein signature.

This is the projected datum the flavored-index argument requires; it is stated
abstractly as a predicate on `ProjData` so that the later concrete construction
need only discharge these three clauses. -/
def FlavoredIndexReady (d : ProjData) : Prop :=
  ProjectedKernelOneDim d ∧ ProjectedChiralityAligned d ∧
    (∀ a, d.retained a = true → d.krein a = 1)

/-- **Flavored index readiness ⇒ the chirality clause of the projected Gate C
release.**  The conjunction packaged inside `ProjectedGateCRelease` for the
retained branches follows abstractly from `FlavoredIndexReady`. -/
theorem FlavoredIndexReady.chirality_clause {d : ProjData}
    (h : FlavoredIndexReady d) :
    ∀ a, d.retained a = true →
      d.kerDim a = 1 ∧ d.chir a = g5pattern a ∧ d.krein a = 1 :=
  fun a ha => ⟨h.1 a ha, h.2.1 a ha, h.2.2 a ha⟩

/-! ## Summary -/

/-- **C77 summary.**  The abstract flavored spectral-flow / modified-chirality
API:

1. orthogonal idempotent branch projectors with `±1` taste signs give a taste
   involution squaring to the branch projector (`tasteTau_sq`);
2. modified chirality `Γ_f = Γ_s · τ` squares to `1` under the commuting
   hypothesis (`ModifiedChiralityData.gammaF_sq`);
3. flavored mass data yields a Hermitian spectral-flow kernel
   (`FlavoredMassData.kernel`); and
4. flavored-index readiness implies the chirality clause of the projected
   Gate C release (`FlavoredIndexReady.chirality_clause`). -/
theorem c77_flavored_spectral_flow_summary :
    (∀ (B : BranchProjectorSystem ι A) (S : TasteSignSystem ι 𝕜),
        tasteTau B S * tasteTau B S = B.branch) ∧
    (∀ (M : ModifiedChiralityData A), M.gammaF * M.gammaF = 1) ∧
    (∀ (d : ProjData), FlavoredIndexReady d →
        ∀ a, d.retained a = true →
          d.kerDim a = 1 ∧ d.chir a = g5pattern a ∧ d.krein a = 1) :=
  ⟨fun B S => tasteTau_sq B S, fun M => M.gammaF_sq,
    fun _ h => FlavoredIndexReady.chirality_clause h⟩

end PhysicsSM.Draft.NullEdgeFlavoredSpectralFlowAPI
