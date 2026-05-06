# Hamming Code Proof Target Roadmap

Reviewed on: 2026-04-30

Source documents:
- `Sources/String_Theory_Codes_and_Formalization.md`
- `Sources/String Theory, Codes, and Formalization.docx`

## Review summary

The document contains a useful research ladder:

```text
Fano plane / [7,4,3] Hamming code
  -> extended [8,4,4] Hamming code
  -> Construction A
  -> E8 lattice
  -> E8 x E8 and D16+ heterotic gauge lattices
  -> Green-Schwarz anomaly cancellation and string-theoretic interpretation
```

The first four steps are good Lean targets. They are finite, algebraic, and
can be stated without importing physical assumptions. The later anomaly and
heterotic-string statements should be treated as provenance and long-horizon
motivation until the code-to-lattice infrastructure is trusted.

The Markdown export has many formulas replaced by embedded image references,
and the `.docx` version appears to contain the same prose with formula images.
For Lean work, do not copy formulas from the image placeholders. Reconstruct
the precise statements from standard coding-theory and lattice definitions,
then record the source and convention choices in docstrings.

## Corrections and guardrails

1. The Fano lines are the weight-3 codewords of the length-7 Hamming code.
   Their complements are the weight-4 codewords of the same length-7 code.
   After adding an overall parity bit, the extended [8,4,4] Hamming code has
   fourteen weight-4 words, plus the zero word and the all-ones word.

2. The slogan "Hamming codes explain anomaly cancellation" should not become a
   theorem statement. The rigorous near-term theorem is instead:
   Construction A sends the extended [8,4,4] Hamming code to an E8 lattice.
   The physics interpretation can cite the heterotic gauge-lattice story after
   that bridge exists.

3. Claims such as "code-anomaly duality", "holographic tensor networks become
   Construction A lattices", and universal derivations of the Standard Model
   from coding theory are speculative. They belong in `OPEN_QUESTIONS.md` or
   source notes, not in trusted Lean theorem names.

4. Avoid real square roots in the first Construction A pass. Define the integer
   pre-lattice first:

   ```lean
   {z : Fin n -> Int | (fun i => (z i : ZMod 2)) in C}
   ```

   Prove closure, parity, and norm-divisibility facts there. Introduce the
   conventional `1 / sqrt 2` scaling only after the algebraic core is stable.

## Existing Lean footholds

- Mathlib has `Mathlib.InformationTheory.Hamming`, including `hammingDist`,
  `hammingNorm`, and the `Hamming` metric type synonym.
- This repo already has the Fano/XOR skeleton in
  `PhysicsSM/Algebra/Octonion/Basic.lean`:
  - `fanoTriple_xor_closure`
  - `fano_lines_are_hamming_parity_rows`
  - `fano_covers_all_ordered_pairs`
- This repo already has concrete E8 Cartan data in
  `PhysicsSM/Lie/Exceptional/E8.lean`, including determinant one for the
  chosen Cartan matrix.
- Local search did not find a project Lean definition of `LinearCode`,
  `ConstructionA`, `hamming743`, or `extendedHamming844`.

## Proposed Lean module layout

Keep the code theory layer separate from octonions and physics:

```text
PhysicsSM/
  Algebra/
    Coding/
      Basic.lean          -- binary vectors, weights, code wrappers, duals
      Hamming743.lean     -- parity-check matrix and Fano-line bridge
      Hamming844.lean     -- extended Hamming code and Type II properties
      ConstructionA.lean  -- code-to-integer-lattice construction
  Lie/
    Exceptional/
      E8ConstructionA.lean -- Hamming844 -> E8 comparison targets
```

The first Aristotle jobs should use draft files or tightly scoped files under
`PhysicsSM/Algebra/Coding/`. Do not move statements into a trusted E8 module
until all definitions and convention choices are reviewed.

## Target ladder

### Target 0: binary vector and code foundation

Purpose: create the minimum local coding API without waiting for all of
coding theory to exist in mathlib.

Suggested declarations:

```lean
abbrev BinaryVector (n : Nat) := Fin n -> ZMod 2

def BinaryLinearCode (n : Nat) :=
  Submodule (ZMod 2) (BinaryVector n)

def BinaryVector.weight {n : Nat} (v : BinaryVector n) : Nat :=
  hammingNorm v

def BinaryLinearCode.minDistance {n : Nat} (C : BinaryLinearCode n) : Nat :=
  -- initially define as a finite minimum over nonzero codewords
  sorry
```

Proof targets:
- `weight_zero`
- `weight_le_length`
- `hammingDist_eq_weight_sub`
- membership lemmas for submodules over `ZMod 2`

Recommended style: descriptive names and comments explaining that this is a
small local wrapper over `Submodule`, not a competing full coding-theory API.

### Target 1: [7,4,3] Hamming code and Fano lines

Purpose: turn the existing Fano/XOR skeleton into an actual binary code.

Suggested declarations:

```lean
def hamming743ParityCheck : Matrix (Fin 3) (Fin 7) (ZMod 2) := ...

def hamming743 : BinaryLinearCode 7 :=
  -- kernel of the parity-check matrix
  ...

def supportFinset {n : Nat} (v : BinaryVector n) : Finset (Fin n) := ...
```

Proof targets:
- `hamming743_is_kernel_parity_check`
- `hamming743_card = 16`
- `hamming743_weight_zero_or_ge_three`
- `hamming743_minDistance_eq_three`
- `hamming743_weight_three_support_iff_fano_line`

Aristotle prompt shape:

```text
Prove that, for the parity-check matrix whose columns are the seven nonzero
vectors of F2^3 in the same order as the project XOR labels, a vector of
weight 3 lies in the kernel exactly when its support is one of the seven Fano
lines already listed in `fanoTriples`.
```

Expected proof method: finite enumeration with `fin_cases`, `decide`, and
small support lemmas. This is the best first job because it connects directly
to existing trusted octonion convention data.

### Target 2: extended [8,4,4] Hamming code

Purpose: define the actual code used for the E8 Construction A theorem.

Suggested declarations:

```lean
def addOverallParityBit (v : BinaryVector 7) : BinaryVector 8 := ...

def extendedHamming844 : BinaryLinearCode 8 := ...
```

Proof targets:
- `extendedHamming844_card = 16`
- `extendedHamming844_minDistance_eq_four`
- `extendedHamming844_weight_set_subset`
- `extendedHamming844_doublyEven`
- `extendedHamming844_selfOrthogonal`
- `extendedHamming844_selfDual`

Implementation note: first prove all weight/cardinality facts by explicit
finite enumeration. General coding-theory lemmas can come later, after the
E8 bridge is visible.

### Target 3: Construction A over binary codes

Purpose: build the missing code-to-lattice bridge.

Suggested declarations:

```lean
def reduceIntVectorModTwo {n : Nat} (z : Fin n -> Int) : BinaryVector n :=
  fun i => (z i : ZMod 2)

def constructionASet {n : Nat} (C : BinaryLinearCode n) : Set (Fin n -> Int) :=
  {z | reduceIntVectorModTwo z in C}

def constructionAAddSubgroup {n : Nat} (C : BinaryLinearCode n) :
    AddSubgroup (Fin n -> Int) := ...
```

Proof targets:
- `zero_mem_constructionA`
- `add_mem_constructionA`
- `neg_mem_constructionA`
- `constructionA_reduce_mem`
- `constructionA_even_norm_of_doublyEven`
- `constructionA_integral_inner_of_selfOrthogonal`

Important design choice: keep this as an integer lattice first. Later modules
can map it into `EuclideanSpace Real (Fin n)` and add the conventional scaling.

### Target 4: Hamming844 gives E8

Purpose: prove the central mathematical bridge from the document.

Two viable proof routes:

1. Explicit basis route:
   construct eight integer vectors in `constructionA extendedHamming844`, prove
   their Gram matrix is the concrete E8 Cartan/Gram matrix, then prove they span
   the Construction A lattice.

2. Root enumeration route:
   define the 240 norm-two vectors of the scaled Construction A lattice and
   prove they have the E8 root-system incidence data.

Suggested first theorem:

```lean
theorem constructionA_extendedHamming844_has_e8_gram :
    -- after choosing an explicit basis, its Gram matrix equals the local E8
    -- matrix convention
    ...
```

Do not begin with a global `IsometricLattice` theorem unless the lattice API is
already ready. The explicit Gram-matrix statement is easier for Aristotle and
easier to review.

### Target 5: rank-16 heterotic lattice targets

Purpose: prepare the string-theory bridge without overclaiming physics.

Proof targets:
- `constructionA_directSum_code`
- `constructionA_two_hamming844_is_E8_sum_E8`
- a separate target for the code/lattice producing `D16+`
- rank-16 even unimodular lattice classification, only after a robust lattice
  API exists

Keep these in a lattice module, not in an anomaly module.

### Target 6: physics interpretation layer

Purpose: connect the formal lattice facts to the document's physics claims
as documented mathematical provenance.

Near-term documentation targets:
- Explain that heterotic modular invariance uses even unimodular rank-16
  lattices.
- Record that the two classical rank-16 cases are `E8 x E8` and `D16+`.
- State that Green-Schwarz anomaly cancellation is a separate differential
  geometry/anomaly-polynomial formalization problem.

Lean theorem targets should wait until the project has:
- characteristic classes,
- invariant polynomials,
- Chern-Weil forms,
- anomaly polynomials,
- a precise convention for traces in `so(32)` and `e8`.

## First recommended Aristotle jobs

### Job A: Fano support equals Hamming743 weight-three support

Input file should contain only:
- imports for `ZMod`, matrices, finsets, and `Mathlib.InformationTheory.Hamming`;
- the binary vector abbreviation;
- the parity-check matrix;
- a local copy or import of the `fanoTriples` data;
- one theorem about weight-three supports.

Expected output: a finite proof, preferably by `decide` or structured
`fin_cases`, with comments explaining the column order.

### Job B: extended Hamming844 has weights 0, 4, and 8

Input file should define `extendedHamming844` by parity extension from
`hamming743`.

Expected output:
- cardinality 16;
- no nonzero word has weight below 4;
- every codeword has weight divisible by 4.

### Job C: Construction A closure

Input file should avoid E8. It should only ask for the integer pre-lattice
`constructionAAddSubgroup` and its closure lemmas.

Expected output: clean reusable algebraic infrastructure.

## Recommended immediate repo update

Create `PhysicsSM/Algebra/Coding/Basic.lean` and add only Target 0. Then create
`PhysicsSM/Algebra/Coding/Hamming743.lean` with the parity-check matrix and the
first Fano bridge theorem. This gives lower-end agents a small, finite, highly
commented problem before any E8 or physics layer appears.

Do not edit the source document to "correct" its formulas yet. Treat it as a
research note, and use this roadmap plus `OPEN_QUESTIONS.md` as the actionable
formalization plan.
