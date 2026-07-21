# Adversarial audit job: stress-test the Opus origin-of-mass landings for over-claim

Type: adversarial semantic audit + any Mathlib-only counterexample you can prove.
Independent cross-check of a set of kernel-checked "obstruction/classification"
theorems, to prevent self-certification. For EACH claim below, decide whether it
suffers any of the four over-claim modes and, if so, prove a Mathlib-only witness:
- **vacuity**: hypotheses that no explicit model satisfies (the theorem is empty);
- **hollow telescoping**: a triviality dressed as depth;
- **docstring-outruns-kernel**: the prose claims more than the statement proves;
- **false shape**: a kernel-checked statement that is not the intended mathematics.

## The claims (each is kernel-checked, standard three axioms)

1. `gap_does_not_fix_pole`: there exist two unitarily conjugate Hermitian
   involutions of ℂ² (same spectrum {-1,+1}) with physical weight
   `(1-H)/2` at entry (0,0) equal to 1 vs 0. Intended reading: an internal
   spectral gap does not determine the physical two-point weight.
   ADVERSARIAL QUESTION: is `physWeight H = ((1-H)/2) 0 0` actually the residue of
   `⟨e0,(z-H)⁻¹ e0⟩` at z=-1 for a Hermitian involution, or does the docstring
   overclaim the physical interpretation? Prove or refute
   `physWeight H = residue` for the two witnesses.
2. `transfer_gap_does_not_fix_correlation_mass`: `⟨v, Tⁿ v⟩ = 2ⁿ+1` for
   `v=(1,1)` but `=1` for `v=(0,1)`, with `T=diag(2,1)`. Intended: composite-mass
   readout is observable dependent. QUESTION: is the "constant correlation" for
   vDark genuinely mass-zero, or is `C(n)=1` compatible with a nonzero connected
   mass? Check whether the claim "sees none of the gap" is precise.
3. `MassResponseNonOverlap`: Γ-odd ⊥ Γ-even in Hilbert-Schmidt, but even/even not
   orthogonal. QUESTION: is the odd/even orthogonality genuinely the fermion-vs-
   gauge/Higgs non-overlap, or does it need a hypothesis that fails for the actual
   response operators?
4. `SharedHiggsScalarSharingNoGo`: identical bosonic data, different fermion
   sector; scalar sharing preserves Yukawa freedom. QUESTION: does the no-go
   depend on the specific `flavorMassTerm` encoding, or is it robust to any
   reasonable fermion-mass functor?
5. `PlueckerYukawaModuli`: two equivariant couplings with equal Frobenius norm and
   determinant. QUESTION: do Frobenius norm + determinant actually exhaust the
   "Plücker modulus data", or could a finer Plücker invariant distinguish them
   (making the no-go weaker than claimed)? Check singular values.

## Success criteria

For each of the five: a verdict (SOUND / OVER-CLAIM-MODE-X) with a one-line
justification, and for any over-claim a Mathlib-only witness. If all five are
sound, prove at least one STRENGTHENING (e.g. claim 1's `physWeight = residue`
identity, or claim 5's equal-singular-values fact) that upgrades a docstring
assertion to a kernel fact. Report axioms.
