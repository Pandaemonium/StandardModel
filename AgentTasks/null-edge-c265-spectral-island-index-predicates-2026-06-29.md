# Gate C1 — Spectral-island and branch-index predicates (C265)

Date: 2026-06-29
Status: theorem-design report (non-blocking). Companion Lean draft:
`PhysicsSM/Draft/NullEdge/GateC1/SpectralIslandIndexPredicates.lean`
(builds clean, `s o r r y`-free, standard assumptions only).

Prompt of record: `PROMPT.md` (Aristotle job C265).
Upstream context: C262 branch-retention audit
(`AgentTasks/null-edge-c262-branch-retention-audit-2026-06-29.md`) and the C263
index↔anomaly bridge plan
(`AgentTasks/null-edge-c263-index-anomaly-bridge-plan-2026-06-29.md`).

---

## 0. One-paragraph summary

C262 established that the *scalar* Wilson chain retains only branch-retention
**clause (3)** — a uniform true inverse bad-sector gap — and that it can never
satisfy clauses **(1)** (separated target spectral island) and **(2)** (nonzero
origin chiral index) because a scalar mass `m(k)·I` is central on spin and
carries no chirality. Before committing to a concrete branch term `W_branch`, we
need the **predicate vocabulary** for all three clauses, stated in the
finite-dimensional regime where the prover is strongest and where no overlap
locality or gauge-field input is required. This report fixes that vocabulary,
recommends which spectral representation to use, gives a three-clause
`BranchRetentionCertificate` structure, and supplies near-Lean theorem
statements plus acceptance tests — including the decisive **zero-index commuting
trap**, which is fully proved in the companion Lean file. The trap is the
structural obstruction any genuine `W_branch` must break.

All claims below are draft-safe: finite `Matrix n n ℂ` linear algebra, no
functional calculus, no operator norm, no locality, no gauge fields.

---

## 1. Question 1 — predicates for a separated target spectral island

The branch criterion (C262 §1, clause 1) asks for a *target spectral island
separated by `delta > 0`*. In finite dimensions the cleanest faithful predicate
is a **spectral gap on the eigenvalues of a Hermitian sign-kernel `H`**: the
spectrum splits into a complement band `(-∞, c]` and a target island
`[c + delta, +∞)` with an empty separating window `(c, c + delta)`, and the
island is nonempty.

```lean
def HasSeparatedIsland (H : Matrix n n ℂ) (hH : H.IsHermitian)
    (c delta : ℝ) : Prop :=
  0 < delta ∧
    (∃ i, c + delta ≤ hH.eigenvalues i) ∧
    (∀ i, hH.eigenvalues i ≤ c ∨ c + delta ≤ hH.eigenvalues i)
```

This is the right primitive because:

* `H.IsHermitian.eigenvalues : n → ℝ` is exactly Mathlib's finite real spectrum,
  so the predicate is decidable in concrete cases and needs no analysis.
* `delta` is literally the spectral-gap width; `delta > 0` is the separation.
* It is the finite analogue of "the resolvent contour `|z − island| = delta/2`
  encircles only the target band", without any contour integral.
* It composes with the *uniform inverse gap* the scalar chain already proves:
  `K_symbol_l2NormSq_gap` is the statement "`0` is `delta`-separated from the
  whole spectrum of `H = γ₅ K`". The island predicate refines this from a single
  global gap (no kernel anywhere) to a *two-band* split, which is what clause (1)
  actually demands.

A second, projector-based predicate is given in §2; the two are complementary
(spectrum-level vs. operator-level) and the certificate in §4 carries both.

---

## 2. Question 2 — which spectral representation to use

Recommendation, in order of when to introduce each:

1. **First: explicit finite spectra (`eigenvalues`).** Use `HasSeparatedIsland`
   as the *definition* of separation. It is the most faithful to "separated by
   `delta`", is decidable on toy models, and connects directly to the existing
   `firstBandMu`/`K_symbol_l2NormSq_gap` gap certificates. Start here.

2. **Then: an abstract Riesz / spectral projector as a predicate** (not a
   resolvent integral). In finite dimensions the Riesz projector onto the island
   is just *the* spectral projector; package it as a predicate `P` is idempotent,
   Hermitian, commutes with `H`, and is order-separated:

   ```lean
   structure IsIslandProjector (H P : Matrix n n ℂ) (c delta : ℝ) : Prop where
     idempotent : P * P = P
     hermitian  : Pᴴ = P
     commutes   : P * H = H * P
     gapAbove   : (P * H * P - (c + delta : ℂ) • P).PosSemidef          -- H ≥ c+δ on range P
     gapBelow   : ((c : ℂ) • (1 - P) - (1 - P) * H * (1 - P)).PosSemidef -- H ≤ c on range (1−P)
   ```

   (`PosSemidef` over `ℂ` requires `open scoped ComplexOrder`; the compressed
   operators `P*H*P` and `(1−P)*H*(1−P)` are Hermitian, so the order conditions
   are meaningful.) This is the object the **chiral index** is taken against
   (§3) and is the natural input to the C263 `overlapIndex` plan, where
   `Π = (1 + T)/2` for `T = sign(H)`.

3. **Avoid first: polynomial spectral projectors.** A projector built as a
   polynomial `p(H)` (interpolating `1` on the island, `0` on the complement) is
   useful *later* for **construction/existence proofs** — it gives an explicit
   witness for `IsIslandProjector` from `HasSeparatedIsland` via Lagrange
   interpolation on the eigenvalues — but it is a poor *primitive* because it
   bakes in a specific functional form. Keep it as a construction lemma, not a
   definition.

4. **Avoid first: matrix block decomposition.** Block-triangular / `2×2`
   operator-matrix decompositions are representation-dependent (they presuppose a
   basis adapted to the split) and are exactly what the abstract projector
   predicate lets us *avoid*. Use blocks only inside concrete model proofs, never
   as the interface.

Summary: **define** separation with explicit finite spectra; **carry** the
abstract projector predicate as the operator-level interface and index target;
**use** polynomial projectors as a construction tool; **avoid** block
decomposition at the interface.

---

## 3. Question 3 — representing a nonzero origin chiral index without overclaiming

The origin chiral index must be a *finite trace*, not an analytic index. Define
it as the trace of the chirality through the island projector:

```lean
def chiralIndex (gamma5 P : Matrix n n ℂ) : ℂ := (gamma5 * P).trace
```

and state clause (2) as `chiralIndex gamma5 P ≠ 0`.

Why this does not overclaim:

* It is `Matrix.trace` of a finite matrix — no Fredholm operator, no kernel/
  cokernel dimension counting, no Atiyah–Singer / Lüscher index *theorem* is
  invoked. It is just `Σ_i (γ₅ P)_{ii}`.
* When `γ₅` is a Hermitian involution and `P` a spectral projector, this trace
  is automatically a (real) **integer** — the net chirality on the island — so
  the definition is *compatible* with the genuine index, but the predicate layer
  only needs nonvanishing and stays agnostic about integrality. Integrality is
  stated separately (§5, `chiralIndex_int`) as a future lemma, not assumed.
* For the **overlap** normalization the same object specializes to the C263
  index. With `Dov = 1 + γ₅ ε`, the GW-modified chirality `γ₅(1 − ½ Dov)` has
  trace `−½ Tr(γ₅ ε)`:

  ```lean
  def overlapIndex (gamma5 eps : Matrix n n ℂ) : ℂ :=
    (-(1 / 2 : ℂ)) * (gamma5 * eps).trace
  ```

  so the predicate layer and the C263 bridge use the *same* trace primitive.

This keeps clause (2) honest: we claim a nonzero finite trace, and flag (but do
not silently assume) the integrality and "= topological charge" content that
belongs to the analytic theory.

---

## 4. Question 4 — the `BranchRetentionCertificate` (exactly three clauses)

```lean
structure BranchRetentionCertificate
    (gamma5 H K P : Matrix n n ℂ) (hH : H.IsHermitian) (c delta : ℝ) : Prop where
  -- Clause 1: separated target spectral island, with P its spectral projector.
  islandSeparation :
    HasSeparatedIsland H hH c delta ∧ IsIslandProjector H P c delta
  -- Clause 2: nonzero origin chiral index of the target island.
  nonzeroIndex : chiralIndex gamma5 P ≠ 0
  -- Clause 3: true inverse bad-sector gap on the complement range (1 − P).
  inverseBadSectorGap :
    ∃ gamma : ℝ, 0 < gamma ∧
      ((1 - P) * (Kᴴ * K) * (1 - P) - (gamma : ℂ) • (1 - P)).PosSemidef
```

Reading of the data: `K` is the (free/Wilson) symbol matrix, `H` the Hermitian
sign-kernel (e.g. `H = γ₅ K`), `P` the island projector, `γ₅` the chirality.

* **Clause 1** is exactly §1+§2: a `delta`-separated spectrum *and* a witnessing
  spectral projector.
* **Clause 2** is exactly §3: a nonzero finite chiral trace on the island.
* **Clause 3** is the inverse-propagator gap of C262 restricted to the bad
  sector `range(1 − P)`: `(1−P) Kᴴ K (1−P) ≥ gamma · (1−P)` in PSD order. This is
  a genuine *inverse* gap (`Kᴴ K` bounded below), explicitly **not** a
  propagator-zero / mirror-removal statement. The scalar chain's
  `K_symbol_l2NormSq_gap` is the global (`P = 0`) special case and is the
  template for discharging this clause.

The structure has *exactly* these three fields, matching the C262 criterion
one-to-one.

---

## 5. Question 5 — near-Lean theorem statements and acceptance tests

### 5.1 The zero-index commuting trap (proved)

The decisive no-go. If a *balance symmetry* `J` is an involution that
**anticommutes** with the chirality and **commutes** with the island projector,
the chiral index vanishes:

```lean
theorem zero_index_commuting_trap
    (gamma5 P J : Matrix n n ℂ)
    (hJ : J * J = 1)
    (hanti : J * gamma5 = -(gamma5 * J))
    (hcomm : J * P = P * J) :
    chiralIndex gamma5 P = 0
```

Proof idea (and the actual Lean proof): conjugation by the involution `J`
preserves the trace, while `J (γ₅ P) J = (J γ₅ J)(J P J) = (−γ₅)(P) = −(γ₅ P)`,
so `Tr(γ₅ P) = −Tr(γ₅ P) = 0`. **Status: proved, `s o r r y`-free, standard
assumptions.** This is the formal version of C262/C263's warning that
"balance-commuting spectral projectors classify route/taste, not chirality, and
carry zero index". Design consequence: **a physical `W_branch` must break this
`J`-symmetry on the target island** — i.e. it must make the island projector
*not* commute with every chirality-odd balance involution.

### 5.2 Acceptance tests (proved)

Both discharged in the companion file on a `Fin 2` toy (`gZ = σ_z`, `gX = σ_x`,
`gP = diag(1,0)`):

```lean
-- clause (2) is satisfiable: anticommuting chirality + 1-dim island ⇒ index ≠ 0
theorem acceptance_nonzero_index : chiralIndex gZ gP ≠ 0           -- = 1

-- the trap fires on a balance-symmetric projector ½(1 + σ_x)
theorem acceptance_trap_zero : chiralIndex gZ ((1/2 : ℂ) • (1 + gX)) = 0
```

These pin the sign/normalization convention and confirm, before any `W_branch`
is chosen, that the index primitive distinguishes the trapped (index 0) from the
chirality-carrying (index ≠ 0) case.

### 5.3 Future near-Lean statements (design targets, not yet formalized)

These belong to the eventual `W_branch` proof; stated here as the acceptance
surface the certificate must hit.

* **Integrality of the index.** For a Hermitian involution `γ₅` and spectral
  projector `P`:
  ```lean
  theorem chiralIndex_int (hg5 : gamma5ᴴ = gamma5) (hg5sq : gamma5 * gamma5 = 1)
      (hP : IsIslandProjector H P c delta) :
      ∃ m : ℤ, chiralIndex gamma5 P = (m : ℂ)
  ```
  (Route: `γ₅` and `P` simultaneously block-diagonalizable; trace of a `±1`
  involution restricted to `range P` is a signature.)

* **Projector existence from separation.** Build the witness for clause (1):
  ```lean
  theorem island_projector_of_separation (hH : H.IsHermitian)
      (hsep : HasSeparatedIsland H hH c delta) :
      ∃ P, IsIslandProjector H P c delta
  ```
  (Route: polynomial/spectral projector via §2.3, *used* not exposed.)

* **Gap transfer (clause 3 from the symbol square).** Generalize
  `K_symbol_l2NormSq_gap` to the compressed bad sector, giving
  `inverseBadSectorGap` directly from a flavored symbol-square identity
  `K_flavored ᴴ K_flavored = coeff · I` plus `firstBandMu`-style positivity.

* **No-go contrapositive (`W_branch` design constraint).**
  ```lean
  theorem branch_needs_balance_breaking
      (cert : BranchRetentionCertificate gamma5 H K P hH c delta) :
      ¬ ∃ J, J * J = 1 ∧ J * gamma5 = -(gamma5 * J) ∧ J * P = P * J
  ```
  (Immediate from `zero_index_commuting_trap` + `cert.nonzeroIndex`: a valid
  certificate forbids a balance symmetry on the island. This is the single most
  useful design lemma — it tells the `W_branch` author exactly which symmetry to
  break.)

---

## 6. Claim boundary

This predicate layer is finite-dimensional linear algebra. It does **not**
construct `sign(H)` as a functional calculus, prove overlap locality /
exponential tails, prove gauge covariance, or assert the analytic
index-theorem identification of `chiralIndex` with a topological charge. It
fixes the *vocabulary and acceptance tests* for branch retention and proves the
zero-index trap and its toy witnesses; choosing and certifying a concrete
`W_branch` against `BranchRetentionCertificate` is the downstream job.

---

## 7. Verification notes

* Companion file `PhysicsSM/Draft/NullEdge/GateC1/SpectralIslandIndexPredicates.lean`
  builds under Lean 4 / Mathlib `v4.28.0` (module target
  `PhysicsSM.Draft.NullEdge.GateC1.SpectralIslandIndexPredicates`).
* `zero_index_commuting_trap`, `acceptance_nonzero_index`, `acceptance_trap_zero`
  are `s o r r y`-free and depend only on `propext`, `Classical.choice`,
  `Quot.sound` (checked via `#print assumptions`).
* The module imports only `Mathlib`; it does not depend on the (currently
  missing) `TetrahedralGlobalGap` / Furey modules, so it is independent of the
  broken default `PhysicsSM` target.
