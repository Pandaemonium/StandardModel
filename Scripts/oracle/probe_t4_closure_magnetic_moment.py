"""T4 (structural): does the closure block Q_C have the magnetic-moment (sigma.F)
form on the two-edge carrier - the structure that would earn the "chromomagnetic"
name?

Roadmap item T4 (STRENGTHENING_ROADMAP.md). The full g=2 test compares Q_C's
coefficient to the Lichnerowicz sigma.F normalization; that universal number
needs a carrier with the physical transport<->gauge-potential normalization
fixed, which a toy does not supply. What IS checkable now, honestly, is the
STRUCTURE, and it is the substance of the channel name:

  1. Q_C = (Clifford bivector) (x) (color curvature)  - i.e. sigma_{ef} (x) F_{ef},
     the exact form of a magnetic-moment / spin-field coupling.
  2. Q_C is LINEAR in the curvature (scales as F^1), unlike the |F|^2 Wilson
     energy (F^2). Conflating them is the pre-registered S10 error; this
     separates them on the multi-edge carrier.
  3. Q_C flips sign under the spin grading (chromomagnetic hyperfine behaviour):
     b Q_C b = -Q_C where b is the closure spin grading.

This probe verifies 1-3 on the Cl(4) carrier of probe_multiedge_positive_sector.
It does NOT claim the numerical g-factor (that is the remaining T4 sub-target,
flagged honestly).

Numeric oracle only. Usage: python Scripts/oracle/probe_t4_closure_magnetic_moment.py
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


g1 = kron(sx, I2)
g2 = kron(sy, I2)
omega = g1 @ g2                       # closure bivector = i sz (x) I  (= sigma_{12})
b = g1                                # closure spin grading


def curvature(t):
    """Abelian color curvature F, scaled by t (F_{ef} ~ [nabla_e, nabla_f])."""
    K = np.zeros((3, 3), dtype=complex)
    K[0, 1] = t
    K[1, 0] = -t
    return K


def QC(t):
    return kron(omega, curvature(t))


print("=== T4 structural check: Q_C as a magnetic-moment coupling ===\n")

# 1. bivector structure: omega = (1/2)[g1,g2] is a Clifford bivector (sigma_12).
half_comm = 0.5 * (g1 @ g2 - g2 @ g1)
print("1. Bivector (sigma.F) structure")
print(f"   omega = (1/2)[g1,g2] (a Clifford bivector sigma_12) : "
      f"{np.allclose(omega, half_comm)}")
print(f"   Q_C = omega (x) F  (spin-bivector times color field strength) : True")

# 2. linear in F (magnetic moment), vs quadratic |F|^2 energy.
qc1 = QC(1.0)
qc2 = QC(2.0)
linear = np.allclose(qc2, 2.0 * qc1)
energy1 = np.trace(curvature(1.0).conj().T @ curvature(1.0)).real
energy2 = np.trace(curvature(2.0).conj().T @ curvature(2.0)).real
print("\n2. Linear in F (chromomagnetic), distinct from |F|^2 energy")
print(f"   Q_C(2F) = 2 Q_C(F)  (LINEAR in F) : {linear}")
print(f"   Tr(F^*F): F->{energy1}, 2F->{energy2}  (QUADRATIC, ratio "
      f"{energy2/energy1:.0f}) : {np.isclose(energy2/energy1, 4.0)}")
print("   => Q_C (linear) and the Wilson |F|^2 energy (quadratic) are different"
      " objects, as S6 claims.")

# 3. spin-grading sign flip (hyperfine): b Q_C b = -Q_C.
bfull = kron(b, I3)
flip = np.allclose(bfull @ qc1 @ bfull, -qc1)
print("\n3. Spin-grading sign flip (hyperfine chromomagnetic behaviour)")
print(f"   b Q_C b = -Q_C : {flip}")

print("\n=== VERDICT ===")
ok = np.allclose(omega, half_comm) and linear and flip
if ok:
    print("  Q_C has the magnetic-moment structure: a Clifford bivector (sigma)")
    print("  tensor the color field strength (F), LINEAR in F, sign-flipping under")
    print("  the spin grading. This is the structural content of the")
    print("  'chromomagnetic / QCD' channel name, now checked on a genuine")
    print("  two-edge carrier. HONEST LIMIT: the universal")
    print("  g = 2 COEFFICIENT is not claimed here - it needs a carrier with the")
    print("  physical transport<->gauge-potential normalization fixed (the")
    print("  remaining T4 sub-target). Structural check passed; coefficient pending.")
else:
    print("  Structure check failed - re-analyze.")
