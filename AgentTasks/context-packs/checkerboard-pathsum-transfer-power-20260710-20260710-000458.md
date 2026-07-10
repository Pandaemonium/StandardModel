# Aristotle semantic context pack

Generated: 2026-07-10T00:05:06
Query: `checkerboard finite path sum transfer matrix power direction phases walk recursion`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Spinor/CheckerboardDynamics.lean` [pathWeight_eq_pow_turnCount]

Score: `0.837`

```text
theorem pathWeight_eq_pow_turnCount [Semiring S] (mu : S)
    (d : Direction) (h : List Direction) :
    pathWeight mu d h = mu ^ turnCount d h := by
  induction h generalizing d with
  | nil => simp
  | cons e rest ih =>
      cases d <;> cases e <;>
        simp [turnWeight, turnCount, ih, pow_add, pow_one]

/-! ## Endpoint-side recursion -/

/--
Last-step decomposition of the finite checkerboard path sum.

A path arriving at `(finishX, finishDir)` after `n + 1` steps was previously at
`finishX - finishDir.step`, either already moving in `finishDir` or moving in
the flipped direction and paying one final corner weight.
-/
```

### 2. `PhysicsSM/Spinor/CheckerboardDynamics.lean` [pathSum_last_step]

Score: `0.829`

```text
theorem pathSum_last_step [Semiring S] (mu : S) (startX : Int)
    (startDir : Direction) (n : Nat) (finishX : Int) (finishDir : Direction) :
    pathSum mu startX startDir (n + 1) finishX finishDir
      =
        pathSum mu startX startDir n (finishX - finishDir.step) finishDir
        +
        pathSum mu startX startDir n (finishX - finishDir.step) finishDir.flip
          * mu := by
  induction n generalizing startX startDir finishX with
  | zero =>
      cases startDir <;> cases finishDir <;>
        simp +decide [pathSum, turnWeight] <;> grind
  | succ n ih =>
      rw [pathSum_succ, ih, ih, pathSum_succ, pathSum_succ]
      simp only [mul_add, add_mul, mul_assoc]
      abel

/--
One step of the directed checkerboard evolution acting on a two-component
lattice wavefunction.
-/
```

### 3. `PhysicsSM/Draft/CheckerboardSpinorRecursionAristotle.lean` [pathSum_last_step]

Score: `0.828`

```text
theorem pathSum_last_step [Semiring S] (mu : S) (startX : Int)
    (startDir : Direction) (n : Nat) (finishX : Int) (finishDir : Direction) :
    pathSum mu startX startDir (n + 1) finishX finishDir
      =
        pathSum mu startX startDir n (finishX - finishDir.step) finishDir
        +
        pathSum mu startX startDir n (finishX - finishDir.step) finishDir.flip
          * mu := by
  induction n generalizing startX startDir finishX with
  | zero =>
    cases startDir <;> cases finishDir <;>
      simp +decide [pathSum, turnWeight] <;> grind
  | succ n ih =>
    rw [pathSum_succ, ih, ih, pathSum_succ, pathSum_succ]
    simp only [mul_add, add_mul, mul_assoc]
    abel

/-! ## Target 4: the path sum as an iterated one-step evolution -/

/-- One step of the directed checkerboard evolution acting on a two-component
lattice wavefunction `psi : Int -> Direction -> S`: the component at `(y, e)`
receives the straight continuation from `(y - e.step, e)` and the reversal
from `(y - e.step, e.flip)` weighted by `mu` on the right. -/
```

### 4. `PhysicsSM/Draft/CheckerboardCornerPolynomialAristotle.lean` [pathWeight_eq_pow_turnCount]

Score: `0.816`

```text
theorem pathWeight_eq_pow_turnCount [Semiring S] (mu : S)
    (d : Direction) (h : List Direction) :
    pathWeight mu d h = mu ^ turnCount d h := by
  induction' h with e rest ih generalizing d;
  · cases d <;> simp +decide [ pathWeight, turnCount ];
  · cases h : e == d <;> simp_all +decide [ pow_add, turnCount_cons ];
    cases d <;> cases e <;> tauto

/-- The finite checkerboard path sum is the polynomial in `mu` whose
coefficients count histories with fixed endpoint data and fixed corner count. -/
```

### 5. `PhysicsSM/Draft/CheckerboardSpinorRecursionAristotle.lean` [sequence]

Score: `0.812`

```text
import Mathlib
import PhysicsSM.Spinor.Checkerboard

/-!
# Draft.CheckerboardSpinorRecursionAristotle

Aristotle handoff: the directed-recursion package for the finite 1+1D Feynman
checkerboard of the trusted module `PhysicsSM.Spinor.Checkerboard`.

## Mathematical intent

This is item 1, 2, and 4 of the "next theorem sequence" in
`Sources/Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md`
(research program: `Sources/Luminal_Motion_Checkerboard_Research_Program.md`).
The trusted module already proves the *first-step* decomposition
`pathSum_succ`.  This file targets:

1. basic counting facts about `histories n` (duplicate-free, cardinality
   `2 ^ n`);
2. the corner-weight/corner-count bridge
   `pathWeight mu d h = mu ^ turnCount d h`;
3. the **last-step** recursion (the checkerboard evolution as a function of
   the *endpoint*, which is the discrete 1+1D Dirac equation);
4. the packaging of the path sum as the `n`-fold iterate of a one-step
   two-component evolution operator acting on a delta initial condition;
5. the **discrete Klein-Gordon (telegraph) equation**: each directed
   component of the path sum satisfies a second-order recursion in which the
   mass weight enters only through `mu ^ 2`.  This is the finite, exact form
   of "the Dirac equation is the square root of the telegrapher's equation"
   (Gaveau--Jacobson--Kac--Schulman, Phys. Rev. Lett. 53 (1984) 419).

All statements were validated by brute-force enumeration in
`Scripts/oracle/validate_checkerboard.py` (sections "last-step recursion +
discrete Klein-Gordon"); the oracle justifies the statements, not the proofs.

## Conventions

- A history is a `List Direction` of *future* steps; the incoming direction
  is carried separately, and the corner between the incoming direction and
  the fi
```

### 6. `PhysicsSM/Draft/CheckerboardSpinorRecursionAristotle.lean` [pathWeight_eq_pow_turnCount]

Score: `0.812`

```text
theorem pathWeight_eq_pow_turnCount [Semiring S] (mu : S)
    (d : Direction) (h : List Direction) :
    pathWeight mu d h = mu ^ turnCount d h := by
  induction h generalizing d with
  | nil => simp
  | cons e rest ih =>
    cases d <;> cases e <;>
      simp [turnWeight, turnCount, ih, pow_add, pow_one]

/-! ## Target 3: the last-step recursion (discrete Dirac equation)

The trusted `pathSum_succ` decomposes by the *first* step (source side).
The discrete Dirac equation is the decomposition by the *last* step
(detector side): a path arriving at `(y, e)` after `n + 1` steps was at
`(y - e.step)` after `n` steps, moving either in direction `e` (weight `1`)
or in direction `e.flip` (corner weight `mu`, multiplied on the right since
it is the most recent corner). -/

/-- **Last-step decomposition** of the finite checkerboard path sum. -/
```

### 7. `PhysicsSM/Spinor/CheckerboardDynamics.lean` [pathSum_eq_iterate_evolve]

Score: `0.811`

```text
theorem pathSum_eq_iterate_evolve [Semiring S] (mu : S) (x : Int)
    (d : Direction) (n : Nat) (y : Int) (e : Direction) :
    pathSum mu x d n y e = (evolve mu)^[n] (deltaInit x d) y e := by
  induction n generalizing y e with
  | zero =>
      simp only [Function.iterate_zero, id_eq, deltaInit]
      by_cases h : y = x ∧ e = d
      · obtain ⟨hy, he⟩ := h
        subst hy
        subst he
        simp [pathSum_zero_same]
      · rw [if_neg h, pathSum_zero_ne_pos]
        tauto
  | succ n ih =>
      rw [Function.iterate_succ_apply', evolve, ← ih, ← ih, pathSum_last_step]

/-! ## Discrete Klein-Gordon / telegraph recursion -/

/--
Discrete Klein-Gordon / telegraph equation for each directed checkerboard
component.

Written additively, the finite identity is

```text
psi_{n+2}(y) + psi_n(y)
  = psi_{n+1}(y - 1) + psi_{n+1}(y + 1) + mu^2 psi_n(y).
```

Thus the first-order directed checkerboard recursion squares to a second-order
recursion in which the corner/chirality-flip weight appears only through
`mu ^ 2`.
-/
```

### 8. `PhysicsSM/Spinor/CheckerboardDynamics.lean` [deltaInit]

Score: `0.811`

```text
def deltaInit [Semiring S] (x : Int) (d : Direction) : Int -> Direction -> S :=
  fun y e => if y = x ∧ e = d then 1 else 0

/--
The finite checkerboard path sum is the `n`-fold iterate of the local
two-component evolution rule applied to a delta initial condition.
-/
```

## Scoped paper hits

### 1. Discrete physics and the Dirac equation

Score: `0.738`
Zotero key: `WBGEISNI`
arXiv: `hep-th/9603202`
DOI: `10.1016/0375-9601(96)00436-7`
URL: https://www.zotero.org/19894138/items/WBGEISNI

Abstract:

We rewrite the 1+1 Dirac equation in light cone coordinates in two significant forms, and solve them exactly using the classical calculus of finite differences. The complex form yields ``Feynman's Checkerboard''---a weighted sum over lattice paths. The rational, real form can also be interpreted in terms of bit-strings.

### 2. Relativistic effects and rigorous limits for discrete- and continuous-time quantum walks

Score: `0.732`
Zotero key: `QSB24VR9`
DOI: `10.1063/1.2759837`
URL: https://doi.org/10.1063/1.2759837

### 3. Notes on The Feynman Checkerboard Problem

Score: `0.732`
Zotero key: `7Z3X3HMK`
arXiv: `1012.1564`
URL: https://www.zotero.org/19894138/items/7Z3X3HMK

Abstract:

The Feynman checkerboard problem is an interesting path integral approach to the Dirac equation in `1+1' dimensions. I compare two approaches reported in the literature and show how they may be reconciled. Some physical insights may be gleaned from this approach.

### 4. Connecting the discrete- and continuous-time quantum walks

Score: `0.725`
Zotero key: `XK9ZRDNJ`
DOI: `10.1103/physreva.74.030301`
URL: https://doi.org/10.1103/physreva.74.030301

### 5. Spin on a 4D Feynman Checkerboard

Score: `0.723`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.
