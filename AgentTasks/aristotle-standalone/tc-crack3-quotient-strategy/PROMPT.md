# STRATEGY JOB (deliverable = a design memo in Markdown; NO Lean proof required)

## Who you are for this job

Act as a skeptical expert in indefinite inner product spaces (Krein/Pontryagin),
gauge-theory state-space constructions (Gupta-Bleuler, Kugo-Ojima/BRST), and Lean 4 /
Mathlib formalization design. You are advising a formalization program; your memo will
be turned into exact Lean statements, so precision about hypotheses and Mathlib API
names matters more than prose.

## Project context (you are blind to our repo; everything you need is here + 4 files)

We formalize, in Lean 4 + Mathlib (kernel-checked, axiom-guarded), a finite
"null-edge" Dirac-type operator on a finite 2-complex:

  D = sum_e c(alpha_e) nabla_e + Gamma phi

with c(alpha_e) null Clifford generators (c(alpha)^2 = 0), nabla_e edge transports,
Gamma a chirality involution, phi a potential. Kernel-checked so far (files included
in this package, read them for exact statements):

- CarrierKreinSquare.lean: the Weitzenbock-type square
  4 (star D) * D = Q_A^# + Q_C^# + 4 Q_T + 4 E_# for an arbitrary involutive
  antiautomorphism `star` (the "Krein square" - the star is NOT yet pinned to a
  fundamental symmetry there; that file's honesty caveat says so).
- CarrierFlatSectorPositivity.lean: on the flat chirality-positive sector
  ({psi : nabla_e psi = 0, Gamma psi = psi}), the form <D psi, Gamma (D psi)>
  equals <phi psi, phi psi> >= 0 (a conditional form identity), and the form
  kreinForm Gamma x y := <x, Gamma y> is Hermitian when Gamma is self-adjoint.
- CarrierPontryaginWitness.lean: an explicit model on C^4 where Gamma is a CERTIFIED
  fundamental symmetry (self-adjoint involution, inertia (2,2), Pontryagin kappa = 2)
  and the flat-sector mass form is strictly positive (= |c|^2 on a distinguished
  state; nonnegative on the full 2-dimensional flat chiral plane).
- CarrierIndexProtection.lean: finite McKean-Singer index protection
  (chiral index = graded dimension for rank-symmetric blocks; Hilbert- and
  Krein-self-adjoint block forms; a forced-massless-mode existence theorem).

## The open crux (the single question of this job)

CRACK 3 / "off-flat positivity": on which physically-motivated sector is the Krein
mass form x |-> <x, J (D^#D) x>-style data (or directly <D psi, J D psi> with
J = Gamma the fundamental symmetry) POSITIVE, beyond the flat sector already done?

A previous strategy result of yours (paraphrased; treat as trusted input): for a
J-self-adjoint operator on a finite Pontryagin space, invariant maximal nonnegative
subspaces EXIST but can be DEGENERATE - existence alone does not give a
positive-definite physical Hilbert sector; the right extra hypothesis
(definitizability? a J-orthonormal eigenbasis? something physical?) was left open.

## The proposed reroute (ratify, sharpen, or refute)

Stop searching for a positive SUBSPACE; build the physical QUOTIENT, exactly as
Gupta-Bleuler does for the electromagnetic field, but in FINITE dimensions where
everything is linear algebra:

  Rung 1 (constraint kernel): define a constraint subspace V' <= V
    (candidate selector: "retardedness" - forward/positive-frequency edge-transport
    data; see question (c) - possibly plus closure/Gauss constraints).
  Rung 2 (radical): N := V' cap (V')^perp_J, the radical of the Krein form
    restricted to V'. Finite-dimensional, computable.
  Rung 3 (quotient positivity - THE theorem): the induced nondegenerate form on
    V'/N is positive definite. Hopefully reducible slot-wise through the
    Weitzenbock decomposition (aperture slot: Gram positivity; turn slot: phi^2
    squares; closure slot: leading-order normalization).
  Rung 4 (naturality/exactness): the gauge-shift image (closure-mode directions)
    lies inside N - i.e. the quotient removes EXACTLY the gauge directions, and
    kappa counts what is removed.

## Questions (answer all; number your answers)

(a) RATIFY OR REFUTE the ladder. In finite dimensions, for J-self-adjoint D on a
    Pontryagin space Pi_kappa, under what minimal hypotheses is Rung 3 TRUE for
    V' := (your best candidate constraint kernel)? If it can be FALSE, give the
    sharpest finite counterexample SHAPE (dimensions, inertia, D block structure)
    and the minimal repair hypothesis. Compare explicitly with the definitizable
    route (Langer): is finite-dimensional definitizability automatic or not for
    our D, and does it shortcut the ladder?

(b) LEAN STATEMENT LADDER. Give exact Lean 4 statement skeletons (Mathlib current
    API; we are on a 2026 Mathlib pin) for: the restricted-form radical as a
    Submodule; the induced form on the quotient (Submodule.Quotient); its
    nondegeneracy by construction; the positivity statement. Name the exact
    Mathlib declarations to build on (e.g. LinearMap.BilinForm vs sesquilinear
    inner-product API, Submodule.orthogonalBilin or its current name, quotient
    module API, finrank lemmas). If Mathlib lacks the sesquilinear radical/quotient
    API, say so explicitly and propose the smallest self-contained definitions.

(c) CONSTRAINT SELECTOR. Our program's candidate: retardedness of edge transport
    (forward-cone support, x_e(k) >= 0 in the transport symbol; the discrete
    stably-causal condition). Is that the right V' to make Rung 4 an exactness
    statement, or is the correct finite Gupta-Bleuler V' the kernel of explicit
    Gauss/closure constraint operators (with retardedness playing the role of the
    positive-frequency SPLIT inside V' instead)? Be concrete about which object
    plays "annihilation part of the constraint" in finite dimensions, where there
    is no frequency integral.

(d) FIRST LEMMAS. The three highest-value first lemmas, with exact Lean
    statements, that (i) are provable in finite dimensions without new theory,
    (ii) survive even if Rung 3 needs a repair hypothesis, and (iii) would be
    reusable by the definitizable route too.

(e) ALTERNATIVES. Any strictly better route to off-flat positivity we are
    missing - e.g. finite-dimensional definitizable-operator theory directly
    (Langer/Bognar), Potapov-Ginzburg transforms, Riesz-projection onto
    nonnegative spectral subspaces (spectrum of a J-sa operator in finite dim),
    or a graded/supersymmetric argument using our index-protection file. Rank
    the top two against the quotient ladder on: mathematical risk, Mathlib
    formalization cost, and physical honesty (no smuggled positivity).

## Output format

Markdown memo, sections (a)-(e), each starting with a one-line verdict in bold.
Wherever you assert a Mathlib declaration exists, give its exact fully-qualified
name; wherever unsure, mark [NAME UNVERIFIED]. Flag any statement of ours you
believe is FALSE loudly and first.
