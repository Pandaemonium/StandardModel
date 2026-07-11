# Proof job: exact sector-resolved window half-charge for the two-wall walk (free-theory phase observable)

Standalone Mathlib-only Lean 4 file. Target: kernel-checked exact
fractionalization -1/2 for the L=8 Pythagorean two-wall split-step walk.
This is the free-theory phase-sensitive observable the program needs: it
separates a sign-kink mass field from the constant field of EQUAL modulus
using only free filled-sea data. Every constant below was verified by
exact sympy arithmetic (Rational/QQ(i)); re-verify rather than trust, but
do not silently change any statement - report mismatches.

## The objects (all entries exact rationals / rational multiples of i)

Sites x in Fin 8, state index n = 2x + component, N = 16.
Coin at x: [[4/5, -(3/5) s(x) i], [-(3/5) s(x) i, 4/5]] with sign field
s = [+1,+1,+1,+1,-1,-1,-1,-1] (walls at bonds 3|4 and 7|0).
Shift S: component 0: x -> x+1 (mod 8); component 1: x -> x-1 (mod 8).
Walk W = S * C (16x16 over Complex, entries rational or rational*I).
Grading Gamma: block-diagonal, block at x = (4/5) sigma_y - s(x) (3/5) sigma_z
  = [[-s(x) 3/5, -4i/5], [4i/5, s(x) 3/5]].
K := (W - W^dagger) / (2i)  (16x16, exact rational Hermitian).
Window projector Pi_w: diagonal 0/1, sites {2,3,4,5} (both components).
Second window Pi_w': sites {6,7,0,1}.

Exact +1 eigenvectors (integer form, sympy-verified W v = v):
v0 = (32, 24i, 40, 60i, 68, 126i, 130, 255i, 257, 126i, 130, 60i, 68, 24i, 40, 0)
v1 = (12i, 16, 0, 20, -12i, 34, -30i, 65, -63i, 34, -30i, 20, -12i, 16, 0, 20)
Exact -1 eigenvectors (sympy-verified W v = -v):
u0 = (-32, -24i, 40, 60i, -68, -126i, 130, 255i, -257, -126i, 130, 60i, -68, -24i, 40, 0)
u1 = (-12i, -16, 0, 20, 12i, -34, -30i, 65, 63i, -34, -30i, 20, 12i, -16, 0, 20)
Gram matrix A^dag A for A = [v0 v1]: [[218450, -53550i], [53550i, 14450]]
(and the analogous computation for [u0 u1]).

## Theorem ladder (ranked; land as many as possible, in order)

T1 (grading): Gamma is Hermitian, Gamma^2 = 1, Gamma W Gamma = W^dagger,
   and Gamma K + K Gamma = 0. Pure finite rational arithmetic.
T2 (modes): W v0 = v0, W v1 = v1, W u0 = -u0, W u1 = -u1; v0, v1 linearly
   independent (e.g. via a nonzero 2x2 minor of A), same for u0, u1;
   K v = 0 for all four; rank K = 12 (equivalently dim ker K = 4, so the
   four vectors SPAN ker K - this makes the sector census complete).
T3 (window charge, rational projection form): define
   Q0win := trace (Gram^{-1} * (A^dag * Pi_w * A)) and prove Q0win = 1.
   Same for the -1 sector (Qpiwin = 1), and for the second window Pi_w'
   (both = 1). Docstring: this is trace(P_ker(W-1) Pi_w), the window
   density of the +1 sector, written sqrt-free via the projection formula
   P = A (A^dag A)^{-1} A^dag.
T4 (half-charge arithmetic): DeltaQ0 := -(Qpiwin)/2 = -1/2 and
   DeltaQpi := -(Q0win)/2 = -1/2. State as the sector-resolved defect
   charge via the chiral-pairing interface (see T5). If T5 does not land,
   keep T4 with an explicit docstring disclosure that the bridge from
   filled-sea trace to -(Qpi)/2 is the (numerically exact, symbolically
   verified) pairing identity proved only at level T5.
T5 (pairing lemma - the conceptual step, attempt seriously): for the
   Hermitian K with Gamma K Gamma = -K and any projector Pi commuting with
   Gamma (our windows are Gamma-closed since Gamma is block-diagonal per
   site): trace over the positive spectral subspace of K compressed to the
   window equals trace over the negative one; hence
   trace(P_{K>0} Pi) = (trace Pi - trace(P_{ker K} Pi)) / 2.
   Recommended route: Gamma restricts to a unitary bijection between
   positive and negative eigenspaces of K (K (Gamma psi) = -Gamma (K psi)).
   Mathlib: Matrix.IsHermitian.spectral_theorem / eigenspaces, or an
   abstract InnerProductSpace argument on EuclideanSpace C (Fin 16). If
   the full spectral route is too heavy, an acceptable weaker form: for
   every eigenvalue mu != 0 of K, Gamma maps the mu-eigenspace bijectively
   onto the (-mu)-eigenspace (dimension equality), plus the trace
   partition statement conditional on diagonalizability of K (which
   Mathlib gives for Hermitian).
T6 (constant-phase control): with V = blockdiag(e^{i phi/2}, e^{-i phi/2})
   at every site, prove V * W(0-field with uniform coin phase phi) * V^dag
   relation: precisely, the phi-coin walk W_phi (off-diagonals
   -(3/5) i e^{+-i phi}) satisfies W_phi = V W V^dag for all real phi.
   Consequence (state it): every window charge built from spectral data of
   W_phi equals that of W - the constant phase is exactly invisible.
   Complex.exp algebra; if fully general phi is awkward, a rational-point
   version (cos phi = 3/5, sin phi = 4/5 explicit) is an acceptable
   fixture fallback, clearly labeled.

## Style and discipline

- Mathlib only; namespace PhysicsSM.Draft.NullEdge.WindowHalfCharge.
- Explicit rational literals; Matrix (Fin 16) (Fin 16) Complex or a
  structure-preserving equivalent; the context file WallModeWitness.lean
  shows the house pattern for exact eigenvector facts on this exact walk
  (16x16 literal matrices, Finset sum expansion, norm_num closure).
- Axiom footprint target: propext, Classical.choice, Quot.sound only.
  Avoid native_decide; if you must use it for a finite check, isolate and
  document it (draft trust), and keep the headline theorems kernel-only.
- Do not weaken statements to pass; report exact blockers instead.
- Deliver one Lean file plus a short memo (what landed, what did not, and
  the exact value of every displayed constant you verified).

## Physics framing (for the memo, not the Lean file)

This is the walk-native Goldstone-Wilczek / Jackiw-Rebbi half-charge: the
kink binds one +1 and one -1 gap mode (both sectors engaged - the
timeframe-pair structure), the filled-sea window deficit is -1 with exact
sector split -1/2 + -1/2, and the sector-resolved charge is the
free-theory, gauge-invariant, pre-registered observable separating
equal-modulus fields. Numerical L=48 sweep shows the per-site decay factor
is exactly 1/2 (errors 2^-(w+1)); at L=8 with the symmetric window the
value is exactly -1/2 with zero finite-size deviation.
