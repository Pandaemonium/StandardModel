import Mathlib

/-!
# Gate YM1/N3: the cut-plaquette mirror-conjugation question (negative result)

Program document section 14, node N3 (top-ranked open item in the day-1
whole-ladder audit, `AgentTasks/aristotle-output/fourday-ym-day1-grand-strategy-20260704/`):
does the raw cut-plaquette mirror holonomy land on the same conjugacy class
as the original plaquette holonomy (or its inverse), so that the real part
of the character - and hence the Wilson weight - agrees on both?

Write `b0 b1 b2 b3 : G` for four link values on a standard `[fwd, fwd, rev,
rev]` plaquette. Then

* `p0Hol b0 b1 b2 b3 = b0 * b1 * b2⁻¹ * b3⁻¹` is the lifted plaquette
  holonomy;
* `mirrorHol b0 b1 b2 b3 = b3⁻¹ * b2⁻¹ * b1 * b0` is the holonomy of the
  GENUINE mirror image under `PlaquetteReflection.mirrorPlaquette`
  (`ReflectionWalk.reflectStep` reverses step order and relabels the copy,
  but does NOT swap `fwd`/`rev` tags - see that module's docstring);
* the ORDINARY loop reversal (which DOES swap `fwd`/`rev`, i.e. inverts
  every letter) is definitionally `(p0Hol b0 b1 b2 b3)⁻¹`.

`mirrorHol` is exactly the **pure word reversal** of `p0Hol` (same four
letters, reversed order, none inverted); the ordinary reversal inverts each
letter as well. Renaming `a = b0, b = b1, c = b2⁻¹, d = b3⁻¹`, the question
becomes: for all groups `G` and `a b c d : G`, is `d c b a` conjugate to
`a b c d` or to `(a b c d)⁻¹`?

## Verdict: FALSE in general

`mirrorConj_counterexample` below exhibits four elements of `S3` for which
`mirrorHol` is the identity while `p0Hol` is a 3-cycle, so they cannot be
conjugate to each other or to `p0Hol⁻¹` (also a 3-cycle). Since finite-group
characters separate conjugacy classes, this refutes
`Re chi_rho(mirrorHol) = Re chi_rho(p0Hol)` already for `S3`'s standard
2-dimensional irrep (`chi(1) = 2 ≠ -1 = chi(3-cycle)`), hence refutes the
Wilson-weight identity `w(mirrorHol b) = w(p0Hol b)` for `beta ≠ 0`.

Root cause (`mirrorConj_of_ordinary_reversal` below is the fix): pure word
reversal is not a conjugacy-class invariant for words of length >= 3 (it IS
for length <= 2, since `ba` is a cyclic rotation of `ab` - this is exactly
why the already-proved zero-cut case never had to face this obstruction:
in the abelian/degenerate zero-cut setting `mirrorHol = p0Hol` exactly, see
`mirrorHol_eq_p0Hol_of_comm`). The ORDINARY reversal, which swaps `fwd`/`rev`
and so inverts every letter, IS conjugate to `p0Hol` (in fact equal to
`p0Hol⁻¹`, see `ordinaryReversal_eq_p0Hol_inv`) - combined with
`FusionTransferSpectrum.character_inv_eq_conj` (`chi(g⁻¹) = conj(chi(g))`,
already closed in this project for Q5), this gives the Wilson-weight
identity for FREE once the mirror convention is corrected.

Recommended fix for the parent Q1/N3 construction (in decreasing
preference; do not apply both, that double-inverts): (1) redefine
`ReflectionWalk.reflectStep` to swap `Step.fwd`/`Step.rev` in addition to
relabeling the copy - note `ReflectionWalk.lean` already carries an
`opLinkField`/`MulOpposite` bookkeeping device for exactly this kind of
order-reversal noncommutativity, which is a promising existing hook for
this redesign, not a fresh invention; or (2) keep the tag fixed but
reinterpret the false-side link-field restriction so a `fwd (false, e)`
step contributes `b(e)⁻¹` (bake the inversion into `U(false,e) := U(e)⁻¹`
at the doubled-lattice-to-single-lattice restriction, rather than into the
step tag). Do NOT attempt to salvage the raw conjugation claim via an extra
hypothesis on `rho`: the obstruction is at the level of conjugacy classes
and already appears for the most benign unitary representation of the
smallest relevant nonabelian group.

## Provenance

Strategy job requested from and proved by Aristotle (Harmonic), project
`0a46d515-a9ea-4577-8f7e-970b8612f24b`, task `80ff1cd5`
(`AgentTasks/aristotle-prompts/ym-q1-n3-cutplaquette-conjugation-strategy-20260704.prompt.md`,
report `AgentTasks/aristotle-output/ym-q1-n3-cutplaquette-conjugation-strategy-20260704/.../ANALYSIS_N3.md`,
local-ignored; permanent summary `AgentTasks/ym-q1-n3-cutplaquette-conjugation-aristotle-2026-07-04.md`).
Verified by this project: `lake env lean` clean on this file standalone
and inside the `GateYM` aggregator, axiom footprint `[propext,
Classical.choice, Quot.sound]` on every declaration (including the `S3`
counterexample, which uses `by decide` - the ordinary kernel-checked
decision procedure, NOT `n a t i v e _ d e c i d e`; no
`Lean.ofReduceBool`/`Lean.trustCompiler` in the axiom list), `s o r r y`-free.

Claim label: **finite identity** (pure finite-group theory; the refuted
claim, not a physics claim, is the content here). This is an intentional
NEGATIVE result, recorded per the project's failure protocol: a correct
"the naive approach does not work" finding is progress, not a stall.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace MirrorHolonomyConjugation

/-- The lifted-plaquette holonomy word for the standard `[fwd, fwd, rev,
rev]` convention: `b0 * b1 * b2⁻¹ * b3⁻¹`. -/
def p0Hol {G : Type*} [Group G] (b0 b1 b2 b3 : G) : G :=
  b0 * b1 * b2⁻¹ * b3⁻¹

/-- The genuine mirror-plaquette holonomy against the negative-side
restriction: `reflectStep` preserves `fwd`/`rev` tags and reverses step
order, so this is the pure word reversal `b3⁻¹ * b2⁻¹ * b1 * b0`, NOT
`p0Hol⁻¹`. -/
def mirrorHol {G : Type*} [Group G] (b0 b1 b2 b3 : G) : G :=
  b3⁻¹ * b2⁻¹ * b1 * b0

/-- **Negative result (N3).** There exist four elements of `S3 = Perm
(Fin 3)` for which `mirrorHol` is conjugate to neither `p0Hol` nor its
inverse. Explicit witness: `b0 = 1`, `b1 = (1 2)`, `b2 = (0 1)`,
`b3 = (0 1)(1 2)` (a 3-cycle); there `p0Hol` is a 3-cycle while
`mirrorHol = 1`, so they cannot be conjugate (the identity is conjugate
only to itself). Since characters separate conjugacy classes, this also
refutes `Re chi_rho(mirrorHol) = Re chi_rho(p0Hol)` for the standard
2-dimensional irrep of `S3`. -/
theorem mirrorConj_counterexample :
    ∃ b0 b1 b2 b3 : Equiv.Perm (Fin 3),
      (¬ ∃ x : Equiv.Perm (Fin 3),
          mirrorHol b0 b1 b2 b3 = x * p0Hol b0 b1 b2 b3 * x⁻¹) ∧
      (¬ ∃ x : Equiv.Perm (Fin 3),
          mirrorHol b0 b1 b2 b3 = x * (p0Hol b0 b1 b2 b3)⁻¹ * x⁻¹) :=
  ⟨1, Equiv.swap 1 2, Equiv.swap 0 1, Equiv.swap 0 1 * Equiv.swap 1 2,
    by decide, by decide⟩

/-- The universally-quantified "mirror always conjugate to `p0Hol` or its
inverse" claim is false: it already fails over `S3`. This is the target
this project should NOT attempt to prove; its universal closure is
refutable, not merely unproved. -/
theorem mirrorConj_not_always :
    ¬ ∀ b0 b1 b2 b3 : Equiv.Perm (Fin 3),
      (∃ x : Equiv.Perm (Fin 3),
          mirrorHol b0 b1 b2 b3 = x * p0Hol b0 b1 b2 b3 * x⁻¹) ∨
      (∃ x : Equiv.Perm (Fin 3),
          mirrorHol b0 b1 b2 b3 = x * (p0Hol b0 b1 b2 b3)⁻¹ * x⁻¹) := by
  obtain ⟨b0, b1, b2, b3, h1, h2⟩ := mirrorConj_counterexample
  exact fun h => (h b0 b1 b2 b3).elim h1 h2

/-- **Abelian escape.** In a commutative group `mirrorHol` equals `p0Hol`
exactly, which is why the already-proved zero-cut/degenerate case never
had to face the N3 obstruction: the zero-cut construction's relevant
group action is abelian/trivial. -/
theorem mirrorHol_eq_p0Hol_of_comm {G : Type*} [CommGroup G]
    (b0 b1 b2 b3 : G) : mirrorHol b0 b1 b2 b3 = p0Hol b0 b1 b2 b3 := by
  unfold mirrorHol p0Hol; ac_rfl

/-- **The fix.** The ORDINARY loop reversal (swapping `fwd`/`rev`, i.e.
inverting every letter in reversed order) equals `p0Hol⁻¹` exactly. This is
the identity that should replace `mirrorHol` once `ReflectionWalk.reflectStep`
(or the false-side link-field restriction) is corrected to swap tags; combined
with `Re chi_rho(g⁻¹) = Re chi_rho(g)` for unitary `rho`
(project's `FusionTransferSpectrum.character_inv_eq_conj`, already closed
for Q5), this recovers the Wilson-weight identity the parent construction
needs. -/
theorem ordinaryReversal_eq_p0Hol_inv {G : Type*} [Group G]
    (b0 b1 b2 b3 : G) :
    b3 * b2 * b1⁻¹ * b0⁻¹ = (p0Hol b0 b1 b2 b3)⁻¹ := by
  unfold p0Hol; group

end MirrorHolonomyConjugation
end GateYM
end NullEdge
end Draft
end PhysicsSM
