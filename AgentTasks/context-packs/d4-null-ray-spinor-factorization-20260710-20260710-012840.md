# Aristotle semantic context pack

Generated: 2026-07-10T01:28:55
Query: `D4 axial null rays explicit Pauli spinor rank one factorization Hopf map`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Spinor-helicity rank-one factorization]

Score: `0.844`

```text
### Spinor-helicity rank-one factorization

`PhysicsSM.Draft.SpinorHelicityRankOneAristotle` proves the complex
rank-one factorization of future null 4-momenta.

`PhysicsSM.Draft.SpinorHelicityQuaternionAristotle` extends the analogous
idea to the quaternionic 6-dimensional case.

These modules remain useful bases for adjacent Pluecker, twistor, and
null-step theorem packages.
```

### 2. `PhysicsSM/Draft/SpinorHelicityRankOneAristotle.lean`

Score: `0.827`

```text
import Mathlib

/-!
# Draft.SpinorHelicityRankOneAristotle

Aristotle handoff: the spinor-helicity rank-one factorization of null
4-momenta over the complex numbers -- `p` is null and future-pointing iff
`sigma . p = lambda lambda^dagger` for some 2-spinor `lambda`.

## Mathematical intent

WP6a of `Sources/Luminal_Motion_Checkerboard_Research_Program.md` (the
`K = C`, spacetime dimension 4 case of the division-algebra spinor-helicity
correspondence `Spin(d-1,1) = SL(2,K)` for `K = R, C, H, O` in
`d = 3, 4, 6, 10`; the octonionic case will connect to the
`PhysicsSM.Spinor.SpinorTenfold*` pure-spinor layer in a later wave).  This
is the algebraic heart of the "spinor = null direction" coincidence that the
checkerboard program exploits: the 2x2 Hermitian matrix of a 4-vector has
Minkowski-norm determinant, and the null future-pointing vectors are exactly
the rank-one positive matrices `lambda lambda^dagger`.

Source: standard spinor-helicity folklore (e.g. Baez--Huerta, "Division
Algebras and Supersymmetry II", arXiv:1003.3436, Section 2); clean-room
formalization from the mathematical definitions.

## Conventions

- Metric signature `(+, -, -, -)`; `p 0` is the time component.
- `minkHerm p = p0 * 1 + p1 * sigmaX + p2 * sigmaY + p3 * sigmaZ`, i.e.
  `!![p0 + p3, p1 - i p2; p1 + i p2, p0 - p3]`.
- `rankOne lam = lam lam^dagger`, i.e. `(rankOne lam) i j = lam i * conj (lam j)`
  (via `Matrix.vecMulVec lam (star lam)`).
- "Null" is stated as `(p 0)^2 = (p 1)^2 + (p 2)^2 + (p 3)^2` and
  "future-pointing" (weakly) as `0 ≤ p 0`.

## Proof guidance

- `minkHerm_apply_*` and the Hermitian/trace/determinant targets are
  entrywise computations: `ext`/`fin_cases`, `simp [Matrix.det_fin_two, ...]`,
  `Complex.ext_iff`, `push_cast`, `ring`.
- `minkHerm_momentumOf`: entrywise; `Comp
```

### 3. `PhysicsSM/Draft/SpinorHelicityQuaternionAristotle.lean` [minkHermQ_rankOne_of_zero]

Score: `0.817`

```text
theorem minkHermQ_rankOne_of_zero (p : Fin 6 → ℝ)
    (hnull : (p 0) ^ 2
      = (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2 + (p 4) ^ 2 + (p 5) ^ 2)
    (hp0 : 0 ≤ p 0) (hz : p 0 + p 5 = 0) :
    minkHermQ p = rankOneQ ![0, ((Real.sqrt (2 * p 0) : ℝ) : ℍ[ℝ])] := by
  ext i j
  · fin_cases i <;> fin_cases j <;> simp +decide [*, minkHermQ, rankOneQ]
    · unfold quatOf
      simp +decide [show p 5 = -p 0 by linarith] at *
      nlinarith
    · unfold quatOf; nlinarith!
    · ring; norm_num [hp0]; linarith
  · fin_cases i <;> fin_cases j <;> simp +decide [minkHermQ, rankOneQ]
    · norm_num [show p 5 = -p 0 by linarith, quatOf] at *
      nlinarith
    · unfold quatOf; nlinarith
  · fin_cases i <;> fin_cases j <;> simp +decide [minkHermQ, rankOneQ]
    · unfold quatOf; nlinarith
    · exact eq_zero_of_mul_self_eq_zero (by nlinarith!)
  · fin_cases i <;> fin_cases j <;> simp +decide [minkHermQ, rankOneQ]
    · unfold quatOf; nlinarith!
    · unfold quatOf
      nlinarith! [sq_nonneg (p 1), sq_nonneg (p 2), sq_nonneg (p 3), sq_nonneg (p 4)]

/-- **Quaternionic spinor-helicity rank-one factorization.**  A real
6-vector is null and future-pointing iff its quaternionic Hermitian matrix
is a rank-one bispinor `lam lam^dagger`. -/
```

### 4. `AgentTasks/spin10-fierz-cayley-chart-aristotle-2026-06-09.md` [Mathematical intent]

Score: `0.808`

```text
## Mathematical intent

This is the bridge from the Spin(10) pure-spinor equations to the affine
Cayley-plane D5 chart. It is the most direct route from the Fock spinor model
to the geometric statement that `(1, psi, q(psi, psi))` is rank one.
```

### 5. `PhysicsSM/Draft/SpinorHelicityQuaternionAristotle.lean` [is]

Score: `0.805`

```text
import Mathlib

/-!
# Draft.SpinorHelicityQuaternionAristotle

Aristotle handoff (wave 2): the quaternionic spinor-helicity rank-one
factorization -- the `K = H`, spacetime dimension 6 case of the
division-algebra correspondence.

## Mathematical intent

WP6 of `Sources/Luminal_Motion_Checkerboard_Research_Program.md`, second
rung of the ladder `K = R, C, H, O` in `d = 3, 4, 6, 10` (the complex
`d = 4` case is `PhysicsSM.Draft.SpinorHelicityRankOneAristotle`, proved in
wave 1; the octonionic `d = 10` case will connect to
`PhysicsSM.Spinor.SpinorTenfold*` in a later wave).  A real 6-vector in
signature `(+,-,-,-,-,-)` is encoded as the 2x2 quaternionic Hermitian
matrix

`minkHermQ p = !![p0 + p5, q; star q, p0 - p5]`,  `q = p1 + p2 i + p3 j + p4 k`,

and the theorem is that `p` is null and future-pointing iff
`minkHermQ p = lam lam^dagger` for a quaternionic 2-spinor `lam`.  The
quaternionic case is the genuine stress test of the formalism short of
octonionic nonassociativity: `H` is noncommutative, so there is no
determinant, and the null condition must be carried by the explicit
Minkowski norm.

Source: standard division-algebra spinor folklore (Baez--Huerta,
arXiv:1003.3436, Section 2); clean-room formalization.  All statements were
validated numerically (`Scripts/oracle/validate_checkerboard.py`, section
"quaternionic rank-one").

## Conventions

- Signature `(+,-,-,-,-,-)`; `p 0` is time; components `p 1 .. p 4` fill
  the quaternion `quatOf p`; `p 5` is the remaining spatial direction on
  the diagonal.
- `rankOneQ lam = Matrix.vecMulVec lam (star lam)`, so
  `(rankOneQ lam) i j = lam i * star (lam j)` -- the order matters over
  `H`; this is the Hermitian order.
- "Null" is `(p 0)^2 = (p 1)^2 + (p 2)^2 + (p 3)^2 + (p 4)^2 + (p 5)^2`;
  "future-pointing" (weakly) i
```

### 6. `PhysicsSM/Draft/SpinorHelicityRankOneAristotle.lean` [momentumOf_nonneg]

Score: `0.804`

```text
theorem momentumOf_nonneg (lam : Fin 2 → ℂ) : 0 ≤ momentumOf lam 0 := by
  exact div_nonneg ( add_nonneg ( Complex.normSq_nonneg _ ) ( Complex.normSq_nonneg _ ) ) zero_le_two

/-! ## Target 3: the rank-one factorization theorem -/

/-
**Spinor-helicity rank-one factorization** (`K = C`, `d = 4`).  A real
4-vector is null and future-pointing iff its Hermitian matrix is a rank-one
bispinor `lambda lambda^dagger`.
-/
```

### 7. `PhysicsSM/Spinor/SpinorTenfoldFierz.lean` [Q10_gammaBilinear_self_eq_zero]

Score: `0.803`

```text
theorem Q10_gammaBilinear_self_eq_zero
    {psi : FockSpinor} (hpsi : IsEvenSpinor psi) :
    Q10 (gammaBilinear psi psi) = 0 :=
  Q10_gammaBilinear_eq_zero_of_clifford (fierz_clifford hpsi)

/-- **Unconditional Proposition 1(b)**: every positive-chirality spinor maps
to a rank-one point `(1, ψ, q(ψ, ψ))` in the `D₅` chart — the affine chart of
the complex Cayley plane is the graph of the gamma-bilinear square, and the
`D = 10` SUSY identity is exactly the equation defining that chart. -/
```

### 8. `PhysicsSM/Draft/SpinorHelicityQuaternionAristotle.lean` [momentumOfQ_nonneg]

Score: `0.802`

```text
theorem momentumOfQ_nonneg (lam : Fin 2 → ℍ[ℝ]) :
    0 ≤ momentumOfQ lam 0 := by
  have h0 : (0 : ℝ) ≤ normSq (lam 0) := normSq_nonneg
  have h1 : (0 : ℝ) ≤ normSq (lam 1) := normSq_nonneg
  simp only [momentumOfQ, Matrix.cons_val_zero]
  linarith

/-! ## Target 3: the rank-one factorization theorem (`K = H`, `d = 6`) -/

/-- Forward construction, generic case `0 < p 0 + p 5`: the explicit spinor
whose rank-one bispinor is `minkHermQ p`. -/
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.770`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. Spin on a 4D Feynman Checkerboard

Score: `0.747`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 3. Locality properties of Neuberger's lattice Dirac operator

Score: `0.735`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 4. On the Dirac Theory of Spin 1/2 Particles and Its Non-Relativistic Limit

Score: `0.732`
Zotero key: `NFMI3A99`
DOI: `10.1103/physrev.78.29`
URL: https://doi.org/10.1103/physrev.78.29

### 5. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.731`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039
