# Lane B audit — Spin(10) stabilizer / Selector-Theorem draft

Scope: the three open `sorry`s of the "16 of Spin(10) = one generation" track,
in `PhysicsSM/Draft/Spin10Stabilizer{Transitivity,Isomorphism,Selector}.lean`,
against `Sources/Spin10_stabilizer.txt` (Krasnov / pure-spinor notes).

Underlying conventions (checked in source):
- `FockSpinor := Finset (Fin 5) → ℂ` (Fock model of `S⁺`, complex 16).
- `evenCliffordGroup` = `Subgroup.closure pairUnitSet` = **GSpin(10, ℂ)**, the
  *complex* general spin group; it "contains all nonzero scalars"
  (`SpinorTenfoldCliffordGroup.lean`, module docstring + `scalarUnit_mem`).
- `StandardModelGaugeGroup` := `SMBlockUnitsSubgroup` = block-diagonal
  **unitary** det-one matrices = the *compact* real form `S(U(2) × U(3))`.
- `OrthogonalPureSpinors ψ₁ ψ₂ := gammaBilinear ψ₁ ψ₂ + gammaBilinear ψ₂ ψ₁ = 0`
  (only the vector current `ψ₁Γ^aψ₂` vanishes).
- Standard pair: `vacuumSpinor = basisSpinor ∅`, `weakSpinor = basisSpinor {3,4}`.

---

## 1. Transitivity — `evenCliffordGroup_transitive_on_krasnov_pairs`  → FALSE as stated (CLOSED, negative)

Statement: for any four pure spinors with `OrthogonalPureSpinors ψ₁ ψ₂` and
`OrthogonalPureSpinors φ₁ φ₂`, there is `g ∈ evenCliffordGroup` with
`g ψ₁ = φ₁` and `g ψ₂ = c • φ₂`.

**Verdict: FALSE as literally formalized.** Refuted with a kernel-checked proof
`not_evenCliffordGroup_transitive_on_krasnov_pairs`
(axioms: `propext, Classical.choice, Quot.sound`; no `sorry`, no `native_decide`,
no new axiom).

Why: `OrthogonalPureSpinors` (vanishing vector current) is, by Chevalley,
equivalent to `dim(N₁ ∩ N₂) ≥ 3`, so it captures **both** the collinear `d = 3`
stratum **and** the diagonal `d = 5` stratum `[ψ₁] = [ψ₂]`. Every pure spinor `ψ`
satisfies `gammaBilinear ψ ψ = 0` (its purity quadric), so the degenerate pair
`(ψ, ψ)` is admitted by the hypotheses. No group element can carry a degenerate
pair to a projectively-distinct one: with `ψ₁ = ψ₂`, the conclusion forces
`φ₁ = c • φ₂`. Instantiating `ψ₁ = ψ₂ = vacuumSpinor`,
`(φ₁, φ₂) = (vacuumSpinor, weakSpinor)` gives `vacuumSpinor = c • weakSpinor`,
impossible for distinct basis monomials (evaluate at `∅`: `1 = c·0`).

Missing lemma / route to the *true* statement: add projective-distinctness of
each pair, e.g. `(¬ ∃ c, ψ₂ = c • ψ₁)` and `(¬ ∃ c, φ₂ = c • φ₁)`. Together with
orthogonality (`d ≥ 3`) and distinctness (`d < 5`) this pins `d = 3`, the single
Spin(10) orbit on which transitivity holds. This matches "Message 2", tightening
point 1 of the source notes: "(d=5) is the diagonal, not an orbit of distinct
projective points." Proving the corrected statement is then a genuine orbit
argument (build `g` as a product of Clifford units realizing the `SO(10,ℂ)`
element that moves one isotropic-3-plane configuration to the other) — still
substantial, but no longer refutable.

---

## 2. Isomorphism — `standard_pair_stabilizer_isomorphic_to_sm`  → FALSE as stated (convention mismatch: complex vs compact)

Statement: `MixedPairStabilizerSubgroup vacuumSpinor weakSpinor ≃* StandardModelGaugeGroup`.

**Verdict: FALSE as literally formalized — real-form mismatch.** The stabilizer
is taken inside the *complex* group `evenCliffordGroup = GSpin(10, ℂ)`. The joint
stabilizer of the marked/projective pair `(vac, [weak])` is the complexified
Levi, a positive-dimensional *complex* reductive group of type
`S(GL(2,ℂ) × GL(3,ℂ))` (complex dim 12, real dim 24). `StandardModelGaugeGroup`
is the *compact* real form `S(U(2) × U(3))` (real dim 12). A connected complex
reductive Lie group is not isomorphic (as an abstract group) to its compact real
form, so no `MulEquiv` exists.

This is exactly the real-form bookkeeping the source flags as "where these
arguments rot if done sloppily" and "(S(U(2)×U(3))) only after fixing one spinor
nonprojectively … with reality conditions" (Message 2, point 2). Krasnov's
`S(U(2) × U(3))` is the stabilizer inside the *compact* `Spin(10)` (or `Pin`),
using the reality/Hermitian structure that makes each `ψᵢ` define a compatible
complex structure on `ℝ¹⁰`.

Missing ingredient / route: introduce a Hermitian inner product on `FockSpinor`
and the compact subgroup `Spin(10) ⊂ GSpin(10,ℂ)` (unitary elements), then state
the iso for `MixedPairStabilizerSubgroup` taken inside that compact subgroup.
With the compact group in place the iso is the true Krasnov result; constructing
the explicit `MulEquiv` remains a sizeable task (block decomposition
`ℂ¹⁰ = W₂ ⊕ W̄₂ ⊕ W₃ ⊕ W̄₃`, identify unitaries preserving the two marked lines
with `S(U(2)×U(3))`).

A formal kernel-checked negative for the *current* statement is possible in
principle but costly (needs a torsion/divisibility or dimension obstruction
separating a compact torus from `ℂˣ`); left as an audit finding rather than a
proof, since the transitivity negative already gives the first-class kill and the
fix here is a definitional one (use the compact group).

---

## 3. Selector — `physical_embedding_selected_by_krasnov_pair`  → underspecified; backward direction tractable, forward blocked

Statement (iff, with a hypothesis `h_iso : H ≃* StandardModelGaugeGroup`):
`H` is the mixed stabilizer of *some* Krasnov pure-spinor pair  ↔  `H` is a
conjugate (`MulAut.conj g`) of `MixedPairStabilizerSubgroup vacuumSpinor weakSpinor`.

**Verdict: TRUE in spirit but currently blocked / underspecified.**
- The hypothesis `h_iso` appears not to be needed for the conjugacy iff and looks
  vestigial; the real content is transitivity + conjugation-equivariance of the
  stabilizer.
- **Backward** (`conjugate ⇒ stabilizer of a pair`) is the tractable direction:
  from `H = conj_g (Stab(vac, weak))`, exhibit the pair `(g·vac, g·weak)` and use
  (i) `g` preserves purity and orthogonality (group action on the quadric), and
  (ii) `MixedPairStabilizerSubgroup (g·ψ₁) (g·ψ₂) = conj_g (MixedPairStabilizerSubgroup ψ₁ ψ₂)`.
  These two equivariance lemmas are the missing pieces; both are provable
  directly from the subgroup definitions. Recommended next handoff target.
- **Forward** (`stabilizer of a pair ⇒ conjugate`) needs the *corrected*
  transitivity of §1 (all genuine `d = 3` pairs are conjugate), which is not yet
  available. Blocked until §1 is fixed and proved.

Route: (a) fix §1 (add distinctness, prove orbit transitivity); (b) prove the two
equivariance lemmas; (c) assemble the iff, dropping or justifying `h_iso`.

---

## Summary table

| sorry | verdict | status |
|---|---|---|
| Transitivity | **FALSE as stated** (admits `d=5` diagonal) | **CLOSED** — kernel-checked negative `not_evenCliffordGroup_transitive_on_krasnov_pairs` |
| Isomorphism | **FALSE as stated** (complex GSpin vs compact `S(U(2)×U(3))`) | audit only; fix = use compact `Spin(10)` |
| Selector | underspecified (`h_iso` vestigial); backward tractable, forward needs fixed §1 | audit + handoff |
