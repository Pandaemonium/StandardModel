# Aristotle semantic context pack

Generated: 2026-06-26T07:47:21
Query: `null edge conventions locked unlocked super Dirac sign electroweak normalization FMS composite branch count Krein stability chirality anomaly continuum square QCD obstruction prediction gate`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` [14. What remains for a complete origin-of-mass treatment]

Score: `0.786`

```text
ow the sub-eV scale. The null-edge
   reading is therefore "almost pure weak-visible null propagation plus tiny
   hidden chirality/sterile/Majorana bookkeeping," not an explanation of the
   neutrino spectrum. A complete treatment must decide Dirac versus Majorana,
   specify the hidden sector, and recover PMNS mixing and mass ordering.

3. **Separate kinematics from dynamics.** The theorem answers: given a finite
   family of null visible momenta, what invariant mass does the family have? A
   complete theory must also answer why the null pieces are trapped, what
   dynamics fixes their distribution, and how effective Dirac, Higgs, or QCD
   behavior emerges from the underlying graph histories.

4. **Use the Dirac square root as the next structural gate.** The determinant
   mass is a square-level observable. The draft Dirac-slash bridge is therefore
   the right transition to P2: it shows what first-order operator has this mass
   as its square. Without that operator-level sequel, this paper is a beautiful
   invariant identity; with it, the paper becomes the first block of a dynamics
   program.

5. **Audit prior art before submission.** The final manuscript should cite and
   differentiate massive spinor-helicity, two-twistor mass models, Cauchy-Binet
   / Gram determinant identities, spinor-network closure, and the QCD "mass
   without mass" literature. The honest positioning is: known mathematical
   ingredients, newly assembled and formally checked for this null-edge research
   program.

6. **Add the public-facing figures.** The high-school section would benefit from
   three visual anchors: two opposite photons in a box, a fanned celestial sphere
   with total energy versus net momentum, and a theorem-status map showing which
   claims are trusted, draft, or f
```

### 2. `AgentTasks/furey-jbar-su2-anomaly-aristotle-2026-05-29.md` [Sources and claim boundary]

Score: `0.775`

```text
## Sources and claim boundary

Source motivation:

- Cohl Furey, "Charge quantization from a number operator",
  arXiv:1603.04078.
- Cohl Furey, "SU(3)_C x SU(2)_L x U(1)_Y (x U(1)_X) as a symmetry of
  division algebraic ladder operators", arXiv:1806.00612.
- Standard Model anomaly conventions from the local module
  `PhysicsSM.StandardModel.AnomalyPackage`.

Claim boundary:

- This theorem only checks the left-doublet contribution visible in the Jbar
  bridge.
- Do not claim the full one-generation anomaly theorem follows from Furey's
  algebra here.
- Do not claim weak isospin is derived from `Q_op`; the `targetT3` table in
  `ElectroweakBridge` is conventional electroweak input.
```

### 3. `PhysicsSM/StandardModel/AnomalyPackage.lean`

Score: `0.775`

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

Score: `0.770`

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

### 5. `AgentTasks/model-calls/claude/2026-06-24-round-013-adversarial-next-job.md` [Adversarial Critique  ## Verdict: **No, not as currently framed.** Recommend a sharper substitute.  The proposed job looks attractive but it is mostly a re-skinning of three already-tracked P1/P2 resu]

Score: `0.766`

```text
# Adversarial Critique  ## Verdict: **No, not as currently framed.** Recommend a sharper substitute.  The proposed job looks attractive but it is mostly a re-skinning of three already-tracked P1/P2 results with a physics-flavored label. The increment over the bridge we just closed is too small, and the framing imports conventions we have not yet pinned down inside Lean.  ## Hidden convention risks  1. **"Chirality" on a real 2-component screen cell.** Chirality, as standardly understood (γ⁵), lives on 4-component Dirac spinors. On a real 2-vector the only candidate is the eigenvalue ±1 of a chosen reflection — almost certainly R itself. So "R flips chirality" risks being tautological: it says "R swaps the eigenspaces of R." That is not a theorem worth a job. 2. **"P1 Plücker-normalized ray direction" on a 2-component amplitude.** Plücker coordinates classify lines in P³ via wedge of two 4-vectors. The bridge from a real 2-spinor to a Plücker ray is exactly what `null-edge-p1-plucker-observer-scalar-bridge` is supposed to fix. Until that lands cleanly, "preserves the Plücker direction" is undefined. 3. **"Super-Dirac gate" and "one-diamond."** Both are non-finite-algebra terms. "Gate" suggests a unitary; "diamond" suggests a causal step. The job description never says whether the operator is R itself, R composed with a phase, or some new construction. Without a concrete matrix the statement is rhetorical. 4. **Zitterbewegung motivation.** Zitterbewegung arises from ± energy interference in continuous Dirac evolution. Pulling it into a finite reflection calculus risks an overclaim that does not survive review. 5. **Real vs complex screen cell.** P9 second-moment work was on real 2-vectors. Chirality semantics typically demand complex structure. Mixing the two silently is
```

### 6. `Sources/NullStrand_Open_Questions_For_Frontier_Models.md` [6.10 Prediction gate clarification: reconstruction is valuable, rigidity is extra]

Score: `0.764`

```text
y | kinematic identity |
| Diagonal null-symbol obstruction | internal architecture constraint |
| Dual-soldered Dirac symbol | consistency theorem |
| Super-Dirac square | exact finite algebra theorem |
| `Phi^2` sole mass block | consistency condition |
| `P(xi)^2 = m^2` | mass-shell matching, not prediction |
| `g = 2` from Clifford square | inherited Dirac normalization unless Pauli counterterms are forbidden |
| Absence of `O(E/Lambda)` Lorentz-violation terms | potential prediction if exact covariance forbids them |
| Gauge group | potential prediction only if finite algebra is forced |
| Three generations | not currently forced |
| Higgs quartic or mass relation | potential prediction only if `Phi`, `f`, `Lambda`, thresholds, and extra scalars are fixed independently |

The noncommutative-geometry spectral-action precedent is useful but cautionary:
a Dirac/spectral-action framework can unify geometry, gauge, Higgs, and Yukawa
data, but the finite Dirac operator, spectral function, cutoff, threshold fields,
and internal algebra can also become storage locations for the Standard Model
parameters. In this program, reproducing `g = 2` is best treated as a
normalization consistency check unless the null-diamond axioms also forbid an
independent Pauli operator at the cutoff.

The cheapest pressure tests before phenomenology are:

```text
flat-symbol / fermion-doubling test;
graded square sign audit;
Pauli coefficient normalization on one U(1) diamond;
minimal spectral-action trace on a periodic null-diamond complex;
frame-term scaling test;
anomaly cancellation of the proposed internal sector;
parameter-moduli audit;
Lorentz-dispersion expansion through O(h^2).
```

Most important refinement: even if G5b never lands, G5a can still be a strong
result. A clean finite nul
```

### 7. `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md` [Key Findings]

Score: `0.764`

```text
## Key Findings

**1. Chirality-flip→mass.** The 1+1 D Feynman checkerboard rigorously yields the Dirac propagator with mass entering exactly as the per-step chirality-reversal ("corner") amplitude iεm; this is the cleanest realization of the treatise's conjecture and is essentially a theorem. In 3+1 D there is a genuine, recognized obstruction to a naive path-sum (Ord, Jacobson), but several rigorous higher-dimensional constructions now exist: Foster–Jacobson's "Spin on a 4D Feynman checkerboard" (null-faced lattice, Weyl steps as spin projectors, Dirac mass = chirality-flip amplitude iεm, no doubling); the D'Ariano–Perinotti–Bisio–Tosini quantum-walk/QCA derivation on the body-centered-cubic lattice from locality + homogeneity + isotropy + unitarity (mass appears as the off-diagonal coupling between the two Weyl walks); and the Arrighi–Nesme–Forets quantum-walk Dirac construction. In ALL of these, m_eff is proportional to the chirality-mixing rate at small wavevector — strongly supporting the conjecture — but a universality/RG statement that the continuum limit is governed ONLY by ν (independent of microscopic details of the isotropic ensemble) has NOT been proven and is the key open mathematical problem.

**2. Gauge curvature on a causal DAG.** A bare causal DAG has no elementary closed spatial loops (plaquettes) because the order relation is acyclic — this is the precise obstruction. Sverdlov (arXiv:0807.2066) assigns a holonomy f(p,q) = P exp(ie∫_γ A) to each causal pair and recovers field strength from triangle products f(a,b)f(b,c)f(c,a) = 1 + ½ F_μν T (b−a)^μ(c−a)^ν + … integrated over an entire Alexandrov set (causal diamond), not from a single plaquette. The continuum identity any such reconstruction must approximate is the non-Abelian Stokes theorem, whose de
```

### 8. `EXECUTION_PLAN.md` [Milestone 5 — Standard Model gauge structure and representations]

Score: `0.763`

```text
ogy.

**Milestone gate**: Human semantic review of every quantum number assignment
against at least one textbook source (Peskin–Schroeder or Weinberg Vol. 2)
before merge.

**Handedness boundary**: Modules that model only the Krasnov/Baez `O^2`
octonionic-qubit route must not be named or summarized as the full Standard
Model fermion sector. That route currently accounts for a left-handed
one-generation representation only; right-handed fermions and three
generations are explicit open defects. Conventional anomaly modules may use
the standard all-left-handed Weyl convention, where physical right-handed
fermions are represented by their left-handed charge-conjugate fields, but that
is a convention and must be documented at each bridge.

---
```

## Scoped paper hits

### 1. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.765`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 2. Hierarchy of quark masses, Cabibbo angles and CP violation

Score: `0.753`
Zotero key: `AKMVETAK`
DOI: `10.1016/0550-3213(79)90316-X`
URL: https://doi.org/10.1016/0550-3213(79)90316-x

### 3. Confinement of quarks

Score: `0.753`
DOI: `10.1103/physrevd.10.2445`
URL: https://doi.org/10.1103/physrevd.10.2445

### 4. Lattice regularization of reduced Kähler-Dirac fermions and connections to chiral fermions

Score: `0.745`
Zotero key: `8RSBSW7Z`
DOI: `10.21468/scipostphys.16.4.108`
URL: https://doi.org/10.21468/scipostphys.16.4.108

Abstract:

Reduced Kähler-Dirac fermions, mirror sectors, measure phase, and a doubler-free lattice action; source guardrail for the null-edge order-complex fermion branch and no-doubling claims.

### 5. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.738`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548
