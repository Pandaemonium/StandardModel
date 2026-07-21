# Spin(10) standardizable-pairs status

## Completed work

* Added `commonAnnihilator` and `annihilatorIntersectionDim`, the requested
  arbitrary-spinor relative-position invariant.
* Added `vacuumStabilizer`, the subgroup fixing `vacuumSpinor` exactly, and
  `InVacuumThreeFiber`, the requested formulation of its `d = 3` pure-spinor
  fiber.
* Reduced `evenCliffordGroup_transitive_on_genuine_krasnov_pairs` to two
  applications of `standardizable_of_genuine_krasnov_pair` followed by the
  already proved conditional transitivity theorem.  Thus target 3 contains no
  direct proof hole, but is not yet an unconditional proof because target 2
  remains unproved.
* No target statement was changed.  In particular, marked transitivity was
  not weakened to transitivity up to scalar.

## First blocker

The first unresolved geometric result is the Chevalley incidence theorem
connecting the existing coordinate definition of `IsPureSpinor` to the new
annihilator invariant:

```lean
theorem annihilatorIntersectionDim_eq_three_of_genuine
    (ψ₁ ψ₂ : FockSpinor)
    (hψ₁ : IsPureSpinor ψ₁) (hψ₂ : IsPureSpinor ψ₂)
    (horth : OrthogonalPureSpinors ψ₁ ψ₂)
    (hdist : ProjectivelyDistinct ψ₁ ψ₂) :
    annihilatorIntersectionDim ψ₁ ψ₂ = 3
```

The imported development defines purity as nonzero positive chirality plus
`gammaBilinear ψ ψ = 0`, but does not yet prove the needed general facts that
its annihilator is a maximal 5-dimensional isotropic subspace, that the
orthogonality equation forces intersection dimension at least 3, or that an
intersection of dimension 5 forces the two pure spinors to be projectively
equal.  Existing annihilator results only compute the vacuum case.

After that incidence theorem, the next independent orbit result required by
the roadmap is:

```lean
theorem vacuumStabilizer_transitive_on_three_fiber
    (ψ : FockSpinor) (hψ : InVacuumThreeFiber ψ) :
    ∃ g : vacuumStabilizer, ∃ c : ℂ, c ≠ 0 ∧
      g.val.val.val ψ = c • weakSpinor
```

This is not available from `SpinorTenfoldBasisOrbit`: that module proves the
orbit result only for wedge-basis monomials, whereas this statement concerns
arbitrary pure spinors.

## Remaining holes and soundness

The only remaining `sorry` terms in
`PhysicsSM/Draft/Spin10StandardizablePairs.lean` are targets 1 and 2:

1. `exists_evenCliffordGroup_smul_eq_vacuum`;
2. `standardizable_of_genuine_krasnov_pair`.

Consequently target 3 currently depends transitively on Lean's `sorryAx`
through target 2 and must not yet be described as kernel-proved.  No new
axiom, opaque declaration, unsafe declaration, or `native_decide` was added.
The file elaborates successfully with the two documented holes.
