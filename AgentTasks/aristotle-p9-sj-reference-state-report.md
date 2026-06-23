# P9 design note: a finite Sorkin–Johnston (SJ) reference state for a causal diamond

Job: `null-edge-p9-sj-reference-state-20260623`
Target: `AgentTasks/aristotle-p9-sj-reference-state-report.md`
Scope: strategy/design note. No theorem in this note is asserted as proved; every
Lean signature below is a *proposed* `by sorry` target. Claim boundary: this is
finite linear algebra over a finite causal set, used as a discrete stand-in for
the continuum SJ vacuum. No continuum field theory, no continuum modular
Hamiltonian, and no area-law theorem is asserted here.

This note is written to be consistent with the existing P7/P9 draft API:

* finite cochains `Cochain n := Fin n → ℝ` and the Euclidean pairing `dot`
  (`PhysicsSM/Draft/NullEdgeP9DiamondSourceVisibilityCore.lean`);
* finite causal-set order counting on `Fin n`
  (`PhysicsSM/Draft/NullEdgeCausetOrderingFraction.lean`);
* the classical finite relative-entropy / observer-channel spine `FinDist`,
  `FinObs`, `klDiv`, data processing, and exact recoverability
  (`PhysicsSM/Draft/NullEdgeRelativeEntropyObserverRoadmap.lean`);
* the finite quantum-measure / Gram-functional layer
  (`PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean`).

The intended home for the new code is a single Mathlib-only draft file, e.g.
`PhysicsSM/Draft/NullEdgeP9SJReferenceState.lean`, in namespace
`PhysicsSM.Draft.NullEdgeP9SJReferenceState`, marked `noncomputable section` and
`flagged as a draft scaffold in the same honesty style as the existing roadmap`.

---

## 1. Finite causal diamond representation

### 1.1 Vertex set and preorder

Fix `n : ℕ` and take the **vertex set** `V := Fin n`. The diamond's causal
structure is a **preorder** `≼` (reflexive + transitive) given as a Boolean
relation, encoded as a 0/1 matrix so it can also be read as a matrix over `ℝ`.

```lean
variable (n : ℕ)
abbrev V := Fin n

/-- Causal relation as a decidable relation. `prec x y` means `x ≼ y`
    (`x` is in the causal past of `y`, including `x = y`). -/
structure FinCauset (n : ℕ) where
  prec : Fin n → Fin n → Prop
  decPrec : DecidableRel prec
  refl  : ∀ x, prec x x
  trans : ∀ x y z, prec x y → prec y z → prec x z
  antisymm : ∀ x y, prec x y → prec y x → x = y   -- partial order (acyclic causet)
```

`antisymm` is the causal-set acyclicity condition (no closed causal loops); it
makes `≼` a genuine partial order. The *strict* relation `x ≺ y := prec x y ∧ x ≠ y`
is the irreflexive causal order used for link/relation counting, matching the
`p.1 < p.2` counting style already in `NullEdgeCausetOrderingFraction.lean`.

### 1.2 A concrete diamond family (the canonical test instance)

For a runnable, `decide`-friendly baseline take the **2D causal diamond on an
integer lozenge** in light-cone coordinates `(u, w)`. Sprinkle / place `n` points
with coordinates `coord : Fin n → ℤ × ℤ` and define

```text
x ≼ y  ↔  (coord x).1 ≤ (coord y).1  ∧  (coord x).2 ≤ (coord y).2
```

i.e. the componentwise product order in null coordinates restricted to the
lozenge `{(u,w) : |u| + |w| ≤ L}`. This is the standard discrete causal diamond:
reflexive, transitive, antisymmetric by construction (it is a sub-order of
`ℤ × ℤ`), and every relation matrix below becomes a concrete `Fin n` matrix that
`decide`/`native_decide` can evaluate. The smallest nontrivial instances are the
3-chain (`n = 3`, totally ordered) and the 4-element "diamond" with a min, a max,
and two incomparable middle points.

### 1.3 The causal/incidence matrix

```lean
/-- Causal matrix `C x y = 1` if `x ≼ y` (else 0), as a real matrix. -/
def causalMatrix (P : FinCauset n) : Matrix (Fin n) (Fin n) ℝ :=
  fun x y => if P.prec x y then 1 else 0
```

`causalMatrix` is upper-triangular in any linear extension of `≼` (a topological
sort), which is the structural fact that makes the retarded/advanced split below
well defined and the inverses below exist.

---

## 2. Pauli–Jordan operator `iΔ = i(R − A)`

In the continuum the Pauli–Jordan (PJ) function is `Δ = G_R − G_A`, the
difference of retarded and advanced Green's functions of the field operator
`(□ + m²)`. On a finite causal set we mirror Johnston's discrete scalar-field
prescription: the **retarded propagator is built directly from the causal
matrix**, and the advanced propagator is its transpose.

### 2.1 Discrete d'Alembertian / hopping operator

Pick a (real, symmetric) **kinetic operator** `K : Matrix V V ℝ` that plays the
role of `(□ + m²)` and whose nonzero off-diagonal entries respect causal links.
Two standard finite choices:

* **Link/adjacency model (Johnston-style):** `K = a·I − b·B` where `B` is the
  *link matrix* (covering relations of `≼`) and `a, b > 0` are the on-site mass
  and hopping amplitude. The retarded Green's function is then the causal
  resolvent
  `R = (a·I − b·L)⁻¹` where `L` is the strictly-lower-triangular link matrix in
  a linear extension, so the Neumann series `R = Σ_k (b/a)^k L^k / a` terminates
  (nilpotent `L`) and `R` is itself supported on `≼`.
* **Direct causal model:** take `R` proportional to the causal matrix itself,
  `R = c · causalMatrix` for a coupling `c` (the "amplitude per causal relation"
  normalization). This is the crudest discretization but keeps everything
  manifestly supported on the order relation.

```lean
/-- Retarded Green's function: supported on `x ≼ y`, lower-triangular in a
    linear extension. Provided abstractly so both the link-resolvent and
    direct-causal models instantiate it. -/
structure RetardedGreen (P : FinCauset n) where
  R : Matrix (Fin n) (Fin n) ℝ
  support : ∀ x y, ¬ P.prec x y → R x y = 0      -- retarded support condition
```

### 2.2 Advanced = transpose, Pauli–Jordan = antisymmetric part

```lean
/-- Advanced Green's function is the transpose of the retarded one. -/
def advanced (G : RetardedGreen P) : Matrix (Fin n) (Fin n) ℝ := (G.R)ᵀ

/-- Real Pauli–Jordan matrix Δ = R − A = R − Rᵀ (real, antisymmetric). -/
def pauliJordanReal (G : RetardedGreen P) : Matrix (Fin n) (Fin n) ℝ :=
  G.R - (G.R)ᵀ

/-- Hermitian Pauli–Jordan operator iΔ over ℂ. -/
def iDelta (G : RetardedGreen P) : Matrix (Fin n) (Fin n) ℂ :=
  Complex.I • ((pauliJordanReal G).map (Complex.ofReal))
```

Key structural facts to discharge first (cheap, and they gate everything else):

* `pauliJordanReal` is **real antisymmetric**: `Δᵀ = −Δ`.
* therefore `iΔ` is **Hermitian**: `(iΔ)ᴴ = iΔ`
  (`Matrix.IsHermitian (iDelta G)`), because `i·(antisymmetric real) = i·M` with
  `M` real antisymmetric gives `Mᴴ = (Mᵀ)conj = (−M)·1 = −M`, and the extra `i`
  flips sign again. This is the discrete analogue of "`iΔ` is self-adjoint".
* `iΔ` has **purely real spectrum** symmetric about 0 (eigenvalues come in
  `±λ` pairs, plus a kernel), the finite shadow of the continuum statement that
  the PJ spectrum is symmetric.

---

## 3. SJ projection: positive-spectrum two-point function `W`

The Sorkin–Johnston state is *defined* as the positive part of `iΔ`. Discretely:

> **Definition (finite SJ two-point function).** Let `iΔ = Σ_k λ_k |v_k⟩⟨v_k|`
> be the spectral decomposition of the Hermitian matrix `iΔ`. The SJ two-point
> function is the restriction to the **positive eigenspace**:
> `W := Σ_{λ_k > 0} λ_k |v_k⟩⟨v_k| = (iΔ)_+`,
> the positive part of `iΔ`.

This is exactly the two defining SJ conditions in finite form:

1. **`W` is positive semidefinite** (`0 ⪯ W`) — a genuine quantum state's
   two-point function.
2. **`W − W̄ = iΔ`** (commutator/Peierls condition): the antisymmetric part of
   `W` reproduces the Pauli–Jordan operator. With `W = (iΔ)_+` and
   `W̄ = conj W = −(iΔ)_−` one gets `W − W̄ = (iΔ)_+ + (iΔ)_− = iΔ` on the
   range of `iΔ`.
3. **`W · (negative eigenvectors of iΔ) = 0`** (ground-state / "no negative
   frequency" condition).

### 3.1 Spectral API

Mathlib provides the spectral theorem for Hermitian matrices via
`Matrix.IsHermitian.spectral_theorem`, eigenvalues `IsHermitian.eigenvalues`
(real), and the unitary eigenvector matrix `IsHermitian.eigenvectorUnitary`.
The positive part is assembled by zeroing nonpositive eigenvalues:

```lean
/-- SJ two-point function: positive spectral part of iΔ. `hH : (iDelta G).IsHermitian`. -/
noncomputable def sjTwoPoint (G : RetardedGreen P)
    (hH : (iDelta G).IsHermitian) : Matrix (Fin n) (Fin n) ℂ :=
  let U := hH.eigenvectorUnitary
  (U : Matrix (Fin n) (Fin n) ℂ)
    * Matrix.diagonal (fun k => (max (hH.eigenvalues k) 0 : ℝ))
    * (star (U : Matrix (Fin n) (Fin n) ℂ))
```

### 3.2 Defining properties to prove (ranked in §"next theorem signatures")

* `sjTwoPoint_posSemidef : 0 ⪯ sjTwoPoint G hH` (PSD).
* `sjTwoPoint_peierls : sjTwoPoint G hH - star (sjTwoPoint G hH) = iDelta G`
  on `range (iDelta G)` (the Pauli–Jordan reproduction condition).
* `sjTwoPoint_hermitian` and self-adjointness bookkeeping.

These three are the finite *characterizing theorem* of the SJ state and are the
right unit-test target before any entropy work.

---

## 4. Spectral truncation (Johnston finite-density / area-law cut)

The naive `W = (iΔ)_+` on a finite causet has a well-documented pathology: its
**high-eigenvalue tail is dominated by short, non-local "links"** and overcounts
ultraviolet correlations, so the entanglement entropy of a sub-diamond scales
with the **volume** rather than the **area** of the cut. Johnston's remedy
(double-cutoff / finite-density truncation) is to keep only eigenvalues in a
physical window. We formalize it as a spectral mask on `iΔ`.

### 4.1 Double cutoff on the PJ spectrum

Order the positive eigenvalues `λ_1 ≥ λ_2 ≥ …`. Introduce:

* a **UV cutoff** `λ_max` (or a kept-rank `r`): discard eigenmodes with
  `λ_k > λ_max`, removing the sub-link UV modes that drive the volume law;
* optionally an **IR cutoff** `λ_min`: discard near-kernel modes that are
  numerically unstable in the projection.

```lean
/-- Spectral window mask. `keep λ = true` selects an eigenmode. -/
def specWindow (lamMin lamMax : ℝ) (lam : ℝ) : Bool :=
  decide (0 < lam) && decide (lamMin ≤ lam) && decide (lam ≤ lamMax)

/-- Truncated SJ two-point function: SJ projection restricted to the kept window. -/
noncomputable def sjTwoPointTrunc (G : RetardedGreen P)
    (hH : (iDelta G).IsHermitian) (lamMin lamMax : ℝ) :
    Matrix (Fin n) (Fin n) ℂ :=
  let U := hH.eigenvectorUnitary
  (U : Matrix (Fin n) (Fin n) ℂ)
    * Matrix.diagonal (fun k =>
        if specWindow lamMin lamMax (hH.eigenvalues k)
        then (hH.eigenvalues k : ℝ) else 0)
    * (star (U : Matrix (Fin n) (Fin n) ℂ))
```

### 4.2 What the truncation must buy us (the falsifiable content)

The physically meaningful, finitely checkable claims (all `decide`/`native_decide`
on the canonical diamond family of §1.2):

* **Monotone rank/trace control:** `trace (sjTwoPointTrunc …) ≤ trace (sjTwoPoint …)`,
  and the kept rank equals `card {k | specWindow …}`. (Easy, structural.)
* **Idempotent-on-window:** truncation commutes with itself; a second identical
  window is a no-op.
* **Area-law diagnostic (the headline empirical target):** for the nested
  sub-diamonds of §5, the *truncated* SJ entanglement entropy
  `S(λ_min, λ_max)` grows sublinearly in the sub-diamond volume and tracks the
  boundary-link count `chainRelationCount`-style perimeter, whereas the
  *untruncated* `S` grows linearly in volume. This is stated as a numerical
  inequality on concrete `n = 3,4,6,…` diamonds rather than an asymptotic
  theorem — it is the honest finite content of "area law".

The recommended normalization (so windows are comparable across diamond sizes)
is Johnston's **finite density**: choose `λ_max` so that the kept fraction
`r/n` is held fixed as `n` grows (a fixed sprinkling density), rather than a
fixed absolute `λ_max`.

---

## 5. Entropy & recoverability connection

Here the new SJ layer plugs into the *existing* finite relative-entropy spine in
`NullEdgeRelativeEntropyObserverRoadmap.lean`. The bridge is the eigenvalue
distribution of the (truncated) SJ correlator.

### 5.1 From correlator to a `FinDist`

A Gaussian/quasi-free finite state's entropy is a function of its correlator
spectrum. Define the **modular spectrum distribution** by normalizing the kept
SJ eigenvalues to a probability vector:

```lean
/-- Normalized SJ spectral weights as a finite distribution (the modular
    spectrum of the truncated SJ state). -/
noncomputable def sjSpectralDist (G : RetardedGreen P)
    (hH : (iDelta G).IsHermitian) (lamMin lamMax : ℝ) : FinDist (Fin n) := …
```

(weights `w_k = λ_k·𝟙[window] / Σ λ_j·𝟙[window]`, nonnegativity and `sum_one`
discharged from positivity of the kept eigenvalues — exactly the `FinDist`
obligations already used in the roadmap).

### 5.2 Nested sub-diamonds as observer channels

A sub-diamond `D' ⊆ D` (an order ideal/causal subinterval of the causet) defines
a **restriction map** `V → V'` that coarse-grains the spectrum. Encode it as a
`FinObs` (column-stochastic channel) `restrictChannel D'`. Then the two
diagnostics we want are *already theorems in the roadmap*, applied to the SJ
spectral distributions:

* **Monotonicity / data processing (`klDiv` non-increase under `FinObs`):**
  `klDiv (pushforward T ρ) (pushforward T σ) ≤ klDiv ρ σ` for the SJ spectral
  distributions `ρ = sjSpectralDist D`, `σ` = reference, `T = restrictChannel D'`.
  This is the discrete relative-entropy monotonicity along nested diamonds (the
  P9 "source-visibility / recoverability" inequality), reusing the proved
  `klDiv` DPI rather than reproving it.
* **Convexity along a nested chain `D₀ ⊇ D₁ ⊇ … ⊇ D_m`:** the sequence
  `S_k := klDiv (sjSpectralDist D_k) (reference)` is monotone non-increasing,
  giving a finite "second-law-along-inclusions" diagnostic.
* **Exact recoverability / equality case:** equality in DPI holds iff the
  restriction channel is sufficient for `(ρ, σ)` — i.e. a discrete Petz
  recovery condition — which is exactly the roadmap's equality-case lemma
  specialized to `restrictChannel`.

### 5.3 Quantum upgrade (flagged, not asserted)

The roadmap's classical layer is commutative (diagonal). The genuine SJ
relative entropy is the **matrix** Umegaki entropy
`S(W ‖ W_ref) = tr(W (log W − log W_ref))`. This requires the quantum matrix
layer that the roadmap explicitly lists as open. The honest staging is: prove
the classical spectral-distribution diagnostics now (they are real theorems via
the existing DPI), and list the matrix Umegaki DPI as the downstream blocker.

---

## 6. Suggested file/proof staging

1. `FinCauset`, `causalMatrix`, the concrete §1.2 diamond instance, plus
   `refl/trans/antisymm` and upper-triangularity lemmas (`decide`-friendly).
2. `RetardedGreen` for the direct-causal and link-resolvent models; support and
   nilpotency lemmas.
3. `pauliJordanReal` antisymmetry, `iDelta` Hermiticity, spectrum symmetry.
4. `sjTwoPoint` PSD + Peierls characterization (the SJ defining theorem).
5. `sjTwoPointTrunc`, window structural lemmas, finite area-law diagnostics
   by `native_decide` on small diamonds.
6. `sjSpectralDist`, `restrictChannel`, and the DPI/convexity/equality
   corollaries via the existing roadmap API.

---

## Summary

```text
overall assessment:
  A finite SJ reference state is well-posed and buildable inside the existing
  P7/P9 finite linear-algebra + relative-entropy API. The construction reduces to
  (a) a 0/1 causal matrix on V = Fin n, (b) a retarded Green's function supported
  on the order with advanced = transpose, (c) the Hermitian Pauli–Jordan matrix
  iΔ = i(R − Rᵀ), (d) its positive spectral part as the SJ two-point function W,
  and (e) a spectral window truncation feeding the already-proved finite klDiv
  data-processing spine. Mathlib's Hermitian spectral theorem supplies every
  primitive needed. No continuum claim is made; the "area law" is stated as a
  finite numerical diagnostic, not an asymptotic theorem.

proposed core definitions:
  FinCauset (V := Fin n, partial order ≼); causalMatrix; the integer-lozenge
  diamond instance; RetardedGreen.R (direct-causal c·causalMatrix and
  link-resolvent (aI − bL)⁻¹ models); advanced := Rᵀ; pauliJordanReal := R − Rᵀ;
  iDelta := I • (Δ : ℂ); sjTwoPoint := positive spectral part of iΔ;
  sjTwoPointTrunc := windowed spectral part; sjSpectralDist : FinDist (Fin n);
  restrictChannel : FinObs (Fin n) (Fin n').

spectral truncation formulation:
  Spectral mask specWindow lamMin lamMax on the eigenvalues of iΔ (UV cutoff to
  kill sub-link volume-law modes, optional IR cutoff for kernel stability), with
  Johnston finite-density normalization (fix kept fraction r/n, not absolute
  λmax). Targets: trace/rank monotonicity, window idempotence, and a finite
  area-law-vs-volume-law diagnostic on small diamonds via native_decide.

relative entropy / data-processing connection:
  Normalize the kept SJ eigenvalues to sjSpectralDist : FinDist; encode nested
  sub-diamond restriction as a column-stochastic FinObs; then reuse the proved
  finite klDiv data-processing inequality, convexity-along-chain, and
  equality/recoverability (sufficiency / discrete Petz) lemmas from
  NullEdgeRelativeEntropyObserverRoadmap. The genuine matrix Umegaki SJ entropy
  is deferred to the (open) quantum matrix layer.

ranked next theorem signatures:
  1. iDelta_isHermitian  : (iDelta G).IsHermitian
       (gates the whole spectral construction; expected easy from Δᵀ = −Δ).
  2. pauliJordanReal_antisymm : (pauliJordanReal G)ᵀ = - pauliJordanReal G.
  3. sjTwoPoint_posSemidef : 0 ⪯ sjTwoPoint G hH.
  4. sjTwoPoint_peierls :
       sjTwoPoint G hH - star (sjTwoPoint G hH) = iDelta G  (on range iΔ).
  5. sjSpectralDist_wellDef : the kept-eigenvalue weights form a FinDist
       (nonneg + sum_one).
  6. sj_dpi_nested :
       klDiv (pushforward (restrictChannel D') (sjSpectralDist D))
             (pushforward (restrictChannel D') ref)
         ≤ klDiv (sjSpectralDist D) ref.
  7. sj_entropy_chain_monotone : k ↦ klDiv (sjSpectralDist (Dchain k)) ref
       is antitone along a nested diamond chain.
  8. sjTwoPointTrunc_trace_le :
       trace (sjTwoPointTrunc …) ≤ trace (sjTwoPoint …)  (truncation control).

likely blockers:
  - Mathlib spectral-API friction: assembling the positive part via
    eigenvectorUnitary / spectral_theorem and proving PSD and the Peierls
    identity on range(iΔ) can be fiddly (unitary star bookkeeping, coercions
    ℝ→ℂ). Budget the most effort here.
  - Existence/invertibility of the link-resolvent model (need L nilpotent in a
    linear extension); the direct-causal model avoids this and should be the
    primary instance.
  - Area-law claim is only a finite numerical diagnostic; a genuine asymptotic
    area law is out of scope and should not be asserted.
  - Matrix Umegaki relative entropy (log of PSD matrices) and its DPI are not in
    Mathlib and sit in the roadmap's open quantum layer; the quantitative
    quantum SJ entropy DPI is the real downstream blocker.
```
