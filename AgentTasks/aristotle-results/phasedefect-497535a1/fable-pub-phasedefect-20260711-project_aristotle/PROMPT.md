# Proof job: exact 4x4 Pluecker phase-defect spectral theorem (free carrier)

Standalone Mathlib-only Lean 4 file, namespace
PhysicsSM.Draft.NullEdge.PlueckerPhaseDefectSpectrum. Target: KERNEL-ONLY
(standard three axioms; no native_decide - everything here is finite ring
algebra over Complex with symbolic parameters, so decide/norm_num/ring
should suffice). This is an external expert's proposed theorem; the core
identity was verified symbolically (sympy) before this submission,
INCLUDING the failure of the identity without the equal-modulus
hypothesis - that hypothesis is load-bearing and must appear explicitly.

## Objects (symbolic parameters, no fixtures needed)

zL zR : Complex; t : Real; w : Complex with |w| = 1 (edge half-phase;
replaces e^{i chi/2} so nothing transcendental appears).
B z : Matrix (Fin 2) (Fin 2) Complex := [[0, z], [conj z, 0]].
Sigma := [[1, 0], [0, -1]].
Edge coupling T := t * Sigma * diag(w, conj w)   (2x2).
H : Matrix (Fin 4) (Fin 4) Complex, block form
  [[B zL, T], [T^dagger, B zR]].
a := |zL|^2 + t^2  (as a real scalar; use zL * conj zL for |zL|^2).
Delta := zR - (conj w)^2 * zL   (the parallel-transported mismatch;
  (conj w)^2 = e^{-i chi}).

## Theorem ladder (ranked)

T1  Bz_sq : (B z) * (B z) = (z * conj z) . 1   (scalar matrix).
T2  sigma_anticomm : Sigma * B z = - (B z * Sigma).
T3  H_hermitian : H^dagger = H  (with |w| = 1 used where needed).
T4  phaseDefect_polynomial (MAIN): under hypothesis
      hmod : zL * conj zL = zR * conj zR,
    (H*H - a . 1) * (H*H - a . 1) = (t^2 * (Delta * conj Delta)) . 1.
    Every entry is polynomial in {zL, zR, conj zL, conj zR, t, w, conj w}
    with the relations w * conj w = 1 and hmod; a block-2x2 computation
    mirroring the verified derivation:
      diagonal blocks of H^2 - a: (B zL)^2 + T T^dag - a = 0 etc.;
      off-diagonal: t (B zL Sigma diag(w,conj w) + Sigma diag(w, conj w) B zR)
        = t * B_{w-transported mismatch} * (Sigma diag(w, conj w))-type
      then square and use T1.
T5  phaseDefect_needs_equal_moduli (CONTROL): a concrete counterexample
    showing T4's conclusion FAILS without hmod - e.g. zL = 1, zR = 2,
    t = 1, w = 1: exhibit an entry of the LHS-RHS difference that is
    nonzero. (Verified: the identity is false for general moduli.)
T6  spectrum consequence: from T4, for any eigenvalue-eigenvector pair
    H.mulVec v = mu . v with v <> 0:
      (mu^2 - a)^2 = t^2 * (Delta * conj Delta)   (as complex scalars),
    i.e. mu^2 = a + t*|Delta| or mu^2 = a - t*|Delta| (state via the
    squared form to avoid Real.sqrt; name gSq := a - t * Complex.abs Delta
    as the preregistered gap observable in a def + docstring).
T7  multiplicity balance: trace H^2 = (2*(zL*conj zL) + 2*(zR*conj zR)
    + 4*t^2) = 4*a under hmod; docstring: with T4 this forces the two
    squared-energy levels a +- t|Delta| to have equal total multiplicity
    2+2 when Delta <> 0 (prove the trace identity in Lean; the
    multiplicity sentence may stay in the docstring if eigen-multiplicity
    API is heavy).
T8  gap_zero_iff: a - t * Complex.abs Delta = 0 iff (t = Complex.abs zL
    and zR = - (conj w)^2 * zL), for t >= 0 (the AM-GM/Cauchy-Schwarz
    step: a - t|Delta| >= (m - t)^2 + t(2m - |Delta|) >= 0 with equality
    iff both vanish; |Delta| <= 2m from hmod and triangle inequality).
    If the full iff is heavy, land the two directions separately;
    do not weaken to one direction silently.
T9  common_phase_conjugacy: for unit alpha with beta^2 = alpha,
    V := blockdiag(diag(beta, conj beta), diag(beta, conj beta)) is
    unitary and V * H(zL, zR) * V^dagger = H(alpha*zL, alpha*zR)
    (common phase is exactly removable; the observable depends only on
    the transported RELATIVE phase).

## Physics framing (memo only)

This is the free-carrier one-particle avatar of "the Pluecker phase is
physical": two sites with EQUAL |z| but different transported phase have
different spectra, with preregistered gap observable gSq and exact
zero-mode locus t = m, zR = -e^{-i chi} zL (Jackiw-Rossi/GW-adjacent,
finite and self-contained). Complements the in-flight filled-sea window
half-charge (many-body level). Not a topological-protection statement -
say so.

## Discipline

Mathlib only; kernel-only proofs (ring, field_simp, norm_num,
Matrix.ext + fin_cases for entries); no sorry, no native_decide; explicit
hypotheses; report blockers honestly with partial landings. Deliver one
Lean file + short memo of what landed and every displayed identity you
verified.
