# Task: Standard Model Anomaly Arithmetic over Rat

**Agent**: Aristotle
**Status**: Submitted
**Priority**: High
**Job ID**: `f4ff2cbc-e135-4ecc-b867-9178d66e5c6b`
**Output**: `AgentTasks/aristotle-output/standard-model-anomaly-rational-check`

## Goal

Add a small, trusted, convention-explicit Standard Model anomaly arithmetic file.
This is separate from the Furey algebra layer. It should prove the usual one
generation Standard Model hypercharge cancellation identities as rational
arithmetic.

Preferred file:

```text
PhysicsSM/StandardModel/AnomalyCancellation.lean
```

If adding the file requires updating an import index, keep that update minimal.
Do not modify Furey files in this job.

## Mathematical convention

Use the convention already documented in the project:

```text
Q = T3 + Y / 2
```

Work with left-handed Weyl fields only. Right-handed Standard Model fermions
are represented as their left-handed charge-conjugate fields. Therefore one
generation has the following left-handed multiplets:

```text
Q_L       : color multiplicity 3, weak multiplicity 2, hypercharge  1/3
L_L       : color multiplicity 1, weak multiplicity 2, hypercharge -1
u_R^c     : color multiplicity 3, weak multiplicity 1, hypercharge -4/3
d_R^c     : color multiplicity 3, weak multiplicity 1, hypercharge  2/3
e_R^c     : color multiplicity 1, weak multiplicity 1, hypercharge  2
```

This is the standard left-handed anomaly convention. It differs from listing
right-handed fields with their un-conjugated charges.

## Suggested Lean declarations

Use `Rat` for exact arithmetic.

```lean
namespace PhysicsSM.StandardModel.AnomalyCancellation

abbrev Charge := Rat

def quarkDoubletHypercharge : Charge := 1 / 3
def leptonDoubletHypercharge : Charge := -1
def antiUpHypercharge : Charge := -4 / 3
def antiDownHypercharge : Charge := 2 / 3
def antiElectronHypercharge : Charge := 2

def gravitationalHyperchargeSum : Charge :=
  6 * quarkDoubletHypercharge +
  2 * leptonDoubletHypercharge +
  3 * antiUpHypercharge +
  3 * antiDownHypercharge +
  antiElectronHypercharge

theorem gravitationalHyperchargeSum_eq_zero :
    gravitationalHyperchargeSum = 0 := by ...

def cubicHyperchargeSum : Charge :=
  6 * quarkDoubletHypercharge ^ 3 +
  2 * leptonDoubletHypercharge ^ 3 +
  3 * antiUpHypercharge ^ 3 +
  3 * antiDownHypercharge ^ 3 +
  antiElectronHypercharge ^ 3

theorem cubicHyperchargeSum_eq_zero :
    cubicHyperchargeSum = 0 := by ...

def su2SquaredU1HyperchargeSum : Charge :=
  3 * quarkDoubletHypercharge + leptonDoubletHypercharge

theorem su2SquaredU1HyperchargeSum_eq_zero :
    su2SquaredU1HyperchargeSum = 0 := by ...

def su3SquaredU1HyperchargeSum : Charge :=
  2 * quarkDoubletHypercharge + antiUpHypercharge + antiDownHypercharge

theorem su3SquaredU1HyperchargeSum_eq_zero :
    su3SquaredU1HyperchargeSum = 0 := by ...

def numberOfWeakDoublets : Nat := 4

theorem numberOfWeakDoublets_even :
    Even numberOfWeakDoublets := by ...

end PhysicsSM.StandardModel.AnomalyCancellation
```

## Comments to include

Add a module docstring explaining:

- this is only rational arithmetic for one generation,
- it is not a path-integral or anomaly-polynomial formalization,
- right-handed fields are included as left-handed conjugates,
- the normalization is `Q = T3 + Y / 2`.

## Constraints

- Do not introduce `sorry`, `admit`, `axiom`, `opaque`, or `unsafe def`.
- Do not overclaim Green-Schwarz, index theory, or quantum anomaly results.
- Keep the file small and heavily commented.
- Run:

```bash
lake env lean PhysicsSM/StandardModel/AnomalyCancellation.lean
```

## Expected result

A trusted arithmetic baseline for the Standard Model anomaly cancellation
conditions, ready to compare later against the Furey algebraic charge model.
