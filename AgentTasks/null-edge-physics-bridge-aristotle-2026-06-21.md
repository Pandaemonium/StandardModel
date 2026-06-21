# Aristotle task: null-edge finite physics bridge

## Objective

Fill the proof holes in:

```text
PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean
```

This is an ambitious but finite theorem package for the null-edge causal graph
research program.  The goal is to bridge the existing theorem islands deeper
into physics-facing structure without asserting any continuum limit:

- Plucker/bivector mass as a finite simplicity defect;
- twistor-chart massless projective direction;
- Abelian stacked-diamond Stokes law after an additive defect observable;
- Higgs/Yukawa permission for finite chirality flips;
- observable-relative quotient, gauge, homology, and spectral nullity;
- algebraic Dirac chiral mass-square identity.

## Target file

```text
PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean
```

Expected module:

```text
PhysicsSM.Draft.NullEdgePhysicsBridgeAristotle
```

## Constraints

- No `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or `u n s a f e` in the final target file.
- Do not use `n a t i v e _ d e c i d e`.
- Do not weaken theorem statements merely to close proofs.
- Helper lemmas in this file are welcome.
- Prefer existing imported theorem names before reproving facts.
- Keep the file draft-facing; do not modify trusted definitions or conventions.

## Proof targets

### 1. Bivector/Plucker mass sector

```lean
spinorFanBivectorMass_eq_momentum_det
spinorFanBivectorMass_nonneg
spinorFanBivectorMass_zero_iff_common_direction
twistorFanMass_zero_iff_common_pi_direction
```

Guidance:

- `spinorFanBivectorMass_eq_momentum_det` should be a direct wrapper around
  `fin_bundle_det_eq_ofReal_pluckerMassReal`.
- `spinorFanBivectorMass_nonneg` should use
  `finPairwisePluckerMassReal_nonneg`.
- `spinorFanBivectorMass_zero_iff_common_direction` should combine
  `spinorFanBivectorMass`, `fin_bundle_det_eq_ofReal_pluckerMassReal`, and
  `fin_bundle_mass_zero_iff_common_direction`.  If it is easier, first prove
  `finPairwisePluckerMassReal psi = 0` is equivalent to
  `finPairwisePluckerMass psi = 0`.
- `twistorFanMass_zero_iff_common_pi_direction` is intended to be a wrapper
  around
  `multiTwistorMassSqDetConvention_eq_zero_iff_common_pi_direction`.

### 2. Finite Abelian Stokes / BF-action additivity

```lean
additiveDefect_verticalStack_eq_sum
```

Guidance:

- Use `pathPairDefect_verticalStack_comm`.
- Then induct over the list `Ps`, using `h_one` for the empty stack and
  `h_mul` for the list product.
- The statement is a finite additive shadow of a BF action; no continuum
  Stokes theorem is involved.

### 3. Higgs/Yukawa permission for chirality flips

```lean
permittedChiralityFlip_iff_yukawa_channel
```

Guidance:

- Use `candidateGaugeLegal_iff_exists_yukawaFlip`.
- Forward direction: unpack the Higgs insertion witness, apply the classifier,
  and read off the left/right multiplets.
- Reverse direction: use the candidate associated to the Yukawa flip and the
  existing `candidateOfYukawaFlip_gaugeLegal`.

### 4. Observable-relative nullity diagnostics

```lean
quotient_incidence_internal_edge_eq_zero
exact_two_step_cycle_holonomy_trivial
homology_null_boundary_chain
exact_cochain_is_cocycle
```

Guidance:

- `quotient_incidence_internal_edge_eq_zero`: use `funext`; reduce to integer
  `if` expressions and rewrite `h`.
- `exact_two_step_cycle_holonomy_trivial`: unfold `exactEdgePhase`; `group`
  should close it.
- `homology_null_boundary_chain`: exact wrapper around
  `chainBoundary_simplexBoundary_eq_zero`.
- `exact_cochain_is_cocycle`: exact wrapper around `coboundary_is_cocycle`.

### 5. Low-mode spectral nullity

```lean
realEdgeIncidence_dot_eq_endpoint_difference
rankOne_edge_form_eq_weighted_modeScore
```

Guidance:

- For `realEdgeIncidence_dot_eq_endpoint_difference`, expand `realDot` and
  `realEdgeIncidence`.  The finite sum should collapse by splitting the two
  endpoint cases.  A useful route is `Finset.sum_eq_single` twice, or a lemma
  of the form:

```lean
Finset.univ.sum (fun x => (if x = u then (1 : Real) else 0) * phi x) = phi u
```

- The theorem is true even if `u = v` because the incidence vector was defined
  as a difference of two indicator functions.
- `rankOne_edge_form_eq_weighted_modeScore` follows from the dot theorem and
  `edgeModeScore`.

### 6. Algebraic Dirac mass-gap square

```lean
chiral_mass_square_matrix
chiral_mass_square_on_eigenvector
```

Guidance:

- Expand `(D + m • Gamma) * (D + m • Gamma)`.
- Use distributivity, `h_anti`, and `h_gamma_sq`.
- Matrix scalar multiplication should commute with multiplication over
  `Complex`; if direct rewriting is awkward, use `ext i j` and prove the entry
  identity by ring-style normalization.
- For the eigenvector theorem, first rewrite by `chiral_mass_square_matrix`,
  then use `Matrix.mulVec_add`, `Matrix.mulVec_smul`, `h_eigen`, and the
  identity matrix action on vectors.

## Why this matters physically

This job is meant to turn the program's best finite ideas into one reusable
physics-facing bridge:

- mass equals Plucker/bivector spread;
- gauge curvature is finite diamond disagreement;
- Yukawa/Higgs insertions are the finite permission rule for chirality flips;
- nullity is observable-relative, not an overloaded graph slogan;
- a chiral mass term opens the expected algebraic mass gap.

If Aristotle closes these proofs, the repository has a strong finite scaffold
for a paper section connecting null-edge causal graphs to real relativistic
physics while keeping continuum dynamics honest and conjectural.

## Local validation before submission

```text
lake env lean PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean
```

Result before submission: typechecks with the intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 7852e499-8e63-4ddf-a641-1fb3d261b437
  task_id: 6a507619-8806-4d64-879c-10c603fe83b1
  target_file: PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgePhysicsBridgeAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-physics-bridge-20260621-project
  output_dir: AgentTasks/aristotle-output/7852e499-8e63-4ddf-a641-1fb3d261b437
  status: integrated
```

Submitted 2026-06-21.  `aristotle list` reported the project as `RUNNING`;
`aristotle tasks 7852e499-8e63-4ddf-a641-1fb3d261b437` reported task
`6a507619-8806-4d64-879c-10c603fe83b1` as `QUEUED` immediately after
submission.

Integrated 2026-06-21 after `aristotle tasks` reported task
`6a507619-8806-4d64-879c-10c603fe83b1` as `COMPLETE`.  The conservative
integration helper extracted the expected candidate file, reported no
placeholders, copied it into
`PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean`, and built
`PhysicsSM.Draft.NullEdgePhysicsBridgeAristotle` successfully.
