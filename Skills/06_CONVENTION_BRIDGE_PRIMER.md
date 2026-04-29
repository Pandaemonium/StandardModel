# Level 6: ConventionBridge Primer

**Purpose.** This tutorial teaches why source conventions cannot be copied
directly into the PhysicsSM octonion code. It explains the role of
`ConventionBridge`, how to read source formulas safely, and which tasks are
appropriate for low-end agents.

**Prerequisites.** Read these first:

- `Skills/00_REPOSITORY_SURVIVAL.md`
- `Skills/04_MATH_LANGUAGE_PRIMER.md`
- `Skills/05_OCTONION_PRIMER.md`

**Key vocabulary.** convention, basis label, source basis, project basis,
permutation, sign correction, Fano orientation, provenance, translation,
oracle validation, semantic alignment.

**Safety rule.** Never copy a Baez or Furey formula involving named octonion
basis elements into trusted Lean code without passing through
`PhysicsSM.Algebra.Octonion.ConventionBridge`.

---

## 1. Why Conventions Matter

Many papers use octonions, but they do not all label the basis elements the
same way.

A formula such as:

```text
e5 * e7 = e2
```

is meaningless in this project until you know:

- which source convention is being used,
- which basis element the source calls `e5`,
- which project basis element it maps to,
- whether a sign correction is needed,
- whether the product order and parentheses are preserved.

The same written formula can be true in one convention and false in another.

## 2. Project Convention Is Authoritative

The project convention is the XOR basis from:

```text
PhysicsSM/Algebra/Octonion/Basic.lean
```

Project basis labels:

```text
e000, e001, e010, e011, e100, e101, e110, e111
```

The product index uses bitwise XOR. The product sign comes from the project
Fano orientation.

Trusted Lean theorems should be stated in this project convention unless a file
explicitly says it is working in another convention.

## 3. What ConventionBridge Does

Read:

```text
PhysicsSM/Algebra/Octonion/ConventionBridge.lean
```

This file records the translation between the Baez/Furey basis convention and
the project XOR convention.

Important declarations:

```text
baezToXORIndex
baezToXORSign
baezBasisInXOR
```

Plain English:

- `baezToXORIndex` says which project basis label a Baez basis label maps to.
- `baezToXORSign` says whether that basis element gets a sign flip.
- `baezBasisInXOR` combines the index map and the sign correction.

## 4. The Current Baez To XOR Map

The current convention bridge uses this map:

| Baez label | Project XOR label | Sign |
|------------|-------------------|------|
| `e1` | `e001` | +1 |
| `e2` | `e010` | +1 |
| `e3` | `e110` | +1 |
| `e4` | `e011` | +1 |
| `e5` | `e100` | -1 |
| `e6` | `e101` | +1 |
| `e7` | `e111` | +1 |

The only sign flip in this chosen map is:

```text
Baez e5 maps to negative project e100.
```

Low-end agents may report this map. They must not change it.

## 5. Why One Sign Flip Matters

Suppose a source formula contains:

```text
-e5
```

Since Baez `e5` maps to negative project `e100`, the translated expression has
two minus signs:

```text
-e5 in Baez convention maps to +e100 in project convention.
```

This is exactly why the project ladder operator `alpha1` has a positive
`e100` real part after translation.

If you miss this sign, many later anticommutation relations will be wrong.

## 6. Furey Ladder Operator Example

Furey gives ladder operators in Baez convention. In plain ASCII notation:

```text
alpha1 = (-e5 + i e4) / 2
alpha2 = (-e3 + i e1) / 2
alpha3 = (-e6 + i e2) / 2
```

After applying the convention bridge, the project uses:

```text
alpha1 = (+e100 + i e011) / 2
alpha2 = (-e110 + i e001) / 2
alpha3 = (-e101 + i e010) / 2
```

The `alpha1` sign change is the visible effect of the Baez `e5` sign flip.

The Lean definitions live in:

```text
PhysicsSM/Algebra/Furey/LadderOperators.lean
```

## 7. Source Formula Checklist

Before translating any source formula, fill out this checklist:

```text
Source:
Exact location in source:
Source convention:
Project convention:
Every basis symbol in the formula:
Map for each basis symbol:
Sign correction for each basis symbol:
Order of multiplication:
Parentheses:
Scalar field:
Expected project formula:
Validation method:
Reviewer needed:
```

If any line is unknown, do not move the formula into trusted Lean code.

## 8. Provenance Notes

Every nontrivial translated definition or theorem should record provenance.

Good provenance note:

```text
Source: Furey, arXiv:1806.00612, Section 2.
Source convention: Baez octonion basis.
Project convention: XOR basis from Basic.lean.
Translation: ConventionBridge, Baez e5 maps to negative e100.
Validation: Scripts/oracle/validate_convention_bridge.py.
Provenance: clean-room formalization, no external code copied.
```

Bad provenance note:

```text
Source: Furey.
```

Too vague. It does not say where, what convention, or how the formula was
translated.

## 9. Oracle Validation

The bridge was validated by:

```text
Scripts/oracle/validate_convention_bridge.py
```

Oracle validation can check products, signs, and translated formulas.

Important rule:

```text
Oracle validation is evidence. It is not a trusted Lean proof by itself.
```

If a theorem is trusted, Lean must still check it.

## 10. What Low-End Agents May Do

Safe tasks:

- Read a source formula and list every basis symbol.
- Record source metadata in `Sources/`.
- Add a task-file note saying ConventionBridge is required.
- Summarize the current Baez-to-XOR map.
- Point a docstring to `ConventionBridge`.
- Run or summarize an existing validator script if asked.
- Compare a source formula to an already-reviewed project formula.

Safe with review:

- Add a provenance note to a Lean docstring.
- Add a markdown table of translated basis labels.
- Create an `AgentTasks/` file requesting formal proof of a translation.

Not safe:

- Invent a sign correction.
- Change `baezToXORIndex`.
- Change `baezToXORSign`.
- Copy a Baez/Furey theorem directly into trusted Lean.
- Decide two conventions are "the same".
- Change a ladder operator to make a proof pass.
- Treat physical interpretation as proved by an algebraic equality.

## 11. Reading ConventionBridge In Lean

Look for:

```text
def baezToXORIndex
def baezToXORSign
def baezBasisInXOR
```

You do not need to understand every Lean detail at first. Start with the
comments. They explain the intended mapping.

When you see:

```text
Baez e5 maps to project e100 with sign -1
```

remember that this means the translated basis vector is negative `e100`, not
positive `e100`.

## 12. Common Mistakes

Mistake:

```text
The source says e7, so I will use project e7.
```

Correction:

```text
The project does not use source labels e1 through e7 directly. Check
ConventionBridge. Baez e7 maps to project e111 in the current bridge.
```

Mistake:

```text
Only the index matters.
```

Correction:

```text
The sign matters too.
```

Mistake:

```text
I changed a sign because the proof failed.
```

Correction:

```text
Stop. A failed proof may indicate a wrong statement, missing lemma, convention
mismatch, or real mathematical issue. Do not change signs to make proofs pass.
```

Mistake:

```text
The oracle checked it, so no Lean proof is needed.
```

Correction:

```text
The oracle is evidence. Trusted code still needs Lean proof.
```

## 13. How To Write A Convention Handoff

If a task needs convention review, write:

```text
Convention handoff:
- Source:
- Source formula:
- Source basis convention:
- Project target file:
- Project basis labels involved:
- Known bridge map:
- Sign corrections:
- Parentheses/order concerns:
- Scalar field:
- Validator used:
- Remaining uncertainty:
```

This is much better than guessing.

## 14. Practice Exercise 1: Translate Labels Only

Using the current bridge table, translate these Baez labels to project labels.
Include signs.

```text
e1
e3
e5
e7
```

Expected answer:

```text
e1 maps to +e001.
e3 maps to +e110.
e5 maps to -e100.
e7 maps to +e111.
```

## 15. Practice Exercise 2: Explain Alpha1

Source formula:

```text
alpha1 = (-e5 + i e4) / 2
```

Task:

1. Translate `e5`.
2. Translate `e4`.
3. Explain why the project formula has `+e100`.

Expected answer:

```text
Baez e5 maps to -e100. Therefore -e5 maps to +e100.
Baez e4 maps to +e011. Therefore i e4 maps to i e011.
So alpha1 maps to (+e100 + i e011) / 2.
```

## 16. Practice Exercise 3: Source Note

Write a provenance note for a formula from Furey Section 2.

It must include:

- source,
- section,
- source convention,
- project convention,
- bridge rule,
- validation method,
- license/copying note.

Do not write Lean code.

## 17. Practice Exercise 4: Spot The Unsafe Move

Which actions are unsafe?

```text
1. Summarize the bridge table.
2. Change Baez e5 to map to +e100 because a proof failed.
3. Add a markdown note that a formula needs ConventionBridge review.
4. Copy a Furey ladder operator directly into Lean without translation.
5. Run the validator script and report output.
```

Expected answer:

```text
Unsafe: 2 and 4.
Safe or usually safe: 1, 3, 5.
```

## Final Checklist

Before using a source formula involving octonion basis elements:

- I know the source.
- I know the source convention.
- I know the project convention.
- I listed every basis element in the formula.
- I applied the index mapping.
- I applied the sign correction.
- I preserved order and parentheses.
- I recorded provenance.
- I did not change signs to make a proof pass.
- I know whether this needs strong review.

## One-Sentence Rule

No source octonion formula enters trusted Lean until its convention has been
made explicit.
