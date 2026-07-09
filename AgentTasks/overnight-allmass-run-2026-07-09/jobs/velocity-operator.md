# claude-velocity-operator — the Dirac velocity operator has eigenvalues exactly +-1 (always moving at c)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

The sharpest kernel form of "a fundamental fermion is always moving at the speed of
light" is: the DIRAC VELOCITY OPERATOR (dx_i/dt = alpha_i in the Heisenberg picture,
units c=1) has instantaneous-velocity eigenvalues EXACTLY +-1 -- never a value strictly
between. Prove it as finite matrix algebra. Use a REAL 4x4 representation to stay
rule-v3-clean (a Majorana-type choice), OR the standard complex Dirac matrices -- your
choice, but keep entries explicit and concrete.

## The objects (explicit 4x4 matrices)

Pick three explicit anticommuting alpha_1, alpha_2, alpha_3 (the Dirac velocity operators)
and beta (the mass/Dirac-beta matrix) satisfying the Dirac algebra:
alpha_i^2 = I, alpha_i alpha_j + alpha_j alpha_i = 0 (i!=j), beta^2 = I,
alpha_i beta + beta alpha_i = 0. (A clean real choice: alpha_i = sigma_x (x) s_i for a
real anticommuting triple s_i on the second factor, or any explicit real 4x4 set. If you
use the complex Dirac rep alpha_i = [[0, sigma_i],[sigma_i, 0]], that is fine -- entries are
constants, so decide/norm_num handle them.)

## Targets (all by decide/norm_num/ring on concrete matrices)

1. `alpha_sq_one`: alpha_i^2 = 1 for each i (so every eigenvalue lambda satisfies
   lambda^2 = 1, i.e. lambda = +-1 -- instantaneous speed is exactly c).
2. `alpha_traceless`: trace alpha_i = 0 (so the +1 and -1 eigenspaces have EQUAL
   dimension 2 each -- the velocity is genuinely +-1, both signs occur, not a trivial +1).
3. `velocity_spectrum` (payload): package as the spectral statement -- the eigenvalues of
   alpha_i are exactly {+1, -1}, each with multiplicity 2. State via: alpha_i^2 = 1
   AND trace = 0 AND alpha_i != 1 AND alpha_i != -1 (both eigenvalues genuinely occur).
   Exhibit an explicit +1-eigenvector and an explicit -1-eigenvector (nonzero) for alpha_1.
4. `massless_luminal` (honest tie): the mass term beta anticommutes with each alpha_i
   (alpha_i beta = - beta alpha_i), so it is the chirality-flipping coupling; with beta
   absent (m=0) the dynamics is diagonal in the velocity eigenbasis (pure +-c motion).
   State the anticommutation + that alpha_1 and beta share no common eigenvector (the mass
   genuinely mixes the +-c states).

Honest scope (put in the docstring + summary): this is the INSTANTANEOUS velocity operator of
a Dirac FERMION; its eigenvalues +-c say the fermion is always moving at c internally. The
observable DRIFT <alpha> = p/E is subluminal (a separate, landed fact); the reconciliation
(Zitterbewegung average) is a companion theorem. This does not cover massive bosons.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. Concrete 4x4 matrices; proofs ring/norm_num/decide/fin_cases;
prefer REAL entries (else explicit complex constants); NO symbolic Complex analysis, NO
Real.cos/sin/sqrt, NO nlinarith deg>=3. Build in-project under 3 min. Deliver
RequestProject/Main.lean (namespace DiracVelocityOperator) + ARISTOTLE_SUMMARY.md.
