# Open Questions in Formalization

**Document purpose.** A curated list of mathematical questions that would be
interesting, novel, and tractable to prove formally in the PhysicsSM Lean
library. Questions are drawn from a literature survey (April 2026) covering
octonion algebra, exceptional Lie theory, the Standard Model from division
algebras, triality, and the Furey program.

**How to use this document.** The tiers are ordered by difficulty. Use Tier 1
to plan the next 1–3 Aristotle jobs. Use Tiers 2–3 to plan the next six months
of the execution plan. Use Tiers 4–5 to identify research-level contributions
that would be genuinely novel in the formal-math literature.

**Current project state (2026-04-29).** The following are already kernel-verified:
- Full real octonion algebra: `Octonion`, conjugation, normSq, normSq_mul,
  left/right alternativity, all three Moufang identities, flexible identity.
- Complexified octonions: ComplexOctonion arithmetic, Module ℂ/ℝ.
- Furey Cl(6) module: omega, 8 basis states, complete action table (48 entries),
  number operators, charge formula, basis_linear_independent.
- D4 triality: Cartan matrix, order-3 cycle, Cartan preservation.
- Octonion symmetry primitives: dot product, imaginary subspace, commutator.

---

## Tier 1 — Near-term (1–3 Aristotle jobs each)

These questions have clear statements, known proof strategies, and all
prerequisites are already in the project. Most reduce to finite computation
or straightforward algebra over existing simp lemmas.

---

### Q1.1 — All inner automorphisms of the octonions have order dividing 3

**Statement.** For any invertible octonion `u`, the map `x ↦ u * x * u⁻¹`
is an automorphism of the octonion algebra, and its cube is the identity map.

**Why novel.** This was proved by Yokota (classical literature) using the
Moufang identity, but has not been formally verified in any proof assistant.
John Baez raised the open question in September 2025 of whether a clean
formal proof exists that directly connects triality to this order-3 property
via the Moufang identities — exactly the approach available in our project.

**Prerequisites.** `normSq_mul`, `conj_mul`, `moufang_left`, `moufang_right`.
Needs: `mul_inv_cancel` type lemmas for invertible octonions (where normSq > 0).

**Proof sketch.** Define `innerAut u x = u * x * u⁻¹` where `u⁻¹ = conj u / normSq u`
for `normSq u ≠ 0`. Prove it is an algebra homomorphism using Moufang.
Prove `innerAut u (innerAut u (innerAut u x)) = x` — a finite computation
using the Moufang identity `(u * x * u) * u⁻¹ = u * (x * (u * u⁻¹))`.

**Difficulty.** Medium. The statement needs careful handling of `u⁻¹` since
octonions are not associative; use `normSq u • conj u` to avoid division.

**Source.** Baez, "The Octonions" (2002), Section 4.1; Yokota (1990).
nCat Café "A Shadow of Triality?" (September 2025).

---

### Q1.2 — Octonion multiplication is isotopic to itself in three ways

**Statement.** There exist three bilinear maps `A, B, C : 𝕆 × 𝕆 → 𝕆` such
that `A(x, y) = normSq_or_related_thing`, capturing the triality isomorphism
at the level of composition algebras. Concretely: the three 8-dimensional real
representations of Spin(8) (vector, left spinor, right spinor) are related by
permuting the roles in `x * y = z` with `n(x) = n(y) = n(z)`.

**Concrete near-term target.** Prove that the map `(x, y) ↦ conj(x) * y` has
the same normSq property as `x * y`: `normSq(conj x * y) = normSq x * normSq y`.

**Prerequisites.** `normSq_conj`, `normSq_mul`. Trivial corollary.

**Difficulty.** Easy — immediate from `normSq_conj` and `normSq_mul`.

**Source.** Baez (2002) Section 2.3, composition algebra isotopy.

---

### Q1.3 — The octonion dot product is symmetric and bilinear

**Statement.** The function `octonionDot x y = (normSq (x + y) - normSq x - normSq y) / 2`
is the unique symmetric bilinear form polarising `normSq`.

Key lemmas:
- `octonionDot_comm : octonionDot x y = octonionDot y x`
- `octonionDot_add_left : octonionDot (x + y) z = octonionDot x z + octonionDot y z`
- `octonionDot_smul_left : octonionDot (r • x) y = r * octonionDot x y`
- `octonionDot_self_eq_normSq : octonionDot x x = normSq x` (already proved!)

**Prerequisites.** `octonionDot_self_eq_normSq` (already in OctonionSymmetry.lean),
`normSq_add` (trivial from component expansion).

**Difficulty.** Easy. All proofs by `simp [octonionDot, normSq]` and `ring`.

**Source.** Standard Euclidean geometry.

---

### Q1.4 — Imaginary octonions form a 7-dimensional real subspace

**Statement.** The set `ImOct = {x : Octonion | x.c0 = 0}` is closed under
addition and real scaling. Together with the 8 basis elements, a basis for
`ImOct` over ℝ is `{e001, e010, e011, e100, e101, e110, e111}`.

Key lemmas:
- `isImaginary_add : IsImaginary x → IsImaginary y → IsImaginary (x + y)`
- `isImaginary_smul : IsImaginary x → IsImaginary (r • x)`
- `isImaginary_basis_elements : ∀ k ∈ {1,...,7}, IsImaginary (basisElem k)`
- `isImaginary_iff : IsImaginary x ↔ conj x = -x`

**Prerequisites.** `IsImaginary` (already in OctonionSymmetry.lean),
`conj_eq_neg_of_imaginary` (already proved).

**Difficulty.** Easy. All proofs are `simp [IsImaginary, conj]`.

**Source.** Standard; Baez (2002) Section 1.

---

### Q1.5 — The octonion commutator of two imaginary octonions is imaginary

**Statement.** Already proved as `octonionCommutator_imaginary` in `OctonionSymmetry.lean`.
Build on it to prove:
- `normSq_commutator : normSq (octonionCommutator x y) = ...` (cross product norm formula)
- `commutator_anticomm : octonionCommutator x y = -(octonionCommutator y x)` (already proved as `octonionCommutator_anticomm`)
- `commutator_self : octonionCommutator x x = 0`

**Prerequisites.** Existing `OctonionSymmetry.lean` theorems.

**Difficulty.** Easy. `rfl` or `ext <;> simp <;> ring`.

---

### Q1.6 — The D4 Cartan matrix generates a valid root system (combinatorial shadow)

**Statement.** The D4 Cartan matrix already in `Triality.lean` satisfies:
- `d4Cartan_diag : ∀ i, d4Cartan i i = 2`
- `d4Cartan_off_diag_range : ∀ i j, i ≠ j → d4Cartan i j ∈ ({0, -1} : Finset ℤ)`
- `d4Cartan_symm : ∀ i j, d4Cartan i j = 0 ↔ d4Cartan j i = 0`

**Prerequisites.** `d4Cartan` (already defined). All by `fin_cases; decide`.

**Difficulty.** Trivial. Three `decide`-based theorems.

---

## Tier 2 — Medium-term (4–10 Aristotle jobs, needs some new infrastructure)

These require either new definitions, moderate proof infrastructure, or
careful statement design. None involve research-level open problems.

---

### Q2.1 — Hurwitz theorem (classification of normed division algebras)

**Statement.** Every finite-dimensional real normed division algebra (where
the norm is multiplicative) is isomorphic to ℝ, ℂ, ℍ, or 𝕆.

**Why novel.** No formal proof exists in Lean, Coq, or Isabelle as of 2026.
This is a classical result (Hurwitz 1898) but has never been machine-verified.

**Proof strategy.** 
1. Define the abstract notion of a composition algebra.
2. State the Cayley–Dickson doubling theorem: every composition algebra of
   dimension > 1 over ℝ arises from a smaller one by doubling.
3. Prove that the process terminates at dimension 8 (using alternativity loss).
4. Check that 𝕆 satisfies the property and is the unique such of dimension 8.

**What we have.** `normSq_mul` proves 𝕆 IS a composition algebra.
We need: an abstract `CompositionAlgebra` typeclass and the Cayley–Dickson bridge.

**Prerequisites.** Milestone 1 (complete), Milestone 2 (Cayley–Dickson bridge, stub).

**Difficulty.** Hard. Needs the abstract algebra interface for composition algebras.
The final step (uniqueness up to isomorphism) requires representing algebras
as structures and constructing isomorphisms. Strong Aristotle target.

**Source.** Hurwitz (1898); Baez (2002) Section 2; Springer–Veldkamp (2000).

---

### Q2.2 — Derivations of the octonions form a Lie algebra of type G2

**Statement.** The space of derivations `Der(𝕆) = {D : 𝕆 → 𝕆 | D is linear,
D(xy) = D(x)y + xD(y)}` is a 14-dimensional real Lie algebra, and this Lie
algebra is isomorphic to the exceptional Lie algebra G₂.

**Why novel.** This is the infinitesimal version of `G2 = Aut(O)`. The derivation
algebra version is somewhat more tractable than the automorphism group version.
No formal proof in any proof assistant. This would be the project's first
formal contact with a specific exceptional Lie algebra.

**Proof strategy.**
1. Define `OctonionDerivation` as a linear map satisfying the Leibniz rule.
2. Show `Der(𝕆)` is closed under the Lie bracket `[D₁, D₂] = D₁ ∘ D₂ - D₂ ∘ D₁`.
3. Compute dim(Der(𝕆)) = 14 by explicit construction of 14 linearly
   independent derivations from the imaginary basis elements.
4. Identify with the G₂ root system (rank 2, 12 roots + 2 Cartan = 14 dim).

**Prerequisites.** `OctonionSymmetry.lean` (octonion commutator as a derivation
candidate), Milestone 1, basic linear algebra for 𝕆.

**Difficulty.** Hard. The dimension count is finite computation.
The isomorphism to G₂ requires connecting to the root system data.

**Source.** Baez (2002) Section 4.1; Springer–Veldkamp (2000) Chapter 2.

---

### Q2.3 — The G2 Cartan matrix and its basic properties

**Statement.** Define the G₂ Cartan matrix explicitly:
```
A_G2 = [[2, -1], [-3, 2]]
```
(or the symmetric version [[2, -3], [-1, 2]] depending on convention).
Prove it satisfies:
- Diagonal entries are 2.
- The determinant is 4 - 3 = 1 (wrong - actually det = 2*2 - (-1)(-3) = 4-3 = 1)
  Wait: det([[2,-1],[-3,2]]) = 4 - 3 = 1. So det = 1.
- The symmetrisation gives the correct lengths ratio of roots (1:√3 for G₂).
- It generates the G₂ root system (2 simple roots, 12 roots total).

**Prerequisites.** `Triality.lean` (Cartan matrix pattern for D4), basic
finite matrix arithmetic.

**Difficulty.** Moderate. Finite `decide`-based computations.

**Source.** Bourbaki, "Lie Groups and Lie Algebras" Ch. 4–6.

---

### Q2.4 — The E8 Cartan matrix (explicit 8×8 matrix and root count)

**Statement.** Define `e8Cartan : Fin 8 → Fin 8 → ℤ` (the E₈ Cartan matrix,
Bourbaki labelling). Prove:
- Diagonal entries are 2.
- Off-diagonal entries are in {0, -1}.
- `det(e8Cartan) = 1` (E₈ is self-dual, unimodular).
- The matrix is connected (E₈ Dynkin diagram is connected).
- The E₈ Weyl group acts by permuting the 240 roots.

**Why novel.** The sphere-packing project (math-inc/Sphere-Packing-Lean)
proves `E8Matrix_unimodular` via the lattice approach. Our project would
prove the same result from the root system / Dynkin diagram perspective,
giving a complementary formalization at the Lie-theoretic level.

**Prerequisites.** `Triality.lean` (Cartan matrix pattern), E8 stub.

**Difficulty.** Moderate for the matrix definition; hard for root count (240).

**Source.** Adams (1996) "Lectures on Exceptional Lie Groups"; Bourbaki Ch. 4–6.

---

### Q2.5 — The exceptional Jordan algebra H₃(𝕆) is 27-dimensional

**Statement.** The space of 3×3 self-adjoint octonionic matrices has real
dimension 27: 3 real diagonal entries + 3 off-diagonal octonions = 3 + 3×8 = 27.
Equip it with the Jordan product `X ∘ Y = (XY + YX)/2` (using matrix multiplication
in 𝕆³×³ with care for non-associativity) and prove the Jordan identity:
`(X ∘ X) ∘ (X ∘ Y) = X ∘ ((X ∘ X) ∘ Y)`.

**Why novel.** The exceptional Jordan algebra is the unique (up to isomorphism)
exceptional simple Jordan algebra. No formal proof in any proof assistant.
It connects to F₄, E₆, E₇, E₈ via the Freudenthal magic square.

**Prerequisites.** Full octonion algebra (Milestone 1 complete), basic matrix
operations, `H3O.lean` stub.

**Difficulty.** Hard. The Jordan identity for H₃(𝕆) is a substantial computation.

**Source.** Baez (2002) Section 3; Springer–Veldkamp (2000) Chapter 5;
Jordan–von Neumann–Wigner (1934).

---

### Q2.6 — ConventionBridge: formal correctness of the Baez→XOR sign map

**Statement.** The map `baezBasisInXOR` defined in `ConventionBridge.lean`
(permutation π plus sign map σ, where only Baez e₅ gets a sign flip) satisfies:
for every Baez positive triple (a, b, c):
`baezBasisInXOR a * baezBasisInXOR b = baezBasisInXOR c`

**Why novel.** This is the formal guarantee that our XOR convention is
isomorphic (as an octonion algebra) to Baez's convention. It validates the
entire ConventionBridge approach. It was deferred from the last sprint because
`Octonion` lacked `Add` — now it has everything needed.

**Prerequisites.** Conjugation, normSq (Milestone 1 complete), `AddCommGroup`
structure (already in ComplexOctonion).

**Difficulty.** Moderate. Seven finite product checks by `fin_cases` + `decide`.

**Source.** `Scripts/oracle/validate_convention_bridge.py` (all 42 products verified).

---

### Q2.7 — Furey ladder operators generate Cl(6) as a concrete algebra

**Statement.** The associative algebra generated by
{L_{α₁}, L_{α₁†}, L_{α₂}, L_{α₂†}, L_{α₃}, L_{α₃†}} acting on
ComplexOctonion by left multiplication is isomorphic to Cl(6) ≅ M₈(ℂ).

**Concrete formal target.** Define the linear map
`L_alpha1 : ComplexOctonion → ComplexOctonion` by `L_alpha1 x = alpha1 * x`,
and prove:
- `L_alpha1 ∘ L_alpha1 = 0` (nilpotency as an operator)
- `L_alpha1 ∘ L_alpha1_dag + L_alpha1_dag ∘ L_alpha1 = id` (canonical CAR)

These are OPERATOR composition equalities, distinct from the product
equalities in `LadderOperators.lean` and requiring careful non-associativity
treatment.

**Prerequisites.** `LadderOperators.lean`, `MinimalLeftIdeal.lean`, Module ℂ.

**Difficulty.** Hard. Requires the associator identity for the specific element omega.

**Source.** Furey arXiv:1806.00612, Section 2.

---

### Q2.8 — Anomaly cancellation for one generation

**Statement.** For the charge assignments in `MinimalLeftIdeal.lean`, verify:
- `∑ Q³ = 0` over the 8 states (gravitational anomaly)
- `∑ Q = 0` over charged states
where Q = -(1/3)(N₁+N₂+N₃) as already proved.

**Why interesting.** Anomaly cancellation is a non-trivial consistency check
in the Standard Model. Having a formal proof that it holds for the 8 algebraic
states of J is a novel contribution to physics-facing formalization.

**Prerequisites.** `MinimalLeftIdeal.lean` charge theorems (already proved).

**Difficulty.** Easy–Moderate. Finite sum computations using existing charge
eigenvalues.

**Source.** Furey arXiv:1806.00612, Section 4; standard SM anomaly references.

---

## Tier 3 — Substantial (requires new major infrastructure)

These require either a new 100+ line Lean file, a new Aristotle moonshot, or
coordination across multiple existing modules.

---

### Q3.1 — G2 = Aut(𝕆): the full automorphism theorem

**Statement.** The group of algebra automorphisms of the real octonions is the
compact Lie group G₂, which has dimension 14.

This is the most important single theorem connecting the octonion algebra to
exceptional Lie theory. It is the cornerstone of Milnor's proof of Bott
periodicity in the exceptional cases and the entry point for E₈ via the chain
G₂ ⊂ F₄ ⊂ E₆ ⊂ E₇ ⊂ E₈.

**No formal proof exists in any proof assistant.**

**Proof strategy (multiple steps):**
1. Show `Aut(𝕆)` is a Lie group by proving it is a closed subgroup of
   O(8) (norm-preserving maps of the underlying real vector space).
2. Prove dim(Aut(𝕆)) = 14 = dim(G₂) by showing the isotropy at `e001` is
   SU(3) and using the fibration `Aut(𝕆) → S⁶ → SU(3)`.
3. Identify the Lie algebra of Aut(𝕆) with `Der(𝕆)` (Q2.2).
4. Show `Der(𝕆)` is a simple Lie algebra of rank 2 with root system G₂.

**Prerequisites.** Q2.2 (derivations), Q2.3 (G₂ Cartan matrix),
`normSq_mul`, `conj_mul`, Module structure.

**Difficulty.** Very Hard. Likely 3–5 separate Aristotle moonshots.

**Source.** Baez (2002) Section 4; Cartan (1914) original; Adams (1996) Ch. 5.

---

### Q3.2 — The Moufang loop of unit octonions

**Statement.** The set `{x : Octonion | normSq x = 1}` is closed under
multiplication (from `normSq_mul`) and forms a Moufang loop (a loop satisfying
the Moufang identity). Prove:
- The Moufang loop axioms using `moufang_left` and `moufang_right`.
- Inverses exist (given by `conj`).
- The loop is not a group (non-associativity).
- The loop contains no normal subloops except {1} and itself (simplicity).

**Why novel.** The simplicity of the Moufang loop of unit octonions is a
classical result (Paige 1956) with no formal proof. It is the closest analogue
of the classical theorem that SO(n) is simple for n ≥ 5.

**Prerequisites.** Moufang identities (proved), `normSq_mul`, `mul_conj`.

**Difficulty.** Hard. Simplicity requires showing any normal sub-loop is trivial.

**Source.** Paige (1956) "A class of simple Moufang loops"; Baez (2002) Section 1.

---

### Q3.3 — The three representations of Spin(8) are related by triality

**Statement.** Spin(8) has three inequivalent 8-dimensional representations
(vector V, left-spinor S₊, right-spinor S₋) related by the outer
automorphism of D₄. The triality map permutes them cyclically:
V ↦ S₊ ↦ S₋ ↦ V.

**Formal target.** At the level already available: prove that the three
8-dimensional representations of D₄ (corresponding to nodes 0, 2, 3 of
`d4OuterCycle`) have the same Dynkin label structure, related by `d4OuterCycle`.

**Why novel.** This is the step connecting the Cartan-matrix triality in
`Triality.lean` to the representation-theoretic triality. No formal proof
in any proof assistant. Baez (September 2025) specifically identifies the
connection between the D₄ outer automorphism and the triality of
representations as an open question for formal investigation.

**Prerequisites.** `Triality.lean` (complete), representation theory of D₄
(mathlib root system infrastructure).

**Difficulty.** Very Hard. Needs the full representation theory of D₄.

**Source.** Baez (2002) Section 2; Cartan (1925); Adams (1996).

---

### Q3.4 — E8 lattice vector count from the root system

**Statement.** The E₈ root system has exactly 240 roots. Equivalently,
the minimal nonzero vectors of the E₈ lattice have norm √2 and there are 240
of them. Prove this from the Cartan matrix / Dynkin diagram.

**What sphere-packing-lean provides.** The math-inc project proves this via
the explicit lattice construction. Our project would prove it from the Lie-
theoretic root system, complementary to the sphere-packing approach.

**Proof strategy.** Use the Weyl character formula or direct computation:
for E₈ of rank 8, the number of roots is `2 * positive_roots`. The positive
roots of E₈ can be enumerated combinatorially from the Cartan matrix.

**Prerequisites.** E₈ Cartan matrix (Q2.4), root system machinery from
mathlib (`Mathlib.LinearAlgebra.RootSystem`).

**Difficulty.** Hard. Requires interfacing with mathlib's root system API.

**Source.** Adams (1996) Ch. 7; Humphreys (1972); math-inc/Sphere-Packing-Lean.

---

### Q3.5 — F4 as the automorphism group of H3(O)

**Statement.** The automorphism group of the exceptional Jordan algebra
H₃(𝕆) is the compact exceptional Lie group F₄ of dimension 52.

**Why novel.** No formal proof in any proof assistant. This is a classical
result (Chevalley–Schafer 1950) and the key stepping stone toward formalizing
the full exceptional Lie group chain G₂ ⊂ F₄ ⊂ E₆.

**Prerequisites.** Q2.5 (H₃(𝕆) Jordan identity), Q2.2 (G₂ = Der(𝕆) for G₂ part),
Jordan algebra theory.

**Difficulty.** Very Hard. Multi-moonshot.

**Source.** Chevalley–Schafer (1950); Baez (2002) Section 4; Springer–Veldkamp (2000).

---

## Tier 4 — Frontier (open in mathematics, or at the edge of current knowledge)

These are genuine research-level questions. A formal proof would constitute
a contribution to mathematics, not just to formalization.

---

### Q4.1 — Baez's open question: triality, Moufang, and order-3 inner automorphisms

**Exact open question (Baez, September 2025).** Is there a clean direct proof
that inner automorphisms of the octonions have order 3 that visibly passes
through triality and the Moufang identities, without Yokota's more convoluted
argument? Conway and Smith (2003) suggest a connection exists; making it
explicit and machine-verified would be novel.

**Context.** The existing proof (Yokota 1990) uses the structure of G₂.
A Moufang-first proof would work in any alternative algebra with a
triality-like symmetry, potentially generalising the result.

**Prerequisites.** Q1.1 (inner automorphisms), Moufang identities (proved),
`d4OuterCycle_order_three` (D₄ triality, proved).

**Source.** Baez nCat Café "A Shadow of Triality?" (September 2025);
Conway–Smith "On Quaternions and Octonions" (2003), Chapter 8.

---

### Q4.2 — Division algebras and SUSY: the Baez–Huerta theorem

**Statement.** Classical (non-super) Yang–Mills theory exists in spacetime
dimensions 3, 4, 6, 10. These are exactly the dimensions 1 + dim(K) where
K ∈ {ℝ, ℂ, ℍ, 𝕆}. Formally:
- In dimension n = 1 + dim(K), the spinor-vector product map has a natural
  K-linear structure.
- The identity `v · (v · ψ) = -|v|² ψ` (for spinors ψ and vectors v)
  holds in these and only these dimensions.

**Why novel.** Baez–Huerta (arXiv:0909.0551, 2010) proved this informally.
No formal proof exists. This would be the formal connection between the
division algebra structure and supersymmetry, connecting the SUSY algebra
stub to the octonion foundation.

**Prerequisites.** `normSq_mul` (composition algebra), Clifford algebra
stubs, ComplexOctonion.

**Difficulty.** Very Hard. Needs Clifford algebra machinery.

**Source.** Baez–Huerta arXiv:0909.0551 (2010).

---

### Q4.3 — The Freudenthal magic square

**Statement.** The Tits–Freudenthal magic square produces an exceptional Lie
algebra from any pair of normed division algebras (A, B):

| L(A,B) | ℝ  | ℂ  | ℍ  | 𝕆  |
|--------|-----|-----|-----|-----|
| ℝ      | A₁  | A₂  | C₃  | F₄  |
| ℂ      | A₂  | A₂+A₂| A₅ | E₆  |
| ℍ      | C₃  | A₅  | D₆  | E₇  |
| 𝕆      | F₄  | E₆  | E₇  | E₈  |

A formal proof of even one entry in this table (e.g., L(𝕆, ℝ) = F₄ agrees
with the automorphism group of H₃(𝕆)) would connect to Q3.5 and be
the first formal instance of the magic square.

**Why novel.** The Freudenthal magic square is a fundamental unifying structure
for all exceptional Lie algebras. No part of it is formally verified.

**Difficulty.** Multi-year project. The full square requires all four division
algebras with their properties.

**Source.** Freudenthal (1964); Tits (1966); Baez (2002) Section 4.4.

---

### Q4.4 — Furey 2025: the Z₂⁵-graded superalgebra structure

**Statement.** (From arXiv:2505.07923, published in Annalen der Physik 2025.)
The particle representations of the lightest Standard Model particles
(all but top quark) form a ℤ₂⁵-graded algebra isomorphic to H₁₆(ℂ)
(16×16 Hermitian matrices over ℂ), where the grading is induced by the
division algebraic substructure ℝ ⊂ ℂ ⊂ ℍ ⊂ 𝕆.

The gauge symmetry of this superalgebra is su(3)_C ⊕ su(2)_L ⊕ u(1)_Y,
plus four additional u(1) factors corresponding to the four division algebras.

**Why novel.** This is from May 2025 — the most recent Furey result.
No part of it has been formalized. A formal proof would be the first
machine-verified result connecting the division algebraic grading to the
full gauge symmetry structure.

**Prerequisites.** Everything in the Furey formalization layer, plus
the three-generation structure (Cl(8) approach from arXiv:1910.08395).

**Difficulty.** Very Hard / research-level.

**Source.** Furey arXiv:2505.07923 (May 2025); Annalen der Physik (October 2025).

---

### Q4.5 — Three generations from triality: the 2024 "trio of trialities" result

**Statement.** (From Furey et al. 2024.) The three generations of Standard
Model fermions can be identified with three copies of J related by the
ℤ₃ triality symmetry of the octonions. Explicitly: if J₁, J₂, J₃ are
three minimal left ideals related by `d4OuterCycle`-type permutations,
then the union J₁ ∪ J₂ ∪ J₃ carries all 48 states of three generations
with correct SU(3) × U(1) quantum numbers.

**Why novel.** The three-generation problem is arguably the deepest open
question in Standard Model physics. A formal proof that three generations
arise from triality symmetry of the division algebra would be a major result.

**Prerequisites.** Full Furey single-generation formalization, Q3.3 (triality
and representations), D₄ triality (already proved at Cartan level).

**Difficulty.** Research-level. Requires new physics alongside new formalization.

**Source.** Furey et al. (2024) "Three generations and a trio of trialities";
Furey arXiv:1910.08395.

---

### Q4.6 — The Jordan eigenvalue theorem and mass ratios

**Statement.** The exceptional Jordan algebra H₃(𝕆) has a well-defined
notion of eigenvalues via the characteristic equation:
`X³ - tr(X) X² + S(X) X - det(X) = 0`
where `S(X)` is the sum of 2×2 minors.

A remarkable (and partly conjectural) result by Singh (2020, TIFR preprint)
claims that mass ratios of elementary particles can be read off from the
eigenvalues of specific elements of H₃(𝕆). Formally verifying even the
characteristic equation for H₃(𝕆) would be a significant step.

**Why novel.** The characteristic polynomial of H₃(𝕆) is a key tool in the
study of F₄ and the octonion projective plane. No formal proof anywhere.

**Difficulty.** Hard (characteristic equation) to Very Hard (mass ratio claims).

**Source.** Baez (2002) Section 3; Singh TIFR preprint (2020);
McCrimmon "A Taste of Jordan Algebras" (2004).

---

## Tier 5 — Long-horizon (5–10 year formalization projects)

These are identified as long-term goals of the project and are mentioned for
completeness. They require substantial new mathematical infrastructure before
any single theorem can be proved.

---

### Q5.1 — E8 as a Lie algebra

Define e₈ as the exceptional 248-dimensional Lie algebra and prove:
- It is simple.
- Its root system has 240 roots (rank 8, dimension 248 = 8 + 240).
- Its Cartan matrix has determinant 1.
- It contains G₂ and F₄ as subalgebras.

**Prerequisite chain:** G₂ (Q3.1) → F₄ (Q3.5) → E₆ → E₇ → E₈.

---

### Q5.2 — Octonion projective plane OP²

Define the octonionic projective plane as the quotient
`{(x, y, z) ∈ 𝕆³ : not all zero} / ∼` with the appropriate non-associative
equivalence relation, and prove its symmetry group is F₄.

**Prerequisite:** Q2.5 (H₃(𝕆)), Q3.5 (F₄ = Aut(H₃(𝕆))).

---

### Q5.3 — E8 and the heterotic string

The heterotic string compactified on the E₈ × E₈ torus has a 496-dimensional
gauge symmetry. Formally state and prove the basic representation-theoretic
fact that the adjoint of E₈ × E₈ has dimension 496, and identify the massless
spectrum.

**Note:** This is physics-interpretation work that requires semantic review.

---

## Summary table

| ID | Question | Difficulty | Status | Formalized elsewhere? |
|----|----------|-----------|--------|----------------------|
| 1.1 | Inner automorphisms have order 3 | Medium | Tier 1 | No |
| 1.2 | normSq(conj x * y) = normSq x * normSq y | Easy | Tier 1 | No |
| 1.3 | octonionDot is bilinear | Easy | Tier 1 | No |
| 1.4 | ImOct is 7-dim | Easy | Tier 1 | No |
| 1.5 | Commutator self-zero | Easy | Tier 1 | No |
| 1.6 | D4 Cartan is symmetric | Trivial | Tier 1 | No |
| 2.1 | Hurwitz theorem | Hard | Tier 2 | No |
| 2.2 | Der(𝕆) ≅ G₂ (Lie alg) | Hard | Tier 2 | No |
| 2.3 | G₂ Cartan matrix | Moderate | Tier 2 | No |
| 2.4 | E₈ Cartan matrix | Moderate | Tier 2 | No |
| 2.5 | H₃(𝕆) Jordan identity | Hard | Tier 2 | No |
| 2.6 | ConventionBridge correctness | Moderate | Tier 2 | No |
| 2.7 | Cl(6) from operator composition | Hard | Tier 2 | No |
| 2.8 | Anomaly cancellation for J | Easy–Mod | Tier 2 | No |
| 3.1 | G₂ = Aut(𝕆) | Very Hard | Tier 3 | No |
| 3.2 | Moufang loop simplicity | Hard | Tier 3 | No |
| 3.3 | Spin(8) representation triality | Very Hard | Tier 3 | No |
| 3.4 | E₈ root count = 240 | Hard | Tier 3 | Partial (lattice) |
| 3.5 | F₄ = Aut(H₃(𝕆)) | Very Hard | Tier 3 | No |
| 4.1 | Baez 2025 triality–Moufang open question | Open | Tier 4 | Open in math |
| 4.2 | Baez–Huerta SUSY theorem | Very Hard | Tier 4 | No |
| 4.3 | Freudenthal magic square | Multi-year | Tier 4 | No |
| 4.4 | Furey 2025 Z₂⁵ superalgebra | Research | Tier 4 | No (paper 2025) |
| 4.5 | Three generations from triality | Research | Tier 4 | No |
| 4.6 | Jordan characteristic equation | Hard | Tier 4 | No |

---

## References

- [Baez (2002)](https://math.ucr.edu/home/baez/octonions/) — "The Octonions", Bull. Amer. Math. Soc. 39, 145–205
- [Baez nCat (Sep 2025)](https://golem.ph.utexas.edu/category/2025/09/a_shadow_of_triality.html) — "A Shadow of Triality?" (open question on triality–Moufang link)
- [Baez–Huerta (2010)](https://arxiv.org/abs/0909.0551) — "Division Algebras and Supersymmetry I"
- [Furey (2016)](https://arxiv.org/abs/1611.09182) — PhD thesis: "Standard model physics from an algebra?"
- [Furey (2018)](https://arxiv.org/abs/1806.00612) — SU(3) × SU(2) × U(1) from ladder operators
- [Furey et al. (2019)](https://arxiv.org/abs/1910.08395) — Three generations, two unbroken gauge symmetries
- [Furey (2025)](https://arxiv.org/abs/2505.07923) — "A Superalgebra Within", ℤ₂⁵-graded structure
- [Geometric triality (2025)](https://www.mdpi.com/2073-8994/17/9/1414) — Geometric Realization of Triality via Octonionic Vector Fields
- [Krasnov (2018)](https://arxiv.org/abs/1805.06739) — Octonions, exceptional Jordan algebra, F₄ in particle physics
- [Adams (1996)](https://press.uchicago.edu/ucp/books/book/chicago/L/bo3630685.html) — "Lectures on Exceptional Lie Groups"
- [Springer–Veldkamp (2000)](https://link.springer.com/book/10.1007/978-3-662-12622-6) — "Octonions, Jordan Algebras and Exceptional Groups"
- [math-inc/Sphere-Packing-Lean](https://github.com/math-inc/Sphere-Packing-Lean) — E₈ lattice formalization (Apache-2.0)
