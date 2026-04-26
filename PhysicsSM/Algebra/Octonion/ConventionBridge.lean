/-!
# Algebra.Octonion.ConventionBridge

Translation between the project XOR convention and the Baez/Furey conventions.

## Why this module exists

The project uses the XOR binary-label convention for octonions (see
`PhysicsSM.Algebra.Octonion.Basic`). Baez (2002) and Furey (2015) use a
cyclic mod-7 convention on labels 1–7. The two conventions are isomorphic
as octonion algebras, but they are **not related by a pure label permutation**
— some basis elements also require sign flips.

This module provides:
- The explicit permutation from Baez labels to project labels.
- The sign correction map needed on top of the permutation.
- Verified translation lemmas (once the `Octonion` type is defined).
- A warning against using Baez/Furey formulas without translating first.

## Baez label permutation

```
Baez e1 ↦ e001    Baez e5 ↦ e100
Baez e2 ↦ e010    Baez e6 ↦ e101
Baez e3 ↦ e110    Baez e7 ↦ e111
Baez e4 ↦ e011
```

As a function `baezToXOR : Fin 7 → Fin 7` on imaginary-unit indices
(1-based for Baez, decimal 1–7 for XOR):

```
1 ↦ 1   (e1 → e001)
2 ↦ 2   (e2 → e010)
3 ↦ 6   (e3 → e110)
4 ↦ 3   (e4 → e011)
5 ↦ 4   (e5 → e100)
6 ↦ 5   (e6 → e101)
7 ↦ 7   (e7 → e111)
```

## Sign correction

After applying the label permutation, the Baez positive triple `(e3, e4, e6)`
becomes `(e110, e011, e101)` under the permutation. In the project convention,
the table gives `e110 * e011` = `-(e011 * e110)`. Since `e011 * e101 = e110`
(project positive triple), we have `e110 * e011 = -e101 ≠ +e101`.

This means some Baez products translate to negatives in the project convention.
The full sign correction requires a sign function `σ : Fin 7 → {±1}` such
that `baez_eᵢ` maps to `σ(i) * project_e_{π(i)}`.

The complete sign map is to be worked out and verified in this module once
the `Octonion` structure is defined.

## Furey convention

Furey's convention is essentially Baez's, with `e₇` as the privileged
imaginary unit (playing the role of `e111` in this project). Furey's ladder
operators are defined in terms of `e₄, e₅, e₆, e₇` (Baez labels); these
translate to `e011, e100, e101, e111` in the project basis, with the sign
corrections above applied.

**Do not copy Furey's ladder-operator definitions without going through the
full sign translation.**

## Safety rule

Every import of Furey- or Baez-sourced formulas must be accompanied by a
`ConventionBridge` lemma confirming the translation. There should be no
bare claims of the form "this follows from Furey (2015) eq. (X)" without
a verified `ConventionBridge` step.

## Prerequisites

- `PhysicsSM.Algebra.Octonion.Basic`

Status: stub — permutation and sign-correction map to be formalized once
`Octonion` type is defined.
-/

namespace PhysicsSM.Algebra.Octonion.ConventionBridge

/-- The permutation on imaginary-unit indices {1,...,7} sending Baez labels
    to project XOR labels. Input and output are 1-based imaginary indices
    (so index k corresponds to basis element eₖ in the respective convention). -/
def baezToXORIndex : Fin 7 → Fin 7
  | ⟨0, _⟩ => ⟨0, by omega⟩  -- Baez e1 → e001 (index 1, 0-based: 0)
  | ⟨1, _⟩ => ⟨1, by omega⟩  -- Baez e2 → e010 (index 2, 0-based: 1)
  | ⟨2, _⟩ => ⟨5, by omega⟩  -- Baez e3 → e110 (index 6, 0-based: 5)
  | ⟨3, _⟩ => ⟨2, by omega⟩  -- Baez e4 → e011 (index 3, 0-based: 2)
  | ⟨4, _⟩ => ⟨3, by omega⟩  -- Baez e5 → e100 (index 4, 0-based: 3)
  | ⟨5, _⟩ => ⟨4, by omega⟩  -- Baez e6 → e101 (index 5, 0-based: 4)
  | ⟨6, _⟩ => ⟨6, by omega⟩  -- Baez e7 → e111 (index 7, 0-based: 6)

end PhysicsSM.Algebra.Octonion.ConventionBridge
