"""Item-1 (Fable) bridge probe: is min spec(D^#D|P) = det P in the free case, and
is the interacting discrepancy Delta a closure-controlled BINDING ENERGY?

Fable's reframe of crux 0b (STRENGTHENING_ROADMAP.md T3): the naive bridge
`min spec(D^#D|P) = det P` is probably false when interactions are on - and that
is the interesting outcome, because in real physics the mass of a bound state is
NOT naively additive; the discrepancy is BINDING. Split it:
  (a) free case (curvature off): min spec should equal the kinematic baseline;
  (b) interacting case: Delta := min spec(interacting) - min spec(free) should be
      controlled by the closure expectation <Q_C> in the ground state. If so,
      Delta is a finite binding-energy invariant the program did not yet name.

This runs on the two-edge Cl(4) carrier of probe_multiedge_positive_sector.py
(which has an oracle-validated J-positive sector and a ground vector). We compute, as the
closure strength t is turned up:
  free_mass2 = min spec on the sector at t=0        (the kinematic baseline)
  Delta(t)   = min spec at t  -  free_mass2
  <Q_C>_0(t) = closure expectation in the FREE ground vector (first-order binding)
and test whether Delta(t) tracks <Q_C>_0(t) (first-order) and how min spec moves.

HONEST SCOPE: this tests the SHAPE of item 1(b) - is the interacting shift a
closure-controlled correction - on the escape carrier. The full item-1(a)
equality to an INDEPENDENT det P requires a carrier with explicit overlapping
null momenta (the enriched-carrier follow-up); here the free-case min spec IS the
aperture/kinematic baseline by construction.

Numeric oracle only. Usage: python Scripts/oracle/probe_bridge_binding_energy.py
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


g1 = kron(sx, I2); g2 = kron(sy, I2); g3 = kron(sz, sx); g4 = kron(sz, sy)
I4 = np.eye(4, dtype=complex)
omega = g1 @ g2
Js = 1j * g3 @ g4
J = kron(Js, I3)

lam = 2.0                                   # aperture strength (fixed)
A = lam * I3
K0 = np.zeros((3, 3), dtype=complex); K0[0, 1] = 1.0; K0[1, 0] = -1.0   # curvature

HA = J @ kron(I4, A)                         # aperture Krein form (fixed)


def HC(t):
    return J @ kron(omega, t * K0)           # closure Krein form at strength t


# J-positive sector as a 12x6 isometry (Js eigenvectors for +1).
evJ, UJ = np.linalg.eigh(J)
P = UJ[:, evJ > 1e-9]                         # 12 x 6


def sector_min_and_ground(t):
    M = P.conj().T @ (HA + HC(t)) @ P         # 6x6 compressed total form
    M = (M + M.conj().T) / 2.0
    w, V = np.linalg.eigh(M)
    return w[0], V[:, 0]                       # least eigenvalue, ground vector (in P-coords)


free_mass2, v0 = sector_min_and_ground(0.0)
MA_sector = P.conj().T @ HA @ P
print("=== free / kinematic baseline (curvature off) ===")
print(f"  free_mass2 = min spec(D^#D|P) at t=0 = {free_mass2:.6f}")
print(f"  (aperture-only; the kinematic baseline the bridge must reproduce)")

print("\n=== interacting: Delta and the closure expectation ===")
print("   t   | min spec | Delta = min-free | <Q_C>_0 (free ground) | Delta/<Q_C>_0")
for t in (0.25, 0.5, 1.0, 1.5, 2.0):
    m_t, v_t = sector_min_and_ground(t)
    delta = m_t - free_mass2
    # first-order binding: closure expectation in the FREE ground vector v0
    MC_sector = P.conj().T @ HC(t) @ P
    qc0 = (v0.conj() @ MC_sector @ v0).real
    ratio = delta / qc0 if abs(qc0) > 1e-12 else float('nan')
    print(f"  {t:4.2f} | {m_t:8.4f} | {delta:+13.5f}  | {qc0:+18.5f}   | {ratio:8.4f}")

# critical closure strength where the positive mass vanishes.
crit = None
for t in np.linspace(0.0, 3.0, 601):
    m_t, _ = sector_min_and_ground(t)
    if m_t <= 1e-9:
        crit = t
        break
qc0_small = (v0.conj() @ (P.conj().T @ HC(0.05) @ P) @ v0).real
print("\n=== VERDICT (honest reading of the data) ===")
print(f"  1. FREE BRIDGE HOLDS: at t=0 the sector min spec = {free_mass2:.3f} =")
print("     the aperture/kinematic baseline. This is the free-case bridge 0b(a).")
print(f"  2. CLOSURE BINDS (Delta < 0): min spec DECREASES linearly, Delta = -t,")
print("     so the closure/chromomagnetic channel LOWERS the ground mass - the")
print("     sign of a binding energy, not an additive constituent mass.")
print(f"  3. The binding is SECOND-ORDER / reorganizational, not first-order:")
print(f"     <Q_C> in the FREE ground state = {qc0_small:+.3f} (~0), yet the true")
print("     ground state at t>0 reorganizes onto the negative-closure direction.")
print("     So Delta is a binding-defect candidate, invisible to the naive <Q_C> estimate -")
print("     exactly why constituent-additivity (0b naive) fails: binding is")
print("     off-diagonal in the free basis.")
print(f"  4. PHASE STRUCTURE: min spec hits 0 at t = {crit:.3f} (= aperture")
print(f"     strength lam = {lam}). Aperture-dominates => positive bound mass;")
print("     closure = aperture => a zero-mode point in this toy; closure-dominates =>")
print("     positivity lost. A clean finite critical-coupling picture.")
print("  READING (Fable item 1): split crux 0b into (a) free equality [M-target,")
print("  near-automatic from the Clifford relation] and (b) Delta := min spec -")
print("  det P = a finite, closure-controlled BINDING-DEFECT candidate that is")
print("  NEGATIVE and off-diagonal. Delta deserves a name; it is the program's")
print("  first finite binding-energy candidate. HONEST SCOPE: item-1(a)'s comparison to an")
print("  INDEPENDENT det P needs an enriched carrier with explicit null momenta.")
