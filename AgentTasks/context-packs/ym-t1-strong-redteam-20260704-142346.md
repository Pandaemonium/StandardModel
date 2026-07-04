# Aristotle semantic context pack

Generated: 2026-07-04T14:23:54
Query: `Q1 T1 Wilson reflection positivity strong tier doubledWilsonWeight_eq_ensembleWeight_mirrorConfig mirror holonomy inversion semantic red team`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/SpinorTenfoldCliffordConjAristotle.lean` [Q10_reflectTwist]

Score: `0.796`

```text
theorem Q10_reflectTwist (v : V10) (hv : Q10 v != 0) (u : V10) :
    Q10 (reflectTwist v u) = Q10 u := by
  unfold reflectTwist;
  rw [ sub_eq_add_neg, Q10_add ];
  simp +decide [ Q10_smul, B10_smul_left, B10_smul_right, B10_comm ];
  rw [ show Q10 ( -u ) = Q10 u by
        unfold Q10; simp +decide [ mul_comm ] ;, show B10 v ( -u ) = -B10 v u by
                                          unfold B10; simp +decide [ Finset.sum_add_distrib, mul_add, add_mul, mul_assoc, mul_comm, mul_left_comm ] ;
                                          ring ] ; ring;
  grind

/-
The twisted reflection is an involution.
-/
```

### 2. `PhysicsSM/Spinor/SpinorTenfoldCliffordConj.lean` [Q10_reflectTwist]

Score: `0.796`

```text
theorem Q10_reflectTwist (v : V10) (hv : Q10 v != 0) (u : V10) :
    Q10 (reflectTwist v u) = Q10 u := by
  unfold reflectTwist;
  rw [ sub_eq_add_neg, Q10_add ];
  simp +decide [ Q10_smul, B10_smul_left, B10_smul_right, B10_comm ];
  rw [ show Q10 ( -u ) = Q10 u by
        unfold Q10; simp +decide [ mul_comm ] ;, show B10 v ( -u ) = -B10 v u by
                                          unfold B10; simp +decide [ Finset.sum_add_distrib, mul_add, add_mul, mul_assoc, mul_comm, mul_left_comm ] ;
                                          ring ] ; ring;
  grind

/-
The twisted reflection is an involution.
-/
```

### 3. `PhysicsSM/Spinor/SpinorTenfoldCliffordConj.lean` [B10_reflectTwist]

Score: `0.786`

```text
theorem B10_reflectTwist (v : V10) (hv : Q10 v != 0) (u w : V10) :
    B10 (reflectTwist v u) (reflectTwist v w) = B10 u w := by
  unfold reflectTwist;
  simp +decide [ B10_add_left, B10_add_right, B10_smul_left, B10_smul_right, B10_comm, B10_self, sub_eq_add_neg ] ; ring;
  unfold B10; norm_num [ Finset.sum_add_distrib, mul_comm ] ; ring;
  grind +extAll

/-
The twisted reflection preserves the quadratic form.
-/
```

### 4. `PhysicsSM/Draft/SpinorTenfoldCliffordConjAristotle.lean` [B10_reflectTwist]

Score: `0.786`

```text
theorem B10_reflectTwist (v : V10) (hv : Q10 v != 0) (u w : V10) :
    B10 (reflectTwist v u) (reflectTwist v w) = B10 u w := by
  unfold reflectTwist;
  simp +decide [ B10_add_left, B10_add_right, B10_smul_left, B10_smul_right, B10_comm, B10_self, sub_eq_add_neg ] ; ring;
  unfold B10; norm_num [ Finset.sum_add_distrib, mul_comm ] ; ring;
  grind +extAll

/-
The twisted reflection preserves the quadratic form.
-/
```

### 5. `PhysicsSM/Coding/HammingConstructionAE8Final.lean` [simple_reflection_preserves_roots]

Score: `0.785`

```text
theorem simple_reflection_preserves_roots :
    forall i : Fin 8,
      rootList.Forall (fun v => simpleReflectD i v in rootList) :=
  simpleReflectD_mem_rootList

/-- **Theorem 23.** Weyl reflection is involutive on roots.

For any root `r`, the map `v |-> reflectD r v` is its own inverse on `rootList`:
reflecting twice returns the original vector. This is the standard property
that reflections are involutions.
Proved in `PhysicsSM.Algebra.Octonion.E8WeylBasic`. -/
```

### 6. `PhysicsSM/Spinor/SpinorTenfoldCliffordConj.lean` [theory]

Score: `0.780`

```text
the inverse direction use the involution:
  conjugating `gammaEnd (reflectTwist v u)` by `gammaUnit v` returns
  `gammaEnd u` (`reflectTwist_reflectTwist`), which inverts the relation.

Do not change any definition or sign convention of
`PhysicsSM.Spinor.SpinorTenfoldCliffordGroup` or the trusted Fock/CAR
layer. Helper lemmas are welcome. No `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`,
`u n s a f e`, and **no `n a t i v e _ d e c i d e`** in the final state.

This is draft code: the statements below contain documented `s o r r y`s and
must not be imported from trusted code until the holes are eliminated.
-/
```

### 7. `PhysicsSM/Draft/SpinorTenfoldCliffordConjAristotle.lean` [theory]

Score: `0.780`

```text
l`); for the inverse direction use the involution:
  conjugating `gammaEnd (reflectTwist v u)` by `gammaUnit v` returns
  `gammaEnd u` (`reflectTwist_reflectTwist`), which inverts the relation.

Do not change any definition or sign convention of
`PhysicsSM.Spinor.SpinorTenfoldCliffordGroup` or the trusted Fock/CAR
layer. Helper lemmas are welcome. The final state should contain no
placeholder proof commands, no new assumptions, and no forbidden declarations.

This draft file now contains kernel-checked proofs of the submitted targets.
-/
```

### 8. `Sources/CodeLatticeE8_Remaining_Migration_Handoff.md` [6. Weyl Cluster]

Score: `0.777`

```text
### 6. Weyl Cluster

Status: the basic reflection-closure layer is promoted as:

```text
CodeLatticeE8/E8/WeylReflections.lean
```

Current promoted declarations include:

- `WeylReflections.reflectionCoeff`;
- `WeylReflections.reflect`;
- `WeylReflections.dot_div_four_of_isE8Root`;
- `WeylReflections.reflect_preserves_IsE8Root`;
- `WeylReflections.reflect_involutive_of_isE8Root`;
- `WeylReflections.dot_mod_four_eq_zero_of_mem`;
- `WeylReflections.reflect_mem_rootList`;
- `WeylReflections.reflect_reflect_of_mem`;
- `WeylReflections.reflect_self_eq_neg_of_normSq`;
- `WeylReflections.reflect_self_eq_neg`;
- `WeylReflections.normSq_reflect_of_mem`.

The remaining Weyl work is the richer permutation/orbit material.

Targets:

```text
CodeLatticeE8/E8/WeylOrbit.lean
CodeLatticeE8/E8/WeylPermutations.lean
```

Likely source files:

```text
PhysicsSM/Algebra/Octonion/E8WeylBasic.lean
PhysicsSM/Algebra/Octonion/E8WeylOrbit.lean
PhysicsSM/Algebra/Octonion/E8WeylOrbitConvergence.lean
PhysicsSM/Algebra/Octonion/E8WeylPermutations.lean
PhysicsSM/Algebra/Octonion/E8WeylPublication.lean
PhysicsSM/Draft/E8WeylSemanticAristotle.lean
```

Goal:

- package the verified Weyl-reflection and orbit material as an E8-structure
  strengthening;
- keep it separate from the central Construction A theorem chain so it does
  not block the paper package.

Guidance:

- Port this after `Roots.lean` and `RootBridge.lean` are stable.
- Prefer root-list based statements to octonion-specific statements unless the
  octonion interpretation is essential.
- The manuscript can cite this as an appendix-level strengthening.
- Watch for large finite computations.  If retained, document the trust
  profile.
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.716`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. Massive relativistic particle model with spin from free two-twistor dynamics and its quantization

Score: `0.710`
Zotero key: `zotero:2T3HC5NC`
arXiv: `hep-th/0510161`
DOI: `10.1103/PhysRevD.73.105011`
URL: https://doi.org/10.1103/PhysRevD.73.105011

### 3. Massive twistor particle with spin generated by Souriau-Wess-Zumino term and its quantization

Score: `0.709`
Zotero key: `arxiv:1403.4127`
arXiv: `1403.4127`
DOI: `10.1016/j.physletb.2014.04.059`
URL: http://arxiv.org/abs/1403.4127

Abstract:

Two-twistor action for a massive spinning particle with Souriau-Wess-Zumino spin term; includes spin-dependent twistor shift modifying standard Penrose incidence relations.

### 4. From Twistor-Particle Models to Massive Amplitudes

Score: `0.708`
Zotero key: `zotero:J5GA3CQ8`
arXiv: `2203.08087`
DOI: `10.3842/SIGMA.2022.045`
URL: http://arxiv.org/abs/2203.08087

### 5. Single twistor description of massless, massive, AdS, and other interacting particles

Score: `0.703`
Zotero key: `zotero:NFHRVF2Q`
arXiv: `hep-th/0512091`
DOI: `10.1103/PhysRevD.73.064002`
URL: https://doi.org/10.1103/PhysRevD.73.064002
