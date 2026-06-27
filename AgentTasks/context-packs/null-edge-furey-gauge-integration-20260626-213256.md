# Aristotle semantic context pack

Generated: 2026-06-26T21:33:16
Query: `Furey ideals anomaly cancellation Standard Model true Z6 gauge group null-edge Furey Phi_H almost-commutative product Gate C`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Baez_Octonions_Standard_Model_Talk_Notes.md` [Near-term targets]

Score: `0.816`

```text
### Near-term targets

1. Define the true Standard Model gauge group as `S(U(2) x U(3))`, with the
   central quotient from `U(1) x SU(2) x SU(3)` documented.
2. Prove exact arithmetic facts for the one-generation Standard Model
   representation table, including anomaly cancellation.
3. Define projective-geometry scaffolding for `h_3(K)`:
   - projections;
   - trace-one points;
   - trace-two lines;
   - incidence `p o ell = p`.
4. Formalize `Stab_G2(I) ~= SU(3)` as a staged target:
   - first as a statement;
   - then through a concrete `C + C^3` model;
   - finally as an automorphism-group theorem.
5. Add a source note to the Furey bridge: the left/right-handed fermion issue is
   open in the Baez/Dubois-Violette/Todorov/Krasnov route.
```

### 2. `PhysicsSM/Draft/StandardModelAnomalyPackage.lean` [FureyRealizesStandardModelOneGeneration]

Score: `0.814`

```text
def FureyRealizesStandardModelOneGeneration : Prop :=
  LocalAnomalyFree standardModelOneGeneration ∧
    WittenSU2AnomalyFree standardModelOneGeneration

/--
Draft target: complete Standard Model anomaly cancellation package, with the
Furey bridge as an explicit hypothesis/result rather than hidden arithmetic.
-/
```

### 3. `PhysicsSM/StandardModel/AnomalyPackage.lean`

Score: `0.809`

```text
import Mathlib.Tactic

/-!
# Standard Model anomaly cancellation package

This module provides a generic, kernel-checked framework for stating and
verifying gauge anomaly cancellation for the Standard Model gauge group
`SU(3)_c × SU(2)_L × U(1)_Y`.

## Physical background

In a chiral gauge theory, quantum loops of fermions can break gauge invariance
unless the fermion content satisfies certain algebraic constraints — the anomaly
cancellation conditions. For the Standard Model these are six conditions:

1. **Gravitational–U(1)**: a mixed anomaly between gravity and hypercharge.
2. **U(1)³**: a pure hypercharge cubic anomaly.
3. **SU(2)²–U(1)**: a mixed anomaly between the weak group and hypercharge.
4. **SU(3)²–U(1)**: a mixed anomaly between colour and hypercharge.
5. **SU(3)³**: a pure colour cubic anomaly.
6. **Witten SU(2)**: a global (non-perturbative) anomaly of the weak group.

The fact that the Standard Model fermion content satisfies all six conditions
simultaneously is a highly non-trivial algebraic miracle. Here it is checked
by exact rational arithmetic.

## Representation conventions

All fermions are entered as **left-handed Weyl spinors**. Physical right-handed
fermions (like `u_R`, `d_R`, `e_R`) are entered as their **left-handed
charge-conjugate** fields (`u_R^c`, `d_R^c`, `e_R^c`). Charge conjugation
flips the sign of hypercharge.

Hypercharge is normalised using the project convention
  `Q = T₃ + Y / 2`
which matches Weinberg (1967) and Peskin–Schroeder. Under this convention
the Standard Model multiplets for one generation are:

| Multiplet | SU(3)_c  | SU(2)_L | Y      | Q (upper, lower) |
|-----------|----------|---------|--------|-------------------|
| Q_L       | 3        | 2       | 1/3    | 2/3, −1/3         |
| L_L       | 1        | 2       |
```

### 4. `PhysicsSM/Algebra/Furey/ElectroweakAnomalyBridge.lean`

Score: `0.808`

```text
import Mathlib
import PhysicsSM.Algebra.Furey.ElectroweakCompletePackage
import PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
import PhysicsSM.Algebra.Furey.OneGenerationPackage
import PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
import PhysicsSM.StandardModel.OneGenerationTable
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.StandardModel.FamilyAnomalyNaturality

/-!
# Furey electroweak–anomaly bridge

This module bridges the Furey finite-state electroweak package to the
Standard Model anomaly cancellation package. It proves that the quantum
numbers extracted from the Furey Jbar sector are **compatible** with the
one-generation anomaly-free table, and that the Furey-derived left-handed
doublet sub-table already satisfies a partial anomaly cancellation
condition.

## What is proved

1. **Doublet embedding**: the two Furey Jbar left-handed doublet multiplets
   (Q_L and L_L) form a sub-list of the full `standardModelOneGeneration`
   table, with matching colour representation, weak representation, and
   hypercharge.

2. **Charge / weak-isospin / hypercharge consistency**: for every Jbar
   basis state, the Furey-assigned physical charge, target T₃, and
   computed hypercharge satisfy the Gell-Mann–Nishijima relation
   `Q = T₃ + Y/2`.

3. **Partial anomaly cancellation**: the Furey Jbar doublet sub-table
   satisfies the SU(2)²–U(1)_Y anomaly condition in isolation, which is
   a necessary condition for the doublet sector to be part of an anomaly-
   free theory.

4. **Anomaly-free completion**: when the Jbar doublet sub-table is completed
   with the conventional right-handed singlet sector (u_Rc, d_Rc, e_Rc),
   the result is exactly `standardModelOneGeneration`, which is proved
   locally anomaly free and Witten-anomaly free.

5. **Package theorem*
```

### 5. `AgentTasks/standard-model-anomaly-furey-aristotle-2026-06-12.md` [Goal]

Score: `0.804`

```text
## Goal

Fill the 17 `sorry`s in

```text
PhysicsSM/Draft/StandardModelAnomalyPackage.lean
```

establishing local/Witten anomaly cancellation for the Standard Model fermions, and verifying the Furey charge/hypercharge coordinate eigenvalues:

- `standardModelOneGeneration_localAnomalyFree`
- `standardModelOneGeneration_wittenAnomalyFree`
- `standardModelOneGeneration_anomalyFree`
- `JbarBasisState_linearIndependent`
- `Q_op_*_target` (8 theorems)
- `T3_op`, `Y_op` definitions
- `T3_op_omega_target`, `T3_op_nu_target`
- `Y_op_omega_target`, `Y_op_nu_target`
- `furey_realizes_anomalyFreeStandardModelGeneration`
```

### 6. `Sources/Furey_Baez_Octonions_Standard_Model_Survey.md` [2.2 The Full Gauge Group and the Z6 Quotient]

Score: `0.799`

```text
### 2.2 The Full Gauge Group and the Z6 Quotient

Furey's 2018 EPJC paper sharpens the gauge symmetry claim.  The main target is:

```text
G_SM = (SU(3)_C x SU(2)_L x U(1)_Y) / Z6,
```

with a possible extra `U(1)_X` when using `U(n)` rather than `SU(n)` ladder
symmetries.

The important feature here is that Furey's construction resembles aspects of
`SU(5)` unification, but the algebraic actions carry extra labels.  Some
transitions that would normally mediate proton decay in an `SU(5)`-like model
are argued to be blocked because they mix distinct algebraic action types.

For formalization, this is attractive because it decomposes into finite,
checkable pieces:

- ladder-operator anticommutation;
- minimal ideal bases;
- charge eigenvalues;
- color and weak representation tables;
- the finite `Z6` kernel of the covering map.

The hard part is not arithmetic.  The hard part is semantic alignment: making
sure the Lean statements really correspond to the intended physics
representations and not just to a convenient finite table.
```

### 7. `PhysicsSM/Gauge/StandardModelProductCoveringTrueZ6Kernel.lean` [standardModelTrueProductZ6KernelPackage]

Score: `0.799`

```text
noncomputable def standardModelTrueProductZ6KernelPackage :
    StandardModelTrueProductZ6KernelPackage where
  kernel_family_maps_to_one := smProductCoveringKernelElt_trueImage_eq_one
  identity_fiber_exact := smTrueProductCoveringTripleToSMBlockUnits_eq_one_iff

end PhysicsSM.Gauge.StandardModelSubgroup
```

### 8. `PhysicsSM/Draft/StandardModelAnomalyPackage.lean`

Score: `0.793`

```text
import Mathlib.Tactic
import PhysicsSM.Algebra.Furey.OperatorRepresentations

/-!
# Draft Standard Model anomaly package and Furey bridge targets

This file is intentionally draft scaffolding for a large Aristotle job. It
collects the missing pieces needed to turn the current exact-arithmetic anomaly
checks into a complete, reviewable Standard Model anomaly-cancellation package.

Trusted files should not import this module while it contains `s o r r y`.

The intended end state is to split successful parts into trusted modules:

* `PhysicsSM.StandardModel.AnomalyPackage`
* `PhysicsSM.Algebra.Furey.AnomalyBridge`

The difficult semantic bridge is the Furey-to-Standard-Model map. The Lean
kernel can check operator eigenvalue equations, but it cannot decide by itself
whether the chosen state labels are the intended Standard Model multiplets. The
final trusted bridge must therefore keep the particle/antiparticle, chirality,
color representation, and hypercharge conventions explicit.
-/
```

## Scoped paper hits

### 1. Gravity and the standard model with neutrino mixing

Score: `0.742`
Zotero key: `NSR38VHU`
arXiv: `hep-th/0610241`
DOI: `10.4310/ATMP.2007.v11.n6.a3`
URL: https://www.zotero.org/19894138/items/NSR38VHU

Abstract:

An effective unified theory based on noncommutative geometry for the standard model with neutrino mixing, minimally coupled to gravity. The unification is based on the symplectic unitary group in Hilbert space and on the spectral action. It yields the detailed structure of the standard model with several predictions at unification scale: besides the gauge-coupling relations familiar from GUTs, it predicts the Higgs scattering parameter and the sum of the squares of the Yukawa couplings, giving a Higgs mass around 170 GeV. Spacetime is the product of an ordinary spin manifold by a finite noncommutative geometry F of KO-dimension 6 modulo 8 and metric dimension 0.

### 2. Lattice Regularization of Reduced Kähler-Dirac Fermions and Connections to Chiral Fermions

Score: `0.739`
Zotero key: `VIQMFAXZ`
arXiv: `2311.02487`
DOI: `10.21468/SciPostPhys.16.4.108`
URL: http://arxiv.org/abs/2311.02487

Abstract:

We show how a path integral for reduced Kähler-Dirac fermions suffers from a phase ambiguity associated with the fermion measure that is an analog of the measure problem seen for chiral fermions. However, unlike the case of chiral symmetry, a doubler free lattice action exists which is invariant under the corresponding onsite symmetry. This allows for a clear diagnosis and solution to the problem using mirror fermions resulting in a unique gauge invariant measure. By introducing an appropriate set of Yukawa interactions which are consistent with 't Hooft anomaly cancellation we conjecture the mirrors can be decoupled from low energy physics. Moreover, the minimal such Kähler-Dirac mirror model yields a light sector which corresponds, in the flat space continuum limit, to the Pati-Salam GUT model.

### 3. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.736`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 4. Renormalizing Yukawa interactions in the standard model with matrices and noncommutative geometry

Score: `0.736`
Zotero key: `SHPRQMGH`
arXiv: `1906.02297`
URL: https://arxiv.org/abs/1906.02297

Abstract:

Shows that gauge-independent terms in the one-loop and multi-loop beta-functions of the Standard Model can be computed from Wetterich functional renormalization of a matrix model associated with the finite spectral triple underlying the spectral-action computation of the Standard Model Lagrangian. Provides a matrix-Yukawa duality for beta-functions.

### 5. An invitation to higher gauge theory

Score: `0.730`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9
