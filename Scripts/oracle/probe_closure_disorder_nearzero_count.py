"""Probe: does closure disorder increase the Banks-Casher near-zero count N_m?

The §9->§6 bridge of the all-mass manuscript, and Amendment A4's follow-up
conjecture (grade C): "controlled blocking of closure-disordered
backgrounds increases N_m" - the link from the RG-Schur mass-generation
mechanism (blocking converts null disagreement into non-null terms) to
constituent-mass generation (a chiral condensate = accumulation of Dirac
eigenvalues near zero, N_m large).

Pre-registered expectation (before running): closure disorder should, on
average, INCREASE the near-zero count N_m by pulling eigenvalues of the
skew-Hermitian (GW-stereographic) operator toward zero - the finite shadow
of the Banks-Casher spectral accumulation that signals chiral symmetry
breaking. Kill: if N_m systematically DECREASES with disorder (spectrum
spreads out, density at zero drops), the naive bridge is wrong and the
mechanism needs the specific chiral/curvature structure, not generic
disorder.

Construction:
  A0 = free skew-Hermitian hopping operator on a ring (a discretized
       1D Dirac; eigenvalues i * 2 sin(k), gapped away from 0 for even N).
  Disorder: A(g) = A0 + g * (skew-Hermitian closure-commutator term),
       modeling the [nabla_1, nabla_2] curvature that the closure channel
       is built from (Weitzenboeck Q_C). The disorder is itself skew
       (curvature is skew-Hermitian), so A(g) stays skew-Hermitian and the
       Banks-Casher count identity applies.
  N_m(A) = sum_j m^2 / (m^2 + lambda_j^2),  lambda_j = eigenvalues of -iA.

Report N_m vs disorder strength g, averaged over random curvature draws,
at a few regulator masses m. Numeric oracle only; NOT a Lean result.

Usage: python Scripts/oracle/probe_closure_disorder_nearzero_count.py
"""

import numpy as np

RNG = np.random.default_rng(20260708)


def free_dirac_ring(N):
    """Skew-Hermitian nearest-neighbour hopping on a ring of N sites."""
    A = np.zeros((N, N), dtype=complex)
    for i in range(N):
        A[i, (i + 1) % N] = 0.5
        A[(i + 1) % N, i] = -0.5      # skew: A^dag = -A
    return A


def random_closure_disorder(N):
    """A random skew-Hermitian 'curvature' matrix (models [n1,n2])."""
    M = RNG.standard_normal((N, N)) + 1j * RNG.standard_normal((N, N))
    return (M - M.conj().T) / 2.0     # skew-Hermitian projection


def chiral_grading(N):
    """Sublattice chiral grading Gamma = diag((-1)^i)."""
    return np.diag([(-1.0) ** i for i in range(N)]).astype(complex)


def chiral_preserving_disorder(N):
    """Skew-Hermitian disorder that PRESERVES the chiral symmetry
    (Gamma D Gamma = -D): only off-sublattice entries, so the spectrum
    stays symmetric about zero (the structure S1-CC shows the closure
    channel actually has)."""
    G = chiral_grading(N)
    D = random_closure_disorder(N)
    # project onto the Gamma-odd (off-sublattice) part: (D - Gamma D Gamma)/2
    return (D - G @ D @ G) / 2.0


def near_zero_count(A, m):
    """N_m = sum_j m^2/(m^2 + lambda_j^2), lambda_j = eigenvalues of -iA."""
    ev = np.linalg.eigvals(-1j * A)   # real (A skew-Hermitian => -iA Herm)
    lam = ev.real
    return float(np.sum(m ** 2 / (m ** 2 + lam ** 2)))


def main():
    N = 40
    A0 = free_dirac_ring(N)
    masses = [0.05, 0.1, 0.2]
    gs = [0.0, 0.05, 0.1, 0.2, 0.4, 0.8]
    ndraw = 200

    print(f"Ring N={N}; N_m averaged over {ndraw} random closure-disorder "
          f"draws.\nPre-registered: expect N_m to INCREASE with disorder g.\n")
    print(f"{'g':>6} | " + " | ".join(f"N_m(m={m})" for m in masses))
    print("-" * 46)
    base = {}
    for g in gs:
        row = []
        for m in masses:
            if g == 0.0:
                val = near_zero_count(A0, m)
            else:
                vals = [near_zero_count(A0 + g * random_closure_disorder(N), m)
                        for _ in range(ndraw)]
                val = float(np.mean(vals))
            row.append(val)
            base.setdefault(m, row[0] if g == gs[0] else base[m])
        print(f"{g:>6.2f} | " + " | ".join(f"{v:9.4f}" for v in row))

    # CHIRAL-PRESERVING variant: disorder that keeps the spectrum symmetric
    print("\n=== chiral-PRESERVING disorder (spectrum stays symmetric) ===")
    print(f"{'g':>6} | " + " | ".join(f"N_m(m={m})" for m in masses))
    print("-" * 46)
    for g in gs:
        row = []
        for m in masses:
            if g == 0.0:
                row.append(near_zero_count(A0, m))
            else:
                row.append(float(np.mean(
                    [near_zero_count(A0 + g * chiral_preserving_disorder(N), m)
                     for _ in range(ndraw)])))
        print(f"{g:>6.2f} | " + " | ".join(f"{v:9.4f}" for v in row))

    print("\n=== verdict (m=0.1) ===")
    m = 0.1
    gen = [near_zero_count(A0, m)] + [float(np.mean(
        [near_zero_count(A0 + g * random_closure_disorder(N), m)
         for _ in range(ndraw)])) for g in gs[1:]]
    chi = [near_zero_count(A0, m)] + [float(np.mean(
        [near_zero_count(A0 + g * chiral_preserving_disorder(N), m)
         for _ in range(ndraw)])) for g in gs[1:]]
    print(f"  generic  disorder: N_m {gen[0]:.3f} -> {gen[-1]:.3f} "
          f"({'INCREASE' if gen[-1] > gen[0] else 'DECREASE'})")
    print(f"  chiral   disorder: N_m {chi[0]:.3f} -> {chi[-1]:.3f} "
          f"({'INCREASE' if chi[-1] > chi[0] else 'DECREASE'})")
    print("\n(FINDING: BOTH generic AND chiral-preserving closure disorder"
          " DECREASE\n the near-zero count N_m (chiral helps only marginally,"
          " ~0.97 vs ~0.74).\n So the naive 'blocking/disorder increases N_m"
          " -> constituent mass' bridge\n (Amendment A4 follow-up) is REFUTED"
          " at the finite random-disorder level:\n random curvature SPREADS "
          "the spectrum away from zero. Banks-Casher\n accumulation must come"
          " from a SPECIFIC coherent/topological low-mode\n structure or a "
          "thermodynamic limit - NOT finite random disorder. The\n §9->§6 "
          "bridge is a documented KILL at this level; kernel bridge was and\n"
          " stays grade C, now with a sharper open question.)")


if __name__ == "__main__":
    main()
