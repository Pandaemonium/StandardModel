"""T3a: the free-case S3<->S4 bridge. In the free (flat) case, is the carrier
mass operator = det P (the kinematic Plucker mass)?

Roadmap T3a / crux 0b(a). The full interacting bridge splits (the interacting
discrepancy is the Delta binding-defect candidate); the FREE case should be a
clean identity. This probe finds the cleanest provable statement.

Claim under test: for the bundle momentum `P = sum_i psi_i psi_i^dagger` (a 2x2
Hermitian PSD matrix, the S3 object), the free "mass operator" is
`P * adjugate(P) = det(P) . I` (the 2x2 adjugate identity), and `det P` is the
pairwise Plucker mass (already kernel-checked). So the free mass operator is a
scalar equal to the kinematic mass, and `min spec = det P` trivially. This is the
finite Clifford/Pauli mass-shell: the slash-square of the total momentum is the
invariant mass squared times the identity.

Numeric oracle only. Usage: python Scripts/oracle/probe_t3a_free_bridge.py
"""

import numpy as np


def wedge(psi, phi):
    return psi[0] * phi[1] - psi[1] * phi[0]


def adjugate2(P):
    """The 2x2 adjugate: adj([[a,b],[c,d]]) = [[d,-b],[-c,a]]."""
    return np.array([[P[1, 1], -P[0, 1]], [-P[1, 0], P[0, 0]]], dtype=complex)


PASS = "PASS"


def check(name, ok):
    print(f"  [{PASS if ok else 'FAIL'}] {name}")
    return ok


def main():
    print("=== T3a: free-case bridge (mass operator = det P) ===\n")
    rng = np.random.default_rng(7)
    spinors = [rng.standard_normal(2) + 1j * rng.standard_normal(2) for _ in range(4)]
    P = sum(np.outer(s, s.conj()) for s in spinors)   # bundle momentum (Hermitian PSD)

    detP = np.linalg.det(P).real
    pairwise = sum(abs(wedge(spinors[i], spinors[j])) ** 2
                   for i in range(len(spinors)) for j in range(i + 1, len(spinors)))
    massop = P @ adjugate2(P)                          # the free mass operator P.adj(P)

    ok1 = check("det P = pairwise Plucker mass (S3, kernel-checked)",
                np.isclose(detP, pairwise))
    ok2 = check("mass operator P.adj(P) = det(P) . I  (the free bridge)",
                np.allclose(massop, detP * np.eye(2)))
    # min spec of the mass operator (scalar) = det P = the kinematic mass
    minspec = np.linalg.eigvalsh((massop + massop.conj().T) / 2).min()
    ok3 = check("min spec(mass operator) = det P = the kinematic mass",
                np.isclose(minspec, detP))
    # massless control: a collinear (rank-1) bundle => det P = 0 => mass op = 0
    coll = [np.array([1, 1j], dtype=complex), np.array([2, 2j], dtype=complex)]
    Pc = sum(np.outer(s, s.conj()) for s in coll)
    ok4 = check("massless control: collinear => P.adj(P) = 0 (min spec 0)",
                np.allclose(Pc @ adjugate2(Pc), 0))

    print("\n=== VERDICT ===")
    if ok1 and ok2 and ok3 and ok4:
        print("  FREE BRIDGE CONFIRMED and CLEAN. The free-case S3<->S4 bridge is the")
        print("  2x2 adjugate/Clifford identity: the free carrier mass operator")
        print("  P.adj(P) equals det(P).I = (the kinematic Plucker mass).I, a scalar,")
        print("  so min spec = det P = S3's mass. This is an M-target (Mathlib")
        print("  `Matrix.mul_adjugate`: A * adjugate A = det A . 1), directly tying")
        print("  the operator mass to the kinematic mass in the free case. The")
        print("  interacting deviation is the Delta binding-defect (T3b).")
    else:
        print("  Mismatch - re-analyze.")


if __name__ == "__main__":
    main()
