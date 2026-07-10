# The equivariant graded index: organizing-theorem strategy

Strategy + design note for `src/EquivariantGradedIndex.lean`. Deliverable:
the sharpest **kernel-provable** finite statement of the "one theorem organizes
§§4/6/8" slogan, split cleanly into a **provable half** (landed as Lean) and an
**aspirational half** (explicitly NOT claimed), with the over-claim boundary
drawn sharply.

Verdict up front: the honest content of the slogan is a **finite equivariant
graded-trace decomposition** — pure linear algebra (trace cyclicity + eigenvalue
pairing). It is real, and it is now kernel-checked. The upgrade to a **topological
index theorem à la Atiyah–Singer is not earned and, at this generality, is a
category error**, not a research gap. Details below.

---

## 1. The organizing theorem, stated precisely

### 1.1 The finite object

Work over `V = ℂ^n` (`n` a `Fintype`), operators = `Matrix n n ℂ`. The decorated
complex contributes:

- an **odd involution** (grading) `Γ`: `Γ² = 1`, `Γᴴ = Γ`, and `Γ D = −(D Γ)`
  for the Dirac-type operator `D` (chirality `Γ`, the closure bivector
  `b = σ_z ⊗ 1`, and the GW edge-orientation-reversal grading are all *odd*
  elements — in the code `b` and the C4 witness grading are literally `σ_z`);
- **even symmetries** `g`: `g D = D g`, `g Γ = Γ g` (gauge transformations and
  the reflection `R` are *even* elements).

The **master invariant** is the `ℂ`-linear **equivariant graded supertrace**

>  `sdim_g(A) := tr(Γ · g · A)`.

Its three uses are the three specializations of `g`:

| use | `g` | statement | program label |
|-----|-----|-----------|---------------|
| index protection | `g = 1` | `sdim_1` sees only `ker D` | §8 McKean–Singer |
| C4 sectored pinning | `g = R` | `sdim` splits over `P_± = (1±R)/2` | §8 / C4 |
| balanced inertia | "∃ odd element" | Witten index `= 0` per sector ⇒ `n₊ = n₋` | §6 S1-CC |

### 1.2 Two distinct claims — keep them apart

- **(a) The index (a graded trace that is invariant).** `sdim_g` is a
  well-defined linear functional, additive over any decomposition of `A`, and it
  *localizes*: contributions from the non-kernel/odd part cancel between the two
  chirality sectors. This is the genuine, provable object.
- **(b) The channels ARE its graded pieces.** Given the Dirac square
  `4 D#D = Q_A + Q_C + 4 Q_T + 4 E_#`, the four channels' graded traces sum to the
  total graded trace. This is an exact *decomposition* of (a) — "unification is
  decomposition." Also provable (it is linearity applied to the specific budget).

Neither (a) nor (b) asserts that the common value of `sdim_1(D#D)` is a
*topological* invariant. That is the separate, unearned claim (§3).

---

## 2. The sharpest TRUE finite statement (landed as Lean)

All of the following are in `src/EquivariantGradedIndex.lean`, kernel-checked,
no `sorry`, axioms `[propext, Classical.choice, Quot.sound]` only.

1. **Supersymmetric cancellation** `graded_trace_odd_vanishes`:
   if `Γ X = −(X Γ)` and `g X = X g`, then `tr(Γ g X) = 0`.
   *The finite McKean–Singer heart: the supertrace of an odd operator vanishes.*
   (Only `[g,X]=0` is used — `[g,Γ]=0` is genuinely unnecessary and omitted.)

2. **Localization to `D#D`** `gamma_pow_comm` + `graded_trace_odd_power_vanishes`:
   `Γ D^m = (−1)^m (D^m Γ)`, hence `tr(Γ D^(2k+1)) = 0`.
   *Every odd power of `D` drops out; any power series in `D` collapses to a series
   in the even powers `D^(2k) = (D#D)^k` — the finite face of "the heat-kernel
   supertrace localizes to `D#D` / to `ker D`."*

3. **Unification is decomposition** `graded_trace_sum`:
   `sdim_g(Σ_i Q_i) = Σ_i sdim_g(Q_i)` over an arbitrary `Finset` of channels.

4. **The Dirac-square budget as one equivariant identity**
   `graded_budget_decomposition`: from
   `4 • (D# * D) = Q_A + Q_C + 4•Q_T + 4•E`,
   `4 • sdim_g(D#·D) = sdim_g(Q_A) + sdim_g(Q_C) + 4•sdim_g(Q_T) + 4•sdim_g(E)`.
   *This is the precise, honest form of "the four channels are the graded pieces
   of one equivariant index."*

5. **C4 isotypic refinement** `graded_trace_sector_split`:
   `sdim(A) = sdim_{P_+}(A) + sdim_{P_-}(A)` with `P_± = (1±R)/2`.
   *Needs only `P_+ + P_- = 1`; `R² = 1` is the extra input that makes the
   per-sector numbers the integers `ν_0(χ), ν_π(χ)`.*

Together (1)–(5) are the sharpest true finite statement: **the master functional
`sdim_g` is linear, localizes onto `D#D` (odd parts cancel), decomposes exactly
into the four channels, and refines over the reflection sectors.** That is the
whole organizing slogan, minus nothing that is actually true.

Retained structural core (already in file): `chiralProduct_involution`
(`C = ΓW`, `C² = 1`) and `sector_pins_W_fixed` (common `(Γ,C)`-eigenvectors are
`W`-fixed) — the multiplicative face feeding the L4 pinning count.

---

## 3. The over-claim boundary: graded decomposition vs topological index

The line is sharp and worth stating exactly.

**Provable (finite graded decomposition).** Everything in §2. Its ingredients are
`tr(AB) = tr(BA)`, `Γ² = 1`, and the anticommutator `ΓD = −DΓ`. The "invariance"
that is real is *algebraic*: `sdim_1(f(D#D))` depends on `f` only through `f(0)`
(the finite McKean–Singer statement), and the value is `str(ker D) =
dim ker D_+ − dim ker D_−`, computed **directly** from the matrices.

**Not claimed (topological index à la Atiyah–Singer).** A topological index
theorem would assert this integer equals a *topological/characteristic-class*
quantity: `ind D = ∫_M ch(σ(D)) Td(M)` (or a K-theory pairing), i.e. a formula
in data that does **not** appear here. The manuscript's §2a is explicit in not
claiming this, and rightly so, because the finite decorated complex supplies
**none** of the required scaffolding:

- **no base/parameter space** — there is a single operator `D`, not a family
  `{D_x}_{x∈X}` over which an index bundle could be formed;
- **no stable/K-theory equivalence** — `sdim` is a number attached to one matrix
  algebra, not a class in `K^0` of anything, so there is no group in which to
  land a "class whose Chern character is computed by cohomology";
- **no characteristic classes / no `Td`, `ch`** — there is no manifold, tangent
  bundle, or symbol to build them from;
- **the "invariance" is the wrong kind** — `sdim_1(e^{−tD#D})` is `t`-independent
  (a *deformation* invariance under one specific homotopy), which is McKean–Singer,
  **not** the homotopy/cobordism invariance of a topological index over a family.

**Honest verdict.** The index-theorem upgrade is *not reachable from this data*,
and pursuing it here is a **category error**, not a research program: with a
single finite operator the "index" is a directly computable dimension count, so
there is nothing for a topological formula to compute that the direct count does
not already give. To make an Atiyah–Singer-type statement *meaningful* one would
first have to introduce genuinely new structure — a parameter family of Dirac
operators over a space, a K-theory receptacle, and a cohomological/localization
formula (an equivariant Lefschetz/Atiyah–Bott fixed-point statement is the
closest honest target, since the C4 sector value is already a Lefschetz number
`tr(Γ R) = 2·#fixed legs`). That is a *different, larger* mathematical object;
it is not implied by, and does not sharpen, the finite decomposition that is
actually true. Claiming it would be an over-claim.

The one place a genuine "index-flavored" theorem *is* reachable is the
**Lefschetz/fixed-point reading of the C4 sector** (call-02 Part B): `ν_0(χ) =
ν_π(χ) = ±¼ tr(Γ R)` and `tr(Γ R) = 2·#{fixed legs}`. That is finite,
`|t|`-independent, and honest — but it is a fixed-point count, not a
characteristic-class integral, so it belongs to the provable half, not the
aspirational one.

---

## 4. Feasibility + ranked sub-lemmas + the blocker

The **graded-trace decomposition (provable half) is done** — §2, all in Lean.
The remaining substance that would deepen (but not topologize) the framework:

Ranked M-targets (need spectral/eigenspace `finrank` API, hence handed off):

1. **L2 balanced inertia** (S1-CC capstone, §6) — *nearest to landing*.
   From `anticonj_charpoly_eq` (`(−B).charpoly = B.charpoly`) and `B` Hermitian,
   derive `n₊ = n₋`. Route (call-02 Part A): `charpoly_neg` (≈10 lines) →
   `Polynomial.roots_comp_neg_X` + `roots_C_mul` →
   `IsHermitian.roots_charpoly_eq_eigenvalues` →
   `card_pos_eq_card_neg_of_multiset_map_neg_eq`. Mathlib-only. **Cheapest.**
2. **L3 `graded_supertrace_localizes_to_kernel`** — the `finrank` form of
   McKean–Singer: `sdim_1(f(D#D)) = f(0)·(dim ker D_+ − dim ker D_−)`. The
   *algebraic* half is already landed (odd-power vanishing, `graded_trace_odd_*`);
   the blocker is the eigenspace-dimension bookkeeping (`Submodule.finrank`,
   eigenvalue pairing `D : ker(D#D−λ)_+ ≅ (…)_−` for `λ ≠ 0`).
3. **L4 `sector_involution_pinning`** — `dim(ker(W∓1) ∩ V_χ) ≥ |ν(χ)|`. The
   pointwise heart is landed (`sector_pins_W_fixed`, `chiralProduct_involution`);
   the blocker is `Submodule.finrank_sup_add_finrank_inf_eq` +
   `LinearMap.IsProj.trace` to turn eigenvector production into a dimension bound.
4. **L5 RG-Schur bridge** — grade C, downstream; not on the critical path.

**The single blocker for 2–4:** the finite **eigenspace-`finrank` / projection-
trace API** (`LinearMap.IsProj.trace = finrank`, `finrank_sup_add_finrank_inf`).
Every remaining M-target is "convert an *algebraic* cancellation/involution fact
(already landed) into a *dimension count*." No new mathematics or deep Mathlib
theory is required — it is API plumbing, well-suited to the theorem-proving
subagent once L2 (pure charpoly, Mathlib-only) is cleared first.

**What is NOT a feasibility question:** the topological index theorem (§3). It is
not blocked; it is not the right target for this data.
