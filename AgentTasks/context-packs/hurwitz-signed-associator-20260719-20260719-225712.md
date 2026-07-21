# Aristotle semantic context pack

Generated: 2026-07-19T22:57:21
Query: `alternative composition algebra associator signed Teichmueller Moufang identity Lean`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/octonion-norm-moufang-moonshot.md` [Part C — Moufang identities (`PhysicsSM/Algebra/Octonion/Moufang.lean`)]

Score: `0.855`

```text
## Part C — Moufang identities (`PhysicsSM/Algebra/Octonion/Moufang.lean`)
```

### 2. `EXECUTION_PLAN.md` [Milestone 1 — Octonion algebra]

Score: `0.849`

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

### 3. `Sources/Publishable_Results_Literature_Search.md` [Paper A: A Lean formalization of octonion arithmetic for mathematical physics]

Score: `0.834`

```text
### Paper A: A Lean formalization of octonion arithmetic for mathematical physics

Possible title:

```text
Formalizing the Octonions and Moufang Identities in Lean 4
```

Core claim:

The project gives a kernel-checked real octonion model in a documented XOR
Fano basis, including multiplication, conjugation, norm multiplicativity,
alternativity, flexibility, and all three Moufang identities.

Why this is publishable:

- The web search did not reveal an obvious public Lean 4 formalization of
  octonions with Moufang identities and norm multiplicativity.
- Nonassociativity makes this a good formalization case study: many generic
  algebra APIs are dangerous, and the paper can explain how explicit
  parenthesization and convention tracking prevent false proofs.
- The result is foundational for `G2`, `Spin(8)` triality, exceptional Jordan
  algebras, and Furey-style Standard Model constructions.

Current repo readiness:

- High. The trusted octonion core appears sorry-free in the relevant trusted
  modules.
- The `TrialityCompanions` theorem gives an additional research-flavored hook:
  a cube `= +/-1` condition for a conjugation-like map to preserve
  multiplication.

Remaining work before submission:

- Run a full clean `lake build` on CI or a non-Windows environment.
- Add a compact API overview and theorem list.
- Decide whether the paper is about just the octonion core or also includes
  the triality-companion foothold.
- Add a comparison section explaining why the XOR convention differs from
  Baez/Furey notation and how `ConventionBridge` controls translation.

Best venue fit:

- Formalization venues such as ITP, CPP, CICM, or Annals of Formalized
  Mathematics.
- A mathematical-physics venue is plausible if the paper includes the
  Standard Model motivation, but th
```

### 4. `AgentTasks/octonion-norm-moufang-moonshot.md` [Algebra.Octonion.Moufang]

Score: `0.828`

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

### 5. `AgentTasks/octonion-norm-moufang-moonshot.md` [Status]

Score: `0.828`

```text
## Status
Trusted. normSq defined; non-negativity, zero characterisation, conjugation
invariance, unity, and the KEY RESULT normSq_mul (composition algebra
property) all proved. Zero sorry.
```

**Moufang.lean**:
```
```

### 6. `AgentTasks/octonion-norm-moufang-moonshot.md` [C2. The three Moufang identities]

Score: `0.827`

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

### 7. `PhysicsSM/Algebra/Octonion/Moufang.lean`

Score: `0.826`

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

### 8. `EXECUTION_PLAN.md` [Milestone 1 — Octonion algebra]

Score: `0.821`

```text
ady
in `Basic.lean`. The current trusted proofs intentionally use component
expansion followed by real polynomial normalization. Introduce abstract
composition-algebra, normed-division-algebra, or Moufang-loop interfaces only
when a downstream theorem needs them.

**Deferred scope**: Hurwitz uniqueness/classification is not a Milestone 1 gate.
It belongs in a later division-algebra classification milestone after the
octonion norm and Cayley-Dickson bridge are stable.

**Classification boundary**: A failed sedenion composition law is evidence
about one Cayley-Dickson continuation, not a proof of Hurwitz's classification.
Do not claim that Lean has proved "only dimensions 1, 2, 4, and 8" until the
classification theorem itself is formalized with its hypotheses.

**Oracle backstop**: `Octonions.jl` and the Python validator for arithmetic checks.

**Risk**: Nonassociativity creates API friction with mathlib's algebra hierarchy.
Keep `Octonion` in its own namespace and do not attempt to fit it into `Algebra`
or `Ring` typeclasses prematurely.

---
```

## Scoped paper hits

### 1. The Octonions

Score: `0.734`
Zotero key: `WRIM6ZI7`
arXiv: `math/0105155`
URL: http://arxiv.org/abs/math/0105155

Abstract:

The octonions are the largest of the four normed division algebras. While somewhat neglected due to their nonassociativity, they stand at the crossroads of many interesting fields of mathematics. Here we describe them and their relation to Clifford algebras and spinors, Bott periodicity, projective and Lorentzian geometry, Jordan algebras, and the exceptional Lie groups. We also touch upon their applications in quantum logic, special relativity and supersymmetry.

### 2. Octonion Internal Space Algebra for the Standard Model

Score: `0.727`
Zotero key: `EPT6PUTC`
arXiv: `2206.06912`
URL: https://arxiv.org/abs/2206.06912

Abstract:

Survey of internal-space algebra for the Standard Model using Clifford algebras with left multiplication by octonions. A distinguished complex structure implements the splitting O = C plus C^3 reflecting lepton-quark symmetry and relates to Pati-Salam and Spin(10) structures.

### 3. Superconnections and the Chern character

Score: `0.725`
Zotero key: `WNATKBT5`
DOI: `10.1016/0040-9383(85)90047-3`
URL: https://doi.org/10.1016/0040-9383(85)90047-3

### 4. An analysis of completely-positive trace-preserving maps on M2

Score: `0.725`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 5. Some unitary representations of Thompson's groups F and T

Score: `0.719`
Zotero key: `K68ST6N4`
arXiv: `1412.7740`
URL: http://arxiv.org/abs/1412.7740

Abstract:

In a "naive" attempt to create algebraic quantum field theories on the circle, we obtain a family of unitary representations of Thompson's groups T and F for any subfactor. The Thompson group elements are the "local scale transformations" of the theory. In a simple case the coefficients of the representations are polynomial invariants of links. We show that all links arise and introduce new "oriented" subgroups $\overrightarrow F <F$ and $\overrightarrow T< T$ which allow us to produce all \emph{oriented} knots and links.
