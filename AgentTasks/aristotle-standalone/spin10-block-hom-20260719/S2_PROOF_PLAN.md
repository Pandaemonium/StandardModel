# Spin(10) selector-chain audit and proof plan

## Outcome at the primary target (S1)

The requested theorem
`Spin10StabilizerTransitivity.evenCliffordGroup_transitive_on_krasnov_pairs`
is false with its stated hypotheses.  The file now retains the original
statement in a block comment and contains the kernel-checked theorem
`not_evenCliffordGroup_transitive_on_krasnov_pairs`.

The explicit witness is

- source pair: `(vacuumSpinor, vacuumSpinor)`;
- target pair: `(vacuumSpinor, weakSpinor)`.

Both source entries and both target entries are pure, and both pairs satisfy
`OrthogonalPureSpinors`.  If the requested conclusion held, the same linear
map would send the equal source entries both to `vacuumSpinor` and to a scalar
multiple of `weakSpinor`.  Evaluation at the empty Fock basis index then gives
`1 = 0`.

The defect is that `OrthogonalPureSpinors` includes both the intended `d = 3`
stratum and the diagonal `d = 5` stratum.  The minimal statement-level repair
is to require both pairs to be projectively distinct.  The file introduces
`ProjectivelyDistinct` for this condition.

## Proven conditional orbit reduction

The file defines `StandardizablePair ψ₁ ψ₂` to mean that an element of the
even Clifford group sends the marked first entry to `vacuumSpinor` and the
projective second entry to `weakSpinor` with nonzero scale.  It proves

`evenCliffordGroup_transitive_on_standardizable_krasnov_pairs`.

Thus all group-composition and scalar bookkeeping needed after normal forms
are available.  The remaining geometric theorem is exactly:

```lean
theorem standardizable_of_genuine_krasnov_pair
    (ψ₁ ψ₂ : FockSpinor)
    (hψ₁ : IsPureSpinor ψ₁) (hψ₂ : IsPureSpinor ψ₂)
    (horth : OrthogonalPureSpinors ψ₁ ψ₂)
    (hdist : ProjectivelyDistinct ψ₁ ψ₂) :
    StandardizablePair ψ₁ ψ₂
```

This is not supplied by `SpinorTenfoldBasisOrbit`: that module establishes
transitivity only for even wedge-monomial basis spinors.  The missing result
requires a general pure-spinor normal form/Witt extension, followed by the
action of the stabilizer of the first pure spinor on the `d = 3` fiber.
Recommended decomposition:

1. Define the annihilator dimension/relative-position invariant for arbitrary
   pure spinors and prove that orthogonality plus projective distinctness gives
   intersection dimension exactly three.
2. Prove marked transitivity on all nonzero pure spinors, not only basis
   monomials:
   `∃ g, g • ψ = vacuumSpinor`.
3. Identify the stabilizer of `vacuumSpinor` and prove it is transitive on pure
   spinors whose annihilator meets the vacuum annihilator in dimension three.
4. Use `scalarUnit_mem` to correct the first marked scale and retain only a
   nonzero projective scale on the second entry.
5. Apply the conditional transitivity theorem already proved.

Useful landed results are
`exists_evenCliffordGroup_smul_basisSpinor`,
`exists_evenCliffordGroup_basisSpinor`,
`exists_evenCliffordGroup_vacuum_weak`, `scalarUnit_mem`, and the concrete
purity/orthogonality lemmas for `vacuumSpinor` and `weakSpinor`.

## S2 (`standard_pair_stabilizer_isomorphic_to_sm`)

The hole remains.  The current imports provide the two abstract group types,
but no homomorphism between them and no stabilizer computation.  The
hypercharge operator only proves the expected infinitesimal eigenvalues; it
does not exponentiate an action or characterize every stabilizer element.
Required sub-results are:

1. Construct a concrete block action homomorphism
   `StandardModelGaugeGroup →* evenCliffordGroup`.
2. Prove its image fixes `vacuumSpinor` and projectively fixes `weakSpinor`.
3. Prove injectivity (including control of the central quotient/kernel).
4. Prove surjectivity onto `MixedPairStabilizerSubgroup vacuumSpinor weakSpinor`
   by a full stabilizer classification.
5. Package the restricted homomorphism as a `MulEquiv`.

## S4 (`physical_embedding_selected_by_krasnov_pair`)

The stated S4 also uses the same overly broad orthogonality condition in its
left side and does not require projective distinctness.  Consequently the
intended proof cannot invoke a corrected S1 without first strengthening S4's
pair witness.  The recommended corrected left side adds
`ProjectivelyDistinct ψ₁ ψ₂`.

After the corrected S1 and S2, add a general conjugation lemma:

```lean
MixedPairStabilizerSubgroup (g • ψ₁) (g • ψ₂) =
  Subgroup.map (MulEquiv.toMonoidHom (MulAut.conj g))
    (MixedPairStabilizerSubgroup ψ₁ ψ₂)
```

(with the orientation adjusted to the project's left action).  Its proof is
pointwise subgroup extensionality, using invertibility of `g`; projective
scales commute with the complex-linear action.  Corrected S1 then reduces an
arbitrary genuine pair to the standard pair, and S2 identifies that standard
stabilizer with the Standard Model gauge group.  The `h_iso` hypothesis in the
current S4 statement is not itself enough to repair the missing orbit-stratum
condition.

## Exceptional Jordan projective geometry

The supporting file currently has three frontier holes, not one:
`F4_transitive_on_good_subalgebra_pairs`,
`standard_block_pair_stabilizer_is_smGaugeGroup`, and
`projective_geometry_main_conjecture`.  Its own handoff notes accurately list
missing F4 actions, orbit transitivity, the octonionic complex splitting, and
the concrete common-stabilizer computation.  No trusted module was modified.

## Verification and axioms

The transitivity target file passes `lake env lean`.  Both the counterexample
theorem and the conditional transitivity theorem use only `propext`,
`Classical.choice`, and `Quot.sound`.  No new axiom, opaque declaration,
unsafe declaration, or native decision procedure was introduced.
