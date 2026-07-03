# Gate C1 — flavored / matrix Wilson square and gap transfer (C264)

Date: 2026-06-29

Status: strategy / proof-design report. **Algebra and gap-transfer layer only.**
This document deliberately makes **no** physical branch-retention claim: it does
not supply a target spectral island, and it does not supply a nonzero origin
chiral index. Those two clauses are flagged throughout as out of scope and are
the open items that must be added on top of this layer before any
branch-retention statement is legitimate (release plan "central unknown"; C262
audit §1).

This is a non-blocking design job for the PhysicsSM null-edge Gate C1 program.
It does **not** touch the local finite/free scalar `Kfree/Hfree` assembly path
(handled separately). It designs the *next* module that would sit beside
`TetraScalarWilsonSymbol.lean`, generalizing the scalar Wilson symbol to a
matrix-valued (flavored / species-splitting, Adams-style) branch mass.

Sources read for this report:

* `PhysicsSM/Draft/NullEdge/GateC1/TetraQMatrixSquareExact.lean`
  (`TetraEuclideanSlashData`, `Q`, `Q_square_exact`, `Q_hermitian`,
  `Q_star_mul_exact`, `Q_inverse_formula*`).
* `PhysicsSM/Draft/NullEdge/GateC1/TetraQSquareExact.lean`
  (`qExact`, `qLower`, `qLower_le_qExact`, positivity lemmas).
* `PhysicsSM/Draft/NullEdge/GateC1/TetraScalarWilsonSymbol.lean`
  (`l2NormSq`, `l2NormSq_*`, `K`, `K_star`, `K_star_mul`, `FirstWilsonBand`,
  `firstBandMu`, `scalarWilsonCoeff_uniform_gap`, `K_symbol_l2NormSq_gap`,
  `H`, `H_symbol_l2NormSq_gap`).
* `PhysicsSM/Draft/NullEdge/GateC1/OverlapGinspargWilson.lean`
  (`Dov`, `dov_ginsparg_wilson`).
* `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` and the C262
  branch-retention audit.

Note on current build state: the GateC1 tree presently does not compile in this
packet because `TetrahedralGlobalGap.lean` (imported by `TetraQSquareExact`) is
absent here. The C262 audit reconstructed it; this report assumes that
reconstruction (or the live module) is available when the proposed file is
added. The central algebraic pivot below was nonetheless machine-checked in
isolation against Mathlib (see §2.1).

---

## 0. Executive summary

* The scalar square theorem `K_star_mul` works for exactly one reason: the
  Wilson mass enters as `m(k)·I`, which is **central**, so the only cross term in
  `K^* K` is `i·(m·Q − m·Q) = 0`.
* For a matrix-valued branch mass `W(k)`, the cross term of
  `K_branch(k)^* K_branch(k)` is `(1/a²)·i·(W(k)·Q − Q·W(k)) = (1/a²)·i·[W(k),Q]`.
  This was machine-verified:
  `(-iQ + W)(iQ + W) = (Q² + W²) + i·(WQ − QW)` (§2.1).
* The **cleanest** controllable regime is: `W(k)` **Hermitian** and **commuting
  with `Q(sin k)`**. Then
  `K_branch(k)^* K_branch(k) = (1/a²)·(qExact(sin k)·I + W(k)²)`,
  a sum of squares of Hermitian matrices, hence positive semidefinite. No
  scalar/centrality assumption on `W` is needed — only Hermiticity + commutation.
* The right generalization of `K_star_mul` is **not** "`= coeff·I`" (that is
  impossible once `W` is a nontrivial matrix). It is the **operator identity**
  `K_branch^* K_branch = (1/a²)·(qExact·I + W²)` plus the **quadratic-form
  decomposition**
  `‖K_branch·ψ‖² = (1/a²)·( qExact·‖ψ‖² + ‖W·ψ‖² )`.
  The right generalization of `K_symbol_l2NormSq_gap` is a **form gap** driven by
  a pointwise lower bound on the smallest eigenvalue of `qExact·I + W²`.
* Scalar `firstBandMu` is **reusable, but only per branch/species**: if `W(k)` is
  simultaneously diagonalizable across momentum in a fixed flavor frame, each
  eigenvalue is itself a scalar Wilson-type mass `m_f(k)`, so the existing
  scalar `firstBandMu` bound applies eigenvalue-by-eigenvalue. The *aggregate*
  uniform gap needs a **new flavored certificate** that (a) takes the min of the
  per-species scalar certificates over the *heavy/complement* species and (b)
  explicitly **excludes the island species** (where the eigenvalue is small by
  design). A single scalar `firstBandMu` cannot be reused as-is, because a true
  uniform gap over *all* flavors would forbid the very island branch retention
  is supposed to keep.
* Concrete near-Lean statements for a new `TetraBranchWilsonSymbol.lean` are in
  §6.

---

## 1. What makes the scalar proof work (and why it must change)

Scalar symbol (`TetraScalarWilsonSymbol.K`):

```
K(k) = a⁻¹ · ( i · Q(sin k) + m(k) · I ),   m(k) = mWilson r ρ k  (scalar).
```

`Q` is Hermitian (`Q_hermitian`) with `Q² = qExact(sin k)·I`
(`Q_square_exact`). Because `m(k)·I` is central:

```
K^* K = a⁻² ( -iQ + mI )( iQ + mI )
      = a⁻² ( Q² + m²I  +  i(mQ − mQ) )
      = a⁻² ( qExact + m² ) · I.                      (= K_star_mul)
```

The cross term cancels *identically* because `m` is a scalar. The downstream
gap chain then only needs a scalar coefficient bound:

* `l2NormSq_mulVec_of_star_mul_eq_smul_one`: `A^* A = c·I ⇒ ‖A ψ‖² = c·‖ψ‖²`;
* `l2NormSq_mulVec_lower_of_star_mul_coeff_gap`: with `γ ≤ c`, `γ‖ψ‖² ≤ ‖A ψ‖²`;
* `scalarWilsonCoeff_uniform_gap` / `firstBandMu`: a uniform `μ>0` lower bound on
  `qLower(sin k) + m(k)²` on the first Wilson band `0 < ρ < 2r`.

For a matrix-valued `W(k)` the equality `K^* K = c·I` is **false in general**:
`W²` is not a multiple of `I`, and the cross term is `i·[W,Q]`, which does not
vanish unless `W` commutes with `Q`. So both the algebraic identity and the
norm-bridge lemmas have to be generalized from "`= c·I`" to "PSD with a form
gap".

---

## 2. Question 2 — commutation / Hermiticity hypotheses

### 2.1 The exact cross-term identity (machine-verified)

For any `Q, W : Matrix Spin Spin ℂ`:

```
(-i·Q + W) · (i·Q + W) = (Q·Q + W·W) + i·(W·Q − Q·W).
```

This was checked against Mathlib (2x2-agnostic, fully general `n`):

```lean
example {n : Type*} [Fintype n] [DecidableEq n] (Q W : Matrix n n ℂ) :
    ((-Complex.I) • Q + W) * (Complex.I • Q + W)
      = (Q*Q + W*W) + Complex.I • (W*Q - Q*W) := by
  simp only [mul_add, add_mul, smul_mul_assoc, mul_smul_comm, smul_add,
    smul_smul, smul_sub]
  have h1 : (Complex.I * -Complex.I) = 1 := by
    have := Complex.I_mul_I; ring_nf; ring_nf at this; linear_combination -this
  rw [h1, neg_smul, one_smul]
  abel
```

When `W` is Hermitian and `Q` is Hermitian, `star(i·Q + W) = -i·Q + W`, so the
left side is exactly `K_branch^* K_branch` up to the `a⁻²` scalar. Hence:

> **Cross term `= (1/a²)·i·[W(k), Q(sin k)]`.** It vanishes **iff** `W(k)`
> commutes with `Q(sin k)`.

### 2.2 The usable hypothesis set

The minimal hypotheses that make `K_branch^* K_branch` reduce to a usable
positive form:

1. **`Q` Hermitian** — already provided by `TetraEuclideanSlashData.Q_hermitian`.
2. **`W(k)` Hermitian:** `star (W k) = W k`. (Euclidean/Hilbert convention,
   matching `B_hermitian`.)
3. **`W(k)` commutes with `Q(sin k)`:** `Q(sin k) · W k = W k · Q(sin k)`.

Under (1)–(3):

```
K_branch(k)^* K_branch(k) = (1/a²) · ( qExact(sin k)·I + W(k)² ).
```

`W(k)² = W(k)^* W(k)` (Hermiticity), so the right side is a sum of two PSD
Hermitian matrices, hence PSD; positivity/no-kernel is then governed by the
smallest eigenvalue of `qExact·I + W²`.

### 2.3 Rejected / weaker variants (and why)

* **`W` Hermitian, anticommuting with `Q`** (`QW + WQ = 0`): cross term is
  `i·(WQ − QW) = −2i·QW ≠ 0`. Does **not** reduce; rejected.
* **`W` anti-Hermitian, anticommuting** (`star W = −W`, `QW + WQ = 0`): cross
  term `i·(W^*Q − QW^*)`... here `star K = −iQ − W`, giving
  `K^*K = a⁻²(Q² − W² − i[W,Q])`, and even with anticommutation the leading term
  is `Q² − W²`, a **difference** of squares — not sign-definite. Rejected.
* **`W` central (`W = m·I`)**: the scalar case; commutation is automatic and
  `W² = m²·I`. This is the special case the new theorem must specialize to.

So commutation `[W, Q] = 0` (with `W` Hermitian) is the unique clean route, and
it strictly generalizes scalar centrality.

### 2.4 The canonical model that satisfies (1)–(3): flavor tensor factor

The cleanest *concrete* `W` satisfying commutation is a **flavor tensor factor**
on `Spin = Dirac ⊗ Flavor` with `Q = Q_Dirac ⊗ I_Flavor`:

```
W(k) = I_Dirac ⊗ M(k),     M(k) : Matrix Flavor Flavor ℂ  Hermitian.
```

Then `[Q, W] = [Q_Dirac, I] ⊗ ... = 0` automatically, and
`W² = I_Dirac ⊗ M(k)²`, so
`qExact·I + W² = I_Dirac ⊗ (qExact·I_Flavor + M(k)²)`. This is the Adams-style
species-splitting shape: `M(k)` carries the branch/flavor structure while
commutation with the Dirac slash is structural. **The abstract interface in §3
should not bake in the tensor product** (to stay representation-free, matching
`TetraEuclideanSlashData`), but this tensor model is the intended witness and is
worth recording as the canonical instance.

---

## 3. Question 1 — cleanest abstract Lean interface for `W_branch(k)`

Mirror the existing `TetraEuclideanSlashData` style: bundle the branch-mass
function with exactly the two hypotheses (2) and (3), parameterized over an
existing slash datum `D`. Keep it representation-free.

```lean
/-- Abstract flavored/matrix Wilson branch mass attached to a fixed
Euclidean tetrahedral slash datum `D`.  Representation-free: the only structure
required is Hermiticity and commutation with the slash `Q(sin k)`. -/
structure TetraBranchMass
    {Spin : Type*} [Fintype Spin] [DecidableEq Spin]
    (D : TetraEuclideanSlashData Spin) where
  /-- Momentum-dependent matrix Wilson/branch mass. -/
  W : (Fin 4 → ℝ) → Matrix Spin Spin ℂ
  /-- Euclidean/Hilbert convention: the branch mass is Hermitian. -/
  W_hermitian : ∀ k, star (W k) = W k
  /-- Branch mass commutes with the slash at the same momentum. -/
  W_comm : ∀ k,
    TetraEuclideanSlashData.Q D (sinCoeffs k) * W k
      = W k * TetraEuclideanSlashData.Q D (sinCoeffs k)
```

Design notes:

* **Why a structure and not loose hypotheses:** it lets downstream APIs take a
  single `Wb : TetraBranchMass D` argument, exactly as the scalar lane threads
  `D : TetraEuclideanSlashData Spin`. It also makes the canonical tensor witness
  (§2.4) a named `def`/instance.
* **Why commutation per-`k` (not a global Clifford relation):** the only thing
  the square needs is `[W(k), Q(sin k)] = 0` at each momentum; demanding a
  global Clifford/anticommutation relation would be both stronger and wrong (see
  §2.3).
* **The scalar lane is the instance** `W k = mWilson r ρ k • I` with
  `W_hermitian` from `star_one`/real scalar and `W_comm` from centrality of
  scalar multiples of `I`. This should be provided as
  `TetraBranchMass.ofScalar` so `TetraScalarWilsonSymbol` is literally a special
  case.
* **Optional spectral-data extension (for §4/§5, not the algebra):** a separate
  structure `TetraBranchSpectralData` adding a fixed flavor frame, per-species
  eigenvalue profiles, and an island index set — see §5. Keep it *separate* from
  `TetraBranchMass` so the algebra layer never depends on island data.

---

## 4. Question 3 — the theorem that generalizes `K_star_mul` and the gap

There are three statements, in increasing strength. The first two are pure
algebra/positivity (provable now from §2). The third is the gap-transfer adapter
that consumes a flavored certificate.

### 4.1 Generalized square (replaces `K_star_mul`)

```
K_branch(k)^* K_branch(k) = (1/a²) · ( qExact(sin k)·I + W(k)² ).
```

This is the honest generalization. Note it is **not** of the form `c·I`; the
output is an explicit Hermitian PSD matrix. Specializing `W = m·I` recovers
`K_star_mul` since `m²·I + qExact·I = (qExact + m²)·I`.

### 4.2 Quadratic-form decomposition (replaces the `l2NormSq` bridge)

```
‖K_branch(k)·ψ‖² = (1/a²) · ( qExact(sin k)·‖ψ‖² + ‖W(k)·ψ‖² ).
```

This is the matrix analogue of `l2NormSq_mulVec_of_star_mul_eq_smul_one`. It
follows from §4.1 by the existing dot-product manipulation
(`l2NormSq_complex`, `Matrix.star_mulVec`, `vecMul_vecMul`), using
`‖ψ‖² = star ψ ⬝ᵥ ψ` and `star ψ ⬝ᵥ (W^*W) ψ = ‖W ψ‖²`. The new generic bridge
lemma needed is:

```
l2NormSq_mulVec_of_star_mul_eq_smul_add_starMul :
  star A * A = c • 1 + (star B * B)  ⇒  ‖A ψ‖² = c·‖ψ‖² + ‖B ψ‖².
```

(or, more directly, prove the `K_branch` decomposition in one shot.)

### 4.3 Form gap (replaces `K_symbol_l2NormSq_gap`)

Because `‖W(k)·ψ‖² ≥ 0`, the `W` term only *helps*; the **gap must come from a
pointwise lower bound on the smallest eigenvalue of `qExact·I + W²`**, not from
`qExact` alone (which vanishes at the origin `k = 0`, exactly as in the scalar
lane where `m(0)² = ρ² > 0` filled the hole). So the gap-transfer theorem is
**parameterized by a flavored coefficient certificate** `wBranchMin`:

> Suppose there is `μ > 0` and, for each `k`, a real `wBranchMin k` with
> `wBranchMin k · ‖ψ‖² ≤ ‖W(k)·ψ‖²` for all `ψ` (a form lower bound for `W²`),
> and `μ ≤ qLower(sin k) + wBranchMin k`. Then with `a > 0`,
> for `γ := μ / a²` we have `γ > 0` and
> `γ·‖ψ‖² ≤ ‖K_branch(k)·ψ‖²` for all `k, ψ`.

This is the exact structural analogue of
`scalarWilsonCoeff_uniform_scaled_gap_from_qLower` +
`K_symbol_l2NormSq_gap`, with the scalar `m(k)²` replaced by the **form lower
bound** `wBranchMin k` of the matrix `W(k)²`. The chirality transfer
`H_branch = γ₅ · K_branch` (with `star γ₅ · γ₅ = 1`) carries over verbatim from
`H_l2NormSq_eq_K_l2NormSq` / `H_symbol_l2NormSq_gap` — it never touched the mass
structure.

### 4.4 Honesty boundary

The form gap in §4.3 is a *conditional* statement: it transfers a flavored
coefficient certificate to an operator gap. It is **silent** about whether such a
certificate exists *with the island excluded* — that is the branch-retention
content and is **not** proved here. A uniform `wBranchMin k > 0` for *all* `k`
and *all* flavors would mean `W` is uniformly invertible everywhere, which would
**destroy** the island. So §4.3 must be applied on the *complement* sector only;
the island sector must be handled by the (out-of-scope) index/island layer.

---

## 5. Question 4 — can scalar `firstBandMu` be reused?

**Partially. It is reusable per-species but not as a single aggregate constant.**

* The scalar `firstBandMu r ρ` is a uniform lower bound for
  `qLower(sin k) + mWilson(r,ρ,k)²` on the band `0 < ρ < 2r`, proved by a
  three-region split on the Wilson radius `R(k) = Σ(1 − cos k_A)`
  (`scalarWilsonCoeff_uniform_gap`). Its derivation is tied to the *scalar*
  profile `mWilson`.
* If `W(k)` is **simultaneously diagonalizable in a fixed flavor frame**
  (independent of `k`), i.e. there is a unitary `U` with
  `U^* W(k) U = diag(m_1(k), …, m_F(k))`, and each species mass `m_f` is itself
  a scalar Wilson-type profile `mWilson r ρ_f`, then for the eigenvector of
  species `f`, `‖W(k)ψ_f‖² = m_f(k)²‖ψ_f‖²`, and
  `qExact(sin k) + m_f(k)² ≥ qLower(sin k) + m_f(k)² ≥ firstBandMu r ρ_f`
  whenever `0 < ρ_f < 2r`. **So `firstBandMu` is reused verbatim, once per
  species.** This needs only Hermiticity + commutation (the eigenframe of `W`
  must be `Q`-invariant, which commutation gives) plus the eigenvalue profiles.
* The **aggregate** `wBranchMin k` is then
  `wBranchMin k = min_f (qLower(sin k) + m_f(k)²) − qLower(sin k)`, and the
  uniform gap is `μ = min over the retained (heavy/complement) species of
  firstBandMu r ρ_f`. The **island species are deliberately excluded** from the
  min: their `ρ_f` is chosen at/near a band edge (e.g. `ρ_f → 0` or `→ 2r`) so
  `firstBandMu r ρ_f → 0` — there is *no* uniform gap there, by design.

Conclusion: do **not** state a single `firstBandMu`-based uniform gap over all
flavors; that would be either false or island-killing. Instead introduce a
**new flavored certificate** `flavorBandMu` that

1. takes per-species band data `ρ_f` and an island index set `Island ⊆ Flavor`;
2. requires `0 < ρ_f < 2r` only for `f ∉ Island`;
3. returns `min_{f ∉ Island} firstBandMu r ρ_f` as the complement-sector gap;
4. records (as a *separate*, out-of-scope obligation) that the island sector
   carries the spectral island + nonzero chiral index.

Item (3) reuses `firstBandMu`/`scalarWilsonCoeff_uniform_gap` as a black box.
Item (4) is the genuine open content and is not part of this gap-transfer layer.

---

## 6. Question 5 — near-Lean statements for `TetraBranchWilsonSymbol.lean`

File header / imports (sits beside the scalar lane, reuses its API):

```lean
import PhysicsSM.Draft.NullEdge.GateC1.TetraScalarWilsonSymbol

noncomputable section
namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraBranchWilsonSymbol

open scoped BigOperators
open TetraQMatrixSquareExact
open TetraScalarWilsonSymbol   -- l2NormSq, sinCoeffs, mWilson, firstBandMu, …

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]
```

### 6.1 Interface (Q1)

```lean
structure TetraBranchMass (D : TetraEuclideanSlashData Spin) where
  W : (Fin 4 → ℝ) → Matrix Spin Spin ℂ
  W_hermitian : ∀ k, star (W k) = W k
  W_comm : ∀ k,
    TetraEuclideanSlashData.Q D (sinCoeffs k) * W k
      = W k * TetraEuclideanSlashData.Q D (sinCoeffs k)

/-- The scalar Wilson lane is the central instance `W = m·I`. -/
def TetraBranchMass.ofScalar (D : TetraEuclideanSlashData Spin) (r rho : ℝ) :
    TetraBranchMass D where
  W := fun k => ((mWilson r rho k : ℝ) : ℂ) • (1 : Matrix Spin Spin ℂ)
  W_hermitian := by s o r r y   -- star (c • 1) = c • 1 for real c
  W_comm := by s o r r y        -- scalar multiples of 1 are central
```

### 6.2 The flavored symbol and its adjoint

```lean
/-- Flavored / matrix Wilson free symbol. -/
def Kbranch (D : TetraEuclideanSlashData Spin) (Wb : TetraBranchMass D)
    (a : ℝ) (k : Fin 4 → ℝ) : Matrix Spin Spin ℂ :=
  ((a : ℂ)⁻¹) •
    (Complex.I • TetraEuclideanSlashData.Q D (sinCoeffs k) + Wb.W k)

theorem Kbranch_star (D : TetraEuclideanSlashData Spin) (Wb : TetraBranchMass D)
    (a : ℝ) (k : Fin 4 → ℝ) :
    star (Kbranch D Wb a k) =
      ((a : ℂ)⁻¹) •
        ((-Complex.I) • TetraEuclideanSlashData.Q D (sinCoeffs k) + Wb.W k) := by
  s o r r y
```

### 6.3 Generalized square (Q3, replaces `K_star_mul`)

```lean
/-- Exact flavored Wilson square.  The cross term `i·[W,Q]` cancels by
`W_comm`; the result is the Hermitian PSD matrix `(qExact·I + W²)/a²`,
NOT a scalar multiple of `I`. -/
theorem Kbranch_star_mul (D : TetraEuclideanSlashData Spin)
    (Wb : TetraBranchMass D) (a : ℝ) (k : Fin 4 → ℝ) :
    star (Kbranch D Wb a k) * Kbranch D Wb a k =
      ((a : ℂ)⁻¹ ^ 2) •
        ( ((TetraQSquareExact.qExact (sinCoeffs k) : ℝ) : ℂ)
            • (1 : Matrix Spin Spin ℂ)
          + Wb.W k * Wb.W k ) := by
  s o r r y

/-- Specialization check: the scalar lane recovers `K_star_mul`. -/
theorem Kbranch_ofScalar_eq_K (D : TetraEuclideanSlashData Spin)
    (a r rho : ℝ) (k : Fin 4 → ℝ) :
    Kbranch D (TetraBranchMass.ofScalar D r rho) a k = K D a r rho k := by
  s o r r y
```

### 6.4 Generic PSD norm bridge (Q3, replaces the `l2NormSq` bridge)

```lean
/-- If `A^* A = c•1 + B^* B`, then `A` adds `‖B ψ‖²` to the scaled norm. -/
theorem l2NormSq_mulVec_of_star_mul_eq_smul_add_starMul
    {n : Type*} [Fintype n] [DecidableEq n]
    (A B : Matrix n n ℂ) (c : ℝ)
    (h : star A * A = ((c : ℝ) : ℂ) • (1 : Matrix n n ℂ) + star B * B)
    (v : n → ℂ) :
    l2NormSq (A.mulVec v) = c * l2NormSq v + l2NormSq (B.mulVec v) := by
  s o r r y

/-- Quadratic-form decomposition of the flavored Wilson symbol. -/
theorem Kbranch_l2NormSq_decomp (D : TetraEuclideanSlashData Spin)
    (Wb : TetraBranchMass D) (a : ℝ) (ha : 0 < a) (k : Fin 4 → ℝ)
    (psi : Spin → ℂ) :
    l2NormSq ((Kbranch D Wb a k).mulVec psi) =
      (1 / a ^ 2) *
        ( TetraQSquareExact.qExact (sinCoeffs k) * l2NormSq psi
          + l2NormSq ((Wb.W k).mulVec psi) ) := by
  s o r r y
```

### 6.5 Flavored coefficient certificate + form gap (Q3/Q4, replaces
`K_symbol_l2NormSq_gap`)

```lean
/-- A pointwise form lower bound for the branch mass square `W(k)²`. -/
def BranchFormLower (Wb : TetraBranchMass D)
    (wBranchMin : (Fin 4 → ℝ) → ℝ) : Prop :=
  ∀ k, ∀ psi : Spin → ℂ,
    wBranchMin k * l2NormSq psi ≤ l2NormSq ((Wb.W k).mulVec psi)

/-- Gap transfer: a flavored coefficient certificate `μ ≤ qLower + wBranchMin`
yields an operator gap `μ/a²` for `Kbranch`.  This is silent about the island;
`wBranchMin` is expected to be positive only on the complement sector. -/
theorem Kbranch_symbol_l2NormSq_gap
    (D : TetraEuclideanSlashData Spin) (Wb : TetraBranchMass D)
    (a mu : ℝ) (ha : 0 < a) (hmu : 0 < mu)
    (wBranchMin : (Fin 4 → ℝ) → ℝ)
    (hform : BranchFormLower Wb wBranchMin)
    (hcert : ∀ k,
      mu ≤ TetraQSquareExact.qLower (sinCoeffs k) + wBranchMin k) :
    ∃ gamma : ℝ, 0 < gamma ∧
      ∀ k : Fin 4 → ℝ, ∀ psi : Spin → ℂ,
        gamma * l2NormSq psi ≤ l2NormSq ((Kbranch D Wb a k).mulVec psi) := by
  s o r r y
```

### 6.6 Chirality transfer (carries over unchanged)

```lean
def Hbranch (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (Wb : TetraBranchMass D)
    (a : ℝ) (k : Fin 4 → ℝ) : Matrix Spin Spin ℂ :=
  gamma5 * Kbranch D Wb a k

theorem Hbranch_l2NormSq_eq_Kbranch_l2NormSq
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (Wb : TetraBranchMass D)
    (a : ℝ) (k : Fin 4 → ℝ)
    (hgamma5 : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (psi : Spin → ℂ) :
    l2NormSq ((Hbranch gamma5 D Wb a k).mulVec psi) =
      l2NormSq ((Kbranch D Wb a k).mulVec psi) := by
  s o r r y
```

### 6.7 Per-species reuse of `firstBandMu` (Q4)

A separate spectral-data structure (kept apart from `TetraBranchMass`), plus the
reuse lemma. Only the *shape* is given; the island/index obligations are
explicitly left as out-of-scope `Prop` fields to be discharged elsewhere.

```lean
/-- Fixed-frame spectral data for a flavored branch mass: a (momentum-independent)
flavor index, per-species scalar Wilson profiles, and a designated island set.
The eigenframe is `Q`-invariant by commutation. -/
structure TetraBranchSpectralData (D : TetraEuclideanSlashData Spin)
    (Wb : TetraBranchMass D) where
  Flavor : Type*
  speciesRho : Flavor → ℝ      -- ρ_f per species
  island : Set Flavor          -- retained light branch(es)
  -- (eigenframe + diagonalization fields elided in this sketch)

/-- Complement-sector uniform gap constant: the min of scalar `firstBandMu`
over the heavy/complement species.  Reuses the scalar certificate verbatim. -/
-- def flavorBandMu (r : ℝ) (S : TetraBranchSpectralData D Wb) [Fintype …] : ℝ :=
--   ⨅ f ∈ Sᶜ.island, firstBandMu r (S.speciesRho f)

/-- Reuse statement (target):  if every complement species is in-band
(`0 < ρ_f < 2r`), the complement-sector form lower bound `wBranchMin`
dominates `flavorBandMu r S`, which is `> 0`. -/
theorem flavor_complement_gap_from_firstBandMu
    (r : ℝ) (S : TetraBranchSpectralData D Wb)
    (hband : ∀ f, f ∉ S.island → FirstWilsonBand r (S.speciesRho f)) :
    True := by   -- placeholder for the per-species min-of-firstBandMu bound
  trivial
```

---

## 7. Recommended proof order for the implementer

1. `Kbranch`, `Kbranch_star`, `TetraBranchMass.ofScalar` (one-liners from
   `K_star`/centrality).
2. `Kbranch_star_mul` — the verified §2.1 identity plus `W_comm` to kill the
   cross term and `Q_square_exact` for `Q²`. This is the keystone.
3. `Kbranch_ofScalar_eq_K` and a corollary that `Kbranch_star_mul` specializes
   to `K_star_mul` (sanity/regression check against the scalar lane).
4. `l2NormSq_mulVec_of_star_mul_eq_smul_add_starMul` (generalize the existing
   `l2NormSq_mulVec_of_star_mul_eq_smul_one` calc), then
   `Kbranch_l2NormSq_decomp`.
5. `BranchFormLower` + `Kbranch_symbol_l2NormSq_gap` (drop the `W` term as
   nonneg, then reuse `scalarWilsonCoeff_uniform_scaled_gap_from_qLower`-style
   scaling).
6. `Hbranch_*` (copy the scalar `H_*` proofs verbatim).
7. Spectral layer (`TetraBranchSpectralData`, per-species `firstBandMu` reuse) —
   lowest priority; needs the simultaneous-diagonalization machinery.

Steps 1–6 are pure algebra/positivity and should be straightforward
generalizations of the existing scalar file. Step 7 and the island/chiral-index
content are the genuinely open part and are **out of scope for this
gap-transfer layer** (see §0, §4.4, §5).

---

## 8. Scope reminder (non-negotiable)

This report and the proposed `TetraBranchWilsonSymbol.lean` establish only the
**algebra and gap-transfer** layer: the exact flavored square, the PSD form
decomposition, and a *conditional* gap parameterized by a flavored certificate.

They do **not** establish branch retention. No theorem here exhibits a target
spectral island, and none computes a nonzero origin chiral index. Per the
release plan and the C262 audit, branch retention requires all three clauses
(island with separation `δ > 0`, nonzero chiral index, true inverse bad-sector
gap on the complement). Only the third clause is touched here, and only as a
gap-*transfer* mechanism that must be fed an island-excluding certificate from a
later, separate layer.
