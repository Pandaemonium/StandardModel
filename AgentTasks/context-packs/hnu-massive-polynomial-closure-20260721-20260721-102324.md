# Aristotle semantic context pack

Generated: 2026-07-21T10:23:56
Query: `live massive HNU walk exact skew-Hermitian ordered exponential product polynomial one-step and many-step error with Pluecker mass`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/hnu-massive-polynomial-adaptive-cost-aristotle-2026-07-21.md` [Objective]

Score: `0.866`

```text
## Objective

Compose the landed skew-Hermitian product-formula bound with the actual doubled
HNU endpoint, Dirac-basis conjugation, and exact Pluecker mass exponential.
Derive a polynomial one-step constant, telescope it, and prove the compact
changing-window schedule for `massiveWend` itself.
```

### 2. `AgentTasks/context-packs/hnu-massive-polynomial-adaptive-cost-20260721-20260721-052957.md` [Aristotle semantic context pack]

Score: `0.865`

```text
# Aristotle semantic context pack

Generated: 2026-07-21T05:30:05
Query: `live massive HNU doubled chiral endpoint exact skew-Hermitian product formula Pluecker mass polynomial one-step error`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.
```

### 3. `AgentTasks/aristotle-standalone/hnu-massive-polynomial-adaptive-cost-20260721/PROMPT.md` [Proof job: compose the polynomial bound with the live massive HNU walk]

Score: `0.852`

```text
# Proof job: compose the polynomial bound with the live massive HNU walk

Work in the supplied PhysicsSM Lean project. Start with the narrow command:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUMassivePolynomialAdaptiveCost.lean
```

Fill every proof placeholder in that target without adding assumptions,
compiler-trusted evaluation, or fake declarations. The decisive target is
`massive_one_step_polynomial_bound`: it must compare the existing live
`HNUMassiveContinuumReduction.massiveWend` with its existing
`massiveEflow`, not replace either by a parallel toy definition.

Use the exact ingredients already landed:

- `HNUPolynomialAdaptiveCost.skewHermitian_ordered_product_bound`;
- its exact two-component depth-eight HNU exponential word;
- `HNUExactCore.endpoint` and the `Uplus`/`Uminus` projector factors;
- `HNUPlueckerMassiveStay.doubledChiralEndpoint`, `diracBasis`, and
  `massiveHNU`;
- `HNUMassiveContinuumReduction.massCoin4_eq_exp_mass4`, `norm_mass4`,
  `norm_kinetic4_le_qAbs`, exact unitarity, and `massiveEflow_div_pow`.

Likely proof ladder:

1. Prove exact phase-times-Pauli-rotation formulas for `Uplus` and `Uminus`.
2. Prove the live `HNUExactCore.endpoint` equals the landed exact depth-eight
   exponential word; all scalar phases must cancel exactly.
3. Pair the `q` and `-q` factors into four-component block-diagonal
   skew-Hermitian generators, then conjugate by `diracBasis`.
4. Prepend the exact Pluecker mass exponential and identify the generator sum
   with `-I * (kinetic4 q + mass4 z)`.
5. Bound the generator-norm sum. The target permits the conservative
   `2*qAbs q + norm z`; prove the sharper `qAbs q + norm z` if a block-norm
   equality is available, but do not weaken the theorem to an assumed
   one-step estimate.
6. Telescope exact unitari
```

### 4. `AgentTasks/aristotle-standalone/hnu-polynomial-adaptive-cost-20260721/PROMPT.md` [Proof job: sharp unitary product bound and polynomial HNU continuum schedule]

Score: `0.833`

```text
ressed through actual commutators or imply

   ```text
   ||prod_j exp(eps A_j) - exp(eps * sum_j A_j)||
     <= eps^2 / 2 * (sum_j ||A_j||)^2.
   ```

   Do not insert an `exp(eps * sum norms)` factor. Preserve factor order.

3. Build the exact two-component HNU exponential word. Use Pauli matrices and
   the rotation factorization from the snapshots: one HNU endpoint is the
   square of the four-factor word with coefficients

   ```text
   q0/2, q2/4, q1/2, q2/4.
   ```

   Prove that the eight skew-Hermitian generators sum to
   `-I * (q0 sigma1 + q1 sigma2 + q2 sigma3)` and that their norms sum to at
   most `qAbs q = |q0| + |q1| + |q2|`. Prove the exact exponential-word
   equality, not only equality of derivatives at zero.

4. Lift through the doubled chiral block and fixed unitary Dirac-basis change,
   then prepend one exact Pluecker mass exponential whose generator norm is
   `norm z`. Prove a one-step estimate of the target shape

   ```text
   ||massiveWend z q eps - massiveEflow z q eps||
     <= eps^2 / 2 * (qAbs q + norm z)^2
   ```

   or return the sharpest explicit polynomial constant you can prove. If the
   displayed constant is false because of a factor count or block norm, keep
   the theorem polynomial and explain the exact correction. The finite witness
   `q = (1,0,0)`, `z = 3+4I` must leave both kinetic and mass generators
   nonzero.

5. Telescope exact unitaries for `n` steps and prove a compact-ball estimate
   polynomial in `R+M`, then define a common schedule guaranteeing error at
   most `1/(N+1)`. For `R_N = 3(N+1)`, prove an explicit polynomial upper
   bound on that schedule (cubic in `N` is the expected first-order scaling).

6. State the semantic boundary in the module docstring: this is approximation
   cost for a fixed continuum tim
```

### 5. `AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_PRODUCT_FORMULA_COST_2026-07-21.md` [Consequence for the live theorem]

Score: `0.830`

```text
## Consequence for the live theorem

The current coefficient `massiveCEnvelope M R` contains
`(R+M)^2 exp(R+M)`. With the changing window `R_N = 3(N+1)`, the current common
step count is therefore exponentially large in `N`. This is a sufficient
certificate, not evidence for an exponential physical hierarchy.

The HNU endpoint has more structure than the generic estimate uses:

- its kinetic part is an ordered product of eight exact unitary exponentials;
- their skew-Hermitian generator norms add to at most `qAbs q`;
- the Pluecker mass coin is one further exact unitary exponential with
  generator norm `norm z`;
- the exact comparison flow is generated by their sum.

The literature therefore motivates the target

```text
one-step error <= C * (qAbs q + norm z)^2 * eps^2,
many-step error <= C * (R + M)^2 * t^2 / n.
```

For `R_N = 3(N+1)`, choosing `n` proportional to
`(R_N+M)^2 (N+1)` gives a cubic schedule for fixed `M` and `t`. This would turn
the continuum theorem into a quantitatively credible polynomial certificate.
```

### 6. `PhysicsSM/Draft/NullEdge/HNUMassiveGlobalGap.lean`

Score: `0.828`

```text
import PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

/-!
# Global zero/pi gap target for the massive HNU walk

This draft isolates the strongest immediate consequence suggested by the exact
HNU census and the newly integrated Pluecker mass composition. The headline
claim is deliberately global over the closed Brillouin cube. It is not implied
by exact unitarity or by the infrared Dirac tangent alone.

The parity-census lemma is the expected hard trigonometric core. Numerical and
symbolic oracles suggest the statements below, but those calculations are not
proof. This file is an Aristotle handoff and remains draft while its proof holes
are present.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
```

### 7. `AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_MASSIVE_DIRAC_CONTINUUM_2026-07-20.md` [Childs, Su, Tran, Wiebe, and Zhu (2021)]

Score: `0.816`

```text
### Childs, Su, Tran, Wiebe, and Zhu (2021)

- Paper: *A Theory of Trotter Error*
- arXiv: <https://arxiv.org/abs/1912.08854>

This gives general product-formula error machinery.  It is useful as a source
of theorem shapes, but the finite `4 x 4` HNU target should first use the
project's existing elementary matrix-exponential bounds; invoking the full
general theory would add abstraction without removing the HNU-specific work.
```

### 8. `AgentTasks/hnu-massive-continuum-reduction-aristotle-2026-07-20.md` [Objective]

Score: `0.813`

```text
## Objective

Complete every proof hole in
`PhysicsSM/Draft/NullEdge/HNUMassiveContinuumReduction.lean` without weakening
the physical walk, the summed massive Dirac generator, or the second-order
one-step error shape.

The module composes four landed structures:

- the exact HNU Weyl endpoint and its quantitative massless remainder;
- the doubled opposite-chirality HNU walk in the live Dirac basis;
- the exact four-component Pluecker mass coin;
- the existing unitary telescope and matrix-exponential remainder machinery.

The primary analytic reference is Arrighi--Forets--Nesme,
arXiv:1307.3524.  That paper supplies the consistency/stability architecture,
not the HNU-specific theorem.
```

### 9. `AgentTasks/aristotle-standalone/hnu-polynomial-adaptive-cost-20260721/PROMPT.md` [Proof job: sharp unitary product bound and polynomial HNU continuum schedule]

Score: `0.811`

```text
# Proof job: sharp unitary product bound and polynomial HNU continuum schedule

Work in Lean 4.28 with Mathlib. The source snapshots in this package record the
live HNU definitions and the already verified generic two-factor commutator
bound. They are reference context; because their original imports are not in
this small package, create a self-contained Mathlib-only output module named
`HNUPolynomialAdaptiveCost.lean`.

The current live massive continuum theorem is mathematically valid but uses a
Taylor envelope containing `exp (R + M)`. At the changing momentum window
`R_N = 3 (N+1)`, its certified microscopic step count is therefore
exponential in `N`. This appears to be a proof artifact. Every HNU rotation
substep and the Pluecker mass coin is an exact exponential of a
skew-Hermitian finite matrix, so all intervening propagator norms are exactly
one. Modern commutator-scaled product-formula bounds suggest a polynomial
certificate.

Prove as much of this ladder as possible without weakening it into an assumed
one-step estimate:

1. For complex finite matrices, prove a two-factor skew-Hermitian estimate
   with no exponential norm penalty:

   ```text
   ||exp(eps A) exp(eps B) - exp(eps (A+B))||
     <= eps^2 / 2 * ||A*B - B*A||
   ```

   for `0 <= eps`, `A^H = -A`, and `B^H = -B`. You may reuse or cleanly
   specialize the variation-of-constants argument in
   `LieTrotterCommutatorBound.lean`.

2. Extend this to a finite ordered product of skew-Hermitian generators. A
   list, `Fin n`, or an explicit nine-factor theorem is acceptable, but the
   final bound must be expressed through actual commutators or imply

   ```text
   ||prod_j exp(eps A_j) - exp(eps * sum_j A_j)||
     <= eps^2 / 2 * (sum_j ||A_j||)^2.
   ```

   Do not insert an `exp(eps * sum norms)` facto
```

### 10. `PhysicsSM/Draft/NullEdge/PlueckerHNUIntertwiner.lean`

Score: `0.811`

```text
import PhysicsSM.Draft.NullEdge.HNUInfraredTangent
import PhysicsSM.Draft.NullEdge.PluckerMassOperator
import PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

/-!
# An explicit HNU--Pluecker bridge after four-component doubling

This module composes three existing finite results without reproducing their
definitions.  The HNU endpoint has the infrared tangent `-i q.sigma`; the live
four-component Pluecker operator has the usual massless Dirac kinetic block;
and the two Pluecker rest operators are related by one explicit rectangular
intertwiner `W`.

The scope boundary is essential.  The theorem does **not** derive the Pluecker
coordinate from the HNU endpoint, and it does not make one two-component HNU
Weyl point massive.  Indeed, `singleWeyl_mass_noGo` proves that no nonzero
`2 x 2` matrix anticommutes with all three Pauli velocity generators.  The
compatible mass appears only after passing to the live four-component
Clifford representation.  The displayed `W` is an explicit compatible
embedding; no uniqueness or canonicity claim is made.

Conventions: the Pauli matrices are those of `HNUExactCore`; the four-component
Dirac matrices are those of `Pluecker3Plus1ComplexMass`; and the complex rest
operator is `PluckerMassOperator.massOperator`.  These imported modules already
record their metric, basis, and Pluecker conventions.

Provenance: clean-room integration of the mathematically valid subset of
Aristotle project `f0d38cd0-cdec-46ef-800b-b588e3e07740`, task
`c9f31d7f-a8ae-4ade-9d36-e03b2db004a9`.  The returned file duplicated the live
APIs and described `W` as forced; this integration instead reuses the live APIs
and retains only the proved explicit-existence statement.
-/
```

## Scoped paper hits

### 1. A Theory of Trotter Error

Score: `0.728`
Zotero key: `U5M94GFX`
arXiv: `1912.08854`
DOI: `10.1103/PhysRevX.11.011020`
URL: http://arxiv.org/abs/1912.08854

Abstract:

The Lie-Trotter formula, together with its higher-order generalizations, provides a direct approach to decomposing the exponential of a sum of operators. Despite significant effort, the error scaling of such product formulas remains poorly understood. We develop a theory of Trotter error that overcomes the limitations of prior approaches based on truncating the Baker-Campbell-Hausdorff expansion. Our analysis directly exploits the commutativity of operator summands, producing tighter error bounds for both real- and imaginary-time evolutions. Whereas previous work achieves similar goals for systems with geometric locality or Lie-algebraic structure, our approach holds in general. We give a host of improved algorithms for digital quantum simulation and quantum Monte Carlo methods, including simulations of second-quantized plane-wave electronic structure, $k$-local Hamiltonians, rapidly decaying power-law interactions, clustered Hamiltonians, the transverse field Ising model, and quantum ferromagnets, nearly matching or even outperforming the best previous results. We obtain further speedups using the fact that product formulas can preserve the locality of the simulated system. Specifically, we show that local observables can be simulated with complexity independent of the system size for power-law interacting systems, which implies a Lieb-Robinson bound as a byproduct. Our analysis reproduces known tight bounds for first- and second-order formulas. Our higher-order bound overestimates the complexity of simulating a one-dimensional Heisenberg model with an even-odd ordering of terms by only a factor of $5$, and is close to tight for power-law interactions and other orderings of terms. This suggests that our theory can accurately characterize Trotter error in terms of both asymptotic scaling and constant prefactor.

### 2. Finite-Difference Approach to the Hodge Theory of Harmonic Forms

Score: `0.711`
Zotero key: `TSAQXS9N`
DOI: `10.2307/2373615`
URL: https://doi.org/10.2307/2373615

### 3. An analysis of completely-positive trace-preserving maps on M2

Score: `0.706`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 4. Random Walks on Simplicial Complexes and the Normalized Hodge 1-Laplacian

Score: `0.702`
Zotero key: `N7T76U5H`
arXiv: `1807.05044`
DOI: `10.1137/18M1201019`
URL: https://doi.org/10.1137/18M1201019

### 5. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.701`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299
