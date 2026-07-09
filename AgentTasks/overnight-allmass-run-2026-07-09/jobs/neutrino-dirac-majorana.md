# claude-neutrino-dirac-majorana — the Dirac/Majorana distinction as a null-edge structure

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Extend the particle table to neutrinos: the Dirac-vs-Majorana question is a null-edge structural
statement. A DIRAC neutrino has independent particle and antiparticle (two distinct null-edge
zigzags related by CPT); a MAJORANA neutrino is its OWN antiparticle (the CPT-conjugate zigzag IS
the same state -- a self-conjugate constraint). Prove the finite distinction, tied to the landed
CPT operator (Theta) and the seesaw.

## The model (explicit rational/real 4x4; reuse the CPT structure)

CPT operator `Theta v = R * conj v` (antiunitary, involutive, `R = Gamma . J`) as in the finite
CPT carrier. A neutrino state `psi`. Mass terms: Dirac `m_D` (connects psi to a distinct partner),
Majorana `m_M` (connects psi to its OWN CPT-conjugate `Theta psi`).

## Targets

1. `dirac_two_states`: a Dirac mass couples `psi` to an INDEPENDENT partner `psi'` (particle !=
   antiparticle): exhibit the Dirac mass matrix `M_D` connecting two distinct null-edge sectors,
   with `Theta psi != psi` (the antiparticle is a different state). The two null-edge zigzags are
   independent.
2. `majorana_self_conjugate` (payload): a Majorana mass imposes the SELF-CONJUGATE constraint
   `Theta psi = psi` (up to phase) -- the particle IS its own antiparticle. Prove that the Majorana
   mass term `M_M` is nonzero ONLY on the Theta-invariant (self-conjugate) subspace, and exhibit an
   explicit Theta-invariant witness (`Theta psi = psi`) on which `M_M` acts, vs a non-invariant
   state on which it vanishes.
3. `lepton_number`: the Dirac mass PRESERVES a U(1) (lepton number -- the relative phase of psi vs
   psi'), the Majorana mass BREAKS it (relates psi to conj psi): prove `M_D` commutes with the
   phase generator `Q` while `M_M` does not (`[M_D, Q] = 0`, `[M_M, Q] != 0`), on explicit
   rational witnesses.
4. `neutrino_verdict`: package -- Dirac neutrino = two independent null-edge zigzags (lepton number
   conserved); Majorana neutrino = a single self-CPT-conjugate zigzag (lepton number violated);
   the distinction is whether the CPT-conjugate is a new state or the same one. Honest scope: a
   finite structural statement (the two mass-term types + their CPT/phase properties), not a
   prediction of the neutrino's nature or mass.

MANDATORY non-degeneracy: explicit rational `M_D, M_M, Theta, Q`; a Theta-invariant Majorana
witness and a Theta-non-invariant one; the nonzero commutator `[M_M, Q]` at an explicit entry; all
in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Explicit 4x4 matrices, REAL preferred (else explicit complex constants
for the conj -- keep it finite, no symbolic Complex analysis); ring/norm_num/decide/fin_cases; NO
Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean
(namespace NeutrinoDiracMajorana) + ARISTOTLE_SUMMARY.md.
