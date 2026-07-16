# Phenomenologist observable card: relative Pluecker-phase interferometry

Date: 2026-07-13

Role activation: `role-20260713-000911-a0f3e6d4`

Program: `NE-DYNAMICS`

Work item: `DYN-MODULAR-001`

## Executive verdict

The strongest currently available operational target is a finite two-pulse
interference experiment in the active fermion-pair sector. The checked model
compares two complex fields with equal modulus,

```text
z1 = 3 + 4 i,    z2 = 5,    |z1| = |z2| = 5.
```

Their one-particle rest operators are exactly unitarily conjugate, so the free
one-particle spectrum cannot distinguish them. A vacuum-referenced two-kick
experiment does distinguish them: the survival probability is exactly `4/5`
for the relative-phase fixture and `1` for the equal-field control.

This is a rigorous finite benchmark and a useful discriminator against a model
that retains only the scalar `|z|`. It is not yet a laboratory prediction. The
pair kick, pulse implementation, physical scale map, and connection to the
selected modular flow are still supplied rather than derived.

## Observable card

### Observable

Prepare the normalized superposition of the vacuum and the low-pair state,

```text
|psi> = (|vac> + |low pair>) / sqrt(2).
```

Apply a pair kick with unit complex coefficient `u1`, followed by a second pair
kick with coefficient `u2`, then project back onto `|psi>`. The checked overlap
and survival probability are

```text
A(u1,u2) = (1 + u2 * conjugate(u1)) / 2,
P(u1,u2) = |A(u1,u2)|^2.
```

For unit phases `u_j = exp(i theta_j)`, this reduces to

```text
P(delta theta) = cos(delta theta / 2)^2
               = (1 + cos(delta theta)) / 2,
delta theta = theta2 - theta1.
```

The exact witness uses `u1 = z1/5 = (3+4i)/5` and `u2 = z2/5 = 1`, giving

```text
P_relative = 4/5,    P_equal-field = 1,    Delta P = 1/5.
```

### Units dictionary

| Quantity | Finite model | Physical units after a scale map |
| --- | --- | --- |
| `z` | Complex Pluecker coordinate and pair-generator coefficient | Energy or mass if it is identified with a rest gap |
| `|z|` | Positive gap scale | Energy |
| `u = z/|z|` | Unit complex phase | Dimensionless |
| Pulse parameter `a` in `exp(-i a K_z)` | Supplied real evolution parameter | Inverse energy, or time with `hbar = 1` |
| Pulse area `a|z|` | Rotation angle | Dimensionless |
| `A` | State overlap | Dimensionless |
| `P = |A|^2` | Survival probability | Dimensionless |

No value in SI units is presently predicted. A physical implementation must
derive or calibrate the map from the finite pair sector and `a|z|` to an actual
Hamiltonian, duration, and measurement channel.

### Input classification

**Derived exactly in the finite model**

- The equal-modulus identity for `z1` and `z2`.
- Exact unitary conjugacy of their one-particle rest operators.
- The two-kick overlap formula.
- The exact probabilities `4/5` and `1`.
- Vacuum invariance under every pair kick.
- Exact realization of the canonical pair operation as the exponential of the
  full-Fock pair generator.

**Supplied or fitted**

- The complex fields `z1` and `z2`.
- The pair-kick interaction and pulse areas.
- The preparation and readout basis.
- The identification of the four finite modes with physical degrees of
  freedom.
- The energy and time scale.

**Held out for a valid benchmark**

Calibrate `|z|`, pulse area, preparation fidelity, and readout fidelity using
phase-blind single-kick data and the equal-field control. Pre-register the
relative phase fixture. The held-out quantity is the two-kick survival
probability for the relative-phase sequence. It must not be used to fit an
additional phase parameter.

### Conventional baseline

The nearest control is a two-channel model specified only by an assigned scalar
mass `m = |z|`. For equal `|z|`, that model predicts no distinction unless an
independent complex interaction phase is added. Therefore:

- beating the scalar-only baseline establishes operational phase retention;
- it does not by itself establish the Pluecker origin of that phase;
- if the baseline is allowed a freely fitted interaction phase, the distinctive
  burden shifts to deriving the same phase from the null-spinor data across the
  free and interacting sectors without another parameter.

The fair comparison fits both models on the same phase-blind calibration data
and scores the pre-registered two-kick result without refitting.

### Positive, boundary, and negative controls

| Control | Expected result | Purpose |
| --- | --- | --- |
| Equal field `u1 = u2` | `P = 1` | Closure and preparation/readout control |
| Relative phase `(3+4i)/5` versus `1` | `P = 4/5` | Nondegenerate positive witness |
| Single kick on a basis pair state | Transition probability depends on `|u|^2 = 1` | Demonstrates why interference is required |
| Vacuum branch | Fixed exactly | Supplies the phase reference |
| Zero pulse area | Identity evolution | Boundary control |
| Nonunitary coefficient choice outside the unit-circle condition | Norm failure | Detects an invalid implementation rather than a phase signal |

### Error model and sensitivity

For `N` independent ideal shots with true probability `P`, the sampling
standard deviation is

```text
sigma_shot = sqrt(P (1-P) / N).
```

For two independently estimated probabilities, use

```text
sigma_Delta = sqrt(P_rel(1-P_rel)/N_rel
                 + P_ctl(1-P_ctl)/N_ctl).
```

With the ideal values `P_rel = 0.8`, `P_ctl = 1`, and equal shot counts, about
`N = 100` shots per setting give an idealized five-standard-deviation separation
of `Delta P = 0.2`. This is only a scale estimate. Real testing must include a
preparation-and-measurement model, pulse-angle uncertainty, phase drift,
leakage from the two-dimensional active sector, and multiple-testing control.
Those systematics will dominate the ideal control's zero binomial variance.

The phase sensitivity is

```text
dP/d(delta theta) = -sin(delta theta) / 2.
```

At the `3-4-5` fixture, `cos(delta theta) = 3/5` and
`|dP/d(delta theta)| = 2/5` per radian. The witness is therefore not at a flat
point of the response curve.

### Falsifier and kill conditions

This observable fails to provide distinctive leverage if any of the following
holds:

1. The phase-covariant selected modular dynamics reduces the constant phase to
   a pure basis choice and supplies no relative link, history, or two-pulse
   quantity.
2. The pair kick cannot be derived as a local operation of the same dynamics
   that produces the one-particle rest operator.
3. A conventional comparator with the same number of independently fitted
   parameters reproduces the held-out result equally well.
4. The effect vanishes after a valid many-body, continuum, or gauge reduction.
5. The physical implementation map requires inserting the relative phase as a
   new free observable parameter rather than inheriting it from `z`.

### Claim ceiling

Allowed claim:

> A kernel-checked finite fermion-pair model retains a relative complex phase
> that is invisible in the equal-modulus one-particle spectrum and exposes it
> through an exact vacuum-referenced two-kick interference probability.

Not allowed yet:

- a Standard Model scattering prediction;
- an observed-particle mass prediction;
- a thermodynamic or continuum modular-flow prediction;
- evidence that nature uses null-spinor Pluecker data;
- a claim that an assigned complex interaction could not reproduce the finite
  probability.

## Next theorem and simulation gates

1. Harvest the running phase-covariant modular-flow job and prove that the
   selected Gibbs/modular generator for arbitrary nonzero `z` is conjugate to
   the real-axis solution with the correct phase orientation.
2. Compose that selected flow with the full-Fock exponential theorem and the
   two-kick observable, eliminating the presently supplied `pairKick` from the
   operational statement.
3. Add a deterministic exact-arithmetic benchmark that emits the two
   probabilities, a parameter manifest, and a hash, while checking the output
   against `witness_survival_probability`.
4. Specify a conventional scalar-only and a freely complex baseline with equal
   parameter budgets before any phenomenological promotion.
5. Only after a physical mode and unit map exists, pre-register a real platform
   or dataset. A generic Ramsey-style two-level or pair-transfer quantum
   simulator is the nearest experimental architecture, not yet a claimed
   realization.

## Formal anchors

- `PhysicsSM/Draft/NullEdge/PlueckerPhaseObservable.lean`
  - `witness_equal_modulus`
  - `witness_conjugate_restOperators`
  - `doubleKick_interference_amplitude`
  - `witness_survival_probability`
- `PhysicsSM/Draft/NullEdge/PlueckerQuarticInteraction.lean`
  - oriented forward/backward pair amplitudes and exact unitary pair kick
- `PhysicsSM/Draft/NullEdge/CanonicalFullFockPairExponential.lean`
  - exact full-Fock exponential realization of the canonical pair operation
- `PhysicsSM/Draft/NullEdge/PairModularSelection.lean`
  - selected modular dynamics and the current separation between supplied and
    derived evolution
- `PhysicsSM/Draft/NullEdge/DYNModularMaxEntCapstone.lean`
  - fixed-phase finite maximum-entropy/modular capstone

No new physical provenance claim is introduced by this role activation. The
artifact reorganizes existing kernel-checked finite results into an explicit
phenomenology contract and records the missing reconstruction steps.
