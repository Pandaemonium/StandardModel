# Binding gloss for the `Lambda` harvest wave (jobs `f3020ad0`, `8ee92569`, `9dfffca1`, `1ef2a1d8`)

Date: 2026-07-21
Author: Opus / Claude (AFPL co-executor)
Status: **binding on harvest.** Apply this wording when these four artifacts land, before
writing any docstring, mailbox message, or manuscript sentence.

## Why this note exists

Earlier today I wrote a physical gloss around a correct theorem and got it wrong, twice
messaged it to Codex, and had to withdraw it. The theorems were never in doubt. The
sentences were. This note fixes the sentences in advance, while there is no harvest-time
pressure, so the error cannot repeat under it.

## The error, recorded so it is not re-made

**Withdrawn claim:** "a frame-blind (invariant) covariance cannot achieve hyperuniform
suppression of a regional mode, so the everpresent-`Lambda` magnitude cannot be reduced
by hyperuniformity without giving up frame-blindness."

**Why it is wrong:** Torquato's reviews (arXiv:1801.06924, arXiv:1608.02212) *define*
disordered hyperuniform systems as ones that are **statistically isotropic** with no
Bragg peaks. Homogeneous, isotropic, hyperuniform point processes are the central objects
of a large active field. Invariance plainly does not forbid hyperuniformity.

**Why the theorems survive:** the finite hypothesis is `S_N`-invariance, i.e.
**2-transitivity** - every pair of distinct sites equivalent to every other. That is not
physical isotropy. Physical isotropy leaves one pair-orbit *per distance*, an
infinite-rank symmetry with ample room for hyperuniformity. 2-transitivity is the much
stronger condition that the symmetry retains **no notion of separation at all**.

## Approved framing, per job

**`f3020ad0` (Poisson-forcing).** Say: *for a 2-transitive symmetry with fixed total, the
regional number variance is forced to be exactly linear in region size.* Do **not** say
"frame-blindness forces Poisson" without the 2-transitivity qualifier, and do **not**
call `S_N`-invariance frame-blindness or isotropy.

**`8ee92569` (rank dichotomy).** This is the flagship of the wave and the correctly
stated result. Say: *hyperuniformity requires the invariance group to distinguish pairs -
to retain some notion of separation. It is obstructed exactly when the symmetry is so
large that all pairs are equivalent (rank 2).* The cyclic witness is essential and must be
stated alongside the no-go, because it is what shows the theorem is about rank rather
than about invariance.

**`9dfffca1` (compact continuous group).** A generalisation of the orbit-propagation
statement, nothing more. Do not let "continuous group" drift into "Lorentz".

**`1ef2a1d8` (stabilizer-orbit decay).** This is the one aimed at the actual causal-set
mechanism. Say: *correlation at a separation class is suppressed by the size of that
class; when point-stabilizer orbits are large the invariant covariance is driven toward a
multiple of the identity, i.e. white noise.* State explicitly that this is a finite
statement about covariance matrices, **not** a theorem about point processes, sprinklings,
or Lorentz invariance. The prompt deliberately instructs the prover to fix the sign
convention itself; take whatever it proves, do not force my stated form.

## Sentences that are FORBIDDEN across all four

- Any claim that these results block the hyperuniformity escape route for everpresent-`Lambda`.
  They do not. The Lorentz group has the interval as a pair invariant, so it is nowhere
  near rank 2, and the counting obstruction does not apply to it.
- Any claim that these are a finite shadow of the causal-set zero-one laws.
- Any use of "frame-blind" as a synonym for invariant, isotropic, or Lorentz-invariant.
- Any statement deriving the value, sign, or magnitude of `Lambda`.

## The one honest link to the physics, if a link is wanted

The real obstruction in the causal-set setting is the **non-compactness of the boost
orbits**: a fixed spacelike interval sweeps a hyperboloid of infinite invariant measure,
so infinitely many partner points share one correlation value and finite total correlation
drives it to zero. `1ef2a1d8` is the finite quantitative shadow of *that* mechanism - and
it is the only one of the four with a legitimate claim to be near the causal-set argument.
Say "finite shadow of the stabilizer-orbit mechanism", never "shadow of the zero-one laws".

## Standing procedure adopted from this

Run the domain literature search **before** writing the physical gloss, not after landing
the theorem. Both grading errors caught today - this one and the chirality `[orig]`/`[comp]`
error in `AgentTasks/weak-chirality-parity-provenance-2026-07-21.md` - would have been
caught by that ordering.
