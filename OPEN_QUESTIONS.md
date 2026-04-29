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
  number operators, charge formula Q = -(1/3)(N₁+N₂+N₃), basis_linear_independent.
- D4 triality: Cartan matrix, order-3 cycle, Cartan preservation.
- Octonion symmetry primitives: dot product, imaginary subspace, commutator.

**Oracle-verification note.** Proof sketches marked *oracle-verified* have been
checked numerically against 30–100 random samples in Python before being written.
This is not a proof but confirms the statement is true and the approach is sound.

---

## Tier 1 — Near-term (1–3 Aristotle jobs each)

These questions have clear statements, known proof strategies, and all
prerequisites are already in the project. Most reduce to finite computation
or straightforward algebra over existing simp lemmas.

---

### Q1.1 — Inner automorphisms of the unit-octonion Moufang loop have order 3

**Statement (clarified from original).** The unit octonions `{x : Octonion | normSq x = 1}`
form a Moufang loop under multiplication. For any unit octonion `u`, the
"inner mapping" `T_u : x ↦ u⁻¹ * (x * u)` (where `u⁻¹ = conj u` for unit
octonions) satisfies `T_u^3 = id`.

More concretely, for any imaginary unit octonion `u` (with `normSq u = 1`,
`u.c0 = 0`), the map `x ↦ u * (x * u)` composed with itself three times is
the identity — a consequence of the Moufang identity.

**Caution on statement.** The naive algebraic inner automorphism
`x ↦ u * x * u⁻¹` does NOT generally have order 3 — for imaginary unit `u`,
it has order 2 on many elements (e.g., `u * e010 * u⁻¹ = -e010` for
`u = e001`). The order-3 result refers specifically to the Moufang loop
inner mappings, which are compositions of left and right translations.
This distinction must be stated carefully in Lean.

**Why novel.** Yokota (1990) proved all Moufang loop inner maps of unit
octonions have order 3. John Baez (September 2025) asked whether a clean
direct proof via the Moufang identities — without the G₂ machinery Yokota
uses — can be found. Our project has exactly the right tools: three Moufang
identities already proved.

**Proof sketch for the specific map T_u(x) = u⁻¹ * (x * u).**
For imaginary unit `u`: `u⁻¹ = conj u = -u` (since `normSq u = 1`).
So `T_u(x) = (-u) * (x * u) = -(u * (x * u))`.

Computing `T_u³(x)`:
```
T_u(x)   = -(u*(x*u))
T_u²(x)  = T_u(-(u*(x*u))) = -(u*(-(u*(x*u))*u)) = u*(u*(x*u))*u
T_u³(x)  = T_u(u*(u*(x*u))*u) = ...
```
The key step: use the **middle Moufang identity**
`u * (y * (u * z)) = ((u * y) * u) * z`
applied with `y = u*(x*u)` and the order-3 of `u*(u*(u*x)) = (u*u*u)*x = -u*x`
(using `u*u = -1` twice).

**Difficulty.** Medium. Requires careful parenthesization; all steps use
existing Moufang lemmas. Strong Aristotle target.

**Prerequisites.** `moufang_middle`, `moufang_right`, `mul_conj`, `normSq_one`.

**Source.** Baez (2002) Section 4.1; Yokota (1990); nCat Café "A Shadow of
Triality?" (September 2025).

---

### Q1.2 — Three isotopic forms of the octonion norm

**Statement.** For all `x y : Octonion`:
```lean
theorem normSq_conj_mul (x y : Octonion) :
    normSq (conj x * y) = normSq x * normSq y

theorem normSq_mul_conj (x y : Octonion) :
    normSq (x * conj y) = normSq x * normSq y
```
These are the three forms of the composition algebra isotopy:
`normSq (x * y) = normSq (conj x * y) = normSq (x * conj y) = normSq x * normSq y`.

**Why interesting.** These are the three "slots" corresponding to the three
8-dimensional representations of Spin(8) permuted by triality. The fact that
all three compositions give the same normSq is the algebraic fingerprint of
the triality symmetry.

**Proof sketch.** *Oracle-verified.*
```lean
theorem normSq_conj_mul (x y : Octonion) :
    normSq (conj x * y) = normSq x * normSq y := by
  rw [← normSq_conj x, normSq_mul]
  -- normSq(conj x) = normSq x  by normSq_conj
  -- normSq(conj x * y) = normSq(conj x) * normSq y  by normSq_mul
```
One line: `rw [← normSq_conj, normSq_mul]` or
`simp only [normSq, conj_c0, ..., mul_c0, ..., Octonion.mul_c7]; ring`.

**Difficulty.** Easy — two-line proofs using existing theorems.

**Prerequisites.** `normSq_mul`, `normSq_conj` (both proved).

**Source.** Baez (2002) Section 2.3.

---

### Q1.3 — The octonion dot product is symmetric and bilinear

**Statement.** The function `octonionDot` already defined in `OctonionSymmetry.lean`
as the component-wise sum `x.c0*y.c0 + ... + x.c7*y.c7` satisfies:
```lean
theorem octonionDot_comm (x y : Octonion) : octonionDot x y = octonionDot y x
theorem octonionDot_add_left (x y z : Octonion) :
    octonionDot (x + y) z = octonionDot x z + octonionDot y z
theorem octonionDot_smul_left (r : ℝ) (x y : Octonion) :
    octonionDot (r • x) y = r * octonionDot x y
theorem octonionDot_zero_left (y : Octonion) : octonionDot 0 y = 0
```
Together with `octonionDot_self_eq_normSq` (already proved), these establish
`octonionDot` as the unique symmetric positive-definite bilinear form
polarising `normSq`.

**Proof sketch.** All four are `simp [octonionDot, Octonion.add_c0, ...,
Octonion.smul_c0, ...] <;> ring` after unfolding the definition.
Each proof is 1–2 lines.

**Difficulty.** Trivial. Add all four in one Aristotle job alongside Q1.4.

**Source.** Standard Euclidean geometry; Baez (2002) Section 1.

---

### Q1.4 — The imaginary octonions form a 7-dimensional real subspace

**Statement.** Recall `IsImaginary x ↔ x.c0 = 0` (already in `OctonionSymmetry.lean`).
```lean
theorem isImaginary_add {x y : Octonion} :
    IsImaginary x → IsImaginary y → IsImaginary (x + y)
theorem isImaginary_smul {x : Octonion} (r : ℝ) :
    IsImaginary x → IsImaginary (r • x)
theorem isImaginary_neg {x : Octonion} :
    IsImaginary x → IsImaginary (-x)
theorem isImaginary_basisElem {k : Fin 8} (hk : k ≠ 0) :
    IsImaginary (basisElem k)
theorem isImaginary_iff_conj_neg (x : Octonion) :
    IsImaginary x ↔ conj x = -x
```

**Proof sketch.** All by `simp [IsImaginary, Octonion.add_c0, ...]`.
The `isImaginary_iff_conj_neg` uses `conj_eq_neg_of_imaginary` (already proved).

**Difficulty.** Trivial.

---

### Q1.5 — The octonionic cross product norm formula

**Statement.** For imaginary octonions `x y : Octonion` (with `x.c0 = 0`, `y.c0 = 0`):
```lean
theorem normSq_commutator_imaginary {x y : Octonion}
    (hx : IsImaginary x) (hy : IsImaginary y) :
    normSq (octonionCommutator x y) =
    4 * (normSq x * normSq y - octonionDot x y ^ 2)
```

This is the **octonionic cross product norm formula**, the direct analogue of
`|u × v|² = |u|²|v|² - (u·v)²` in ℝ³. It says the 7-dimensional imaginary
subspace carries a cross product whose norm is controlled by the dot product.

**Also:**
```lean
theorem octonionDot_eq_scalar_part_of_conj_mul (x y : Octonion) :
    octonionDot x y = (conj x * y).c0
```
This connects the dot product to the scalar part of the product — a key identity
linking the algebraic and geometric structures. *Oracle-verified.*

**Proof sketch for cross product norm.** *Oracle-verified.*
Use the product decomposition of imaginary octonions: for `x`, `y` imaginary,
`x * y = -(octonionDot x y) • 1 + (x*y + y*x)/2 + octonionCommutator x y / 2`.
More directly:
```
normSq(x*y) = (x*y).c0^2 + normSq(imaginary part of x*y)
= octonionDot(x,y)^2 + normSq(octonionCommutator(x,y))/4   [scalar + imaginary split]
normSq(x*y) = normSq x * normSq y                            [normSq_mul]
```
Combining: `normSq(octonionCommutator(x,y)) = 4*(normSq x * normSq y - octonionDot(x,y)^2)`.

In Lean: `ext <;> simp [octonionCommutator, normSq, octonionDot, IsImaginary,
  Octonion.mul_c0, ...] <;> ring`.

**Proof sketch for dot = scalar part.** *Oracle-verified.*
```lean
theorem octonionDot_eq_scalar_part (x y : Octonion) :
    octonionDot x y = (conj x * y).c0 := by
  simp [octonionDot, conj, Octonion.mul_c0]; ring
```

**Difficulty.** Cross product norm: Easy (ring after simp). Scalar part: Easy.

**Source.** Standard; Baez (2002) Section 1.

---

### Q1.6 — The D4 Cartan matrix satisfies the basic root system axioms

**Statement.** The `d4Cartan` defined in `Triality.lean` satisfies:
```lean
theorem d4Cartan_diag (i : Fin 4) : d4Cartan i i = 2
theorem d4Cartan_off_diag_nonpos (i j : Fin 4) (h : i ≠ j) :
    d4Cartan i j ∈ ({0, -1} : Finset ℤ)
theorem d4Cartan_symm_zero (i j : Fin 4) :
    d4Cartan i j = 0 ↔ d4Cartan j i = 0
```

**Proof sketch.** All three: `fin_cases i <;> fin_cases j <;> decide`.

**Difficulty.** Trivial. Three 4-line proofs.

---

## Tier 2 — Medium-term (4–10 Aristotle jobs, needs some new infrastructure)

---

### Q2.1 — Hurwitz theorem (classification of normed division algebras)

**Statement.** Every finite-dimensional real algebra `A` satisfying
`normSq (x * y) = normSq x * normSq y` for a positive-definite quadratic form
`normSq` is isomorphic to `ℝ`, `ℂ`, `ℍ`, or `𝕆`.

**Why novel.** No formal proof exists in any proof assistant as of 2026.

**Proof strategy (three layers).**

*Layer 1 — Existence (already proved):* `normSq_mul` shows 𝕆 satisfies the
composition property. ℝ, ℂ, ℍ also satisfy it (proven in mathlib).

*Layer 2 — Upper bound on dimension:* The key lemma is that the Cayley–Dickson
double of any composition algebra of dimension n gives a composition algebra
of dimension 2n, but the double of 𝕆 (the sedenions, dim = 16) is NOT a
composition algebra. This can be proved by explicit counterexample: find
sedenion elements `s, t` with `normSq(s*t) ≠ normSq(s)*normSq(t)`. The
proof is a finite computation once the sedenion multiplication table is defined.

*Layer 3 — Uniqueness:* Any two composition algebras of the same dimension
over ℝ are isomorphic. This requires constructing an explicit isomorphism,
which is the hardest part.

**Near-term formal target.** The sedenions fail the composition property:
define `sed_mul : Fin 16 → Fin 16 → Fin 16 → ℝ` (the sedenion multiplication
table via Cayley–Dickson from 𝕆) and prove there exist basis elements
`e_a, e_b` with `normSq(e_a * e_b) ≠ 1 = normSq(e_a) * normSq(e_b)`.
This is a `decide`-based computation on `Fin 16`.

**Prerequisites.** `normSq_mul` (complete), Milestone 2 (Cayley–Dickson, stub).

**Difficulty.** Hard for the full theorem; the sedenion counterexample is Moderate.

**Source.** Hurwitz (1898); Baez (2002) Section 2.

---

### Q2.2 — Der(𝕆) is 14-dimensional

**Statement.** The vector space of octonion derivations
`Der(𝕆) = {D : 𝕆 →ₗ ℝ 𝕆 | ∀ x y, D(x * y) = D(x) * y + x * D(y)}`
has real dimension 14.

**Why 14?** A derivation D is determined by 8 linear maps `D(eₖ)` (each an
8-dimensional vector), giving 64 free parameters. The Leibniz rule imposes
64 × 8 = 512 linear constraints. The key fact: `rank(constraint matrix) = 50`,
leaving `64 - 50 = 14` dimensions. *Oracle-verified: the constraint matrix
has rank 50, giving a 14-dimensional null space.*

**Proof sketch (dimension count).**
```lean
-- Represent D as an 8×8 real matrix M where D(eᵢ) = ∑ⱼ M[i,j] * eⱼ
-- D(1) = 0 forces M[0,*] = 0 (8 equations)
-- Leibniz for basis pairs (eᵢ, eⱼ) forces 64 systems of 8 equations each
-- The constraint matrix is:
--   A : Matrix (Fin 512) (Fin 64) ℝ
-- Prove: A.rank = 50
-- Conclude: dim(null A) = 64 - 50 = 14
```

The rank-50 fact is a finite computation: build A explicitly from the
multiplication table (using `Octonion.mul_c0`...`mul_c7`) and verify rank.
This is the type of computation that `native_decide` or `norm_num` can handle.

**Also prove:** The antisymmetry of the associator (which is needed to show
the null space is exactly 14-dimensional and not larger):
```lean
theorem assoc_antisymm_12 (a b c : Octonion) :
    (a * b) * c - a * (b * c) = -((b * a) * c - b * (a * c))
-- Proof: ext <;> simp [mul_c0,...] <;> ring  (oracle-verified)
```
This uses our Moufang + alternativity machinery.

**Why G₂?** (Harder, separate target.) Once we have 14 derivations, show their
Lie bracket structure matches the G₂ root system (rank 2, 12 roots, Cartan
matrix [[2,-1],[-3,2]]). This requires the G₂ Cartan matrix (Q2.3) and
connecting the bracket structure of derivations to the root data.

**Difficulty.** Dimension count: Moderate (finite matrix rank). G₂ identification: Hard.

**Source.** Baez (2002) Section 4.1; Springer–Veldkamp (2000) Chapter 2.
Oracle: `Scripts/oracle/validate_octonion.py` extended with constraint analysis.

---

### Q2.3 — The G₂ Cartan matrix

**Statement.** Define `g2Cartan : Fin 2 → Fin 2 → ℤ` as:
```lean
def g2Cartan (i j : Fin 2) : ℤ :=
  match i.val, j.val with
  | 0, 0 =>  2 | 0, 1 => -1
  | 1, 0 => -3 | 1, 1 =>  2
  | _, _ =>  0
```
(Bourbaki convention, with the short root α and long root β; the ratio of
root lengths is √3 : 1 giving the asymmetric entries -1 and -3.)

Prove:
```lean
theorem g2Cartan_diag (i : Fin 2) : g2Cartan i i = 2  -- by decide
theorem g2Cartan_det : g2Cartan 0 1 * g2Cartan 1 0 - 2 * 2 = -4 + 3  -- det = 1
-- Equivalently: det([[2,-1],[-3,2]]) = 4 - 3 = 1
theorem g2Cartan_det_eq : (2 : ℤ) * 2 - (-1) * (-3) = 1  -- by decide
theorem g2Cartan_non_simply_laced : g2Cartan 0 1 ≠ g2Cartan 1 0
-- The asymmetric entries signal that G₂ is non-simply-laced
```

**Interpretation.** `g2Cartan 0 1 = -1` means the long root β has Dynkin label
1 over the short root. `g2Cartan 1 0 = -3` means the short root α loses 3
steps for each β. This encodes the 1:√3 length ratio of G₂ roots.

**Proof sketch.** All by `fin_cases i <;> fin_cases j <;> decide` or `norm_num`.

**Difficulty.** Trivial computations; the mathematical significance takes more work.

**Source.** Bourbaki Ch. 4–6; Baez (2002) Section 4.

---

### Q2.4 — The E₈ Cartan matrix

**Statement.** Define `e8Cartan : Fin 8 → Fin 8 → ℤ` using the Bourbaki
labelling of E₈ (nodes 0–7, where node 1 branches off node 3 in the main
chain 0-2-3-4-5-6-7):

```lean
-- Connected pairs (0-indexed, Bourbaki E8 with branch at node 3):
-- Chain: 0--2--3--4--5--6--7, Branch: 1--3
-- Adjacency: {(0,2),(2,3),(3,4),(4,5),(5,6),(6,7),(1,3)} symmetric

def e8Cartan (i j : Fin 8) : ℤ :=
  if i = j then 2
  else if (i,j) ∈ ({(0,2),(2,0),(2,3),(3,2),(3,4),(4,3),(4,5),(5,4),
                     (5,6),(6,5),(6,7),(7,6),(1,3),(3,1)} : Finset _)
  then -1 else 0
```

The E₈ Cartan matrix (explicit 8×8, rows 0–7):
```
row 0: [ 2, 0,-1, 0, 0, 0, 0, 0]
row 1: [ 0, 2, 0,-1, 0, 0, 0, 0]
row 2: [-1, 0, 2,-1, 0, 0, 0, 0]
row 3: [ 0,-1,-1, 2,-1, 0, 0, 0]
row 4: [ 0, 0, 0,-1, 2,-1, 0, 0]
row 5: [ 0, 0, 0, 0,-1, 2,-1, 0]
row 6: [ 0, 0, 0, 0, 0,-1, 2,-1]
row 7: [ 0, 0, 0, 0, 0, 0,-1, 2]
```

Prove:
```lean
theorem e8Cartan_diag (i : Fin 8) : e8Cartan i i = 2
theorem e8Cartan_off_diag (i j : Fin 8) (h : i ≠ j) :
    e8Cartan i j ∈ ({0, -1} : Finset ℤ)
theorem e8Cartan_symm (i j : Fin 8) :
    e8Cartan i j = 0 ↔ e8Cartan j i = 0
-- Unimodularity (det = 1): the hardest result
theorem e8Cartan_unimodular : Matrix.det (Matrix.of (fun i j => (e8Cartan i j : ℚ))) = 1
-- Connectivity: The Dynkin diagram is connected
theorem e8Cartan_connected : -- statement TBD from mathlib root system API
```

**Why novel.** The sphere-packing project proves unimodularity via the *lattice*
approach. Our proof from the Cartan matrix / Dynkin diagram would be the first
Lie-theoretic formalization of this fact.

**Proof sketch for unimodularity.** `native_decide` on the explicit 8×8 integer
matrix — this is a finite computation once the matrix is defined.

**Difficulty.** Matrix definition + basic properties: Easy. Unimodularity: Easy
(native_decide). Connecting to root system: Moderate.

**Source.** Adams (1996) Ch. 7; Bourbaki Ch. 4–6; math-inc/Sphere-Packing-Lean.

---

### Q2.5 — The exceptional Jordan algebra H₃(𝕆) and the Jordan identity

**Statement.** Define the exceptional Jordan algebra as 3×3 self-adjoint
octonionic matrices. Its dimension over ℝ is 3 (diagonal) + 3×8 (off-diagonal
octonions) = **27**. Equip it with the Jordan product `X ∘ Y = (1/2)(XY + YX)`
and prove the **Jordan identity**: `(X ∘ X) ∘ (X ∘ Y) = X ∘ ((X ∘ X) ∘ Y)`.

**Representation.** A general element:
```lean
structure H3O where
  diag0 : ℝ              -- (0,0) entry, must be real
  diag1 : ℝ              -- (1,1) entry
  diag2 : ℝ              -- (2,2) entry
  off01 : Octonion        -- (0,1) entry; (1,0) = conj off01
  off02 : Octonion        -- (0,2) entry; (2,0) = conj off02
  off12 : Octonion        -- (1,2) entry; (2,1) = conj off12
```

**Proof sketch.**

*Dimension proof (Easy):* A Lean structure with 3 real fields + 3 octonion
fields (each 8 real numbers) has `3 + 3×8 = 27` real parameters. The formal
dimension statement uses `LinearIndependent ℝ` over an explicit basis.

*Jordan identity (Hard):* The identity `(X²) ∘ (X ∘ Y) = X ∘ (X² ∘ Y)` is a
degree-4 polynomial identity in 27 variables. After expanding `X ∘ Y` in
components (using the octonionic matrix product, which involves non-associative
octonion multiplication), the identity reduces to:
```
ext <;> simp [H3O.jordan_prod, H3O.mul, ...] <;> ring
```
The key steps use the **Moufang identity** of 𝕆 to handle the non-associativity
of octonionic matrix multiplication.

The Jordan identity for H₃(𝕆) was verified by Jordan–von Neumann–Wigner (1934)
and is equivalent to the pair of alternative laws for 𝕆, together with the
`normSq_mul` property.

**What makes this hard.** The expansion involves 3×3 matrix products where
each entry is an octonionic sum. The resulting polynomial identity in 27 real
variables (3 real diagonals + 3×8 octonion components) is large but computable.
Strong Aristotle target.

**Difficulty.** Dimension: Easy. Jordan identity: Hard (large but mechanical).

**Source.** Jordan–von Neumann–Wigner (1934); Baez (2002) Section 3;
Springer–Veldkamp (2000) Chapter 5.

---

### Q2.6 — ConventionBridge: formal correctness of the Baez→XOR sign map

**Statement.** The map `baezBasisInXOR` defined in `ConventionBridge.lean`
(applying permutation π and sign σ, where only Baez e₅ gets sign −1)
is an isomorphism of octonion algebras from Baez convention to project XOR.
Specifically, for all 7 Baez positive triples (a, b, c):
```lean
theorem bridge_triple_1 : baezBasisInXOR 1 * baezBasisInXOR 2 = baezBasisInXOR 4
theorem bridge_triple_2 : baezBasisInXOR 2 * baezBasisInXOR 3 = baezBasisInXOR 5
theorem bridge_triple_3 : baezBasisInXOR 3 * baezBasisInXOR 4 = baezBasisInXOR 6
theorem bridge_triple_4 : baezBasisInXOR 4 * baezBasisInXOR 5 = baezBasisInXOR 7
theorem bridge_triple_5 : baezBasisInXOR 5 * baezBasisInXOR 6 = baezBasisInXOR 1
theorem bridge_triple_6 : baezBasisInXOR 6 * baezBasisInXOR 7 = baezBasisInXOR 2
theorem bridge_triple_7 : baezBasisInXOR 7 * baezBasisInXOR 1 = baezBasisInXOR 3
```
*Oracle-verified: all 7 triples pass.*

**Explicit values used.** The permutation π: 1↦1, 2↦2, 3↦6, 4↦3, 5↦4, 6↦5, 7↦7.
The sign σ: only Baez e₅ gets −1 (maps to −e100); all others get +1.
So `baezBasisInXOR 5 = -basisElem 4` (the −e100 element) while all others are
`±basisElem(π(k))` with + sign.

**Proof sketch.** Each triple is a concrete product of explicit `Octonion` values:
```lean
-- e.g., bridge_triple_1: (e001) * (e010) = e011 in XOR convention
-- baezBasisInXOR 1 = basisElem 1 = e001
-- baezBasisInXOR 2 = basisElem 2 = e010
-- baezBasisInXOR 4 = basisElem 3 = e011
-- Proof: ext <;> simp [baezBasisInXOR, baezToXORIndex, baezToXORSign,
--                       basisElem, mul_c0, ...] <;> decide
```

**Why novel.** This is the formal guarantee that all Furey formulas using
the Baez convention are correctly translated to the project XOR convention.

**Difficulty.** Moderate. Seven `fin_cases`/`decide` proofs after unfolding.

**Source.** `Scripts/oracle/validate_convention_bridge.py`.

---

### Q2.7 — Furey left-multiplication operators on J are nilpotent

**Statement.** Define the left-multiplication operator:
```lean
def L_alpha1 (x : ComplexOctonion) : ComplexOctonion := alpha1 * x
```
Then prove:
```lean
theorem L_alpha1_nilpotent (x : ComplexOctonion) :
    alpha1 * (alpha1 * x) = 0
```
This says `L_alpha1 ∘ L_alpha1 = 0` as a linear operator on ComplexOctonion.
Similarly for `L_alpha2` and `L_alpha3`.

**Why this differs from the existing `alpha1_nilpotent`.** The existing theorem
`alpha1 * alpha1 = 0` proves nilpotency *of the element*. This theorem proves
nilpotency *of the operator* (i.e., with an arbitrary `x` between them),
which is stronger and requires left alternativity.

**Proof sketch.** The key step uses the **left alternative law for ComplexOctonion**:
```
alpha1 * (alpha1 * x)    [operator nilpotency]
= (alpha1 * alpha1) * x  [by ComplexOctonion.left_alternative]
= 0 * x                  [by alpha1_nilpotent]
= 0                      [by zero_mul]
```

This requires two auxiliary theorems:

*Step 1:* `ComplexOctonion.left_alternative`:
```lean
theorem ComplexOctonion.left_alternative (a b : ComplexOctonion) :
    a * (a * b) = (a * a) * b
```
Proof: Expand using `mul_re`, `mul_im` and `Octonion.left_alternative`:
```lean
ext <;> simp [mul_re, mul_im, Octonion.left_alternative,
              ← Octonion.left_alternative] <;> ring
```
The real-octonion left_alternative handles the sub-expressions; the
antisymmetry of the associator closes the remaining cross terms.

*Step 2:* `ComplexOctonion.zero_mul`:
```lean
theorem ComplexOctonion.zero_mul (b : ComplexOctonion) : (0 : ComplexOctonion) * b = 0
```
Proof: `ext <;> simp [mul_re, mul_im]`.

**Complete proof of L_alpha1_nilpotent:**
```lean
theorem L_alpha1_nilpotent (x : ComplexOctonion) : alpha1 * (alpha1 * x) = 0 := by
  rw [← ComplexOctonion.left_alternative, alpha1_nilpotent, ComplexOctonion.zero_mul]
```

**Why novel.** The distinction between element nilpotency and operator nilpotency
is the key step toward the Clifford algebra Cl(6) acting on J. The operator
version implies the canonical anticommutation `{L_α, L_α†} = id` when combined
with the product anticommutation already proved.

**Difficulty.** Moderate. Two auxiliary lemmas + a clean three-line proof.

**Prerequisites.** `alpha1_nilpotent` (proved), `Octonion.left_alternative` (proved).

**Source.** Furey arXiv:1806.00612, Section 2.

---

### Q2.8 — Charge cancellation over the full algebraic generation J ⊕ J̄

**Statement (corrected from original).** The charges over J ALONE do NOT sum
to zero (`∑ Q = -4` for J). However, the two complementary minimal left
ideals J (generated by `omega`) and J̄ (generated by `omega_bar`) together
satisfy:
```lean
-- Sum of charges over J: -1 + 3*(-2/3) + 3*(-1/3) + 0 = -4
theorem charge_sum_J : (-1 : ℚ) + 3*(-2/3) + 3*(-1/3) + 0 = -4

-- J_bar carries negated charges (anti-particles)
-- Over J ⊕ J_bar, the sum cancels:
theorem charge_sum_full_generation : (-4 : ℚ) + 4 = 0
```

More interesting is the **cubic anomaly condition** relevant to Standard Model
consistency. The cubic anomaly for J and J̄ combined:
```lean
-- sum Q^3 over J = (-1)^3 + 3*(-2/3)^3 + 3*(-1/3)^3 + 0^3 = -2
-- sum Q^3 over J_bar = -(-2) = 2  (charges negated, Q^3 sign flips)
-- Total: 0
theorem cubic_charge_sum_J :
    (-1 : ℚ)^3 + 3*(-2/3)^3 + 3*(-1/3)^3 = -2
theorem cubic_anomaly_full_generation : (-2 : ℚ) + 2 = 0
```

**Why interesting.** These are the first formal statements connecting the
algebraic charge assignments in `MinimalLeftIdeal.lean` to Standard Model
anomaly conditions. While simple as arithmetic facts, their proof imports
the charge eigenvalues already kernel-verified.

**Proof sketch.** All statements are `norm_num` after importing the charge
values from `MinimalLeftIdeal.lean`.

**Difficulty.** Easy — `norm_num` on explicit rational numbers.

**Note.** The physically interesting anomaly cancellation conditions include the
`U(1)³` and `U(1)·gravity²` anomalies, which involve hypercharge Y = 2Q, and
may require the combined SM gauge group structure. This more complete version
is a longer-term target.

**Source.** Furey arXiv:1806.00612, Section 4.

---

## Tier 3 — Substantial (requires new major infrastructure)

---

### Q3.1 — G₂ = Aut(𝕆): the full automorphism theorem

**Statement.** The group of algebra automorphisms of the real octonions is
the compact Lie group G₂, which has dimension 14.

**No formal proof exists in any proof assistant.**

**Proof strategy (multiple Aristotle moonshots).**

*Step 1 — Aut(𝕆) ⊆ O(8):* Every automorphism φ of 𝕆 preserves the norm
(`normSq(φ(x)) = normSq(x)`), so Aut(𝕆) is a closed subgroup of O(8).
Proof uses: φ(x*y) = φ(x)*φ(y) ⟹ normSq(φ(x)*φ(y)) = normSq(φ(x))*normSq(φ(y))
= normSq(x)*normSq(y) = normSq(x*y); since φ is a bijection, normSq is preserved.

*Step 2 — Aut(𝕆) is a manifold of dimension 14:* Use the orbit-stabilizer
theorem. Aut(𝕆) acts transitively on pairs (u, v) of orthogonal imaginary
unit octonions (from the proof that any imaginary unit is the image of e001
under some automorphism, and similarly for the second). The stabilizer of
`e001` acts on the orthogonal complement of span(e001), which is 6-dimensional
with SU(3) structure. The fibration gives dim = 6 + 8 = 14... actually:
dim(Aut(𝕆)) = dim(orbit of e001) + dim(stabilizer of e001)
= 6 (S⁶ = unit imaginary sphere) + 8 ... hmm this requires careful analysis.

*Step 3 — Identify with G₂:* The Lie algebra of Aut(𝕆) is Der(𝕆) (proved in
Q2.2 as 14-dimensional). Show it is simple and has the G₂ root structure (Q2.3).

**Difficulty.** Very Hard. 3–5 separate Aristotle moonshots needed.

**Source.** Baez (2002) Section 4; Cartan (1914); Adams (1996) Ch. 5.

---

### Q3.2 — The Moufang loop of unit octonions

**Statement.** The set `S⁷ = {x : Octonion | normSq x = 1}` is closed under
multiplication and forms a Moufang loop.

Key theorems to prove:
```lean
-- Closure under multiplication
theorem unit_mul_unit {x y : Octonion} (hx : normSq x = 1) (hy : normSq y = 1) :
    normSq (x * y) = 1  -- from normSq_mul

-- Inverses exist via conjugate
theorem unit_inv {x : Octonion} (hx : normSq x = 1) :
    x * conj x = 1  -- from mul_conj with normSq x = 1

-- Moufang identity holds (loop version)
-- For unit x, y, z: (x*y)*(z*x) = x*((y*z)*x)  -- from moufang_left
-- Non-associativity: there exist x,y,z with (x*y)*z ≠ x*(y*z)
theorem not_associative :
    ∃ (x y z : Octonion), normSq x = 1 → normSq y = 1 → normSq z = 1 →
    (x * y) * z ≠ x * (y * z)
-- Counterexample: x=e001, y=e010, z=e100
-- (e001*e010)*e100 = e011*e100 = ?
-- e001*(e010*e100) = e001*e110 = ?
-- Check these are different.
```

**Proof sketch for `unit_inv`.**
From `mul_conj`: `x * conj x = (x.c0² + ... + x.c7²) • 1 = normSq x • 1`.
When `normSq x = 1`: `x * conj x = 1 • 1 = 1`.

**Proof sketch for `not_associative`.**
Compute `(e001 * e010) * e100` vs `e001 * (e010 * e100)`:
- `(e001 * e010) * e100 = e011 * e100 = ?`  row 3, col 4: -e111
- `e001 * (e010 * e100) = e001 * e110 = ?`  row 1, col 6: +e111
These differ (one is -e111, the other +e111). Non-associativity confirmed.

**Difficulty.** Moderate. Most proofs use existing machinery.

**Source.** Baez (2002) Section 1; Paige (1956).

---

### Q3.3 — The three 8-dimensional representations of D₄ are triality-related

**Statement.** The D₄ Dynkin diagram has an order-3 outer automorphism
`d4OuterCycle` (already proved in `Triality.lean`). The three outer nodes
(0, 2, 3) correspond to the vector representation V and the two half-spin
representations S₊, S₋ of Spin(8). The triality cycle permutes these three
representations cyclically.

**Formal target.** At the Cartan matrix level, prove that the three outer nodes
have identical "neighborhood structure" in the D₄ diagram:
```lean
theorem d4_outer_nodes_equivalent (k : Fin 3) :
    -- All three outer nodes have the same number of connections (= 1)
    -- and connect only to the central node
    ∀ j : Fin 4, j ≠ 1 →
    d4Cartan (![0, 2, 3].get k) j = d4Cartan 1 (![0, 2, 3].get k)
-- (meaning: outer nodes connect only to the central node, not to each other)
```
And prove that `d4OuterCycle` maps between these equivalent positions.

**Difficulty.** Moderate at Cartan level (fin_cases). Very Hard for the
representation-level statement.

**Source.** Baez (2002) Section 2; Adams (1996) Ch. 1.

---

### Q3.4 — E₈ root count = 240

**Statement.** The E₈ root system contains exactly 240 roots (120 positive, 120 negative).

**Proof strategy — explicit enumeration.** The E₈ roots can be constructed as
the union of two sets in `ℝ⁸ ≅ Fin 8 → ℝ`:
```
Set 1 (112 roots): ±eᵢ ± eⱼ  for all 1 ≤ i < j ≤ 8
Set 2 (128 roots): (1/2)(±e₁ ± e₂ ± ... ± e₈) with an EVEN number of minus signs
```
(Total: 112 + 128 = 240.)

In Lean, with the E₈ lattice already in `math-inc/Sphere-Packing-Lean` (Apache-2.0,
available on Linux but not directly importable on Windows due to `Aux.lean`),
the proof can be:

*Option A (import):* Import `SpherePacking.Dim8.E8.Packing` and use
`E8Matrix_unimodular` + the fact that minimal vectors of the unimodular E₈
lattice are exactly the roots.

*Option B (direct):* Construct a `Finset (Fin 8 → ℤ)` explicitly containing
the 240 vectors and prove each is a root of the E₈ root system using the
E₈ Cartan matrix from Q2.4.

**Difficulty.** Hard. Requires bridging the Lie-theoretic root system API
(mathlib) with the explicit vector construction.

**Source.** Adams (1996) Ch. 7; math-inc/Sphere-Packing-Lean.

---

### Q3.5 — F₄ = Aut(H₃(𝕆))

**Statement.** The automorphism group of H₃(𝕆) (exceptional Jordan algebra)
is the 52-dimensional compact Lie group F₄.

**Proof strategy.**
1. From Q2.5: H₃(𝕆) is defined and the Jordan identity is proved.
2. Show Aut(H₃(𝕆)) contains a copy of G₂ (acting on the octonion entries)
   and a copy of Spin(9) ... actually the structure is more complex.
3. Key identification: dim(Der(H₃(𝕆))) = 52 = dim(F₄), provable by a constraint
   analysis similar to Q2.2 but for 27×27 matrices satisfying the Jordan Leibniz rule.
4. Show the resulting Lie algebra is simple of type F₄ by checking the Cartan matrix.

**Difficulty.** Very Hard. Multiple moonshots.

**Source.** Chevalley–Schafer (1950); Baez (2002) Section 4; Springer–Veldkamp (2000).

---

## Tier 4 — Frontier (open in mathematics, or at the edge of current knowledge)

---

### Q4.1 — Baez's 2025 open question: Moufang-based proof of order-3 inner automorphisms

**Exact open question (Baez, September 2025, nCat Café).** Can one prove that
inner automorphisms of the Moufang loop S⁷ have order 3 in a way that
visibly uses the Moufang identities — without going through the G₂ structure
that Yokota's proof invokes? Conway and Smith (2003) suggest the connection
exists but the argument is "convoluted."

**Our position.** We have:
- All three Moufang identities formally proved.
- The D₄ triality cycle of order 3 formally proved.
- The machinery to compute product compositions explicitly.

A Lean proof that directly chains the Moufang identities to produce the order-3
result would be the first clean, kernel-verified proof of this connection.

**Prerequisites.** Q1.1 (inner automorphism statement), Q3.2 (Moufang loop setup).

**Source.** Baez nCat Café "A Shadow of Triality?" (September 2025);
Conway–Smith "On Quaternions and Octonions" (2003), Chapter 8.

---

### Q4.2 — Division algebras and SUSY: the Baez–Huerta theorem

**Statement.** The identity `v · (v · ψ) = -|v|² ψ` (for a vector `v` and
spinor `ψ`, with the appropriate inner product) holds in spacetime dimensions
3, 4, 6, 10 — exactly `1 + dim(K)` for `K ∈ {ℝ, ℂ, ℍ, 𝕆}` — and is
the algebraic heart of supersymmetry in these dimensions.

**Why novel.** Baez–Huerta (2010) proved this but it is not yet formalized.
Connecting the SUSY algebra stub (`SUSYAlgebra.lean`) to the octonion
foundation requires formalizing the Clifford algebra Cl(n) and its spinor
representations.

**Difficulty.** Very Hard. Needs Clifford algebra machinery (Milestone 3).

**Source.** Baez–Huerta arXiv:0909.0551 (2010).

---

### Q4.3 — The Freudenthal magic square

**Statement.** The construction L(A, B) from pairs of normed division algebras
gives the magic square of Lie algebras:

| L(A,B) | ℝ  | ℂ    | ℍ  | 𝕆  |
|--------|-----|------|-----|-----|
| ℝ      | A₁  | A₂   | C₃  | F₄  |
| ℂ      | A₂  | 2A₂  | A₅  | E₆  |
| ℍ      | C₃  | A₅   | D₆  | E₇  |
| 𝕆      | F₄  | E₆   | E₇  | E₈  |

**Tractable first entry.** The entry L(𝕆, ℝ) = F₄ connects to Q3.5. Proving
even this single entry would be the first formal instance of the magic square.

**Difficulty.** Multi-year project.

**Source.** Freudenthal (1964); Tits (1966); Baez (2002) Section 4.4.

---

### Q4.4 — Furey 2025: the ℤ₂⁵-graded superalgebra

**Statement.** (arXiv:2505.07923, Annalen der Physik 2025.) The particle
representations of the lightest Standard Model particles form a ℤ₂⁵-graded
algebra isomorphic to H₁₆(ℂ), generated by the division algebraic substructure
ℝ ⊂ ℂ ⊂ ℍ ⊂ 𝕆, with gauge symmetry su(3)_C ⊕ su(2)_L ⊕ u(1)_Y plus
four U(1) factors.

**Why novel.** Published in May 2025, completely unformalised. The ℤ₂⁵ grading
is induced by the four division algebra inclusions — a structure that has no
formal treatment anywhere.

**Difficulty.** Very Hard / research-level.

**Source.** Furey arXiv:2505.07923 (May 2025).

---

### Q4.5 — Three generations from triality

**Statement.** (Furey et al. 2024.) The three generations of Standard Model
fermions arise from three copies of J related by the ℤ₃ triality symmetry
of the octonions. Under `d4OuterCycle`-type permutations of the Furey
ladder operators, three isomorphic minimal left ideals J₁, J₂, J₃ carry
the 48 states of a full three-generation spectrum.

**Difficulty.** Research-level.

**Source.** Furey et al. "Three generations and a trio of trialities" (2024).

---

### Q4.6 — The Jordan characteristic equation for H₃(𝕆)

**Statement.** Every element X ∈ H₃(𝕆) satisfies a degree-3 characteristic
equation:
```
X³ - tr(X) X² + S(X) X - det(X) 1 = 0
```
where `det(X)` is the cubic form (norm) on H₃(𝕆) and `S(X)` is the sum of
2×2 minors (a quadratic form).

This is the analogue of the Cayley–Hamilton theorem for the exceptional Jordan
algebra and is a key tool in the study of F₄ and the octonionic projective plane.

**Proof sketch.** The identity is a polynomial identity in 27 real variables.
After expanding X³, X², X in components via the Jordan product, apply `ring`.
The octonionic non-associativity is handled by the Jordan identity (Q2.5),
which itself uses the Moufang identity. This is a large but mechanical computation.

**Difficulty.** Hard (requires Q2.5 first).

**Source.** Baez (2002) Section 3; McCrimmon "A Taste of Jordan Algebras" (2004).

---

## Tier 5 — Long-horizon (5–10 year formalization projects)

---

### Q5.1 — E₈ as a Lie algebra

Define e₈ as the 248-dimensional simple exceptional Lie algebra. Prove:
- Root system has 240 roots (rank 8, dim = 8 + 240 = 248).
- Cartan matrix has determinant 1.
- Contains G₂ and F₄ as subalgebras.
- E₈ = Der(H₃(𝕆)) ⊕ H₃(𝕆) ⊕ H₃(𝕆) (Tits construction).

**Prerequisite chain:** G₂ (Q3.1) → F₄ (Q3.5) → E₆ → E₇ → E₈.

---

### Q5.2 — Octonion projective plane OP²

Define OP² as the Cayley plane (the compact Riemannian symmetric space F₄/Spin(9))
and prove its symmetry group is F₄.

**Prerequisite:** Q2.5 (H₃(𝕆)), Q3.5 (F₄ = Aut(H₃(𝕆))).

---

### Q5.3 — E₈ and the heterotic string

The adjoint representation of E₈ has dimension 248. Formally prove dim(adj E₈) = 248
and that dim(E₈ × E₈) = 496 (the anomaly-free dimension for the heterotic string).

**Note:** Physics interpretation requires semantic review before any formal claim.

---

## Summary table

| ID | Question | Difficulty | Proof sketch available? | Formalized elsewhere? |
|----|----------|-----------|------------------------|----------------------|
| 1.1 | Inner maps of S⁷ have order 3 | Medium | Partial (Moufang chain) | No |
| 1.2 | Three isotopic norm formulas | Easy | Yes (2-line proofs) | No |
| 1.3 | octonionDot is bilinear | Easy | Yes (ring) | No |
| 1.4 | ImOct is 7-dim subspace | Easy | Yes (simp) | No |
| 1.5 | Cross product norm formula | Easy | Yes (simp+ring) | No |
| 1.6 | D4 Cartan axioms | Trivial | Yes (decide) | No |
| 2.1 | Hurwitz theorem | Hard | Partial (sedenion step) | No |
| 2.2 | dim(Der(𝕆)) = 14 | Moderate | Yes (rank computation) | No |
| 2.3 | G₂ Cartan matrix | Moderate | Yes (explicit matrix) | No |
| 2.4 | E₈ Cartan matrix | Moderate | Yes (explicit matrix) | No |
| 2.5 | H₃(𝕆) Jordan identity | Hard | Partial (ring after expand) | No |
| 2.6 | ConventionBridge correctness | Moderate | Yes (7 decide proofs) | No |
| 2.7 | Operator nilpotency of L_α | Moderate | Yes (3-line proof via left_alt) | No |
| 2.8 | Charge cancellation J ⊕ J̄ | Easy | Yes (norm_num) | No |
| 3.1 | G₂ = Aut(𝕆) | Very Hard | Strategy only | No |
| 3.2 | Moufang loop axioms | Moderate | Yes (existing theorems) | No |
| 3.3 | D4 triality and representations | Very Hard | Partial (Cartan level) | No |
| 3.4 | E₈ root count = 240 | Hard | Strategy (explicit set) | Partial (lattice) |
| 3.5 | F₄ = Aut(H₃(𝕆)) | Very Hard | Strategy only | No |
| 4.1 | Baez 2025 triality–Moufang | Open | Open | Open in math |
| 4.2 | Baez–Huerta SUSY theorem | Very Hard | None | No |
| 4.3 | Freudenthal magic square | Multi-year | None | No |
| 4.4 | Furey 2025 ℤ₂⁵ superalgebra | Research | None | No (paper 2025) |
| 4.5 | Three generations from triality | Research | None | No |
| 4.6 | Jordan characteristic equation | Hard | Partial (ring after Q2.5) | No |

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
