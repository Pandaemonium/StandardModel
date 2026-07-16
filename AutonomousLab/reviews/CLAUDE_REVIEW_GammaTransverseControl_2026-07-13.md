# Claude review: GammaTransverseControl (gamma-coupled transverse control)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-184353, item QCA-3PLUS1-001
- Source: `.../87e8d4f4-.../GammaTransverseControl/Core.lean` (458, sha 68e5a93a
  MATCH), Mathlib-only self-contained.
- Date: 2026-07-13
- Context: this COMPLETES the `FiniteTransverseWeylLift` thread. That module was a
  SEPARABLE additive sum and I noted it "lacks the anticommuting gamma-matrix
  coupling of a domain-wall Dirac operator." This module adds exactly that
  coupling - and the honest outcome is the doubling.

## Verdict: APPROVE (integrate; wrap the bare `#print axioms` in `#guard_msgs`)

An exemplary, honestly-scoped finite control. The genuine anticommuting Clifford
coupling gives a real domain-wall `H^2` decomposition + complement gap, and the
chirality audit machine-checks that the kernel carries a PAIRED opposite-chirality
Dirac symbol with NET CHIRALITY ZERO - i.e. gamma coupling does not isolate a
single Weyl. No over-claiming. Integrate as the honest completion of the
transverse-lift no-go, after `#guard_msgs`-wrapping the guards.

## Requested checks (all pass)

### Exact Clifford relations - YES
`gamma1..4` (`sx (x) sx`, `sx (x) sy`, `sx (x) sz`, and the 4th generator);
`gamma_sq : gamma a * gamma a = 1`; all six pair anticommutators
(`gamma12/13/23/14/24/34_anticomm`) and the general `gamma_anticommute (a b)
(hab : a != b) : gamma a * gamma b + gamma b * gamma a = 0`, resting on the
Pauli anticommutators. Exact `{gamma_a, gamma_b} = 2 delta_ab`.

### H^2 decomposition - YES (the load-bearing anticommuting-coupling result)
`H_sq : H(k)^2 = (M*M) (x) 1 + (kx^2+ky^2+kz^2) • 1`. This holds BECAUSE the
`gamma4`-coupling anticommutes with the tangent (`gamma4_tangent_anticommute`),
so the cross terms `M (x) {gamma4, tangent} = 0` vanish, leaving
`M^2 (x) gamma4^2 + 1 (x) tangent^2 = M^2 (x) 1 + k^2 • 1`. This is precisely the
domain-wall structure the separable `FiniteTransverseWeylLift` lacked - the
anticommutation is what makes the square decompose.

### Complement gap - YES
`M_sq_structure : M*M = 5 • 1 - w wᵀ` (exact Cayley identity); `complement_gap`
(`M^2 = 5` on `w`-perp); `H_sq_complement_gap` (`H^2 = (5 + k^2)` on the
complement). Correctly scoped: "a quadratic identity, not a spectral
diagonalisation" (the docstring explicitly declines to diagonalise `M`, whose
spectrum is `{0, ±sqrt 5}`).

### Kernel restriction - YES
`kernel_restriction : H(k) *ᵥ embed e = embed (tangent k *ᵥ e)`. On the kernel
sector `w (x) Spin4` the `M (x) gamma4` part is annihilated (`M w = 0`), so `H`
acts as the tangential Dirac symbol `tangent = k·gamma`. Non-vacuous
(`exists_nonzero_complement`, embed of a nonzero spinor).

### Paired opposite-chirality tangent - YES (the honest headline)
`tangent = chir * weyl` with `chir = sx (x) 1` (`chir_sq = 1`) and `weyl = 1 (x)
(k·sigma)` (TWO copies of the single Weyl symbol; `weyl_sq = k^2 • 1`). `chir`
commutes with `weyl`, so the chirality projectors split `tangent` into `+weyl`
and `-weyl` sectors. Their momentum -> d-vector Jacobians are `JacPlus = I`
(`det = +1`) and `JacMinus = -I` (`det = -1`), and
`chirality_paired_not_isolated` machine-checks
`det JacPlus = 1  and  det JacMinus = -1  and  det JacPlus * det JacMinus < 0  and
det JacPlus + det JacMinus = 0`. Net chirality ZERO: the gamma-coupled kernel is a
PAIRED four-component massless Dirac symbol, NOT a single isolated Weyl.

## Over-claim modes - all clear

- Vacuity: none (`exists_nonzero_complement`; non-vacuous kernel restriction;
  explicit Jacobian witnesses).
- False shape: none - `H_sq` is the genuine anticommuting decomposition (not the
  separable sum), and the chirality audit is the real paired-Dirac structure.
- Hidden assumptions: none - "one fixed finite Hamiltonian matrix," honestly
  bounded ("NOT a discrete-time evolution, NOT a primitive-null walk, NOT a
  periodic Brillouin-zone construction, NOT an anomaly-inflow theorem").
- Overclaiming: none - the docstring states the negative result plainly ("does
  not isolate a single Weyl species"; "paired ... rather than one isolated
  Weyl"; "quadratic identity, not a spectral diagonalisation").

## Should it be integrated? - YES, with two hygiene fixes

Integrate: it is the honest completion of the transverse-domain-wall thread - the
first time the genuine anticommuting gamma-coupling is used, and it machine-checks
that the domain-wall kernel DOUBLES (net chirality 0). That is a valuable,
scoped no-go (the transverse route with real gamma-coupling cannot isolate one
Weyl), consistent with the recurring "doublers relocate/reappear" pattern.
Required at integration (not correctness):
1. **Wrap the bare `#print axioms` in `#guard_msgs (whitespace := lax) in`** - the
   19 end-of-file `#print axioms` are auditable but NOT build-enforced; pin them
   to `[propext, Classical.choice, Quot.sound]` for the flagship guard discipline.
2. Port the standalone `GammaTransverseControl` namespace into `PhysicsSM.Draft.
   NullEdge`, and reconcile `M`/`w` with the identical `FiniteTransverseWeylLift`
   definitions (reuse, do not re-copy the chain/kernel).
Minor: the lone `sorry` token is PROSE ("sorry-free"); recommend the spaced form.

## Theorem-level boundaries

Proved: the full Clifford algebra; the anticommuting `H^2 = M^2 (x) 1 + k^2 • 1`
decomposition; the exact complement mass gap `H^2 = 5 + k^2` on `w`-perp; the
kernel tangent restriction to the Dirac symbol; and the paired opposite-chirality
census `chirality_paired_not_isolated` (net chirality 0). NOT claimed: a single
Weyl species (explicitly refuted), a spectral diagonalisation of `M`, any
discrete-time / primitive-null / Brillouin-zone / winding / anomaly-inflow
statement, or a physical domain wall beyond this one finite matrix.

## Build/replay footprint

Independent `lake env lean` (Mathlib-only, self-contained): **EXITCODE=0**, no
`error:`, and ZERO bad-footprint tokens (`ofReduceBool` / `sorryAx` /
`trustCompiler` / `native_decide` - none). The bare `#print axioms` all report
`[propext, Classical.choice, Quot.sound]` (confirmed e.g.
`chirality_paired_not_isolated depends on axioms: [propext, Classical.choice,
Quot.sound]`). So the module is kernel-clean at the standard three and sorry-free
(the one `sorry` token is prose). Only cosmetic noise: `linter.unusedSimpArgs`
warnings (unused simp arguments at several proofs). The `#print axioms` are
auditable but NOT `#guard_msgs`-enforced - wrap them at integration.
