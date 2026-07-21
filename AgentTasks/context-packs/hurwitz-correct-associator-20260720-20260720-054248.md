# Aristotle semantic context pack

Generated: 2026-07-20T05:42:56
Query: `alternative algebra associator identity xy z y x zy y corrected parenthesization Lean`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/triality-companions-conjugation-moonshot.md` [Critical Convention Warning]

Score: `0.829`

```text
## Critical Convention Warning

Octonions are not associative. Every theorem statement must keep all
parentheses explicit.

For this task, use the fixed convention:

```lean
def conjBy (a x : Octonion) : Octonion := (a * x) * conj a
```

Do not silently replace `(a * x) * conj a` with `a * (x * conj a)` unless you
have proved the specific reassociation lemma needed at that point.

Use `cube a := (a * a) * a` as the canonical parenthesization of `a^3`. If you
prove `a * (a * a) = (a * a) * a`, record it as a named lemma and then use it
only through that lemma.
```

### 2. `AgentTasks/g2-derivations-automorphisms-e8-moonshot.md` [Phase B — Associator antisymmetry (*oracle-verified, 100 random triples*)]

Score: `0.827`

```text
## Phase B — Associator antisymmetry (*oracle-verified, 100 random triples*)

File: `PhysicsSM/Algebra/Octonion/OctonionSymmetry.lean`

The associator `assoc a b c = (a * b) * c - a * (b * c)` is alternating (antisymmetric
in every pair of arguments). This is the algebraic fingerprint of alternativity.

**Proof strategy.** From `left_alternative` (a*(a*x) = (a*a)*x) linearized at a→a+b:
replace a by a+b, expand, subtract the two pure cases. The result is the crossed
term, giving the antisymmetry. Then `ring` after `simp` expansion.

```lean
/-- The octonion associator is antisymmetric in the first two arguments.
    Source: standard consequence of left alternativity (linearization).
    Oracle-verified over 100 random triples. -/
theorem assoc_antisymm_12 (a b c : Octonion) :
    (a * b) * c - a * (b * c) = -((b * a) * c - b * (a * c)) := by
  ext <;>
    simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
      Octonion.mul_c6, Octonion.mul_c7,
      Octonion.sub_c0, Octonion.sub_c1, Octonion.sub_c2,
      Octonion.sub_c3, Octonion.sub_c4, Octonion.sub_c5,
      Octonion.sub_c6, Octonion.sub_c7,
      Octonion.neg_c0, Octonion.neg_c1, Octonion.neg_c2,
      Octonion.neg_c3, Octonion.neg_c4, Octonion.neg_c5,
      Octonion.neg_c6, Octonion.neg_c7] <;>
    ring

/-- The octonion associator is antisymmetric in the last two arguments.
    Oracle-verified over 100 random triples. -/
theorem assoc_antisymm_23 (a b c : Octonion) :
    (a * b) * c - a * (b * c) = -((a * c) * b - a * (c * b)) := by
  ext <;>
    simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
      Octonion.mul_c6, Octonion.mul_c7,
      Octonion.sub_c0, Octonion.sub_c1, Octo
```

### 3. `AgentTasks/octonion-norm-moufang-moonshot.md` [C3. Derived consequence: the flexible identity]

Score: `0.822`

```text
### C3. Derived consequence: the flexible identity

```lean
/-- The flexible identity: x·(y·x) = (x·y)·x.
    Follows from the left and right Moufang identities (or directly by ring).
    This says the associator [x, y, x] = 0 for any x, y. -/
theorem flexible (x y : Octonion) : x * (y * x) = (x * y) * x := by
  ext <;>
  simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
             Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
             Octonion.mul_c6, Octonion.mul_c7] <;>
  ring
```

---
```

### 4. `PhysicsSM/Draft/Sedenions/CocycleQuadraticPhase.lean` [sedenion_not_associative]

Score: `0.819`

```text
theorem sedenion_not_associative :
    ¬ (∀ a b c : Fin 16, associatorVal a b c = 1) := by native_decide +revert

/-- The associator takes values in {-1, 1}. -/
```

### 5. `PhysicsSM/Algebra/Octonion/Alternativity.lean`

Score: `0.816`

```text
/-!
# Algebra.Octonion.Alternativity

Left and right alternative laws for octonions.

An algebra is alternative if:
- `left_alternative`  : (x * x) * y = x * (x * y)
- `right_alternative` : x * (y * y) = (x * y) * y

These are weaker than associativity and hold for all four normed division algebras.
The octonions are the largest alternative division algebra.

Note: The flexible law  x * (y * x) = (x * y) * x  follows from alternativity.

WARNING: Alternativity does NOT imply associativity. The associator
  [x, y, z] = (x * y) * z - x * (y * z)
is nonzero for generic octonions.

Source: Baez, "The Octonions", §1.
Convention: follows `PhysicsSM.Algebra.Octonion.Basic` multiplication convention.

Prerequisites:
- `PhysicsSM.Algebra.Octonion.Basic`

Status: stub — alternativity proofs to be added.
-/

namespace PhysicsSM.Algebra.Octonion

end PhysicsSM.Algebra.Octonion
```

### 6. `AgentTasks/codex-pub-channel-physical-cohomology-aristotle-2026-07-11.md` [Independent local attempt]

Score: `0.815`

```text
## Independent local attempt

The paper calculation was expanded independently.  No mathematical
counterexample appeared: the key derived identities are `Q(ip)=0`, `(ip)Q=0`,
`(ip)X(ip)=0`, and `(ip)XsQ=(ip)X`.  The local Lean attempt was rolled back to
the typechecking handoff statements after rectangular matrix products made
generic noncommutative-ring normalization inapplicable and explicit
`Matrix.mul_assoc` orientations became the proof-engineering bottleneck.  This
is an API/reassociation blocker, not evidence against the theorem.  Aristotle
should prefer small typed associativity lemmas over ring normalization.
```

### 7. `PhysicsSM/Draft/Sedenions/CocycleQuadraticPhase.lean` [associatorVal]

Score: `0.811`

```text
def associatorVal (a b c : Fin 16) : Int :=
  omega a b * omega (fin16Xor a b) c * omega b c * omega a (fin16Xor b c)

/-- The sedenion algebra is NOT associative. -/
```

### 8. `PhysicsSM/Lie/Exceptional/OctonionSymmetry.lean` [octonionCommutator_imaginary]

Score: `0.809`

```text
theorem octonionCommutator_imaginary {x y : Octonion}
    (hx : IsImaginary x) (hy : IsImaginary y) :
    IsImaginary (octonionCommutator x y) := by
  unfold IsImaginary at *
  unfold octonionCommutator
  simp [hx, hy]
  ring

/-! ## Associator -/

/--
The explicitly parenthesized octonion associator.

Because octonions are not associative, this definition is intentionally
parenthesized in the only way it should be read:

```text
[a, b, c] = (a * b) * c - a * (b * c)
```

Later G2 work should refer to this named definition rather than restating the
parenthesized expression by hand.
-/
```

## Scoped paper hits

### 1. The Octonions

Score: `0.699`
Zotero key: `WRIM6ZI7`
arXiv: `math/0105155`
URL: http://arxiv.org/abs/math/0105155

Abstract:

The octonions are the largest of the four normed division algebras. While somewhat neglected due to their nonassociativity, they stand at the crossroads of many interesting fields of mathematics. Here we describe them and their relation to Clifford algebras and spinors, Bott periodicity, projective and Lorentzian geometry, Jordan algebras, and the exceptional Lie groups. We also touch upon their applications in quantum logic, special relativity and supersymmetry.

### 2. Local d'Alembertian for causal sets

Score: `0.696`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 3. Some Identities for the Quantum Measure and its Generalizations

Score: `0.694`
Zotero key: `arxiv:gr-qc/9903015`
arXiv: `gr-qc/9903015`
DOI: `10.1142/S0217732302007041`
URL: http://arxiv.org/abs/gr-qc/9903015

Abstract:

Algebraic identities for Sorkin generalized measure theory and the hierarchy of sum rules, including the quantum grade-2 measure condition.

### 4. Tri-partitions and Bases of an Ordered Complex

Score: `0.693`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x

### 5. Octonion Internal Space Algebra for the Standard Model

Score: `0.693`
Zotero key: `EPT6PUTC`
arXiv: `2206.06912`
URL: https://arxiv.org/abs/2206.06912

Abstract:

Survey of internal-space algebra for the Standard Model using Clifford algebras with left multiplication by octonions. A distinguished complex structure implements the splitting O = C plus C^3 reflecting lepton-quark symmetry and relates to Pati-Salam and Spin(10) structures.
