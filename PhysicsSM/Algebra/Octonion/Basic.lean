/-!
# Algebra.Octonion.Basic

Octonion type, basis labeling, and multiplication convention for this project.

## Basis labeling (XOR convention)

The project uses 3-bit binary labels for the eight basis elements:

| Label   | Role           | Decimal |
|---------|----------------|---------|
| `e000`  | unit element 1 | 0       |
| `e001`  | imaginary unit | 1       |
| `e010`  | imaginary unit | 2       |
| `e011`  | imaginary unit | 3       |
| `e100`  | imaginary unit | 4       |
| `e101`  | imaginary unit | 5       |
| `e110`  | imaginary unit | 6       |
| `e111`  | imaginary unit | 7       |

## Multiplication rule

For two imaginary basis elements `eₐ * e_b`:
- The **index** of the product is `a XOR b` (bitwise).
- The **sign** is determined by the Fano plane orientation below.
- `e000` is the unit: `e000 * eₐ = eₐ * e000 = eₐ`.
- Each imaginary unit squares to `-1`: `eₐ * eₐ = -e000` for `a ≠ 0`.

## Fano plane orientation — positive triples

The seven positive cyclic triples `(eₐ, e_b, e_c)` satisfy `eₐ * e_b = e_c`:

```
e001 * e010 = e011      (anchors the e111-free face)
e001 * e101 = e100
e001 * e110 = e111
e010 * e100 = e110
e010 * e101 = e111
e011 * e101 = e110
e011 * e111 = e100      ← user-specified anchor
```

Note `e101 * e111 = e010` and `e110 * e111 = e001` follow cyclically from
the last two triples above.

Each triple `(eₐ, e_b, e_c)` with `eₐ * e_b = e_c` also gives:
- `e_b * e_c = eₐ`  (cyclic)
- `e_c * eₐ = e_b`  (cyclic)
- `e_b * eₐ = -e_c` (reversed)
- etc.

This orientation has been machine-validated: Fano incidence and all 512
Moufang checks pass. See `Scripts/oracle/validate_octonion.py`.

## Relationship to Baez and Furey conventions

This convention is **not the same** as Baez (2002) or Furey (2015) verbatim.

Baez uses a cyclic mod-7 scheme on labels 1–7. A label permutation that sends
Baez's basis to this XOR basis is:

```
Baez e1 ↦ e001    Baez e5 ↦ e100
Baez e2 ↦ e010    Baez e6 ↦ e101
Baez e3 ↦ e110    Baez e7 ↦ e111
Baez e4 ↦ e011
```

However, this permutation alone does **not** convert Baez products to project
products — some basis elements also need sign flips. The full translation
(permutation + signs) is worked out in
`PhysicsSM.Algebra.Octonion.ConventionBridge`.

**Do not use Baez/Furey product formulas, ladder operators, or structure
constants directly in this project without explicitly translating them via
`ConventionBridge`. Mixing conventions silently corrupts signs.**

Furey's convention is essentially Baez's with `e₇` as the privileged
imaginary unit. In this project `e111` plays the same structural role.
The translation to Furey's ladder operators must go through `ConventionBridge`.

## Provenance

Convention: XOR basis labeling, user-defined.
Validation: `Scripts/oracle/validate_octonion.py` (Fano + Moufang).
Source for mathematical content: Baez, "The Octonions", Bull. Amer. Math. Soc.
39 (2002) 145–205. Convention differs from Baez — see `ConventionBridge`.

## Predecessor modules

None — this is the base octonion module.

## Successor modules

- `PhysicsSM.Algebra.Octonion.Conjugation`
- `PhysicsSM.Algebra.Octonion.Norm`
- `PhysicsSM.Algebra.Octonion.Alternativity`
- `PhysicsSM.Algebra.Octonion.ConventionBridge`

Status: stub — `Octonion` structure definition to be added.
-/

namespace PhysicsSM.Algebra.Octonion

/-!
The seven positive Fano triples encoded as a list, for use by the oracle
validator and future executable definitions.
-/

/-- The seven lines of the Fano plane as positive cyclic triples,
    in the project XOR basis. Each entry `(a, b, c)` records `eₐ * e_b = e_c`,
    with indices given as natural numbers matching the 3-bit XOR labels. -/
def fanoTriples : List (Fin 8 × Fin 8 × Fin 8) :=
  [ (⟨1, by omega⟩, ⟨2, by omega⟩, ⟨3, by omega⟩)   -- e001 * e010 = e011
  , (⟨1, by omega⟩, ⟨5, by omega⟩, ⟨4, by omega⟩)   -- e001 * e101 = e100
  , (⟨1, by omega⟩, ⟨6, by omega⟩, ⟨7, by omega⟩)   -- e001 * e110 = e111
  , (⟨2, by omega⟩, ⟨4, by omega⟩, ⟨6, by omega⟩)   -- e010 * e100 = e110
  , (⟨2, by omega⟩, ⟨5, by omega⟩, ⟨7, by omega⟩)   -- e010 * e101 = e111
  , (⟨3, by omega⟩, ⟨5, by omega⟩, ⟨6, by omega⟩)   -- e011 * e101 = e110
  , (⟨3, by omega⟩, ⟨7, by omega⟩, ⟨4, by omega⟩)   -- e011 * e111 = e100
  ]

end PhysicsSM.Algebra.Octonion
