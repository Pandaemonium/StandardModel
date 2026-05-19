# Hamming E8 theta modular-form construction Aristotle job - 2026-05-16

Status: submitted to Aristotle.

Purpose: target the remaining analytic gap in the `Theta_E8 = E4` proof:
construct a weight-4 level-1 modular form from the Hamming Construction A E8
theta function, and match its q-expansion coefficients with
`hammingThetaConvolutionCoeff`.

## Local target file

Added:

```text
PhysicsSM/Draft/E8ThetaModularFormConstructionAristotle.lean
```

Main target:

```lean
theorem exists_e8Theta_weight4_modularForm_with_qExpansion :
    exists f : ModularForm (CongruenceSubgroup.Gamma 1) 4,
      (forall z : UpperHalfPlane, f z = e8ThetaAnalytic z) /\
      (forall n : Nat,
        (ModularFormClass.qExpansion (1 : Real) f).coeff n =
          (hammingThetaConvolutionCoeff n : Complex))
```

This is the exact input needed by the existing sorry-free reduction:

```lean
hammingThetaConvolutionCoeff_eq_e4Coeff_of_weight4_form
```

## Intended proof route

1. Prove T-invariance from the fact that every Construction A E8 vector has
   `sqNorm z` divisible by `4`.
2. Prove S-invariance from Poisson summation for the self-dual E8 lattice.
   Relevant SPL module: `SpherePacking.CohnElkies.PoissonSummationGeneral`.
3. Prove holomorphicity and boundedness at cusps from theta summability and
   Gaussian majorants.
   Relevant SPL module: `SpherePacking.ModularForms.JacobiTheta`.
4. Match q-expansion coefficients to shell counts and use
   `constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff`.

Useful SPL blueprint:

```text
SpherePacking/Dim24/Uniqueness/Rigidity/Classify/Niemeier/RootlessCase/ThetaMF.lean
```

That file bundles an even unimodular theta series as a modular form by proving
S/T invariance, holomorphicity, and cusp boundedness.  The new job should adapt
that pattern to rank 8 / weight 4 and the Hamming Construction A model.

## Heavy native_decide policy

The user explicitly approved replacing heavyweight `native_decide` statements
with documented `by sorry` placeholders in the Aristotle submission copy only,
to prevent proof-search timeouts.  Aristotle should not spend time proving
those placeholders.  They are only compile-time relief for imported finite
enumerations.  The live repository keeps the existing verified computations.

If placeholders are added in the submission copy, mark them with a comment like:

```lean
-- Submission-only timeout placeholder: not part of the theta modular-form target.
```

Do not introduce axioms, `opaque`, or `unsafe`.

## Local verification

Command run in the main checkout:

```text
lake env lean PhysicsSM/Draft/E8ThetaModularFormConstructionAristotle.lean
```

Result: the file checks with one intentional draft `sorry`.

## Submission package

```text
AgentTasks/aristotle-submit/hamming-e8-theta-modular-form-20260516-project
```

## Submitted job

| Job | Aristotle ID | Status at submission |
|-----|--------------|----------------------|
| E8 theta modular-form construction | `eedeebb1-2a7b-4ce6-afd8-314453f23040` | queued |

Submission command:

```text
aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-e8-theta-modular-form-20260516-project <prompt>
```

Follow-up command:

```text
aristotle result eedeebb1-2a7b-4ce6-afd8-314453f23040 --destination AgentTasks/aristotle-output/hamming-e8-theta-modular-form-20260516
```
