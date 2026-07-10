# S1-CC: the general-representative reduction (witness → general)

This note closes the last MEMO piece of the S1-CC closure-positivity crux: the
claim that the balanced inertia found on the explicit `6×6` witness
(`sig(J Q_C|_{V'/N}) = (2,2,0)`) is **not special to the witness**, but holds for
*every* scalar-metric physical Gauss sector.

The result: **balance is a general theorem for the scalar-metric class.** It is a
structural consequence of `b`-anticonjugation surviving the compression to
`V'/N`, and is completely independent of which Gauss charge `Q_G` is used. The
only way positivity can survive is to leave the scalar-metric class entirely
(a genuinely *soldered* `Q_G` — the pre-registered kill condition **K-A**), or
to make the sector trivial (`K̄ = 0`, positivity only vacuously). Both boundaries
are made precise below.

Everything here is **kernel-checked** in Lean, with axioms
`[propext, Classical.choice, Quot.sound]` only:

* `src/S1CCBalancedInertia.lean` — the abstract balance engine, generalized to an
  arbitrary finite carrier index type `ι`.
* `src/S1CCGeneralReduction.lean` — the general reduction, over arbitrary carrier
  `ι` and representative index `κ`.
* `src/S1CCWitnessAsInstance.lean` — the `6×6` witness re-derived as a literal
  instance of the general theorem.

---

## 1. The general reduction, stated precisely

### 1.1 Setup (scalar-metric single-edge carrier)

* Carrier `H = ℂ^ι` for a finite index set `ι`. In the physical program `ι` is a
  **product** `Clifford × color`, e.g. `Fin 2 × Fin 3`.
* Closure Krein form `J Q_C =: J`, a Hermitian matrix on `H`
  (in the witness `J = (σx·σz) ⊗ K` with `K` skew-Hermitian; skew⊗skew = Hermitian).
* Closure grading `b`, a **diagonal `±1` involution** on `H`
  (in the witness `b = σz ⊗ 1`), satisfying the **full-carrier anticonjugation**
  ```
  b · J · b = -J.                                        (A)
  ```
* Gauss charge `Q_G` nilpotent (`Q_G² = 0`) with `[G,K] = 0` (descent /
  Theorem 1). The physical sector is `V'/N = ker Q_G / range Q_G`, and the
  induced closure form is the compression of `J` to a set of coset
  representatives `r : κ → ι`.

Property (A) is a property of the **pair `(J, b)` alone** — it does not mention
`Q_G` at all. This is the crux of the whole upgrade.

### 1.2 Statement

> **General reduction (Lean: `S1CCGeneralReduction.compression_balanced`).**
> Let `J` be Hermitian, `d : ι → ℂ` a `±1` grading (`∀ i, d i = 1 ∨ d i = -1`)
> whose diagonal matrix `b = diagonal d` anticonjugates `J` (property (A)).
> Then for **any** representative selection `r : κ → ι`, the compressed closure
> form `B := J.submatrix r r` is **balanced**:
> ```
> #{ i | eig(B) i > 0 } = #{ i | eig(B) i < 0 }      (n₊ = n₋).
> ```

No hypothesis on `Q_G` appears. `Q_G` enters *only* through the choice of the
representative index map `r`, and balance holds for **every** `r`.

> **No-positivity corollary (Lean: `compression_has_neg_eigenvalue`).**
> If additionally the sector is nondegenerate (`IsUnit (det B)`) and nonempty
> (`Nonempty κ`), then `B` has a strictly negative eigenvalue — so the closure
> form is **never positive semidefinite** on a nontrivial physical sector.

---

## 2. Why it is general — proof and the exact dependency

The abstract balance engine
`S1CCBalancedInertia.hermitian_balanced_count_of_neg_charpoly` needs only two
things about the *compressed* form `B`:

1. `B` is Hermitian; and
2. `(-B).charpoly = B.charpoly`, i.e. the Hermitian spectrum is invariant under
   negation.

Item (2) follows from a **congruence anticonjugation on the sector**:
`S⁻¹ B S = -B` for some invertible `S` implies `(-B).charpoly = B.charpoly`
(similarity is a charpoly invariant — `anticonj_charpoly_eq`), and a Hermitian
matrix whose charpoly is negation-invariant is balanced
(`neg_eigenvalues_multiset` + `countP_pos_eq_countP_neg_of_map_neg_eq`).

So the entire question reduces to:

> **Does `b`-anticonjugation SURVIVE the compression to `V'/N`?**

**Yes — for a diagonal grading it survives *any* compression, structurally.**
This is `compression_inherits_anticonj`, and its proof is one line of entrywise
algebra: for `b = diagonal d`,
```
(diagonal (d∘r) · B · diagonal (d∘r))_{ij}
   = d(r i) · J_{r i, r j} · d(r j)
   = (b · J · b)_{r i, r j}
   = (-J)_{r i, r j}                      by (A)
   = -B_{ij}.
```
The middle equality is exactly the fact that `b` is **diagonal**: conjugating a
submatrix by the restricted diagonal is the same as conjugating first and then
restricting. Nothing about `r` (hence nothing about `Q_G`) is used. The descended
grading is literally `b̄ = diagonal (d∘r)`, and `b̄ B b̄ = -B`.

**Conclusion.** `b`-anticonjugation is inherited by every compression, so the
compressed closure form is balanced for every representative set, i.e. for every
scalar-metric `Q_G`. The balance is **not** a coincidence of the witness's
coordinate alignment; the witness alignment only makes the compression a literal
`submatrix`, which is presentation, not content.

### 2.1 Reducing a general `G` to the witness shape (no loss of generality)

For a general scalar-metric `Q_G = c₁ ⊗ G` the sector `ker G / range G` need not
be axis-aligned, so `V'/N` is not literally a `submatrix` in the given
coordinates. But this is only a change of basis:

* `G` is Hermitian on the color leg, hence unitarily diagonalizable: `G = U D U*`.
* In the `G`-eigenbasis, `ker G` and `range G` **are** axis subspaces, so the
  compression to `V'/N` is a genuine `submatrix`.
* `[G,K] = 0` ⟹ `K` preserves the `G`-eigenspaces, so `Ǩ = U*KU` is block-diagonal
  aligned with `ker G` ⊕ `(ker G)^⊥`; the restriction `K̄` to `ker G` is
  well-defined (this is the descent, Theorem 1).
* The grading `b = σz ⊗ 1` acts only on the **Clifford** leg, so it commutes with
  the color-leg unitary `1 ⊗ U`. Hence property (A) is **preserved verbatim** by
  the change of basis: `b (1⊗U)* J (1⊗U) b = -(1⊗U)* J (1⊗U)`.

So WLOG `G` is diagonal, `V'/N` is a `submatrix`, and
`compression_balanced` applies directly. This is the sense in which the witness
shape is fully general within the scalar-metric class.

### 2.2 The exact dependency (what makes `b` preserve the sectors)

For a **scalar-metric** (factorized) `Q_G = c₁ ⊗ G`, `b = σz ⊗ 1` anticommutes
with `Q_G`:
```
b Q_G b⁻¹ = (σz c₁ σz) ⊗ G = -c₁ ⊗ G = -Q_G,          (σz c₁ σz = -c₁),
```
because the null covector `c₁` is **off-diagonal** in the closure grading `σz`
(a `σz`-odd operator). From `b Q_G = -Q_G b`:
* `Q_G v = 0 ⟹ Q_G (b v) = -b Q_G v = 0`, so `b` preserves `ker Q_G = V'`;
* `b (Q_G w) = -Q_G (b w) ∈ range Q_G`, so `b` preserves `range Q_G = N`.

Thus `b` descends to `V'/N`, and (by §2) anticonjugation descends with it. The
only property used is `σz c₁ σz = -c₁`, i.e. **the null covector is `σz`-odd** —
which holds for the entire scalar-metric class and is independent of `G`.

---

## 3. No-go honesty — could positivity survive?

**Within the scalar-metric class: no (except vacuously).**
By §2 the compressed form is balanced, `n₊ = n₋`. Positivity would require
`n₋ = 0`, hence `n₊ = 0`, hence (with the zero-count) the form is identically
zero on `V'/N` — i.e. `K̄ = 0`, the trivial sector. This matches the resolution's
"positive only vacuously (`K̄ = 0`)". On any nontrivial nondegenerate sector,
`compression_has_neg_eigenvalue` produces a strictly negative direction, so the
closure form is **never positive semidefinite**. The general no-go holds.

**The honest boundary — where the reduction genuinely stops (kill condition K-A).**
The single structural input is that `b` is a **diagonal `±1` grading commuting
with the color-leg change of basis** and that `Q_G` is **factorized**
(`c₁ ⊗ G`, scalar metric). If `Q_G` is genuinely **soldered** — a Hermitian
Gauss operator on `H` that mixes the Clifford and color legs so that
`σx/σz ⊗ 1` no longer sends `c₁ ⊗ (·)` to `±c₁ ⊗ (·)` — then:

* `b` need **not** anticommute with `Q_G`, so `b` need not preserve `ker Q_G` and
  `range Q_G`;
* `b` need not descend to `V'/N`, so property (A) need not survive the
  compression;
* `compression_balanced` does **not** apply, and a `J`-positive physical sector
  is not excluded by this mechanism.

This is exactly the pre-registered kill condition **K-A**: a soldered `G` (not of
the form `1_{Clifford} ⊗ G_color`) voids the `b`-invariance and the inertia
prediction, forcing the ghost-extended BRST route. It is the true frontier of
the no-go: **the general reduction is a theorem precisely on the scalar-metric
(factorized, `σz`-odd null covector) class, and can fail only outside it.**

Two secondary caveats, both benign:
* **Nondegeneracy.** Balance (`n₊ = n₋`) needs no nondegeneracy. The stronger
  "not positive semidefinite" statement needs the sector nondegenerate and
  nonempty; a degenerate sector can only *add* zero modes, never break the
  `n₊ = n₋` symmetry.
* **Existence of the descent.** `[G,K] = 0` (abelian/linearized gauge
  covariance) is assumed for the sector to exist at all (Theorem 1); it is
  orthogonal to the balance mechanism and already M in the program.

---

## 4. Summary

| Question | Answer |
|---|---|
| Is balance general for scalar-metric `Q_G`? | **Yes**, structurally: `compression_inherits_anticonj` + balance engine. |
| Does it depend on the witness's coordinate alignment? | **No.** Alignment only makes the compression a literal `submatrix`; §2.1 removes it by a color-leg unitary that fixes `b`. |
| Which `Q_G` does the balance depend on? | **None.** `Q_G` only selects the representative map `r`; balance holds for every `r`. |
| Can positivity survive for some scalar-metric `Q_G`? | **Only vacuously** (`K̄ = 0`). Otherwise `n₊ = n₋ ≥ 1` ⟹ indefinite. |
| Where is the honest boundary? | **Kill condition K-A:** a *soldered* (non-factorized) `Q_G` breaks `b`-invariance; the reduction is a theorem exactly on the scalar-metric class. |

**Net effect on the crux.** The whole S1-CC closure-positivity crux is upgraded
from "no-go on the witness `M`" to "no-go on the general scalar-metric class",
kernel-checked. The remaining escape is not a gap in the argument but a genuinely
different physical class (soldered `Q_G`, K-A), which is out of scope for the
scalar-metric statement by construction.
