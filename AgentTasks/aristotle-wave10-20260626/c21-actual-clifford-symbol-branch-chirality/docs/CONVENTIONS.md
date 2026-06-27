# Project conventions and convention-lock status

This document records conventions that agents should treat as stable enough to
use by default, plus conventions that are still working choices or explicitly
unlocked. It is intentionally more detailed than `AGENTS.md`; keep only
always-needed pointers in `AGENTS.md` and put living convention detail here.

Status labels:

- Locked: use this convention unless the user explicitly asks for a new audit.
- Working: use this as the current default, but keep theorem statements
  localized so the choice can still be changed.
- Unlocked: do not build strong claims on this yet; state assumptions explicitly.

## Repo-wide mathematical conventions

### Octonions

Status: Locked.

Use the project XOR binary-label convention from
`PhysicsSM.Algebra.Octonion.Basic`.

- Bases: `e000`, `e001`, `e010`, `e011`, `e100`, `e101`, `e110`, `e111`.
- Product index: bitwise XOR of input labels.
- Sign: Fano orientation in `PhysicsSM.Algebra.Octonion.Basic`.
- Anchor products: `e011 * e111 = e100`, `e101 * e111 = e010`,
  `e110 * e111 = e001`.

Do not copy Baez/Furey formulas directly. Use
`PhysicsSM.Algebra.Octonion.ConventionBridge` for relabeling/sign checks.

### Text and Lean hygiene

Status: Locked.

Use UTF-8 without BOM, LF line endings, one final newline, and no trailing
whitespace. In prose, spell Lean placeholder/escape tokens with spaces unless
the literal token is required by executable code, regexes, or tooling.

## Null-edge / null-strand conventions

### Metric signature

Status: Locked.

Use mostly-minus Lorentzian signature:

```text
+(time)^2 - (space)^2
```

Equivalently, null momenta satisfy `p^2 = 0`, and massive on-shell modes satisfy
`p^2 = m^2` in the mostly-minus convention. Any theorem using the opposite
signature must live behind an explicit namespace or conversion lemma.

### Null transport scope

Status: Locked as a program convention.

The null-edge claim concerns primitive spacetime transport:

```text
primitive spacetime propagation is supported on null edges
```

It does not mean every internal field value is made of light. Higgs values may
live on vertices, Yukawa maps may be local fiber maps, and gauge holonomies may
live on edges.

### Dual-soldered Dirac architecture

Status: Locked as the active architecture.

Use null edge directions `ell_a` for support and dual covectors `alpha^a` for
Clifford soldering:

```text
D_N = sum_a c(alpha^a) nabla_{ell_a}
```

Do not use the diagonal architecture as the basic Dirac symbol:

```text
sum_a c(ell_a^flat) nabla_{ell_a}
```

The diagonal architecture has the known trace/symbol obstruction and should only
appear as a documented negative comparison.

### Local frame and covariance

Status: Locked as a P2 architecture convention.

The viable P2 architecture should use local frame data:

```text
ell_a = ell_a(x)
alpha^a = alpha^a(x)
```

Curvature should enter through holonomy around finite null diamonds. Fixed flat
null frames are acceptable for finite algebra tests and branch-count audits, but
not enough for a final relativistic continuum claim. The full continuum theorem
remains an unlocked theorem target, but the architectural convention is locked:
P2 should use local frame and dual-soldering data.

### Super-Dirac square signs

Status: Locked as the current convention. The formal sign audit remains a proof
target, not a convention choice.

Use:

```text
D_N = sum_a C_a nabla_a
D_N^2 = K_h + C_diamond + T_frame
D = i D_N + Gamma_s Phi_H
D^2 = -K_h - C_diamond - T_frame + Phi_H^2
      - i Gamma_s sum_a C_a [nabla_a, Phi_H]
```

The sign of `Phi_H^2` depends on the grading hypotheses. In this convention:

```text
(Gamma_s Phi_H)^2 = +Phi_H^2 iff [Gamma_s, Phi_H] = 0
(Gamma_s Phi_H)^2 = -Phi_H^2 iff {Gamma_s, Phi_H} = 0
```

So `Phi_H` may be odd under the internal grading, but it must commute with
spacetime chirality `Gamma_s` for the displayed `+Phi_H^2` convention.

### Gradings

Status: Locked as a separation rule.

Keep these distinct:

- `Gamma_s`: spacetime chirality.
- `chi_E`: internal grading.
- `epsilon_form`: cochain/form-degree grading.

Do not use form degree or internal grading to silently repair a spacetime
chirality sign error.

### Frame/tetrad defect

Status: Working.

Use:

```text
T_frame = sum_{a,b} C_a [nabla_a, C_b] nabla_b
```

Finite tetrad-postulate target:

```text
[nabla_a, C_b] = 0 for all a,b implies T_frame = 0
```

If frame transport is not compatible, do not hide `T_frame`; classify it as a
frame/tetrad defect, possible torsion/nonmetricity-like term, or continuum
contamination.

### Branch-count / no-doubling test

Status: Locked as an audit rule.

Do not claim no-doubling from coefficient-vector zeros alone. For a flat
retarded symbol:

```text
D_+(q) = sum_a C_a (exp(i q_a) - 1) / h = c(p(q))
```

the physical test is determinant-level:

```text
det D_+(q) = 0
```

or the corresponding mass-shell equation. A nonzero Lorentzian null Clifford
vector can still have kernel.

### Krein / Lorentzian adjointness

Status: Locked as a non-overclaim rule.

Krein `J`-self-adjointness is a necessary Lorentzian audit, not a stability
theorem. It does not by itself imply real spectrum, positivity, unitary
evolution, absence of growing modes, anomaly safety, or chiral imbalance.

## Mass-unification language conventions

### Umbrella language

Status: Locked.

Use:

```text
mass as quadratic obstruction by a canonical obstruction map B
```

Do not use `spectral gap` as the universal slogan. Use `spectral gap` only for
operator spectra, Hessians, Hamiltonians, mass matrices, or Dirac-square
contexts. For P1 Plucker mass, use `finite invariant mass`, `rank-one
obstruction`, `quadratic Plucker obstruction`, or `rest-frame invariant of a
null bundle`.

### Canonical obstruction datum

Status: Locked as a manuscript and task-handoff convention.

A canonical obstruction datum is a pair `(S, B)`, where `S` is a finite
geometric or internal structure and:

```text
B : configuration space(S) -> failure space(S)
```

is a functorial or natural map determined by `S`, not by fitted masses, such
that `ker B` is the massless/gapless/symmetric locus and `B^dagger B` gives the
quadratic obstruction away from that locus.

Every mass claim should identify its `B` and its claim label.

### Current obstruction-map statuses

Status: Locked as a claim ledger unless later theorem work changes it.

```text
B_Pl(Psi) = (psi_i wedge psi_j)_{i<j}
  finite identity; canonical rank-one obstruction

B_Y = M : E_R -> E_L
  reconstruction once the Yukawa block is supplied; predictive only if M is constrained

B_EW(X) = X H_0
  structural theorem given SM electroweak group, Higgs representation, and vacuum section

B_Higgs = radial Hessian or d^2 V at H_0
  scalar-potential reconstruction

B_QCD
  not yet available; QCD remains boundary/motivation
```

### No double counting

Status: Locked.

The Plucker/null-spread term belongs to the kinetic/null-bundle side. The
Higgs/Yukawa term belongs to the internal zero-order side. Operator-level
matching should be:

```text
K_null = Phi_H^2
```

not:

```text
m_Plucker^2 + m_Higgs^2
```

as two additive explanations of the same elementary fermion mass.

### Fermion mass versus W/Z mass

Status: Locked.

Use:

```text
fermion masses live in Phi_H^2
W/Z masses live in |nabla^A H|^2, link stiffness, or Higgs-orbit obstruction
```

Do not put W/Z gauge-boson mass into the same block as the fermion Yukawa
matrix.

### Gauge/Higgs language

Status: Locked as a wording rule.

Avoid saying that a local gauge redundancy literally breaks as an observable
fact. Prefer:

```text
The Higgs field defines a covariant internal reference section.
Holonomies that fail to preserve it acquire quadratic cost.
Stabilizer directions remain gapless.
```

Use FMS-style gauge-invariant composite language when discussing physical W/Z
excitations.

### Claim labels

Status: Locked.

Use these labels in manuscripts and task notes:

- Representation: standard data are placed on null-edge variables without
  reducing freedom.
- Reconstruction: a known mechanism emerges from null-edge primitives, but
  inputs remain free.
- Structural theorem: a qualitative feature is forced once specified algebraic
  inputs are assumed.
- Prediction: a normally-free EFT parameter or structure is fixed or restricted.

P1 and P1.5 are reconstruction/structural theorem papers, not prediction
papers. Prediction begins at the moduli-rank/codimension gate.

## Electroweak conventions

### Structural theorem

Status: Locked for the Standard Model electroweak convention.

Use the Higgs convention:

```text
Y(H) = 1
Q = T_3 + Y/2
H_0 = (0, v / sqrt(2))
B_EW(X) = X H_0
```

Target structural theorem:

```text
ker B_EW = u(1)_em
rank q = 3
```

where `q(X) = |B_EW(X)|^2`.

### Coefficient formulas

Status: Locked as the physics-Hermitian normalization target. The Lean theorem
is still unproved, but the convention choice is no longer open.

The conventional target is:

```text
q(W,B) = v^2/8 * [g^2((W^1)^2 + (W^2)^2) + (g W^3 - g' B)^2]
m_W = g v / 2
m_Z = sqrt(g^2 + g'^2) v / 2
m_gamma = 0
```

Use physics-Hermitian generators for coefficient formulas:

```text
T_i = sigma_i / 2
Y(H) = 1
Q = T_3 + Y / 2
H_0 = (0, v / sqrt(2))
```

The compact mathematical Lie algebra uses anti-Hermitian generators. When a
theorem is stated in anti-Hermitian convention, include an explicit conversion
from the physics-Hermitian convention. Do not silently move factors of `i`
between the generator, the connection, and the covariant derivative.

### FMS/gauge-invariant composites

Status: Unlocked.

The schematic target:

```text
O_e^a = H_s^dagger tau^a U_e H_t
```

requires audit or correction before it is treated as final.

## QCD and hadron mass

Status: Locked as a boundary rule; theorem content unlocked.

Safe sentence:

```text
QCD supplies confinement and dynamics; Plucker supplies invariant accounting.
```

Do not claim the Plucker theorem derives proton mass. Do not define `B_QCD`
until there is an actual finite Hamiltonian or color-holonomy gap theorem, for
example a statement of the form:

```text
H_color^finite restricted to singlets >= Delta > 0
```

under explicit finite graph and boundary assumptions.

## Prediction gate

Status: Locked as a standard of evidence; concrete map unlocked.

Use:

```text
F : M_finite -> M_EFT
```

Prediction requires:

```text
rank(dF) < dim M_EFT
```

or a nontrivial relation:

```text
R(theta_EFT) = 0
```

Simple parameter counting is only a first screen. Redundant coordinates, gauge
choices, and field redefinitions can fake deficits.

## Still not fully locked

The following should not be treated as settled:

- Exact FMS-style finite graph composite for W/Z excitations.
- Full finite-to-continuum symbol and square-limit theorem.
- Determinant-level branch count and no-doubling result.
- Krein physical-sector stability.
- Chiral mechanism: internal chiral representation, domain wall, overlap-like,
  or non-Hermitian/Krein imbalance.
- Anomaly/chirality audit for the full finite construction.
- Any clean finite `B_QCD`.
- Any finite-to-EFT codimension or numerical mass prediction.

When working in these areas, state assumptions locally and keep conclusions
labelled as working, audit, reconstruction, or future prediction gate.

The electroweak coefficient normalization is now locked as a convention, but
the corresponding Lean theorem remains to be proved.
