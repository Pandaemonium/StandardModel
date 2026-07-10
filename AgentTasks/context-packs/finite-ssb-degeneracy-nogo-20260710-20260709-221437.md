# Aristotle semantic context pack

Generated: 2026-07-09T22:14:43
Query: `finite spontaneous symmetry breaking unique ground state degeneracy symmetry invariant density matrix`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.759`

```text
um).**
  Adopted target, superseding any naive Gauss-sector gap statement (the
  oracle's 2x2-torus discovery stands): define the flux-sector
  decomposition of the Gauss-invariant space, prove the transfer operator
  PRESERVES it, and prove the local plaquette algebra preserves the
  trivial-flux sector. Two named spectral quantities: flux gap vs
  glueball/local gap. `TransferGapDefinition.finiteMassGap` refers to the
  LOCAL gap only. Kill condition (adopted): if the lowest excitation is
  always a global flux sector, the finiteMassGap theorem target must be
  renamed and redefined - no silent substitution.
- **Q4 (finite-group unitarizability; OUT at Aristotle `d4a9bd1f`).**
  Every `FDRep C G` (finite `G`) has a unitary matrix model. Harvest
  checklist in `AgentTasks/ym-gap-unitarizability-aristotle-2026-07-04.md`;
  on integration, strip the matrix-model hypothesis from
  `WilsonVacuumDominance`.
- **Q5 (eigenvalue reality and ordering; medium; after Q4).** The Wilson
  fusion eigenvalues (`FusionTransferSpectrum`) are real for
  inversion-symmetric real weights (proof sketch: `chi(g^-1) =
  conj(chi(g))` from the unitary matrix model of Q4, then the `g -> g^-1`
  reindexing); combined with `|gamma| <= 1` this orders the spectrum below
  the vacuum eigenvalue and feeds the D12 gap definition.
- **Q6 (KP conclusion as an abstract polymer theorem; hard; Aristotle
  strategy job first).** Adopted scoping: do NOT start with full Ursell
  generality. Finite polymer set, finite cluster expansion, tree-graph
  bound, and the tail estimate
  `sum over clusters touching X, distance >= R  <= C_X exp(-m R)`.
  Statement freeze on top of `PolymerKPCriterion.lean` (which froze the
  CONDITION only). This is the single most reusable analysis asset in the
  program (Measure Pro
```

### 2. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [New synthesis: proper time as visible concurrence]

Score: `0.752`

```text
wistor papers
Fedoruk-Lukierski `1403.4127` (`HPP4FME8`) and Deguchi-Okano `1512.07740`
(`7V6SJB4F`). They support a sharper hidden-channel theorem target: the finite
internal label should carry a local `U(1)`/`SU(2)` basis freedom, and the visible
reduced density should be invariant under hidden-basis isometries. This is the
finite algebra now isolated in `PhysicsSM.Draft.NullEdgeDecoherenceChannelAristotle`.

**Lean targets.**

- `visibleDensity_from_orthonormal_internal_purification`;
- `det_visibleDensity_eq_internal_plucker_sum`;
- `visibleReducedDensity_hiddenMix2_eq_pairSpinorFamily`;
- `visibleDet_eq_exteriorGram_weighted_plucker`;
- `partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker`;
- `normalized_mass_ratio_eq_two_sqrt_det_visibleDensity`;
- `mass_ratio_eq_sqrt_linear_entropy`;
- `massless_iff_visibleDensity_rank_one`;
- `restFrame_iff_visibleDensity_maximallyMixed`.
```

### 3. `Sources/Null_Edge_Big_Physics_Inquiry_Development.md` [1.5 Make-or-break computation]

Score: `0.747`

```text
### 1.5 Make-or-break computation

The finite theorem relocates the flavor problem.  It does not solve it.  The
decisive question is whether the internal geometry naturally produces
hierarchical Gram spectra.

Pilot:

1. Choose natural internal states in the `H_3(O)`/Albert layer: primitive
   idempotents, Peirce components, or coherent states on the octonionic
   projective plane.
2. Define a canonical or at least convention-controlled Hermitian pairing.
3. Compute the Gram matrix for natural triples and Higgs-transition channels.
4. Look for forced small parameters, exponential/geodesic suppression, or
   constrained mixing angles.
5. If the spectra are generic `O(1)`, mark the flavor branch as elegant but
   nonpredictive.
```

### 4. `Sources/nrqg-round4-tower.md` [4. Why three generations (Level 5) — new result R4-2: the exceptional continuation]

Score: `0.738`

```text
## 4. Why three generations (Level 5) — new result R4-2: the exceptional continuation

The deepest unexplained pattern in physics: matter comes in three copies, identical except for mass, mixed by the CKM/PMNS matrices. The tower suggests a continuation that is almost forced by its own logic.

**[T] The setup.** Level 2 used $\mathrm{Herm}_2(\mathbb K)$ — the *degree-2* determinant — for spacetime, and Gate I1 showed the physics of that determinant is pairwise concurrence (2-tangle: mass = entanglement of a null pair). Jordan's classification says the $\mathrm{Herm}_n(\mathbb K)$ family has exactly one exceptional member beyond the associative tower: $J_3(\mathbb O) = \mathrm{Herm}_3(\mathbb O)$, the 27-dimensional Albert algebra with its **cubic norm** (degree-3 determinant) and automorphism group $F_4$ (structure group $E_6$). There is no $J_4(\mathbb O)$; the tower has exactly one more rung and then provably stops.

**[C] The conjecture (generation triple).** Spacetime took $\mathrm{Herm}_2(\mathbb C)$; the internal fiber takes the unique exceptional continuation $J_3(\mathbb O)$. Its three primitive idempotents — the three "diagonal directions" of a 3×3 octonionic Hermitian matrix — are the three generations. This is the Todorov–Dubois-Violette / Boyle program, adopted here with a new information-theoretic twist:

**[T] The twist.** Just as $\det_2$ = concurrence (2-tangle), the natural degree-3 invariant of three qubits — Cayley's $2{\times}2{\times}2$ hyperdeterminant — *is* the 3-tangle (Coffman–Kundu–Wootters: $\tau = 4|\mathrm{Det}|$). Degree-2 determinants measure pairwise entanglement; degree-3 determinantal invariants measure genuinely tripartite entanglement. So the tower's pattern reads:

$$
\underbrace{\det{}_2 = \text{mass} = \text{2-tangle}}_{\text{spac
```

### 5. `Sources/NERD_2.md` [1.5 Gate I1 (new, finite-dimensional, Lean-tractable)]

Score: `0.737`

```text
### 1.5 Gate I1 (new, finite-dimensional, Lean-tractable)

1. $\det(p_\mu\sigma^\mu) = p^2$ (soldering determinant).
2. PSD rank-one factorization: future-null $\iff P = \lambda\lambda^\dagger$.
3. Cauchy–Binet mass identity $\det(LL^\dagger) = \sum_{i<j}|\langle ij\rangle|^2$ and its equality with the cross-term expansion.
4. Little-group theorem: stabilizer of $P$ under right action on $L$ is $\mathrm{U}(2)$ (with $\mathrm{SU}(2)$ as the spin part).

Every item is finite matrix algebra. This is the cheapest nontrivial formal target in the entire program and can run in parallel with C1 without touching it.

---
```

### 6. `PhysicsSM/Draft/NullEdgeTwoTwistorHiddenChannelAristotle.lean` [visibleReducedDensity_hiddenMixFinite_entry_eq]

Score: `0.736`

```text
theorem visibleReducedDensity_hiddenMixFinite_entry_eq
    {m n : Nat} (U : Matrix (Fin m) (Fin n) Complex)
    (psi : Fin n -> CSpinor) (hU : FiniteHiddenColumnIsometry U)
    (a b : Fin 2) :
    visibleReducedDensity (hiddenMixFinite U psi) a b =
      visibleReducedDensity psi a b := by
  have lhs_rewrite :
      visibleReducedDensity (hiddenMixFinite U psi) a b =
        Finset.univ.sum (fun k : Fin m =>
          (Finset.univ.sum fun i : Fin n => U k i * psi i a) *
            (Finset.univ.sum fun j : Fin n =>
              starRingEnd Complex (U k j) * starRingEnd Complex (psi j b))) := by
    unfold visibleReducedDensity finBundleMomentum hiddenMixFinite rankOneHermitian
    simp +decide [Matrix.vecMulVec]
    erw [Finset.sum_apply, Finset.sum_apply]
    rfl
  have lhs_fubini :
      visibleReducedDensity (hiddenMixFinite U psi) a b =
        Finset.univ.sum (fun i : Fin n =>
          Finset.univ.sum (fun j : Fin n =>
            (Finset.univ.sum fun k : Fin m =>
              U k j * starRingEnd Complex (U k i)) *
                (psi j a * starRingEnd Complex (psi i b)))) := by
    rw [lhs_rewrite]
    simp only [Finset.sum_mul, Finset.mul_sum]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro i _
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro j _
    apply Finset.sum_congr rfl
    intro k _
    ring
  simp_all +decide [FiniteHiddenColumnIsometry]
  rw [← lhs_rewrite, visibleReducedDensity, finBundleMomentum, Finset.sum_apply,
    Finset.sum_apply]
  unfold rankOneHermitian
  simp +decide [Matrix.vecMulVec]

/--
Finite hidden basis changes preserve the visible reduced density.

This is the high-value proof target in this batch.  Expanding entries reduces
the statement to the column-isometry equations for `U` and finite sum
re
```

### 7. `Sources/Null_Edge_Key_Conjectures.md` [What we have formally proven]

Score: `0.735`

```text
le columns. If all visible spinors are collinear, then `G = I` can have
full rank while the visible determinant is zero. For two labels with
`v_1 wedge v_2 != 0`, the reduced formula above does make masslessness
equivalent to `det(G) = 0`.

There is also a useful negative result for dephasing. The two-label monotonicity
can hold under its hypotheses, but unrestricted `n`-label dephasing
monotonicity is false. A concrete three-label counterexample is:

```text
V = [[1, 0, 1],
     [0, 1, 1]]

G = [[1,   1/5, 1/5],
     [1/5, 1,   1/5],
     [1/5, 1/5, 1  ]]
```

The Gram matrix is positive semidefinite, but `det(V G V^dagger) = 16 / 5`,
while complete hidden-label dephasing sends `G` to `I` and gives
`det(V V^dagger) = 3`. Thus dephasing decreases the determinant in this
example. Any positive theorem for more than two labels needs phase-alignment,
orthogonality, channel, or visible-column hypotheses.

The manuscript should also separate three notions that have been bundled under
"coherence":

```text
hidden-label overlaps       -- entries of G
left/right chirality term   -- off-diagonal Yukawa coherence
visible mixedness/Schmidt   -- reduced observer state impurity
```

They can move in opposite directions, so claims about one should not be used as
evidence about another without an explicit channel theorem.

A clean first-order bridge is the helicity-reduced Dirac/Yukawa two-level
model:

```text
H_h(p) = h |p| sigma_z + m sigma_x
E = sqrt(|p|^2 + |m|^2).
```

The positive-energy projector has off-diagonal left/right coherence
`|m| / (2 E)`. After copying the chirality record to an unresolved environment,
or equivalently dephasing in the chirality basis, the dephased state has

```text
2 sqrt(det(rho_h^dephased)) = |m| / E.
```

This is a precise finite theorem target co
```

### 8. `AgentTasks/context-packs/nullstrand-wave4-fock-bell-20260625-150653.md` [8. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Executive conclusion]]

Score: `0.734`

```text
s
the finite spine for the flavor-overlap/Yukawa-hierarchy proposal. Second,
the normalized determinant identity makes `2 sqrt(det rho_vis) = m/E` a
proper-time-rate/concurrence wrapper, with monotonicity claims restricted first
to explicit unital visible-channel classes and with entangling hidden dynamics
kept
```
```

## Scoped paper hits

No paper hits returned.
