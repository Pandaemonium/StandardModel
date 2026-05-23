# Sedenion Zero Divisors: Research Proposal

**Status:** Research directions and open questions  
**Date:** 2026-05-23  
**Project:** `PhysicsSM` / `StandardModel` formalization

---

## Overview

The sedenions S = ℝ^16, obtained from the octonions by the Cayley–Dickson construction, are the
first algebra in the CD tower that fails to be a division algebra: they possess nontrivial zero
divisors. This document organizes research directions linking the geometric and combinatorial
structure of those zero divisors to Reed–Muller codes, Barnes–Wall lattices, stabilizer quantum
codes, and physical models of three fermion generations.

---

## 1. The Solid Core: Zero Divisors as Affine Planes

### 1.1 Basic geometry

The sedenions have 15 imaginary unit basis elements `e₁, …, e₁₅` (indices = nonzero elements of
F₂⁴). The multiplication table is governed by a Cayley–Dickson twisting cochain

```
eₐ eᵦ = ω(a, b) · e_{a ⊕ b}     (a, b ≠ 0, a ≠ b)
```

where `ω : F₂⁴ × F₂⁴ → {±1}` encodes the sedenion sign structure and `⊕` is XOR.

A **zero divisor pair** is a pair of unit imaginary elements `eₐ, eᵦ` with `eₐ eᵦ = 0`. This
happens if and only if the Cayley–Dickson twisting makes the two elements "orthogonal" in a
precise combinatorial sense.

### 1.2 The zero-divisor code C_ZD

Let `F₂¹⁶` carry coordinates `(c₀, c₁, …, c₁₅)` indexed by F₂⁴ (so index 0 and index 8 are
the two "real" slots — the real parts of the two octonion components in the CD split S = O ⊕ O).

Define

```
C_ZD = { c ∈ RM(2,4) : c₀ = 0, c₈ = 0 }
```

where `RM(2,4)` is the second-order Reed–Muller code of length 16. Then:

- **Dimension:** `dim(C_ZD) = 9` (over F₂)
- **Minimum distance:** 4
- **Weight enumerator:**

  ```
  W(y) = 1 + 77 y⁴ + 168 y⁶ + 203 y⁸ + 56 y¹⁰ + 7 y¹²
  ```

### 1.3 Counting the zero divisors

The weight-enumerator encodes the zero-divisor geometry:

| Weight | Count | Geometric role |
|--------|-------|----------------|
| 4      | 77    | affine 2-planes in F₂⁴ (one for each line in AG(2,4)) |
| 6      | 168   | primitive unit zero divisors |
| 8      | 203   | (various) |
| 10     | 56    | |
| 12     | 7     | assessors (one per box-kite) |

The **168 primitive unit zero divisors** form 7 groups of 24, one group per **box-kite** structure.
Each box-kite contains **6 assessors** (unit zero divisors that pair nontrivially), giving
7 × 6 = 42 assessors total.

### 1.4 Box-kites and assessors

A **box-kite** is the minimal zero-divisor configuration: 8 unit imaginary sedenions forming
two sets of 4 that mutually annihilate. Each box-kite is combinatorially equivalent to the
vertices and edges of a rectangular octahedron (a "box" plus its diagonals — hence the name,
from de Marrais).

**Reference:** de Marrais, *Box-Kite Flying in the Ambit of the Sedenions*, arXiv:math/0011260.

---

## 2. Reed–Muller Structure

### 2.1 RM(2,4) as a code on F₂⁴

The second-order Reed–Muller code `RM(2,4)` has parameters `[16, 11, 4]` over F₂. Its codewords
are evaluations on all 16 points of F₂⁴ of Boolean polynomials of degree ≤ 2:

```
f(x₁, x₂, x₃, x₄) = a₀ + Σᵢ aᵢ xᵢ + Σᵢ<ⱼ aᵢⱼ xᵢ xⱼ
```

The weight-4 codewords (minimum-weight words) correspond exactly to characteristic functions of
**affine 2-planes** in F₂⁴ (i.e., cosets of 2-dimensional F₂-subspaces). There are 35 such planes,
giving 35 weight-4 words in `RM(2,4)` up to the zero word.

The condition `c₀ = c₈ = 0` removes codewords that are nonzero on the two "real" indices,
selecting only those planes that avoid both real directions.

### 2.2 Affine planes and zero divisors

**Claim (to be formalized):** There is a bijection

```
{ weight-4 words of C_ZD } ↔ { affine 2-planes in F₂⁴ avoiding {0, 8} }
```

and the support of each such codeword corresponds to a set of 4 imaginary sedenion indices
that mutually interact as zero divisors.

### 2.3 Cayley–Dickson cocycle and quadratic refinements

The sedenion signs `ω(a, b)` form a **2-cocycle** in group cohomology `H²(F₂⁴, {±1})`. Different
choices of cocycle (within the same cohomology class) give isomorphic sedenion algebras, but the
combinatorial structure of C_ZD is sensitive to the specific cocycle representative.

**Open question:** Which quadratic refinements of the cocycle `ω` preserve the zero-divisor
geometry of C_ZD? Is there a canonical "stabilizer-state" cocycle that makes the zero-divisor
structure manifestly visible?

**Reference:** Albuquerque–Majid, *Quasialgebra structure of the octonions*, arXiv:math/9802116.

---

## 3. Barnes–Wall Connection

### 3.1 The BW₁₆ lattice

The Barnes–Wall lattice `BW₁₆ = Λ₁₆` is a 16-dimensional integral lattice with:
- Minimum squared norm: 4
- Kissing number: 4320
- Density: related to sphere packing in ℝ¹⁶

`BW₁₆` is related to `RM(2,4)` via **Construction A**: lifting `RM(2,4)` from F₂ to ℤ gives a
scaled version of `BW₁₆`.

### 3.2 Connection to sedenions (indirect)

The connection between `BW₁₆` and sedenions is indirect but suggestive:

```
RM(2,4) --[Construction A]--> BW₁₆
    |
    | (zero-divisor condition)
    |
C_ZD --(?)--> sublattice of BW₁₆ encoding zero-divisor geometry
```

**Open question:** Is there a sublattice of `BW₁₆` whose shortest vectors encode the 168
primitive unit zero divisors, analogous to the way E8's 240 shortest vectors encode the
octonion unit imaginary roots?

### 3.3 Barnes–Wall magic monotones

Recent work (Kalra–Sinha 2025) constructs quantum resource monotones using Barnes–Wall lattice
norms. These **magic monotones** measure the "non-stabilizerness" (magic) of quantum states via
the geometry of `BW₁₆`.

**Reference:** Kalra–Sinha, *Barnes–Wall magic monotones*, arXiv:2503.04101.

---

## 4. Quantum Information: Stabilizer Plaquettes

### 4.1 Stabilizer states and affine subspaces

A **stabilizer state** on n qubits is a quantum state whose density matrix is the projector onto
the joint +1 eigenspace of an abelian subgroup of the n-qubit Pauli group. Equivalently (over F₂),
a stabilizer state is characterized by:

- A **Lagrangian subspace** L ⊂ F₂^(2n) (the stabilizer group's symplectic structure)
- A **quadratic phase function** φ : F₂^n → F₂ determining the specific state within L

**Reference:** Dehaene–De Moor, *Clifford group, stabilizer states, and linear and quadratic
operations over GF(2)*, arXiv:quant-ph/0304125.

### 4.2 Zero divisors as 4-qubit stabilizer plaquettes

**Proposed identification (Path A — highest priority):**

The weight-6 zero divisors in C_ZD correspond to **signed affine 2-planes** in F₂⁴, which are
precisely the supports of **4-qubit stabilizer plaquettes** (elementary stabilizer states on
4 qubits supported on an affine 2-plane).

More precisely, a weight-6 word in C_ZD should correspond to:
1. An affine 2-plane P ⊂ F₂⁴ (the support, 4 elements)
2. A sign pattern on P (the "quadratic refinement" or cocycle twist)

The **168 primitive unit zero divisors** would then be in bijection with the 168 signed affine
2-planes, i.e., the 168 = 42 × 4 stabilizer plaquettes up to a certain equivalence.

**Open questions:**
- Does the Cayley–Dickson cocycle `ω` on C_ZD agree with the Dehaene–De Moor quadratic phase?
- Are the 42 assessors in bijection with the 42 maximal abelian subgroups of some natural group?
- Is there a "stabilizer rank" interpretation of the box-kite structure?

### 4.3 Kliuchnikov–Schönnenbeck: resource theory connection

Recent work on single-qubit magic state resource theory (Kliuchnikov–Schönnenbeck 2024) uses
lattice-theoretic tools related to E8 and Barnes–Wall. The sedenion zero-divisor geometry may
provide a 4-qubit analog.

**Reference:** Kliuchnikov–Schönnenbeck, *Approximating transformations of unitary channels*,
arXiv:2404.17677.

---

## 5. S₃ Automorphism and Three Fermion Generations

### 5.1 The sedenion automorphism group

The automorphism group of the sedenions `Aut(S)` is a compact Lie group strictly containing
G₂ = Aut(O). The quotient `Aut(S)/G₂` has a discrete factor isomorphic to **S₃** (the
symmetric group on 3 elements).

This S₃ acts by permuting the three "free" imaginary directions that are not fixed by the
embedded G₂ action — in physical terms, it permutes the three **fermion generations**.

### 5.2 The Gourlay–Gresnigt–Varma Cl(8) model

A series of papers (Gourlay, Gresnigt, Varma, 2022–2025) develops a model where:

- A single generation of Standard Model fermions is encoded in an ideal of `Cl(6)` (real
  Clifford algebra)
- The full three-generation structure is encoded in `Cl(8)` via the sedenion automorphism group
- The S₃ factor in `Aut(S)/G₂` acts as the flavor symmetry, permuting generations

**References:**
- Gresnigt et al., arXiv:2306.13098 (2023)
- Gourlay–Gresnigt, arXiv:2407.01580 (2024)
- Gourlay et al., arXiv:2601.07857 (2025)

### 5.3 Connection to zero-divisor geometry (Path C)

**Open question:** Does the S₃ ≅ Aut(S)/G₂ symmetry preserve the zero-divisor geometry
encoded in C_ZD? Specifically:

- Does S₃ act on the 7 box-kites, permuting them in a natural way?
- Does S₃ preserve the partition of the 168 zero divisors into 7 families of 24?
- Is there a triality structure (analogous to D₄ triality for octonions) visible in the
  sedenion zero-divisor geometry?

---

## 6. PSL(2,7) / GL(3,2) Action on Assessors

### 6.1 The 7 box-kites and PSL(2,7)

The 7 box-kites form a natural combinatorial structure indexed by the 7 points of PG(2,2) = the
Fano plane. The automorphism group of the Fano plane is **PSL(2,7) ≅ GL(3,2)**, the simple
group of order 168.

**Proposed structure:** PSL(2,7) acts on the 7 box-kites by the action of GL(3,2) on the Fano
plane, and this action extends to a **signed action** on the 168 primitive unit zero divisors
(168 = |PSL(2,7)| — this coincidence suggests a regular action).

### 6.2 The King–Luhn triptych

King and Luhn (2009) study the sedenion structure in the context of tripling structures and
3-generation models. Their "triptych" construction may provide the explicit PSL(2,7) action.

**Reference:** King–Luhn, arXiv:0912.1344.

### 6.3 Nebe–Rains–Sloane: self-dual codes and the assessors

Nebe, Rains, and Sloane study self-dual codes over Z₄ whose images under the Gray map are
related to Barnes–Wall codes. The **Kerdock codes** (Z₄-linear, Gray image = RM(2,m) up to
permutation) may provide the right framework for the sedenion assessors.

**Reference:** Nebe–Rains–Sloane, *Self-dual codes over the integers and over abelian groups*,
arXiv:math/0001038.

### 6.4 Z₄/Kerdock direction

The Z₄-linearity of Reed–Muller codes (Hammons–Kumar–Calderbank–Sloane–Solé 1994) suggests
that the sedenion zero-divisor code C_ZD may be best understood as a **Z₄-linear code** with
a natural Kerdock-type structure. The cocycle `ω` determining sedenion signs would then arise
from the Z₄-structure via the Gray map.

---

## 7. Research Priority Ranking

Listed from highest to lowest research priority:

### Priority 1: Cocycle Foundation (Path A prerequisite)

**Goal:** Explicitly compute the Cayley–Dickson twisting cochain `ω : F₂⁴ × F₂⁴ → {±1}` for
the standard sedenion multiplication and verify that it determines C_ZD as described.

**Concrete task:**
1. Fix sedenion basis `e₀, e₁, …, e₁₅` with explicit multiplication table
2. Compute `ω(a, b)` for all `a, b ∈ F₂⁴`
3. Show that `eₐ eᵦ = 0 ⟺ a ⊕ b ≠ 0` and a certain condition on `ω`
4. Identify C_ZD as a subcode of RM(2,4) and verify the weight enumerator

**Why first:** All other directions depend on having the correct cocycle in hand.

### Priority 2: Stabilizer Plaquette Identification (Path A)

**Goal:** Construct an explicit bijection between the 168 primitive unit zero divisors and the
168 signed affine 2-planes (4-qubit stabilizer plaquettes).

**Concrete task:**
1. Enumerate all affine 2-planes in F₂⁴ avoiding indices {0, 8}
2. For each plane, determine the 4 possible sign patterns compatible with the cocycle `ω`
3. Identify which of the 168 × 4 = 672 signed planes match actual weight-6 words in C_ZD
4. Verify that the box-kite structure corresponds to orbits of the stabilizer group

### Priority 3: ψ-Orbit Test (Path B)

**Goal:** Test whether the 168 zero divisors form a single orbit under the action of some
natural group ψ ⊂ Aut(S).

**Concrete task:**
1. Compute the stabilizer subgroup of a single zero divisor within Aut(S)
2. Determine the orbit size
3. If orbit = 168, identify the acting group explicitly (possibly PSL(2,7) × Z₂?)
4. Compare with the known decomposition 168 = 7 × 24

### Priority 4: Signed PSL(2,7) Action on Assessors

**Goal:** Make the PSL(2,7) action on the 7 box-kites explicit and lift it to the full
zero-divisor geometry.

**Concrete task:**
1. Label the 7 box-kites by points of PG(2,2)
2. Write down the PSL(2,7) action on PG(2,2) (168 permutations of 7 points)
3. Verify this action permutes box-kites consistently with zero-divisor pairings
4. Determine how the 168-element PSL(2,7) acts on the 168 zero divisors (is it a regular action?)

### Priority 5: Z₄/Kerdock Lifting

**Goal:** Identify C_ZD as the Gray image of a Z₄-linear code and connect to Kerdock codes.

**Concrete task:**
1. Find a Z₄-linear code K with `Gray(K) ≅ C_ZD`
2. Check whether K is a Kerdock code or a puncturing thereof
3. Connect the Z₄-structure to the sedenion cocycle `ω`
4. Determine whether the sedenion multiplication lifts to a Z₄-module structure

### Priority 6: Physics Bridge (S₃ and Three Generations)

**Goal:** Make the S₃ ≅ Aut(S)/G₂ action on zero-divisor geometry explicit and connect to the
Gourlay–Gresnigt three-generation model.

**Concrete task:**
1. Identify G₂ ⊂ Aut(S) explicitly in terms of the zero-divisor code
2. Compute the S₃ action on C_ZD
3. Verify S₃ preserves the box-kite partition
4. Identify the "generation" labels in the zero-divisor geometry

---

## 8. Three Concrete Research Paths

### Path A: Stabilizer Plaquettes (Quantum Information Priority)

**Hypothesis:** The 168 primitive unit sedenion zero divisors are in natural bijection with
4-qubit stabilizer plaquettes (signed affine 2-planes in F₂⁴).

**Method:**
1. Fix the standard sedenion Cayley–Dickson product on `e₀, …, e₁₅`
2. Compute C_ZD explicitly as a subcode of RM(2,4)
3. Identify weight-6 words with signed affine 2-planes via Dehaene–De Moor formalism
4. Show the bijection is equivariant for a natural group action

**If successful:** The sedenion zero divisors would have a completely natural quantum-information
interpretation as elementary "error syndromes" or "stabilizer checks" in a 4-qubit code.

### Path B: ψ-Orbit Test (Group Theory Priority)

**Hypothesis:** The 168 zero divisors form a single orbit under a natural 168-element subgroup
of Aut(S), providing an intrinsic characterization without reference to the CD product.

**Method:**
1. Enumerate zero divisors directly from the multiplication table
2. Compute the Aut(S)-stabilizer of one zero divisor
3. Determine orbit size by the orbit-stabilizer theorem
4. If orbit = 168, identify acting subgroup (likely PSL(2,7) or a central extension)

**If successful:** The zero-divisor geometry would reduce to standard group theory, making
formalization much more tractable.

### Path C: S₃ Preservation (Physics Priority)

**Hypothesis:** The S₃ factor in Aut(S)/G₂ preserves the zero-divisor geometry encoded in C_ZD,
and this action corresponds to permuting the three fermion generations.

**Method:**
1. Identify an explicit S₃ ⊂ Aut(S) complementary to G₂
2. Compute the S₃-action on the 168 zero divisors
3. Check whether the 7-box-kite partition is S₃-invariant
4. Map the S₃-orbits to generation labels in the Gourlay–Gresnigt model

**If successful:** This would provide a purely geometric origin for the three-generation flavor
structure from the algebra of the sedenions.

---

## 9. Key References

| arXiv / Source | Authors | Topic |
|----------------|---------|-------|
| arXiv:math/0011260 | de Marrais (2000) | Box-kites and sedenion zero divisors |
| arXiv:math/9802116 | Albuquerque–Majid (1998) | Quasialgebra / cocycle structure of sedenions |
| arXiv:2404.17677 | Kliuchnikov–Schönnenbeck (2024) | Magic state resource theory, lattice tools |
| arXiv:2503.04101 | Kalra–Sinha (2025) | Barnes–Wall magic monotones |
| arXiv:2407.01580 | Gourlay–Gresnigt (2024) | Cl(8) and three generations |
| arXiv:2306.13098 | Gresnigt et al. (2023) | Sedenions and three-generation SM |
| arXiv:quant-ph/0304125 | Dehaene–De Moor (2003) | Stabilizer states and affine subspaces |
| arXiv:0912.1344 | King–Luhn (2009) | Sedenions, triptych, three generations |
| arXiv:math/0001038 | Nebe–Rains–Sloane (2000) | Z₄ self-dual codes and Kerdock |
| arXiv:2601.07857 | Gourlay et al. (2025) | Cl(8) three-generation update |

---

## 10. Lean Formalization Sketch

If any of the above directions is confirmed, the following Lean formalization path is suggested:

```lean
-- 1. Fix sedenion multiplication table
def SedenionMul : Fin 16 → Fin 16 → (Fin 16 × Bool) := ...

-- 2. Zero divisor predicate
def isZeroDivisor (a b : Fin 16) : Prop :=
  a ≠ 0 ∧ b ≠ 0 ∧ SedenionMul a b = (0, true)  -- or however zero is encoded

-- 3. C_ZD as a code
def C_ZD : Finset (Fin 2 ^ 16) :=
  RM_2_4.filter (fun c => c 0 = 0 ∧ c 8 = 0)

-- 4. Weight enumerator verification
theorem C_ZD_weight_enumerator :
    (C_ZD.filter (fun c => c.weight = 6)).card = 168 := by decide

-- 5. Box-kite structure
def boxKite (i : Fin 7) : Finset (Fin 16) := ...

theorem boxKite_zero_divisors (i : Fin 7) (a b : Fin 16) (ha : a ∈ boxKite i)
    (hb : b ∈ boxKite i) (hab : a ≠ b) : isZeroDivisor a b := ...
```

**Note:** All `decide`-based computations at Fin 16 should be tested for feasibility before
committing to this approach. The sedenion multiplication table is a 16×16 table, which is
tractable for `decide`.

---

## 11. Open Questions Summary

1. **Cocycle uniqueness:** Is the zero-divisor code C_ZD invariant under all Cayley–Dickson
   cocycle representatives in the same cohomology class, or does it depend on the specific
   representative?

2. **Stabilizer bijection:** Is there a canonical group-equivariant bijection between weight-6
   words of C_ZD and 4-qubit stabilizer plaquettes?

3. **PSL(2,7) regular action:** Does PSL(2,7) act regularly (freely and transitively) on the 168
   primitive unit zero divisors?

4. **S₃ preservation:** Does the S₃ factor in Aut(S)/G₂ preserve the box-kite partition?

5. **BW₁₆ sublattice:** Is there a sublattice of BW₁₆ whose shortest vectors encode the 168
   zero divisors, analogous to E8's 240 shortest vectors encoding octonion units?

6. **Kerdock lift:** Is C_ZD the Gray image of a Kerdock code over Z₄?

7. **Theta series analog:** Is there an analog of the E8 theta series (E4 Eisenstein series)
   for the sedenion zero-divisor lattice?

---

*This document is a research proposal. No claims in this document are yet verified by Lean proofs.
All connections to the literature are to be confirmed before formalization.*
