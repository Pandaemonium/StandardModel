# Aristotle N4: quantum-code extraction moonshot

Create or modify:

```text
PhysicsSM/Draft/Sedenions/QuantumCodeExtractionMoonshot.lean
```

## Big Goal

Determine whether any honest finite quantum code can be extracted from the
sedenion code data.

The current docs warn that `C_ZD` is not automatically a quantum stabilizer
code.  This job should make that warning precise and search for nearby useful
CSS/stabilizer-code data.

## Existing Context

Use:

```text
PhysicsSM.Draft.Sedenions.ReedMullerCode
PhysicsSM.Draft.Sedenions.AnomalyCancellationAnalogue
PhysicsSM.Draft.Sedenions.StabilizerPlaquettes
PhysicsSM.Draft.Sedenions.StabilizerMagicMoonshot
```

## Desired Theorems

Try to prove:

1. `C_ZD` is not self-orthogonal and therefore cannot directly be used as both
   sides of a CSS stabilizer check system.
2. Classify the CSS pairs obtainable from the finite family:

```text
C_ZD
C_ZD^perp
RM(1,4)
shortened RM(1,4)
punctured versions at coordinates 0 and 8
```

3. For each valid CSS pair, compute `n`, `k`, and a finite distance estimate or
   exact minimum weight of nontrivial logical words.
4. If no nontrivial code appears, prove the negative theorem cleanly.
5. Optionally connect the 42 stabilizer plaquette states to stabilizer states
   rather than stabilizer codes, preserving the distinction in theorem names.

Suggested theorem names:

```lean
theorem cZD_not_css_self_orthogonal : ...
theorem valid_css_pairs_classification : ...
theorem best_css_candidate_parameters : ...
theorem signed_plaquettes_are_states_not_code_checks : ...
```

## Constraints

- Do not call a binary code a quantum code without a symplectic/commutation
  condition and parameters.
- No axioms, opaque constants, unsafe code, or admits.
