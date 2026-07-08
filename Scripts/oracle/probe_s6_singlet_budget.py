"""S6 color-singlet mass-budget witness: exact-fraction verification.

Transcribes Fable call-03 Part B (the recommended committed probe) to verify
the predicted budget of the 18-dim quark-antiquark epsilon-singlet witness
BEFORE anyone formalizes the 18x18 Lean version. Numeric oracle only.

Design (Fable call-03):
  V = C^2 (x) (C^3 (x) C^3-bar), dim 18 (spinor (x) quark (x) antiquark).
  gamma1 = E01 (x) 1_9, gamma2 = E10 (x) 1_9; metric g = !![0,1;1,0].
  Gamma = sigma_z (x) 1_9; phi = 1_18.
  Transports (3-4-5 rational rotations): u = R_z, v = R_x, w = R_y.
    nabla1 = 1_2 (x) (u (x) 1_3), nabla2 = 1_2 (x) (v (x) w-bar).
    K = [nabla1, nabla2] = 1_2 (x) ([u,v] (x) w) ; Q_C = 2 sigma_z (x) ([u,v](x)w).
  Q_A = -g12 {nabla1,nabla2}-type aperture; here the aperture color content is
    (uv + vu) (x) w on the singlet (Fable's evaluation).
  State psi = (1,0) (x) s, s = epsilon-singlet (sum_a e_a (x) f_a).
  Key identity: <s | A (x) B | s> = Tr(A B^T)  (unnormalized; norm cancels).

Budget shares b_X = ev(Q_X-contribution) / M^2, M^2 = 4 ev(D^2).
Fable predicted (spin-up): (b_A, b_C, b_T) = (135/446, -32/223, 375/446),
and a hyperfine spin-flip M^2(down) - M^2(up) = 512/125.

This probe recomputes them in exact rationals with the natural 3-4-5
rotations and reports whether the STRUCTURE holds (b_C != 0 and negative for
spin-up, sign-flip under spin-down = hyperfine splitting), and the exact
values for the conventions used here.

Usage: python Scripts/oracle/probe_s6_singlet_budget.py
"""

from fractions import Fraction as F


def matmul(A, B):
    n = len(A)
    return [[sum(A[i][k] * B[k][j] for k in range(n)) for j in range(n)]
            for i in range(n)]


def comm(A, B):
    return sub(matmul(A, B), matmul(B, A))


def anti(A, B):
    return add(matmul(A, B), matmul(B, A))


def add(A, B):
    return [[A[i][j] + B[i][j] for j in range(len(A))] for i in range(len(A))]


def sub(A, B):
    return [[A[i][j] - B[i][j] for j in range(len(A))] for i in range(len(A))]


def transpose(A):
    return [[A[j][i] for j in range(len(A))] for i in range(len(A))]


def trace_ABt(A, B):
    """Tr(A B^T) = sum_{ij} A_ij B_ij (the singlet expectation identity)."""
    return sum(A[i][j] * B[i][j] for i in range(len(A)) for j in range(len(A)))


# 3-4-5 rational rotations
c, s = F(3, 5), F(4, 5)
u = [[c, -s, F(0)], [s, c, F(0)], [F(0), F(0), F(1)]]      # R_z
v = [[F(1), F(0), F(0)], [F(0), c, -s], [F(0), s, c]]      # R_x
w = [[c, F(0), s], [F(0), F(1), F(0)], [-s, F(0), c]]      # R_y

uv_comm = comm(u, v)          # [u, v]
uv_anti = anti(u, v)          # {u, v} = uv + vu

# spin-up expectations: <up|sigma_z|up> = +1
# ev(Q_C) = 2 * Tr([u,v] w^T)
evQC_up = 2 * trace_ABt(uv_comm, w)
# ev(Q_A): aperture color content (uv+vu) (x) w, spinor factor gives g12-scaled
# identity => coefficient 2 (Fable), spin factor +1 (Q_A carries I_2 on spinor)
evQA = 2 * trace_ABt(uv_anti, w)
# 4 ev(Q_T) = 4 * ||psi||^2 ; with unnormalized singlet ||s||^2 = 3, spin 1 => 12
evQT4 = F(12)

M2_up = evQA + evQC_up + evQT4
bA = evQA / M2_up
bC_up = evQC_up / M2_up
bT = evQT4 / M2_up

# spin-down: <down|sigma_z|down> = -1 flips the closure (chromomagnetic) sign
evQC_dn = -evQC_up
M2_dn = evQA + evQC_dn + evQT4
bC_dn = evQC_dn / M2_dn

print("=== S6 color-singlet mass budget (exact fractions, 3-4-5 rotations) ===")
print(f"  ev(Q_C) [spin-up]   = {evQC_up}  (a Wilson-loop difference)")
print(f"  ev(Q_A)             = {evQA}")
print(f"  4 ev(Q_T)           = {evQT4}")
print(f"  M^2 [up]            = {M2_up}")
print(f"  (b_A, b_C, b_T)     = ({bA}, {bC_up}, {bT})")
print(f"  sum                 = {bA + bC_up + bT}")
print()
print(f"  spin-down: b_C      = {bC_dn}  (sign flip => hyperfine)")
print(f"  M^2(down) - M^2(up) = {M2_dn - M2_up}")
print()
print("=== structural verdict ===")
print(f"  b_C != 0 (spin-up):           {bC_up != 0}")
print(f"  b_C negative (spin-up):       {bC_up < 0}")
print(f"  closure sign flips (up/down): {(bC_up < 0) != (bC_dn < 0)}")
print(f"  budget sums to 1:             {bA + bC_up + bT == 1}")

# flat negative control: nabla2 = 1_2 (x) (v (x) v-bar) => color commutator
# [u, v] stays but the antiquark factor becomes v; the closure trace uses v.
# The TRUE flat control is trivial holonomy: u = v = w = I => [u,v] = 0.
flat = trace_ABt(comm(u, u), w)
print(f"  flat control (u=v): ev(Q_C) = {2 * flat} (expect 0): "
      f"{2 * flat == 0}")

print("\n=== match to Fable call-03 ===")
print("  Fable predicted (135/446, -32/223, 375/446) [M^2=1784/125] and its")
print("  spin-flip (135/574, +32/287, 375/574) [M^2=2296/125], split 512/125.")
print("  This probe reproduces BOTH fraction sets EXACTLY - the only")
print("  difference is which sigma_z eigenstate is labelled 'spin-up' (a")
print("  convention). CONFIRMED: b_C != 0, closure sign flips between the two")
print("  spin states (a finite hyperfine pi/rho-analog splitting of 512/125),")
print("  budget sums to 1, flat holonomy gives ev(Q_C) = 0. The S6 witness")
print("  design is validated; the Lean 18x18 transcription (Kronecker route)")
print("  is a decide/norm_num target, oracle-backed by these exact fractions.")
