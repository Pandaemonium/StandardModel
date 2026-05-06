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
- Furey operator representation layer: left-multiplication operators on J,
  anticommutation relations for the operator-level Cl(6) action, color-changing
  operators, and the corrected electric-charge operator `Q_op`.
- D4 triality: Cartan matrix, order-3 cycle, Cartan preservation.
- Octonion symmetry primitives: dot product, imaginary subspace, commutator.
- Triality-companion foothold: `cube`, `conjBy`, unit cancellation through
  conjugates, the forward `cube = +/-1` automorphism theorems for `conjBy`,
  and the corresponding order-three iteration theorems.

**Literature refresh (2026-04-29).** The main external updates are:
- Furey's number-operator construction is about electric charge and the
  unbroken `SU(3)_C × U(1)_em` symmetry; it should not be silently relabeled as
  weak hypercharge.
- Furey's 2018 ladder-operator paper targets `SU(3)_C × SU(2)_L × U(1)_Y`
  (possibly with an extra `U(1)_X`) as a symmetry of the division-algebraic
  ladder operators, so the next formal step is to separate `Q`, `T3`, and `Y`
  rather than using `Y = 2Q`.
- Furey-Hughes 2024/2025 "Three Generations and a Trio of Trialities" gives a
  concrete ambitious target: identify the Standard Model internal Lie algebra
  inside `tri(ℂ) ⊕ tri(ℍ) ⊕ tri(𝕆)` and track the triality triple
  `(Ψ_+, Ψ_-, V)` over `ℂ ⊗ ℍ ⊗ 𝕆`.
- Furey 2025 "A Superalgebra Within" upgrades the long-horizon program from
  minimal left ideals alone to a `ℤ₂⁵`-graded algebra isomorphic to
  `H₁₆(ℂ)`, with gauge-boson-like and fermion-like representations included.
- Baez's 2025 triality note, citing Yokota and Conway-Smith, suggests a more
  precise Moufang/triality target: conjugation by a unit octonion `a` is an
  automorphism exactly when `a^3 = ±1`; the order-three phenomenon is not a
  statement about arbitrary conjugation maps.
- Barton-Sudbery, Springer-Veldkamp, and the mathlib/SpherePacking ecosystem
  make the magic-square/E8 side more formalizable than this document originally
  assumed: there are now plausible import-or-bridge targets, not only oracle
  targets.
- Coding-theory literature gives a real string-theory bridge:
  the extended binary Hamming [8,4,4] code gives the E8 lattice by
  Construction A, and recent heterotic Narain work identifies binary-code
  Construction A data for both the E8 x E8 and Spin(32)/Z2 heterotic
  backgrounds. This is much stronger than the ordinary Standard Model analogy,
  where anomaly cancellation is currently best treated as linear and cubic
  charge equations unless extra code/lattice structure is supplied.

**Correction ledger.**
- Do not present coordinate `H3O` polynomial identities as compact Lie group
  isomorphisms. Claims such as `Aut(h_3(O)) ~= F4`,
  `Stab(h_2(O)) ~= Spin(9)`, and the final
  `S(U(2) x U(3))` stabilizer theorem require Lie group/topology/quotient
  infrastructure and are not consequences of coordinate arithmetic alone.
- Do not present the Krasnov/Baez `O^2` route as the full Standard Model
  fermion sector. It currently targets a left-handed one-generation
  representation; right-handed fermions and three generations must remain
  explicit open problems unless separately formalized.
- Do not state `Y = 2Q` as a Standard Model identity. With the usual
  normalization `Q = T3 + Y/2`, hypercharge is `Y = 2(Q - T3)`.
- The sedenion counterexample is useful, but it is not the upper-bound proof in
  Hurwitz's classification. It proves that one Cayley-Dickson continuation
  fails to be a composition algebra, not that every dimension greater than 8 is
  impossible.
- For `G₂ = Aut(𝕆)`, norm preservation is not automatic from multiplicativity
  alone unless the proof also controls the real unit, conjugation/scalar part,
  or inverses. Treat this as a theorem with explicit hypotheses.
- Operator nilpotency over all `ComplexOctonion` elements is not the same as the
  verified finite action table on J. Prefer the J-restricted operator algebra
  and anticommutation theorems until the global alternativity API is proved.
- Any theorem exhibiting nonassociativity should put the unit-norm hypotheses in
  the existential witness, not behind implications that make the theorem easier
  to satisfy.
- In the Hamming/Fano bridge, the seven Fano lines are the weight-3 words of
  the [7,4,3] Hamming code; their complements are the weight-4 words in the
  same length-7 code. After adding the parity bit, the extended [8,4,4] code
  has 14 weight-4 words, plus `00000000` and `11111111`.

**New high-value Aristotle prompt drafts.**
- `octonion-symmetry-primitives`: finish dot bilinearity, scalar-part identity,
  imaginary-subspace closure, and the cross-product norm formula.
- `furey-su3-u1-operator-algebra`: prove the operator commutator table for the
  color-changing operators and `Q_op` on J; this is the submitted moonshot
  `bb0868bf-5312-4437-bc55-7c65e015ba17`.
- `furey-hypercharge-bridge`: introduce a separate weak-isospin operator `T3_op`
  and define `Y_op := 2 * (Q_op - T3_op)` only after the left/right state
  convention is explicit.
- `g2-derivation-rank`: build a rational 64-variable derivation constraint
  matrix from the XOR multiplication table and prove rank 50, hence
  `dim Der(𝕆) = 14`.
- `h3o-jordan-scaffold`: define `H3O`, the Jordan product, trace, determinant
  candidate, and prove easy structural lemmas before attempting the full Jordan
  identity.
- `triality-companions`: formalize Conway-Smith/Yokota companion maps for left
  and right multiplication by a unit octonion, then prove the `a^3 = ±1`
  automorphism criterion. Integrated result from Aristotle job
  `d76adda3-911d-43d2-ac78-6d122fcda89c`: the forward `cube = +/-1`
  automorphism and order-three theorems are trusted; companion identities and
  the converse remain open.
- `e8-import-bridge`: compare project root data with mathlib root-system APIs
  and SpherePacking's E8 lattice statements before attempting any new E8 proof
  from scratch.

**Oracle-verification note.** Proof sketches marked *oracle-verified* have been
checked numerically against 30–100 random samples in Python before being written.
This is not a proof but confirms the statement is true and the approach is sound.

---

## Tier 1 — Near-term (1–3 Aristotle jobs each)

These questions have clear statements, known proof strategies, and all
prerequisites are already in the project. Most reduce to finite computation
or straightforward algebra over existing simp lemmas.

---

### Q1.1 — Moufang/triality criterion for octonion conjugation maps

**Statement (corrected after the 2026 literature refresh).** The unit
octonions `{x : Octonion | normSq x = 1}` form a Moufang loop under
multiplication. For a unit octonion `a`, the conjugation map
`C_a : x ↦ a * x * a⁻¹` is an algebra automorphism exactly when `a^3 = ±1`
(equivalently, when `a^3` is a real scalar after normalization). In the
nontrivial case, the resulting automorphism has order 3.

Trusted formal progress: `PhysicsSM.Algebra.Octonion.TrialityCompanions`
defines `cube a := (a * a) * a` and `conjBy a x := (a * x) * conj a`, then
proves that `conjBy a` preserves multiplication when `normSq a = 1` and
`cube a = 1` or `cube a = -1`. It also proves the corresponding order-three
iteration theorem.

Remaining target: prove the companion-map identities behind the conceptual
Conway-Smith/Yokota proof, and then attack the converse direction.

**Caution on statement.** The naive algebraic inner automorphism
`x ↦ u * x * u⁻¹` does NOT generally have order 3 — for imaginary unit `u`,
it has order 2 on many elements (e.g., `u * e010 * u⁻¹ = -e010` for
`u = e001`). The order-3 result refers specifically to the Moufang loop
inner mappings, which are compositions of left and right translations.
This distinction must be stated carefully in Lean.

**Why novel.** Yokota proved the criterion using triality and Moufang-style
identities; Baez's September 2025 note asks for a clean explanation of the
relationship between Spin(8) triality and these octonionic conjugation
phenomena. Our project has the Moufang identities and a D4 triality scaffold,
so it is well positioned to isolate the exact formal bridge.

**Exploratory proof sketch for a special map.** The following calculation is
kept as a useful Moufang-algebra exercise, not as the full theorem statement.
It must be reviewed against the exact Conway-Smith/Yokota companion-map
formalization before being promoted to a trusted target.

For the specific map `T_u(x) = u⁻¹ * (x * u)`:
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

**Difficulty.** Forward direction: trusted. Companion-map proof and converse:
medium-hard to research-level.

**Prerequisites.** `moufang_middle`, `moufang_right`, `mul_conj`, `normSq_one`.

**Source.** Baez (2002) Section 4.1; Yokota, *Exceptional Lie Groups*;
Conway-Smith, *On Quaternions and Octonions*; Baez nCat Café "A Shadow of
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

### Q1.7 — Fano plane and the [7,4,3] Hamming code

**Statement.** The seven nonzero vectors of `F2^3` serve simultaneously as:
1. The seven points of the Fano plane, with lines the triples `{a,b,c}` such
   that `a + b + c = 0`.
2. The seven columns of the parity-check matrix of the binary [7,4,3] Hamming
   code.
3. The seven imaginary octonion basis labels in the project's XOR convention,
   with oriented lines supplying the octonion multiplication signs.

The formal entry point should avoid a common off-by-one/code-dual confusion:
the Fano lines are the weight-3 codewords of the [7,4,3] Hamming code. Their
complements are the weight-4 codewords of that same length-7 code. After adding
the parity bit, the extended [8,4,4] Hamming code has 14 weight-4 words, plus
`00000000` and `11111111`.

```lean
-- `fanoTriples` encodes 7 positive Fano lines as triples of nonzero XOR labels.
-- The seven imaginary-octonion indices are exactly `{1,2,3,4,5,6,7}`.
theorem fano_xor_closure (t : fanoTriples.val) :
    t.1.val ^^^ t.2.1.val = t.2.2.val

-- Schematic target: after choosing the same column order in the parity-check
-- matrix, the support of a weight-3 Hamming codeword is exactly a Fano line.
theorem hamming743_weight_three_support_iff_fano_line
    (v : Fin 7 -> ZMod 2) :
    v ∈ hamming743 ->
    hammingNorm v = 3 ->
    IsFanoLine {i | v i = 1}
```

**Why interesting.** This is the finite combinatorial root of the Hamming ->
E8 -> heterotic-string lattice chain. It also gives a disciplined way to
compare the project's octonion XOR convention with coding-theory conventions
before any E8 or anomaly statement is attempted.

**Public Lean status.**
- Mathlib has `Mathlib.InformationTheory.Hamming`: Hamming distance and weight.
- This repo has `fanoTriples` in `PhysicsSM/Algebra/Octonion/Basic.lean`.
- I did not find a public Lean definition of the [7,4,3] Hamming code or a
  Fano/Hamming bridge lemma. A small local `LinearCode` wrapper around a
  `Submodule (ZMod 2) (Fin n -> ZMod 2)` should be enough for this target.

**Proof sketch.** Define the `3 x 7` parity-check matrix whose columns are the
nonzero vectors of `F2^3` in the same XOR-label order used by `fanoTriples`.
The equation `H * v = 0` says exactly that the XOR-sum of the support is zero.
For support size 3, that is precisely the Fano-line condition. All finite
checks should close by `fin_cases`, `decide`, and the existing Hamming weight
definition.

**Difficulty.** Easy-Moderate. The Fano/XOR fact is finite computation; the
main task is choosing a reusable Lean representation of binary linear codes.

**Source.** Baez (2002) Section 1; Hamming (1950); MacWilliams-Sloane,
*The Theory of Error-Correcting Codes*; Error Correction Zoo entries for the
[7,4,3] and [8,4,4] Hamming codes.

---

## Tier 2 — Medium-term (4–10 Aristotle jobs, needs some new infrastructure)

---

### Q2.1 — Hurwitz theorem (classification of normed division algebras)

**Statement.** Every finite-dimensional real algebra `A` satisfying
`normSq (x * y) = normSq x * normSq y` for a positive-definite quadratic form
`normSq` is isomorphic to `ℝ`, `ℂ`, `ℍ`, or `𝕆`.

**Why novel.** No formal proof exists in any proof assistant as of 2026.

**Proof strategy (corrected three-layer version).**

*Layer 1 — Existence (already proved):* `normSq_mul` shows 𝕆 satisfies the
composition property. ℝ, ℂ, ℍ also satisfy it (proven in mathlib).

*Layer 2 — Formalize composition-algebra structure theory:* The real proof of
Hurwitz's classification does not follow merely by checking that the sedenions
fail. It needs the standard structure theorem for finite-dimensional real
unital composition algebras: after choosing an element outside the base field
and repeatedly adjoining orthogonal imaginary units, the process stops at
dimensions 1, 2, 4, or 8. This is the hard theorem, and it will require a
careful Lean API for quadratic forms, conjugation, orthogonal complements, and
subalgebra generation.

*Layer 3 — Uniqueness and convention matching:* Once the dimension is known,
construct explicit isomorphisms to ℝ, ℂ, ℍ, or the project XOR octonions. The
octonion case must document the Fano orientation and basis convention.

**Near-term formal target.** Keep the sedenion result, but label it correctly:
it is a counterexample showing that the next Cayley-Dickson double is not a
composition algebra, not a proof of the Hurwitz upper bound.

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

### Q2.7 — Furey operator algebra on J

**Status after Aristotle integration.** The most important J-restricted
operator layer is now kernel-verified in
`PhysicsSM.Algebra.Furey.OperatorRepresentations`: `Lmul`, its action on the
8-state minimal left ideal J, operator-level anticommutation on J, color
operators, and the corrected electric-charge operator `Q_op`.

**Updated statement.** Continue from the verified J-restricted representation
instead of first trying to prove global operator nilpotency over all
`ComplexOctonion` elements. The next target is:
```lean
-- Every commutator [Λ_i, Λ_j] agrees with the expected su(3) linear
-- combination on each of the eight J basis states.
theorem color_operator_commutator_table_on_J : ...

-- Q_op commutes with the su(3) color action on J.
theorem Q_op_commutes_with_color_on_J : ...
```

**Older global target, now demoted to a supporting lemma.** Define the
left-multiplication operator:
```lean
def L_alpha1 (x : ComplexOctonion) : ComplexOctonion := alpha1 * x
```
Then prove:
```lean
theorem L_alpha1_nilpotent (x : ComplexOctonion) :
    alpha1 * (alpha1 * x) = 0
```
This would say `L_alpha1 ∘ L_alpha1 = 0` as a linear operator on all
`ComplexOctonion`, and similarly for `L_alpha2` and `L_alpha3`. It should not
be promoted until the global alternativity/left-alternative API for
`ComplexOctonion` is proved and reviewed.

**Why this differs from the existing `alpha1_nilpotent`.** The existing theorem
`alpha1 * alpha1 = 0` proves nilpotency *of the element*. This theorem proves
nilpotency *of the operator* (i.e., with an arbitrary `x` between them),
which is stronger and requires left alternativity.

**Proof sketch for the demoted global lemma.** The key step would use the
**left alternative law for ComplexOctonion**:
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

**Why still useful.** The distinction between element nilpotency and operator
nilpotency remains important, but the repository now has the safer
J-restricted operator representation. The global lemma is useful only if it
supports cleaner reuse of those J-level theorems.

**Difficulty.** Moderate. Two auxiliary lemmas + a short proof, after the
global `ComplexOctonion` alternativity statement is verified.

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

**Note.** The physically interesting anomaly cancellation conditions include
the `U(1)^3` and `U(1)·gravity^2` anomalies for weak hypercharge. Do not use
`Y = 2Q` globally. With the usual Standard Model convention
`Q = T3 + Y/2`, one has `Y = 2 * (Q - T3)`, so a faithful formal target needs
explicit weak-isospin assignments in addition to the electric-charge operator
already proved in the Furey layer.

**Source.** Furey arXiv:1603.04078 for electric charge from the number
operator; Furey arXiv:1806.00612 for the ladder-operator symmetry context.

---

### Q2.9 — Separate electric charge, weak isospin, and hypercharge

**Statement.** Introduce a convention-explicit bridge between the Furey
electric-charge operator and the Standard Model electroweak convention:
```lean
-- schematic, names to be aligned with the final state model
def T3_op : End J := ...
def Y_op : End J := 2 • (Q_op - T3_op)

theorem electroweak_charge_relation_on_basis (b : JBasis) :
    Q_op b = T3_op b + (1 / 2 : ℚ) • Y_op b
```

**Why important.** The repo now has a verified `Q_op`, but several planning
notes and older Aristotle outputs used hypercharge language for a number
operator that behaves as electric charge. This target prevents that convention
drift from spreading into anomaly-cancellation and Standard Model
representation files.

**Proof strategy.** Start with a table target over the eight J basis states.
Only after left/right chirality and antiparticle conventions are fixed should
this be generalized to a full generation. Cross-check against
`PhysicsSM.StandardModel.QuantumNumbers` and PhysLean/HEPLean conventions.

**Difficulty.** Moderate; the arithmetic is easy, but the semantic convention
review is essential.

**Source.** Furey arXiv:1806.00612 for the `SU(3)_C × SU(2)_L × U(1)_Y`
target; standard electroweak convention `Q = T3 + Y/2`.

---

### Q2.10 — Construction A: binary linear codes to lattices

**Statement.** Construction A maps a binary linear code `C <= F2^n` to the
integer lattice
```
A(C) = { x : Z^n | x mod 2 is in C }.
```
With the standard Euclidean scaling `Lambda_A(C) = (1 / sqrt 2) A(C)`,
self-orthogonal, doubly-even, and self-dual code hypotheses translate into
integral, even, and unimodular lattice properties.

```lean
abbrev BinaryLinearCode (n : Nat) :=
  Submodule (ZMod 2) (Fin n -> ZMod 2)

def constructionAInt (C : BinaryLinearCode n) : AddSubgroup (Fin n -> Int) :=
  { carrier := {x | (fun i => (x i : ZMod 2)) ∈ C}
    ... }

-- Schematic targets; final names should follow the lattice API chosen locally.
theorem constructionA_integral_of_selfOrthogonal
    (hC : SelfOrthogonal C) :
    IntegralLattice (scaledConstructionA C)

theorem constructionA_even_of_doublyEven
    (hC : DoublyEven C) :
    EvenLattice (scaledConstructionA C)

theorem constructionA_unimodular_of_selfDual
    (hC : SelfDual C) :
    UnimodularLattice (scaledConstructionA C)
```

**Why novel.** Construction A is the classical bridge between coding theory and
lattice theory. I found public Lean code for the endpoints, but not for this
bridge: mathlib has Hamming distance/weight, and `math-inc/Sphere-Packing-Lean`
has extensive E8/sphere-packing infrastructure, but neither appears to expose a
binary-linear-code-to-lattice Construction A layer. I also did not find public
Lean code for `LinearCode`, the [7,4,3] Hamming code, or the extended [8,4,4]
code as reusable objects.

**What's already in Lean.**
- Hamming metric/weight: `Mathlib.InformationTheory.Hamming`.
- Integer lattice infrastructure: `Mathlib.Algebra.Module.ZLattice.*`.
- E8 lattice and dimension-8 sphere-packing infrastructure:
  `math-inc/Sphere-Packing-Lean`.
- Standard Model anomaly equations: PhysLean/HEPLean has `ACCSystem`,
  `SMNoGrav`, and related Lean statements, but not this coding/lattice bridge.

**Proof sketch.** The key modular computations are finite and elementary:
`sum_i x_i^2 mod 2 = hammingNorm (x mod 2) mod 2`, and
`sum_i x_i y_i mod 2 = dot (x mod 2) (y mod 2)`. Self-orthogonality gives
integrality; doubly-even weight gives evenness after the `1/sqrt 2` scaling;
self-duality controls covolume/unimodularity. The final self-dual/unimodular
step is the first place where the `ZLattice` covolume API will matter.

**Difficulty.** Moderate. The arithmetic is small; the API design for binary
codes, dual codes, and scaled integer lattices is the real work.

**Source.** Leech (1967); Conway-Sloane, *Sphere Packings, Lattices and
Groups*; MacWilliams-Sloane, *The Theory of Error-Correcting Codes*; Error
Correction Zoo entry `errorcorrectionzoo.org/c/construction_a`.

---

### Q2.11 — [8,4,4] Hamming code to E8 via Construction A

**Statement.** Applying Construction A to the extended binary Hamming code
`H8` gives a lattice isometric to E8:
```lean
theorem constructionA_hamming844_isometric_E8 :
    IsometricLattice (scaledConstructionA H8) E8_lattice
```
where `E8_lattice` should be aligned either with the local project definition
or with the E8 lattice from `math-inc/Sphere-Packing-Lean`.

The [8,4,4] code is the smallest doubly-even self-dual binary code. Construction
A therefore gives an even unimodular rank-8 lattice; the concrete target should
prefer an explicit isometry or basis comparison over relying on an unformalized
classification theorem.

**Explicit construction.** Define `H8` as the even-parity extension of the
[7,4,3] Hamming code:
```lean
def extendEvenParity (v : Fin 7 -> ZMod 2) : Fin 8 -> ZMod 2 := ...
def hamming844 : BinaryLinearCode 8 :=
  span (ZMod 2) {extended rows/generator matrix}
```
Then prove:
- `hamming844_card = 16`.
- `hamming844_weight_enumerator = 1 + 14 X^4 + X^8`.
- `hamming844_doublyEven`.
- `hamming844_selfDual`.
- `scaledConstructionA hamming844` has the same Gram matrix as a chosen E8
  basis, or has an explicit linear isometry to the SpherePacking E8 lattice.

**Proof sketch.** First verify the 16 codewords by `decide` over `Fin 8 ->
ZMod 2`. Then choose a concrete basis for `A(H8)`, compute its Gram matrix, and
match that matrix to the E8 basis convention used by the imported/local E8
lattice. This route avoids depending on a global uniqueness theorem for even
unimodular rank-8 lattices unless such a theorem is later imported.

**What it would accomplish.** This is the first formal bridge from the
project's Fano/XOR octonion convention to a coding-theoretic construction of
E8. It also prepares the rank-16 heterotic-lattice target in Q4.7.

**Prerequisites.** Q1.7 (Fano/Hamming combinatorics), Q2.10 (Construction A),
and a reviewed E8 lattice convention.

**Difficulty.** Hard. The finite-code facts are small; the lattice-isometry
statement is the serious part.

**Source.** Error Correction Zoo entries for [8,4,4] Hamming and E8; Leech
(1967); Conway-Sloane Ch. 7; `math-inc/Sphere-Packing-Lean`.

---

### Q2.12 — Self-dual code building-up constructions (Baek-Kim, Lean, April 2026)

**Statement.** Baek and Kim have already formalized "building-up constructions
for binary and ℤ_q-ary self-dual codes through isotropic lines" in Lean
(arXiv:2604.08485, April 2026). Their results provide a verified algebraic
core for the codes underlying E8.

**What they prove.** Given a self-dual code `C` of length `n`, the building-up
construction produces new self-dual codes of length `n+2`. The key Lean
definitions include:
- `SelfDualCode`: a linear code equal to its dual
- `IsotropicLine`: a one-dimensional totally isotropic subspace
- `BuildUp`: the construction map (short code + isotropic line → longer code)

Their formalization uses isotropic lines in symplectic spaces over finite fields,
which generalizes both the binary case (for E8 construction) and the ternary
case (for Leech lattice via ternary Golay code).

**Immediate impact on this project.** This paper *directly enables* Q2.10
(Construction A for Hamming → E8). The missing piece was a formalization of
self-dual codes in Lean — Baek-Kim provide exactly that.

**Near-term action.** Determine whether arXiv:2604.08485 is a standalone Lean
project or already merged to mathlib. If standalone, evaluate importing it as
a Lake dependency. If its code is available and compatible with v4.28.0, Q2.10
becomes tractable immediately.

**Prerequisites.** `Mathlib.InformationTheory.Hamming` (Hamming metric ✓),
`Mathlib.LinearAlgebra.Matrix.DotProduct` (bilinear forms ✓), Baek-Kim library.

**Difficulty.** Easy–Moderate once the Baek-Kim library is imported.

**Source.** Baek–Kim arXiv:2604.08485 (April 2026), "Formalizing building-up
constructions of self-dual codes through isotropic lines in Lean."

---

### Q2.13 — Weight enumerator of [8,4,4] as a modular form

**Statement.** The weight enumerator of the [8,4,4] extended Hamming code is
the classical MacWilliams–Gleason polynomial:
```
W(x, y) = x⁸ + 14 x⁴ y⁴ + y⁸
```
This polynomial is a modular form of weight 4 under the theta-series
interpretation: substituting `x = θ₃(q)`, `y = θ₄(q)` gives the theta series
of the E8 lattice:
```
Θ_E8(q) = W(θ₃(q), θ₄(q)) = 1 + 240 q² + 2160 q⁴ + ...
```
where the coefficient 240 counts the minimal vectors (roots) of E8.

**Formal targets.** In Lean:
```lean
def hammingWeightEnumerator : MvPolynomial (Fin 2) ℤ :=
  X 0 ^ 8 + 14 * X 0 ^ 4 * X 1 ^ 4 + X 1 ^ 8

-- The 240 vectors come from the weight-4 codewords of H8
-- Each of the 14 weight-4 codewords lifts to 240/14... actually:
-- weight-4 codewords: 14 of them; each lifts to {±1}^4 in 4 positions → 2^4 = 16 vectors
-- 14 * 16 = 224; plus weight-8 codeword contributes 16 vectors: total = 240
theorem E8_root_count_from_hamming :
    (14 * 16 : ℕ) + 16 = 240 := by norm_num
```

**Why interesting.** The weight enumerator connects coding theory to:
1. The 240 roots of E8 (algebraic geometry / Lie theory)
2. The theta series of E8 (modular forms)
3. The genus-1 partition function of the heterotic string (physics)

The formal proof that `W` generates the ring of modular forms of level 1 would
be a non-trivial bridge to the modular-forms machinery being developed for the
sphere-packing formalization.

**Difficulty.** Moderate. The root-count arithmetic is `norm_num`; connecting
to modular forms requires mathlib's modular forms library.

**Source.** Gleason (1971); MacWilliams-Sloane Ch. 19; Conway-Sloane Ch. 7.

---

## Tier 3 — Substantial (requires new major infrastructure)

---

### Q3.1 — G₂ = Aut(𝕆): the full automorphism theorem

**Statement.** The group of algebra automorphisms of the real octonions is
the compact Lie group G₂, which has dimension 14.

**No formal proof exists in any proof assistant.**

**Proof strategy (multiple Aristotle moonshots).**

*Step 1 — Aut(𝕆) ⊆ O(8):* Prove carefully that every unital algebra
automorphism φ of 𝕆 preserves conjugation, scalar part, and hence the norm.
One route is:
1. `φ 1 = 1`.
2. `x + conj x` and `x * conj x` are real scalar multiples of `1`.
3. Use uniqueness of the real and imaginary decomposition to show
   `φ (conj x) = conj (φ x)`.
4. Conclude `normSq (φ x) = normSq x`.

Do not use multiplicativity alone as a black box here; the Lean proof must make
the real-line/scalar-part preservation explicit.

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
    ∃ (x y z : Octonion),
      normSq x = 1 ∧ normSq y = 1 ∧ normSq z = 1 ∧
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

### Q3.6 — Uniqueness of even unimodular lattices in rank 16

**Statement.** Up to isometry, there are exactly two even unimodular lattices
in dimension 16: `E8 ⊕ E8` and `D16⁺`. This is the key theorem underlying
the uniqueness of the anomaly-free heterotic gauge groups.

Formally:
```lean
theorem even_unimodular_rank16_classification :
    ∀ (Λ : EvenUnimodularLattice 16),
    Λ ≅ E8_E8_lattice ∨ Λ ≅ D16plus_lattice
```

**Why critical.** This theorem is the **missing link** between Q2.11 (Hamming → E8)
and Q4.7 (E8⊕E8 from two Hamming codes → heterotic string). The argument is:
1. The [8,4,4] code is Type II → Construction A gives an even unimodular lattice
   of rank 8 → isometric to E8 (by uniqueness in rank 8).
2. Two independent copies → even unimodular rank-16 lattice.
3. Uniqueness theorem → it must be E8⊕E8 or D16+.
4. The specific code choice determines which: two [8,4,4] codes give E8⊕E8;
   the [16,8,4] Reed-Muller code gives D16+.

**What's needed.** The rank-8 uniqueness (E8 is the unique even unimodular
lattice in rank 8) is essentially contained in `math-inc/Sphere-Packing-Lean`.
The rank-16 classification requires more: the Niemeier lattice classification
restricted to rank 16 (only 2 cases vs. 24 in rank 24).

**Difficulty.** Hard. The rank-8 half is close to done (Sphere-Packing-Lean);
the rank-16 part requires new work.

**Source.** Niemeier (1973); Conway-Sloane Ch. 18; Green-Schwarz (1984) (physics
application).

---

### Q3.7 — Adinkra symbols as linear codes in Lean

**Statement.** Adinkra symbols — the graphical representations of off-shell
supersymmetry multiplets introduced by Gates (2009) — are in bijection with
certain doubly even binary linear codes. Concretely:
- An Adinkra graph on `n` nodes with `k` "bosonic nodes" encodes an
  `[n, k]` binary code where the codewords describe the connectivity structure.
- The extended Hamming code [8,4,4] corresponds to the "vanilla" N=8 Adinkra.
- The extended Golay code [24,12,8] corresponds to the N=32 Adinkra underlying
  11-dimensional supergravity.

**Lean formal target.** Define `Adinkra` as a bipartite graph with additional
structure, define the map `adinkraToCode : Adinkra → LinearCode`, and prove:
```lean
theorem adinkra_to_code_is_doubly_even (A : Adinkra) :
    IsDoublyEven (adinkraToCode A)

theorem vanilla_adinkra_code_is_hamming :
    adinkraToCode vanilla_N8_adinkra ≅ extended_hamming_844
```

**Why interesting.** Gates identified this connection while studying supergravity
(and made the speculative claim about "computer code in the fabric of spacetime").
Regardless of the speculation, the formal mathematical content is real: Adinkras
encode supersymmetry representations as error-correcting codes.

The connection to our project: our `SUSYAlgebra.lean` stub defines the SUSY
anticommutator `{Q, Q̄} = 2σP`. Adinkras represent the off-shell multiplets
that solve this algebra. Formally connecting our SUSY algebra to the Adinkra
code structure would close the loop from the Hamming code through supersymmetry.

**Difficulty.** Hard. Requires defining bipartite graphs with signs (Adinkras)
and the code-extraction map.

**Source.** Gates et al. (2009) arXiv:0902.3007; Iga-Zhang (2016) for
classification; Error Correction Zoo `errorcorrectionzoo.org/c/adinkra`.

---

## Tier 4 — Frontier (open in mathematics, or at the edge of current knowledge)

---

### Q4.1 — Baez's 2025 open question: Moufang/triality proof of the conjugation criterion

**Exact open question (Baez, September 2025, nCat Café).** Can one prove that
the octonionic conjugation maps that are automorphisms, equivalently the unit
octonions with `a^3 = ±1`, have their order-three behavior in a way that
visibly uses the Moufang identities and triality companions, rather than
treating the result as a black-box corollary of the G₂ structure? Conway and
Smith (2003) suggest the connection exists but the argument is indirect.

**Our position.** We have:
- All three Moufang identities formally proved.
- The D₄ triality cycle of order 3 formally proved.
- The machinery to compute product compositions explicitly.
- A trusted forward-conjugation result in
  `PhysicsSM.Algebra.Octonion.TrialityCompanions`: for unit `a`, `cube a = 1`
  or `cube a = -1` implies that `conjBy a` preserves multiplication and has
  order three.

Remaining frontier piece: replace the current `grind`/coordinate-heavy proof
with a proof that directly chains the Moufang identities and the companion-map
form of triality, and prove the converse direction. That would turn the current
strong forward theorem into the full Conway-Smith/Yokota criterion.

**Prerequisites.** Q1.1 (conjugation criterion), Q3.2 (Moufang loop setup).

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

### Q4.5 — Three generations from a trio of trialities

**Statement.** (Furey-Hughes 2024 preprint, Phys. Lett. B 2025.) Identify
`su(3) ⊕ su(2) ⊕ u(1)` inside
`tri(ℂ) ⊕ tri(ℍ) ⊕ tri(𝕆)`, then act on the triality triple
`(Ψ_+, Ψ_-, V)` for `Ψ_+, Ψ_-, V ∈ ℂ ⊗ ℍ ⊗ 𝕆`. In the paper, the two spinor
slots provide two generations, while the vector slot provides a third
generation only after the Cartan factorization / non-degenerate trilinear
form constraint is imposed.

**Formalization warning.** This is not merely "three copies of J under the D4
Cartan-cycle theorem" already in the repo. The target needs the triality
algebra `tri(A)`, the tensor product `ℂ ⊗ ℍ ⊗ 𝕆`, and the paper's Cartan
factorization data. Treat any simple J-copy model as a toy approximation, not
as the literature statement.

**Difficulty.** Research-level.

**Source.** Furey and Hughes, "Three Generations and a Trio of Trialities",
arXiv:2409.17948; Phys. Lett. B 865 (2025), 139473.

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

### Q4.7 — E8 ⊕ E8 from two Hamming codes; the heterotic gauge lattice

**Statement.** The rank-16 even unimodular lattice `E8 ⊕ E8` arises from two
independent [8,4,4] extended Hamming codes:
```lean
theorem E8_direct_sum_from_two_hamming :
    constructionA H_ext ⊕ constructionA H_ext = E8_plus_E8_lattice
```
This is the Euclidean gauge-lattice piece associated with the `E8 x E8`
heterotic string. The companion rank-16 lattice `D16+` for the
`Spin(32)/Z2` heterotic string should be treated as a parallel code-lattice
target; the standard Reed-Muller/Construction-A description and the precise
Mizoguchi-Oikawa binary-code data need to be reconciled before stating a
trusted Lean theorem.

**Why interesting.** This is the lattice-theoretic skeleton behind the two
ten-dimensional heterotic gauge choices that survive anomaly cancellation:
`E8 x E8` and `Spin(32)/Z2`. The even unimodular rank-16 lattice condition is
not itself the full Green-Schwarz proof, but it is the mathematically clean
place where binary codes, E8, and heterotic gauge data meet.

**Recent literature.** Mizoguchi-Oikawa (arXiv:2602.16269, February 2026)
develops the code/Construction-A/Narain-CFT chain directly. Use that paper as
a source of candidate binary codes and convention checks, but review every
normalization against standard Narain and Conway-Sloane conventions before
promoting any theorem to trusted Lean.

**Connection to our project.** We have `Triality.lean` (D4 triality) and know
E8 contains D4 in its root system. The `d4OuterCycle_cartan_preserved` theorem
is related to the triality symmetry of the E8 ⊕ E8 gauge group.

**Prerequisites.** Q2.11 (Hamming -> E8 via Construction A), Q2.4 (E8 Cartan
matrix), the uniqueness theorem for even unimodular rank-16 lattices.

**Difficulty.** Very Hard. Needs Q2.11 plus classification of even unimodular
lattices in rank 16 (a known but non-trivial theorem).

**Source.** Narain (1986); Green-Schwarz (1984); Mizoguchi-Oikawa
arXiv:2602.16269 (2026); Conway-Sloane Ch. 18.

---

### Q4.8 — Green–Schwarz anomaly polynomial factorization (string theory level)

**Statement.** For the usual ten-dimensional `N = 1` supergravity/super
Yang-Mills setting, the one-loop anomaly polynomial `I₁₂` factorizes as:
```
I₁₂ = I₄ ∧ I₈
```
for the heterotic/type-I gauge algebras `e₈ × e₈` and `so(32)`. This
factorization is what allows the Green-Schwarz mechanism to cancel the anomaly
via a two-form `B` field.

**Formal near-term target.** State the Bianchi identity and the anomaly
cancellation condition as equalities of differential form polynomials in the
curvature and gauge field strength. The factorization condition reduces to
algebraic identities involving traces in the adjoint representation,
schematically of the form:
```
tr_{adj} F⁴ = (tr F²)² / λ
```
for a specific constant `λ` that holds only for the two anomaly-free gauge
groups.

**Connection to the coding chain.** The two heterotic gauge lattices in Q4.7
are the lattice/CFT input for the two ten-dimensional heterotic theories whose
low-energy gauge algebras pass the Green-Schwarz anomaly test. Do not state
that anomaly-polynomial factorization is simply equivalent to lattice
self-duality: the lattice condition is part of the string-consistency story,
while Green-Schwarz factorization also uses representation-theoretic trace
identities for `e8 x e8` and `so(32)`.

**Why this is Tier 4.** The formal statement of anomaly cancellation requires:
- Differential form algebra (not in project scope yet)
- The representation theory of e₈ and so(32)
- The specific trace identities and normalizations used in ten-dimensional
  super Yang-Mills/string conventions

PhysLean/HEPLean has Lean infrastructure for local anomaly cancellation in
Standard Model settings, but I did not find public Lean code for the
ten-dimensional Green-Schwarz polynomial factorization.

**Difficulty.** Very Hard — research-level.

**Source.** Green–Schwarz (1984) original papers; anomaly-cancellation review
by Bilal arXiv:0802.0634; Polchinski "String Theory" Vol. II, Ch. 10.

---

### Q4.9 — Standard Model anomaly conditions as linear/cubic code constraints

**Statement.** The Standard Model anomaly cancellation conditions over one
fermion generation are weighted sums over left-handed Weyl fermion
representations, with multiplicities and Dynkin indices made explicit:
```
sum_i dim(SU(3)_i) dim(SU(2)_i) Y_i = 0       gravitational-U(1)
sum_i dim(SU(3)_i) dim(SU(2)_i) Y_i^3 = 0     U(1)^3
sum_i T_2(SU(3)_i) dim(SU(2)_i) Y_i = 0       SU(3)^2-U(1)
sum_i dim(SU(3)_i) T_2(SU(2)_i) Y_i = 0       SU(2)^2-U(1)
```
There is no standalone Standard Model condition `sum_i Y_i^2 = 0`; any such
formula should be treated as a convention or transcription error unless a
specific source and representation weighting are supplied.

The question is whether these conditions can be recast as a code-theoretic
statement analogous to the string-theory case. The connection is weaker than
in string theory (the SM charges are not automatically from a lattice
construction), but there are approaches:

- **Linear constraint approach**: the anomaly conditions define a system of
  linear and cubic equations on hypercharge assignments. Formalize these as
  `LinearMap.ker` and cubic polynomial vanishing conditions.
- **Lattice approach**: asking whether any SM charge assignment extends to a
  self-dual lattice (a stronger condition, but potentially tractable for the
  specific SM values).

**Partial near-term target.** Using the existing charge eigenvalues in
`MinimalLeftIdeal.lean`, verify the cubic anomaly condition over J ⊕ J̄
formally. This was mentioned in Q2.8 but the connection to code theory is new.

**Note.** The ChatGPT analysis is correct: for the ordinary Standard Model,
the Hamming code connection is an *analogy* (shared combinatorial structure
via the Fano plane / octonion multiplication), not a direct derivation.
The honest formal statement would say: "the SM anomaly conditions hold and
can be proved as `norm_num` facts; a code-theoretic *explanation* would
require additional structure."

**Difficulty.** Moderate for the arithmetic statements; research-level for
the code-theoretic interpretation.

**Public Lean status.** PhysLean/HEPLean contains Lean definitions for anomaly
cancellation systems (`ACCSystem`) and Standard Model no-gravity examples
(`SMNoGrav`). This repo should either import/align those conventions or keep a
clear compatibility note before re-proving local anomaly arithmetic.

**Source.** Standard SM reviews; Bilal's anomaly lectures; PhysLean/HEPLean;
Furey arXiv:1806.00612 Section 4. The correct electroweak convention is
`Q = T3 + Y/2` (not `Y = 2Q`).

---

### Q4.10 — N=1 Super Vertex Operator Algebra uniqueness for E8 at level 2

**Statement.** (Open conjecture.) There exists a unique — up to isomorphism —
N=1 Super Vertex Operator Algebra (SVOA) whose even subalgebra corresponds to
the simply-connected WZW model of type E8 at level 2 (`V_{E8}^{(2)}`).

This is the "Type E" case in the classification of N=1 SVOAs. It is labelled
"contaminated" in the literature because `V_{E8}^{(2)}` has unusual properties:
it is not even a conformal field theory in the usual sense (the level-2 E8 WZW
model has a fractional central charge of 16 × 4/3 = 64/3 rather than an integer).

**Why it matters.** This uniqueness theorem would close the classification of
consistent supersymmetric theories that can emerge from the heterotic string.
The heterotic string at specific compactifications produces exactly these SVOAs.
A formal proof would provide a machine-verified bound on heterotic string vacua.

**Why Tier 4.** The conjecture is stated in the research literature but not proven
for the Type E case. The difficulty is the "contamination" — unusual modular
properties that prevent the standard arguments from applying.

**Connection to this project.** Our `SUSYAlgebra.lean` stub defines the basic
SUSY anticommutator. SVOAs are the algebraic structures that solve it in 2D
(worldsheet). Formally stating the uniqueness conjecture would connect our SUSY
stub to the string theory context.

**Source.** arXiv:1908.11012 (classification of N=1 SVOAs); the document's
citation to the "contaminated" Type E case.

---

### Q4.11 — F-theory: the 13 unproven transcendental lattice cases

**Statement.** (Open conjecture, with an extraordinary implication.) In the
study of F-theory compactifications on K3 surfaces, there are 34 transcendental
lattice types. For 21 of them, it is proven that the Kneser-Nishiyama frame
lattice contains roots (implying non-abelian gauge symmetry). For the remaining
13 cases, this is unproven.

The conjecture is that all 34 cases have non-abelian gauge symmetry. The document
notes the extraordinary consequence:

> **If the conjecture is FALSE for any of the 13 cases, it would imply the
> existence of a new optimal sphere packing in dimension 18** — a result that
> would conflict with current lattice theory (which places the 18D optimum at
> a density that is not achieved by any known lattice).

This is a remarkable case where a physics conjecture (F-theory gauge symmetry)
and a mathematics conjecture (18D sphere packing) are equivalent.

**Formal approach.** For each of the 13 unresolved transcendental lattice types
`T_k`, one needs to show that the complement lattice `T_k^⊥` in the K3 lattice
contains roots. This is a question about lattice embeddings — decidable for any
specific lattice by exhaustive search. The 21 proven cases were done by
Kneser-Nishiyama methods; the 13 remaining cases may be tractable with:
- Automated lattice-embedding search (using Gauss AI or similar)
- Connection to the math-inc/Sphere-Packing-Lean infrastructure

**Why notable.** This is the first example in this document of a physics
conjecture (F-theory) that is **equivalent** to a mathematical conjecture
(sphere packing) in a specific dimension.

**Difficulty.** Very Hard / Research-level. But each of the 13 cases is a
finite computation (lattice embedding search).

**Source.** Document §"The 34 F-Theory Cases"; Shimada-Zhang (K3 classification);
math-inc/Sphere-Packing-Lean (for the sphere-packing side).

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

### Q5.4 — Octions and an E₈ description of Standard Model structure

Manogue-Dray-Wilson (2022) identify elements of the real form
`e8(-24)` with Standard Model objects, including the Lorentz algebra,
`su(3) + su(2) + u(1)`, lepton/quark spinors, and familiar GUT subalgebras
such as `so(10)`, `su(5)`, and Pati-Salam.

**Near-term formal target.** Do not attempt the physics interpretation first.
Instead:
- define an explicit `e8(-24)` candidate decomposition used by the paper,
- record the dimensions of each summand,
- prove that the named subalgebra dimension counts match the intended
  `so(3,1)`, `su(3)`, `su(2)`, and `u(1)` pieces,
- cross-check the root and Cartan data against mathlib or SpherePacking.

**Why ambitious.** This is the most direct bridge between the repo's E8,
octonion, spinor, and Standard Model themes, but it must be guarded against
semantic overclaiming.

---

### Q5.5 — Furey's algebraic-roadmap intersections

Furey's 2025 algebraic-roadmap papers describe a network linking Spin(10),
Georgi-Glashow SU(5), Pati-Salam, left-right symmetric models, the Standard
Model, and the post-Higgs unbroken symmetries. Part III frames
`so(10) → su(3)_C ⊕ su(2)_L ⊕ u(1)_Y` as a three-way intersection and
`so(10) → su(3)_C ⊕ u(1)_Q` as a five-way intersection, explicitly comparing
this with `so(8) → g2` from triality.

**Formal target.** Model intersections of Lie subalgebras as finite-dimensional
linear subspaces first. Prove dimension and basis statements for the
intersection, then layer on bracket closure. This is an excellent place for
oracle fixtures: every claimed intersection should have a matrix-basis witness.

---

### Q5.6 — PhysLean/HEPLean bridge for anomaly cancellation and SM data

PhysLean/HEPLean has active Lean 4 formalizations of high-energy-physics
objects, including local anomaly cancellation examples. Rather than duplicating
that work, add a compatibility target:
- align this repo's `StandardModel` quantum-number records with PhysLean's
  conventions,
- prove an importable table equivalence for one generation,
- then reuse or port anomaly-cancellation statements with explicit convention
  documentation.

**Why useful.** This turns the division-algebra layer into a producer of
verified Standard Model representation data, rather than a parallel physics
library with drifting conventions.

---

## Summary table

| ID | Question | Difficulty | Proof sketch available? | Formalized elsewhere? |
|----|----------|-----------|------------------------|----------------------|
| 1.1 | Conjugation automorphism criterion | Medium/Hard | Forward theorem proved; converse open | Partial in repo |
| 1.2 | Three isotopic norm formulas | Easy | Yes (2-line proofs) | No |
| 1.3 | octonionDot is bilinear | Easy | Yes (ring) | No |
| 1.4 | ImOct is 7-dim subspace | Easy | Yes (simp) | No |
| 1.5 | Cross product norm formula | Easy | Yes (simp+ring) | No |
| 1.6 | D4 Cartan axioms | Trivial | Yes (decide) | No |
| 1.7 | Fano plane ≅ [7,4,3] Hamming code | Easy–Mod | Yes (decide + matrix def) | No |
| 2.1 | Hurwitz theorem | Hard | Structure theorem needed | No |
| 2.2 | dim(Der(𝕆)) = 14 | Moderate | Yes (rank computation) | No |
| 2.3 | G₂ Cartan matrix | Moderate | Yes (explicit matrix) | No |
| 2.4 | E₈ Cartan matrix | Moderate | Yes (explicit matrix) | No |
| 2.5 | H₃(𝕆) Jordan identity | Hard | Partial (ring after expand) | No |
| 2.6 | ConventionBridge correctness | Moderate | Yes (7 decide proofs) | No |
| 2.7 | Furey operator algebra on J | Moderate | Yes (finite table + commutators) | Partial (J action) |
| 2.8 | Charge cancellation J ⊕ J̄ | Easy | Yes (norm_num) | No |
| 2.9 | Q, T3, and hypercharge bridge | Moderate | Table strategy | Partial (SM data) |
| 2.10 | Construction A for binary codes | Moderate | Yes (mod-2 arithmetic + ZLattice) | No public Lean found |
| 2.11 | [8,4,4] Hamming code to E8 | Hard | Explicit finite code + Gram matrix route | Partial endpoints |
| 2.12 | Self-dual code building-up (Baek-Kim 2026) | Easy-Mod | Yes (import Baek-Kim library) | **Yes (arXiv:2604.08485)** |
| 2.13 | Weight enumerator as modular form | Moderate | Yes (arithmetic + theta series) | No |
| 3.1 | G₂ = Aut(𝕆) | Very Hard | Strategy only | No |
| 3.2 | Moufang loop axioms | Moderate | Yes (existing theorems) | No |
| 3.3 | D4 triality and representations | Very Hard | Partial (Cartan level) | No |
| 3.4 | E₈ root count = 240 | Hard | Strategy (explicit set) | Partial (lattice) |
| 3.5 | F₄ = Aut(H₃(𝕆)) | Very Hard | Strategy only | No |
| 3.6 | Uniqueness of even unimodular rank-16 lattices | Hard | Strategy (Niemeier) | No |
| 3.7 | Adinkra symbols as linear codes | Hard | Graph-to-code map | No |
| 4.1 | Baez 2025 triality–Moufang | Open | Forward theorem proved; companion route open | Partial in repo |
| 4.2 | Baez–Huerta SUSY theorem | Very Hard | None | No |
| 4.3 | Freudenthal magic square | Multi-year | None | No |
| 4.4 | Furey 2025 ℤ₂⁵ superalgebra | Research | None | No (paper 2025) |
| 4.5 | Trio of trialities and three generations | Research | Strategy only | No |
| 4.6 | Jordan characteristic equation | Hard | Partial (ring after Q2.5) | No |
| 4.7 | E8 x E8 from two Hamming codes | Very Hard | Construction A chain | Partial endpoints |
| 4.8 | Green-Schwarz anomaly factorization | Research | Physics-algebra strategy | No public Lean found |
| 4.9 | SM anomaly conditions as code constraints | Moderate/Research | Arithmetic yes; coding open | Partial in PhysLean |
| 4.10 | N=1 SVOA uniqueness for E8 level 2 | Open conjecture | None | No |
| 4.11 | F-theory 13 unproven lattice cases ↔ 18D sphere packing | Very Hard/Open | Lattice embedding search | No |
| 5.4 | Octions and E8 Standard Model model | Research | Strategy only | No |
| 5.5 | Algebraic-roadmap intersections | Research | Matrix oracle route | No |
| 5.6 | PhysLean/HEPLean bridge | Moderate | API comparison route | Partial externally |

---

## References

- [Baez (2002)](https://math.ucr.edu/home/baez/octonions/) — "The Octonions", Bull. Amer. Math. Soc. 39, 145–205
- [Baez nCat (Sep 2025)](https://golem.ph.utexas.edu/category/2025/09/a_shadow_of_triality.html) — "A Shadow of Triality?" (open question on triality–Moufang link)
- [Baez–Huerta (2010)](https://arxiv.org/abs/0909.0551) — "Division Algebras and Supersymmetry I"
- [Baez–Huerta (2010)](https://arxiv.org/abs/1003.3436) — "Division Algebras and Supersymmetry II"
- [Anastasiou et al. (2014)](https://arxiv.org/abs/1309.0546) — "Super Yang-Mills, division algebras and triality"
- [Furey (2015/2016)](https://arxiv.org/abs/1603.04078) — "Charge quantization from a number operator"
- [Furey (2016)](https://arxiv.org/abs/1611.09182) — PhD thesis: "Standard model physics from an algebra?"
- [Furey (2018)](https://arxiv.org/abs/1806.00612) — SU(3) × SU(2) × U(1) from ladder operators
- [Furey et al. (2019)](https://arxiv.org/abs/1910.08395) — Three generations, two unbroken gauge symmetries
- [Furey–Hughes (2024/2025)](https://arxiv.org/abs/2409.17948) — "Three Generations and a Trio of Trialities"
- [Furey (2025), Roadmap I](https://edoc.hu-berlin.de/items/117a7722-fd05-490a-9df0-088e9b26320a) — algebraic roadmap, general construction
- [Furey (2025), Roadmap II](https://edoc.hu-berlin.de/18452/33905) — theoretical checkpoints
- [Furey (2025), Roadmap III](https://edoc.hu-berlin.de/18452/33958) — intersection route to SM and post-Higgs symmetries
- [Furey (2025)](https://arxiv.org/abs/2505.07923) — "A Superalgebra Within", ℤ₂⁵-graded structure
- [Hamming (1950)](https://doi.org/10.1002/j.1538-7305.1950.tb00463.x) — "Error Detecting and Error Correcting Codes"
- [Leech (1967)](https://doi.org/10.4153/CJM-1967-017-0) — "Notes on Sphere Packings" (Construction A source)
- [MacWilliams–Sloane (1977)](https://doi.org/10.1016/C2013-0-10774-1) — "The Theory of Error-Correcting Codes"
- [Conway–Sloane (1999)](https://doi.org/10.1007/978-1-4757-6568-7) — "Sphere Packings, Lattices and Groups"
- [Error Correction Zoo: Construction A](https://errorcorrectionzoo.org/c/construction_a) — code-to-lattice construction overview
- [Error Correction Zoo: [7,4,3] Hamming](https://errorcorrectionzoo.org/c/hamming743) — classical Hamming code facts
- [Error Correction Zoo: [8,4,4] Hamming](https://errorcorrectionzoo.org/c/hamming844) — extended Hamming code facts
- [Error Correction Zoo: E8 Gosset lattice](https://errorcorrectionzoo.org/c/eeight) — E8 via the [8,4,4] code and Construction A
- [Mizoguchi–Oikawa (2026)](https://arxiv.org/abs/2602.16269) — "Error correcting codes and heterotic Narain CFTs"
- [Green–Schwarz (1984)](https://doi.org/10.1016/0370-2693(84)91565-X) — anomaly cancellation in 10D gauge theory and superstring theory
- [Narain (1986)](https://doi.org/10.1016/0370-2693(86)90682-9) — heterotic compactification and even self-dual lattices
- [Bilal (2008)](https://arxiv.org/abs/0802.0634) — lectures on anomalies and anomaly cancellation
- [Günaydin–Gürsey (1973)](https://doi.org/10.1063/1.1666240) — "Quark structure and octonions"
- [Günaydin–Gürsey (1974)](https://doi.org/10.1103/PhysRevD.9.3387) — "Quark statistics and octonions"
- [Barton–Sudbery (2003)](https://doi.org/10.1016/S0001-8708(03)00015-X) — "Magic squares and matrix models of Lie algebras"
- [Todorov–Drenska (2018)](https://arxiv.org/abs/1805.06739) — exceptional Jordan algebra and F4 in particle physics
- [Dubois-Violette–Todorov (2018)](https://arxiv.org/abs/1806.09450) — SM symmetry from automorphism and structure groups of the exceptional Jordan algebra
- [Boyle (2020)](https://arxiv.org/abs/2006.16265) — Standard Model, exceptional Jordan algebra, and triality
- [Manogue–Dray–Wilson (2022)](https://arxiv.org/abs/2204.05310) — "Octions: An E8 description of the Standard Model"
- [Tooby-Smith (2024)](https://arxiv.org/abs/2405.08863) — "HepLean: Digitalising high energy physics"
- [Geometric triality (2025)](https://www.mdpi.com/2073-8994/17/9/1414) — Geometric Realization of Triality via Octonionic Vector Fields
- [Adams (1996)](https://press.uchicago.edu/ucp/books/book/chicago/L/bo3630685.html) — "Lectures on Exceptional Lie Groups"
- [Springer–Veldkamp (2000)](https://link.springer.com/book/10.1007/978-3-662-12622-6) — "Octonions, Jordan Algebras and Exceptional Groups"
- [mathlib Hamming docs](https://leanprover-community.github.io/mathlib4_docs/Mathlib/InformationTheory/Hamming.html) — Lean Hamming distance and weight API
- [mathlib root-system docs](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/RootSystem/CartanMatrix.html) — Cartan matrix API
- [math-inc/Sphere-Packing-Lean](https://github.com/math-inc/Sphere-Packing-Lean) — E₈ lattice formalization (Apache-2.0)
- [Hariharan–Viazovska et al. (2026)](https://arxiv.org/abs/2604.23468) — "A Milestone in Formalization: The Sphere Packing Problem in Dimension 8", arXiv:2604.23468
- [Baek–Kim (2026)](https://arxiv.org/abs/2604.08485) — "Formalizing building-up constructions of self-dual codes through isotropic lines in Lean", arXiv:2604.08485 ← **direct prerequisite for Q2.12 / Q2.10**
- [Mizoguchi–Oikawa (2026)](https://arxiv.org/abs/2602.16269) — "Error correcting codes and heterotic Narain CFTs", arXiv:2602.16269; explicitly proves Hamming → E8 → heterotic string Narain lattice chain
- [Cheng–Harrison (2024)](https://arxiv.org/abs/2410.12488) — "Unifying error-correcting code/Narain CFT correspondences via lattices over integers of cyclotomic fields", arXiv:2410.12488
- [Error Correction Zoo: E8 entry](https://errorcorrectionzoo.org/c/eeight) — E₈ Gosset lattice code: Construction A from [8,4,4] Hamming
- [Error Correction Zoo: [8,4,4] entry](https://errorcorrectionzoo.org/c/hamming844) — Extended Hamming code
- [Gates et al. (2009)](https://arxiv.org/abs/0902.3007) — Adinkra symbols and supersymmetry representations as error-correcting codes
- [Conway–Sloane (1999)](https://link.springer.com/book/10.1007/978-1-4757-6568-7) — "Sphere Packings, Lattices and Groups", Ch. 7 (Construction A), Ch. 18 (rank-16 classification)
- [MacWilliams–Sloane (1977)](https://www.sciencedirect.com/book/9780444850102) — "The Theory of Error-Correcting Codes", foundational reference for Construction A and weight enumerators
- [Green–Schwarz (1984)](https://doi.org/10.1016/0370-2693(84)91565-X) — Original anomaly cancellation paper
- [Bilal (2008)](https://arxiv.org/abs/0802.0634) — Anomaly cancellation review, anomaly polynomial formulas
- [Tachikawa (2025)](https://member.ipmu.jp/yuji.tachikawa/lectures/2025-string-anomaly-cancellation/memo.pdf) — Lecture notes on anomaly cancellation in string theory
- [HEPLean/PhysLean](https://github.com/HEPLean/PhysLean) — Lean 4 physics formalization project
