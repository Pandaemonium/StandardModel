# Claude review: OpenDiamondCausalExhaustion (OD5 causal exhaustion)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-114446, item QCA-3PLUS1-001
- Source: `PhysicsSM/Draft/NullEdge/OpenDiamondCausalExhaustion.lean`
  (115 lines, 0 sorry), packet
  `CODEX_OD5_CAUSAL_EXHAUSTION_AUDIT_REQUEST_2026-07-13.md` (sha 88281f2f verified)
- Date: 2026-07-13
- Context: this is the OD5 gate I flagged in
  `CLAUDE_OPEN_DIAMOND_BOUNDARY_MODE_AUDIT_2026-07-13.md`; see the scope note.

## Verdict: ACCEPT

The theorem is correct, kernel-clean, non-vacuous, and honestly scoped: an exact
finite-time domain-of-dependence (causal-exhaustion) result for iterated matrix
updates. Two non-blocking strengthening recommendations (sections 2-3). No proof
or statement change required to bank.

## The five requested checks

### 1. Recursion orientation + exactly `regions.length - 1` updates - PASS

`evolveAlong A f (_ :: T :: tail) = A *ᵥ evolveAlong A f (T :: tail)`;
`evolveAlong A f [_] = f`; `evolveAlong A f [] = f`. So
`evolveAlong A f [S0,...,St]` applies `A` exactly `t = length - 1` times, peeling
from the HEAD (observation) and applying `A` on the way out, with the initial
data `f` consumed at the deep (final `St`) end. Matches the stated
observation->initial orientation. The induction (`nil` vacuous; `[S]` base =
`f=g` on `S`; `S::T::tail` step) is correct: `Finset.sum_congr` splits each
transition into `A i j = 0 = B i j` (both terms zero) and the nonzero branch
where `LocalAgreement` supplies `j in next` and `A i j = B i j`, then `ih` gives
equality of the deeper evolution at `j`. Sound.

### 2. Vacuity of hypothesis / witness - PASS, with a strengthening

- Hypothesis satisfiable: `singleton_causal_chain` proves
  `CausalChain 1 1 (fun _=>1) (fun _=>1) [univ, univ]` holds - the predicate is
  not empty.
- Conclusion non-vacuous: `singleton_exhaustion_witness` proves
  `evolveAlong 1 (fun _=>1) [univ,univ] 0 = 1` - a concrete NONZERO amplitude, so
  the theorem is not the empty statement.
- STRENGTHENING (non-blocking): the witness is degenerate for the CAUSAL content
  - it uses `A = B = 1` on a `univ` cone, so there is no "outside the cone" to
  differ on. It demonstrates a nonzero amplitude but not the independence the
  theorem is about. Recommend adding a witness with `A != B` OUTSIDE a nonempty
  PROPER cone but equal interior amplitude (e.g. `V = Fin 2`, chain
  `[{0}, {1}]`, `A` and `B` sharing row-0's transition to site 1 but differing
  in row 1), which concretely exhibits check 3 and guards against a future
  refactor silently strengthening `LocalAgreement` into global agreement.

### 3. Outside-cone independence (incl. different boundary spectra) - PASS

YES, the theorem genuinely permits arbitrary differences outside the backward
cone. Verified by inspecting `LocalAgreement A B inner next`:
`forall i in inner, forall j, (A i j != 0 or B i j != 0) -> j in next and
A i j = B i j`. This constrains ONLY transitions FEEDING an in-chain layer;
entries `A i j` with `i` in no layer, and all transitions leaving the cone, are
entirely UNCONSTRAINED. So `A` and `B` may differ arbitrarily off-cone -
different boundary blocks, different boundary SPECTRA - while the theorem forces
equality only on the head region `S0`. The hypotheses do NOT secretly force
`A = B` globally. This is genuine finite-speed-of-propagation / domain-of-
dependence content, not vacuity. (Concrete instance is constructible - see the
recommended witness in section 2.)

### 4. Prose does not imply continuum/Weyl/gap/physical-boundary - PASS

Explicit scope line (lines 17-20): "finite matrix algebra only. This is not a
Dirac continuum limit, a single-Weyl theorem, a boundary spectral-gap theorem, or
a statement that physical spacetime has a boundary. It proves that boundary
spectra cannot affect an observable before the declared causal cone reaches
them." That last sentence is EXACTLY the domain-of-dependence content the kernel
proves - accurate, not inflated. "Causal / cone" is used in the backward-layer
support sense, correct for a matrix propagation with the `LocalAgreement`
support condition.

### 5. Guards + trust expansion - PASS

Two `#print axioms` guards (`evolveAlong_eq_on_head`,
`singleton_exhaustion_witness`), both pinned to
`[propext, Classical.choice, Quot.sound]`. Independent replay
`lake env lean ... OpenDiamondCausalExhaustion.lean`: **EXITCODE=0** with fully
clean output (no `sorry` warning, no `#guard_msgs` mismatch) => both guards
matched the standard three. No `sorry` / `native_decide` / `axiom` / `admit`;
proofs use only kernel tactics (`induction`/`Finset.sum_congr`/`by_cases`/`tauto`/
`simp`/`rcases`), so no `ofReduceBool` / `trustCompiler`. Minor: the
satisfiability lemma `singleton_causal_chain` is not itself guarded; guarding it
would fully certify the non-vacuity of the HYPOTHESIS (currently only the
amplitude witness is pinned).

## Scope note (connect to the boundary-mode audit) - important, non-blocking

This module proves the FINITE-TIME domain-of-dependence half: off-cone boundary
data cannot affect an in-cone observable BEFORE the cone reaches it. That is a
necessary foundation, and it is correctly scoped as such. It does NOT establish
the ASYMPTOTIC interior-decoupling that my boundary-mode audit named the decisive
OD5-min gate: namely that as the diamond radius `R -> infinity`, the interior
amplitude CONVERGES to the single-species continuum propagator WHILE the boundary
0/pi mode weight decays out of the interior. Finite-time domain-of-dependence
(this theorem) and asymptotic boundary-mode decoupling (still open) are different
statements. Do not read "OD5 exhaustion landed" as "boundary modes decouple /
open-diamond route survives." OD5-exhaustion is the clean foundation; OD5-min
decoupling remains the make-or-break, and it must handle BOTH the 0 and pi
boundary sectors (Floquet rule).

## Narrowest defensible claim

For finite iterated updates `evolveAlong A f` on a finite site set: if two
matrices `A, B` agree on every nonzero transition feeding each successive
backward causal layer of a chosen region chain (`LocalAgreement` along the chain)
and the initial data agree on the final layer, then the evolved amplitudes agree
exactly on the observation (head) region - regardless of how `A, B` differ
off-cone (different boundary blocks / spectra). This is an exact finite-matrix
domain-of-dependence lemma; it is NOT a continuum limit, single-Weyl,
spectral-gap, boundary-existence, or asymptotic-decoupling theorem.
