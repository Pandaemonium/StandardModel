# Codex Aristotle target: concrete D4 / Hadamard quotient

Prove every theorem in `D4Quotient/ConcreteQuotient.lean` without changing any
definition or weakening any statement. Run the narrow command first:

```text
lake env lean D4Quotient/ConcreteQuotient.lean
```

## Mathematical target

`Coord = Z^4` is the standard simple-root coordinate lattice for `D4`.
`d4Embed` maps it to physical coordinates and must be proved to have image
exactly `{x in Z^4 | sum x even}`. The Hadamard sublattice is the image of the
explicit matrix `lhCoord`, whose determinant is `-8` and Smith normal form is
`diag(1,2,2,2)`.

The explicit quotient label is

```text
phi(c) = (c1 mod 2, c3 mod 2, (c0+c2) mod 2).
```

Prove it is surjective and that its kernel is exactly the image of `lhCoord`.
Then construct the additive equivalence

```text
Coord / LH ~=+ (Fin 3 -> ZMod 2)
```

and prove the quotient has cardinality `8`. This is the missing concrete input
for the already-landed generic `D4DisconnectedCopy.eightCopies` theorem.

## Nondegeneracy and audit requirements

- Do not replace the concrete kernel theorem by an assumption.
- Do not state only `det = 8`; the explicit quotient map and kernel equality are
  the scientific payload.
- Preserve the physical embedding theorem, so this is genuinely the standard
  even-sum `D4` lattice rather than an abstract copy of `Z^4`.
- Use kernel-checked arithmetic and standard Mathlib quotient APIs only.
- If the final quotient equivalence API blocks, still close every preceding
  injectivity, range, surjectivity, and kernel theorem and leave a precise note.

Context pack:
`AgentTasks/context-packs/d4-concrete-quotient-20260709-20260709-173421.md`.

```yaml
aristotle:
  project_id: 9c0020be-4a4d-4b26-bf07-1acb2a07b4e2
  target_file: D4Quotient/ConcreteQuotient.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateC1.D4ConcreteQuotient
  status: integrated
```
