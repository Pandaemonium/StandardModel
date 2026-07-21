# Aristotle semantic context pack

Generated: 2026-07-20T05:42:47
Query: `alternative algebra standard right Moufang identity correct parenthesization composition algebra Lean`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/octonion-norm-moufang-moonshot.md` [Part C — Moufang identities (`PhysicsSM/Algebra/Octonion/Moufang.lean`)]

Score: `0.885`

```text
## Part C — Moufang identities (`PhysicsSM/Algebra/Octonion/Moufang.lean`)
```

### 2. `AgentTasks/octonion-norm-moufang-moonshot.md` [C2. The three Moufang identities]

Score: `0.865`

```text
### C2. The three Moufang identities

Each proof is: `ext <;> simp only [mul_c0...mul_c7] <;> ring`.
The `ring` tactic handles degree-6 polynomial identities in 24 real variables.
These may take 60–180 seconds each.  Do NOT attempt to simplify or split —
ring will find the proof.

```lean
import PhysicsSM.Algebra.Octonion.Basic
open PhysicsSM.Algebra.Octonion

/-- Left Moufang identity: (x·y)·(z·x) = x·((y·z)·x).
    Parenthesization is essential: (x·y)·(z·x) ≠ x·(y·z·x) in general.
    Proof: component expansion + ring tactic on the 8 degree-6 polynomial
    equalities in 24 variables (x.c0,...,z.c7). -/
theorem moufang_left (x y z : Octonion) :
    (x * y) * (z * x) = x * ((y * z) * x) := by
  ext <;>
  simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
             Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
             Octonion.mul_c6, Octonion.mul_c7] <;>
  ring

/-- Right Moufang identity: (x·(y·x))·z = x·(y·(x·z)).
    Note: (x·(y·x)) is the flexible product of x and y via x. -/
theorem moufang_right (x y z : Octonion) :
    (x * (y * x)) * z = x * (y * (x * z)) := by
  ext <;>
  simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
             Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
             Octonion.mul_c6, Octonion.mul_c7] <;>
  ring

/-- Middle Moufang identity: x·(y·(x·z)) = ((x·y)·x)·z. -/
theorem moufang_middle (x y z : Octonion) :
    x * (y * (x * z)) = ((x * y) * x) * z := by
  ext <;>
  simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
             Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
             Octonion.mul_c6, Octonion.mul_c7] <;>
  ring
```
```

### 3. `PhysicsSM/Algebra/Octonion/Moufang.lean` [moufang_left]

Score: `0.861`

```text
theorem moufang_left (x y z : Octonion) :
    (x * y) * (z * x) = x * ((y * z) * x) := by
  ext <;>
    simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
      Octonion.mul_c7] <;>
    ring

/--
Right Moufang identity.

The `x` occurs twice in the characteristic Moufang pattern. The explicit
parentheses are part of the mathematical content and should not be changed
without rechecking the convention.
-/
```

### 4. `PhysicsSM/Algebra/Octonion/Moufang.lean`

Score: `0.860`

```text
namespace PhysicsSM.Algebra.Octonion

/--
Left Moufang identity.

Because the octonion product is nonassociative, this statement is not a
rewriting convenience: it records a genuine identity with fixed parentheses.
The proof expands both sides to their eight real coordinates using the
project's multiplication table, then asks `ring` to verify each coordinate
polynomial.
-/
```

### 5. `AgentTasks/octonion-norm-moufang-moonshot.md` [Algebra.Octonion.Moufang]

Score: `0.858`

```text
# Algebra.Octonion.Moufang

The three Moufang identities for octonions.

Octonions are non-associative but satisfy the three Moufang identities, which
are consequences of alternativity.  These identities characterize Moufang
loops (the multiplicative structure of octonions) and are used in the proofs
of the G₂ = Aut(𝕆) theorem and the E₈ root system properties.

The identities are:
  (1) moufang_left  :  (x·y)·(z·x) = x·((y·z)·x)
  (2) moufang_right :  (x·(y·x))·z = x·(y·(x·z))
  (3) moufang_middle:  x·(y·(x·z)) = ((x·y)·x)·z

All three hold for ALL octonions x, y, z (not just invertible ones).

Note: **all parenthesizations are essential**.  The identities are false if
parentheses are moved.  The proofs are purely combinatorial expansions using
the explicit XOR multiplication table; no abstract algebra is needed.

Source: Baez, The Octonions, Section 1.3.
         Springer–Veldkamp, Octonions, Jordan Algebras, §1.4.
Convention: XOR basis. Non-associativity is fully in scope.
Prerequisites: `PhysicsSM.Algebra.Octonion.Basic` (mul_c simp lemmas)
-/
```
```

### 6. `EXECUTION_PLAN.md` [Milestone 1 — Octonion algebra]

Score: `0.858`

```text
### Milestone 1 — Octonion algebra
**Goal**: The `Octonion` type with all core identities proved. No `sorry` in
trusted files at completion.

**Lean targets** (`PhysicsSM/Algebra/Octonion/`):

| File | Content | Key theorems |
|------|---------|-------------|
| `Basic.lean` | `Octonion` structure, basis, multiplication | `fanoTriples`, `mul_def` |
| `Conjugation.lean` | `conj` involution | `conj_conj`, `conj_mul`, `mul_conj` |
| `Norm.lean` | `normSq` | `normSq_nonneg`, `normSq_eq_zero`, `normSq_mul` |
| `Alternativity.lean` | Alternative laws | `left_alternative`, `right_alternative` |
| `Moufang.lean` | Moufang identities | `moufang_left`, `moufang_right`, `moufang_middle` |
| `TrialityCompanions.lean` | Conjugation criterion foothold | `conjBy_mul_of_unit_cube_eq_one`, `conjBy_iter_three_of_unit_cube_eq_one` |

**Status**: Complete at the trusted coordinate-arithmetic layer. Aristotle
results now integrated:
- Basic arithmetic core: explicit multiplication, pointwise additive/scalar
  operations, left and right alternativity, and anticommutation of distinct
  imaginary basis elements.
- Job `fe5f83fd-885e-4f87-936f-9a8a4746ee7c`: conjugation, squared norm,
  norm multiplicativity, all three Moufang identities, and flexibility.
- Job `d76adda3-911d-43d2-ac78-6d122fcda89c`: `cube`, `conjBy`, unit
  cancellation through conjugates, the `cube = +/-1` forward automorphism
  theorems, and the corresponding order-three iteration theorems. Companion
  identities and the converse criterion remain open.

**Strategy**: Continue from the explicit eight-coordinate representation already
in `Basic.lean`. The current trusted proofs intentionally use component
expansion followed by real polynomial normalization. Introduce abstract
composition-algebra, normed-division-algebra, or Mou
```

### 7. `AgentTasks/octonion-norm-moufang-moonshot.md` [Status]

Score: `0.854`

```text
## Status
Trusted. normSq defined; non-negativity, zero characterisation, conjugation
invariance, unity, and the KEY RESULT normSq_mul (composition algebra
property) all proved. Zero sorry.
```

**Moufang.lean**:
```
```

### 8. `PhysicsSM/Algebra/Octonion/Moufang.lean`

Score: `0.848`

```text
import PhysicsSM.Algebra.Octonion.Basic

/-!
# Algebra.Octonion.Moufang

The Moufang identities for the project octonion model.

Octonions are not associative, but they satisfy the three Moufang identities.
These identities are a central replacement for associativity in octonionic
algebra and are used throughout the theory of Moufang loops, composition
algebras, and exceptional structures.

The formal statements keep every parenthesis explicit:

- `moufang_left`: `(x * y) * (z * x) = x * ((y * z) * x)`.
- `moufang_right`: `(x * (y * x)) * z = x * (y * (x * z))`.
- `moufang_middle`: `x * (y * (x * z)) = ((x * y) * x) * z`.
- `flexible`: `x * (y * x) = (x * y) * x`.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), Section 1;
Springer and Veldkamp, "Octonions, Jordan Algebras and Exceptional Groups",
Section 1.4.
Convention: XOR basis and Fano orientation from
`PhysicsSM.Algebra.Octonion.Basic`.
Provenance: Aristotle job `fe5f83fd-885e-4f87-936f-9a8a4746ee7c`,
adapted to this repository's `PhysicsSM` module paths and comments.

Status: trusted. The file contains no `s o r r y`; each identity is checked by
coordinate expansion and real polynomial normalization.
-/
```

## Scoped paper hits

### 1. Octonion Internal Space Algebra for the Standard Model

Score: `0.735`
Zotero key: `EPT6PUTC`
arXiv: `2206.06912`
URL: https://arxiv.org/abs/2206.06912

Abstract:

Survey of internal-space algebra for the Standard Model using Clifford algebras with left multiplication by octonions. A distinguished complex structure implements the splitting O = C plus C^3 reflecting lepton-quark symmetry and relates to Pati-Salam and Spin(10) structures.

### 2. An analysis of completely-positive trace-preserving maps on M2

Score: `0.720`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 3. Some Identities for the Quantum Measure and its Generalizations

Score: `0.718`
Zotero key: `arxiv:gr-qc/9903015`
arXiv: `gr-qc/9903015`
DOI: `10.1142/S0217732302007041`
URL: http://arxiv.org/abs/gr-qc/9903015

Abstract:

Algebraic identities for Sorkin generalized measure theory and the hierarchy of sum rules, including the quantum grade-2 measure condition.

### 4. Tri-partitions and Bases of an Ordered Complex

Score: `0.718`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x

### 5. The Standard Model, The Exceptional Jordan Algebra, and Triality

Score: `0.715`
Zotero key: `3ABEUB3K`
arXiv: `2006.16265`
DOI: `10.48550/arXiv.2006.16265`
URL: http://arxiv.org/abs/2006.16265v2

Abstract:

Relates the complexified exceptional Jordan algebra to the Standard Model, left-right extension, Spin(10), and a geometric interpretation in which three generations are related to SO(8) triality.
