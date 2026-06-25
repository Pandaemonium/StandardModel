# Round 022 context: P2 trace ladder after Mandelstam identity

Date: 2026-06-24.

## Program gestalt

We are advancing the null-edge causal graph program by turning ambitious
physics claims into finite Lean theorem packages. The strongest current lanes:

- `P1-F`: formalization of Plucker mass, observer-conditioned normalization,
  and frame-audited celestial mixedness.
- `P2-R`: finite Dirac / branch-reflection / super-Dirac square-root bridge.
- `P4-R`: null-step quantum-walk/chirality dynamics.
- `P7-R`: observer channels, relative entropy, and proper-time/mass readout.
- `P9-F`: finite source-visibility, screen/harmonic projection, and noise
  guardrails.

This round is focused on `P2-R`: keep the operator/trace story finite and
algebraic before making any super-Dirac or causal-diamond interpretation.

## Latest P2 theorem state

Live module:

```text
PhysicsSM/Draft/NullEdgeP2TwoReflectionTrace.lean
```

Definitions already present:

```text
RMat2 := Matrix (Fin 2) (Fin 2) Real
chiralHamiltonian (h p m : Real) : RMat2
branchReflection (h p m E : Real) : RMat2
trace2 (M : RMat2) : Real
tracelessMat (a b c : Real) : RMat2
```

Banked draft theorems in this module:

```text
trace2_mul_two_branchReflections_formula
trace2_mul_two_branchReflections_symm
trace2_branchReflection_sq_eq_two_on_massShell
trace2_mul_three_branchReflections_eq_zero
trace2_mul_four_branchReflections_formula
trace2_four_diagWitness_eq_two
trace2_four_alternatingWitness_eq_neg_two
trace2_four_branchReflections_nonconstant
trace2_mul_four_traceless_mandelstam
```

The new theorem `trace2_mul_four_traceless_mandelstam` says that, for four
real traceless `2 x 2` matrices, the four-trace is determined by pairwise
two-traces:

```text
2 * trace2(A * B * C * D)
  =
trace2(A * B) * trace2(C * D)
- trace2(A * C) * trace2(B * D)
+ trace2(A * D) * trace2(B * C)
```

It was proved by Aristotle and integrated into the live draft module. Direct
checks passed:

```text
lake env lean PhysicsSM\Draft\NullEdgeP2TwoReflectionTrace.lean
lake build PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace
lake env lean PhysicsSMDraft.lean
```

## Most likely next proof target

Aristotle recommended a branch-reflection instantiation corollary, explicitly
not a broad physics claim:

1. Prove each `branchReflection h p m E` is a real traceless `2 x 2` matrix,
   or directly express it as a `tracelessMat` coordinate matrix.
2. Use `trace2_mul_four_traceless_mandelstam` to specialize the four-trace
   reduction to four branch reflections:

```text
2 * trace2(R4 * R3 * R2 * R1)
  =
trace2(R4 * R3) * trace2(R2 * R1)
- trace2(R4 * R2) * trace2(R3 * R1)
+ trace2(R4 * R1) * trace2(R3 * R2)
```

where `Ri = branchReflection hi pi mi Ei`.

Physics value: this proves that the current real two-generator branch-reflection
model has no independent four-step scalar beyond pairwise trace data. Later
one-diamond curvature/super-Dirac claims must add an explicit geometric
substitution map rather than pretending the four-trace is new.

## Decision needed

We need exactly one new Aristotle job for the next constrained-loop round.
Possible choices:

1. Submit the P2 branch-reflection Mandelstam instantiation theorem above.
2. Delay P2 and pivot to P9 source visibility or P1/P7 observer-channel work.
3. Submit a design/audit job asking for the correct one-diamond substitution
   map after the branch-reflection theorem.

Please evaluate which single move is most publication-worthy and least likely
to produce technical debt.
