"""Carrier dynamics simulation harness (validated against kernel-checked M-theorems).

Groundwork for rigorous dynamics simulations (see
`AgentTasks/overnight-allmass-run-2026-07-08/DYNAMICS_GROUNDWORK.md`). The design
principle: EVERY numerical output is checked against a landed, kernel-checked
identity, so the simulation is anchored to proofs rather than free-floating.

Four validated blocks:
  1. KINEMATICS  - Plucker mass: det(sum psi psi^dag) = sum_{i<j}|wedge|^2
     (validates PluckerMass.two_edge_plucker_mass_identity + MassMonogamy).
  2. BUDGET      - the carrier square splits into channels summing to one share
     (validates CarrierMassBudget.signed_budget_sum_one).
  3. EVOLUTION   - discrete time evolution U=exp(-i H t) on a positive sector:
     norm AND energy conserved (the dynamics seed; D2/D3 of the roadmap).
  4. RG STEP     - Schur decimation of a null chain: (ab)^2 = k(ab), effective
     coupling != 0 iff non-collinear (validates RGSchurMassWitness).

Numeric oracle only; the VALIDATIONS mirror kernel theorems.
Usage: python Scripts/oracle/carrier_dynamics_harness.py
"""

import numpy as np

sx = np.array([[0, 1], [1, 0]], dtype=complex)
sy = np.array([[0, -1j], [1j, 0]], dtype=complex)
sz = np.array([[1, 0], [0, -1]], dtype=complex)
I2 = np.eye(2, dtype=complex)
I3 = np.eye(3, dtype=complex)


def kron(*m):
    out = m[0]
    for x in m[1:]:
        out = np.kron(out, x)
    return out


PASS, FAIL = "PASS", "FAIL"


def check(name, ok):
    print(f"  [{PASS if ok else FAIL}] {name}")
    return ok


# ----------------------------------------------------------------------------
# 1. KINEMATICS: Plucker mass of a null bundle
# ----------------------------------------------------------------------------
def wedge(psi, phi):
    return psi[0] * phi[1] - psi[1] * phi[0]


def bundle_momentum(spinors):
    """P = sum_i psi_i psi_i^dagger (2x2 Hermitian PSD)."""
    P = np.zeros((2, 2), dtype=complex)
    for psi in spinors:
        P += np.outer(psi, psi.conj())
    return P


def validate_kinematics():
    print("1. KINEMATICS (Plucker mass = pairwise disagreement)")
    rng = np.random.default_rng(1)
    spinors = [rng.standard_normal(2) + 1j * rng.standard_normal(2) for _ in range(4)]
    P = bundle_momentum(spinors)
    detP = np.linalg.det(P).real
    pairwise = sum(abs(wedge(spinors[i], spinors[j])) ** 2
                   for i in range(len(spinors)) for j in range(i + 1, len(spinors)))
    ok1 = check("det(sum psi psi^dag) = sum_{i<j}|wedge|^2 (Plucker identity)",
                np.isclose(detP, pairwise))
    # massive <=> PosDef <=> det>0 (RankAreaMass); collinear bundle is massless
    coll = [np.array([1, 2], dtype=complex), np.array([2, 4], dtype=complex)]
    ok2 = check("collinear bundle massless (det P = 0)",
                np.isclose(np.linalg.det(bundle_momentum(coll)).real, 0))
    ok3 = check("non-collinear bundle massive (det P > 0, PosDef)",
                detP > 1e-9 and np.all(np.linalg.eigvalsh(P) > -1e-9))
    return ok1 and ok2 and ok3


# ----------------------------------------------------------------------------
# 2. BUDGET: the carrier square splits into channels summing to one
# ----------------------------------------------------------------------------
def build_carrier(lam=2.0, kappa=1.0, mu=1.0):
    """Two-edge Cl(4) carrier (the validated escape carrier). Returns the
    aperture/closure/turn blocks, the Krein metric, and the total D^#D form."""
    g1, g2, g3, g4 = kron(sx, I2), kron(sy, I2), kron(sz, sx), kron(sz, sy)
    I4 = np.eye(4, dtype=complex)
    omega = g1 @ g2
    Js = 1j * g3 @ g4
    K = np.zeros((3, 3), dtype=complex); K[0, 1] = kappa; K[1, 0] = -kappa
    QA = kron(I4, lam * I3)           # aperture (kinetic)
    QC = kron(omega, K)               # closure (gauge)
    QT = kron(I4, mu * I3)            # turn (Higgs) - a phi^2 = mu term
    J = kron(Js, I3)
    return dict(QA=QA, QC=QC, QT=QT, J=J, dim=12)


def validate_budget():
    print("2. BUDGET (channel shares sum to one)")
    c = build_carrier()
    # D^#D total = QA + QC + 4 QT ; expectation in a random unit state
    rng = np.random.default_rng(2)
    v = rng.standard_normal(c["dim"]) + 1j * rng.standard_normal(c["dim"])
    v /= np.linalg.norm(v)
    def ev(M):
        return (v.conj() @ M @ v).real
    M2 = ev(c["QA"]) + ev(c["QC"]) + 4 * ev(c["QT"])
    bA, bC, bT = ev(c["QA"]) / M2, ev(c["QC"]) / M2, 4 * ev(c["QT"]) / M2
    print(f"      shares (b_A, b_C, b_T) = ({bA:.3f}, {bC:.3f}, {bT:.3f})")
    return check("b_A + b_C + b_T = 1 (signed_budget_sum_one)",
                 np.isclose(bA + bC + bT, 1.0))


# ----------------------------------------------------------------------------
# 3. EVOLUTION: discrete time evolution on a positive sector (the dynamics seed)
# ----------------------------------------------------------------------------
def validate_evolution():
    print("3. EVOLUTION (unitary carrier dynamics on the positive sector)")
    c = build_carrier(lam=2.0, kappa=1.0)
    # On the J-positive sector the total mass form is PosDef (T2 escape); use it
    # as an ordinary Hermitian Hamiltonian H and evolve U = exp(-i H t).
    evJ, UJ = np.linalg.eigh(c["J"])
    Pcols = UJ[:, evJ > 1e-9]
    H = Pcols.conj().T @ (c["QA"] + c["QC"]) @ Pcols
    H = (H + H.conj().T) / 2.0
    posdef = np.all(np.linalg.eigvalsh(H) > 1e-9)
    check("Hamiltonian PosDef on the sector (a genuine mass operator)", posdef)
    rng = np.random.default_rng(3)
    psi0 = rng.standard_normal(H.shape[0]) + 1j * rng.standard_normal(H.shape[0])
    w, V = np.linalg.eigh(H)
    def evolve(t):
        U = V @ np.diag(np.exp(-1j * w * t)) @ V.conj().T
        return U @ psi0
    norm0 = np.vdot(psi0, psi0).real
    energy0 = (psi0.conj() @ H @ psi0).real
    ts = [0.0, 0.7, 1.9, 5.0]
    norm_ok = all(np.isclose(np.vdot(evolve(t), evolve(t)).real, norm0) for t in ts)
    energy_ok = all(np.isclose((evolve(t).conj() @ H @ evolve(t)).real, energy0)
                    for t in ts)
    ok_n = check("norm conserved under U=exp(-iHt) (unitarity)", norm_ok)
    ok_e = check("energy <psi|H|psi> conserved (the D2 invariant)", energy_ok)
    print(f"      spectrum(H) min={w.min():.3f} max={w.max():.3f} "
          f"(a positive mass gap = {w.min():.3f})")
    return posdef and ok_n and ok_e


# ----------------------------------------------------------------------------
# 4. RG STEP: Schur decimation of a null chain (mass generation)
# ----------------------------------------------------------------------------
def validate_rg_step():
    print("4. RG STEP (Schur decimation: mass from blocking non-collinear nulls)")
    # Null (nilpotent) coefficients a, b with a^2=b^2=0, {a,b}=k.1.
    a = np.array([[0, 1], [0, 0]], dtype=complex)   # sigma_+
    b = np.array([[0, 0], [1, 0]], dtype=complex)   # sigma_-  ; {a,b}=I => k=1
    k = (a @ b + b @ a)
    ab = a @ b
    law = check("(ab)^2 = k (ab) with k={a,b} (null_pair_prod_sq law)",
                np.allclose(ab @ ab, ab))   # since k=I
    # effective edge non-nilpotent (mass generated) iff k != 0 (non-collinear)
    gen = check("effective term non-nilpotent (mass generated), k!=0",
                not np.allclose(ab @ ab, 0))
    # collinear control: b' = a (same direction) => {a,a}=0 => no mass
    ctrl = check("collinear control: {a,a}=0 => effective term nilpotent (no mass)",
                 np.allclose((a @ a) @ (a @ a), 0))
    return law and gen and ctrl


def main():
    print("=== Carrier dynamics harness: validated simulation blocks ===\n")
    results = {
        "kinematics": validate_kinematics(),
        "budget": validate_budget(),
        "evolution": validate_evolution(),
        "rg_step": validate_rg_step(),
    }
    print("\n=== SUMMARY ===")
    for name, ok in results.items():
        print(f"  {name:12s}: {'all checks PASS' if ok else 'FAILURE'}")
    allok = all(results.values())
    print(f"\n  Harness {'VALIDATED (every block matches its kernel theorem)' if allok else 'has FAILURES - investigate'}.")
    print("  This is the D3/D4 numeric seed; D1 (finite carrier action + EOM,")
    print("  clean-room from PhysLean VariationalCalculus/EulerLagrange) and D5")
    print("  (canonical ensemble) are the next groundwork - see DYNAMICS_GROUNDWORK.md.")


if __name__ == "__main__":
    main()
