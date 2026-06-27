# Aristotle semantic context pack

Generated: 2026-06-26T08:09:04
Query: `null edge conventions unresolved FMS gauge invariant composite W Z Krein stability chiral mechanism anomaly cancellation continuum square limit Lichnerowicz QCD finite obstruction B_QCD color gap`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `FUTURE_DIRECTIONS.md` [The field]

Score: `0.796`

```text
### The field

The Standard Model anomaly cancellation conditions for a single generation of
left-handed Weyl fermions with hypercharges `Yᵢ` are:

```
[U(1)]³:             Σᵢ Yᵢ³ = 0
[SU(2)]²[U(1)]:      Σᵢ Y(doublets)/2 = 0
[SU(3)]²[U(1)]:      Σᵢ Y(colour triplets)/2 = 0
[grav]²[U(1)]:       Σᵢ Yᵢ = 0
[U(1)][grav]²:       Σᵢ Yᵢ = 0  (same as above for SM)
```

Davighi-Gripaios-Lohitsiri (2020) and subsequent work frame anomaly
cancellation as a system of *Diophantine equations* in the integer hypercharge
assignments. Their "method of chords" constructs infinitely many solutions to
`[U(1)]³ = 0` by treating the cubic equation as a curve and using rational
points. This gives a systematic enumeration of all "anomaly-free" charge
spectra — including exotic ones.

A separate line (Ibanez-Ross 1991, Binetruy-Girardi-Grimm 2000) shows that in
theories with an anomalous U(1), the Green-Schwarz term must cancel the anomaly,
constraining the charges further. The combination of Diophantine methods with
Green-Schwarz constraints gives a classifier for consistent extensions of the
Standard Model.
```

### 2. `PhysicsSM/StandardModel/AnomalyPackage.lean`

Score: `0.796`

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

### 3. `FUTURE_DIRECTIONS.md` [Key references]

Score: `0.795`

```text
### Key references

- Ibanez-Ross (1991) "Discrete gauge symmetry anomalies" — original Diophantine
  framing, *Phys. Lett. B*
- Davighi-Gripaios-Lohitsiri (2020) arXiv:1910.11460 — "Anomaly cancellation
  in the Standard Model with an additional U(1)" — systematic Diophantine approach
- Allanach-Sherrat (2021) arXiv:2108.02227 — "Charge normalisation and anomaly
  cancellation" — recent systematic survey
- Green-Schwarz (1984) — original anomaly cancellation paper
```

### 4. `Sources/Underexplored_Angles_Lit_Review.md` [4. Anomaly Cancellation as a Diophantine/Code Constraint]

Score: `0.791`

```text
## 4. Anomaly Cancellation as a Diophantine/Code Constraint
Beyond treating anomaly cancellation purely as a physics requirement, the next step is to treat it as a **constraint-solving problem over charges**. Recent work frames anomaly equations as Diophantine equations and uses geometric methods such as the method of chords to generate solutions.

* **Why it matters:** This could become a rigorous "checksum" for any candidate particle spectrum produced by COG. Anomaly cancellation is fundamentally a structured arithmetic constraint on allowed charge assignments, akin to a lattice or code condition.
* **Concrete experiment:** Write a small solver that takes candidate COG particle states and computes all local gauge and mixed gravitational anomaly sums. Then make "anomaly-free" a first-class acceptance test.
* **Reference:** [Solving Gauge Anomaly Equations in the Standard Model (arXiv:2111.04148)](https://arxiv.org/pdf/2111.04148)
```

### 5. `Sources/Paper_Draft_v1.md` [5.3 Anomaly cancellation]

Score: `0.784`

```text
### 5.3 Anomaly cancellation

The Standard Model local anomaly cancellation conditions and Witten SU(2)
global anomaly cancellation are verified for one generation
(PhysicsSM.StandardModel.AnomalyCancellation). The family-symmetry
naturality theorem (Section 9) shows these are stable under family
relabelings.

---
```

### 6. `Sources/Null_Edge_Causal_Graph_Next_Wave_2026-06-21.md` [Main research claim after this wave]

Score: `0.783`

```text
## Main research claim after this wave

The strongest current statement is:

```text
Finite bundles of visible null spinor edges have a Lorentz-spinor invariant
mass equal to their total projective angular spread.  Standard Model Higgs
insertions supply the finite representation-theoretic permission for
chirality-changing graph vertices.  Gauge curvature is represented by
causal-diamond holonomy defects, and fermionic graph structure begins with the
order-complex cochain algebra.
```

That is a coherent theorem-first spine for the program.
```

### 7. `AgentTasks/furey-anomaly-cancellation.md` [Mathematical background]

Score: `0.780`

```text
## Mathematical background

Standard Model gauge anomalies occur when symmetries of the classical action are
violated upon quantization by triangular fermion-loop diagrams.  A consistent gauge
theory must satisfy six independent anomaly-cancellation conditions.  For one
generation of left-handed Weyl fermions with gauge group
SU(3)_c × SU(2)_L × U(1)_Y and electric charge Q = T3 + Y/2, the conditions are:

| # | Condition | Equation |
|---|-----------|----------|
| 1 | [grav]²[U(1)_Y] — linear hypercharge | Σ Y = 0 |
| 2 | [U(1)_Y]³ — cubic abelian | Σ Y³ = 0 |
| 3 | [SU(3)]²[U(1)_Y] — mixed colour-hypercharge | Σ_{coloured} Y = 0 |
| 4 | [SU(2)]²[U(1)_Y] — mixed weak-hypercharge | Σ_{SU(2) doublets} Y = 0 |
| 5 | [U(1)_Y]³ in hypercharge (same as 2 but for Y not Q) | already covered |
| 6 | Witten SU(2) global | # SU(2) doublets is even |

Source: Green-Schwarz-West (1985); Bilal arXiv:0802.0634 (lectures on anomalies);
Davighi-Gripaios-Lohitsiri (2020) arXiv:2006.03588 (systematic Diophantine analysis).

**Oracle verification.** The exact rational conditions are numerically verified
below using the electric-charge eigenvalues already kernel-checked in
`MinimalLeftIdeal.lean`, plus an explicitly stated weak-isospin target table.

---
```

### 8. `OPEN_QUESTIONS.md` [Q4.8 — Green–Schwarz anomaly polynomial factorization (string theory level)]

Score: `0.776`

```text
mensional
  super Yang-Mills/string conventions

PhysLean/HEPLean has Lean infrastructure for local anomaly cancellation in
Standard Model settings, but I did not find public Lean code for the
ten-dimensional Green-Schwarz polynomial factorization.

**Difficulty.** Very Hard — research-level.

**Source.** Green–Schwarz (1984) original papers; anomaly-cancellation review
by Bilal arXiv:0802.0634; Polchinski "String Theory" Vol. II, Ch. 10.

---
```

## Scoped paper hits

### 1. LQG vertex with finite Immirzi parameter

Score: `0.742`
Zotero key: `MQRXNUIX`
arXiv: `0711.0146`
DOI: `10.1016/j.nuclphysb.2008.02.018`
URL: http://arxiv.org/abs/0711.0146

Abstract:

Finite-Immirzi spin-foam vertex connecting canonical loop quantum gravity and four-dimensional spin-foam dynamics; source guardrail for linear simplicity and constrained BF-theory language in the null-edge simplicity-defect branch.

### 2. Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation

Score: `0.738`
Zotero key: `N68MN4ET`
arXiv: `hep-lat/9802011`
DOI: `10.1016/S0370-2693(98)00423-7`
URL: https://www.zotero.org/19894138/items/N68MN4ET

Abstract:

It is shown that the Ginsparg-Wilson relation implies an exact symmetry of the fermion action, which may be regarded as a lattice form of an infinitesimal chiral rotation. Using this result it is straightforward to construct lattice Yukawa models with unbroken flavour and chiral symmetries and no doubling of the fermion spectrum. A contradiction with the Nielsen-Ninomiya theorem is avoided, because the chiral symmetry is realized in a different way than has been assumed when proving the theorem.

### 3. Confinement of quarks

Score: `0.737`
DOI: `10.1103/physrevd.10.2445`
URL: https://doi.org/10.1103/physrevd.10.2445

### 4. Comment on 'Gauge networks in noncommutative geometry'

Score: `0.736`
Zotero key: `Q55ZUJSZ`
arXiv: `2508.17338`
DOI: `10.48550/arXiv.2508.17338`
URL: https://arxiv.org/abs/2508.17338

Abstract:

A critique of the gauge-network spectral-action construction arguing that the continuum limit is pure Yang-Mills without a Higgs scalar.

### 5. Absence of Neutrinos on a Lattice. 1. Proof by Homotopy Theory

Score: `0.732`
Zotero key: `CP84QBM4`
DOI: `10.1016/0550-3213(82)90011-6`
URL: https://www.zotero.org/19894138/items/CP84QBM4

Abstract:

It is shown, by a homotopy theory argument, that for a general class of fermion theories on a Kogut-Susskind lattice an equal number of species (types) of left- and right-handed Weyl particles (neutrinos) necessarily appears in the continuum limit. We thus present a no-go theorem for putting theories of the weak interaction on a lattice. One of the most important consequences of our no-go theorem is that is not possible, in strong interaction models, to solve the notorious species doubling problem of Dirac fermions on a lattice in a chirally invariant way.
