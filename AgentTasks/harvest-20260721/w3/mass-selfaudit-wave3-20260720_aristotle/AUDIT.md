# Adversarial semantic audit — wave 3

## Scope and method

The supplied project contains the landing names only in the audit request; it does
**not** contain the source declarations or their docstrings. Consequently this is
a stress-test of the quoted claim shapes, not a line-by-line finding about an
unseen theorem signature. `RequestProject/AuditWitnesses.lean` gives Mathlib-only,
kernel-checked witnesses for every semantic distinction below.

Verdict labels:

- **sound**: the quoted mathematical shape survives the proposed degenerate case;
- **over-claim**: the prose asserts more than the displayed/kernel-level shape can
  support;
- **conditional**: sound only after distinguishing two standard meanings that the
  prose currently conflates.

## 1. `PlueckerYukawaModuli` / `YukawaConditionalUniqueness`

**Verdict: over-claim unless the actual phase-fix predicate also fixes a
normalization (or another magnitude datum).** This is
**docstring-outruns-kernel / false-shape**, not merely a nonzero edge case.

A genuinely one-dimensional intertwiner space is not `{0}`: `finrank = 1` rules
that out. If the landing only proves `finrank ≤ 1`, however, the zero-dimensional
case remains and an implication quantified over two *admissible* couplings can be
vacuously true because there are none. The unseen signature is needed to decide
which hypothesis it uses.

More importantly, choosing a phase does not choose magnitude. In the real
one-dimensional model, the convention `0 ≤ x` accepts both `0` and `1`:

- `AuditWitnesses.weak_phase_does_not_give_uniqueness`.

Requiring nonzero would make “phase” defined, but still would not give uniqueness:
positive values of different magnitudes remain. Thus the right repair is not just
`coupling ≠ 0`.

**Sound strengthening/repair:** add a fixed norm/magnitude (often unit
normalization) and then impose the phase convention. The theorem
`AuditWitnesses.phase_and_magnitude_unique` proves this repaired one-dimensional
real model. For a complex line, the analogous statement should fix `‖y‖` and a
phase representative; if a physical coupling may vanish, handle zero separately
rather than assigning it a phase.

## 2. `MechanismMatrixConsistency`

**Verdict: sound for the algebraic claim; no “no fixed vectors” assumption is
needed.** The degenerate grading does not refute the intersection statement.
There is, however, a possible **docstring over-interpretation** if the prose says
this establishes a nontrivial decomposition into two populated sectors.

With the usual definitions

`Γ M = M Γ` (even) and `Γ M = -M Γ` (odd),

setting `Γ = 1` makes every map even, while in characteristic zero the only odd
map is zero. Hence the intersection is still `{0}`:

- `AuditWitnesses.trivial_grading_every_map_even`;
- `AuditWitnesses.trivial_grading_odd_iff_zero`.

This is a degenerate grading, but not a counterexample. An involution is sufficient
because it is invertible/surjective; “no fixed vectors” is irrelevant to the
intersection proof.

**Strengthening:** the involution hypothesis can be weakened. The theorem
`AuditWitnesses.odd_even_intersection_of_surjective` proves that surjectivity of
`Γ` alone suffices (over `ℚ`, hence with `2 ≠ 0`). If the intended prose claims a
nontrivial grading, separately assume/prove that both graded subspaces or
eigenspaces are nonzero; the intersection theorem cannot supply that fact.

## 3. `ResolventResponsePole`

**Verdict: over-claim if “response” means the full matrix/operator or a physical
two-point function.** This is **false-shape / docstring-outruns-kernel**.

An equality for `(0,0)` establishes only one matrix element (equivalently, a
projected response after choosing the corresponding source/probe). It neither
determines the remaining entries nor identifies that entry with a physical
observable unless the observable is separately defined as that projection.

`AuditWitnesses.same_zero_zero_entry_different_full_response` constructs two
`2 × 2` rational matrices with the same prescribed `(0,0)` value
`(z + 1)⁻¹` but different `(1,1)` values, and proves the full matrices unequal.
The same witness works with `(z - 1)⁻¹` substituted for the head entry.

**Repair:** change the prose to “the `(0,0)` matrix element (or selected-channel
response) has denominator `z ± 1`.” To claim a two-point function, define it as a
contraction such as `uᴴ R(z) v` and prove that contraction equals the displayed
scalar. To claim the full response, prove matrix/operator equality entrywise.

## 4. `UniformQuasienergyGap`

**Verdict: `[Nonempty K]` is load-bearing for the intended semantic claim.**
Without it, existence of `δ > 0` satisfying a pointwise lower bound is
**vacuously** true on `K = Empty`.

- `AuditWitnesses.empty_parameter_uniform_margin` proves
  `∃ δ > 0, ∀ k : Empty, δ ≤ gap k` for an arbitrary gap function.
- `AuditWitnesses.uniform_margin_has_pointwise_content` uses `[Nonempty K]` to
  extract an actual parameter `k` whose gap is positive.

So if the landing includes `[Nonempty K]`, the quoted “uniform margin” wording is
sound against this attack. If it omits that instance, the prose over-claims.

**Strengthening:** retain `[Nonempty K]` and expose the nonvacuous consequence
`∃ k, 0 < gap k` (as the second witness does). For stronger analytic content,
under compactness and continuity identify `δ` with a positive minimum, rather
than merely postulating an arbitrary lower bound.

## 5. `SeesawNGeneration`

**Verdict: conditional; the prose must distinguish matrix equivalence/Gaussian
elimination from symmetry-preserving congruence.** As written, this is a likely
**false-shape** over-claim in a Majorana-mass interpretation.

For the block matrix

`[[0, mD], [mDᵀ, MR]]`,

ordinary two-sided block elimination yields the Schur complement
`-mD MR⁻¹ mDᵀ` for every invertible `MR`; this algebraic identity does **not** need
`MR` symmetric. But if “block diagonalization” means a congruence preserving a
symmetric/Majorana bilinear form, then the starting block matrix itself is
symmetric only when `MRᵀ = MR`, and the left and right eliminators are transposes
only with the corresponding symmetry of the inverse.

The concrete witness uses

`MR = [[1,1],[0,1]]`, `MR⁻¹ = [[1,-1],[0,1]]`.

- `AuditWitnesses.nonsymmetricMR_inverse` proves both inverse identities.
- With `mD = 1`, `AuditWitnesses.general_invertible_MR_can_give_nonsymmetric_light_block`
  proves that `-MR⁻¹` is not symmetric.

Thus general invertibility supports the Schur-complement formula as matrix
elimination, but does not by itself support calling the result a symmetric
Majorana light-mass matrix.

**Sound strengthening/repair:** either (a) explicitly call the result a Schur
complement under two-sided equivalence and retain only invertibility, or (b) add
`MRᵀ = MR` for a congruence/Majorana claim. The theorem
`AuditWitnesses.light_block_symmetric_of_inverse_symmetric` proves that the light
block is symmetric whenever the inverse block is symmetric (which follows from
invertible symmetric `MR`).

## Axiom and build report

The project builds with no `sorry`, no `native_decide`, no new `axiom`, and no
`@[implemented_by]`. Kernel axiom inspection of every theorem in
`AuditWitnesses.lean` reports exactly:

- `propext`
- `Classical.choice`
- `Quot.sound`

These are standard permitted axioms. No theorem reports any additional axiom.
