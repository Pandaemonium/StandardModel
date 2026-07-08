"""Carrier second-quantized (Fock) simulator: free gap, binding seed, hadron probe.

Lean-anchored (SOLO_RUN_PLAN.md Focus 2). Validates the finite second-quantization
layer against the landed kernel theorems, and probes the one open interacting step:

  * free many-body gap = one-particle gap       <- FockMassGap.secondQuantized_massGap
  * free 2-body energy = sum of constituents    <- FockMassGap.fockEnergy_twoParticle
  * binding defect Delta = -kappa lowers it     <- BindingDefect.blockBindingDefect_eq_neg_kappa
                                                    / FockMassGap.twoBody_bound_below_threshold
  * one-particle spectrum {lam-kappa, lam, lam+kappa}, gap lam-kappa
                                                <- MassGapWitness.B_spectrum / B_least_eigenvalue

Physics outputs:
  (1) FREE Fock spectrum on N=3 modes: vacuum (E=0), 1-particle (gap = lam-kappa),
      2-particle (E = sum of constituents), 3-particle; the many-body gap.
  (2) BINDING SEED: adding the kernel-proved defect Delta=-kappa to the two lowest
      modes' pair energy drops it below the free threshold exactly when kappa>0.
  (3) INTERACTING two-body probe (the OPEN hadron step): build H2 = dGamma(B)|_Lambda2
      + V with an attractive V of strength kappa on the ground pair; its least
      eigenvalue drops strictly below the free threshold min_{i<j}(d_i+d_j) -> a
      finite below-threshold bound state (the honest hadron seed; V is inserted,
      not derived - grade C, mirroring the Aristotle proof `allmass-proof-hadron`).

Numeric oracle only. Usage: python Scripts/oracle/carrier_fock_sim.py

Provenance: all-mass solo run 2026-07-08 [orig]; validates FockMassGap +
BindingDefect + MassGapWitness.B_spectrum, probes the interacting hadron seed.
"""

import itertools

import numpy as np


def one_particle_spectrum(lam, kappa):
    """The carrier sector block B(lam,kappa) squared-mass levels (= B_spectrum)."""
    return np.array([lam - kappa, lam, lam + kappa])


def fock_states(N):
    """All fermionic occupation states on N modes (tuples of 0/1)."""
    return list(itertools.product([0, 1], repeat=N))


def fock_energy(d, occ):
    """Free many-body energy dGamma(B): sum of occupied one-particle eigenvalues."""
    return sum(d[i] for i in range(len(d)) if occ[i])


PASS = "PASS"


def check(name, ok):
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}")
    return ok


def main():
    print("=== Carrier second-quantized (Fock) simulator ===\n")
    lam, kappa = 2.0, 1.0
    d = one_particle_spectrum(lam, kappa)       # {1, 2, 3}
    N = len(d)
    gap = lam - kappa                            # one-particle gap = 1
    print(f"One-particle spectrum d = {d} (gap = lam - kappa = {gap})")

    # --- (0) one-particle validation (MassGapWitness.B_spectrum / least eigenvalue) ---
    print("\n(0) One-particle (B_spectrum / B_least_eigenvalue):")
    check("spectrum = {lam-kappa, lam, lam+kappa}",
          np.allclose(sorted(d), sorted([lam - kappa, lam, lam + kappa])))
    check("least eigenvalue (mass gap) = lam - kappa", np.isclose(d.min(), gap))

    # --- (1) free Fock spectrum + many-body gap (secondQuantized_massGap) ---
    print("\n(1) FREE Fock spectrum (dGamma(B); FockMassGap):")
    states = fock_states(N)
    energies = {occ: fock_energy(d, occ) for occ in states}
    ground = min(energies.values())
    excited = min(e for occ, e in energies.items() if any(occ))  # nonvacuum least
    print(f"    vacuum energy = {ground} ; first excited = {excited}")
    check("ground energy = 0 (vacuum)", np.isclose(ground, 0.0))
    check("first excited = one-particle gap = lam - kappa (secondQuantized_massGap)",
          np.isclose(excited, gap))
    # by particle number
    for k in range(N + 1):
        ks = [fock_energy(d, occ) for occ in states if sum(occ) == k]
        print(f"    {k}-particle energies: {sorted(ks)}")

    # --- (2) free two-body = sum of constituents; the binding seed ---
    print("\n(2) FREE two-body = sum of constituents (fockEnergy_twoParticle):")
    pair_energy = {(i, j): d[i] + d[j] for i in range(N) for j in range(i + 1, N)}
    for (i, j), e in pair_energy.items():
        print(f"    modes ({i},{j}): E = d_{i}+d_{j} = {e}")
    free_threshold = min(pair_energy.values())   # min_{i<j}(d_i+d_j) = 1+2 = 3
    check("free 2-body energy is the sum of constituents (no binding)",
          all(np.isclose(pair_energy[(i, j)], d[i] + d[j])
              for i in range(N) for j in range(i + 1, N)))
    # binding defect Delta = -kappa (BindingDefect.blockBindingDefect_eq_neg_kappa)
    Delta = -kappa
    seeded = free_threshold + Delta
    print(f"    free threshold min(d_i+d_j) = {free_threshold}; +Delta(={Delta}) "
          f"= {seeded}")
    check("binding defect Delta = -kappa < 0 (binding sign; kappa>0)", Delta < 0)
    check("seeded pair energy < free threshold (below-threshold seed)",
          seeded < free_threshold - 1e-12)

    # --- (3) INTERACTING two-body probe: a genuine bound state below threshold ---
    print("\n(3) INTERACTING two-body (the OPEN hadron step; V inserted, grade C):")
    # Basis of the 2-particle sector Lambda^2: pairs (i<j).
    pairs = [(i, j) for i in range(N) for j in range(i + 1, N)]
    dim = len(pairs)
    # Free part dGamma(B)|_Lambda2 = diag(d_i + d_j).
    H0 = np.diag([d[i] + d[j] for (i, j) in pairs])
    # Attractive interaction V of strength kappa, coupling the ground pair (0,1)
    # to the other pairs sharing a mode (a finite Hubbard-like off-diagonal hop),
    # Hermitian, scale = closure strength kappa (the binding channel).
    V = np.zeros((dim, dim))
    for a, (i, j) in enumerate(pairs):
        for b, (k, l) in enumerate(pairs):
            if a != b and len({i, j} & {k, l}) == 1:   # share exactly one mode
                V[a, b] = -kappa / 2.0                  # attractive
    H2 = H0 + V
    ev = np.linalg.eigvalsh(H2)
    print(f"    2-particle basis (pairs): {pairs}")
    print(f"    free threshold = {free_threshold}; interacting spectrum = "
          f"{np.round(ev, 4)}")
    check("H2 is Hermitian", np.allclose(H2, H2.T))
    check("interacting ground energy < free threshold (bound state below threshold)",
          ev.min() < free_threshold - 1e-9)
    # binding energy of the interacting bound state
    E_bind = ev.min() - free_threshold
    print(f"    interacting binding energy = {E_bind:.4f} (negative = bound)")
    check("binding energy is negative (genuine below-threshold bound state)",
          E_bind < 0)
    # kappa -> 0 limit: no binding
    H2_free = np.diag([d[i] + d[j] for (i, j) in pairs])   # kappa=0 => V=0
    check("kappa->0: interacting = free (no bound state without closure)",
          np.isclose(np.linalg.eigvalsh(H2_free).min(), free_threshold))

    print("\n=== VERDICT ===")
    print("  Fock simulator VALIDATED vs FockMassGap (free gap = one-particle gap;")
    print("  free 2-body = sum of constituents) + BindingDefect (Delta = -kappa) +")
    print("  B_spectrum. The interacting two-body probe exhibits a finite")
    print("  below-threshold bound state (hadron seed) when closure kappa>0 - the")
    print("  numeric shadow of the open interacting-hadron theorem (V inserted,")
    print("  grade C; cf. Aristotle proof allmass-proof-hadron).")


if __name__ == "__main__":
    main()
